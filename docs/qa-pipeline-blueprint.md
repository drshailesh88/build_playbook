# QA Pipeline Implementation Blueprint
**Version 1 · 2026-04-14 · Status: DESIGN LOCKED, AWAITING GRILL**

Authoritative design document for the hardened QA testing engine that ships with `build_playbook` as an installable scaffold into any Next.js target app. Synthesizes 15 grill-session decisions. Supersedes `docs/qa-pipeline-evolution-plan.md`.

---

## Operating Principle

> **Build it right, build it complete, build it now.**
>
> Every "defer for later" or "start simple, upgrade when needed" is a future emergency where I stop building my product to fix my testing infrastructure. This pipeline will handle every app I build, including apps where money flows. It is built once.

Corollaries:
- The harness owns truth. Agents never self-report test results.
- The entity that writes code NEVER declares it works.
- Evidence doesn't get narrated by an AI. Reports are deterministic.
- Trust the prompt, verify with code.
- No unclassified code. No silent defaults. No bypass paths.

---

## What This Is (One Page)

**A local-CLI QA harness that runs overnight against a Next.js app and produces rigorous, trustworthy verdicts without agent cheating.**

**Target user:** solo builder with one high-stakes Next.js app and Claude Code access (Codex/Gemini pluggable later).

**Delivery:** installable scaffold shipped by `build_playbook`. One command (`/playbook:install-qa-harness`) drops a fully configured `.quality/` tree + enforcement hooks + service-specific setup (Clerk, Razorpay, Drizzle, etc.) into the target repo.

**Loop shape:** controller orchestrates fresh Claude sessions against structured repair packets. Deterministic gates (tsc, ESLint, Vitest, Playwright, Stryker, axe, Lighthouse, security audit) run via subprocess. Mutation-score ratchet per module prevents regression. 4-layer enforcement (Claude permissions + bash hooks + controller diff audit + pre-commit) prevents agents from editing the exam paper.

**Runtime:** local, overnight. macOS notification at session end. Single deterministic `summary.md` report. No cloud infrastructure, no webhooks, no monitoring service.

**Scale target:** 10–20 features per app, overnight serial. Parallelism deferred (see §9).

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│                       User's Target Next.js App                       │
│                                                                       │
│   ┌─────────────────┐                    ┌────────────────────────┐   │
│   │   src/, app/    │◄─── fixer edits ───│  Claude Code session   │   │
│   │   (editable)    │                    │  (fresh, --max-turns=30)│   │
│   └─────────────────┘                    │                         │   │
│                                          │  Layer 1: permissions   │   │
│   ┌─────────────────────────────┐        │  Layer 2: bash hook     │   │
│   │ .quality/ (locked)          │◄──┐    └────────────────────────┘   │
│   │  contracts/                 │   │                ▲                 │
│   │  locked-tests/              │   │                │ invoked fresh   │
│   │  policies/                  │   │                │ per iteration   │
│   │  state.json                 │   │                │                 │
│   │  runs/<id>/...              │   │    ┌───────────┴───────────┐    │
│   └─────────────────────────────┘   │    │   qa-controller.ts    │    │
│                                      │    │  (Node + tsx CLI)     │    │
│   ┌─────────────────────────────┐   │    │                       │    │
│   │ Config files (locked)       │   │    │  - orchestrates loop  │    │
│   │  vitest.config.ts           │   │    │  - builds packets     │    │
│   │  playwright.config.ts       │   │    │  - runs gates         │    │
│   │  stryker.conf.mjs           │   │    │  - computes ratchet   │    │
│   │  tsconfig.json              │   │    │  - diff audit (L3)    │    │
│   │  eslint.config.mjs          │   ├────┤  - report writer      │    │
│   └─────────────────────────────┘   │    └───────────────────────┘    │
│                                      │                ▲                 │
│   ┌─────────────────────────────┐   │                │                 │
│   │ .husky/pre-commit (Layer 4) │───┘                │                 │
│   └─────────────────────────────┘                    │                 │
│                                                       │                 │
│   ┌──────────────────────────────────────────────────┴──────────────┐ │
│   │ Deterministic gates (subprocess, harness-owned):                 │ │
│   │  tsc, ESLint, Knip, Vitest, Playwright, Stryker, axe, Lighthouse │ │
│   │  API contract validation, migration safety, security audit       │ │
│   └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘

