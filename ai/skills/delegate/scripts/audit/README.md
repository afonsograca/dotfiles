# Audit of delegate jobs

Use these scripts to audit the Codex jobs of the last weeks.

1. Extract the calls and the runs:

       python3 extract.py --since 2026-09-20 --exclude <id of the audit session>

   - `claude_calls.jsonl`: each `codex exec` call that Claude Code made, with its flags, its result, and the failures that it found.
   - `codex_runs.jsonl`: each Codex exec run, with its model, sandbox, tool failures, duration, and tokens.
   - The default output folder is `/tmp/delegate-audit`. The default start date is 30 days ago.

2. Dump one Claude Code session as text, to read what occurred:

       python3 dump.py <session id or the start of it>

Do the checks again after a Codex CLI update. The sandbox facts in `references/codex.md` can change.
