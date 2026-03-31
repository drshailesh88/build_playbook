# Sprint Build Perfect — Build, Test, Perfect, Repeat

Build features from your requirements list. Each feature goes through a build-test-perfect loop that does NOT exit until the feature works as intended. After all features are built, run a full QA sweep to verify everything works together.

Input: $ARGUMENTS (module name, phase number, or "all" — default: current phase from STATE.md)

## The Iron Law

NO FEATURE EXITS THE LOOP UNTIL IT PASSES ALL TESTS. No exceptions. No "good enough." No "we'll fix it later."

## Process

### Step 0: Orient

Read these files:
1. `.planning/STATE.md` — current phase
2. `.planning/REQUIREMENTS.md` — the checklist
3. `.planning/ROADMAP.md` — phase order and context
4. `AGENTS.md` — project-specific rules (if exists)

Identify which requirements to build:
- If $ARGUMENTS is a phase number: build all unchecked requirements for that phase
- If $ARGUMENTS is "all": build all unchecked requirements across all phases
- If no argument: build unchecked requirements for the current phase from STATE.md

Report: "Phase N: X unchecked requirements to build"

### Step 1: The Build-Test-Perfect Loop

For each unchecked requirement:

#### 1a. BUILD

Read the requirement. Read relevant code. Follow existing patterns.

- Write implementation code
- Write unit tests for what you built
- Run `npx tsc --noEmit` — fix any type errors

#### 1b. UNIT TEST

Run `npm test` (or the project's test command).

- Count passing vs failing tests
- If your NEW tests fail: fix the code, re-run. Up to 5 attempts.
- If EXISTING tests broke: you introduced a regression. Fix it.
- Do NOT modify existing tests to make them pass.

#### 1c. QA TEST (Playwright)

If the feature has a UI component, test it with Playwright:

```bash
# Start the dev server if not running
npm run dev &
sleep 5

# Run relevant Playwright tests
npx playwright test [relevant-test-file] --reporter=json
```

Check:
- Does the page load without errors?
- Does the feature render correctly?
- Can a user interact with it (click, type, submit)?
- Does it produce the expected result?

If no Playwright tests exist for this feature, write one:
- Create `e2e/[feature-name].spec.ts`
- Test the happy path (user does the thing, expected result happens)
- Test one error path (user does something wrong, appropriate error shown)

#### 1d. PERFECT LOOP

If ANY test fails (unit OR Playwright):

```
ATTEMPT 1: Read the error. Fix the obvious cause. Re-run tests.
ATTEMPT 2: Read the error more carefully. Check edge cases. Fix. Re-run.
ATTEMPT 3: Step back. Read the full test output. Check if the fix broke something else. Fix. Re-run.
ATTEMPT 4: Minimal approach. Only touch the exact lines causing the failure. Re-run.
ATTEMPT 5: If still failing, mark as STUCK. Add <!-- STUCK: [reason] --> to REQUIREMENTS.md. Move on.
```

Maximum 5 attempts per feature. If it takes more than 5, a human needs to look at it.

#### 1e. FEATURE COMPLETE

When ALL tests pass (unit + Playwright):

- Check the box in REQUIREMENTS.md: `- [ ]` → `- [x]`
- Commit: `feat: [requirement summary] (Phase N) — all tests passing`
- Report:
  ```
  ✓ [requirement text]
    Unit tests: X passing
    Playwright: Y passing
    Attempts: N/5
  ```

Move to the next unchecked requirement.

### Step 2: Phase Complete — Full QA Sweep

When all requirements for the current phase are checked:

#### 2a. Full Unit Test Suite

```bash
npm test
```

Report pass/fail counts. If any failures:
- Identify which tests fail
- Fix the code (not the tests)
- Re-run until all pass

#### 2b. Full Playwright E2E Suite

```bash
npx playwright test --reporter=json
```

Report pass/fail counts. If any failures:
- Read the failure screenshots/traces
- Fix the code
- Re-run until all pass

#### 2c. Cross-Feature Integration Check

For each requirement that was built in this phase:
- Verify it still works after all other features were added
- Check for conflicts (CSS clashes, state conflicts, API route collisions)
- Run the specific Playwright test for each feature one more time

#### 2d. Quality Score Check

If `quality-score.mjs` exists:
```bash
node quality-score.mjs
```
Report the score. Flag any dimension below 90.

### Step 3: Sprint Report

After the phase is fully complete and all tests pass:

```
SPRINT COMPLETE — Phase N
═══════════════════════════════════

Requirements built: X/Y
Requirements stuck: Z (need human review)

Unit tests: A passing, B failing
Playwright tests: C passing, D failing

Commits: N
Time: ~estimate

Features that needed multiple attempts:
  - [feature 1]: 3 attempts (issue: missing null check)
  - [feature 2]: 2 attempts (issue: wrong CSS selector)

Stuck items (need human):
  - [feature 3]: <!-- STUCK: Playwright can't click modal -->

Next: /playbook:where-am-i for next phase
```

### Step 4: Update State

Update `.planning/STATE.md`:
- Mark current phase as COMPLETE
- Set next phase as current
- Record completion date

Commit: `milestone: Phase N complete — all tests passing`

## Rules

- NEVER claim a feature is done without ALL tests passing
- NEVER skip the Playwright test for UI features
- NEVER modify existing tests to make them pass (unless genuinely wrong)
- NEVER exit the perfect loop with failing tests — either fix or mark STUCK
- ONE requirement at a time. Build it. Test it. Perfect it. Then the next one.
- If the dev server needs to be running for Playwright, start it at the beginning and keep it running
- Always run the FULL test suite at phase boundaries, not just individual test files
- If you break something while fixing something else, fix BOTH before moving on
