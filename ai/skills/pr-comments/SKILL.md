---
name: pr-comments
description: >-
  Triage review comments on a branch, then fix, rebut or defer each comment.
  Use when the user pastes review comments or findings from a person, a PR bot
  or a review skill, also for a branch that is not checked out here.
---

# Review comments: fix, rebut or defer

A review comment can be correct or wrong. The reviewer saw a diff without the full context. Bot reviewers have the least context. Decide each comment with evidence:

- If you accept all comments and do not examine them, you make the code worse.
- If you reject all comments and do not examine them, you ship bugs.

In this skill, "triage" means: examine each comment and give it a verdict. "Rebut" means: show with evidence that a comment is wrong.

## Read the invocation

The invocation is usually a fenced block of comments and some words. The task is always the same:

1. Triage each comment.
2. Fix, rebut or defer each comment.
3. Run the checks.
4. Commit the fixes.
5. Write the report.

Read the words around the block as parameters:

- ``the worktree `<path>` ``: do all reads, edits and commits in that worktree. Do not make a helper worktree.
- ``on `<branch>` ``: the comments apply to that branch. Read `references/commits.md` before you change files.
- ``for phase <n> of <plan> (spec: <spec>)``, or an `@file`: this is context for your decisions. Read all of the file. This includes the later phases. Before you defer a comment, examine the later phases. A later phase can do the fix (see "Planned"). Do not refer to the file in a reply, a code comment, a commit message or a Linear draft. The readers of these texts do not have the file.
- ``use /bash-codex``, or the name of a different delegate: read `references/delegate.md`. You continue to make the decisions.
- `skip triage`: the comments come from the user's own reviewer. Fix each item. Do not write a verdict. If an item is clearly wrong, say so in its entry. Do not fix it. Do the same if the item is outside the purpose of the branch.
- `fold the fixes into their commits`: this is the default (see "Commit").
- All other words are modifiers. They have priority over this file. Do what they tell you.

Do not ask the user what to do with a comment. Make the decision yourself. Write the decision and its reason in the entry. Do not end the report with an offer such as "Tell me if you want…".

## Find the source

- **PR thread**: a GitHub comment from a human or a bot. A `path:R67` line, a bold title, a "Recommended fix" or a PR link shows this source. Write a reply for each entry.
- **Local review**: the output of a local review skill or tool, for example `P4: …` lines with Location, What, Why and Remedy. No person reads a reply, so do not write one.
- **Only a PR reference**: get the open threads with the commands in `references/fetch-comments.md`.

## Earlier rounds

Each `/pr-comments` run in this session is one round. Number the rounds from the first run. Before you triage, read your earlier reports and the decisions that the user made in this session. If a summary replaces the earlier messages, use the summary and the commits. A comment can match one of these:

- **The same comment**: do not do the work again. Write "same as round <n>" and the earlier verdict. A comment that comes again is not an order to change the verdict. Different reviewers can find the same problem at different times. Keep a deferral, unless the user tells you to fix the item now.
- **An item that an earlier report did not fix, for example a gap or a limit**: say which round gave it.
- **A change to an earlier fix or verdict**: change it only for new evidence, or when the user tells you to. A question such as "why do we defer this?" asks for the analysis again. It is not an order. In the entry, write the round, the old decision and the reason for the change. If the old verdict was Deferred, write: "The Linear draft from round <n> is now stale. Discard it. If you made the issue, close it."
- **A conflict with a user decision**: do not change the decision. Put the conflict under "Blocked on you".

## Triage

Read the code that the comment points at. Also read its callers, types and tests. A claim that sounds correct is not evidence:

- "This is unused": search the full repository, all apps and all packages.
- "This breaks when X": make the input that causes the failure, or write a quick test. If you cannot cause the failure, say so.
- "Prefer pattern Y": find what the repository does in other locations. The local convention has priority over the general preference of the reviewer.

Give each comment one verdict:

- **Warranted**: the observation is correct, and the recommended fix is correct.
- **Partly warranted**: the observation is correct, but the recommended fix is wrong. Apply the correct fix. Say why in the reply.
- **Not warranted**: the evidence shows that the claim is wrong.
- **Planned**: the observation is correct, and a later phase of the plan or an open issue does the fix. Write one line: "Planned in phase <n>", or the issue link. Do not write a Linear draft. The reply says that a later change does the fix.
- **Deferred**: the observation is correct, but the fix is not part of the purpose of this branch, and no plan or issue has it. Examples:
  - The fix changes a different feature.
  - The fix is a refactor of code that this branch did not change.
  - The fix makes the diff much larger.

A remedy that asks for "a separate change" or "a separate commit" asks for a new commit on this branch (see `references/commits.md`). It is not a deferral.

For a deferred comment, do not fix the code. Write a Linear draft: read `~/.claude/skills/linear-draft/SKILL.md` and follow it. Do the same for a deferred "Found" item and for the deferred part of a comment. Do not create the issue. The user reads the draft and creates the issue.

