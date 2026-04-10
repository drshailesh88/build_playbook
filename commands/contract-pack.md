# Contract Pack — Frozen Oracle Before Build

Create an independent test oracle from the spec BEFORE any code is written. The contract pack defines what "correct" means. The builder agent gets these tests but CANNOT edit them. This is the foundation of honest QA.

Input: $ARGUMENTS (feature name, PRD section, or path to spec file)

## Why This Exists

Oracle contamination: when the same agent writes code and tests, tests become mirrors of the code. The fix is to create tests from the SPECIFICATION before seeing any implementation. These tests can never be tautological because they were written before the code existed.

> "A single agent that plans, builds, and evaluates its own work will reliably praise its own mediocre output." — Anthropic Engineering

Adapted from:
- Karpathy's Autoresearch (external metric, not self-assessment)
- Cole Medin's Adversarial Dev (planner → builder → evaluator separation)
- codecentric's Isolated Specification Testing (`.claudeignore` + permission deny)
- Codex adversarial review feedback on this playbook

## Process

### Step 1: Identify the Feature Spec

Resolve the input:
- If a file path: read it directly
- If a feature name: search `.planning/decisions/`, `.planning/REQUIREMENTS.md`, or GitHub issues
- If "latest": find the most recent planning document

Also load if available:
- `UBIQUITOUS_LANGUAGE.md` — domain terms
- `.planning/ux-brief.md` — UX decisions
- `.planning/data-requirements.md` — data model
- `.planning/ui-brief.md` — visual decisions

<HARD-GATE>
Do NOT read any source code in `src/`, `app/`, `lib/`, `components/`, or equivalent.
The contract pack must be written from SPEC ONLY — never from implementation.
If you catch yourself reading source to understand behavior, STOP.
</HARD-GATE>

### Step 2: Interview the User

<HARD-GATE>
Do NOT generate examples and freeze them silently. The user must approve every contract artifact before it becomes frozen. Freezing misunderstandings is worse than having no tests.
</HARD-GATE>

Ask the user these questions in plain language (no test jargon):

**Happy paths:**
"Walk me through what a user does with this feature. Start from the beginning."
- Get 5-15 concrete examples of correct behavior
- Each example: what the user does → what they should see → what should happen in the system

**Forbidden behaviors:**
"What should NEVER happen? What would be a disaster?"
- Get 3-10 counterexamples
- Each: what could go wrong → why it must not happen

**Invariants:**
"What must ALWAYS be true, no matter what the user does?"
- Get 3-8 invariants
- Examples: "totals never go negative", "deleted users can't log in", "every booking has an event"

**Edge cases:**
"What about weird situations? Empty lists? Very long names? Duplicate entries?"
- Get 3-5 edge cases the user cares about

**API shape (if applicable):**
"What data goes in and what comes back?"
- Input fields with types
- Expected response shape
- Error responses

### Step 3: Present for Approval

Show the user a summary in plain English:

```markdown
## Contract Pack: [Feature Name]

### Examples (happy paths)
1. When a coordinator adds a speaker, the speaker appears in the list immediately
2. When the speaker's email is invalid, a red error message shows under the field
3. ...

### Forbidden behaviors
1. A read-only user must NEVER see the "Add Speaker" button
2. Deleting a speaker must NEVER delete their travel arrangements
3. ...

### Invariants
1. The speaker count shown in the header always matches the actual list length
2. Every speaker must have at least a name and email
3. ...

### Edge cases
1. Adding a speaker with a 200-character name should work (not truncate silently)
2. The list should show "No speakers yet" when empty, not a blank page
3. ...
```

Ask: **"Does this match what you expect? Anything to add, remove, or change?"**

Iterate until the user says "looks good" or "approved."

### Step 4: Generate the Contract Pack

Create the directory and files:

```bash
mkdir -p contracts/$FEATURE_NAME
```

#### 4a: `examples.md`
```markdown
# Examples — [Feature Name]
# Approved by: [user] on [date]
# Status: FROZEN — do not edit without explicit approval

## Example 1: [title]
**Given:** [preconditions]
**When:** [user action]
**Then:** [expected outcome — user-visible AND system-level]

## Example 2: [title]
...
```

#### 4b: `counterexamples.md`
```markdown
# Counterexamples — [Feature Name]
# Approved by: [user] on [date]
# Status: FROZEN

## Counterexample 1: [title]
**This must NEVER happen:** [forbidden behavior]
**Why:** [reason]
**Test:** [how to verify it doesn't happen]
```

#### 4c: `invariants.md`
```markdown
# Invariants — [Feature Name]
# Approved by: [user] on [date]
# Status: FROZEN

1. [invariant statement] — ALWAYS true
2. [invariant statement] — ALWAYS true
...
```

#### 4d: `acceptance.spec.ts`

Generate Playwright tests from the approved examples and counterexamples.

