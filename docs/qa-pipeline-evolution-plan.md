# Build Playbook — QA Pipeline Evolution Plan

How to evolve the current harden/anneal pipeline into a foolproof, deterministic, overnight quality engine that agents cannot game.

---

## Problem Statement

The current `/harden` pipeline (census -> specs -> test -> heal) has oracle contamination: the same agent writes code AND decides what "correct" means. Tests become mirrors of code, not independent checks. The agent writes tautological tests, mocks everything, and reports 100% pass rate. The anneal loop makes it worse by letting the agent weaken assertions to make tests pass.

## Design Principles

1. **The builder and the judge must be different agents with different access**
2. **Mutation score is the metric, not test pass rate or coverage**
3. **Frozen tests can never be weakened by the builder**
4. **Every fix runs ALL tests — regression detected mechanically, not by agent judgment**
5. **Scores only go up — revert if any score drops (Karpathy's iron law)**

---

## What to Build

### 1. Modify `/playbook:anneal` — Add No-Oracle-Drift Rules

**File:** `commands/anneal.md`

**Changes:**
- Add explicit rules about what anneal is and isn't allowed to do
- Anneal CAN: fix app code, fix brittle selectors, fix timing/wait issues, quarantine flaky tests with reason
- Anneal CANNOT: weaken assertions, delete assertions, change expected business behavior, rewrite scenarios, change contract tests in the same task as code changes
- Add a reason code requirement for any test file modification: `SELECTOR_FIX`, `TIMING_FIX`, `QUARANTINE`, `SPEC_CHANGE_APPROVED`
- Add the autoresearch ratchet: snapshot ALL scores before each fix, revert if ANY score drops

**Effort:** Small (modify existing command)

### 2. New: `/playbook:contract-pack` — Frozen Oracle Before Build

**File:** `commands/contract-pack.md`

**What it does:**
- Takes a feature name or PRD section as input
- A QA agent (separate from builder) reads ONLY the spec/PRD — NOT the source code
- Generates a Contract Pack:

```
contracts/<feature>/
  examples.md             — 5-15 canonical examples of correct behavior
  counterexamples.md      — 3-10 things that must NOT happen  
  invariants.md           — properties that must always hold
  acceptance.spec.ts      — Playwright tests against the running app
  api-contract.json       — expected API shapes and responses
  regressions.spec.ts     — (initially empty, grows from bugs found)
```

- The QA agent uses `.claudeignore` or `--deny` to prevent reading `src/`
- Tests are written against the RUNNING APPLICATION via Playwright (real browser, not mocks)
- Contract pack is committed and marked as FROZEN
- Builder agent gets this pack but CANNOT edit files in `contracts/`

**Key design:**
- Uses Playwright MCP for real browser interaction
- Tests assert business state (DB, API responses, URL transitions), not just DOM
- Each test has assertion depth: "clicked Save, got 200, row updated, revision incremented, draft appears after reload" — not "clicked Save and saw toast"

**Effort:** Medium (new command, new workflow concept)

### 3. New: `/playbook:mutation-gate` — Objective Quality Measurement

**File:** `commands/mutation-gate.md`

**What it does:**
- Installs Stryker if not present (`@stryker-mutator/core @stryker-mutator/vitest-runner`)
- Runs Stryker on specified modules (or changed files from last commit)
- Reports mutation score per module
- For surviving mutants: feeds them to Claude to strengthen test assertions
- Autoresearch ratchet: keep assertion improvements that kill mutants, discard those that don't
- Reports to Linear if Linear is configured

**Thresholds:**
- Critical paths (auth, payments): >= 80% mutation score
- Standard features: >= 70%
- Experimental/new code: >= 50%

**What makes this ungameable:**
- Stryker is deterministic — it mechanically mutates code and checks if tests catch it
- The agent can't fake a mutation score — either the test catches `>` flipped to `<`, or it doesn't
- Surviving mutants are the BEST possible feedback for test improvement — they tell you exactly which mutations your tests missed

**Effort:** Medium (new command, Stryker integration)

### 4. New: `ralph-loop-qa.sh` — The Overnight QA Ralph Loop

**File:** `adapters/linear/ralph-loop-qa.sh`

**What it does:**
A Ralph loop that iterates over modules (not Linear issues) to progressively improve quality. Runs overnight. Three stages per module, each using the autoresearch ratchet.

**Structure:**
```
for each module (sorted by worst mutation score first):

  STAGE 1: DISCOVER (GAN adversary)
    - Start dev server
    - Codex (adversary, cannot see source code) attacks the running app
    - Writes Playwright tests that try to break things
    - Every bug found = new test committed + Linear issue created
    - Ratchet: keep tests that find real bugs, discard those that find nothing

  STAGE 2: FIX (autoresearch ratchet)
    - For each bug found by adversary:
      - Snapshot ALL scores (all modules, not just this one)
      - Claude (builder) attempts fix
      - Run ALL tests
      - If ALL scores >= snapshot: commit
      - If ANY score dropped: revert, try again (max 3 attempts)
      - Report to Linear

  STAGE 3: STRENGTHEN (mutation ratchet)
    - Run Stryker on this module
    - For each surviving mutant:
      - Claude strengthens assertions to kill the mutant
      - Run ALL tests
      - If mutation score improved AND nothing else regressed: keep
      - Otherwise: revert

  STAGE 4: VERIFY (frozen oracle)
    - Run frozen contract pack tests
    - Run accessibility checks (axe-core)
    - If all pass: module DONE
    - If any fail: create Linear issues for next Ralph build loop

  Module hits thresholds?
    YES → LOCK module (tests become frozen, join the permanent suite)
    NO  → Report progress, continue next night
```

**Agent separation:**
- Codex is the adversary (Stage 1) — CANNOT see source code, only the running app
- Claude is the builder/fixer (Stage 2, 3) — CANNOT edit frozen tests or adversary tests
- Stryker is the mutation judge — deterministic, no agent involvement
- axe-core is the accessibility judge — deterministic
- Script is the regression judge — mechanical score comparison, agent has no say

**Linear tracking:**
- One Linear issue per module being improved
- Comments show: mutation score progression, bugs found, bugs fixed, regressions caught and reverted
- Labels: `qa-in-progress`, `qa-locked`

**What "locked" means:**
When a module passes all thresholds:
- Its tests are moved to the frozen suite
- Future changes to OTHER modules must not break these tests
- The module's score becomes part of the global ratchet baseline

**Environment variables:**
```
LINEAR_TEAM=DRS               # Linear team
TEST_CMD="npm test"            # Test command
TYPE_CHECK_CMD="npx tsc --noEmit"  # Type check
MUTATION_THRESHOLD=80          # Minimum mutation score to lock
NOTIFY_WEBHOOK=https://...     # Notifications
MAX_ITERATIONS=50              # Max iterations per night
```

**Effort:** Large (new script, ~400-500 lines)

### 5. New: `commands/ralph-loop-qa.md` — Documentation

**File:** `commands/ralph-loop-qa.md`

Slash command documentation explaining the overnight QA loop, how to run it, what to expect in Linear, and how it chains with the build Ralph loop.

**Effort:** Small

### 6. Update `commands/commands.md` — Add New Commands

Add to Phase 7 (Harden & Test):
- `/playbook:contract-pack` — Create frozen acceptance tests from spec before build
- `/playbook:mutation-gate` — Run Stryker, measure mutation score, strengthen weak tests
- `./adapters/linear/ralph-loop-qa.sh` — Overnight QA loop: discover, fix, strengthen, verify

**Effort:** Small

### 7. Update Obsidian Reference

Update `one vault/Build Playbook - All Scripts Reference.md` with the new commands and the two-Ralph architecture.

**Effort:** Small

---

## The Two-Ralph Architecture

### The Daily Cycle

```
Evening:   ralph-loop.sh "ProjectName"
             ↓ builds features, commits to main, marks Done in Linear

Overnight: ralph-loop-qa.sh "ProjectName"  
             ↓ discovers bugs, fixes them, strengthens tests
             ↓ locks perfected modules, reports to Linear

Morning:   Check Linear on phone
             ↓ see what was built, what was improved, what's stuck
             ↓ review any STUCK items that need human judgment
```

### Ongoing Project Cadence

```
Week 1: Build features (ralph-loop) → QA overnight (ralph-loop-qa)
Week 2: Build more features → QA overnight (including regression on week 1)
Week 3: Few new features → mostly QA refinement → most modules locked
Week 4: Final features → all modules locked → ship
```

### Linear Shows the Full Picture

```
FEATURES (from ralph-loop):
  DRS-10: [1.1] Create user schema          — Done
  DRS-11: [1.2] Build registration API       — Done  
  DRS-12: [1.3] Registration UI              — Done

QA MODULES (from ralph-loop-qa):
  QA-1: Registration module                  — Locked (84% mutation score)
  QA-2: Travel module                        — In progress (63% mutation score)
  QA-3: Auth module                          — Queued
  
  QA-1 comments:
    "Adversary found 7 bugs. All fixed."
    "Mutation score: 45% → 67% → 78% → 84%"
    "2 regressions caught and reverted, then fixed properly"
    "Module LOCKED at 84% mutation score"
```

---

## Regression Prevention Architecture

### The Global Ratchet

Every fix attempt in ralph-loop-qa runs ALL tests across ALL modules:

```bash
# Before fix
SNAPSHOT_ALL_PASS=$(npm test | count_passing)
SNAPSHOT_FROZEN=$(playwright test tests/frozen/ | count_passing)
SNAPSHOT_MUTATION_AUTH=$(stryker run --mutate 'src/auth/**' | get_score)
SNAPSHOT_MUTATION_TRAVEL=$(stryker run --mutate 'src/travel/**' | get_score)
# ... all modules

# After fix — mechanical comparison
AFTER_ALL_PASS=$(npm test | count_passing)
if [ "$AFTER_ALL_PASS" -lt "$SNAPSHOT_ALL_PASS" ]; then
  git checkout -- .   # REVERT — no discussion
fi
```

The agent is never asked "did you introduce a regression?" The script compares numbers.

### What Makes This Honest

| Cheating attempt | Why it fails |
|-----------------|-------------|
| Weaken assertions to pass | Frozen tests can't be edited, mutation score would drop |
| Delete a failing test | Test count would drop, ratchet reverts |
| Mock the database | Playwright runs against real app, Stryker mutates real code |
| Fix module A by breaking module B | ALL module scores checked, any drop = revert |
| Claim "test was flaky" | Flaky tests quarantined with reason code, not deleted |
| Write tautological tests | Mutation score catches them — if `>` flipped to `<` and test still passes, the test is useless |

---

## Build Order

| Step | What | Depends On | Effort |
|------|------|-----------|--------|
| 1 | Modify `anneal.md` — add no-oracle-drift rules | Nothing | Small |
| 2 | New `contract-pack.md` — frozen oracle from spec | Nothing | Medium |
| 3 | New `mutation-gate.md` — Stryker integration | Nothing | Medium |
| 4 | New `ralph-loop-qa.sh` — overnight QA loop | Steps 1-3 | Large |
| 5 | New `ralph-loop-qa.md` — documentation | Step 4 | Small |
| 6 | Update `commands.md` | Steps 1-5 | Small |
| 7 | Update Obsidian reference | Steps 1-6 | Small |
| 8 | Install to Claude + Codex globals | Steps 1-7 | Small |

Steps 1-3 are independently valuable. Step 4 combines them into the overnight engine. Steps 5-8 are documentation and distribution.

---

## Open Questions for Adversarial Review

1. Is the module-by-module approach right, or should the QA loop iterate by severity (worst bugs first regardless of module)?
2. Should Stryker run on every iteration (slow) or only at stage boundaries (faster but less granular)?
3. How to handle the dev server — does ralph-loop-qa start/stop it, or assume it's running?
4. For the contract-pack: should the QA agent use Playwright MCP directly, or generate test files that Playwright runs later?
5. How to define "module" — by directory? by feature? by Linear parent issue?
6. Should locked modules ever be unlocked (e.g., when a new feature touches a locked module)?
7. Is the 80% mutation threshold realistic for all codebases, or should it be configurable?
8. How to handle Stryker performance — full mutation run on a large codebase could take hours?

---

*Status: PLAN — awaiting adversarial review before execution*
*Last updated: 2026-04-10*
