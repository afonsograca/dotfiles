import json, sys, os


def text(c):
    if isinstance(c, str):
        return c
    if isinstance(c, list):
        return "\n".join(x.get("text", "") if isinstance(x, dict) else str(x) for x in c)
    return str(c)


sid = sys.argv[1]
path = next((os.path.join(r, f) for r, _, fs in os.walk(os.path.expanduser("~/.claude/projects")) for f in fs if f.startswith(sid) and f.endswith(".jsonl")), None)
out = []
for l in open(path, errors="replace"):
    e = json.loads(l)
    m = e.get("message") or {}
    ct = m.get("content")
    ts = (e.get("timestamp") or "")[11:19]
    if e.get("type") == "user":
        if isinstance(ct, list):
            for x in ct:
                if isinstance(x, dict) and x.get("type") == "tool_result":
                    out.append(f"[{ts}] RESULT: {text(x.get('content'))[:700]}")
                elif isinstance(x, dict) and x.get("type") == "text":
                    t = x["text"]
                    if "Base directory for this skill" in t:
                        t = t[:120] + " ...[skill text cut]"
                    out.append(f"[{ts}] USER: {t[:2500]}")
        else:
            t = text(ct)
            if "Base directory for this skill" in t:
                t = t[:120] + " ...[skill text cut]"
            out.append(f"[{ts}] USER: {t[:2500]}")
    elif e.get("type") == "assistant" and isinstance(ct, list):
        for x in ct:
            if x.get("type") == "text":
                out.append(f"[{ts}] ASSISTANT: {x['text'][:1500]}")
            elif x.get("type") == "tool_use":
                inp = x.get("input", {})
                s = inp.get("command") or json.dumps(inp)
                lim = 4000 if "codex" in s else 400
                bg = " (background)" if inp.get("run_in_background") else ""
                out.append(f"[{ts}] TOOL {x['name']}{bg}: {s[:lim]}")
print("\n".join(out))
