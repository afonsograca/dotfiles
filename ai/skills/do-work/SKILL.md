---
name: do-work
description: "Execute one unit of work end to end: a Linear issue, a phase of a plan, or a described task. Write tests first, implement, examine the result against the acceptance criteria, and commit. Use when the user asks you to implement a feature, fix a bug, or complete a plan phase or a Linear issue."
---

# Do Work

Do the work from the task to committed code. Stop only in these conditions:

- The reproduction shows that the task is not necessary. Tell the user why.
- The next action deletes data or rewrites shared history.
- You cannot continue without a decision from the user.

## Inputs

- **`APT-NNNN` or a Linear URL:** read [linear.md](linear.md).
- **A phase of a plan:** read only that phase in the plan and in the spec. Read each file one time. Do only that phase.
- **A task in words:** if it has no acceptance criteria, write them first.
- **Work for other agents** (for example `/bash-codex`): also read [delegate.md](delegate.md).

Before you start, run `git status`. If it shows staged or unstaged changes, tell the user. Do not commit them.

## Step 1: Find the scope

Find the modules, the tests, and the call sites that the change touches. Use the helpers and patterns that exist. Do not change code outside the task. Report problems outside the task. Do not examine them further.

## Step 2: Write tests first

Before the first test, invoke the `tdd` skill with the Skill tool. Obey it for the full task. Before you write a mock, read its `mocking.md`.

Do not stop to agree the seams with the user. Use the seams from the plan, the issue, or the reproduction. If there are none, choose them and report them.

Do not write tests for rendering, styles, gestures, or navigation. Move logic that needs a test into a hook or a function.

## Step 3: Do the checks

While you work, run only the tests that you changed and the package typecheck. Before you commit, run all the checks for the changed files. The repo rules give the commands, for example `.claude/rules/testing.md`. A cache hit is not a check.

Give each long command a timeout, for example `timeout 15m`. If a command gives no output for 5 minutes, stop it and report it. Before you wait for a background job, tell the user what it does and its timeout.

If a test fails that you did not touch, run it on the base commit. If it also fails there, report it. Do not repair it.

## Step 4: Examine your tests

1. For each new test, remove the production change. Make sure that the test fails. Then put the change back.
2. Examine the tests against the `tdd` skill.
3. Make sure that the main entry point has a test.
4. Repair each gap that would stop a merge. Report the gaps that you do not repair, and why.

## Step 5: Commit

- Read the full diff. Remove comments that the code already shows.
- Stage only the files of this task. Before each commit, make sure that `git diff --staged` shows only these files.
- Make one commit for each change that can work alone. Use the repo commit format.
- Put each later fix into its commit with `git commit --fixup=<sha>` and `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`.

## Step 6: Report

In the plan file, mark each criterion that a test proves. Write each manual-check result from the user into the plan file immediately.

In the final reply, give:

- The commits, the branch, and the worktree.
- A table of the criteria: met, open (unit tests only), or not met. Give the evidence.
- For each open criterion, a numbered procedure for the user. Make the temporary debug edits yourself. Do not commit them.
- The seams that you chose and the gaps that you did not repair.
- Problems outside the task.

Do not write "complete" while a criterion is open.
