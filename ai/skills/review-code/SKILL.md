---
name: review-code
description: Do a very strict maintainability review of abstraction quality, large files and spaghetti-condition growth. When the user gives a spec, also compare the branch with the spec. Use for a thermo-nuclear code quality review, a thermonuclear review, a deep code quality audit, or a very harsh maintainability review.
disable-model-invocation: true
---

# Code Quality Review

Use this skill for a very strict review of implementation quality, maintainability, abstraction quality and codebase health. The review has two axes:

- **Quality** — is the implementation well structured and easy to maintain?
- **Spec** — does the change do what the PRD or the plan asks for?

Your chat reply at the end is the saved report, word for word, not a summary (step 4).

All the judgement rules are in the `references/quality-rubric.md` file in the directory of this skill. The passes read that file. You read only the sections that step 4 names. Your task is the procedure below.

At the start, find the absolute path of the rubric file one time. The invocation context usually shows the load path of this skill. If it does not, search for `review-code/references/quality-rubric.md` in `~/.claude/skills/` and `.claude/skills/`. If you cannot find the file, stop and tell the user. Do not start a pass without the path. A pass cannot use a relative path, so give each pass the absolute path.

## 1. Set the target and the fixed point

**Target checkout.** The user can name a worktree or a different checkout, for example "the worktree `/workspaces/worktrees/apt-1279`, read-only". Then run each git command there with `git -C <path>`, and give that path to each pass. Read the repo rules from that checkout. Never edit a file there. If the user names no checkout, use the checkout that you run in.

**Fixed point.** Use the point that the user names: a SHA, a branch, a tag or `HEAD~5`. If the user says "this branch", or names no point, use `origin/main`. Do not ask.

Get the SHA of HEAD one time: `git rev-parse HEAD`. Use that SHA in each command, not the word `HEAD`. HEAD can move during the review. The SHA cannot move.

Set the base diff command one time: `git diff <point>...<sha>`. The three dots compare with the merge-base. Get the commits with `git log <point>..<sha> --oneline`. Step 3 makes both commands narrower for each slice.

Before you continue, make sure of these two conditions:

- `git rev-parse <point>` gives a SHA.
- The diff is not empty.

If a ref is bad or the diff is empty, stop here. Do not let the passes fail because of it.

Do not run `git fetch`. `origin/main` can be older than the remote. Name the point that you used in the report, so that the user can see it.

Run `git status --porcelain`. Some files can have changes that are not committed. These include unmerged files, and changed files that are not in the diff. The review target is the SHA, not the disk. Tell each pass to read these files with `git show <sha>:<path>`. Name these files in the report. In step 4, verify each hunk at the SHA, not on the disk.

**Earlier review.** Find the last report for this branch. It can be in this session, or in the newest `.local/reviews/<branch>-*.md` file in the checkout that you run in. Step 4 writes this file. In the file name, each `/` in the branch name changes to `-`.

- If that report has the same SHA, do not review again and do not ask. Write one line: HEAD did not move after the last review at `<sha>`. If files have changes that are not committed, add: commit them, then run the review again.
- If the SHA is different, do the full review below. Keep the earlier findings for step 3 and step 4.

## 2. Find the spec and the repo rules

**Spec.** Use a spec only when the user gives one. A spec is one of these:

- A path in the message of the user to a spec, a PRD, a plan or a phase of a plan. For example: `phase 1 of .local/docs/plans/foo-phases.md (spec: .local/docs/specs/foo.md)`. Read each file that the message names. If the message names a phase, the Spec axis examines only that phase.
- The text of a Linear issue description, in the message of the user or earlier in the session.

If the user gives no spec, do not do the Spec pass. Do not search for a spec, do not guess one from the session or from the branch name, and do not ask. A Linear ID alone, for example `apt-1279` in a branch name, is not a spec.

Use only local files. Do not call an issue tracker, and do not run `gh`.

**Repo rules.** Collect the files that tell how this repo writes code: `REPO.md`, `CLAUDE.md`, each `AGENTS.md` above a changed file, each `.agents/rules/*.md` file, and the `AGENT.md` of each feature that the diff changes. Also read each ADR that the spec, the commits or the diff names. Search for the ADR directory as `docs/adr/` at all depths. Include hidden parent directories in the search. If the target is a different checkout, also search the checkout that you run in. Git ignores `.local/`, so a worktree does not have the `.local/` files of the main checkout.

