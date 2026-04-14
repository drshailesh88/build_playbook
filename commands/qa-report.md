# qa-report — Open a run report

Without arguments: lists all run directories with their verdict line (parsed
from each `summary.md`). With a `<run-id>` argument: prints that run's full
`summary.md` to stdout.

Input: `$ARGUMENTS` — optional run id.

## Steps

```bash
npm run qa report                          # list all runs
npm run qa report run-2026-04-14-001       # print specific run
```

## Use When

- You want to find which runs are green vs blocked.
- You want to re-read an overnight run's full verdict + Next Actions.
- You want to share a summary with a reviewer or put it into a commit
  message.

## Note

Every summary.md is produced by the deterministic template (blueprint
Part 11). No LLM writes any part of the report.
