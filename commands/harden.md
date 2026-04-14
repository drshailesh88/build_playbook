# harden — DEPRECATED

This command used to be `census → specs → test → heal`. It has been
**replaced by the hardened QA pipeline**.

## Use instead

```
/playbook:qa-run       # Full session
/playbook:qa-report    # Post-run summary
```

The new pipeline does everything harden did, but with:

- **Mechanical oracle enforcement** (contracts SHA256-hashed; tampering blocks
  the run)
- **Real tool execution** (tsc + ESLint + Knip + Vitest + Playwright + Stryker
  + axe + Lighthouse + visual regression + API contract validation + bundle
  + license + npm audit, all run via subprocess by the controller)
- **Short-circuit integrity checks** (contract-tamper and data-corruption
  signals abort immediately — no wasted cycles)
- **Deterministic reporting** (blueprint Part 11 summary.md; no LLM narration)

See `docs/qa-pipeline-blueprint.md` for the full architecture.

Historical version preserved at `commands/deprecated/harden.md`.
