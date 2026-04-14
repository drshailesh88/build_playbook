# wire-selectors — Adjust data-testid selectors to match the DOM

Tight-scope selector fix-up (blueprint T3). The agent is permitted to READ
only the feature's UI source and the acceptance spec, and may EDIT ONLY the
spec's `data-testid` selectors. Assertions are locked — the controller runs
a diff check afterward that rejects any `expect()` change.

Input: `$ARGUMENTS` — feature name.

## What It Does

1. Swaps in `.claude/settings-selector-wiring.json` (tight permissions:
   reads to the feature's app/components source, writes to the acceptance
   spec only).
2. Invokes Claude with the current failing selectors + the DOM excerpts.
3. Claude adjusts `data-testid` strings to match actual DOM.
4. Controller computes the diff; if any `expect()` line changed, the whole
   edit is rejected.
5. Swaps settings back.

## Steps

```bash
/playbook:wire-selectors auth-login
```

## Safeguards

- Diff check post-wiring rejects assertion changes (ONLY selectors may move).
- Cannot read `.quality/` contracts during this operation (the oracle stays
  frozen).
- Cannot edit source (you're adjusting the TEST, not the app).

## When To Use

- Right after `/playbook:author-locked-tests` — the first run will fail on
  selector mismatches; this command resolves them without leaking the
  source-code behavior into the test assertions.
