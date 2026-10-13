# Devin

Write the prompt to `/tmp/<job>.prompt.md`. Then run:

    (cd <dir> && devin --model <model> --permission-mode <mode> --prompt-file /tmp/<job>.prompt.md -p < /dev/null > /tmp/<job>.log 2> /tmp/<job>.err)

- Use a prompt file, not an inline prompt: the Bash tool refuses some inline prompts, for example a prompt that contains the word "git".

- Put `-p` last, with no value, as in the command above. `-p` takes a value: if a flag comes between `-p` and an inline prompt, Devin reads the prompt as a path and stops with an error.
- `--model`: the effort is part of the model name, for example `claude-opus-5-5-high`, `gpt-6-sol-medium`, or `swe-2-high`. Run `devin models list < /dev/null` to get the names.
- `--permission-mode`:
  - `auto` (default): only read-only tools. Devin cannot run shell commands, not even `git log`.
  - `accept-edits`: also file edits in the workspace.
  - `smart`: a fast model also approves shell commands that it thinks are safe. Use this only when the user asks for it. If the job must run tests, use `accept-edits` and run the tests yourself after the job.
  - Never use `dangerous`.
- A refused tool call writes `warning: rejected a tool call that requires confirmation` to stderr. Devin then exits with 0 and often prints no reply. Always read the `.err` file. An empty `.log` file usually means a refused tool call.
- Print mode stops in a directory that Devin does not trust. Add `--respect-workspace-trust false` only for a directory that you made, for example a temporary directory.
- The `.log` file has only the final reply.
- Auth error: tell the user to run `! devin auth login`. `devin auth status` shows the account.
