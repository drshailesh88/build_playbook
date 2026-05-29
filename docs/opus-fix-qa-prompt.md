# Opus 4.7 Task: Fix 5 Adversarial Findings in qa-prompt.template.md

## Your Role

You are editing a prompt template that the QA grader agent follows when
verifying each built story. This file is NOT code — it's instructions for
an LLM. Every change you make changes how future QA verification behaves.

## System Context

The Build Playbook pipeline:

```
grill-me → write-a-prd → prd-to-ralph → build-prompt → [qa-prompt] → harden → release gates
                                                           ^^^
                                                       YOU ARE HERE
```

**Upstream (build-prompt produces):** A built feature with `passes:true`
in prd.json, committed code, and tests named per `fail_to_pass`.

**Downstream (qa-run expects):** `qa-report.json` entries with: story_id,
verdict, bugs (array), acceptance_criteria_checks, fail_to_pass_checks,
out_of_scope_checks. The release gate counts bugs and checks verdict
to determine ship readiness.

**Key invariant:** QA is an INDEPENDENT verifier. It must produce
mechanically auditable evidence, not self-attested pass/fail claims.

## File to Modify

**`playbook/qa-scaffold/templates/ralph/qa-prompt.template.md`** (253 lines)

## Constraints

- Do NOT restructure the file. Fix each finding surgically.
- Do NOT change the QA agent's core workflow (pick story, verify, report).
- All fixes go into qa-prompt.template.md.
- Preserve existing markdown formatting style.

---

## FINDINGS TO FIX

### Finding Q1 [HIGH]: EARS acceptance checks are self-attested
**File:** `qa-prompt.template.md`, lines 110-158
**Section:** Acceptance criteria verification

**Current state:** The grader parses WHEN/SHALL criteria and records
pass/fail in the report, but doesn't require evidence artifacts (exact
command run, observed output, screenshot path). A grader can mark every
criterion as pass without proving execution.

**What to change:** After the existing acceptance criteria verification
instructions, add an evidence requirement:

```markdown
**Evidence requirement for each EARS criterion:**

For every acceptance criterion, the QA report entry MUST include:

| Field | Content |
|-------|---------|
| `criterion` | The full EARS text |
| `trigger` | Parsed WHEN/IF/WHILE clause |
| `expected` | Parsed SHALL clause |
| `verification_method` | How verified: "unit_test", "e2e_test", "manual_browser", "api_call" |
| `command_or_action` | Exact command, URL, or browser action performed |
| `observed_result` | What actually happened (output snippet, status code, UI state) |
| `result` | "pass" or "fail" |
| `evidence_path` | Path to screenshot, test output file, or "inline" if observed_result is sufficient |

**qa_tested:true is BLOCKED** unless every acceptance criterion has all
evidence fields populated AND result=pass. A criterion with result=pass
but empty observed_result or command_or_action is invalid.
```

---

### Finding Q2 [HIGH]: fail_to_pass oracle satisfied by skipped/trivial tests
**File:** `qa-prompt.template.md`, lines 86-104
**Section:** fail_to_pass oracle verification

**Current state:** Oracle verification uses grep against verbose test
output — a skipped test or `expect(true).toBe(true)` with the right
name satisfies it.

**What to change:** Replace the grep-based verification with structured
parsing:

```markdown
**fail_to_pass verification (structured, not grep):**

1. Run the test suite with a JSON reporter:
   `npm run test:run -- --reporter=json 2>test-results.json`
   (Fall back to `--reporter=verbose` only if JSON is unavailable)

2. For each pinned test name in `fail_to_pass`:
   a. Find the test in the JSON output by exact name match
   b. Verify `status === "passed"` (not "skipped", "pending", or "failed")
   c. Verify the test contains at least one assertion (`assertionCount > 0`
      or `numPassingAsserts > 0`)
   d. Record in the report: test_name, status, assertion_count, duration_ms

3. A pinned test is UNSATISFIED if:
   - It does not exist in the output (missing)
   - Its status is not "passed" (failed/skipped/pending)
   - It has zero assertions (trivial/stub test)

4. **qa_tested:true is BLOCKED** if ANY pinned test is unsatisfied.

Do NOT use grep against text output as the primary verification method.
Grep cannot distinguish a passing test from a failing test that prints
the same name.
```

---

### Finding Q3 [HIGH]: Out-of-scope violations don't block qa_tested:true
**File:** `qa-prompt.template.md`, lines 54-56
**Section:** Out-of-scope verification

**Current state:** QA records out-of-scope violations as bugs but can
still flip qa_tested:true. Forbidden behavior can ship as "known bug."

**What to change:** Add a hard blocking rule:

```markdown
**Out-of-scope violations are SHIP-BLOCKING:**

If the `## Out of Scope — DO NOT BUILD THESE` section lists excluded
behaviors, and the implementation contains ANY of them:

