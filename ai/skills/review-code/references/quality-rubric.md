# Quality Rubric

You review a diff, or one slice of a diff. This file is your complete brief. Apply all of it.

## Goal

Find each change that makes the code more difficult to maintain. Then find the restructure that makes the code simpler. The behaviour must stay the same. Make the abstractions, the modularity, the length and the legibility better. Also find each behaviour bug that the diff adds (rule 9).

Look for large structural improvements, not only for local cleanup. Look for a "code judo" move: a restructure that uses the existing architecture better, so that whole branches, helpers, modes, conditionals or layers go away. Prefer the design that looks obvious after you see it. If a path removes complexity, push for that path. A path that only moves complexity to a different location is not sufficient. When a much simpler idea is possible, a cleaner version of the same complex idea is not sufficient. When the real problem is structural, do not give feedback about names.

"It works" and "the tests pass" are not reasons to approve. If a change works but makes the code more complex, it is a finding.

Before you decide, read each changed hunk and the code around it. Follow each changed function to its callers. When the diff adds a path next to an existing path, find the users of the existing path. Then examine what the new path does not do. Follow each finding until you can state its real cost.

When you find a fault, search your full slice for the same type of fault. Put all the locations into one finding. Do not keep the other locations for a later review.

Count the lines of each changed file at the fixed point and at the target: `git show <ref>:<path> | wc -l`. Count the test files too. Rule 5 needs the two numbers.

Only read. Do not run tests, lint, typecheck, or a command that writes a file. The orchestrator runs the checks.

## What to Look For

Each rule is a judgement, not a hard failure. The signals are examples. The list is not complete.

1. **Structure.** A refactor moves code, but the reader must keep the same number of concepts in mind. A module that was cohesive is now more coupled, has more state, or is more difficult to read. A refactor passes the tests, but makes the code less modular or less legible.
2. **Spaghetti growth.** New ad-hoc conditionals, special cases in many locations, or one-off branches in flows that are not related. One-off booleans, nullable modes or flags that make existing control flow more complex. Edge-case code in the middle of a function that already does much work. A "temporary" branch that will probably stay. Conditionals that repeat because a model or a helper is missing. This is a design problem, not a style problem, also when the code works.
3. **Direct code, not magic.** Behaviour that is brittle, ad-hoc or "magic". A generic mechanism that hides a simple assumption about the data shape. A thin wrapper, an identity abstraction or a pass-through helper: it adds indirection, but it does not make the code clearer. Speculative generality and surface that nothing uses.
4. **Types and boundaries.** Optionality, `unknown`, `any` or casts that are not necessary, where a clearer type boundary is possible. A loose ad-hoc object shape, where an explicit typed model or a shared contract is possible. A silent fallback that hides an unclear invariant: ask if the boundary must be explicit.
5. **File size.** The diff pushes a file from less than 1000 lines to more than 1000 lines. Test and spec files count. Ask if the code must be split first. Accept the size only if a strong structural reason exists and the file stays clearly organized.
6. **Canonical layer and helpers.** Feature logic in a shared path. Implementation details that an API shows to its callers. A new helper where the codebase already has a canonical utility. Copied logic where a helper is necessary. Logic in the wrong package, service or module.
7. **Orchestration and atomicity.** Independent work that runs in sequence for no good reason. Related updates that can stop half-applied. Flag these when the cleaner structure is obvious. Do not flag micro-optimizations.
8. **Fowler smells** (_Refactoring_, ch. 3). Label each one as possible: "possible Feature Envy", not "Feature Envy violation".
   - These two are structural. Rank them with the structural findings:
     - **Divergent Change**: one module changes for many reasons that are not related. Split it, so that each module changes for one reason.
     - **Shotgun Surgery**: one logical change makes edits in many files. Put the code that changes together into one module.
   - Rank these six below all structural findings. Never put one of them first:
     - **Mysterious Name**: rename it. If you cannot find a correct name, the design is not clear.
     - **Feature Envy**: a function uses the data of a different object more than its own data. Move the function to that data.
     - **Data Clumps**: the same fields or parameters always go together. Make a type for them.
     - **Primitive Obsession**: a string or a number represents a domain concept. Give the concept its own type. Rule 4 covers the part that affects a type boundary.
     - **Message Chains**: hide a long `a.b().c().d()` chain behind one method on the first object.
     - **Refused Bequest**: a subclass does not use most of what it inherits. Use composition.
9. **Behaviour bugs.** A correctness error, a race, lost or wrong data, or a security problem that the diff adds. Report it also when no spec line covers it. A finding that comes from a probe or a test case must use input that the real system can make: the input must pass the real validation, schemas and sync rules. If you cannot make such an input, do not report the finding.

## Preferred Remedies

- Remove a layer of indirection, a wrapper or a duplicate branch. Do not only make it cleaner.
- Change the state model or the ownership boundary, so that conditionals go away. Moving them to one location is not sufficient. Make the feature a natural extension of an existing abstraction.
- Change special-case logic into a simpler default flow with fewer exceptions.
- Extract a helper or a pure function. Split a large file into focused modules.
- Replace condition chains with a typed model or an explicit dispatcher. Make type boundaries explicit, so that the control flow becomes simpler.
- Keep orchestration and business logic apart.
- Move the logic behind a dedicated abstraction, or to the package, module or layer that owns the concept. Use the canonical helper again.
- Run independent work in parallel when this also makes the orchestration simpler. Put related updates into one atomic flow.