Playbook repo (this repo, build_playbook):
  playbook/qa-scaffold/
    registry/services/*.yaml       (10-12 services)
    registry/providers/*.yaml      (Claude + Codex/Gemini disabled)
    snippets/global-setup/
    snippets/mocks/
    snippets/tiers/
    installer/                      (bash + tsx installer)
  commands/
    install-qa-harness.md
    qa-run.md, qa-baseline.md, qa-status.md, qa-report.md, ...
    contract-pack.md                (updated path: .quality/contracts/)
    deprecated/{anneal,harden,spec-runner,anneal-check}.md
```

---

## Part 1 — Target App Scaffold

Complete file tree created by `/playbook:install-qa-harness`:

```
<target-app>/
├── .claude/
│   ├── settings.json                          # Layer 1 permissions.deny (loop mode)
│   ├── settings-contract-authoring.json       # Source-denied variant for A2
│   ├── settings-test-authoring.json           # Same for T2
│   ├── settings-selector-wiring.json          # Tight selector-only permissions
│   └── hooks/
│       └── block-locked-paths.sh              # Layer 2 bash hook
├── .husky/
│   └── pre-commit                             # Layer 4 (diff check)
├── .quality/
│   ├── contracts/                             # locked per feature
│   │   └── <feature>/
│   │       ├── index.yaml                     # machine-readable metadata
│   │       ├── examples.md
│   │       ├── counterexamples.md
│   │       ├── invariants.md
│   │       ├── acceptance.spec.ts             # Playwright, locked
│   │       ├── regressions.spec.ts            # grows over time
│   │       └── api-contract.json              # optional
│   ├── policies/
│   │   ├── tiers.yaml                         # glob → tier mapping
│   │   ├── detected-services.yaml             # auto-detection output
│   │   ├── providers.yaml                     # provider enable/disable
│   │   ├── thresholds.yaml                    # retry cap, plateau N, budgets
│   │   └── lock-manifest.json                 # SHA256 of locked files
│   ├── runs/                                  # R4 split (see §6)
│   │   ├── .gitignore                         # heavy artifacts
│   │   └── <run-id>/
│   │       ├── summary.md                     # committed
│   │       ├── state-delta.json               # committed
│   │       ├── violations.jsonl               # committed
│   │       ├── packets/<feature>-<n>.md       # committed
│   │       ├── evidence/                      # gitignored
│   │       ├── fixer-notes/                   # gitignored
│   │       ├── traces/                        # gitignored
│   │       ├── stryker-html/                  # gitignored
│   │       └── playwright-report/             # gitignored
│   ├── state.json                             # committed, S2 schema
│   └── state.lock                             # gitignored, L1 pattern
├── qa/                                        # controller code
│   ├── package.json                           # qa-controller deps
│   ├── controller.ts                          # main entry
│   ├── run-one-attempt.ts
│   ├── judge.ts
│   ├── parsers/
│   │   ├── vitest-junit.ts
│   │   ├── playwright-json.ts
│   │   └── stryker-json.ts                    # reads mutation.json + incremental.json
│   ├── gates/
│   │   ├── contract-hash-verify.ts
│   │   ├── lock-manifest-verify.ts
│   │   ├── tsc.ts
│   │   ├── eslint.ts
│   │   ├── knip.ts
│   │   ├── vitest.ts
│   │   ├── playwright-targeted.ts
│   │   ├── contract-test-count.ts             # 14a addition
│   │   ├── diff-audit.ts                      # regex + AST (10A-γ)
│   │   ├── test-count-sanity.ts               # 8a addition
│   │   ├── stryker-incremental.ts
│   │   ├── tier-floor.ts
│   │   ├── ratchet.ts
│   │   ├── api-contract-validation.ts         # 14b release gate
│   │   ├── migration-safety.ts                # 14b release gate
│   │   ├── axe-accessibility.ts
│   │   ├── visual-regression.ts               # Playwright native
│   │   ├── lighthouse-ci.ts
│   │   ├── bundle-size.ts
│   │   ├── npm-audit.ts
│   │   └── license-compliance.ts
│   ├── providers/
│   │   ├── base.ts                            # FixerProvider interface
│   │   ├── claude.ts                          # ships enabled
│   │   ├── codex.ts                           # scaffolded, not_enabled
│   │   └── gemini.ts                          # scaffolded, not_enabled
│   ├── detection/
│   │   ├── service-detector.ts                # scans package.json + .env.example
│   │   ├── dependency-analyzer.ts             # dep-cruiser wrapper, depth 1
│   │   └── registry-loader.ts                 # loads playbook/qa-scaffold/registry
│   ├── diff-audit/
│   │   ├── regex-patterns.ts                  # 10a + 10A additions
│   │   ├── ast-assertion-analyzer.ts          # 10A-γ day 1
│   │   └── hardcoded-return-detector.ts
│   ├── reports/
│   │   └── summary-writer.ts                  # deterministic, 13e.i
│   ├── recovery.ts                            # 15c R-2
│   ├── packet-builder.ts
│   ├── state-manager.ts
│   └── types.ts
├── tests/
│   ├── global-setup.ts                        # Clerk setup, seeded users
│   ├── unit/                                  # editable per α
│   ├── integration/                           # editable per α
│   ├── mocks/                                 # MSW handlers (Razorpay webhooks, etc.)
│   └── helpers/                               # editable
├── scripts/
│   └── qa/
│       ├── reset-test-db.ts                   # TRUNCATE + seed
│       └── seed-test-users.ts                 # Clerk test users
├── .env.test.example                          # auto-generated from services
├── .env.test                                  # user fills, gitignored
├── playwright.config.ts                       # locked after install
├── stryker.conf.mjs                           # locked after install
└── package.json                               # deps merged from registry
```

### Package.json scripts added:

```json
{
  "scripts": {
    "qa": "tsx qa/controller.ts",
    "qa:run": "tsx qa/controller.ts run",
    "qa:baseline": "tsx qa/controller.ts baseline",
    "qa:status": "tsx qa/controller.ts status",
    "qa:report": "tsx qa/controller.ts report",
    "qa:doctor": "tsx qa/controller.ts doctor",
    "qa:clean": "tsx qa/controller.ts clean"
  }
}
```

---

## Part 2 — Service Registry (Auto-Detection Layer)

### 2.1 Registry location

```
playbook/qa-scaffold/registry/
  services/
    clerk.yaml
    nextauth.yaml
    stripe.yaml
    razorpay.yaml
    lemon-squeezy.yaml
    drizzle-postgres.yaml
    prisma-postgres.yaml
    supabase.yaml
    resend.yaml
    sentry.yaml
    upstash.yaml
  snippets/
    global-setup/
      clerk.ts
      nextauth.ts
    mocks/
      razorpay-webhook.ts
      stripe-webhook.ts
      resend-email.ts
    tiers/
      auth-critical.yaml
      payments-critical.yaml
      db-critical.yaml
```

### 2.2 Service manifest schema

```yaml
# playbook/qa-scaffold/registry/services/clerk.yaml
name: clerk
display_name: "Clerk (Authentication)"
category_hint: auth
status: validated    # validated | draft | stub

detection:
  package_patterns: ["@clerk/nextjs", "@clerk/testing"]
  env_patterns: ["CLERK_*", "NEXT_PUBLIC_CLERK_*"]

env_test_vars:
  required:
    - { name: CLERK_SECRET_KEY, description: "Clerk test instance secret key" }
    - { name: NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY, description: "Clerk test publishable key" }
    - { name: E2E_CLERK_USER_USERNAME, description: "Primary test user email" }
    - { name: E2E_CLERK_USER_PASSWORD, description: "Primary test user password" }
  optional:
    - { name: E2E_CLERK_ADMIN_USERNAME }
    - { name: E2E_CLERK_ADMIN_PASSWORD }

snippets:
  global_setup: snippets/global-setup/clerk.ts
  auto_install_dev_packages:
    - "@clerk/testing"
  playwright_config_patches:
    - path: "globalSetup"
      value: "./tests/global-setup.ts"

tier_hints:
  critical_75:
    - "src/**/auth/**"
    - "app/**/api/auth/**"
    - "middleware.ts"

documentation_url: "https://clerk.com/docs/testing/playwright/overview"

security_notes: |
  Session state saved to playwright/.clerk/user.json. Gitignore this path.
  Use Testing Tokens for bot detection bypass during E2E runs.
```

### 2.3 Installer behavior

1. Walk every `playbook/qa-scaffold/registry/services/*.yaml`
2. For each manifest, evaluate `detection.package_patterns` against target's `package.json` and `detection.env_patterns` against target's `.env.example`
3. Matches → merge `env_test_vars` into `.env.test.example`, install `auto_install_dev_packages`, inject `snippets.global_setup` content into `tests/global-setup.ts`, patch `playwright.config.ts`, merge `tier_hints` into `.quality/policies/tiers.yaml`
4. Unknown deps → behavior depends on `--strict-detection` flag:
   - Default (F2): warn + skip, log to `.quality/install-report.md`
   - `--strict-detection`: F1 fail-hard
   - `--stub-unknowns`: F3 generate `.yaml.stub` for future completion
5. Write `detected-services.yaml` with provenance (L2 — user-editable except `installed_from_registry` field)

### 2.4 Initial registry (v1 ships with all 12)

| Service | Status | Validation |
|---|---|---|
| clerk | validated | User's actual stack |
| razorpay | validated | User's actual stack |
| drizzle-postgres | validated | User's actual stack |
| nextauth | draft | Claude-authored, validate on first use |
| stripe | draft | Claude-authored, validate on first use |
| lemon-squeezy | draft | Claude-authored |
| prisma-postgres | draft | Claude-authored |
| supabase | draft | Claude-authored |
| resend | draft | Claude-authored |
| sentry | draft | Claude-authored |
| upstash | draft | Claude-authored |
| auth.js | draft | Claude-authored |

**Drafts are committed but have `status: draft` in manifest. First-use of a draft triggers an "unvalidated manifest" prompt in installer: "This manifest has not been validated against a real app. Review before proceeding?"**

---

## Part 3 — Contract System

### 3.1 Location

All under `.quality/contracts/<feature>/` (C2 reconciliation — existing `contract-pack.md` command gets one-line path update).

### 3.2 `index.yaml` schema (complete, with all additions)

```yaml
schema_version: 1

feature:
  id: auth-login
  title: "User authentication — email/password login"
  tier: critical_75                # declared; wins over glob-based tier
  category: auth                   # auth | payments | user_data | business_logic | ui
  status: frozen                   # draft | pending_approval | frozen | versioning
  security_sensitive: true         # 12b addition — auto-true for auth/payments/user_data

approval:
  approved_by: shailesh
  approved_at: 2026-04-14T00:00:00Z
  pr_or_commit: b6166e5

source_docs:
  - .planning/PRD.md#authentication
  - .planning/features/auth-login.md
  - UBIQUITOUS_LANGUAGE.md

artifacts:
  examples: examples.md
  counterexamples: counterexamples.md
  invariants: invariants.md
  acceptance_tests: acceptance.spec.ts
  regression_tests: regressions.spec.ts
  api_contract: api-contract.json   # null if not API-facing

counts:                             # used by 14a contract-test-count gate
  examples: 8
  counterexamples: 4
  invariants: 5
  acceptance_tests: 12
  regression_tests: 0

affected_modules:                   # drives T4 Stryker targeting
  - "src/auth/**"
  - "src/lib/session.ts"
  - "app/api/auth/**"
  - "middleware.ts"

test_data:
  seeded_users: [test_user, test_admin]
  requires_services: [clerk, drizzle-postgres]

hashes:                             # H3 — written on freeze, verified every run
  examples.md: "sha256:abc..."
  counterexamples.md: "sha256:def..."
  invariants.md: "sha256:ghi..."
  acceptance.spec.ts: "sha256:jkl..."
  api-contract.json: "sha256:mno..."
  # regressions.spec.ts intentionally NOT hashed (grows over time)

version: 2
version_history:
  - version: 1
    date: 2026-04-14
    approved_by: shailesh
    reason: "Initial contract"
    diff_summary: "+8 examples, +4 counterexamples, +12 tests"
    authoring_mode: source_denied
  - version: 2
    date: 2026-04-18
    approved_by: shailesh
    reason: "Added social login from PRD v2"
    diff_summary: "+2 examples, +4 tests"
    authoring_mode: source_denied    # required for security_sensitive per 12e
    baseline_reset_triggered: true   # 12e addition
```

### 3.3 Category-based enforcement (12d)

On `qa run` start, controller checks each feature:

| Category | status | Result |
|---|---|---|
| auth / payments / user_data | frozen | ✅ included in run |
| auth / payments / user_data | draft / pending_approval | ❌ HARD ERROR, session blocks |
| auth / payments / user_data | missing contract | ❌ HARD ERROR, session blocks |
| business_logic / ui | frozen | ✅ included, tier floor enforced |
| business_logic / ui | missing contract | ⚠️ WARN + skip, fall into O-γ path |

### 3.4 Authoring workflow

**Initial authoring (A2):**
1. User invokes `/playbook:contract-pack <feature>`
2. Controller swaps `.claude/settings.json` → `settings-contract-authoring.json` (deny Read on all source)
3. Claude interviews per existing `contract-pack.md` flow
4. User approves content
5. Artifacts written to `.quality/contracts/<feature>/`
6. SHA256 hashes computed (H3)
7. `index.yaml` written with all metadata
8. Settings swapped back
9. Git commit
10. Layer 1 permissions.deny now applies to these files

**Version bump:**
- Regular features: same flow, `--version-bump` flag
- `security_sensitive: true` features: MUST use source-denied (A2) even for bumps (12e)
- Baseline reset automatically triggered for `affected_modules`, audit-logged

### 3.5 Locked test authoring (T2 + T3)

**Initial (T2):**
1. `/playbook:author-locked-tests <feature>`
2. Controller swaps to `settings-test-authoring.json` (source still denied)
3. Claude reads `index.yaml` + `examples.md` + `counterexamples.md`
4. Writes `acceptance.spec.ts.draft`
5. User renames to `.spec.ts`, commits
6. Locked under Layer 1

**Selector wiring (T3 fallback):**
1. Tests fail on first run due to unmatched selectors
2. `/playbook:wire-selectors <feature>`
3. Controller swaps to `settings-selector-wiring.json` (allows Read on `src/app/<feature>/**` AND `acceptance.spec.ts`, DENY on everything else)
4. Claude adjusts ONLY `data-testid` selectors
5. **Post-wiring diff check (9b addition):** if any `expect()` line changed, reject the wiring, revert, feed violation to next attempt
6. User commits wired tests
7. Locked again

---

## Part 4 — Enforcement Stack (4 Layers)

### Layer 1 — `.claude/settings.json` (permissions.deny)

```jsonc
// Loop-mode settings (active during qa:run)
{
  "permissions": {
    "deny": [
      "Edit(./.quality/**)", "Write(./.quality/**)",
      "Edit(./vitest.config.ts)", "Write(./vitest.config.ts)",
      "Edit(./playwright.config.ts)", "Write(./playwright.config.ts)",
      "Edit(./stryker.conf.mjs)", "Write(./stryker.conf.mjs)",
      "Edit(./tsconfig.json)", "Write(./tsconfig.json)",
      "Edit(./eslint.config.mjs)", "Write(./eslint.config.mjs)",
      "Edit(./tests/e2e/**)", "Write(./tests/e2e/**)",
      "Edit(./e2e/**)", "Write(./e2e/**)",
      "Edit(./tests/**/__snapshots__/**)",
      "Edit(./e2e/**/*-snapshots/**)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "command": ".claude/hooks/block-locked-paths.sh" }
    ]
  }
}
```

### Layer 2 — `.claude/hooks/block-locked-paths.sh`

```bash
#!/bin/bash
# Blocks Bash commands that would write to locked paths
# Claude's permissions.deny covers Edit/Write tools but NOT bash sed/cat/echo redirects

TOOL_INPUT="$1"
LOCKED_PATTERNS='\.quality/|vitest\.config|playwright\.config|stryker\.conf|tsconfig\.json|eslint\.config\.mjs|tests/e2e/|e2e/.*\.spec|/\.claude/settings'
WRITE_OPERATIONS='(>|>>|tee|sed -i|chmod|mv|cp|dd)'

if echo "$TOOL_INPUT" | grep -E "$WRITE_OPERATIONS" | grep -E "$LOCKED_PATTERNS"; then
  echo "BLOCKED: Bash command would modify a locked path." >&2
  echo "Locked pattern matched: $(echo "$TOOL_INPUT" | grep -oE "$LOCKED_PATTERNS" | head -1)" >&2
  exit 2   # exits 2 = PreToolUse blocks the tool call
fi

exit 0
```

### Layer 3 — Controller diff audit (regex + AST, 10A-γ)

Applied after every fixer invocation:

1. Compute `git diff HEAD` against pre-invocation commit
2. Revert any edits to locked paths (`git checkout HEAD -- <path>`)
3. Apply regex patterns from §10.1 to detect cheating signals
4. For test files: parse AST (both before and after), compute assertion-strength metrics
5. Violations logged to `.quality/runs/<id>/violations.jsonl`
6. Violations fed back into next repair packet as VIOLATION_HISTORY

### Layer 4 — `.husky/pre-commit`

```bash
#!/bin/bash
# Blocks commits that touch locked paths without going through the controller

STAGED=$(git diff --cached --name-only)
LOCKED_PATTERN='^(\.quality/|vitest\.config|playwright\.config|stryker\.conf|tsconfig\.json|eslint\.config\.mjs|tests/e2e/|e2e/.*\.spec)'

LOCKED_MATCHES=$(echo "$STAGED" | grep -E "$LOCKED_PATTERN")

if [ -n "$LOCKED_MATCHES" ]; then
  # Check for controller marker commit (controller signs its commits)
  if [ -f ".quality/state.lock" ] && [ -n "$QA_CONTROLLER_COMMIT" ]; then
    exit 0   # controller-driven commit, allowed
  fi
  echo "ERROR: Commit touches locked paths without controller authorization:" >&2
  echo "$LOCKED_MATCHES" >&2
  echo "Run through /playbook:qa-run, or use /playbook:qa-baseline-reset for explicit changes." >&2
  exit 1
fi

# Also run anti-cheat diff audit on staged test files
tsx qa/gates/diff-audit.ts --staged-only || exit 1

exit 0
```

---

## Part 5 — The Loop

### 5.1 Session lifecycle

```
qa run invoked
  ↓
Recovery & preflight (R-2)
  ├─ stale lock check, dirty tree check, abandoned runs, Stryker cache freshness
  ├─ qa-doctor drift check (services, hashes, contracts)
  └─ Pass or fail fast with clear message
  ↓
Session start
  ├─ Create .quality/state.lock with PID
  ├─ Create .quality/runs/<run-id>/
  ├─ Start full Stryker BASELINE (parallel to static gates)
  ├─ While Stryker runs: contract hash verification + lock manifest verify
  ├─ Populate baseline into state.json (B4 ratchet-up only)
  ↓
Feature enumeration
  ├─ Read all .quality/contracts/*/index.yaml
  ├─ Apply 12d category gate:
  │   - auth/payments/user_data missing frozen contract → HARD ERROR
  │   - business_logic/ui missing contract → skip-with-warning (O-γ)
  ├─ Filter to features below tier floor or with !has_exceeded_floor
  └─ Order by category priority (security_sensitive first)
  ↓
