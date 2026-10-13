import argparse, json, glob, os, re, collections, datetime

ap = argparse.ArgumentParser(description="Extract Claude-side codex calls and Codex exec runs for an audit.")
ap.add_argument("--since", help="YYYY-MM-DD (default: 30 days ago)")
ap.add_argument("--out", default="/tmp/delegate-audit")
ap.add_argument("--exclude", action="append", default=[], help="Claude session id to skip, for example the audit session")
args = ap.parse_args()

CLAUDE = os.path.expanduser("~/.claude/projects")
CODEX = os.path.expanduser("~/.codex/sessions")
since = datetime.datetime.fromisoformat(args.since) if args.since else datetime.datetime.now() - datetime.timedelta(days=30)
SINCE = since.timestamp()
OUT = args.out
os.makedirs(OUT, exist_ok=True)
TRIGGER_SKILLS = {"bash-codex", "delegate"}
CODEX_RE = re.compile(r"(^|[;&|(\s])codex\s+(exec|e|review)\b")
FAIL = {
    "stdin_hang": "Reading additional input from stdin",
    "bwrap": r"bwrap|namespace",
    "eperm": r"EPERM|Operation not permitted",
    "apply_patch_fail": r"apply_patch.*(fail|error)|failed to apply",
    "auth": r"not logged in|401 Unauthorized|codex login",
    "rate_limit": r"rate limit|usage limit|429",
    "sandbox_denied": r"sandbox (denied|blocked)|blocked by sandbox|read-only file system",
    "pnpm_store": r"unable to open database file",
    "network": r"ENOTFOUND|EAI_AGAIN|network (is )?(disabled|unreachable)|Could not resolve host",
}


def text_of(c):
    if isinstance(c, str):
        return c
    if isinstance(c, list):
        return "\n".join(x.get("text", "") if isinstance(x, dict) else str(x) for x in c)
    return str(c)


def flags(cmd):
    m = re.search(r"\s-s\s+([\w-]+)|--sandbox[ =]([\w-]+)", cmd)
    return {
        "sandbox": (m.group(1) or m.group(2)) if m else None,
        "model": (re.search(r"\s(?:-m|--model)[ =]([\w.\-]+)", cmd) or [None, None])[1],
        "effort": (re.search(r"model_reasoning_effort=\"?(\w+)", cmd) or [None, None])[1],
        "stdin_closed": "< /dev/null" in cmd or "</dev/null" in cmd,
        "skip_git": "--skip-git-repo-check" in cmd,
        "out_last": bool(re.search(r"\s(-o|--output-last-message)\s", cmd)),
        "dangerous": "dangerously" in cmd,
        "apply_patch_note": "apply_patch" in cmd,
        "writable_roots": "writable_roots" in cmd,
        "redirect_log": bool(re.search(r">\s*/tmp/\S+", cmd)),
        "prompt_file": bool(re.search(r"\$\(cat |< *\S+\.(md|txt)\b(?! *2)", cmd)),
        "len": len(cmd),
    }


calls = []
for f in glob.glob(CLAUDE + "/**/*.jsonl", recursive=True):
    if any(x in f for x in args.exclude) or os.path.getmtime(f) < SINCE:
        continue
    try:
        lines = open(f, errors="replace").read().splitlines()
    except Exception:
        continue
    if not any("codex" in l for l in lines):
        continue
    uses, results, notes = {}, {}, {}
    trigger = []
    last_user = ""
    for i, l in enumerate(lines):
        try:
            e = json.loads(l)
        except Exception:
            continue
        msg = e.get("message") or {}
        content = msg.get("content")
        if e.get("type") == "user":
            t = text_of(content)
            if "<command-name>/bash-codex" in t:
                trigger.append(("slash", e.get("timestamp")))
            for m in re.finditer(r"<tool-use-id>(toolu_\w+)</tool-use-id>.*?<status>(\w+)</status>.*?<summary>(.*?)</summary>", t, re.S):
                notes[m.group(1)] = (m.group(2), m.group(3)[:200])
            if isinstance(content, list):
                for c in content:
                    if isinstance(c, dict) and c.get("type") == "tool_result":
                        results[c.get("tool_use_id")] = (bool(c.get("is_error")), text_of(c.get("content")))
            if isinstance(content, str) or (isinstance(content, list) and any(isinstance(c, dict) and c.get("type") == "text" for c in content)):
                if "<task-notification>" not in t and "tool_result" not in str(content)[:50]:
                    last_user = t[:300]
        if e.get("type") == "assistant" and isinstance(content, list):
            for c in content:
                if not isinstance(c, dict) or c.get("type") != "tool_use":
                    continue
                inp = c.get("input", {})
                if c.get("name") == "Skill" and inp.get("skill") in TRIGGER_SKILLS:
                    trigger.append(("model", e.get("timestamp")))
                if c.get("name") == "Bash" and CODEX_RE.search(inp.get("command", "")):
                    uses[c["id"]] = (e.get("timestamp"), inp, last_user)
    for tid, (ts, inp, lu) in uses.items():
        cmd = inp.get("command", "")
        err, out = results.get(tid, (None, ""))
        fails = [k for k, p in FAIL.items() if re.search(p, out, re.I)]
        calls.append({
            "file": f.replace(CLAUDE + "/", ""), "ts": ts, "tool_use_id": tid,
            "background": bool(inp.get("run_in_background")), "timeout": inp.get("timeout"),
            "flags": flags(cmd), "cmd_head": cmd[:1500], "last_user": lu,
            "result_error": err, "result_head": out[:400], "result_fail": fails,
            "denied": "denied" in out[:300].lower(),
            "notification": notes.get(tid),
            "triggers_in_file": trigger,
        })

