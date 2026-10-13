# Delegation

You write the tests, you examine the results, and you commit. The delegates write the production code.

If the task changes only tests, do the work yourself. Tell the user.

## Backend

Use the backend that the user names in the request:

- **A skill** (for example "use /bash-codex" or "use /bash-devin"): invoke it. Obey its rules and its limits.
- **Claude agents with a model, an effort, or both** (for example "use Sonnet with high effort agents"): use the Agent tool with its `model` and `effort` parameters.

If the user does not name a backend, ask.

## Each job

- Make each job one vertical slice: one behavior and its failing test. Write the test before you start the job. Never tell a delegate to write tests.
- Write the test for the next slice after you examine the result of the last slice.
- Give the goal, the files, the tests, the test command, and these limits:
  - Make the tests pass. Do not change the tests. If a test is wrong, stop and report.
  - Do not commit. Do not edit lockfiles.
  - Obey the comment rules of the repo (`AGENTS.md`, `CLAUDE.md`, `.claude/rules/`). Copy them into the prompt.
- Run jobs in parallel only if they change different files. Give each parallel job a worktree, from a temporary commit that has the failing tests.
- Run jobs in the background. Wait for the notification. Do not use `sleep`.

## The result

- Read the full diff. Run the tests yourself.
- Apply the diffs one job at a time.
- Use `git worktree remove` and `git branch -d`. Do not use `rm -rf` or `git branch -D`.
