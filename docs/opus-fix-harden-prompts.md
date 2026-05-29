# Opus 4.7 Task: Fix 6 Adversarial Findings in Harden Prompts

## Your Role

You are editing three prompt templates that form the hardening layer —
mutation testing, completeness auditing, and contract drift detection.
These are instructions for LLM agents, not code. Every change affects
how future hardening iterations behave.

## System Context

The Build Playbook pipeline:

```
grill-me → write-a-prd → prd-to-ralph → build-prompt → qa-prompt → [harden] → release gates
                                                                      ^^^
                                                                  YOU ARE HERE
```

The harden layer has three agents running in sequence:
1. **harden-prompt** (mutation testing) — runs Stryker, finds surviving
   mutants, adds tests to kill them. Goal: raise mutation score.
2. **harden-completeness-prompt** — compares OUGHT (prd.json) vs IS
   (what's actually built), appends missing features to prd.json.
3. **harden-drift-prompt** — compares frozen contracts
   (`.quality/contracts/`) against implementation, finds behavioral drift.

**Downstream:** qa-run release gates consume harden outputs to decide
if the app ships.

**Key invariant:** Harden agents strengthen quality. They must NEVER
weaken existing tests, bypass contracts, or introduce unverified work.

## Files to Modify

1. **`playbook/qa-scaffold/templates/ralph/harden-prompt.template.md`** (205 lines)
2. **`playbook/qa-scaffold/templates/ralph/harden-completeness-prompt.template.md`** (361 lines)
3. **`playbook/qa-scaffold/templates/ralph/harden-drift-prompt.template.md`** (177 lines)

## Constraints

- Do NOT restructure any file. Fix each finding surgically.
- Do NOT change the fundamental harden workflow (Stryker → tests, OUGHT−IS → append, contracts → drift).
- All fixes go into the three template files listed above.
- Preserve existing markdown formatting style.

---

## FINDINGS TO FIX

### Finding H1 [HIGH]: Completeness auto-builds auth/payments before contracts
**File:** `harden-completeness-prompt.template.md`, lines 232-256
**Section:** Step 5c (contract flagging) and Step 8 (signal)

**Current state:** Step 5c flags stories with `contract_needed: true` and
`contract_category_gate: "hard"` for auth/payments/user_data. But Step 8
emits `<promise>NEXT</promise>` which triggers build.sh. The builder picks
up these stories and builds them before `/playbook:contract-pack` freezes
an oracle — meaning drift detection has nothing to compare against.

**What to change:**

1. In Step 5c, after the contract flagging table, add:
   ```markdown
   **HARD-gate stories are NOT buildable until contracts exist.**

   For any appended story with `contract_category_gate: "hard"`:
   - Set `"blocked_on_contract": true` in addition to existing fields
   - The builder (build-prompt) will skip entries with
     `blocked_on_contract: true`, same as `blocked_on_spec`

   This prevents building auth/payments/user_data features before a
   frozen oracle exists. The human must run
   `/playbook:contract-pack <story-id>` first, which removes
   `blocked_on_contract` after the contract is frozen.
   ```

2. In Step 8, update the NEXT signal description:
   ```markdown
   - `<promise>NEXT</promise>` — appended ≥1 buildable feature (not
     blocked_on_spec or blocked_on_contract); orchestrator will trigger
     build.sh
   ```

3. Also add: if ALL appended features are blocked (on spec or contract),
   emit a distinct signal or note in the progress log that human action
   is required before the next build iteration will pick up work.

---

### Finding H2 [HIGH]: Lossy IS extractor treated as infallible truth
**File:** `harden-completeness-prompt.template.md`, lines 53-57
**Section:** Step 2 (Read the deterministic IS list)

**Current state:** The prompt says "You MUST treat the extractor output
as truth for IS" and forbids codebase search. If the extractor misses
an entity, completeness classifies an already-built feature as missing
and appends a duplicate story.

**What to change:** After the existing "MUST treat as truth" block, add
a validation step:

```markdown
**Extractor confidence check (before computing OUGHT − IS):**

Before trusting the IS list, perform a bounded sanity check:

1. Count entities in `completeness-is-list.json`: if total entities
   (apiEndpoints + serverActions + uiPages + routeHandlers) is ZERO
   and prd.json has ≥3 stories with `passes:true`, the extractor
   likely failed. **ABORT** with diagnostic: "IS extractor returned
   zero entities despite N built stories."

2. Read `completeness-evidence.json`. If it reports `warnings` or
   `discoveredRoots` that suggest extraction was partial (e.g.,
   "skipped directory X", "no package.json found"), log these in
   completeness-progress.txt and add a confidence qualifier to the
   iteration summary.

3. If a feature in OUGHT has `passes:true` in prd.json (meaning the
   builder already built and marked it) but NO matching entity exists
   in IS, this is an EXTRACTOR GAP, not a missing feature. Do NOT
   append a new story. Instead, log:
   ```
   EXTRACTOR GAP: {story-id} has passes:true but no IS entity found.
   The extractor may need updating, or the feature uses a pattern the
   extractor doesn't recognize.
   ```
   Flag these in the progress log for human review.

You still MUST NOT search the codebase yourself. But you MUST NOT
blindly append stories for features that prd.json says are already built.
```

---

### Finding H3 [HIGH]: Drift detection misses prose invariants
**File:** `harden-drift-prompt.template.md`, lines 131-138
**Section:** Completion verification

**Current state:** The drift agent reads contract examples,
counterexamples, and invariants, but completion is verified only by
rerunning acceptance tests. If a contract invariant isn't encoded in
`acceptance.spec.ts`, it passes even when violated.

**What to change:** Add a contract coverage audit before the completion
signal. Find the section where the agent determines DRIFT_COMPLETE and
add:

```markdown
**Contract coverage audit (required before DRIFT_COMPLETE):**

Before declaring no drift, verify that every contract artifact has
corresponding test coverage:

1. Read `.quality/contracts/{feature}/invariants.md`. For each invariant:
   - Find a corresponding test in `acceptance.spec.ts` or
     `regressions.spec.ts` that exercises this invariant
   - If no test covers it: this is a **COVERAGE GAP**, not "no drift"
   - Record: `{ invariant, covered: true/false, test_name_or_gap }`

2. Read `.quality/contracts/{feature}/counterexamples.md`. For each
   counterexample (forbidden behavior):
   - Find a corresponding test that asserts this behavior does NOT occur
   - If no test covers it: COVERAGE GAP
   - Record: `{ counterexample, covered: true/false, test_name_or_gap }`

3. Read `.quality/contracts/{feature}/examples.md`. For each example
   (required behavior):
   - Find a corresponding test that asserts this behavior occurs
   - If no test covers it: COVERAGE GAP

**DRIFT_COMPLETE is BLOCKED** if any invariant or counterexample has
`covered: false`. Instead, emit NEXT with a diagnostic:
"Contract coverage gaps found — [N] invariants and [M] counterexamples
lack test coverage. Adding tests to close gaps."

The drift agent SHOULD write tests to close coverage gaps (within its
permissions — it may read contract prose and write regression tests).
If it cannot (locked files), ABORT with the gap report.
```

---

### Finding H4 [MEDIUM]: Checkpoint validation is advisory
**File:** `harden-completeness-prompt.template.md`, lines 184-225
**Section:** Step 5b (checkpoint gate)

**Current state:** Step 5b says "Do not append invalid entries" but then
allows `blocked_on_spec` entries that fail validation to be appended
anyway. There's no machine-verifiable validation — it's self-reported.

**What to change:** Make validation concrete and enforceable:

```markdown
**Checkpoint validation is MANDATORY, not advisory.**

After constructing each entry and BEFORE appending to prd.json, validate
using these exact checks (pseudo-code):

```python
def validate_completeness_entry(entry):
    errors = []

    # 1. Behavior sections
    behavior = entry.get('behavior', '')
    required_sections = [
        '## Acceptance Criteria', '## Out of Scope',
        '## Escalation Conditions', '## Risk Flags',
        '## Verification Anchors', '## Completeness Check',
        '## Builder Notes'
    ]
    for section in required_sections:
        if section not in behavior:
            errors.append(f"Missing behavior section: {section}")

    # 2. EARS format
    if 'SHALL' not in behavior:
        errors.append("No EARS criteria found (missing SHALL keyword)")

    # 3. fail_to_pass
    ftp = entry.get('fail_to_pass', [])
    if not isinstance(ftp, list) or len(ftp) == 0:
        errors.append("fail_to_pass must be a non-empty array")
    for name in ftp:
        if name.count('.') < 2:
            errors.append(f"fail_to_pass '{name}' not in module.feature.behavior format")

    # 4. Structured tests
    for test_type in ['unit', 'e2e', 'edge_cases']:
        tests = entry.get('tests', {}).get(test_type, [])
        for t in tests:
            if not isinstance(t, dict):
                errors.append(f"tests.{test_type} contains non-object")
            elif not all(k in t for k in ['name', 'description', 'source']):
                errors.append(f"tests.{test_type} entry missing required fields")

    # 5. fail_to_pass ↔ tests correspondence
    all_test_names = set()
    for t in entry.get('tests', {}).get('unit', []):
        all_test_names.add(t.get('name', ''))
    for t in entry.get('tests', {}).get('e2e', []):
        all_test_names.add('e2e.' + t.get('name', ''))
    for t in entry.get('tests', {}).get('edge_cases', []):
        all_test_names.add('edge.' + t.get('name', ''))
    for name in ftp:
        if name not in all_test_names:
            errors.append(f"fail_to_pass '{name}' has no corresponding test")

    return errors
```

If `validate_completeness_entry` returns errors:
- For `blocked_on_spec: true` entries: log errors, append anyway (human will fix)
- For all other entries: fix errors BEFORE appending. Do NOT append
  invalid non-blocked entries.

Log all validation results in completeness-progress.txt.
```

---

### Finding H5 [MEDIUM]: Mutation tests can game scores without testing behavior
**File:** `harden-prompt.template.md`, lines 59-78
**Section:** Test writing for surviving mutants

**Current state:** The agent writes tests to kill surviving mutants but
isn't required to map each test to a real behavior. Tests can be
implementation-shaped (testing internal details) rather than behavior-shaped.

**What to change:** Add a behavioral requirement after the test-writing
instructions:

```markdown
**Behavioral grounding requirement:**

Every test added to kill a surviving mutant MUST cite one of:
- A PRD story acceptance criterion (by DEC-NNN or story ID)
- A contract invariant (by contract feature name + invariant text)
- An externally observable behavior (by route, action, or UI element)

If a surviving mutant cannot be killed by a test grounded in real
behavior, it is likely an implementation detail that SHOULD survive.
Record it as `intentional_survivor` in the progress log with reasoning.

**Prohibited test patterns:**
- Tests that assert internal variable values not visible to users/API
- Tests that assert call counts on internal functions
- Tests that duplicate existing assertions with different syntax
- Tests whose only purpose is killing a specific mutant at a specific line

The goal is behavior coverage, not line coverage. A high mutation score
from implementation-shaped tests is worse than a moderate score from
behavior-shaped tests.
```

---

### Finding H6 [MEDIUM]: No verification that test weakening didn't occur
**File:** `harden-prompt.template.md`, lines 72-81
**Section:** Quality checks before commit

**Current state:** The agent runs Stryker, unit tests, tsc, and lint
before committing. But nothing checks whether existing tests were
weakened, deleted, or had assertions reduced.

**What to change:** Add a diff-audit step before the commit section:

```markdown
**Pre-commit diff audit (MANDATORY):**

Before committing, verify the diff does not weaken existing tests:

1. Run `git diff --stat` — check for deleted test files
2. Run `git diff -- '**/*.test.*' '**/*.spec.*'` — inspect test changes:
   - No `describe.skip`, `it.skip`, `xit`, `xdescribe` added
   - No `.only` added (accidentally scoping down the suite)
   - No assertion matchers weakened (e.g., `toBe` → `toBeTruthy`,
     `toEqual` → `toBeDefined`, `toThrow` → removed)
   - No `expect` calls removed from existing tests
   - No test files deleted
3. Count total assertions before and after (if JSON reporter available):
   `assertion_count_after >= assertion_count_before`

If any weakening is detected: ABORT. Do not commit. Record the
attempted weakening in progress.txt with the file and line.

**This check is non-negotiable.** The stop-rules say "never weaken a
test" — this step makes that rule mechanically verifiable instead of
self-reported.
```

---

## Success Criteria

1. Hard-contract completeness stories get `blocked_on_contract: true` and builder skips them
2. IS extractor gaps on `passes:true` stories are logged, not blindly re-appended
3. Drift detection audits contract coverage — DRIFT_COMPLETE blocked with uncovered invariants
4. Checkpoint validation uses concrete pseudo-code, not advisory prose
5. Mutation tests must cite a real behavior — implementation-shaped tests prohibited
6. Pre-commit diff audit mechanically detects test weakening

## Execution Order

1. H1 (blocked_on_contract) — adds field the builder already knows to skip
2. H2 (extractor confidence) — standalone, completeness prompt
3. H4 (concrete validation) — standalone, completeness prompt
4. H5 (behavioral grounding) — standalone, harden prompt
5. H6 (diff audit) — standalone, harden prompt
6. H3 (contract coverage audit) — standalone, drift prompt

## Commit Message

```
fix(harden): block uncontracted high-risk builds, extractor confidence check, contract coverage audit, behavioral test grounding, diff audit

6 findings from Codex adversarial review:
- H1: Hard-contract stories get blocked_on_contract (builder skips)
- H2: IS extractor gaps on passes:true stories logged, not re-appended
- H3: Drift requires contract coverage audit before DRIFT_COMPLETE
- H4: Checkpoint validation uses concrete checks, not advisory prose
- H5: Mutation tests must cite real behavior (no implementation-shaped tests)
- H6: Pre-commit diff audit detects test weakening mechanically

Found by: Codex adversarial review
```
