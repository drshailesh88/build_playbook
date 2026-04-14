# classify-check — Verify tiers.yaml covers every source file

Runs `qa/classify-checker.ts` against the target app's source tree. Prints
any file that does NOT match a glob in `.quality/policies/tiers.yaml`.

This is what `qa-doctor`'s `tiers-coverage` check runs — this command lets
you run it in isolation and get a clean file list.

## Process

```ts
import { runClassifyCheck } from "qa/classify-checker.js";

const result = await runClassifyCheck({
  workingDir: process.cwd(),
});

if (result.ok) {
  console.log(`✅ ${result.scanned} source files, 0 unclassified.`);
  process.exit(0);
} else {
  console.error(
    `❌ ${result.unclassified.length} unclassified source files:`,
  );
  for (const path of result.unclassified) {
    console.error(`  ${path}`);
  }
  console.error(
    `\nAdd these to a tier in .quality/policies/tiers.yaml or delete them.`,
  );
  process.exit(1);
}
```

## Output

```
❌ 5 unclassified source files:
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

## What It Scans

Default source roots: `src/`, `app/`, `lib/`, `components/`, `pages/`.
Default extensions: `.ts`, `.tsx`, `.js`, `.jsx`.
Default exclusions: `node_modules/`, `.next/`, `.git/`, `__snapshots__/`,
`coverage/`, `dist/`, `build/`, `.stryker-tmp/`, `*.test.*`, `*.spec.*`.

Override via `classify-checker`'s options if your app uses different
conventions.

## Use When

- Right after `/playbook:classify-modules` to confirm coverage.
- In a pre-push git hook.
- Before the first `/playbook:qa-run` (qa-run aborts on unclassified +
  `unclassified_behavior: fail_fast`).
- In CI to prevent merges that add unclassified files.

## Integration With qa-doctor

The same logic powers `qa doctor`'s `tiers-coverage` drift check. Running
`qa doctor` gives you this plus four other checks (deprecated commands,
contract hashes, providers policy, detected services).

Use `classify-check` when you want just this one check with an exit code.
Use `qa doctor` for a full health snapshot.
