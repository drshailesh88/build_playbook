# Contract Pack — Frozen Oracle Before Build

Create an independent test oracle from the spec BEFORE any code is written.
The contract pack defines what "correct" means. The builder agent gets
these tests but CANNOT edit them. This is the foundation of honest QA.

Input: `$ARGUMENTS` — feature name (kebab-case), or one of the flags below.

## Flags

- `<feature>` (bare argument) — initial authoring flow.
- `<feature> --version-bump --reason="..."` — update an existing frozen
  contract. Increments version, recomputes hashes, appends a history entry,
  triggers a baseline reset for modules in `affected_modules`.
- `<feature> --security-sensitive` — force `security_sensitive: true` in the
  index.yaml. Auto-applied for categories `auth`, `payments`, `user_data`;
  this flag is for business_logic features you want to explicitly harden.

## Why This Exists

Oracle contamination: when the same agent writes code and tests, tests
become mirrors of the code. The fix is to create tests from the
SPECIFICATION before seeing any implementation. These tests can never be
tautological because they were written before the code existed.

> "A single agent that plans, builds, and evaluates its own work will
> reliably praise its own mediocre output." — Anthropic Engineering

Adapted from:
- Karpathy's Autoresearch (external metric, not self-assessment)
- Cole Medin's Adversarial Dev (planner → builder → evaluator separation)
- codecentric's Isolated Specification Testing (permission-based source lock)

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

**Swap in contract-authoring settings** before Claude reads anything:

```bash
cp .claude/settings-contract-authoring.json .claude/settings.json.tmp
mv .claude/settings.json .claude/settings.json.loop
mv .claude/settings.json.tmp .claude/settings.json
```

This blocks Read on `src/`, `app/`, `lib/`, `components/`, `pages/`,
`tests/`, and `e2e/`. Contracts MUST be written from spec only — if Claude
catches itself reading source to understand behavior, STOP.

<HARD-GATE>
Do NOT read any source code in `src/`, `app/`, `lib/`, `components/`, or
equivalent. The contract pack must be written from SPEC ONLY — never from
implementation. The permissions.deny above enforces this mechanically;
this note is a reminder for the reader.
</HARD-GATE>

### Step 2: Interview the User

<HARD-GATE>
Do NOT generate examples and freeze them silently. The user must approve
every contract artifact before it becomes frozen. Freezing misunderstandings
is worse than having no tests.
</HARD-GATE>

Ask the user these questions in plain language (no test jargon):

**Happy paths:**
"Walk me through what a user does with this feature. Start from the beginning."
- Get 5-15 concrete examples of correct behavior.
- Each example: what the user does → what they should see → what should
  happen in the system.

**Forbidden behaviors:**
"What should NEVER happen? What would be a disaster?"
- Get 3-10 counterexamples.
- Each: what could go wrong → why it must not happen.

**Invariants:**
"What must ALWAYS be true, no matter what the user does?"
- Get 3-8 invariants.

**Edge cases:**
"What about weird situations? Empty lists? Very long names? Duplicates?"
- Get 3-5 edge cases.

**API shape (if applicable):**
"What data goes in and what comes back?"
- Input fields with types.
- Expected response shape.
- Error responses.

### Step 3: Present for Approval

Show a plain-English summary and iterate until the user says "approved."

### Step 4: Write the Contract Pack

Create the directory and draft files:

```
.quality/contracts/<feature-name>/
  examples.md
  counterexamples.md
  invariants.md
  acceptance.spec.ts
  regressions.spec.ts    (initially empty)
  api-contract.json      (if applicable)
  index.yaml             (written last, after hashes computed)
```

#### Artifact format: `examples.md`

```markdown
# Examples — <Feature Name>
# Approved by: <user> on <date>
# Status: FROZEN — do not edit without explicit approval

## Example 1: <title>
**Given:** <preconditions>
**When:** <user action>
**Then:** <expected outcome — user-visible AND system-level>
```

#### Artifact format: `counterexamples.md`

```markdown
## Counterexample 1: <title>
**This must NEVER happen:** <forbidden behavior>
**Why:** <reason>
**Test:** <how to verify it doesn't happen>
```

#### Artifact format: `invariants.md`

```markdown
1. <invariant statement> — ALWAYS true
2. <invariant statement> — ALWAYS true
```

#### Artifact format: `acceptance.spec.ts`

Generate Playwright tests from the approved examples and counterexamples.

<HARD-GATE>
These tests must run against the LIVE APPLICATION in a real browser.
No mocks. No jsdom. Real Playwright, real browser.
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

### Step 5: Write index.yaml + Freeze

Call the contract-utils helper:

```ts
import { initializeContract, freezeContract } from "qa/contract-utils.js";

// Step A: initial index.yaml with status=pending_approval
await initializeContract({
  contractDir: ".quality/contracts/<feature>/",
  featureId: "<feature>",
  title: "<Feature Title>",
  tier: "critical_75",     // or "business_60" / "ui_gates_only"
  category: "auth",        // auto-sets security_sensitive=true
  approvedBy: "<user>",
  affectedModules: ["src/auth/**", "middleware.ts"],
  seededUsers: ["test_user"],
  requiresServices: ["clerk"],
  sourceDocs: [".planning/PRD.md#authentication"],
});

// Step B: user reviews; rename *.draft → *, run tests in RED phase
// Step C: freeze — recomputes hashes + flips status to frozen
await freezeContract({
  contractDir: ".quality/contracts/<feature>/",
  approvedBy: "<user>",
  prOrCommit: "<sha or PR #>",
});
```

Post-freeze, Layer 1 permissions.deny applies to the whole contract directory.
Agents cannot edit these files during `qa run`.

### Step 6: Swap settings back + Verify Tests Run (Red Phase)

Restore loop-mode settings:

```bash
mv .claude/settings.json .claude/settings-contract-authoring.json.tmp
mv .claude/settings.json.loop .claude/settings.json
```

<HARD-GATE>
If the feature hasn't been built yet, ALL acceptance tests should FAIL.
If they pass, the tests are too weak or testing the wrong thing.
This is the TDD "red" phase — failing tests are CORRECT at this stage.
</HARD-GATE>

```bash
npx playwright test .quality/contracts/<feature>/ --reporter=list
```

Expected: all tests fail (feature not built yet).
If any pass: investigate — the test might be asserting something trivial.

### Step 7: Commit and Report

```bash
git add .quality/contracts/<feature>/
git commit -m "contract(<feature>): frozen acceptance pack — N examples, N counterexamples, N invariants"
```

Report:
```
CONTRACT PACK FROZEN
Feature:           <name>
Approved by:       <user>
Tier:              critical_75
Category:          auth (security_sensitive=true)

Examples:          N
Counterexamples:   N
Invariants:        N
Acceptance tests:  N
API contracts:     N endpoints

Status: All tests FAILING (correct — feature not built yet)

Next:
  Build the feature: tests will guide implementation
  The builder agent can read .quality/contracts/ but CANNOT edit it
  Run /playbook:qa-run after build — it uses these as the oracle
```

## Version-bump flow (`--version-bump`)

When the PRD changes and a contract needs updating:

```bash
/playbook:contract-pack auth-login --version-bump --reason="Added social login from PRD v2"
```

Invokes `bumpContractVersion` from `qa/contract-utils.ts`, which:

1. Sets `status` to `versioning` (brief transition state).
2. Re-opens the contract directory for editing (under source-denied
   permissions for `security_sensitive` features — A2 pattern, blueprint
   12e).
3. After updates, recomputes hashes.
4. Increments `version` (1 → 2 → 3).
5. Appends to `version_history` with reason, authoring_mode, and
   `baseline_reset_triggered: true`.
6. Calls `freezeContract` to set `status: frozen` + finalize hashes.
7. The next `qa run` reads `baseline_reset_triggered` and forces a full
   baseline for every module in `affected_modules` (blueprint 12e).

Old tests are preserved in `regressions.spec.ts` if behavior changed
(append-only by convention; the controller trusts human judgment here).

### `--security-sensitive`

For `business_logic` or `ui` features you want to harden beyond the
category default, pass `--security-sensitive`. This flag:

- Sets `feature.security_sensitive: true` in index.yaml.
- Forces source-denied authoring on every version bump (A2).
- Promotes the feature to `critical_75` tier consideration (still
  determined by tiers.yaml, but contract declares intent).

For `auth` / `payments` / `user_data`, this is auto-set — the flag is
redundant for those categories.

## Rules

- NEVER generate a contract pack without user approval. Frozen
  misunderstandings are worse than no tests.
- NEVER read source code while writing contracts. The oracle must be
  independent of implementation. `.claude/settings-contract-authoring.json`
  enforces this mechanically.
- NEVER write shallow assertions. "Toast appeared" is not a contract test.
  "Record persisted and visible after reload" is.
- NEVER let the builder agent edit files in `.quality/contracts/`. Layer 1
  permissions.deny covers the whole `.quality/**` tree.
- ALL tests must run against the live app in a real browser. No mocks,
  no jsdom.
- Contract tests that pass before the feature is built are WRONG. Red
  phase = correct.
- Every bug found in production or QA becomes a regression test in
  `regressions.spec.ts`.
- Version bumps on `security_sensitive` features MUST use source-denied
  authoring. The controller writes `authoring_mode: source_denied` in the
  history entry either way; violating this manually is a trust breach.