For each feature (SERIAL — C1):
  └─ Feature loop (see §5.2)
  ↓
Session end
  ├─ Run MANDATORY full Stryker (not incremental) — re-verification
  ├─ Run release gates (see §5.4)
  ├─ Compute baseline updates (ratchet up only)
  ├─ Write summary.md (deterministic, 13e.i)
  ├─ Write state-delta.json
  ├─ git add + commit "chore(qa): state update after <run-id>"
  ├─ Release state.lock
  ├─ osascript notification
  └─ open summary.md
```

### 5.2 Per-feature loop

```
feature start
  ↓
attempt = 1, plateau_buffer = []
  ↓
loop while attempt <= 10 AND !plateau_detected:
  ├─ pre-attempt git commit: "qa checkpoint: <feature> attempt <n>"
  ├─ build repair packet (§6.1)
  ├─ invoke fixer provider (Claude by default)
  ├─ [POST-FIXER] diff audit → if violation:
  │    ├─ revert locked paths
  │    ├─ log violation
  │    ├─ feed into next packet
  │    ├─ attempt++
  │    └─ continue
  ├─ run fast repair gates 1-14 (§5.3)
  ├─ compute state:
  │    ├─ GREEN? → commit iteration, mark feature green, break
  │    ├─ IMPROVED_NOT_GREEN? → commit iteration (new baseline), attempt++
  │    ├─ REGRESSED? → git reset --hard to pre-attempt commit, attempt++
  │    ├─ VIOLATION? → (handled above)
  │    └─ BLOCKED? → mark blocked, save evidence, exit feature loop
  ├─ compute plateau signature: hash(failed_gate + error_message + metric_snapshot)
  ├─ plateau_buffer.push(signature)
  └─ if last 3 signatures identical AND no metric improvement → mark BLOCKED
  ↓
