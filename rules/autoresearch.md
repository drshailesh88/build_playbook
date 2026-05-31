---
description: Governs behavior during metric-driven improvement loops (/improve, /lazy-dev). Prevents metric gaming, enforces atomic commits, and ensures cross-metric safety.
---

# Autoresearch Rules

These rules are active during any improvement loop invoked by `/improve` or `/lazy-dev`. They supplement the existing coding-style, testing, and security rules.

## The Loop Contract

Every iteration follows this exact sequence:

1. Run `./scripts/score.sh <metric>` — record the baseline
2. Diagnose the highest-impact opportunity
3. Make ONE atomic change (single concern, minimal diff)
4. Run `./scripts/score.sh <metric>` — record the result
5. Check guard metrics (see below)
6. If improved AND guards pass → `git add && git commit`
7. If regressed OR guard violated → `git checkout -- . && git clean -fd`
8. Log the iteration to `.quality/goals/iterations-<metric>-active.jsonl`
9. Repeat until target met, stall detected, or max iterations reached

## Commit Format

```
[S:OLD->NEW] component: what changed
```

Example: `[S:72->78] auth: add missing branch tests for token refresh`

## What You Must Never Do

1. Fabricate a score — always run the actual `./scripts/score.sh` command
2. Delete or weaken a test to improve a metric
3. Modify locked config files (tsconfig.json, eslint.config.*, vitest.config.*, playwright.config.*)
4. Edit files locked by the current phase (see File Locking below)
5. Make multiple unrelated changes in one iteration
6. "Fix" a broken revert — revert cleanly, log it, move on
7. Modify `scripts/score.sh` to inflate scores (Split mode: you may fix measurement bugs, never redefine what "good" means)
8. Run improvement loops on Tier 1 modules without human supervision

## File Locking by Phase

| Phase (metric) | Editable | Locked (READ-ONLY) |
|---------------|----------|-------------------|
| tsc-errors, eslint | Source code (`src/`, `app/`, `lib/`) | Test files (`*.test.*`, `*.spec.*`, `__tests__/`) |
| coverage, mutation | Test files only | Source code |
| axe, lighthouse-*, playwright | Source code | Test files |

The active phase is recorded in `.quality/goals/GOAL.md`. Respect the file map section.

## Guard Metrics

Every improvement loop defines guard metrics that must NOT regress:

| Target Metric | Guard (must not drop) |
|---------------|----------------------|
| coverage | Test count must not decrease |
| mutation | Test count must not decrease, coverage must not drop |
| lighthouse-perf | Accessibility must stay >= 90 |
| lighthouse-a11y | Performance must stay >= current |
| tsc-errors | All existing tests must pass |
| eslint | All existing tests must pass |
| axe-violations | All existing tests must pass |

If a guard metric is violated, revert immediately. Do not attempt to fix both metrics in one iteration.

## Stall Detection

Stop the loop when ANY of these is true:

- 3 consecutive iterations with < 0.5% improvement (diminishing returns)
- Target score reached
- Max iterations hit (Quick: 5, Moderate: 10, Aggressive: 20)
- Build or test suite fails after revert (environment is broken)

## Module Tier Rules

| Tier | Operating Mode | Evaluator | Constraint |
|------|---------------|-----------|------------|
| Tier 1 (auth, payments, data) | Supervised | Locked | Pause for human approval before each commit |
| Tier 2 (core features) | Converge | Split | Stop at target, no overnight |
| Tier 3 (UI, utils, helpers) | Continuous | Split | Run until stall, overnight OK |

Never run Tier 1 modules in unattended/overnight mode. This is non-negotiable.

## Revert Protocol

If a change causes ANY of these, revert immediately:

```bash
git checkout -- . && git clean -fd
```

Triggers:
- Build failure (`tsc --noEmit` exits non-zero)
- Test failure (any test runner exits non-zero)
- Target metric regression (score went down)
- Guard metric violation (guard dropped below threshold)
- File-lock violation (edited a locked file)

After reverting, log the iteration as "reverted" with a one-sentence note explaining why. Then continue to the next iteration with a different approach.

## Iteration Log Format

Each iteration appends one JSON line to `.quality/goals/iterations-<metric>-active.jsonl`:

```json
{"iteration": 1, "before": 72, "after": 78, "action": "added branch tests for token refresh", "result": "kept", "guard_ok": true, "timestamp": "2026-05-31T10:00:00Z"}
```

```json
{"iteration": 2, "before": 78, "after": 76, "action": "attempted to merge duplicate test setup", "result": "reverted", "guard_ok": true, "timestamp": "2026-05-31T10:05:00Z"}
```

## Relationship to QA Harness

Autoresearch runs BETWEEN QA harness runs, never instead of them. The sequence:

1. QA harness run → identifies shortfalls
2. `/improve` or `/lazy-dev` → drives metrics toward targets
3. QA harness run again → regression check (full, independent)

The QA harness is the source of truth. Autoresearch is the improvement engine.
