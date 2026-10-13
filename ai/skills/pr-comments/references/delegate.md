# Work with a delegate

Read this file when the user names a delegate, for example `use /bash-codex` or `use fable agents`.

The delegate writes each fix. You continue to make the decisions:

- You give the verdicts.
- You review each diff.
- You write the report.

## Start the delegate

- A `/name` delegate is a skill. Load it with the Skill tool. Do what it tells you. If the Skill tool cannot start it, read its SKILL.md directly.
- A plain name, for example `use fable agents`, tells you which agent or model to start.

## Write the task

Send one task for each fix. Put these items in each task:

- The comment, your verdict and the applicable file paths.
- The worktree path. A delegate that runs alone works in your worktree, on your branch. Parallel delegates that change files each get their own worktree, as the delegate skill says.
- This rule, word for word: "Write a code comment only for context that a reader cannot get from the code. Write it in ASD-STE100 Simplified Technical English. Do not refer to an untracked file or to its contents. Do not change code that is not part of this fix."
- The project rules that apply to the fix, for example the test rules in `AGENTS.md`, `CLAUDE.md` and your memory.
- The done criteria: the check to run, and the result that you expect.

If two fixes change the same file, run their tasks one at a time. Parallel tasks on the same file make patches that overlap.

## Review each diff

The diff of the delegate is a draft. Do these steps for each diff:

1. Read all of the diff.
2. Run the reproduction against the diff.
3. Compare the style with the code near it.
4. Remove the changes that the fix does not need, for example a reformat, or a rewrite of a comment from `main`.

If the diff is wrong or too large, send the delegate a more precise task. Then review the new diff.

If the delegate cannot write to a path, apply its draft yourself. For example, a sandbox can block the path.

If you change the diff yourself, you become the author. If your change affects behavior, get a second review from a general-purpose agent.

## Challenge a rebuttal

For a rebuttal of a correctness claim, send the delegate the comment and your evidence. Use read-only mode. Tell the delegate to try to show that you are wrong.