1. Record each violation in `out_of_scope_checks.violations`
2. Set `verdict: "fail"` — not "pass_with_bugs" or "conditional"
3. **qa_tested:true is BLOCKED** until all out-of-scope violations are
   removed from the implementation

Out-of-scope items are prohibitions, not warnings. The builder must
remove the forbidden behavior. QA must not accept it as a known bug.

The QA agent must NOT remove the over-built code itself — record the
violation, set verdict=fail, and let the builder fix it in the next
build iteration.
```

---

### Finding Q4 [MEDIUM]: Only 4 of 7 behavior sections verified
**File:** `qa-prompt.template.md`, lines 143-188
**Section:** Behavior section verification

**Current state:** Detailed verification exists for: acceptance criteria,
out-of-scope, verification anchors, fail_to_pass. Missing: escalation
conditions, completeness check, builder notes.

**What to change:** Add verification rules for the 3 missing sections.
Insert after the existing verification sections:

```markdown
**Escalation condition verification:**

Read `## Escalation Conditions — STOP AND ABORT IF`. For each condition:
1. Determine if the condition is testable from the built code
2. If testable: verify the implementation would abort/escalate when the
   condition triggers. Record in `escalation_checks`:
   `{ condition, testable: true, verified: true/false, method }`
3. If not testable from code alone: record as
   `{ condition, testable: false, reason }` — this is not a failure,
   but it must be logged
4. If the builder SHOULD have hit an escalation condition but didn't
   abort: this is a HIGH severity bug

**Risk flag verification:**

Read `## Risk Flags`. If any decision has LOW confidence or HARD
reversibility:
1. Verify the implementation uses reversible patterns (feature flags,
   abstraction layers, migration rollback) where the risk flag suggests
2. Record in `risk_flag_checks`:
   `{ flag, mitigation_found: true/false, details }`

**Builder notes verification:**

Read `## Builder Notes`. For each note:
1. Check whether the implementation follows the stated constraint
2. Record in `builder_note_checks`:
   `{ note, followed: true/false, details }`
3. A violated builder note is a MEDIUM severity bug
```

---

### Finding Q5 [MEDIUM]: QA report schema mismatches runner expectations
**File:** `qa-prompt.template.md`, lines 179-188
**Section:** QA report JSON schema

**Current state:** The template uses `bugs_found` and `verdict` but the
qa.sh runner reads `bugs` and `status`. This causes undercounted bugs
and `?` statuses downstream.

**What to change:** Find the QA report JSON template/schema section and
align field names. The runner is the downstream consumer, so the grader
must match the runner's expectations:

```markdown
**QA report entry schema (MUST match exactly):**

```json
{
  "story_id": "<story ID from prd.json>",
  "status": "pass | fail | conditional",
  "bugs": [],
  "acceptance_criteria_checks": {
    "total": 0, "passed": 0, "failed": 0,
    "details": []
  },
  "fail_to_pass_checks": {
    "total": 0, "satisfied": 0, "unsatisfied": 0,
    "details": []
  },
  "out_of_scope_checks": {
    "violations": [], "clean": true
  },
  "escalation_checks": [],
  "risk_flag_checks": [],
  "builder_note_checks": [],
  "verification_anchor_checks": {
    "route_exists": true, "action_exists": true, "ui_exists": true
  }
}
```

**Field naming is contractual.** Use `status` not `verdict`. Use `bugs`
not `bugs_found`. The qa.sh runner and qa-run release gates parse these
exact field names.
```

---

## Success Criteria

1. Every EARS criterion requires evidence (command, observed result, evidence path)
2. fail_to_pass uses structured JSON parsing, not grep — verifies status=passed + assertion_count > 0
3. Out-of-scope violations hard-block qa_tested:true
4. All 7 behavior sections have verification rules and report fields
5. QA report schema matches runner expectations exactly

## Execution Order

1. Q5 (schema alignment) — defines the report structure all other fixes reference
2. Q1 (EARS evidence) — adds detail fields to the schema
3. Q2 (structured fail_to_pass) — adds detail fields to the schema
4. Q3 (out-of-scope blocking) — references the schema's verdict/status field
5. Q4 (missing behavior sections) — adds new report sections

## Commit Message

```
fix(qa-prompt): evidence-backed EARS checks, structured test parsing, out-of-scope blocking, full behavior verification

5 findings from Codex adversarial review:
- Q1: EARS criteria require evidence artifacts (command, observed result, path)
- Q2: fail_to_pass uses JSON reporter parsing, not grep — verifies passed + assertions
- Q3: Out-of-scope violations hard-block qa_tested:true
- Q4: All 7 behavior sections now have verification rules
- Q5: Report schema aligned with runner (status/bugs, not verdict/bugs_found)

Found by: Codex adversarial review
```
