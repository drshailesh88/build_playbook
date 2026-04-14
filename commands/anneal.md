# anneal — DEPRECATED

This command was part of the first-generation testing approach and has been
**replaced by the hardened QA pipeline**.

## Use instead

```
/playbook:qa-run
```

The new pipeline subsumes anneal's self-healing test loop with real enforcement:

- **Locked surfaces** (agent cannot edit tests, configs, contracts)
- **Diff auditing** (cheating patterns like `.skip`, weakened assertions,
  snapshot laundering are detected and rejected)
- **Outcome-based verification** (harness runs tests via subprocess, not the
  agent — the entity that writes code never declares it works)
- **Mutation ratcheting** (mutation score is monotonic; regressions block)

See `/playbook:qa-run --help` for the migration path, or `docs/qa-pipeline-blueprint.md` for the full design.

Historical version of this command is preserved at
`commands/deprecated/anneal.md`. **Do not invoke the deprecated/ path** — it
bypasses the hardened pipeline and will be removed in a future version.