Safety cap: attempt 10 with no progress → mark BLOCKED
```

### 5.3 Fast Repair gates (runs every iteration, short-circuits on cheap failures)

| # | Gate | Typical time | Fail mode |
|---|---|---|---|
| 1 | Contract hash verification | ~1s | HARD: CONTRACT_TAMPERED |
| 2 | Lock manifest integrity | ~1s | HARD: LOCK_TAMPERED |
| 3 | tsc --noEmit strict | 10-30s | continue to audit, then packet |
| 4 | ESLint (with anti-cheat rules) | 5-15s | continue |
| 5 | Knip (dead code detection) | 5-10s | continue |
| 6 | Vitest unit | 10-60s | continue |
| 7 | Vitest integration | 30-120s | continue |
| 8 | Playwright targeted (feature's acceptance.spec.ts) | 30-180s | continue |
| 9 | Contract test count (14a — actual tests ran vs counts.acceptance_tests) | ~1s | HARD: test deletion signal |
| 10 | Diff audit (regex + AST) | 5-10s | HARD: VIOLATION |
| 11 | Test count sanity (8a — total consistency with prior runs) | ~1s | HARD: data corruption |
| 12 | Stryker incremental + T4 targeted | 60-180s | continue to ratchet check |
| 13 | Tier floor check | ~1s | determines green vs not-green |
| 14 | Ratchet check | ~1s | determines keep vs revert |

**Total typical inner iteration: 4–10 minutes.**

### 5.4 Release gates (runs ONCE at session end, all mandatory)

| # | Gate | Typical time | Parallel group |
|---|---|---|---|
| 1 | Full Stryker (no incremental) | 10-40m | alone |
| 2 | Full Vitest with --coverage | 2-10m | parallel |
| 3 | Full Playwright (all contracts + E2E, all browsers) | 5-30m | parallel |
| 4 | Accessibility (axe-core across all routes) | 2-5m | parallel |
| 5 | Visual regression (Playwright toHaveScreenshot) | 2-10m | parallel |
| 6 | Security audit (`/playbook:security-audit` integrated) | 5-15m | parallel |
| 7 | API contract validation (14b) | 2-5m | parallel |
| 8 | Database migration safety (14b) | ~30s | parallel |
| 9 | Bundle size check | 1-3m | parallel |
| 10 | Lighthouse CI | 3-10m | parallel |
| 11 | npm audit | 10-30s | parallel |
| 12 | License compliance | 30s | parallel |
| 13 | Dependency freshness (outdated flags) | 30s | parallel |
| 14 | Full contract hash verification | 5s | alone |
| 15 | Final ratchet commit to state.json | 1s | alone |

**Parallelization:** gates 2-13 run concurrently while gate 1 (Stryker) continues. Total wall clock ≈ max(Stryker, slowest_parallel) + serial overhead.

**Release verdict:** RED if any of 1-5 fail. WARN (non-blocking) if 6-13 fail. HARD if 14 fails.

---

## Part 6 — Data Contracts

### 6.1 Repair packet schema (F4 — markdown with YAML frontmatter)

File: `.quality/runs/<run-id>/packets/<feature>-<attempt>.md`

```markdown
---
packet_version: 1
run_id: run-2026-04-14-001
feature_id: auth-login
attempt_number: 3
session_id: session-2026-04-14T21-30-00Z

