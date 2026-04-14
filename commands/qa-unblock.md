# qa-unblock — Reset a BLOCKED feature

Transitions a feature from `status: blocked` → `status: pending` in
`state.json` and clears its plateau buffer so the next `qa-run` will retry
the feature.

Input: `$ARGUMENTS` — **required** feature ID (e.g. `payment-refund`).

## Steps

```bash
npm run qa unblock payment-refund
```

## Safeguards

- Errors if the feature ID isn't in `state.json`.
- Errors if the feature isn't currently `blocked` (no-op prevention — you
  probably shouldn't reset a green feature).

## Use When

- You've investigated a BLOCKED feature, fixed the upstream problem (adjusted
  a contract, added a missing test fixture, fixed a real bug), and want the
  controller to retry on the next run.

## What It Does NOT Do

- Does NOT modify any code. The controller will still run its full gate
  chain on the next attempt.
- Does NOT reset mutation baselines. Those are sticky via the ratchet; use
  `/playbook:qa-baseline-reset` if you need to lower one.
