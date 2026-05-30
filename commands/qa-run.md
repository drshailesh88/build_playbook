# qa-run — Run the full QA session

Orchestrates the hardened QA pipeline: preflight → session lock → full Stryker
baseline → per-feature repair loop → release gates → deterministic summary.

Input: `$ARGUMENTS` — optional flags (`--feature=<id>`, `--category=<cat>`,
`--skip-release-gates`, `--skip-baseline-stryker`, `--no-notification`).

## What It Does

1. **R-2 preflight** (blueprint 9.2):
   - Stale lock check (dead PID → clear and log; alive PID → abort).
   - Dirty working tree → hard error; commit or stash first.
   - Abandoned runs (no `summary.md`) → moved to `.quality/runs/abandoned/`.
   - Stryker cache freshness check.
   - state.json parse integrity.

2. **Session lock** acquired at `.quality/state.lock` with PID.

3. **Full Stryker baseline** — measures overall mutation score for the
   Baseline → Final summary table.

4. **Feature enumeration + category gate** (blueprint 12d):
   - `auth`, `payments`, `user_data` → must be `status: frozen` or hard error.
   - `business_logic`, `ui` → skip-with-warning if not frozen.

5. **Per-feature loop** (serial, max 10 attempts per feature):
   - Build repair packet (F4 with hypothesis + codebase context).
   - Invoke Claude fixer in fresh session.
   - Diff audit (regex + AST + hardcoded-return).
   - Fast-repair gates 1–14 with short-circuit rules.
   - Judge → GREEN / IMPROVED_NOT_GREEN / REGRESSED / VIOLATION / BLOCKED.
   - Plateau detection (3 identical signatures → BLOCKED).

6. **Release gates** (parallelization groups per Part 5.4):
   - Full Stryker alone → gates 2–13 concurrent → contract hash alone last.
   - Verdict: GREEN / WARN / RED / HARD.

7. **Deterministic summary.md** (Part 11) + `state-delta.json`.

8. **Commit state** (`chore(qa): state update after <run-id>`).

9. **Release lock** + macOS notification + `open summary.md`.

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

## Use When

- You want to run the full pipeline.
- You want an overnight session (long releases loops).
- You want the canonical session-end verdict.

## Steps

```bash
npm run qa run
# or with filters:
npm run qa run -- --feature=auth-login
npm run qa run -- --category=payments
npm run qa run -- --skip-release-gates  # dev speed
```

## After It Finishes

- Read `.quality/runs/<run-id>/summary.md` (auto-opens on macOS).
- Review any BLOCKED features or WARN-level release gates.
- Investigate violations in `violations.jsonl` (if any).
