---
name: to-plan
description: Turn a spec (or PRD) into a multi-phase implementation plan using tracer-bullet vertical slices, each phase declaring its blocking edges, saved as a local Markdown file in .local/docs/plans/.
disable-model-invocation: true
---

# To Plan

Break a spec into a phased implementation plan using vertical slices (tracer bullets). Output is a Markdown file in `.local/docs/plans/`.

## Process

### 1. Gather context

Work from whatever is already in the conversation context — typically a spec produced by `/to-spec`. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments. If there is no spec in context and no reference, ask the user to paste it or point you to the file.

### 2. Explore the codebase

If you have not already explored the codebase, do so to understand the current architecture, existing patterns, and integration layers. The plan should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Identify durable architectural decisions

Before slicing, identify high-level decisions that are unlikely to change throughout implementation:

- Route structures / URL patterns
- Database schema shape
- Key data models
- Authentication / authorization approach
- Third-party service boundaries

These go in the plan header so every phase can reference them.

### 4. Draft vertical slices

First, examine the size of the full spec. If one agent run can build it and verify it in one context window, tell the user. Propose a plan with one phase, or no plan.

Break the spec into **tracer bullet** phases. Each phase is a thin vertical slice that goes through all integration layers from end to end. A phase is not a horizontal slice of one layer.

<vertical-slice-rules>
- Each slice gives a narrow but complete path through each layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Make each slice small enough that one agent run can build it and verify it in one context window
- Do not split a slice only to make it smaller. Each split adds a handoff.
- Put all prefactoring in the first phases
- Do not include file names, function names, or implementation details that later phases can change
- Include durable decisions: route paths, schema shapes, data model names
</vertical-slice-rules>

Exception to the no-snippets rule: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

Write each acceptance criterion as a check that an agent can run. The check must pass or fail. Examples are a package test command with a named test file or test name, a test name, or a request and its expected response. Use a manual check only when an automatic check is not possible. Each criterion checks only work that its own phase delivers.

Give each phase its **blocking edges** — the phases that must complete before it can start. A phase with no blockers can start immediately; anyone consuming the plan can work the frontier (any phase whose blockers are all done) in parallel. For many features the phases form a simple linear chain — that's fine, just make the order explicit.

If the change is a wide refactor (one mechanical change that breaks call sites across the whole codebase), read [WIDE-REFACTORS.md](WIDE-REFACTORS.md).

### 5. Quiz the user

Present the proposed breakdown as a numbered list. For each phase show:

- **Title**: short descriptive name
- **Delivers**: the end-to-end behaviour that this phase makes work
- **User stories covered**: which user stories from the spec this addresses
- **Blocked by**: which other phases (if any) must complete first

Ask the user these questions with the `AskUserQuestion` tool:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each phase only depend on phases that genuinely gate it?
- Should any phases be merged or split further?

Iterate until the user approves the breakdown.

### 6. Write the plan file

Create `.local/docs/plans/` if it doesn't exist. Write the plan as a Markdown file named after the feature (e.g. `.local/docs/plans/user-onboarding.md`). Order phases in dependency order (blockers first). Use the template below.

<plan-template>
# Plan: <Feature Name>

> Source spec: <brief identifier or link>
> ADR: <path, if an ADR applies; one line for each ADR>
> Grilling record: <path, if a grilling record exists>
>
> How to use this plan: tick each acceptance criterion when its check passes. When you find new work, add it as a criterion or as a new phase.

## Architectural decisions

Durable decisions that apply across all phases:

- **Routes**: ...
- **Schema**: ...
- **Key models**: ...
- (add/remove sections as appropriate)

---

## Phase 1: <Title>

**User stories**: <list from the spec>

**Blocked by**: None — can start immediately

### What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

### Acceptance criteria

- [ ] <check that can pass or fail>
- [ ] <check that can pass or fail>

---

## Phase 2: <Title>

**User stories**: <list from the spec>

**Blocked by**: Phase 1

### What to build

...

### Acceptance criteria

- [ ] ...

<!-- Repeat for each phase -->
</plan-template>
