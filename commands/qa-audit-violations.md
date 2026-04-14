# qa-audit-violations — Aggregate cheating attempts across all runs

Walks every `.quality/runs/<id>/violations.jsonl` file and aggregates by
pattern ID. Useful for:

- Spotting which anti-cheat patterns fire most often (signal that a fixer
  agent has a habit).
- Auditing over time — every rejected cheating attempt is preserved.
- Evidence for any post-mortem ("the fixer tried SKIP_ADDED 7 times across
  3 runs before we caught the upstream design issue").

## Steps

```bash
npm run qa audit-violations
```

## Output

```
audit: 11 violations across 3/42 runs
  SKIP_ADDED: 5 occurrences across 2 run(s)
  EXPECT_REMOVED_NET: 3 occurrences across 2 run(s)
  MATCHER_WEAKENED: 2 occurrences across 1 run(s)
  HARDCODED_SUCCESS_RETURN: 1 occurrence across 1 run(s)
```

## Interpretation

- A pattern appearing across MANY runs = a systemic issue (maybe the fixer
  prompt lacks a counterexample, or the underlying model defaults to this
  shortcut).
- A pattern appearing ONCE with a high count = one stuck feature; investigate
  that feature specifically via `qa-report <run-id>`.
