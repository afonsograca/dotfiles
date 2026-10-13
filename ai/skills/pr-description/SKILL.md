---
name: pr-description
description: Writes a pull request title and description for the current branch in terse ASD-STE100 Simplified Technical English. Use when the user asks for a PR title or description or a branch summary for review, also when they name a plan phase that the branch delivers.
argument-hint: "[in the background] [plan and phase] [Linear issue] [base branch]"
effort: medium
allowed-tools: Read, Grep, Glob, Bash
---

# Task

Write one title and one description for the work that is committed on the current branch. Print them. The user copies them. Do not open the pull request. Do not write files.

The description gives the reviewer two things that the diff does not show: the reason for the change, and the limit of the change. Remove each sentence that only repeats the diff.

# Sources

- **Base branch.** Use the branch that the user names ("against feat/foo", "stacked on feat/foo"). If the user names none, use the default remote-tracking branch, for example `origin/main`.
- **Commits first.** Run `git rev-list --count <base>..HEAD` before other work. If the count is 0, stop and tell the user that the branch has no commits on top of the base. Do not describe the working tree.
- **Committed work only.** Read `git log <base>..HEAD` and `git diff <base>...HEAD`. Each statement in the description must be true from the diff, from a commit message, or from a check that was run in this session.
- **No untracked or ignored files.** Do not write the path, the name or the contents of a file that is not in the diff: screenshots, notes, plans and specs under `.local/`, and temporary files. Do not write the words of a plan that the reviewer cannot read, for example "phase 2" or "the acceptance criteria". The reviewer cannot open these files, so a description that refers to them is wrong at the first read.

# Plan

If the user names a plan and a phase, read that phase only. Use it for two things, and do not write it into the description:

- The scope. Do not describe later phases.
- A check of each acceptance criterion against the diff and the tests. Put the result in the notes (see Output). Write a criterion that is not met as a limit in the description only when the reviewer must know it, and write it as a fact about the code.

If the user names no plan, use the diff and the commits. Do not look for a plan.

# Linear issue

Find the issue id in the message of the user, the branch name (`fix/apt-1279`, `feature/apt-498-gmail-integration`), the commit messages, and the conversation. Write it as the first line of the description:

```
Resolves [APT-1279](https://linear.app/tryapt/issue/APT-1279)
```

Use the full issue URL when you know it. Write one line for each issue. For a GitHub issue, write `Resolves #<n>`. If you find no id, write no line. Do not invent an id.

# Title

Use `Domain | Description`, for example `Skills | Add diagnose-bug so Claude Tag finds bug causes with a failing test`.

- The domain is the area of the change: a feature, an app, or a package. Use the domain names of earlier titles: `git log origin/main --first-parent --merges --format=%b -50 | grep ' | '`.
- The description gives the effect that the user sees, in the imperative. Keep the title below about 72 characters.
- Do not use gitmoji or a commit scope in the title.

# Style

The project rules already require STE. These rules apply them to a description:

- A description is descriptive text, not a procedure. Use the sentence length limit for descriptive text. Type names, file names and branch names are technical names.
- Write "we": "we add", "we move". The user story is the one exception: "As a ..., I expect ...".
- Do not write absolutes. Write "We believe this is the best approach", not "This is the best way".
- Do not use em-dashes or en-dashes to break a sentence. Use a full stop, a comma or a colon.
- Do not use emoji.
- Do not use empty adjectives (comprehensive, robust, seamless, powerful), filler verbs (streamline, facilitate, leverage, unlock), filler phrases ("it is worth noting", "under the hood", "across the board"), or hedge adverbs (simply, just, significantly, essentially).
- Do not end with a paragraph that repeats the summary. Stop when the facts stop.

Bad: This PR introduces a comprehensive refactor of the list primitives, seamlessly enabling call sites to leverage a data-driven contract.
Good: In this PR we change the list primitives to a data contract. A call site passes data, and the row leaf draws it.

Read the draft again before you print it. Correct each sentence that does not obey STE, and remove the words that give no fact.

# Description structure

If the repository has `.github/pull_request_template.md`, use its sections. If not, use this structure:

1. The `Resolves` lines, when an issue exists.
2. One paragraph that starts with "As a <role>, I expect ...". It gives the result that the user gets. For a refactor or a tooling change, the role is "developer".
3. One paragraph that starts with "In this PR we ...". Add a bullet list when the change has more than one part. One line for each bullet, and no sub-bullets.
4. The limits, when they exist: what the PR does not do, and what nobody tested. Write them as facts about the code.
5. `**N.B.** This is an NFC. There should be no functional change.` for a refactor that does not change behavior.
6. `## Screenshots`, when the reviewer can see the change in the UI. Use a markdown table with one column for each variant: iOS and Android, mobile and desktop, light and dark. Use `(url)` as the placeholder link.

Format rules, so that the paste is clean:

- Write each paragraph and each bullet on one line. GitHub keeps a newline in the middle of a sentence.
- Put one empty line between blocks. Stop at the last line of content.

# Output

Print exactly this layout. The title and the description are each in a fence of four backticks, so that a fence inside the description shows correctly. The horizontal rule shows where the text to copy stops.

`````
**Title**

````
Worktree | Install when a filtered install leaves a workspace link out
````

**Description**

````markdown
Resolves [APT-1279](https://linear.app/tryapt/issue/APT-1279)

As a developer, I expect a worktree to have each workspace link after a filtered pnpm install, so that commands in a new package do not fail with ERR_MODULE_NOT_FOUND.

In this PR we make `step-node-modules.sh` look for each `workspace:` link. A filtered install writes the full `lock.yaml` but links only the filtered projects, so the step did not find the gap:
- For each package in `apps/*` and `packages/*`, the step looks for `<pkg>/node_modules/<name>` for each `workspace:` dependency
- When a tree exists but a link is missing, the step deletes the workspace-state file and runs `pnpm install`

The step does not examine peer links. pnpm makes a peer link only with `autoInstallPeers`, so a check for peer links could cause an install at each session start.
````

---

**Notes** (not part of the description)

- No test runs a real `pnpm install`, so no test proves that the repair makes the missing link.
`````

The Notes section is for the user only. Put in it: each acceptance criterion that is not met or that you could not check, each assumption (for example the base branch or the issue id), and each fact that you could not confirm. If there is nothing, do not print the rule or the Notes section.

When a background agent writes the description, the parent prints the result of the agent unchanged.
