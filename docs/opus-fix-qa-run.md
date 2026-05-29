# Opus 4.7 Task: Fix 4 Adversarial Findings in qa-run.md

## Your Role

You are editing the release gate command — the final checkpoint that
decides whether the app ships. This is the most consequential file in
the pipeline: a false-positive GREEN means broken software goes live.
This file is instructions for an LLM agent, not code.

## System Context

The Build Playbook pipeline:

```
grill-me → write-a-prd → prd-to-ralph → build-prompt → qa-prompt → harden → [qa-run]
                                                                                ^^^
                                                                            YOU ARE HERE
```

**Upstream inputs qa-run consumes:**
- `ralph/prd.json` — all stories with passes/qa_tested flags
- `ralph/qa-report.json` — QA grader findings per story
- `.quality/contracts/*/index.yaml` — frozen contracts with status
- `.quality/contracts/*/acceptance.spec.ts` — contract test files
- Stryker mutation reports (from harden-prompt)
- Vitest/Playwright test results
- Harden loop reports (completeness, drift, adversarial, security)

**Output:** `summary.md` — the ship/no-ship verdict with evidence.

**Key invariant:** The release gate MUST fail closed. Missing evidence =
RED, not GREEN. Skipped gates = RED, not invisible. The summary must
accurately represent what was verified vs what was skipped.

## File to Modify

**`commands/qa-run.md`** (65 lines)

**Note:** This file is short — it's a high-level command spec. The actual
gate logic lives in `playbook/qa-scaffold/controller/gates/release-runner.ts`
and related TypeScript files. Your job is to update the COMMAND SPEC to
define the correct behavior. The TypeScript implementation will be updated
separately to match. Make the spec unambiguous so the implementation has
no room for misinterpretation.

## Constraints

- Do NOT modify TypeScript files. Only update `commands/qa-run.md`.
- Do NOT remove existing functionality. All fixes are additive.
- The command spec must be precise enough that a developer implementing
  it has zero ambiguity about fail-closed behavior.
- Preserve existing markdown formatting style.

---

## FINDINGS TO FIX

### Finding X1 [CRITICAL]: GREEN verdict with most gates skipped
**File:** `commands/qa-run.md`, lines 35-38
**Section:** Release verdict logic

**Current state:** The release runner computes GREEN when no gate FAILED —
but missing/skipped gates are not counted as failures. The test suite
itself skips every gate except contract-hash and expects GREEN. Minimum
evidence to pass: just a contract-hash check (which passes with zero
contracts).

**What to change:** Add a mandatory gate manifest and fail-closed rule.
This is the most important fix — it changes the fundamental verdict logic:

```markdown
## Release Verdict Logic — Fail Closed

The release verdict MUST fail closed. Missing evidence is RED, not GREEN.

**Required gate manifest (ALL must run and pass for GREEN):**

| Gate | Source | Required |
|------|--------|----------|
| Unit tests | Vitest exit code 0, all `fail_to_pass` satisfied | YES |
| Type check | `tsc --noEmit` exit code 0 | YES |
| Lint | `lint` exit code 0 | YES |
| Contract integrity | Every `.quality/contracts/*/index.yaml` with `status: frozen` has matching hash | YES (if any contracts exist) |
| Category gate | Every auth/payments/user_data feature has a frozen contract | YES |
| Mutation score | Stryker baseline met for every module with a baseline file | YES (if baselines exist) |
| QA completeness | Every `passes:true` story has `qa_tested:true` + qa-report entry | YES |

**Verdict rules:**
- **GREEN:** ALL required gates ran AND passed with non-empty evidence
- **YELLOW:** All gates ran, but WARN-level issues exist (e.g.,
  business_logic features without contracts)
- **RED:** ANY required gate failed, was skipped, or produced no evidence

**There is no skip mechanism in ship mode.** `--skip-release-gates` is
for development debugging ONLY and MUST print a prominent warning:
"SKIPPED GATES — this verdict is NOT valid for shipping."

A verdict produced with any skipped required gate MUST be labeled
`"INVALID — gates skipped"`, not GREEN.
```

---

### Finding X2 [HIGH]: Category gate only checks existing contracts
**File:** `commands/qa-run.md`, lines 23-25
**Section:** Category gating

**Current state:** The category gate checks `status: frozen` on contracts
that exist in `.quality/contracts/`. But if a high-risk feature never got
a contract directory at all, it's invisible — no directory means no check.

**What to change:** Add feature inventory cross-check:

```markdown
## Category Gate — Feature Inventory Cross-Check

The category gate MUST NOT rely solely on discovered contract directories.
It must cross-check against the feature inventory:

1. **Build the feature inventory** from `ralph/prd.json`:
   - Every story with `passes:true` that has `risk_domain` in
     ["auth", "payments", "user_data"] OR `contract_needed: true` with
     `contract_category_gate: "hard"`

2. **For each feature in the inventory:**
   - Check if `.quality/contracts/{feature}/index.yaml` exists
   - If missing: **HARD ERROR** — "Feature {id} (category: {cat}) has
     no contract directory. Run `/playbook:contract-pack {id}` first."
   - If exists but `status` is not `frozen`: **HARD ERROR** —
     "Contract for {id} exists but is not frozen (status: {status})."
   - If exists and frozen: check hash integrity (existing logic)

3. **For WARN-level features** (`contract_category_gate: "warn"`):
   - Same check but produces WARNING, not HARD ERROR
   - Listed in summary as "uncontracted features (WARN)"

This ensures that a payment feature the builder built but nobody ran
contract-pack on produces a HARD ERROR, not silence.
```

---

### Finding X3 [HIGH]: Summary claims verification when evidence is empty
**File:** `commands/qa-run.md`, line 39
**Section:** summary.md output

**Current state:** The summary writer can print "all hashes verified"
when zero contracts were checked, or claim verification happened when
gates were skipped.

**What to change:** Define an evidence matrix requirement:

```markdown
## Summary Evidence Matrix

`summary.md` MUST include an evidence matrix showing what was actually
verified:

```markdown
## Evidence Matrix

| Gate | Status | Items Checked | Items Passed | Items Failed | Artifact |
|------|--------|--------------|-------------|-------------|----------|
| Unit tests | RAN | 47 | 47 | 0 | test-results.json |
| Type check | RAN | 1 | 1 | 0 | — |
| Lint | RAN | 1 | 1 | 0 | — |
| Contract integrity | RAN | 3 | 3 | 0 | .quality/contracts/ |
| Category gate (HARD) | RAN | 2 | 2 | 0 | — |
| Category gate (WARN) | RAN | 1 | 0 | 1 | — |
| Mutation baselines | RAN | 4 | 4 | 0 | .quality/baselines/ |
| QA completeness | RAN | 8 | 8 | 0 | qa-report.json |
```

**Rules for the evidence matrix:**
- Status must be one of: `RAN`, `SKIPPED`, `NOT_APPLICABLE`, `ERROR`
- `Items Checked` must be > 0 for `RAN` status (except type check/lint
  which are binary)
- If `Items Checked` is 0 and Status is `RAN`: change Status to
  `EMPTY — no items to check` and do NOT count this as a passing gate
- `SKIPPED` gates must show why (e.g., "—skip-release-gates flag")
- The summary MUST NOT contain affirmative statements ("all verified",
  "hashes match") for gates with Status != `RAN` or Items Checked == 0

**Affirmative claims require evidence.** "Contract integrity verified"
requires ≥1 contract checked. "Mutation baselines met" requires ≥1
baseline checked. Zero-item gates produce neutral statements: "No
contracts found to verify."
```

---

### Finding X4 [MEDIUM]: Harden loop outcomes not consumed
**File:** `commands/qa-run.md`, lines 3-4
**Section:** Overall release session description

**Current state:** qa-run only feeds feature-loop results and release
gate results into the summary. Harden loop reports (mutation, security,
adversarial, drift, completeness) are not ingested. A release can be
GREEN while harden loops have unresolved findings.

**What to change:** Add harden report ingestion:

```markdown
## Harden Report Ingestion

Before computing the release verdict, check for harden loop reports:

| Report | Path | Blocking? |
|--------|------|-----------|
| Completeness | `ralph/completeness-report.json` | YES if `blocked_on_spec` or `blocked_on_contract` entries exist |
| Drift | `ralph/drift-report.json` or `.quality/drift/` | YES if unresolved drift findings |
| Security | `ralph/security-report.json` | YES if HIGH/CRITICAL unresolved |
| Adversarial | `ralph/adversarial-report.json` | WARN if unresolved |

**For each report that exists:**
1. Parse for unresolved/blocking findings
2. Add a row to the evidence matrix
3. If blocking: set verdict to RED with diagnostic

**For each expected report that does NOT exist:**
- If the corresponding harden loop was run (check git log for
  HARDEN:/COMPLETENESS:/DRIFT:/SECURITY: commits): WARN — "harden loop
  ran but no report found"
- If the harden loop was never run: INFO — "harden loop not run"
  (not blocking, but noted in summary)

The release verdict should reflect the FULL quality picture, not just
the feature loop and release gates.
```

---

## Success Criteria

1. Release verdict fails closed — missing/skipped gates produce RED, not GREEN
2. Category gate cross-checks prd.json feature inventory, not just existing contract directories
3. Summary evidence matrix shows exactly what ran, what passed, what was skipped, with item counts
4. Harden loop reports are ingested and blocking findings prevent GREEN verdict

## Execution Order

1. X1 (fail-closed verdict) — foundational change, everything else references it
2. X2 (feature inventory cross-check) — adds a required gate
3. X4 (harden report ingestion) — adds more required gates
4. X3 (evidence matrix) — renders all gates including new ones

## Commit Message

```
fix(qa-run): fail-closed release verdict, feature inventory category gate, evidence matrix, harden report ingestion

4 findings from Codex adversarial review (1 critical, 2 high, 1 medium):
- X1: Release verdict fails closed — missing/skipped gates = RED
- X2: Category gate cross-checks prd.json feature inventory, not just existing contracts
- X3: Summary evidence matrix shows ran/skipped/empty with item counts
- X4: Harden loop reports ingested — blocking findings prevent GREEN

Found by: Codex adversarial review
```
