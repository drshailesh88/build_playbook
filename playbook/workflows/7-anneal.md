# Anneal — Self-Healing Test Loop

Read failed test specs, fix the underlying code, re-run tests, and repeat until the quality gate passes. This is the autonomous self-healing loop that turns a failing app into a hardened one.

Module: $ARGUMENTS (module name, or "all")

## Why This Exists

After spec-runner identifies failures, you have a list of broken checkpoints. This command enters a loop: read a failure → diagnose it → fix the code → re-run the test → verify it passes → move to the next failure. The loop continues until all checkpoints pass or the maximum iterations are reached.

Adapted from:
- a production self-annealing system (quality score improved from 47 → 99.71 over multiple sessions)
- Geoffrey Huntley's Ralph methodology ("sit ON the loop, not IN it")
- Jesse Vincent's verification-before-completion ("evidence before claims")

## The Loop

```
READ FAILURES
    │
    ▼
┌─────────────────────────┐
│ Pick highest-priority    │
│ failing checkpoint       │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ DIAGNOSE                 │
│ Read the failing test    │
│ Read the source code     │
│ Identify root cause      │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ FIX                      │
│ Make the minimal code    │
│ change to fix this       │
│ checkpoint               │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ VERIFY                   │
│ Re-run JUST this test    │
│ Did it pass?             │
└────────┬────────────────┘
         │
    ┌────┴────┐
    │YES      │NO
    ▼         ▼
  ┌─────┐  ┌──────────────┐
  │COMMIT│  │ Try again    │
  │      │  │ (max 3 per   │
  │Mark  │  │  checkpoint) │
  │PASS  │  └──────┬───────┘
  └──┬──┘         │
     │         3 failures
     │            │
     ▼            ▼
  ┌─────┐  ┌──────────────┐
  │NEXT │  │ SKIP — mark  │
  │FAIL │  │ as STUCK     │
  └──┬──┘  └──────────────┘
     │
     ▼
  ALL DONE or MAX ITERATIONS?
     │
    ┌┴──────────┐
    │YES        │NO
    ▼           ▼
  REPORT      LOOP BACK
```

## Process

### Step 1: Read Failure Inventory

```bash
# Find all failing checkpoints across specs for this module
grep -rn "FAIL:" qa/specs/$ARGUMENTS/ | head -50
```

Parse each failure:
- Spec file path
- Checkpoint description
- Section/category
- Which test file failed

Count total failures. If zero: "✅ No failures found. Module is clean."

### Step 2: Prioritize Failures

Order by:
1. `[CONFIRMED]` features first (highest confidence they should work)
2. `[EMERGENT]` features second (library features that should work by default)
3. `[RUNTIME-ONLY]` features last (may be false positives)

Within each priority tier, group related failures together (same component, same file) so fixes can cascade.

### Step 3: Enter the Healing Loop

Set iteration counter: `MAX_ITERATIONS = total_failures × 3` (cap at 50 per session)
Set per-checkpoint retry limit: 3

**For each failing checkpoint:**

#### 3a: Diagnose

Use a subagent (Explore mode) to investigate:

```
Prompt: |
  A test is failing for this checkpoint:
  
  Spec: <spec file path>
  Checkpoint: "<checkpoint description>"
  Test file: <generated test path>
  Test error: <Playwright error output>
  
  Read the test file to understand what it expects.
  Read the source component(s) to understand what actually happens.
  
  Report:
  1. What the test expects
  2. What the code actually does
  3. Root cause of the mismatch
  4. Is this a CODE bug or a TEST bug?
```

**Critical distinction:**
- **CODE bug**: The feature doesn't work as described. Fix the application code.
- **TEST bug**: The feature works but the test is wrong (bad selector, wrong assertion, timing issue). Fix the test.
- **SPEC bug**: The checkpoint describes something that doesn't make sense. Mark as BLOCKED with explanation.

#### 3b: Fix

Apply the minimal change:
- If CODE bug: fix the source file. Use the smallest possible change.
- If TEST bug: fix the generated test file. Update the selector or assertion.
- If SPEC bug: update the spec file to mark checkpoint as BLOCKED with reason.

