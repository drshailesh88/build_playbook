# classify-modules — Interactive tiers.yaml builder

Scans the target app's source tree and helps you classify each module into
a tier (`critical_75`, `business_60`, `ui_gates_only`). Writes
`.quality/policies/tiers.yaml` with `unclassified_behavior: fail_fast` so
any subsequent file with no matching glob halts `qa run` loudly (6b.iii).

## Tier Reference

| Tier | Mutation floor | Enforcement | Use for |
|---|---|---|---|
| `critical_75` | 75% | Stryker + floor gate on every run | Auth, payments, user data, core business logic |
| `business_60` | 60% | Stryker + floor gate on every run | Non-critical business logic, API handlers |
| `ui_gates_only` | none | Static + unit + Playwright + a11y + visual | UI components where mutation is hard to measure meaningfully |

## Process

### Step 1: Scan the target app's source tree

```ts
import { runClassifyCheck } from "qa/classify-checker.js";

const initial = await runClassifyCheck({
  workingDir: process.cwd(),
  sourceRoots: ["src", "app", "lib", "components", "pages"],
});
// initial.unclassified will be every .ts/.tsx file — nothing is classified yet.
```

Present the user with a directory listing grouped by top-level dir:

```
Found 42 source files across:
  src/auth/        (6 files)  — tier hint from clerk.yaml → critical_75
  src/payments/    (8 files)  — tier hint from razorpay.yaml → critical_75
  src/lib/         (12 files) — tier hint from drizzle.yaml → critical_75 for db/*,
                                 default business_60 otherwise
  src/components/  (14 files) — no tier hint — suggest ui_gates_only
  app/api/         (2 files)  — no tier hint — suggest business_60
```

### Step 2: Load detected-services.yaml for suggestions

```ts
import yaml from "js-yaml";
import { readFile } from "node:fs/promises";

const detectedRaw = await readFile(".quality/policies/detected-services.yaml", "utf8")
  .catch(() => null);
const detected = detectedRaw ? yaml.load(detectedRaw) : null;

// Each detected service's manifest has tier_hints. Claude merges them
// as suggestions, ALWAYS deferring to user judgment.
```

### Step 3: Walk the user through each group

For each top-level directory:

1. Show the files + any service tier_hint that matched.
2. Suggest a tier + explain why (e.g., "Clerk detected, so `src/auth/**`
   is suggested as `critical_75`").
3. Ask the user: "Accept `critical_75` for `src/auth/**`? (Y/n/edit)"
4. Let them:
   - Accept (Y)
   - Override (choose a different tier)
   - Break down (classify sub-paths individually — e.g.
     `src/lib/payments/**` → `critical_75`, `src/lib/util/**` →
     `business_60`)

Keep every choice in memory as a glob → tier mapping. Resolve conflicts
(longer / more-specific globs win).

### Step 4: Write tiers.yaml

```yaml
# .quality/policies/tiers.yaml
schema_version: 1
tiers:
  critical_75:
    - "src/auth/**"
    - "middleware.ts"
    - "src/lib/payments/**"
    - "app/api/auth/**"
  business_60:
    - "src/lib/**"
    - "app/api/**"
  ui_gates_only:
    - "src/components/**"
    - "app/**/page.tsx"
    - "app/**/layout.tsx"
unclassified_behavior: fail_fast
```

Always set `unclassified_behavior: fail_fast` (6b.iii — no silent defaults).

### Step 5: Verify coverage

Run `runClassifyCheck` again to confirm every file is classified:

```ts
const final = await runClassifyCheck({ workingDir: process.cwd() });
if (!final.ok) {
  console.error(`Still ${final.unclassified.length} unclassified files:`);
  for (const path of final.unclassified.slice(0, 20)) {
    console.error(`  ${path}`);
  }
  console.error(`
Every source file must match a tier glob. Either:
  - extend a tier in tiers.yaml to cover these files, or
  - delete the files if they're genuinely unused.
`);
  process.exit(1);
}
console.log(`${final.scanned} files classified, 0 unclassified. Ready for qa-run.`);
```

### Step 6: Commit

```bash
git add .quality/policies/tiers.yaml
git commit -m "chore(qa): classify modules into tiers for <app-name>"
```

## Rules

- NEVER set `unclassified_behavior` to anything other than `fail_fast`.
  Silent defaults undermine the ratchet — a new unclassified file could
  silently slip into `ui_gates_only` (no floor) and never be checked.
- NEVER over-classify UI components as `critical_75`. Mutation testing on
  presentation components is noisy and low-signal. If the component has
  business logic embedded, move that logic into `src/lib/` and classify
  the pure presentation layer as `ui_gates_only`.
- NEVER accept service tier_hints blindly. Review each one — your app
  may structure things differently than the manifest assumes.
