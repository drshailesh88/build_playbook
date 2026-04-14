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
