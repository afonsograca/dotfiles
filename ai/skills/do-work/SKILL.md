---
name: do-work
description: Execute a unit of work in this repository end-to-end: understand the task, plan if needed, implement, validate with typecheck and tests, then commit. Use when the user asks you to implement a feature, fix a bug, or complete a task described in a plan or PRD.
---

# Do Work

Execute one unit of work from start to committed code.

## Step 1: Understand the task

Before touching any code, be clear on what success looks like:

- What files will change? (service, route, schema, test, callers?)
- What's the acceptance criteria — how will you know it's done?
- Is there a plan file in `./plans/` that already describes this work? If so, read it and treat its acceptance criteria as the definition of done.

If anything is ambiguous, ask before proceeding.

## Step 2: Plan (skip if a plan already exists)

If there's no plan file covering this task, do a scoping pass before writing any code:

- Identify the service and its test file
- Find every call site that will need updating (use grep)
- Identify any schema changes needed
- Create a task list with TaskCreate so your progress is visible

Keep this lightweight — you're not designing, just mapping the blast radius so nothing gets missed.

## Step 3: Implement

Work through the plan step by step. Mark each task complete as you finish it.

### Backend code: red-green-refactor

For any backend code — services, loaders, actions, DB queries — use a tracer bullet approach: implement one behaviour at a time, each as its own red-green-refactor cycle.

**The cycle:**

1. **Red** — Write a single test that captures the next behaviour. Run `pnpm test` and confirm it fails (for the right reason, not because of a syntax error).
2. **Green** — Write the minimum production code to make that test pass. Don't write code that isn't needed to pass the current test.
3. **Refactor** — Clean up while keeping tests green. Then repeat from step 1 for the next behaviour.

**Tracer bullet style** means picking the path through the code that delivers the most value first — typically the happy path — before adding edge cases and error paths. A good order:

1. Happy path
2. Not-found / empty cases
3. Validation and error cases
4. Permission / auth checks

Each cycle should be small enough to hold in your head. If you find yourself writing a lot of production code to pass a single test, the test is probably covering too much — split it.

### Frontend code

Skip the red-green-refactor cycle and implement directly. Write tests only where logic is genuinely testable in isolation; don't try to test rendering or user interactions here.

## Step 4: Validate

Run both feedback loops and fix all issues before committing:

```bash
pnpm typecheck
pnpm run test
```

**If typecheck fails:**

- Fix at the source — don't cast to `any`
- If errors appear in files you didn't touch, check whether your changes broke an import or type contract upstream

**If tests fail:**

- If the failing test is in a file you changed, fix the code (or the test, if the test was wrong)
- If a pre-existing test is failing that you didn't touch, note it in your commit message rather than silently fixing unrelated things

Iterate until both commands exit with code 0.

## Step 5: Commit

Once typecheck and tests are green:

- Stage only the files changed for this task — don't `git add -A`
- Write a commit message in conventional commit format: `type(scope): description`
  - The types should be a gitmoji: https://gitmoji.dev/
  - Common types: `feat`, `fix`, `refactor`, `test`, `chore`
  - Scope is optional but useful (e.g. `:sparkles:(enrollments): ...`)
  - Body is optional — use it only when the _why_ isn't obvious from the title

```bash
git commit -m "$(cat <<'EOF'
type(scope): short description

EOF
)"
```

Do **not** push unless the user explicitly asks.
