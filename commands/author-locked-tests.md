# author-locked-tests — Generate acceptance tests from a frozen contract

Generates `acceptance.spec.ts` under source-denied permissions (blueprint
T2). The test-authoring agent reads the contract's examples, counterexamples,
invariants, and (optionally) api-contract.json — but CANNOT read any source
code. This preserves oracle independence: tests cannot accidentally codify
current-implementation behavior.

Input: `$ARGUMENTS` — feature name. Contract must already exist at
`.quality/contracts/<feature>/` with `status: frozen`.

## Process

### Step 1: Verify the contract is frozen

```ts
import { readIndexYaml } from "qa/contract-utils.js";

const contract = await readIndexYaml(`.quality/contracts/${feature}/`);
if (contract.feature.status !== "frozen") {
  throw new Error(
    `Contract ${feature} is ${contract.feature.status}, not frozen. ` +
    `Run /playbook:contract-pack ${feature} first.`
  );
}
```

### Step 2: Swap in test-authoring settings

```bash
cp .claude/settings.json .claude/settings.json.loop
cp .claude/settings-test-authoring.json .claude/settings.json
```

The swapped-in settings deny Read on `src/`, `app/`, `lib/`, `components/`,
`pages/`. Allow Read on `.quality/contracts/**`, `.planning/**`, and
`tests/helpers/**`. Allow Write ONLY to `.spec.ts.draft` locations.

### Step 3: Invoke Claude with the contract

Claude is instructed to:

1. Read `.quality/contracts/<feature>/index.yaml` for metadata.
2. Read `examples.md`, `counterexamples.md`, `invariants.md`.
3. Read `api-contract.json` if present.
4. Generate `acceptance.spec.ts.draft` using Playwright.

**Prompt Claude with:**

```
You are a test-authoring agent. You may NOT read any source code.

Your task: generate Playwright tests at
.quality/contracts/<feature>/acceptance.spec.ts.draft that verify every
example, counterexample, and invariant in the frozen contract.

Rules:
- Real Playwright, real browser — no mocks, no jsdom.
- Each test must assert at least ONE deep signal:
  (a) persisted state (visible after page reload)
  (b) API response (status + body content)
  (c) URL/navigation transition
  (d) multiple DOM elements confirming state change
  (e) accessibility state (aria attributes)
- NOT acceptable as only assertion: "toast appeared", "button exists",
  "element is visible".
- Use data-testid selectors (e.g. `[data-testid="login-btn"]`). They will
  likely not match the DOM yet — that's expected; the user will run
  /playbook:wire-selectors afterward to adjust them.
- Every test description should reference the example/counterexample/
  invariant number from the contract (e.g. "Example 3: login with valid
  credentials").

When done, the spec file ends in .draft — the user will review, rename
to acceptance.spec.ts, and commit.
```

### Step 4: User reviews + renames

```bash
# User inspects the draft
$EDITOR .quality/contracts/<feature>/acceptance.spec.ts.draft

# Once satisfied, rename to the real file
mv .quality/contracts/<feature>/acceptance.spec.ts.draft \
   .quality/contracts/<feature>/acceptance.spec.ts
```

### Step 5: Swap settings back to loop mode

```bash
cp .claude/settings.json.loop .claude/settings.json
```

The `.spec.ts` now falls under Layer 1 permissions.deny.

### Step 6: Run once + wire selectors

```bash
npx playwright test .quality/contracts/<feature>/acceptance.spec.ts
```

If tests fail because selectors don't match the actual DOM — this is
expected on first run. The authoring agent never saw the DOM. Run:

```
/playbook:wire-selectors <feature>
```

to fix selectors under tight permissions (without modifying assertions).

## Rules

- NEVER author tests while source is readable. Oracle contamination means
  tests become a mirror of the bug rather than a check against it.
- NEVER author tests without a frozen contract — the contract IS the spec.
- NEVER edit assertions after the spec leaves this command; if an assertion
  is wrong, fix the CONTRACT, then version-bump, then re-run this command.
