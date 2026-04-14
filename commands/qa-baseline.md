# qa-baseline — Populate mutation baselines

Runs full Stryker and populates per-module mutation baselines in
`state.json`. Use when bootstrapping a fresh install or after a large refactor.

Input: `$ARGUMENTS` — optional `--module=<path>` for single-module refresh.

## What It Does

1. Runs `npx stryker run` (full, not incremental).
2. Parses `reports/mutation/mutation.json`.
3. For each file with a valid score, applies a mutation measurement via
   `applyMutationMeasurement` (ratchet-up only).
4. Writes state.json.

Unclassified files (no tier glob match) are skipped — run `qa-doctor` to
find them.

## Steps

```bash
npm run qa baseline              # full project
npm run qa baseline -- --module=src/auth/login.ts  # single module refresh
```

## Use When

- Immediately after `install-qa-harness`.
- After a large refactor where existing baselines need refresh.
- Before the first `qa-run` so the ratchet has something to compare against.

## Downward Baselines

This command is **ratchet-up only**. If the new score is LOWER than the
stored baseline, the measurement is silently skipped. Use
`/playbook:qa-baseline-reset` with an explicit reason to lower a baseline.