failed_gates:
  - gate: vitest-unit
    tests_failed: 2
    tests_total: 47
    first_failure:
      test: "tests/unit/auth/login.test.ts > validateSession > rejects expired tokens"
      expected: "{ valid: false, reason: 'expired' }"
      received: "{ valid: false, reason: undefined }"
  - gate: stryker-incremental
    module_mutation_scores:
      "src/auth/login.ts": 54    # floor 75
    surviving_mutants_count: 11

ratchet_targets:
  - metric: "mutation_score.src/auth/login.ts"
    must_be: ">= 75"
  - metric: "playwright.auth-login.acceptance"
    must_be: "all_pass"

allowed_edit_paths:
  - "src/auth/**"
  - "src/lib/session.ts"
  - "tests/unit/auth/**"      # α strategy — editable with anti-cheat

forbidden_edit_paths:
  - ".quality/**"
  - "vitest.config.ts"
  - "playwright.config.ts"
  - "stryker.conf.mjs"
  - "tests/e2e/**"
  - "**/__snapshots__/**"

codebase_context:               # 7b addition — controller-computed via dep-cruiser depth 1
  - "src/auth/login.ts"          # the failing file
  - "src/auth/session.ts"        # direct import
  - "src/auth/providers/clerk.ts"
  - "src/lib/jwt.ts"
  - "src/lib/logger.ts"

hypothesis:                     # 7b addition — controller's best root-cause guess
  confidence: medium
  summary: >
    The `reason` field is undefined when token.exp < now. Likely missing
    destructuring assignment in validateSession's error path. Check line
    42 in login.ts where isExpired() branches.
  evidence:
    - "src/auth/login.ts:42 surviving mutant: BooleanLiteral true→false in isExpired check"
    - "Expected 'reason: expired', received 'reason: undefined' (undefined suggests missing assignment)"

evidence_paths:
  - ".quality/runs/run-2026-04-14-001/evidence/vitest-output.txt"
  - ".quality/runs/run-2026-04-14-001/evidence/stryker-mutation.json"

prior_attempts:                 # C4 graduated fidelity
  - attempt: 1
    approach: "Added null check in validateSession"
    result: "Tests still failed with same error"
    # one-line summary only for older priors
  - attempt: 2
    approach: "Rewrote validateSession using async/await"
    result: "REGRESSED: mutation score 62 → 54, reverted"
    # full error output included because this is the immediate prior
    error_output: |
      FAIL  tests/unit/auth/login.test.ts > validateSession > rejects expired tokens
      Expected: { valid: false, reason: "expired" }
      Received: { valid: false, reason: undefined }
      [full stack trace...]

violation_history: []           # full diff if any prior attempt violated

max_turns: 30                   # fixer invocation budget
---

## Task
Fix the 2 failing unit tests in `src/auth/login.ts` and reduce 11 surviving
mutants to bring mutation score above the 75% floor for this critical module.

## Rules (non-negotiable)
- Do NOT edit any path in `forbidden_edit_paths`.
- Do NOT add `.skip`, `.only`, `test.todo`, or `describe.skip`.
- Do NOT weaken assertions (remove expect() calls, replace specific
  assertions with `toBeTruthy()`).
- Do NOT widen coverage exclusions.
- Do NOT use `mockReturnValue(X)` where X matches an assertion value in the
  same test (testing the mock, not the code).
- Do NOT introduce if/else branching inside test bodies.
- When done, write your approach summary to
  `.quality/runs/run-2026-04-14-001/fixer-notes/auth-login-3.md`.