with open(OUT + "/claude_calls.jsonl", "w") as fh:
    for c in sorted(calls, key=lambda c: c["ts"] or ""):
        fh.write(json.dumps(c) + "\n")

runs = []
for f in glob.glob(CODEX + "/**/*.jsonl", recursive=True):
    if os.path.getmtime(f) < SINCE:
        continue
    try:
        lines = open(f, errors="replace").read().splitlines()
        meta = json.loads(lines[0]).get("payload", {})
    except Exception:
        continue
    if meta.get("source") != "exec":
        continue
    r = {"file": f, "ts": meta.get("timestamp"), "cwd": meta.get("cwd"), "model": None, "effort": None,
         "sandbox": None, "prompt": "", "tools": 0, "tool_fail": collections.Counter(), "exit_nonzero": 0,
         "duration_s": None, "last_msg": None, "tokens": None, "aborted": False}
    for l in lines[1:]:
        try:
            e = json.loads(l)
        except Exception:
            continue
        p = e.get("payload", {})
        t = e.get("type")
        if t == "turn_context" and r["model"] is None:
            r["model"], r["effort"] = p.get("model"), p.get("effort")
            r["sandbox"] = (p.get("sandbox_policy") or {}).get("type")
        elif t == "response_item" and p.get("type") == "message" and p.get("role") == "user" and not r["prompt"]:
            txt = text_of(p.get("content"))
            if "<environment_context>" not in txt and "AGENTS.md" not in txt[:40]:
                r["prompt"] = txt[:3000]
        elif t == "response_item" and p.get("type") in ("custom_tool_call", "function_call"):
            r["tools"] += 1
        elif t == "response_item" and p.get("type") in ("custom_tool_call_output", "function_call_output"):
            o = text_of(p.get("output"))
            m = re.search(r"(?:Process exited with code|exit code:?)\s*(\d+)", o)
            if m and m.group(1) != "0":
                r["exit_nonzero"] += 1
            for k, pat in FAIL.items():
                if re.search(pat, o, re.I):
                    r["tool_fail"][k] += 1
        elif t == "event_msg" and p.get("type") == "task_complete":
            r["last_msg"] = (p.get("last_agent_message") or "")[:600]
            if p.get("started_at") and p.get("completed_at"):
                r["duration_s"] = p["completed_at"] - p["started_at"]
        elif t == "event_msg" and p.get("type") in ("turn_aborted", "error"):
            r["aborted"] = True
        elif t == "event_msg" and p.get("type") == "token_count":
            info = p.get("info") or {}
            tot = info.get("total_token_usage") or {}
            if tot:
                r["tokens"] = tot.get("total_tokens")
    if r["duration_s"] is None and r["ts"]:
        try:
            st = datetime.datetime.fromisoformat(r["ts"].replace("Z", "+00:00")).timestamp()
            r["duration_s"] = int(os.path.getmtime(f) - st)
        except Exception:
            pass
    r["tool_fail"] = dict(r["tool_fail"])
    runs.append(r)

with open(OUT + "/codex_runs.jsonl", "w") as fh:
    for r in sorted(runs, key=lambda r: r["ts"] or ""):
        fh.write(json.dumps(r) + "\n")
print(len(calls), "claude codex calls;", len(runs), "codex exec runs; output in", OUT)
