# Sprint Build Perfect V2 — Build, Test, Review, Perfect, Repeat

V2 improvements over V1:
- Git worktree isolation per requirement (zero mess on failure)
- Mandatory Codex adversarial review before commit
- Machine-readable sprint status JSON
- Context rot detection via status file verification

Build features from your requirements list. Each feature goes through a build-test-review-perfect loop that does NOT exit until the feature works as intended and survives adversarial review. After all features are built, run a full QA sweep to verify everything works together.

Input: $ARGUMENTS (module name, phase number, or "all" — default: current phase from STATE.md)

## The Iron Law

NO FEATURE EXITS THE LOOP UNTIL IT PASSES ALL TESTS AND SURVIVES CODEX REVIEW. No exceptions. No "good enough." No "we'll fix it later."

## Context Survival Protocol

This command is designed to survive context rot, session death, and context window limits. It works by keeping ALL progress in files, not in conversation memory.

### Machine-Readable Sprint Status (`.planning/sprint-status-v2.json`)

Before EVERY step, update `.planning/sprint-status-v2.json`. This file is your memory across sessions and your context rot detector.

Format:
```json
{
  "session_start": "2026-03-30T10:00:00Z",
  "current_requirement": "Add user authentication flow",
  "status": "BUILDING",
  "attempt": 1,
  "requirements_done": 0,
  "requirements_stuck": 0,
  "requirements_remaining": 10,
  "test_results": { "unit_pass": 0, "unit_fail": 0, "e2e_pass": 0, "e2e_fail": 0 },
  "worktree_branch": "wt/req-1-user-auth",
  "last_updated": "2026-03-30T10:00:00Z"
}
```

Valid `status` values: `BUILDING`, `TESTING`, `PERFECTING`, `REVIEWING`, `COMPLETE`

### WIP Commits (Work In Progress)

Do NOT wait until all tests pass to commit. Commit after every meaningful change inside the worktree:
- After writing implementation code: `wip: [requirement] — implementation, tests pending`
- After writing tests: `wip: [requirement] — tests written, fixing failures`
- After each fix attempt: `wip: [requirement] — fix attempt N, [X] passing`
- After Codex review passes: `feat: [requirement] — all tests passing, review approved`

### Session Resumption

When this command starts, FIRST check for an existing sprint status:

1. Read `.planning/sprint-status-v2.json` — if it exists, you're RESUMING a previous session
2. Read the status field:
   - `BUILDING` → the previous session died during build. Check git for WIP commits. Continue building.
   - `TESTING` → code was written but tests failed. Run tests, see what's failing, continue fixing.
   - `PERFECTING` → in the middle of fix attempts. Read the attempt number and last error. Continue from there.
   - `REVIEWING` → code passed tests but Codex review was interrupted. Re-send for review.
   - `COMPLETE` → previous requirement finished. Move to next unchecked requirement.
3. If a worktree branch is recorded, check if it still exists. If so, enter it and resume.
4. Do NOT re-read all planning files if sprint-status-v2.json tells you what you need. Keep the context lean.

### Context Rot Detection — Status File Verification

Before EVERY new requirement, re-read `.planning/sprint-status-v2.json` and verify it matches your understanding:

1. Does `requirements_done` match your count of completed requirements?
2. Does `requirements_remaining` match the number of unchecked items in REQUIREMENTS.md?
3. Does `current_requirement` match what you think you just finished or are about to start?
4. Do the `test_results` numbers match the last test run you remember?

If ANY of these contradict what you believe the state to be — STOP. You are in context rot. Immediately:
1. Commit all work with `wip: context checkpoint — saving before session restart`
2. Push to remote
3. Update sprint-status-v2.json
4. Tell the user:
   ```
   CONTEXT ROT DETECTED via sprint-status-v2.json verification.
   The status file says X but I believe Y. This means my context has degraded.
   Nothing is lost — all progress is in git + sprint-status-v2.json.

   Action: Start a fresh session and run /sprint-build-perfect-v2
   ```
5. STOP. Do not build another requirement in this state.

**Proxy Signals That Mean "Stop Soon":**

| Signal | What it means | Action |
|--------|--------------|--------|
| You re-read a file you already read this session | Memory is fading | Finish current requirement, then checkpoint |
| You make the same fix twice | Losing track of what you tried | Stop after this requirement |
| You ask the user a question you should know the answer to | Context is degrading | Checkpoint immediately |
| You're on your 4th+ requirement this session | Getting heavy | Checkpoint after this one |
| A tool call returns compaction warnings | Context was compressed | Finish current requirement, then stop |
| You feel the urge to "re-orient" or "let me check where we are" | You've lost the thread | Checkpoint immediately |

