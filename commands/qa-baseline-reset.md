# qa-baseline-reset — Explicit ratchet-down (audit-logged)

Lowers a module's stored mutation baseline with a required reason. Every
reset is appended to `state.baseline_reset_log` with timestamp, old + new
values, reason, triggered_by, and approved_by fields — so every downward
adjustment is auditable.

Input: `$ARGUMENTS` — flags:
- `--module <path>` (required): the module path to reset.
- `--reason <text>` (required): why the reset is legitimate.
- `--new-baseline <score>` (required): new mutation score (0–100).
- `--approved-by <user>` (optional): defaults to `$USER`.

## Steps

```bash
npm run qa baseline-reset -- \
  --module=src/lib/payments/refund.ts \
  --reason="Refactor per PRD v2 invalidated old tests; rebuilding coverage" \
  --new-baseline=60 \
  --approved-by=shailesh
```

## When It's Legitimate

- Large refactor that invalidates existing tests and you're rebuilding.
- Contract version bump that changed the oracle for this module.
- Platform migration that replaced the module's underlying library.

## When It's NOT Legitimate

- "Agents keep failing to hit the floor and I want to keep shipping" — the
  whole point of the ratchet is to block this. Use `/playbook:qa-unblock`
  and debug why the agents are stuck.
- "I deleted the tests" — you need to add new ones, not lower the floor.

## Safety

- Without a valid `--reason`, the command fails.
- Without an approved_by, defaults to the current shell user.
- The `has_exceeded_floor` flag is NEVER cleared by a reset — once a module
  hit its tier floor, that fact is permanently recorded even if the current
  baseline drops back below.