## Evidence
Full test output: `.quality/runs/run-2026-04-14-001/evidence/vitest-output.txt`
Stryker report: `.quality/runs/run-2026-04-14-001/evidence/stryker-mutation.json`
```

### 6.2 `state.json` schema (S2 + B4 + sanity metadata)

```json
{
  "schema_version": 1,
  "last_updated": "2026-04-14T22:45:00Z",
  "last_run_id": "run-2026-04-14-001",

  "features": {
    "auth-login": {
      "contract_version": 2,
      "status": "green",
      "last_green_run_id": "run-2026-04-14-001",
      "last_green_at": "2026-04-14T22:00:00Z",
      "attempts_this_session": 2,
      "plateau_buffer": []
    },
    "payment-refund": {
      "status": "blocked",
      "blocked_at": "2026-04-14T22:30:00Z",
      "blocked_reason": "plateau_detected",
      "blocked_signature": "vitest-unit:refund-amount-validation:expected-error",
      "attempts_this_session": 10
    }
  },

  "modules": {
    "src/auth/login.ts": {
      "tier": "critical_75",
      "declared_in_contract": "auth-login",
      "mutation_baseline": 81,
      "mutation_baseline_set_at": "2026-04-14T22:00:00Z",
      "mutation_baseline_run_id": "run-2026-04-14-001",
      "has_exceeded_floor": true,
      "test_coverage_baseline": 94
    },
    "src/auth/session.ts": {
      "tier": "critical_75",
      "mutation_baseline": 76,
      "has_exceeded_floor": true
    }
  },

  "baseline_reset_log": [
    {
      "timestamp": "2026-04-10T14:00:00Z",
      "module": "src/lib/payments/refund.ts",
      "old_baseline": 72,
      "new_baseline": 58,
      "reason": "Large refactor per PRD v2 — legitimate reset",
      "triggered_by": "qa-baseline-reset command",
      "approved_by": "shailesh"
    }
  ],

  "test_count_history": {
    "vitest_unit": [245, 247, 247, 247],
    "vitest_integration": [89, 89, 91, 91],
    "playwright": [47, 47, 59, 59]
  },

  "runs": {
    "run-2026-04-14-001": {
      "started_at": "2026-04-14T21:30:00Z",
      "ended_at": "2026-04-14T22:45:00Z",
      "features_attempted": ["auth-login", "payment-checkout", "payment-refund"],
      "features_green": ["auth-login", "payment-checkout"],
      "features_blocked": ["payment-refund"],
      "violations_count": 0,
      "baseline_full_mutation_score": 74,
      "final_full_mutation_score": 78
    }
  }
}
```

### 6.3 Report format (deterministic, 13e.i, with 13d Contract Integrity section)

See full template in §11 summary.md structure.

**Key principle: NO LLM writes any part of the report.** Every section is template-filled from controller state. "Next Actions" prose derived from rule-based templates (blocked feature → "Review BLOCKED feature X").

---

## Part 7 — Slash Command Inventory

### Bootstrap & detection
- `/playbook:install-qa-harness` — full scaffold install, auto-detect services
- `/playbook:install-qa-harness --upgrade` — idempotent re-run
- `/playbook:install-qa-harness --strict-detection` — F1 fail-hard on unknown deps
- `/playbook:install-qa-harness --stub-unknowns` — F3 generate stub manifests

### Authoring
- `/playbook:contract-pack <feature>` — interactive contract authoring (source-denied)
- `/playbook:contract-pack <feature> --version-bump --reason="..."` — update existing
- `/playbook:author-locked-tests <feature>` — generate acceptance.spec.ts (source-denied)
- `/playbook:wire-selectors <feature>` — tight-scope selector fix-up (assertions diff-checked)

### Classification
- `/playbook:classify-modules` — interactive tiers.yaml builder from codebase scan
- `/playbook:classify-check` — verify every source file has a tier; fail-fast on unclassified

### Baseline & run
- `/playbook:qa-baseline` — full Stryker + all Vitest + all Playwright, populate state
- `/playbook:qa-baseline --module=<path>` — single-module refresh
- `/playbook:qa-run` — full loop over all unblocked features
- `/playbook:qa-run --feature=<id>` — single feature
- `/playbook:qa-run --category=auth` — filter by category
- `/playbook:qa-run --dry-run` — compute packet, don't invoke fixer

### Management
- `/playbook:qa-unblock <feature>` — reset BLOCKED state, allow retry
- `/playbook:qa-baseline-reset --module=X --reason="..."` — B4 explicit ratchet-down
- `/playbook:qa-doctor` — drift check: services vs package.json, contract hashes, deprecated commands, orphaned runs
- `/playbook:qa-clean` — remove stale locks, compress >30-day runs, orphaned directories

### Reporting
- `/playbook:qa-report` — cumulative report across all runs
- `/playbook:qa-report <run-id>` — single-run detail
- `/playbook:qa-status` — current state: green / blocked / pending counts
- `/playbook:qa-audit-violations` — review cheating attempts across runs

### Kept standalone (not subsumed)
- `/playbook:security-audit` — standalone AND integrated as Release gate #6
- `/playbook:verify-with-codex` — manual ad-hoc cross-model review

### Deprecated (D2 + D3)
- `/playbook:anneal` — stub redirects to `qa-run`
- `/playbook:anneal-check` — stub redirects to `qa-status`
- `/playbook:harden` — stub redirects to `qa-run + qa-report`
- `/playbook:spec-runner` — stub redirects to `qa-run`

Historical content preserved at `commands/deprecated/<name>.md`. `qa-doctor` flags both stub presence and deprecated/ folder with "consider removing entirely in next major version."

---

## Part 8 — Provider Abstraction (P2)

### 8.1 Interface

```typescript
// qa/providers/base.ts
export interface FixerProvider {
  name: string;
  isEnabled(): boolean;
  invoke(packet: RepairPacket, runId: string, attempt: number): Promise<FixerResult>;
}

export interface FixerResult {
  providerName: string;
  exitCode: number;
  stdout: string;
  stderr: string;
  durationMs: number;
  filesEditedCount: number;   // from git diff, not from fixer self-report
  fixerNotesPath?: string;     // where fixer wrote optional notes
}
```

### 8.2 Provider manifests

```
playbook/qa-scaffold/registry/providers/
  claude.yaml       (status: enabled)
  codex.yaml        (status: not_enabled — Seatbelt wrapper required)
  gemini.yaml       (status: not_enabled — Seatbelt wrapper required)
```

### 8.3 `.quality/policies/providers.yaml`

```yaml
schema_version: 1
active_fixer: claude
enabled:
  - claude
