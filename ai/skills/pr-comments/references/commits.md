# Commits

Read this file before you change files for review comments.

## Where to work

- If the user gave a worktree path, work in that worktree.
- If the comments are for the checked-out branch, work in the current worktree.
- If the comments are for a different branch, do not switch branches in the worktree of the user. Do these steps:
  1. Run `git worktree list`.
  2. If a worktree has the branch checked out, work in that worktree.
  3. If no worktree has the branch, make a temporary worktree for it. Do not make a new branch:

     ```bash
     git worktree add /tmp/pr-comments-<branch-slug> <branch>
     ```

  4. At the end, remove the temporary worktree with `git worktree remove`.

Before the first change, write down the sha of the branch tip. Give this sha to the user in the report, so that the user can undo the changes. Do not make backup branches or backup refs. The tip sha, `ORIG_HEAD` and the reflog are enough.

## Fold or add a commit

Each commit on the branch must stay meaningful and atomic. Its subject must describe all of its diff.

**Fold** the fix into the commit that added the code when the fix corrects that commit. Examples:

- A bug in the code of the commit.
- A wrong name in the commit.
- A missing case of the change.
- A test of the change.

To find the commit, run `git blame` or `git log -L` on the lines. Then make a fixup commit:

```bash
git commit --fixup=<sha>
```

If the fix changes what the commit does, also change the message of the commit. To do this, write an `amend!` commit:

- The subject is `amend! ` and then the old subject.
- The body is the new full message.

```bash
git commit -m "amend! <old subject>" -m "<new subject>" -m "<new body>"
```

**Add a new commit** when the fix is a different concern. Examples:

- A move or an extraction of code.
- A new helper that other code also uses.
- A change to code that the branch did not add.
- A fix that makes the old commit too large for one purpose.

Use the commit style of the repository. Put the new commit at the tip, unless an earlier commit needs it.

Do not add an "address review comments" commit.

Do not use `--no-verify`. If a hook fails, fix the cause. If the cause is not in your change, stop and give the user the hook output.

## Squash

Rebase onto the merge base. Then the branch does not move onto a newer `main`:

```bash
GIT_SEQUENCE_EDITOR=: git rebase --autosquash "$(git merge-base HEAD origin/main)"
```

If the branch starts from a different branch, use that branch in place of `origin/main`. If the branch has a merge commit, do not rebase. Keep the fixup commits. Tell the user.

If a conflict occurs, resolve it. Then continue the rebase. Keep the intent of each side. Do not add new behavior. If you cannot resolve the conflict, or a permission rule stops the rebase, do these steps:

1. Run `git rebase --abort`.
2. Keep the fixup commits.
3. Give the user the rebase command.

After the rebase, run the checks again on the tip.

## Push

Do not push. Run `git ls-remote origin <branch>`. If the output shows the branch, the fold changed the history of a remote branch. Tell the user that the push needs `git push --force-with-lease`.

Run `git branch --contains <old tip>`. Each other branch in the output starts from the old history. Give its name. Tell the user that it needs a rebase onto the new tip.
