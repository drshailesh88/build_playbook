# Mutation Gate — Objective Test Quality Measurement

Run Stryker mutation testing on changed modules. Report mutation score. Strengthen weak tests by feeding surviving mutants back. The one metric agents cannot fake.

Input: $ARGUMENTS (module path, "changed" for git-changed files, or "all")

## Why This Exists

Test coverage lies. 93% coverage can mean 58% mutation score — a 34-point gap where bugs hide. Coverage measures which lines EXECUTE. Mutation score measures which bugs your tests would actually CATCH.

Stryker introduces small mutations to your code (flip `>` to `<`, remove a return, swap `true` for `false`). If your tests still pass after a mutation, that test is decorative — it executes the code but doesn't verify the result.

This is the ONLY objective measure of test quality that an agent cannot game.

## Process

### Step 1: Check Stryker Installation

```bash
npx stryker --version 2>/dev/null
```

If not installed:
```bash
npm install --save-dev @stryker-mutator/core @stryker-mutator/vitest-runner @stryker-mutator/typescript-checker
```

If `stryker.config.mjs` doesn't exist, create a minimal one:
```javascript
/** @type {import('@stryker-mutator/api/core').PartialStrykerOptions} */
export default {
  testRunner: 'vitest',
  checkers: ['typescript'],
  reporters: ['clear-text', 'json'],
  concurrency: 4,
  timeoutMS: 30000,
  mutate: ['src/**/*.ts', '!src/**/*.test.ts', '!src/**/*.spec.ts'],
};
```

### Step 2: Determine Scope

Resolve $ARGUMENTS:
- `"changed"` or no argument: mutate only files changed since last commit
  ```bash
  git diff --name-only HEAD~1 | grep -E '\.(ts|tsx|js|jsx)$' | grep -v test | grep -v spec
  ```
- A module path (e.g., `src/lib/actions/registration`): mutate that directory
- `"all"`: mutate everything (WARNING: slow on large codebases — hours, not minutes)

<HARD-GATE>
Do NOT run `--mutate` on the entire codebase per-fix. Scope to changed files or one module.
Full-repo mutation is for nightly CI, not for iteration loops.
</HARD-GATE>

### Step 3: Run Mutation Testing

```bash
npx stryker run --mutate "$SCOPE" --reporters json,clear-text 2>&1
```

Parse the JSON report. Extract:
- Total mutants generated
- Mutants killed (tests caught the mutation)
- Mutants survived (tests missed the mutation — THESE ARE THE PROBLEM)
- Mutation score (killed / total × 100)

### Step 4: Report Scores

```
MUTATION GATE — RESULTS
Module: [scope]

Mutants generated:  [N]
Mutants killed:     [N] (tests caught these)
Mutants survived:   [N] (tests MISSED these — weakness)
Mutation score:     [N]%

Threshold: [configured threshold]%
Status:    [PASS if >= threshold, FAIL if below]
```

**Score interpretation:**
- >= 80%: Excellent — tests are robust
- 60-79%: Good — room to improve, but functional
- 40-59%: Weak — many bugs would go undetected
- < 40%: Decorative — tests provide false confidence

### Step 5: Strengthen Weak Tests (if score below threshold)

For each surviving mutant, Stryker reports:
- The file and line that was mutated
- The type of mutation (e.g., "ConditionalExpression: changed `>` to `<`")
- Which tests cover that line but didn't catch the mutation

**Feed surviving mutants to the agent to strengthen assertions:**

<HARD-GATE>
When strengthening tests, the agent must add BEHAVIORAL assertions, not implementation-coupled ones.

GOOD: "when amount is negative, the function should throw or return error"
BAD: "when line 42 uses >, it should use >" (this just hardcodes the implementation)

The test should describe WHAT the code should do for a given input, not HOW the code does it.
</HARD-GATE>

For each surviving mutant:
1. Read the mutation (what was changed)
2. Ask: "If this mutation were real, what user-visible behavior would break?"
3. Write a test that checks that user-visible behavior
4. Run Stryker again on just that mutant to confirm it's killed

**Autoresearch ratchet:**
```
BEFORE_SCORE = current mutation score
Agent strengthens assertions
AFTER_SCORE = new mutation score

if AFTER_SCORE >= BEFORE_SCORE:
  keep changes, commit
else:
  revert — something went wrong
```

### Step 6: Commit Improvements

```bash
git add <test-files>
git commit -m "test: strengthen assertions for [module] — mutation score [before]% → [after]%"
```

### Step 7: Final Report

```
MUTATION GATE — COMPLETE
Module: [scope]

Before:  [N]% mutation score
After:   [N]% mutation score
Delta:   +[N]%

Surviving mutants addressed: [N]/[total surviving]
Tests strengthened:          [N] files
New assertions added:        [N]

Threshold: [N]%
Status:    [PASS/FAIL]

Surviving mutants still open (need manual attention):
  1. src/lib/actions/registration.ts:42 — ConditionalExpression: > to >=
  2. ...
```

## Thresholds

Default thresholds (configurable per project):

| Module type | Minimum mutation score |
|-------------|----------------------|
| Auth, payments, permissions | 80% |
| Core business logic | 70% |
| API endpoints | 65% |
| UI components | 50% |
| Experimental / new code | Ratchet from current baseline |

The ratchet rule: once a module reaches a score, it can never drop below. Each run's score becomes the new floor.

## Integration with Other Commands

**After `/playbook:anneal`:** Run mutation-gate to verify the fixes actually improved test quality, not just test pass rate.

**After `ralph-loop-qa.sh`:** Mutation-gate runs at stage boundaries (not every iteration) to measure progress.

**In CI:** Block merges if mutation score on changed files drops below the module's ratcheted baseline.

## Rules

- NEVER run whole-repo mutation on every fix iteration. Scope to changed files or one module.
- NEVER add assertions that just hardcode the implementation. Assert behavior, not line numbers.
- ALWAYS use the ratchet — mutation score can only go up, never down.
- ALWAYS run existing tests after strengthening to check for regressions.
- Surviving mutants that can't be killed with behavioral tests may indicate dead code — flag for review.
- Mutation testing is the JUDGE of test quality. It is NOT a test-generation tool.
