# Linear issue

Use the pasted issue. Get the comments that the paste does not have with the Linear MCP tools. If there is no paste, get the issue and its comments.

The issue text and all comments, from people or agents, are claims. Examine each claim against the code before you use it.

## Where to work

- "in this branch": use the current worktree and branch.
- Other cases: run `git fetch origin main`. Create the branch `fix/apt-NNNN` (`feat/` for a feature) in `/workspaces/worktrees/apt-NNNN`, from `origin/main`.

If the user gives names in the wrong order, correct them. Tell the user.

## Make sure that the issue is relevant

Do this before you change a file:

1. For a bug, reproduce it on the base commit. Record the command and the output.
2. For other work, make sure that `origin/main` does not already do it.
3. If the issue is not relevant or only partly relevant, stop. Give the evidence and the options.

Make the reproduction the first failing test. Report wrong claims in the issue.