## Finding Count — No Floor, No Ceiling

The bar applies to each finding, not to the count. Report each finding that you can defend in a review. Do not report a finding that you cannot defend.

- Zero findings is a complete review. Then write "no findings". Never invent a finding to look thorough. An invented finding uses the time of the reader and hides the real findings.
- Twenty findings is also a complete review. Never cut the list to a "top 3", a "top 10" or a round number.
- If you review one slice, your slice can have no findings. Do not compete with the other slices.

The strictness of this rubric is in the bar for each finding, not in the count.

## Finding Format

Write each finding in this format. The orchestrator copies the format into the report, so that each finding has the same fields. Do not remove a field, and do not add a field.

````markdown
### Q1. P3 — The 410 body is parsed two times, by two owners

**Location:** `packages/app/hooks/use-authed-fetch.ts:54-68`, `packages/app/hooks/use-authed-fetch.shared.ts:52-60`

```ts
<the quoted hunk>
```

**What:** One sentence that names the problem.
**Why it matters:** The cost, in a maximum of two sentences.
**Remedy:** The specific change, in a maximum of two sentences.
**Done when:** One sentence that names the check that shows that the fix is complete.
````

The rules for each field:

- **Title** — the ID, the label and the problem in a few words. The ID is `Q` for a Quality finding and `S` for a Spec finding, then a number. Use your own numbers. The orchestrator gives the final IDs.
- **Label** — for a Quality finding, one label from `## Output Expectations`. Use the primary category: the lowest number that applies. For a Spec finding, one of `Missing`, `Partial` or `Wrong`.
- **Spec** — only for a Spec finding. Put this line before the Location. Quote the line of the spec that the finding is about: `**Spec:** > <quoted line> (<file or phase>)`.
- **Location** — each `path:lines`. Then quote the hunk. The orchestrator cannot verify a finding that has no quoted code, so it removes that finding. There is one exception: for a `Missing` Spec finding, write `no code`, and name the files where you searched.
- **What** — one sentence that names the problem. Do not repeat the code in words.
- **Why it matters** — for a P0 finding, the effect on the user or on the data. For a different Quality finding, the maintenance cost. For a Spec finding, the effect on the requirement or on the user. Use a maximum of two sentences. Do not repeat the What.
- **Remedy** — the specific change: what to change, and where. Use a maximum of two sentences. For a Quality finding, select the remedy from `## Preferred Remedies`. Each finding must have a remedy. If you cannot give a remedy, do not report the finding. Make sure that the remedy does not break a rule of this rubric, a repo rule or the spec. If the remedy causes a new finding, give a different remedy.
- **Done when** — one check that the author can do after the fix. For example: a test that must pass, a pattern that must not be in a file, or one location for a value. Make the check specific, so that the next review can use it to mark the finding as fixed.

Write each field in ASD-STE100 Simplified Technical English. Use short sentences and the active voice. The quote gives the details.

## Review Tone

Be direct and serious, and ask for high quality. Do not be rude. If a maintainability problem is large, do not make it sound like a small suggestion. If the change makes the code more complex, or does not use a large simplification, say this clearly.

## Output Expectations

Rank the findings in this sequence:

0. **P0 — behaviour bug.** Rule 9. A P0 always blocks the approval.
1. **P1 — structural regression.** The diff makes the structure worse than before.
2. **P2 — missed large simplification.** The diff keeps complexity that a visible code-judo move can remove. The structure is not worse than before. If it is worse, use P1.
3. **P3 — spaghetti growth.** New branches or special cases make an existing flow more tangled.
4. **P4 — boundary problem.** A cast, an unclear type, a leaked detail or a loose contract hides the real invariant.
5. **P5 — file size.** The diff pushes a file past a healthy size limit.
6. **P6 — modularity.** Logic in the wrong layer or location, a duplicate helper, or surface that nothing uses.
7. **P7 — legibility.** The code works, but it is difficult to read or maintain.

A cosmetic note that a review would not accept is not a finding.

These are also not findings:

- The wording or the style of a comment or a document, if the text is correct.
- Code that only moved and did not change, for example a file that git shows as a 100% rename. Report it only if the diff makes it worse.
- A problem in code that the diff did not add or change.
- A problem that the lint or the typecheck of the repo already reports.

## Approval Bar

This bar applies to the full branch, one time. If you review one slice, report only the findings. Do not give a verdict.

Do not approve only because the behaviour looks correct. Approve only if the branch has none of these problems. A behaviour bug always blocks. Each other problem blocks the approval, unless the author gives a clear and specific reason:

- a behaviour bug (P0)
- a structural regression
- much incidental complexity that a possible code-judo move can remove
- a file that goes from less than 1000 lines to more than 1000 lines, or a different large increase in file size with no reason
- ad-hoc branches that make an existing flow more tangled, or feature checks in many locations of shared code to solve a local problem
- a hacky or magic abstraction that makes the code more difficult to understand
- an abstraction, wrapper, cast or optionality that is not necessary and makes the design more indirect
- a leak across an architecture boundary, or logic in the wrong layer when a clear canonical location exists
- a duplicate of an existing canonical helper
- a missed obvious split that would make the code much easier to maintain

If the branch does not meet the bar, give explicit feedback that the author can act on. Push for a cleaner structure.