disabled:
  - codex
  - gemini
# Enabling codex/gemini requires Seatbelt wrapper per decision 15a
```

**To bring Codex online later:** install `claude-sandbox`, flip `codex` to `enabled` in providers.yaml, set `active_fixer: codex` or add to rotation. No controller code changes.

---

## Part 9 — Concurrency & Crash Recovery

### 9.1 Concurrency (15b — C1 serial)

Features processed one at a time. State.json written after each feature reaches terminal state. No shared mutable state between feature iterations.

**Controller architecture supports future parallelism:** feature processing is a single function `processFeature(feature, runId): Promise<FeatureResult>`. Swap the serial `for` loop for a worker pool when (if) 30+ features becomes common.

**Deferred until problem forces it:** per-worker ephemeral Postgres, per-worker Playwright ports, state.json merge-conflict resolution, Stryker memory parallelization.

### 9.2 Crash recovery (15c — R-2)

On every `qa run` start, preflight executes:

```
1. state.lock check:
   ├─ exists && PID alive → ERROR: concurrent run detected
   ├─ exists && PID dead → log stale, clear
   └─ absent → continue

2. git working tree:
   ├─ dirty → HARD ERROR: "Commit or stash before qa run. Dirty tree:\n<files>"
   └─ clean → continue

3. Last run directory:
   ├─ summary.md absent → mark ABANDONED
   └─ move to .quality/runs/abandoned/<run-id>/

4. Stryker cache freshness:
   ├─ .stryker-tmp/incremental.json mtime > last successful run start → discard, log
   └─ else → preserve

5. state.json integrity:
   ├─ parse errors → restore from HEAD: git checkout HEAD -- .quality/state.json
   ├─ schema_version mismatch → HARD ERROR: "state.json schema drift"
   └─ ok → continue
