# Codex

Write the prompt to `/tmp/<job>.prompt.md`. Then run:

    (cd <dir> && codex exec -m <model> -c model_reasoning_effort=<effort> -s <read-only|workspace-write> -o /tmp/<job>.md - < /tmp/<job>.prompt.md > /tmp/<job>.log 2>&1)

- `-` reads the prompt from stdin. Use a prompt file, not an inline prompt: the Bash tool refuses some inline prompts, for example a prompt that contains the word "git".
- `exec` runs without interaction. Outside a git repo, add `--skip-git-repo-check`.
- `-m` and `-c model_reasoning_effort=` are optional. The defaults are in `~/.codex/config.toml`.
- If stdin is open, `codex exec` prints "Reading additional input from stdin..." and waits forever.
- `-o` writes only the final reply to `/tmp/<job>.md`. The log has the full session.
- Sandbox:
  - `read-only` to examine (probe a service, review code). `workspace-write` only to change files. Never use `--dangerously-bypass-approvals-and-sandbox`.
  - `read-only` cannot run tests: vitest cannot write to `/tmp`. For a review, use `read-only` and run the tests yourself.
  - Tell Codex to run tools with `node_modules/.bin/<tool>`, not with `pnpm`. In `workspace-write`, each `pnpm` command waits approximately 70 s for `registry.npmjs.org` because the sandbox has no network. Also, the pnpm store is read-only, so `pnpm` can fail with "unable to open database file". If the job must use `pnpm`, add the store directory (the parent of `pnpm store path`) to `writable_roots`.
  - `workspace-write` keeps `.agents/` read-only. Only when the job must edit it, add it to `writable_roots`.
  - `writable_roots` takes one list: `-c 'sandbox_workspace_write.writable_roots=["<path>","<path>"]'`.
  - `workspace-write` has no network. A connection to a local service (for example MongoDB on 127.0.0.1) fails with `EPERM`. Only when the job must reach a local service, add `-c sandbox_workspace_write.network_access=true`. This also opens the internet.
  - In a linked worktree (`git rev-parse --git-common-dir` is outside the checkout), the sandbox cannot write the git dir. Codex cannot run `git add`, `commit`, `checkout`, `mv`, or `stash`. Tell Codex to change only files.
  - `workspace-write` blocks some process spawns (`spawnSync ... EPERM`). Run a failed test yourself before you accept the failure.
- Write the prompt as short, direct orders. Codex does better with "Resize every PNG in ~/screenshots. Do not touch other folders. Report each file converted." than with long context or soft requests. Give the facts as a flat list, then the orders.
- Codex can start commands in parallel, also when the prompt says "in this order". If the order is important, write "Wait for each command to finish before you start the next one."
- For a job that changes files, put this line in the prompt: "Do not run `pnpm install`. Do not edit lockfiles."
- Auth error: tell the user to run `! codex login`.