These rules usually **add** findings. A repo rule can also stop a finding, but only if it passes a strict test: the rule must name the specific pattern that the rubric flagged. A general rule stops nothing. A rule that only does not prohibit the pattern stops nothing. A rule that the diff adds or changes cannot stop a finding in the same diff. A user memory can stop a finding with the same test. Name the memory as the source. Apply the memory test in step 4, when you merge the reports, not in the slices. Also solve conflicts there: if one slice stops a pattern and a different slice reports it, apply the strict test yourself.

When a rule names the pattern, remove the finding. Write one line under `### Allowed by a repo rule` at the end of the axis: the pattern, the file and the rule. Write one line, not a finding. Then future reviews do not report an approved exception again, and the user can see what the rules stopped.

## 3. Slice the diff and start all the passes in parallel

Divide the diff into slices: one slice for each module, feature or layer. Each slice must be complete without the other slices. Put each changed file in exactly one slice. Use a maximum of 6 slices. If the diff is small, use one slice.

Then start all the passes below at the same time.

**Who runs the passes.** The user can name a delegation skill, for example `/bash-codex`, `/bash-claude` or `/bash-devin`. Then load that skill. Use the procedure of that skill and the settings of the user, for example the effort, for each pass. Use them also for each exploration or verification that you delegate. The passes only read. If the delegation skill has a sandbox setting, use read-only, for example `-s read-only` for Codex. Give each job the same brief that a pass gets below, with absolute paths. Run the jobs in the background, and wait for their notifications. Do not use `sleep` or `ScheduleWakeup` to wait.

If the user names no delegation skill, start each pass with the Agent tool. Start all of them in **one** message. Use `general-purpose` as the agent type. Keep that type also when the user names a model, because the type and the model are different settings. If the user names a model, for example "review with opus" or "use sonnet", give it as the `model` argument to each pass, so that you can compare the reports. If the user names no model, do not give a `model` argument, so that the passes use the session model. Never select a model yourself.

**One Quality pass for each slice.** Give each pass:

- A diff command for its slice only: `git diff <point>...<sha> -- <files>`. Make this command yourself. Do not give a pass the diff of the full branch and tell it to filter. The narrow command is the reason for the slices.
- The commit list for the same files: `git log <point>..<sha> --oneline -- <files>`.
- This instruction, with the absolute path: "Read `<absolute path to references/quality-rubric.md>`. It is your complete brief."
- The repo-rule files that apply to its slice, and the step 2 rule about when a repo rule stops a finding.
- The earlier findings in its files, if step 1 found an earlier review. Give each one with its ID and its **Done when** check. Tell the pass to use that check, and to report each earlier finding as fixed or still open. Also give the items of the earlier `### Dropped` and `### Allowed by a repo rule` lists in its files. Tell the pass not to report these items again, unless their code changed. Also tell it to review the full slice for new findings, as usual.
- No word limit and no limit on the number of findings.

**One Spec pass for the full diff**, only if step 2 found a spec. Do not slice this pass. You can see a missing requirement only when you look at the full change.

- The diff command, the commit list and the path to the spec.
- The earlier Spec findings with their **Done when** checks, and the earlier Spec `### Dropped` list, if step 1 found an earlier review. Give the same instructions as for a Quality pass.
- This instruction, with the absolute path: "Read `<absolute path to references/spec-brief.md>`. It is your complete brief."

**One check task.** In the same message as the passes, start one background task that runs the tests, the lint and the typecheck for the changed files in the target checkout. Use the commands of the repo. Do not use a command that writes a file in the target, for example a baseline update. Make the task print the exit code of each command, so that you do not have to run a command again to get its code. The passes cannot run these checks, because their sandbox blocks them.

While the passes run, do no other work. Do not read code, do not run commands, and do not use `sleep` to poll. You need the context space for step 4. Wait for the notifications of the passes and of the check task. When a pass is done, write one line: the pass, the number of its preliminary findings, and the passes that still run. For example: "The Codex Quality pass is done. It found 3 preliminary findings. The Codex Spec pass is still running." To get the number, count the finding titles in the output of the pass. This is the only command that you can run while you wait. Do not verify or summarize the findings yet. When all the passes and the check task are done, start step 4.

## 4. Verify, then report

Collect the reports. Then, in the main context:

- Merge the findings that are the same problem in different locations. Slices never share a file, so two slices cannot flag the same hunk. The real duplicates are one root cause that many slices report, and a Quality finding that the Spec pass also reports. Merge each group into one finding that names all the locations.
- Read the `## Finding Format`, `## Finding Count — No Floor, No Ceiling`, `## Output Expectations` and `## Approval Bar` sections of the rubric. Do not read other sections.
- Examine each finding in the real code before you print it. Each finding quotes a hunk. Read that hunk. Remove the findings that are not correct, and the findings that have no hunk to read. For a `Missing` Spec finding, search the files that it names.
- Make sure that each finding has all the fields of `## Finding Format`. If a field is missing or is not specific, write it yourself from the code. If you cannot write a remedy, remove the finding.
- For each Spec (b) item, search the session for a request from the user for that behaviour. If you find a request, remove the item.
- A behaviour bug that no spec line covers is a Quality P0 finding. Move it from the Spec axis to the Quality axis. Do not remove it because no spec line covers it. For a finding that comes from a probe or a test case, make sure that the real system can make the input. If it cannot, remove the finding.
- A requirement that only CI or production can show is not a Spec finding. Put it under `### Not verified`.
- Rank the remaining findings in each axis. Never merge the two axes, and never rank one axis against the other: a clean change can build the wrong feature. Then give the final IDs in the sequence of the rank: `Q1`, `Q2` and so on for Quality, and `S1`, `S2` and so on for Spec. In a re-review, an earlier finding that is still open keeps its earlier ID. New findings get the numbers after the highest earlier ID.

Write the report in this format. Use only these sections, in this sequence. Do not print a section that has "only if" when its condition is false. Do not add other sections, tables or notes.

````markdown
Quality: <verdict> — <n> findings. Spec: <verdict> — <n> findings.

- **Target:** <checkout>
- **Fixed point:** <point> (`<short sha>`, only if the point is not a SHA). No fetch.
- **SHA:** `<sha>`
- **Slices:** <one line for each slice: its name and its files>
- **Spec:** <the files and the phase, or "none">
- **Passes:** <who ran the passes, with the model or the effort>
- **Not committed:** <the files, or "none">

## Earlier findings

- Q1 — fixed. <The result of its Done when check.>
- S2 — still open.

## Quality

**Verdict: Changes requested.** Blocks: Q1, Q3. <One sentence: the Approval Bar items that these findings hit.>

### Q1. P0 — <title>

<all the fields of the Finding Format>

### Allowed by a repo rule

- <pattern> — <file> — <rule>

### Dropped

- <finding> — <reason>

## Spec

**Verdict: Fail.** Blocks: S1. <One sentence: the requirements that are missing, partial or wrong.>

### S1. Partial — <title>

<all the fields of the Finding Format>

### Not in the spec

- <behaviour> — <location>

### Allowed by a repo rule

### Dropped

## Checks

- `<command>` — <result>

### Not verified

- <check> — <reason>
````

The rules for each section:

- **Status line** — the same verdicts as the axes.
- **Earlier findings** — only if step 1 found an earlier review. Give each earlier finding its status: fixed, still open, or no longer applies. Use its **Done when** check to decide if it is fixed.
- **Verdict** — the first line under each axis heading. `Blocks` lists the IDs of the findings that cause the verdict, or `none`.
  - Quality: `Approve` or `Changes requested`. Apply the `## Approval Bar` of the rubric to the full branch, one time. A P0 always blocks. A finding that must be fixed before the merge always blocks. A finding that does not hit a bar item does not block, but you still print it.
  - Spec: `Fail` if one (a) or (c) finding remains, `Pass` if none remains, and `Skipped` if the user gave no spec. For `Skipped`, write the reason, for example `**Verdict: Skipped.** The user gave no spec.`, and print nothing more under `## Spec`.
- **Findings** — each finding in the format of `## Finding Format`, with all the fields.
- **Not in the spec** — only if the Spec pass found (b) items. The user must make sure of these items. They do not make the Spec verdict fail.
- **Allowed by a repo rule** — only if the axis has items.
- **Dropped** — only if you removed findings in this run. Write one line for each finding, with the reason. A merge or a new label is not a removal.
- **Checks** — each check that ran, with its command and its result.
- **Not verified** — only the checks that did not run, with the reason. Do not put a check that ran here.

Write the report in ASD-STE100 Simplified Technical English. Use short sentences and the active voice.

Save the report to `.local/reviews/<branch>-<short sha>.md` in the checkout that you run in. Get the short SHA with `git rev-parse --short <sha>`. Do this also when the target is a different checkout. If the directory does not exist, make it. The next review reads this file in step 1.

Then print the content of the saved file as your chat reply, word for word. Do not write a summary, and do not add text before it or after it. Do this also after a context compaction.