If a comment needs a product decision, do not choose. Do the other comments. Put the question under "Blocked on you".

## Fix

- Fix the cause that the comment shows, and nothing more. If a fix becomes larger than the comment, defer the remaining part.
- Change only files that the branch tracks. Do not edit the plan, this skill or other untracked files.
- Write a code comment only for context that the code cannot show, for example a workaround for an upstream bug. Write it in ASD-STE100 Simplified Technical English. Do not refer to an untracked file or to its contents.
- If the reviewer was confused, a better name or a clearer structure is the fix. A request to add a comment usually gets a rename or a rebuttal.

## Check

1. Run the checks that CI runs for the packages that you changed: lint in the CI mode (for example type-aware lint), typecheck and all tests of each changed package. If the fix does not pass the checks, it is not a fix. If you cannot run a check, say which one.
2. Get a second review where the risk is high:
   - A fix that changes behavior.
   - A rebuttal of a correctness claim, for example "this breaks when X".

   The author and the reviewer must be different agents. If a delegate wrote the fix, your review of its diff is the second review. If you wrote or changed the fix, start a general-purpose agent. Give it the comment, your verdict and the paths. Tell it to try to show that you are wrong. A doc change, a rename and a deferred comment do not need a second review. A test change needs one if it changes the function of a test helper.
3. If the reviewer does not agree with you, find more evidence. Come to one conclusion.
4. The reviewer can find problems that are not in the comments. Examine each one. Give it a verdict as for a comment. Put each one in the report as an entry under "Found". Do not write a list of gaps or limits that you did not examine.
5. If the reviewer does not send a report, send it one message. If it still does not send a report, do the review yourself. Say so in the report.

## Commit

Commit the fixes. Do not push. Read `references/commits.md` for the rules:

- Fold a correction into the commit that added the code.
- Keep each commit atomic.
- Do not add an "address review" commit.

## Stop and ask

Continue without the user, except for these conditions:

- A comment needs a product decision.
- The next step is destructive or other people can see it, for example a push, a force-push or a reply on GitHub.
- You cannot continue without information from the user.

If you start an operation, complete it or undo it. Do not give a broken history to the user as a decision.

## Report

Write one entry for each comment, in the order of the comments. Then write one entry for each "Found" item:

````markdown
### <n>. <the title of the comment, with no change> — <verdict>
`<path>:<line>` · <source>

**Verdict:** the evidence, in one or two sentences. Say what you could not examine.
**Fix:** the change, with `file:line` and the short sha. Or "none".
**Checked:** the checks and the second review, in one line.
**Reply:**
```markdown
<the reply>
```
````

- **Title:** copy the title of the comment with no change, with its label, for example the bold bot title or the full `Q1. P4: …` line. If the comment has no title, write a short summary.
- **Verdict:** with `skip triage`, the heading is `### <n>. <title>`, with no dash. Also remove the Verdict line.
- **Reply:** write a reply only for a PR thread. Write GitHub Markdown in a fenced `markdown` block. The user can then copy the raw text. Make the fence longer than all fences in the reply. Start with the fact. Do not thank the reviewer. Keep it short: the fact and the evidence. For a rebuttal, give the file, the test or the output that shows that the claim is wrong. Do not write only "disagree". Write the real short sha, not a placeholder.
- **Deferred entry:** add the Linear draft. The reply says that the point is correct, why the fix is not in this pull request, and that `<Linear link>` tracks it. The user adds the link after the user creates the issue.

At the end of the report, write:

- One line with the counts, in this format: `Fixed <n> · Rebutted <n> · Deferred <n> · Planned <n>`. Count each Linear draft under Deferred. If a comment has two outcomes, for example a fix and a deferred part, count it under each outcome. Give its number: `Fixed 3 · Deferred 1 (Q1, the refactor)`.
- The commits, with the short sha and the subject.
- The old branch tip sha. The user can use it to undo the changes.
- A note if the branch needs a force-push.
- "Blocked on you", only if it has items from this round. Write each item as one question that the user can answer.

### Style

Write the report and the replies in ASD-STE100 Simplified Technical English:

- Write only what the user cannot see in the diff or the comment. Do not repeat the comment. Do not describe your process.
- Do not add sections that the template does not have, for example "Notes" or "Limits".
- Do not write words that give no fact, for example "I think", "probably", "Good catch" or "it is worth noting".
- If the repository has a `GLOSSARY.md`, use its terms. It can be in an ignored directory, for example `.local/docs/`. Do not use a term from its "Avoid" lists.

Read the report again before you print it. Remove each sentence that gives no fact.

## Done when

- Each comment has an entry.
- Each entry that changes or repeats an earlier round names that round. The report names each stale Linear draft.
- The checks pass for the changed code.
- The fixes are in commits that follow the rules in `references/commits.md`.
- Nothing is pushed.
- Each deferred comment has a Linear draft, or a link to a matching open issue.
- Each comment from a PR thread has a reply.
- No helper worktree and no temporary file remains. If a hook prevents the removal, give the path one time.