<HARD-GATE>
These tests must run against the LIVE APPLICATION in a real browser.
No mocks. No jsdom. No renderToStaticMarkup. Real Playwright, real browser.
</HARD-GATE>

**Assertion depth requirements — each test must assert at least ONE of:**
- Persisted state (visible after page reload)
- API response (status code + body content)
- URL/navigation transition
- Multiple DOM elements that confirm the full state change
- Accessibility state (aria attributes)

**NOT acceptable as the only assertion:**
- Toast/notification appeared (easily faked)
- Button exists (not a behavior check)
- Element is visible (too shallow)

**Test structure:**
```typescript
import { test, expect } from '@playwright/test';

// FROZEN CONTRACT — DO NOT EDIT
// Approved by: [user] on [date]
// Source: contracts/[feature]/examples.md

test.describe('[Feature Name] — Contract Tests', () => {
  test('Example 1: [title]', async ({ page }) => {
    // Given: [preconditions — navigate, set up state]
    // When: [user action — click, fill, submit]
    // Then: [deep assertion — check DB state, API, reload persistence]
  });

  test('Counterexample 1: [title] — must NOT happen', async ({ page }) => {
    // Verify the forbidden behavior does not occur
  });
});
```

#### 4e: `api-contract.json` (if applicable)
```json
{
  "feature": "[Feature Name]",
  "frozen": true,
  "approvedBy": "[user]",
  "approvedDate": "[date]",
  "endpoints": [
    {
      "method": "POST",
      "path": "/api/[resource]",
      "input": { "field1": "string", "field2": "number" },
      "output": { "id": "string", "created": "boolean" },
      "errorCases": [
        { "condition": "missing field1", "status": 400, "message": "field1 is required" }
      ]
    }
  ]
}
```

#### 4f: `regressions.spec.ts` (initially empty)
```typescript
import { test, expect } from '@playwright/test';

// REGRESSION TESTS — grows as bugs are found and fixed
// Each test here came from a real bug. Never delete these.

test.describe('[Feature Name] — Regressions', () => {
  // Will be populated by anneal and ralph-loop-qa as bugs are found
});
```

### Step 5: Verify Tests Run (Red Phase)

<HARD-GATE>
If the feature hasn't been built yet, ALL acceptance tests should FAIL.
If they pass, the tests are too weak or testing the wrong thing.
This is the TDD "red" phase — failing tests are CORRECT at this stage.
</HARD-GATE>

Run the acceptance tests:
```bash
npx playwright test contracts/$FEATURE_NAME/ --reporter=list
```

Expected: all tests fail (feature not built yet).
If any pass: investigate — the test might be asserting something trivial.

### Step 6: Commit and Report

```bash
git add contracts/$FEATURE_NAME/
git commit -m "contract($FEATURE_NAME): frozen acceptance pack — [N] examples, [N] counterexamples, [N] invariants"
```

Report:
```
CONTRACT PACK FROZEN
Feature: [name]
Approved by: [user]

Examples:          [N]
Counterexamples:   [N]
Invariants:        [N]
Acceptance tests:  [N]
API contracts:     [N] endpoints

Status: All tests FAILING (correct — feature not built yet)

Next:
  Build the feature: tests will guide implementation
  The builder agent can read contracts/ but CANNOT edit it
  Run anneal after build — it will use these as the oracle
```

## Observability Hooks

For the adversary agent and acceptance tests to make deep assertions (DB state, API responses) without seeing source code, the app needs test-observable surfaces:

**Recommended (add if not present):**
- Test-only API endpoint: `GET /api/test/state?entity=speakers&eventId=X` — returns current state
- Request tracing: `X-Request-Id` header on all responses
- Seeded test data: `npm run seed:test` creates known fixtures
- Test user accounts: one per role, deterministic credentials

These hooks let tests verify business state without reading source code.

## Contract Versioning

Contracts can be updated when product intent changes:

```markdown
# Contract Version History
## v1 — [date] — Initial contract
## v2 — [date] — Added bulk import flow (approved by [user])
##   Reason: New feature added to PRD
##   Changes: +3 examples, +1 counterexample, +2 tests
```

A contract version bump requires:
1. Explicit user approval
2. Reason documented
3. New version committed separately from code changes
4. Old tests preserved in `regressions.spec.ts` if behavior changed

## Rules

- NEVER generate a contract pack without user approval. Frozen misunderstandings are worse than no tests.
- NEVER read source code while writing contracts. The oracle must be independent of implementation.
- NEVER write shallow assertions. "Toast appeared" is not a contract test. "Record persisted and visible after reload" is.
- NEVER let the builder agent edit files in `contracts/`. Use `.claudeignore` or permission deny.
- ALL tests must run against the live app in a real browser. No mocks, no jsdom.
- Contract tests that pass before the feature is built are WRONG. Red phase = correct.
- Every bug found in production or QA becomes a regression test in `regressions.spec.ts`.
