# qa-doctor — Drift check

Runs five drift checks and prints a structured report:

1. **Deprecated commands** — flags `anneal.md`, `harden.md`, `spec-runner.md`,
   `anneal-check.md` present in `commands/` (should be stubs or moved to
   `commands/deprecated/`).
2. **Contract hashes** — recomputes SHA256 of every artifact declared in
   `index.yaml` and flags mismatches.
3. **Tiers coverage** — walks `src/`, `app/`, `lib/`, `components/`,
   `pages/` and flags any file with no matching tier glob (6b.iii fail-fast).
4. **Providers policy** — flags if `active_fixer` is in the `disabled` list.
5. **Detected services** — compares `detected-services.yaml` to current
   `package.json` deps; warns when service is in the detected list but the
   package is gone (or vice versa).

Exit code: 0 if no errors (warn-level issues allowed), 1 if any error-level
issue is present.

## Steps

```bash
npm run qa doctor
```

## Use When

- After upgrading the playbook or controller.
- After editing `tiers.yaml` or `providers.yaml`.
- Before a release to catch drift you forgot about.
