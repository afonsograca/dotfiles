---
name: linear-draft
description: >-
  Write or update a Linear issue draft (a title and a description) for a real
  problem outside the current change. Use when a review comment is deferred,
  when you find a problem outside the task, or when the user asks for an issue
  or a ticket. Not for implementing an issue (/do-work) or phasing a spec
  (/to-plan).
---

# Linear issue draft

A draft records a problem that this change does not fix. The reader is a person or an agent that did not see this session, the pull request or the review. Make the issue complete without them.

Do not create the issue. The user reads the draft and creates the issue. The Linear tools are read-only.

## Before you write

Each step below prevents a mistake that made a user reject earlier drafts.

1. **Show that the problem is real.** Reproduce it: run a test, a command or a query on the code. A claim from a reviewer, a delegate or a second agent is not evidence. If you cannot reproduce it, write what you read and what you could not examine under "Not confirmed". Do not write a draft for a claim that you did not examine.
2. **Make sure that no other work has it.** If the session has a plan, read all of its phases. If a phase does the fix, do not write a draft. Say "Planned in phase <n>". If the phase does the fix but has no criterion for it, give the criterion that the plan needs. Give the caller the entry that it needs in place of the draft, for example the reply for the review thread that says that a later phase does the fix. If the session has earlier drafts, compare with them. If one matches, update it (see "Update a draft").
3. **Search Linear.** If a Linear tool is available, search open issues with words from the title and the file path. If an issue matches, give its link and do not write a draft. Read the issue. If you found facts that it does not have, for example more locations, give them as a comment that the user can add to it. If no Linear tool is available, say so one time, before the first draft. Do not repeat it in each draft.
4. **Find all locations.** Search the full repository for the same pattern: all apps and packages, and also `scripts/`, `migrations/`, `evals/` and tests. Run `git fetch` and search `origin/main` and the current branch. A local `main` can be weeks old. Record the command and the count. A draft that names 4 files when 14 have the problem gives a wrong size.
5. **Estimate the size and the risk.** Count the files and the lines that the fix changes. Say what occurs if nobody fixes it, and how frequently. The user and the team use these facts to decide when to fix it, or if they fix it.

## Title

Use `Domain | Problem`, for example `Push | A late registration from an ended session takes the Device from the new user`.

- The title gives the problem, not the fix. "Push | Send the permission again on foreground" is a fix. "Push | The server keeps an old permission after the user changes it in settings" is the problem.
- Use the domain names of the code, for example the feature folder or the glossary term. If the repository has a `GLOSSARY.md`, use its terms. It can be in an ignored directory, for example `.local/docs/`.

## Description

Use this template. Keep "Problem" and "Done when", and put at least one item in "Done when". Remove each other section that has no content. Do not add sections, for example "Effect", "Possible fixes" or "Acceptance". The template already has a location for each of them.

```markdown
## Problem

<What is wrong, and the effect on the user or on the code. Link the code with a GitHub permalink.>

<The other locations that have the same problem, with the search command and the count. If you found none, say that you searched and where.>

## Evidence

<The source: the link to the review thread and its author, or the task where you found the problem.>

<The reproduction, the test or the output that shows the problem.>

## Proposed fix

<The fix that you recommend, and the other options if there are some.>

**Size:** <the number of files and lines>. **If not fixed:** <the effect, and how frequently it occurs>.

## Done when

- [ ] <A result that a person can see, for example "a test for X passes">

## Why deferred

<Why the fix is not in <PR link>, in one or two sentences. Remove this section if the issue does not come from a change.>

## Not confirmed

<What you could not examine, and where you looked.>
```

### Links

- Get the repository from `git remote get-url origin`. Take the pull request link from the conversation. Do not call `gh`: it is not logged in.
- For a permalink, use a commit that stays on the remote. If the code is on `main`, use the `main` sha. If the code is only on a branch, a rebase or a fold can change the sha. Give the path and the PR link.
- If you cannot get a link, write a placeholder such as `<PR link>`. List each placeholder after the draft, so that the user can replace it.
- Do not refer to an untracked file, for example a plan under `.local/`, or to its contents. The reader does not have it. Write the fact that you need in the issue.

## Output

Write `**Title**`, then the title in a fenced block of its own. Write `**Description**`, then the description in a fenced `markdown` block. Make each fence longer than all fences inside it, for example four or five backticks. The user can then copy the raw text.

If you write more than one draft, number them. If one issue blocks a different one, say so in "Problem" and give the order.

The caller of this skill, for example /pr-comments, has a count line. Count each draft in it as a deferred outcome, also when the draft is for one part of a comment or for a problem that you found yourself.

## Update a draft

A draft changes when a later round fixes a part of it, finds more evidence, or finds more locations.

1. Before the draft, write what changed, in a short list. Write one line for the title: "Title: no change" or the old title and the new title.
2. Print the full new title and the full new description. Do not tell the user how to edit the old draft, for example "remove the second paragraph". The user then must merge two texts.
3. Say: "If you created the issue from the old draft, edit that issue. Do not create a second issue."
4. If a fix makes all of the draft unnecessary, say: "Discard draft <n>. If you created the issue, close it."

## After the user creates the issue

When the user gives the link, replace each `<Linear link>` placeholder in the replies and drafts of this session with it.

## Style

Write in ASD-STE100 Simplified Technical English. Code identifiers and quoted output are exempt. Do not write words that give no fact, for example "I think", "probably" or "Good catch".