**Constraints:**
- ONE fix per iteration — don't bundle unrelated fixes
- Run TypeScript check after every fix: `npx tsc --noEmit 2>&1 | head -20`
- Run lint after every fix: `npx eslint <changed-file> 2>&1 | head -20`
- If TypeScript or lint fails, fix that BEFORE moving on

#### 3c: Verify

Re-run ONLY the failing test:

```bash
npx playwright test qa/generated/$MODULE/<spec-id>.spec.ts -g "<checkpoint description>" --reporter=json
```

Read the result. Did this specific checkpoint pass?

<HARD-GATE>
Do NOT claim the fix worked without running the test and reading the output.
"Should work now" is not evidence. Run it.
</HARD-GATE>

#### 3d: Record Result

**If PASS:**
```bash
# Update spec file: change - [ ] FAIL to - [x] PASS
# Commit the fix
git add <changed-files>
git commit -m "fix(<module>): <what was fixed> — checkpoint now passes"
```

Move to next failure.

**If still FAIL:**
Increment retry counter for this checkpoint.
- Retry < 3: Try a different fix approach
- Retry = 3: Mark as STUCK. Add to stuck list. Move to next failure.

```markdown
- [ ] STUCK: **<feature>** — <description> (3 fix attempts failed: <brief summary of what was tried>)
```

### Step 4: Re-Run Full Suite

After all individual fixes, re-run the entire module's test suite to check for regressions:

```bash
npx playwright test qa/generated/$ARGUMENTS/ --reporter=json
```

If any previously-passing test now fails (regression), the fix broke something else. Revert the offending commit and mark that checkpoint as STUCK.

### Step 5: Update Spec Files

Update all spec headers with final counts:

```markdown
STATUS: <COMPLETE if all pass, PARTIAL if some fail, STUCK if max retries hit>
TESTED: <N>/<total>
PASS: <N>
FAIL: <N>
BLOCKED: <N>
STUCK: <N>
```

### Step 6: Report

```
🔬 ANNEALING COMPLETE
━━━━━━━━━━━━━━━━━━━━
Module: <module>
Iterations: <N>
Duration: <time>

Results:
  Before: <N>/<total> passing (<percentage>%)
  After:  <N>/<total> passing (<percentage>%)
  Delta:  +<N> checkpoints fixed

  ✅ Fixed:   <N> checkpoints
  🔧 STUCK:   <N> checkpoints (3 attempts each, need human review)
  ⚠️  BLOCKED: <N> checkpoints (spec issues, not code issues)

Fixed checkpoints:
  1. <spec> CP-<N>: <description> — <what was wrong>
  2. ...

Stuck checkpoints (need human attention):
  1. <spec> CP-<N>: <description> — <what was tried>
  2. ...

Commits: <N> fix commits made

Next: 
  - Review STUCK items manually
  - Run `/spec-runner <module>` to re-validate
  - Run `/harden <module>` for the full pipeline with quality gate
```

### Step 7: Commit Summary

```bash
git add qa/specs/$ARGUMENTS/ qa/generated/$ARGUMENTS/ qa/queue.jsonl
git commit -m "anneal(<module>): <fixed>/<total> checkpoints passing — <N> fixed, <N> stuck"
```

## Self-Annealing Quality Gate (Optional)

If the project has a quality scorer (like a `quality-score.mjs`), run it as a gate:

```bash
# Check if a quality scorer exists
test -f quality-score.mjs && node quality-score.mjs
# Or
test -f quality-score.json && cat quality-score.json
```

If the score dropped after annealing (fixes introduced regressions), flag it.

## Rules

- **ONE fix per iteration** — never bundle. Each fix gets its own commit and verification.
- **ALWAYS re-run the specific test after a fix** — evidence before claims.
- **NEVER modify tests to make them pass artificially** — if the feature doesn't work, fix the feature, not the test. (Exception: test has a genuinely wrong selector or assertion.)
- **3 retries max per checkpoint** — then mark STUCK and move on. Don't burn tokens on intractable problems.
- **Always run regression check** after individual fixes — a fix that breaks something else isn't a fix.
- **STUCK items are for humans** — the agent tried 3 times. A human needs to look. Don't pretend these will self-resolve.
- **Cap total iterations at 50** — if you have 50+ failures, the module needs more than patching. Step back and re-architect.
