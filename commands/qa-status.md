# qa-status — Current QA state snapshot

Reads `state.json` and prints:
- Feature counts (green / blocked / pending / in-progress).
- Modules with their tier, baseline, floor, and below-floor flag.
- Latest test-count history per runner.

Fast, no subprocess calls. Safe to run any time.

## Steps

```bash
npm run qa status
```

## Output

```
last run: run-2026-04-14-001
features: 6 green / 1 blocked / 0 pending / 0 in-progress
modules: 18 tracked, 2 below floor
  src/lib/payments/refund.ts [critical_75]: 58% vs floor 75%
  src/auth/rotation.ts       [critical_75]: 70% vs floor 75%
```

## Use When

- You want a quick health check.
- You need a reminder of which features are blocked.
- You want to identify modules that need mutation-strengthening work.
