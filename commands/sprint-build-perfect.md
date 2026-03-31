# Sprint Build Perfect — Build, Test, Perfect, Repeat

Build features from your requirements list. Each feature goes through a build-test-perfect loop that does NOT exit until the feature works as intended. After all features are built, run a full QA sweep to verify everything works together.

Input: $ARGUMENTS (module name, phase number, or "all" — default: current phase from STATE.md)

## The Iron Law

NO FEATURE EXITS THE LOOP UNTIL IT PASSES ALL TESTS. No exceptions. No "good enough." No "we'll fix it later."

## Context Survival Protocol

This command is designed to survive context rot, session death, and context window limits. It works by keeping ALL progress in files, not in conversation memory.

### The Sprint Log (`.planning/sprint-log.md`)

Before EVERY step, write what you're about to do to `.planning/sprint-log.md`. After every step, write what happened. This file is your memory across sessions.

Format:
```markdown
# Sprint Log
## Session started: [timestamp]
## Current requirement: [text]
## Status: BUILDING / TESTING / PERFECTING / COMPLETE
## Attempt: 2/5
## Files changed: [list]
## Last test result: 22 passing, 1 failing
## Failing test: [test name and error]
## Notes: [what you tried, what worked, what didn't]
```

### WIP Commits (Work In Progress)

Do NOT wait until all tests pass to commit. Commit after every meaningful change:
- After writing implementation code: `wip: [requirement] — implementation, tests pending`
- After writing tests: `wip: [requirement] — tests written, fixing failures`
- After each fix attempt: `wip: [requirement] — fix attempt N, [X] passing`
- After all tests pass: `feat: [requirement] — all tests passing` (the final commit)

WIP commits mean: if the session dies, the next session starts with your code already written. It just needs to finish testing/fixing.

### Session Resumption

When this command starts, FIRST check for an existing sprint log:

1. Read `.planning/sprint-log.md` — if it exists, you're RESUMING a previous session
2. Read the status field:
   - `BUILDING` → the previous session died during build. Check git for WIP commits. Continue building.
   - `TESTING` → code was written but tests failed. Run tests, see what's failing, continue fixing.
   - `PERFECTING` → in the middle of fix attempts. Read the attempt number and last error. Continue from there.
   - `COMPLETE` → previous requirement finished. Move to next unchecked requirement.
3. Do NOT re-read all planning files if sprint-log.md tells you what you need. Keep the context lean.

### Context Rot Detection

After completing each requirement, do a self-check:
- "Am I still oriented? Do I know what phase I'm in, what I just built, what's next?"
- If you feel uncertain about the project state, re-read `.planning/sprint-log.md` and `.planning/STATE.md`
- If you have built 3+ requirements in this session, consider telling the user:
  "I've built N requirements this session. Context is getting heavy. Recommend: commit, push, start a fresh session with `/sprint-build-perfect` to continue with clean context."

### The 3-Requirement Checkpoint

After every 3 completed requirements:
1. Commit all work
2. Push to remote
3. Update sprint-log.md with a summary of what's done
4. Tell the user: "Checkpoint: N requirements complete. Recommend fresh session to avoid context rot. Run `/sprint-build-perfect` in a new session to continue."

The user can choose to continue or restart. Either way, nothing is lost — everything is in files and commits.

## Process

### Step 0: Orient + Detect GSD

First, detect which project management system is in use:

**If `.gsd/` directory exists (GSD v2):**
Read these files in order:
1. `.gsd/STATE.md` — current milestone, slice, task
2. `.gsd/milestones/M001/M001-ROADMAP.md` — slice list with checkboxes
3. Current slice plan: `.gsd/milestones/M001/S[NN]-PLAN.md` — task decomposition with must-haves
4. `AGENTS.md` — project-specific rules (if exists)

Work units = GSD tasks within slices. Each task has must-haves (truths, artifacts, key links).

**If `.planning/` directory exists (Playbook / GSD v1):**
Read these files:
1. `.planning/STATE.md` — current phase
2. `.planning/REQUIREMENTS.md` — the checklist
3. `.planning/ROADMAP.md` — phase order and context
4. `AGENTS.md` — project-specific rules (if exists)

Work units = unchecked requirements in REQUIREMENTS.md.

**Identify what to build:**
- If $ARGUMENTS is a phase/slice number: build all unchecked items for that phase/slice
- If $ARGUMENTS is "all": build all unchecked items across all phases/slices
- If no argument: build unchecked items for the current phase/slice from STATE.md

