# author-locked-tests — Generate acceptance tests from a frozen contract

Generates `acceptance.spec.ts` under source-denied permissions (blueprint T2).
The test-authoring agent reads the contract (examples, counterexamples,
invariants, API contract) but CANNOT read any source code. This preserves
oracle independence — tests cannot accidentally codify current-implementation
behavior.

Input: `$ARGUMENTS` — feature name (must have a frozen `index.yaml` in
`.quality/contracts/<feature>/`).

## What It Does

1. Verifies the feature's contract is `status: frozen`.
2. Swaps in `.claude/settings-test-authoring.json` (source reads denied).
3. Invokes Claude with the contract as input.
4. Writes `acceptance.spec.ts.draft` into the contract dir.
5. Swaps the settings back.
6. User reviews, renames to `acceptance.spec.ts`, commits.

On first run the generated tests will almost certainly FAIL when run against
the app — the selectors won't match yet because the authoring agent never
saw the DOM. That's expected. Run `/playbook:wire-selectors <feature>` next.

## Steps

```bash
/playbook:author-locked-tests auth-login
```

## Rules

- NEVER author tests while source is readable. Oracle contamination means
  tests become a mirror of the bug rather than a check against it.
- NEVER author tests without a frozen contract — the contract IS the spec.