```

All recovery actions logged to `.quality/runs/<new-run-id>/preflight.log`.

---

## Part 10 — Anti-Cheat Pattern List (10A-γ, complete)

### 10.1 Regex patterns (Layer 3 diff audit)

```typescript
export const ANTI_CHEAT_REGEX_PATTERNS = [
  // Skip / disable
  { id: "SKIP_ADDED", regex: /^\+.*\b(test|it|describe)\.skip\s*\(/m, severity: "reject" },
  { id: "ONLY_ADDED", regex: /^\+.*\b(test|it|describe)\.only\s*\(/m, severity: "reject" },
  { id: "TODO_ADDED", regex: /^\+.*\b(test|it)\.todo\s*\(/m, severity: "reject" },
  { id: "XIT_ADDED", regex: /^\+\s*xit\s*\(/m, severity: "reject" },
  { id: "XDESCRIBE_ADDED", regex: /^\+\s*xdescribe\s*\(/m, severity: "reject" },

  // Tautologies
  { id: "EXPECT_TRUE_TRUE", regex: /^\+.*expect\(true\)\.toBe\(true\)/m, severity: "reject" },
  { id: "EXPECT_NUM_EQUALS_SELF", regex: /^\+.*expect\((\d+)\)\.toBe\(\1\)/m, severity: "reject" },

  // Test file deletion
  { id: "TEST_FILE_DELETED", computed: (diff) => /deleted file.*\.(test|spec)\.[jt]sx?/.test(diff), severity: "reject" },

  // Config widening
  { id: "COVERAGE_EXCLUDE_ADDED",
    paths: ["vitest.config.ts", "stryker.conf.mjs"],
    regex: /^\+.*(exclude|ignore|testPathIgnorePatterns)/m,
    severity: "reject" },
  { id: "THRESHOLD_LOWERED", paths: ["vitest.config.ts", "stryker.conf.mjs"],
    computed: detectThresholdDecrease, severity: "reject" },

  // Snapshot laundering
  { id: "SNAPSHOT_UPDATED_WITHOUT_SRC_CHANGE",
    computed: (diff) => hasSnapshotChange(diff) && !hasSrcChange(diff),
    severity: "reject" },

  // Mock abuse
  { id: "EXCESSIVE_MOCKING", regex: /^\+.*vi\.mock\(/gm,
    threshold: "per_file_count > 3", severity: "warn" },
  { id: "MOCK_RETURNS_EXPECTED",   // 10a addition
    computed: detectMockEqualsAssertion, severity: "warn" },

  // Test structure
  { id: "CONDITIONAL_TEST_LOGIC",  // 10a addition
    computed: detectIfElseInTestBody, severity: "warn" },

  // Source-side cheating
  { id: "HARDCODED_SUCCESS_RETURN", paths: ["src/**", "app/**"],
    regex: /^\+\s*return\s+\{\s*(success|authenticated|valid|ok)\s*:\s*true\s*\}/m,
    severity: "warn" },
];
```

### 10.2 AST-based assertion analysis (10A-γ day 1)

For every changed test file, parse before+after AST using `@babel/parser`:

- Count expect() calls pre vs post; reject if net negative
- Compare matcher specificity: `toBe` / `toEqual` / `toMatchObject` / `toStrictEqual` are "specific". `toBeTruthy` / `toBeDefined` / `not.toBeNull` are "weak". Reject if specific→weak substitution detected
- Detect `expect().not.toThrow()` added where `expect().toThrow(SpecificError)` existed before → reject
- Compute depth of object matching (e.g., `toMatchObject({ x: 1, y: 2 })` depth 1, vs `toEqual` deep) — reject shallow replacing deep

Implementation: `qa/diff-audit/ast-assertion-analyzer.ts`.

---

## Part 11 — Summary.md Template (Deterministic)

```markdown
# QA Run Summary — run-{run_id}

**Session:** {started_at} → {ended_at} ({duration})
**Triggered by:** {trigger}
**Previous run:** {prev_run_id} ({prev_status})

## Verdict

**Status:** {overall_status_emoji_and_text}

- {features_attempted_count} features attempted
- {features_green_count} features moved to green
- {features_blocked_count} features blocked
- {violations_count} violations detected
- {contract_tamper_count} contract tamper events

## Contract Integrity                            ← 13d addition

- Contract hashes verified: {contracts_verified_count}/{contracts_total_count} ✅/❌
- Lock manifest verified: {lock_manifest_verified} ✅/❌
- Providers abstraction intact: {providers_intact} ✅/❌
- Deprecated command stubs present (expected): {deprecated_stubs_present}
- {tamper_details_if_any}

## Baseline → Final

{deterministic_metrics_table}

## Features

{per_feature_blocks}

## Baseline Changes

{baseline_changes_table_with_reset_log_entries}

## Violations Detected

{violations_list_from_violations_jsonl_or_"None this run."}

## Anti-cheat Warnings

{warning_patterns_matched_across_run}

## Performance

- Full baseline Stryker: {baseline_duration}
- Per-iteration incremental Stryker: median {median}, max {max}
- Total fixer invocations: {fixer_invocations}
- Total fixer runtime: {fixer_runtime}

## Next Actions

{rule_based_action_list}
```

**All sections derived from controller state. No LLM in the pipeline.**

---

## Part 12 — Implementation Order

Given "build it complete, build it now" — this is not a staged rollout. All components ship in v1.

### Week 1 — Scaffold foundation + installer
- `playbook/qa-scaffold/` directory in playbook repo
- Service registry (12 manifests: 3 validated, 9 Claude-drafted)
- Provider registry (3 manifests, 1 enabled)
- Installer bash script + tsx detection logic
- `/playbook:install-qa-harness` command
- `/playbook:qa-doctor` command (drift checker)
- Auto-install flow: detect → merge env vars → inject snippets → install deps

### Week 2 — Enforcement layers
- Layer 1: `.claude/settings.json` templates (loop, contract-authoring, test-authoring, selector-wiring variants)
- Layer 2: `block-locked-paths.sh`
- Layer 3: Controller diff audit (regex + AST)
- Layer 4: `.husky/pre-commit`
- Anti-cheat pattern library (regex + AST)
- Lock manifest computation & verification
- Contract hash computation & verification

### Week 3 — Contract system
- Update `/playbook:contract-pack` for new path + schema + hash writing
- `/playbook:author-locked-tests`
- `/playbook:wire-selectors` with post-wiring diff check
- `/playbook:classify-modules` + `classify-check`
- index.yaml schema + category gate enforcement
- Version bump flow with source-denied for security_sensitive

### Week 4 — Controller loop
- State machine (5-state taxonomy)
- Feature loop (attempts, plateau detection, safety cap)
- Repair packet builder (F4 + codebase_context + hypothesis)
- Claude provider (I2 + I3 invocation)
- Crash recovery (R-2)
- Session lock (L1)

### Week 5 — Gates & parsers
- All 15 fast-repair gates
- All 15 release gates
- Vitest/Playwright/Stryker parsers (with incremental handling)
- Dependency-cruiser integration (depth 1)
- Stryker T4 targeting (scope ∩ diff ∪ reverse-deps)
- Test count sanity + contract test count gates

### Week 6 — Reporting & polish
- Summary.md template (deterministic)
- state-delta.json writer
- violations.jsonl writer
- `/playbook:qa-status`, `qa-report`, `qa-audit-violations`
- `qa-clean` retention logic
- `qa-baseline-reset` with audit log
- macOS notification hook
- `qa-unblock`

### Week 7 — Deprecation & testing
- Move existing anneal/harden/spec-runner/anneal-check to `commands/deprecated/`
- Stub replacements at original paths
- qa-doctor flags for deprecated presence
- End-to-end test against user's actual Next.js app:
  - Install into target repo
  - Author first 3 critical-category contracts (auth-login, payment-checkout, user-profile)
  - Author locked tests, wire selectors
  - Run first `qa baseline`
  - Run first `qa run` overnight
  - Review summary.md
- Fix bugs surfaced by real usage

### Week 8 — Hardening
- Verify all 12 service manifests work against real apps (activate drafts as validated)
- Verify all deprecated stubs redirect correctly
- Run `qa-audit-violations` to confirm anti-cheat captures real attempts
- Document final command reference + troubleshooting

**Total: 8 weeks solo.**

---

## Appendix A — Required npm dependencies

**Auto-installed in target app on `install-qa-harness`:**

```json
{
  "devDependencies": {
    "@playwright/test": "^1.49.0",
    "@clerk/testing": "^1.x",             // only if Clerk detected
    "@stryker-mutator/core": "^9.x",       // assumed present
    "@stryker-mutator/vitest-runner": "^9.x",
    "@axe-core/playwright": "^4.x",
    "@lhci/cli": "^0.14.x",
    "@babel/parser": "^7.x",
    "dependency-cruiser": "^16.x",
    "fast-xml-parser": "^4.x",
    "knip": "^5.x",
    "license-checker": "^25.x",
    "msw": "^2.x",
    "tsx": "^4.x",
    "commander": "^12.x",
    "execa": "^9.x",
    "zod": "^3.x",
    "husky": "^9.x",
    "lint-staged": "^15.x"
  }
}
```

## Appendix B — Tier floor lookup table

| Tier | Mutation floor | Gates beyond mutation | Categories that auto-assign |
|---|---|---|---|
| critical_75 | 75% | All fast-repair + all release | auth, payments, user_data |
| business_60 | 60% | All fast-repair + release (except heavy perf) | business_logic (when frozen contract) |
| ui_gates_only | N/A | Static + Vitest + Playwright + a11y + visual; no mutation floor | ui (when frozen contract) |

**Unclassified: HARD ERROR (6b.iii, no fallback).**

## Appendix C — What this blueprint does NOT cover

These are not included in v1 and require separate design if wanted later:

- Codex/Gemini enabled as primary fixer (manifests scaffolded, disabled)
- Parallel feature execution (C2/C3 — C1 serial only)
- Cloud execution (no webhooks, no GitHub Actions workers, no persistent service)
- Slack/Linear monitoring (explicitly deleted from plan)
- Cross-app shared state (each app has independent .quality/)
- Time-travel debugging of past runs (abandoned runs archived, not replayable)
- Custom reporters per team preference (summary.md format is fixed)

---

## Appendix D — Open items requiring YOUR input before coding

These are not architectural decisions; they're domain content only you can provide:

1. **Your 3-5 critical features** (auth-login, payment-checkout, etc.) — exact feature IDs and priority order for O-α authoring before first baseline
2. **Tier classifications** for your specific app's `src/` tree — globs for critical_75, business_60, ui_gates_only in `.quality/policies/tiers.yaml`
3. **External services list** your target app actually uses — for verification of auto-detection (should match: Clerk, Razorpay, Drizzle+Postgres, plus any others)
4. **Test user fixtures** — emails, passwords, roles for Clerk seeded users in `.env.test`
5. **Razorpay webhook samples** — saved HTTP payloads for MSW replay in webhook E2E tests
6. **Acceptance of 8-week timeline** — realistic for solo, or compress via Claude-pair-programming during build?
7. **Commit granularity** — one commit per gate implementation, or per command, or per week?

---

**End of blueprint. Grill this document.**
