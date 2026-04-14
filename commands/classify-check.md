# classify-check — Verify tiers.yaml covers every source file

Walks the target app's source tree (`src/`, `app/`, `lib/`, `components/`,
`pages/`) and prints any file that does NOT match a glob in
`.quality/policies/tiers.yaml`.

This is what `qa-doctor`'s tiers-coverage check runs — this command lets you
run it in isolation + get a clean file list.

## Steps

```bash
/playbook:classify-check
```

## Output

```
5 unclassified source files:
  src/utils/legacy.ts
  src/helpers/one-off.ts
  app/admin/diagnostic.tsx
  app/api/health/route.ts
  lib/deprecated-adapter.ts

Add these to a tier in .quality/policies/tiers.yaml or delete them.
```

## Exit Codes

- 0 — every source file is classified.
- 1 — unclassified files exist.

## Use When

- Right after `classify-modules` to confirm coverage.
- In a pre-push git hook.
- Before the first `qa-run` (qa-run aborts on unclassified + fail_fast).