Report: "Phase/Slice N: X items to build | Tracking: GSD v2 / Playbook"

### Step 1: The Build-Test-Perfect Loop

For each unchecked requirement:

#### 1a. BUILD

**First, update the sprint log:**
```markdown
## Current requirement: [requirement text]
## Status: BUILDING
## Attempt: 1/5
## Session: [new or resumed]
```

Read the requirement. Read relevant code. Follow existing patterns.

- Write implementation code
- Write unit tests for what you built
- Run `npx tsc --noEmit` — fix any type errors
- **WIP commit:** `wip: [requirement] — implementation + tests written`
- **Update sprint log:** `Status: TESTING`

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

**Update sprint log:** `Status: PERFECTING`

If ANY test fails (unit OR Playwright):

```
ATTEMPT 1: Read the error. Fix the obvious cause. Re-run tests.
  → Update sprint log: Attempt: 1/5, Last test result: X passing Y failing
  → WIP commit: wip: [requirement] — fix attempt 1

ATTEMPT 2: Read the error more carefully. Check edge cases. Fix. Re-run.
  → Update sprint log: Attempt: 2/5
  → WIP commit: wip: [requirement] — fix attempt 2

ATTEMPT 3: Step back. Read the full test output. Check if the fix broke something else. Fix. Re-run.
  → Update sprint log: Attempt: 3/5
  → WIP commit: wip: [requirement] — fix attempt 3

ATTEMPT 4: Minimal approach. Only touch the exact lines causing the failure. Re-run.
  → Update sprint log: Attempt: 4/5
  → WIP commit: wip: [requirement] — fix attempt 4

ATTEMPT 5: If still failing, mark as STUCK. Add <!-- STUCK: [reason] --> to REQUIREMENTS.md. Move on.
  → Update sprint log: Status: STUCK, Notes: [what was tried]
  → Commit: stuck: [requirement] — 5 attempts exhausted, needs human review
```

Maximum 5 attempts per feature. If it takes more than 5, a human needs to look at it.

**Every attempt produces a WIP commit.** If the session dies on attempt 3, the next session reads the sprint log, sees "Attempt: 3/5", and picks up at attempt 4 — not from scratch.

#### 1e. FEATURE COMPLETE — Update GSD State

When ALL tests pass (unit + Playwright):

**If GSD v2 (`.gsd/` exists):**
- Write task summary to `.gsd/milestones/M001/T[NN]-SUMMARY.md`:
  ```markdown
  ---
  task: T[NN]
  status: done
  tests_pass: true
  attempts: N
  ---
  [What was built, what was tested, any decisions made]
  ```
- If this was the last task in the slice, mark the slice complete in `M001-ROADMAP.md`
- Update `.gsd/STATE.md` with current progress

**If Playbook (`.planning/` exists):**
- Check the box in REQUIREMENTS.md: `- [ ]` → `- [x]`
- Update `.planning/STATE.md` with current progress

**Both:**
- Commit: `feat: [requirement/task summary] (Phase/Slice N) — all tests passing`
- Report:
  ```
  [requirement/task text]
    Unit tests: X passing
    Playwright: Y passing
    Attempts: N/5
    Tracked in: GSD v2 / Playbook
  ```

Move to the next unchecked requirement/task.

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

**If GSD v2:**
- Mark current slice as complete in `M001-ROADMAP.md`
- Write slice UAT script to `.gsd/milestones/M001/S[NN]-UAT.md`
- Update `.gsd/STATE.md` — advance to next slice
- Commit: `milestone(S[NN]): [slice title] complete — all tests passing`

**If Playbook:**
- Update `.planning/STATE.md` — mark current phase COMPLETE, set next phase as current
- Record completion date
- Commit: `milestone: Phase N complete — all tests passing`

## Rules

- NEVER claim a feature is done without ALL tests passing
- NEVER skip the Playwright test for UI features
- NEVER modify existing tests to make them pass (unless genuinely wrong)
- NEVER exit the perfect loop with failing tests — either fix or mark STUCK
- ONE requirement at a time. Build it. Test it. Perfect it. Then the next one.
- If the dev server needs to be running for Playwright, start it at the beginning and keep it running
- Always run the FULL test suite at phase boundaries, not just individual test files
- If you break something while fixing something else, fix BOTH before moving on