**The Hard Rule: Never build more than 5 requirements in a single session.** After 5, ALWAYS checkpoint and recommend a fresh session — even if everything feels fine. Context rot is invisible to the one experiencing it.

### The 3-Requirement Hard Checkpoint

After every 3 completed requirements:
1. Re-read sprint-status-v2.json and verify `requirements_done` matches your count
2. Commit all work
3. Push to remote
4. Update sprint-status-v2.json with a summary of what's done
5. Tell the user:
   ```
   CHECKPOINT: 3 requirements complete this session.
   Context health: [PASS if status file verification passed / DEGRADING if mismatch detected]
   Sprint status: requirements_done=N, requirements_stuck=N, requirements_remaining=N

   Recommendation: Fresh session with /sprint-build-perfect-v2
   Or type "keep going" to continue (max 2 more requirements).
   ```

After 5 total requirements: HARD STOP. No "keep going" option. Commit, push, tell the user to restart.

The user can choose to continue at the 3-requirement checkpoint. But at 5, you stop. Period.

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

**Initialize sprint-status-v2.json:**
```json
{
  "session_start": "[timestamp]",
  "current_requirement": "",
  "status": "BUILDING",
  "attempt": 0,
  "requirements_done": 0,
  "requirements_stuck": 0,
  "requirements_remaining": [count of unchecked items],
  "test_results": { "unit_pass": 0, "unit_fail": 0, "e2e_pass": 0, "e2e_fail": 0 },
  "worktree_branch": "",
  "last_updated": "[timestamp]"
}
```

Report: "Phase/Slice N: X items to build | Tracking: GSD v2 / Playbook"

### Step 1: The Build-Test-Review-Perfect Loop

For each unchecked requirement:

#### 1a. CREATE WORKTREE

Create a git worktree for this requirement. All work happens in isolation.

```bash
# Create a branch name from the requirement (slugified, short)
BRANCH_NAME="wt/req-[N]-[short-slug]"
git worktree add "../worktree-req-[N]" -b "$BRANCH_NAME"
```

Update sprint-status-v2.json:
```json
{
  "current_requirement": "[requirement text]",
  "status": "BUILDING",
  "attempt": 1,
  "worktree_branch": "[BRANCH_NAME]"
}
```

All subsequent work for this requirement happens inside the worktree directory.

#### 1b. BUILD

Read the requirement. Read relevant code. Follow existing patterns.

- Write implementation code
- Write unit tests for what you built
- Run `npx tsc --noEmit` — fix any type errors
- **WIP commit (in worktree):** `wip: [requirement] — implementation + tests written`
- **Update sprint-status-v2.json:** `"status": "TESTING"`

#### 1c. UNIT TEST

