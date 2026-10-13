---
name: delegate
description: "Run a job in the Devin CLI, the Codex CLI, or `claude -p` as a Bash subprocess. Use when the user names Devin or Codex, or wants work or a review from a model that the Agent tool cannot run (SWE-2, SWE-1.7, Gemini, an OpenAI model). Not for work that you can do yourself, and not for questions about these models."
---

# Delegate to an agent CLI

Run the CLI with the Bash tool. The Agent tool cannot run these CLIs.

Do not delegate a task only because it is work on the machine. If the user does not ask for a CLI or for a model that only a CLI has, do the work yourself.

## Select the CLI

1. The user names a CLI, or starts this skill with `/bash-claude`, `/bash-codex`, or `/bash-devin`: use that CLI.
2. The user names only a model: use the CLI that has the model.
   - Claude models (`opus`, `sonnet`, `haiku`, `fable`), and the user did not ask for `claude -p`: do not use this skill. The Agent tool sets the model and the effort. Use `claude -p` only for a full model ID that the Agent tool does not accept.
   - OpenAI models (`gpt-*`): codex. Run `codex debug models < /dev/null` to see them.
   - Other models (for example SWE-2, SWE-1.7, Gemini): devin. Run `devin models list < /dev/null` to see them.
   - Devin also has Claude and OpenAI models. Use Devin for these models only when the user asks for Devin.
3. The user asks to delegate, but names no CLI and no model: ask the user which CLI to use. Recommend one.

Then read the reference file of that CLI. It gives the command, the model and effort flags, the permission flags, and the known problems:

- [references/claude.md](references/claude.md)
- [references/codex.md](references/codex.md)
- [references/devin.md](references/devin.md)

## Rules for all CLIs

- Delegate only work that needs an agent. If one `curl`, `grep`, or `ls` does the task, run it yourself. A job is slower and not better.
- Do a small edit yourself (less than approximately 10 lines, or text that the user will paste). The prompt, the wait, and the review take more time than the edit.
- Close stdin with `< /dev/null` or with a prompt file. Each CLI can wait for input forever.
- Write the output to files in `/tmp`. Give each job a unique name, for example `<cli>-$(date +%s%N)`, because other sessions can run a job with the same task at the same time.
- Start each job with its own Bash call and `run_in_background`. Wait for the notification. Do not detach the job with `&`. Do not use `sleep`, `pgrep`, a poll loop, or a wakeup.
- The job does not get your conversation. Put the goal, the files, the done criteria, and the limits in the prompt. Tell the job what to say when it finds nothing, so that an empty reply has only one meaning.
- The job does not get your memory or your user-level rules (for example the comment rules, or the test rules about mocks). A `claude -p` job loads only the rules of its checkout. Copy the applicable rules into the prompt word for word.
- Use the narrowest permission mode that lets the job do the task. Never use the mode that approves all tools. A tool call that needs approval cannot get it, and a refused call usually does not make the job fail. Look for refused calls in the output.
- Give each parallel job that changes files its own worktree, also when the jobs change different files. Do not edit a tree while a job runs in it. After you copy the results, remove the worktrees.
- If the user names a model that does not exist, use the nearest model. Tell the user.
- The CLIs run commands. They do not look at the screen. For a visual check, use a browser tool.
- The reply is a draft. Read the diff and do the checks yourself. If the reply is wrong, incomplete, or vague, do the work again yourself or run a new job with a better prompt. Do not ask the user first.
