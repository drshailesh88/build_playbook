# wire-selectors — Adjust data-testid selectors to match the DOM

Tight-scope selector fix-up (blueprint T3). After
`/playbook:author-locked-tests` generates an acceptance spec, the selectors
it used won't match the actual DOM because the authoring agent never saw
source code. This command lets Claude READ the feature's UI source + the
acceptance spec, EDIT ONLY the spec's selectors, and leaves assertions
alone. The controller runs a diff check afterward that REJECTS any change
to `expect()` lines.

Input: `$ARGUMENTS` — feature name.

## Process

### Step 1: Capture baseline of expect() calls

Before wiring, record the `expect()` count + shapes in the spec. This is
the baseline for the post-wiring diff check.

```ts
import { analyzeTestFileChange } from "qa/diff-audit/ast-assertion-analyzer.js";
import { readFile } from "node:fs/promises";

const specPath = `.quality/contracts/${feature}/acceptance.spec.ts`;
const beforeContent = await readFile(specPath, "utf8");
```

### Step 2: Swap in selector-wiring settings

```bash
cp .claude/settings.json .claude/settings.json.loop
cp .claude/settings-selector-wiring.json .claude/settings.json
```

The swapped-in settings ALLOW:
- Read on `src/app/**`, `src/components/**`, `src/pages/**`, plus `app/**`,
  `components/**`, `pages/**` (the UI source).
- Read on `.quality/contracts/*/acceptance.spec.ts` (the spec being wired).
- Read on `.quality/contracts/*/index.yaml` (metadata).
- Edit on `.quality/contracts/*/acceptance.spec.ts`.

And DENY:
- Edit/Write to ALL source directories (`src/`, `app/`, `components/`,
  `lib/`, `pages/`).
- Write to `.quality/contracts/**` (you're editing IN PLACE, not writing
  new files).
- Edit to every OTHER contract artifact (examples, counterexamples,
  invariants, index.yaml, api-contract.json).

### Step 3: Invoke Claude

**Prompt Claude with:**

```
You are a selector-wiring agent. Your only job is to make data-testid
selectors in the acceptance spec match the ACTUAL DOM in the feature's
UI source.

Rules (NON-NEGOTIABLE):
- You may adjust ONLY data-testid values in the .spec.ts file.
- You may NOT modify any expect() call.
- You may NOT modify assertion matchers or assertion arguments.
- You may NOT add or remove tests.
- You may NOT edit any source code.

Workflow:
1. Run the spec: `npx playwright test <spec>`
2. Identify which selectors fail to resolve.
3. Read the corresponding UI source files to find the real data-testid
   values.
4. Update the selectors in the spec.
5. Re-run the spec to confirm the selectors now resolve.

The controller will inspect your diff after you exit. Any change that
affects an expect() call will be REJECTED and your edits reverted.
```

### Step 4: Post-wiring AST diff check

After Claude exits, compare before/after using the AST analyzer:

```ts
import { analyzeTestFileChange } from "qa/diff-audit/ast-assertion-analyzer.js";
import { readFile, writeFile } from "node:fs/promises";

const afterContent = await readFile(specPath, "utf8");
const audit = analyzeTestFileChange(beforeContent, afterContent);

const forbiddenFindings = audit.findings.filter(
  (f) => f.patternId === "NET_EXPECT_DECREASE" ||
         f.patternId === "MATCHER_WEAKENED"
);
// Also reject if the NUMBER of expect() calls changed — even adding one
// counts as an assertion change.
if (audit.expectCountBefore !== audit.expectCountAfter || forbiddenFindings.length > 0) {
  await writeFile(specPath, beforeContent);  // revert
  throw new Error(
    `Wiring REJECTED: assertions changed. ` +
    `Before: ${audit.expectCountBefore} expect() calls. ` +
    `After: ${audit.expectCountAfter}. ` +
    `Findings: ${forbiddenFindings.map((f) => f.patternId).join(", ")}`
  );
}
```

### Step 5: Swap settings back + confirm

```bash
cp .claude/settings.json.loop .claude/settings.json
npx playwright test .quality/contracts/<feature>/acceptance.spec.ts
```

If the spec now passes: commit the selector updates.
If it still fails on real behavior (not selectors): the feature is genuinely
not implemented correctly. This is the expected state during build — the
full `/playbook:qa-run` loop handles it.

## What This Command Does NOT Do

- Does NOT rewrite tests. Selectors only.
- Does NOT change assertions. Even strengthening them is rejected (if you
  need stronger assertions, version-bump the contract).
- Does NOT modify source. If the UI needs a new data-testid, that's a
  source change and belongs in the regular build loop, not here.

## Rules

- NEVER use this command to "fix" failing assertions by changing them.
  Assertion failures mean the feature is broken or the contract is wrong.
- NEVER run this without first running the spec once — you need the
  selector failures as input.
- NEVER modify .quality/contracts/*/index.yaml — even if the test count
  changed slightly. Use /playbook:contract-pack --version-bump for
  anything contract-altering.
