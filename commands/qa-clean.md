# qa-clean — Clear stale locks + archive old runs

Housekeeping command:

1. Clears `.quality/state.lock` if its PID is dead (R-2 stale-lock recovery).
2. Archives heavy artifacts (`evidence/`, `fixer-notes/`, `traces/`,
   `stryker-html/`, `playwright-report/`) from runs older than
   `--retention-days` (default: 30).
3. Preserves `summary.md` and `state-delta.json` forever — those are the
   committed audit record.

Input: `$ARGUMENTS` — optional `--retention-days=<n>`.

## Steps

```bash
npm run qa clean                         # 30-day retention (default)
npm run qa clean -- --retention-days=7   # aggressive cleanup
```

## Output

```
clean: staleLockCleared=true archived=5 retained=12
```

## Use When

- Run directory is getting large.
- You killed a `qa-run` process and the lock is stuck.
- Before committing heavy runs (archives unwanted artifacts before `git add`).