Run `npm test` (or the project's test command).

- Count passing vs failing tests
- If your NEW tests fail: fix the code, re-run. Up to 5 attempts.
- If EXISTING tests broke: you introduced a regression. Fix it.
- Do NOT modify existing tests to make them pass.

Update sprint-status-v2.json `test_results` after each run.

#### 1d. QA TEST (Playwright)

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

Update sprint-status-v2.json `test_results` with e2e counts.

#### 1e. PERFECT LOOP

**Update sprint-status-v2.json:** `"status": "PERFECTING"`

If ANY test fails (unit OR Playwright):

```
ATTEMPT 1: Read the error. Fix the obvious cause. Re-run tests.
  → Update sprint-status-v2.json: attempt: 1, test_results updated
  → WIP commit (in worktree): wip: [requirement] — fix attempt 1

ATTEMPT 2: Read the error more carefully. Check edge cases. Fix. Re-run.
  → Update sprint-status-v2.json: attempt: 2
  → WIP commit: wip: [requirement] — fix attempt 2

ATTEMPT 3: Step back. Read the full test output. Check if the fix broke something else. Fix. Re-run.
  → Update sprint-status-v2.json: attempt: 3
  → WIP commit: wip: [requirement] — fix attempt 3

ATTEMPT 4: Minimal approach. Only touch the exact lines causing the failure. Re-run.
  → Update sprint-status-v2.json: attempt: 4
  → WIP commit: wip: [requirement] — fix attempt 4

ATTEMPT 5: If still failing, mark as STUCK. DELETE THE WORKTREE — zero mess in main tree.
  → Update sprint-status-v2.json: status: "COMPLETE", requirements_stuck += 1
  → git worktree remove "../worktree-req-[N]" --force
  → git branch -D "$BRANCH_NAME"
  → Add <!-- STUCK: [reason] --> to REQUIREMENTS.md in main tree
```

Maximum 5 attempts per feature. If it takes more than 5, a human needs to look at it. The worktree is deleted cleanly — no residue in the main tree.

#### 1f. MANDATORY CODEX ADVERSARIAL REVIEW

<IMPORTANT>
This step is NON-OPTIONAL in V2. Do NOT skip it. Do NOT review the code yourself instead — the whole point is a DIFFERENT model reviews it.
</IMPORTANT>

**Update sprint-status-v2.json:** `"status": "REVIEWING"`

Get the diff with `git diff main` (inside the worktree).

Send to Codex (via the Codex plugin or by running `codex exec --full-auto` in a subshell):

```
You are the ADVERSARY agent. Your job is to BREAK the code that was just written.

Here is what changed:
[paste the git diff]

Your mission:
1. Read the diff carefully
2. Find bugs: edge cases not handled, missing null checks, missing error handling,
   SQL injection, XSS, race conditions, off-by-one errors, missing validation,
   broken existing functionality
3. For each bug you find, write a FAILING TEST that exposes it
4. Add these tests to the existing test files
5. Run: npm test
6. Report what you found

Be ruthless. Think like a hacker and a QA engineer combined.
If you genuinely cannot find any bugs, say "NO BUGS FOUND" and stop.
```

If Codex found bugs and wrote failing tests:
- Read the new failing tests
- Fix the CODE (not the tests) to make them pass
- Run `npm test` to verify
- Up to 2 fix rounds
- If still failing after 2 rounds, treat as STUCK: delete worktree, move on

If Codex plugin is unavailable, fall back to `codex exec --full-auto` in a Bash subshell.

#### 1g. MERGE WORKTREE TO MAIN

When ALL tests pass (unit + Playwright) AND Codex review is complete:

```bash
# Switch to main tree
cd [main-project-dir]
git merge "$BRANCH_NAME" --no-ff -m "feat: [requirement summary] (Phase/Slice N) — all tests passing, review approved"
git worktree remove "../worktree-req-[N]"
git branch -d "$BRANCH_NAME"
```

#### 1h. FEATURE COMPLETE — Update State

**If GSD v2 (`.gsd/` exists):**
- Write task summary to `.gsd/milestones/M001/T[NN]-SUMMARY.md`:
  ```markdown
  ---
  task: T[NN]
  status: done
  tests_pass: true
  attempts: N
  review: codex-approved
  ---
  [What was built, what was tested, any decisions made]
  ```
- If this was the last task in the slice, mark the slice complete in `M001-ROADMAP.md`
- Update `.gsd/STATE.md` with current progress

**If Playbook (`.planning/` exists):**
- Check the box in REQUIREMENTS.md: `- [ ]` → `- [x]`
- Update `.planning/STATE.md` with current progress

**Update sprint-status-v2.json:**
```json
{
  "status": "COMPLETE",
  "requirements_done": [incremented],
  "requirements_remaining": [decremented],
  "test_results": { "unit_pass": X, "unit_fail": 0, "e2e_pass": Y, "e2e_fail": 0 }
}
```

Report:
```
[requirement/task text]
  Unit tests: X passing
  Playwright: Y passing
  Codex review: APPROVED
  Attempts: N/5
  Isolation: worktree merged cleanly
  Tracked in: GSD v2 / Playbook
```

**Run context rot detection** (re-read sprint-status-v2.json and verify against your understanding) before moving to the next requirement.

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
SPRINT COMPLETE — Phase N (V2)
═══════════════════════════════════

Requirements built: X/Y
Requirements stuck: Z (need human review)

Unit tests: A passing, B failing
Playwright tests: C passing, D failing

Codex reviews: N passed, M flagged issues (all resolved)

Commits: N
Worktrees created: N | Merged: N | Deleted (stuck): N
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

- NEVER claim a feature is done without ALL tests passing AND Codex review approved
- NEVER skip the Codex adversarial review — it is mandatory in V2
- NEVER skip the Playwright test for UI features
- NEVER modify existing tests to make them pass (unless genuinely wrong)
- NEVER exit the perfect loop with failing tests — either fix or mark STUCK
- NEVER use destructive git commands on the main tree — worktrees isolate all risk
- ONE requirement at a time. Build it. Test it. Review it. Perfect it. Then the next one.
- If the dev server needs to be running for Playwright, start it at the beginning and keep it running
- Always run the FULL test suite at phase boundaries, not just individual test files
- If you break something while fixing something else, fix BOTH before moving on
- If a requirement is STUCK, delete the worktree — zero mess in the main tree
- If Codex plugin is unavailable, fall back to `codex exec --full-auto` in a Bash subshell
