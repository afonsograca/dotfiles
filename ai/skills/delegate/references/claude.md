# Claude Code

Write the prompt to `/tmp/<job>.prompt.md`. Then run:

    (cd <dir> && claude -p --model <model> --effort <effort> --permission-mode auto < /tmp/<job>.prompt.md > /tmp/<job>.log 2>&1)

- With no prompt argument, `claude -p` reads the prompt from stdin. Use a prompt file, not an inline prompt: the Bash tool refuses some inline prompts, for example a prompt that contains the word "git".

- `--model`: `sonnet`, `opus`, `haiku`, `fable`, or a full model ID.
- `--effort`: `low`, `medium`, `high`, `xhigh`, or `max`.
- Use `--permission-mode auto`. Never use `bypassPermissions`.
- The job loads the CLAUDE.md, the rules, the hooks, and the skills of the checkout in `<dir>`.
- The log has only the final reply of the job.
