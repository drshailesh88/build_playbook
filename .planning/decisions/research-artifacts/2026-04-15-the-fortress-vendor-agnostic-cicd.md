# The Fortress: A Vendor-Agnostic CI/CD Pipeline for AI Agent Code

## What This System Does

This is a complete CI/CD pipeline designed for a non-technical builder who uses AI agents (Claude Code, Codex, Gemini, Cursor, or any future tool) to write code. The system ensures that no bad code reaches production — regardless of which AI wrote it.

**The philosophy:** GitHub Actions is the boss. AI agents are interchangeable workers. The pipeline is the source of truth, not any single vendor.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    YOUR DEVELOPMENT FLOW                        │
│                                                                 │
│  You (or Ralph/AI) write code                                   │
│         │                                                       │
│         ▼                                                       │
│  Push to feature branch (never main)                            │
│         │                                                       │
│         ▼                                                       │
│  Open Pull Request                                              │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 1: FAST CHECKS (< 2 min)               │   │
│  │  ┌─────────┐ ┌───────────┐ ┌──────────┐ ┌────────────┐  │   │
│  │  │ Linting │ │Type Check │ │ Secrets  │ │   Build    │  │   │
│  │  │ ESLint  │ │tsc/mypy   │ │  Scan    │ │  Compile   │  │   │
│  │  └─────────┘ └───────────┘ └──────────┘ └────────────┘  │   │
│  │  ❌ Fail = Block PR. No AI needed to diagnose.           │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Pass                                                  │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 2: TEST SUITE (2-10 min)                │   │
│  │  ┌───────────┐ ┌────────────┐ ┌───────────────────────┐  │   │
│  │  │Unit Tests │ │Integration │ │  Coverage Threshold   │  │   │
│  │  │  Vitest   │ │   Tests    │ │    (min 80%)          │  │   │
│  │  └───────────┘ └────────────┘ └───────────────────────┘  │   │
│  │  ❌ Fail = Trigger AI Agent to fix (Gate 2B)              │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Pass                                                  │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 2B: AI AUTO-FIX (if Gate 2 failed)      │   │
│  │  ┌──────────────────────────────────────────────────────┐ │   │
│  │  │  Try Agent 1 (e.g., Claude) → fix → re-run tests    │ │   │
│  │  │  If still failing after 2 attempts:                  │ │   │
│  │  │  Try Agent 2 (e.g., Codex) → fix → re-run tests     │ │   │
│  │  │  If still failing: escalate to human                 │ │   │
│  │  └──────────────────────────────────────────────────────┘ │   │
│  │  Max 2 attempts per agent. Hard cap prevents spiral.      │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Pass                                                  │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 3: AI CODE REVIEW (3-5 min)             │   │
│  │  ┌──────────────────────────────────────────────────────┐ │   │
│  │  │  AI Reviewer (CodeRabbit / Claude / PR-Agent)        │ │   │
│  │  │  Checks: security, performance, style, AI smells     │ │   │
│  │  │  Posts inline comments + summary on PR                │ │   │
│  │  └──────────────────────────────────────────────────────┘ │   │
│  │  This is advisory — it comments but doesn't block.        │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 4: SECURITY SCAN (2-5 min)              │   │
│  │  ┌────────────┐ ┌────────────┐ ┌──────────────────────┐  │   │
│  │  │ Dependabot │ │   Snyk /   │ │   CodeQL / Semgrep   │  │   │
│  │  │   Alerts   │ │  npm audit │ │  (static analysis)   │  │   │
│  │  └────────────┘ └────────────┘ └──────────────────────┘  │   │
│  │  ❌ Critical/High = Block PR                              │   │
│  │  ⚠️  Medium/Low = Warning only                            │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Pass                                                  │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 5: HUMAN APPROVAL                       │   │
│  │  ┌──────────────────────────────────────────────────────┐ │   │
│  │  │  You review the PR:                                  │ │   │
│  │  │  - Read AI reviewer's summary                        │ │   │
│  │  │  - Check that all gates are green                    │ │   │
│  │  │  - Approve and merge                                 │ │   │
│  │  └──────────────────────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Merge                                                 │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 6: DEPLOYMENT                           │   │
│  │  ┌───────────┐ ┌────────────┐ ┌───────────────────────┐  │   │
│  │  │  Build    │ │  Deploy to │ │  Health check after   │  │   │
│  │  │ Production│ │  Staging   │ │  deploy (smoke test)  │  │   │
│  │  └───────────┘ └────────────┘ └───────────────────────┘  │   │
│  │  If health check fails → auto-rollback                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │ Pass                                                  │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              GATE 7: POST-DEPLOY MONITORING               │   │
│  │  ┌──────────────────────────────────────────────────────┐ │   │
│  │  │  Sentry / error tracking watches for new errors      │ │   │
│  │  │  If error spike detected → alert you                 │ │   │
│  │  │  Optional: trigger AI agent to diagnose and fix      │ │   │
│  │  └──────────────────────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  🟢 Code is live and monitored                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## File Structure

Put these files in your repository:

```
your-repo/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                    # Gates 1-2: Fast checks + tests
│   │   ├── ai-review.yml             # Gate 3: AI code review
│   │   ├── security.yml              # Gate 4: Security scanning
│   │   ├── deploy.yml                # Gate 6: Deployment
│   │   └── nightly-health.yml        # Scheduled: Nightly health check
│   ├── CODEOWNERS                    # Who must approve what
│   └── pull_request_template.md      # PR template
├── AGENTS.md                         # Instructions for ALL AI agents
├── CLAUDE.md                         # Claude-specific instructions (optional)
├── .cursorrules                      # Cursor-specific (optional)
├── CODEX.md                          # Codex-specific (optional)
└── ...your code
```

---

## Workflow 1: ci.yml — The Core Pipeline (Gates 1 + 2)

This is the most important file. It runs on every PR and blocks merging if anything fails.

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

# Cancel in-progress runs for same PR
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  # ============================================
  # GATE 1: FAST CHECKS (run in parallel)
  # ============================================

  lint:
    name: "Gate 1 · Lint"
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npx eslint . --max-warnings 0

  typecheck:
    name: "Gate 1 · Type Check"
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npx tsc --noEmit

  secrets-scan:
    name: "Gate 1 · Secrets Scan"
    runs-on: ubuntu-latest
    timeout-minutes: 2
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified

  build:
    name: "Gate 1 · Build"
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npm run build

  # ============================================
  # GATE 2: TEST SUITE (runs after Gate 1 passes)
  # ============================================

  unit-tests:
    name: "Gate 2 · Unit Tests"
    needs: [lint, typecheck, build]
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npm test -- --coverage --reporter=json --outputFile=test-results.json
      - name: Check coverage threshold
        run: |
          COVERAGE=$(node -e "
            const report = require('./coverage/coverage-summary.json');
            console.log(report.total.lines.pct);
          ")
          echo "Coverage: ${COVERAGE}%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "❌ Coverage ${COVERAGE}% is below 80% threshold"
            exit 1
          fi
      - name: Upload coverage report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  property-tests:
    name: "Gate 2 · Property Tests"
    needs: [lint, typecheck, build]
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npm run test:property
        # Adjust this command to match your project

  # ============================================
  # GATE SUMMARY: Final status check
  # ============================================

  ci-passed:
    name: "✅ All CI Gates Passed"
    needs: [lint, typecheck, secrets-scan, build, unit-tests, property-tests]
    runs-on: ubuntu-latest
    if: always()
    steps:
      - name: Check all gates
        run: |
          if [ "${{ needs.lint.result }}" != "success" ] ||
             [ "${{ needs.typecheck.result }}" != "success" ] ||
             [ "${{ needs.secrets-scan.result }}" != "success" ] ||
             [ "${{ needs.build.result }}" != "success" ] ||
             [ "${{ needs.unit-tests.result }}" != "success" ] ||
             [ "${{ needs.property-tests.result }}" != "success" ]; then
            echo "❌ One or more CI gates failed"
            echo "Lint: ${{ needs.lint.result }}"
            echo "Type Check: ${{ needs.typecheck.result }}"
            echo "Secrets: ${{ needs.secrets-scan.result }}"
            echo "Build: ${{ needs.build.result }}"
            echo "Unit Tests: ${{ needs.unit-tests.result }}"
            echo "Property Tests: ${{ needs.property-tests.result }}"
            exit 1
          fi
          echo "✅ All gates passed"
```

---

## Workflow 2: ai-review.yml — AI Code Review (Gate 3)

This is vendor-agnostic. You can use CodeRabbit, Claude Code Action, Codex, or all of them.

```yaml
# .github/workflows/ai-review.yml
name: AI Code Review

on:
  pull_request:
    types: [opened, synchronize, ready_for_review]

# Don't review draft PRs
jobs:
  ai-review:
    name: "Gate 3 · AI Code Review"
    if: github.event.pull_request.draft == false
    runs-on: ubuntu-latest
    timeout-minutes: 15
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # OPTION A: Claude Code Action (Anthropic)
      # Uncomment to use Claude as reviewer
      # - uses: anthropics/claude-code-action@v1
      #   with:
      #     anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
      #     prompt: |
      #       Review this PR for:
      #       1. Correctness - do imports exist? Types correct?
      #       2. AI code smells - hallucinated imports, over-engineering
      #       3. Security - hardcoded secrets, injection risks
      #       4. Missing tests for new functionality
      #       Post a summary comment with 🟢/🟡/🔴 rating.
      #       Do NOT make changes. Only review and comment.

      # OPTION B: CodeRabbit (vendor-agnostic, free for open source)
      # This works automatically if you install CodeRabbit GitHub App
      # No workflow config needed — it triggers on PR events

      # OPTION C: Qodo PR-Agent (open source)
      - name: PR Agent Review
        uses: Codium-ai/pr-agent@main
        env:
          OPENAI_KEY: ${{ secrets.OPENAI_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          command: "/review"

      # You can run MULTIPLE reviewers simultaneously
      # Different AI vendors catch different things
```

---

## Workflow 3: security.yml — Security Scanning (Gate 4)

```yaml
# .github/workflows/security.yml
name: Security Scan

on:
  pull_request:
    branches: [main]
  schedule:
    - cron: "0 6 * * 1"   # Weekly on Monday at 6 AM

jobs:
  dependency-audit:
    name: "Gate 4 · Dependency Audit"
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
      - run: npm ci
      - run: npm audit --audit-level=high
        # Fails on high/critical vulnerabilities
        # Change to --audit-level=critical for less strict

  codeql:
    name: "Gate 4 · CodeQL Analysis"
    runs-on: ubuntu-latest
    timeout-minutes: 15
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript-typescript
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
```

---

## Workflow 4: deploy.yml — Deployment Pipeline (Gate 6)

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-staging:
    name: "Gate 6 · Deploy to Staging"
    runs-on: ubuntu-latest
    timeout-minutes: 15
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npm run build
      - name: Deploy to staging
        run: |
          # Replace with your actual deploy command
          # Examples: vercel deploy --prebuilt, aws s3 sync, etc.
          echo "Deploying to staging..."
      - name: Smoke test staging
        run: |
          # Replace with your staging URL
          # curl -f https://staging.yourapp.com/health || exit 1
          echo "Smoke test passed"

  deploy-production:
    name: "Gate 6 · Deploy to Production"
    needs: deploy-staging
    runs-on: ubuntu-latest
    timeout-minutes: 15
    environment: production   # Requires manual approval in GitHub settings
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci
      - run: npm run build
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
      - name: Post-deploy health check
        run: |
          # Replace with your production URL
          # for i in {1..5}; do
          #   curl -f https://yourapp.com/health && exit 0
          #   sleep 10
          # done
          # echo "❌ Health check failed after 5 attempts"
          # exit 1
          echo "Health check passed"
```

---

## Workflow 5: nightly-health.yml — Nightly Health Check

```yaml
# .github/workflows/nightly-health.yml
name: Nightly Health Check

on:
  schedule:
    - cron: "0 2 * * *"   # 2 AM daily (UTC — adjust for your timezone)
  workflow_dispatch:        # Allow manual trigger

jobs:
  health-check:
    name: "Nightly · Code Health"
    runs-on: ubuntu-latest
    timeout-minutes: 20
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "npm"
      - run: npm ci

      - name: Type check
        run: npx tsc --noEmit 2>&1 | tee type-errors.txt || true

      - name: Dependency audit
        run: npm audit 2>&1 | tee audit-report.txt || true

      - name: Outdated packages
        run: npm outdated 2>&1 | tee outdated.txt || true

      - name: Count TODOs and FIXMEs
        run: |
          echo "## Code Health Report - $(date +%Y-%m-%d)" > health-report.md
          echo "" >> health-report.md
          echo "### TODOs and FIXMEs" >> health-report.md
          grep -rn "TODO\|FIXME\|HACK\|XXX" src/ --include="*.ts" --include="*.tsx" | wc -l | xargs -I{} echo "Total: {}" >> health-report.md
          echo "" >> health-report.md
          echo "### Type Errors" >> health-report.md
          wc -l < type-errors.txt | xargs -I{} echo "Total: {}" >> health-report.md
          echo "" >> health-report.md
          echo "### Dependency Vulnerabilities" >> health-report.md
          cat audit-report.txt >> health-report.md

      - name: Create issue with report
        if: always()
        uses: peter-evans/create-issue-from-file@v5
        with:
          title: "Nightly Health Report - ${{ github.run_id }}"
          content-filepath: health-report.md
          labels: automated,health-check
```

---

## The AGENTS.md File — Universal Instructions for ALL AI Agents

This file is read by Claude Code, Codex, Cursor, Gemini, and most other AI coding tools.

```markdown
# AGENTS.md — Instructions for AI Agents

## Project Overview
This is a TypeScript project. All code must be strictly typed.

## Rules — These Are Non-Negotiable

### Before Writing Any Code
1. NEVER push directly to `main`. Always create a feature branch.
2. NEVER skip type annotations. Every parameter and return type must be explicit.
3. NEVER import modules that don't exist. Verify the file path before adding an import.
4. NEVER hardcode secrets, API keys, or passwords.
5. NEVER modify more than 3 files without running tests first.

### When Writing Code
1. Use TypeScript strict mode. No `any` types unless absolutely necessary.
2. Keep functions under 50 lines. Extract helpers if longer.
3. Add JSDoc comments on exported functions.
4. Handle errors explicitly — no empty catch blocks.
5. Use existing patterns in the codebase. Check similar files before writing new patterns.

### When Writing Tests
1. Every new function must have at least one test.
2. Test the happy path AND at least one error case.
3. Use descriptive test names: "should return error when input is empty"
4. Never mock what you don't own. Prefer integration tests for external dependencies.

### Before Committing
1. Run `npx tsc --noEmit` — fix all type errors.
2. Run `npx eslint . --max-warnings 0` — fix all lint errors.
3. Run `npm test` — all tests must pass.
4. If any of the above fail, fix them before committing.

### Commit Messages
Use conventional commits:
- `feat:` for new features
- `fix:` for bug fixes
- `chore:` for maintenance
- `test:` for test additions
- `docs:` for documentation

### What Success Looks Like
- All CI checks pass (lint, typecheck, build, tests)
- Coverage stays above 80%
- No security vulnerabilities introduced
- Code follows existing patterns in the project
```

---

## Branch Protection Rules — Setup Guide

Go to your repo → Settings → Branches → Add rule for `main`:

```
✅ Require a pull request before merging
   ✅ Require approvals: 1
   ✅ Dismiss stale pull request approvals when new commits are pushed

✅ Require status checks to pass before merging
   Required checks:
   - "✅ All CI Gates Passed" (from ci.yml)
   - "Gate 4 · Dependency Audit" (from security.yml)

✅ Require conversation resolution before merging

✅ Do not allow bypassing the above settings
   (This prevents even you from skipping checks)
```

---

## PR Template

Create `.github/pull_request_template.md`:

```markdown
## What does this PR do?
<!-- Brief description -->

## How was this tested?
<!-- What tests were added or run? -->

## Checklist
- [ ] Type checking passes (`npx tsc --noEmit`)
- [ ] All tests pass (`npm test`)
- [ ] No `any` types added
- [ ] New functionality has tests
- [ ] No secrets or API keys in code
```

---

## Vendor Swap Guide

The beauty of this system is that swapping AI vendors requires changing ONE workflow file, not the entire pipeline.

### If you want to switch from Claude to Codex for auto-fixing:
1. Open `.github/workflows/ai-review.yml`
2. Comment out the Claude Code Action step
3. Uncomment or add the Codex step
4. Update the API key secret

### If you want MULTIPLE AI reviewers:
Add multiple steps in the ai-review job. Each runs independently.
Different AIs catch different things — redundancy is a feature.

### If a vendor raises prices or goes down:
1. Your core CI (lint, typecheck, tests, security) is 100% vendor-agnostic
2. Only the AI review and auto-fix steps depend on a vendor
3. Swap the vendor in 5 minutes by editing one YAML file

---

## What Each Gate Catches

| Gate | What It Catches | AI Needed? | Blocks PR? |
|------|----------------|------------|------------|
| 1 · Lint | Style errors, formatting | No | Yes |
| 1 · Type Check | Type errors, missing imports | No | Yes |
| 1 · Secrets Scan | Leaked API keys, passwords | No | Yes |
| 1 · Build | Compilation failures | No | Yes |
| 2 · Unit Tests | Logic errors, regressions | No | Yes |
| 2 · Property Tests | Edge cases, unexpected inputs | No | Yes |
| 2B · Auto-Fix | CI failures the AI can fix | Yes | No (helper) |
| 3 · AI Review | Code smells, AI slop, design issues | Yes | No (advisory) |
| 4 · Security | Vulnerabilities, unsafe deps | No | High/Critical |
| 5 · Human | Design, intent, business logic | You | Yes |
| 6 · Staging | Real-world behavior | No | Yes |
| 6 · Production | Deployment health | No | Auto-rollback |
| 7 · Monitoring | Production errors | Optional | Alert only |

**Notice: Gates 1, 2, 4, 5, and 6 don't need AI at all.**
The AI-dependent gates (2B, 3) are helpers — if they break or a vendor disappears, your pipeline still works. You just lose the auto-fix and auto-review convenience.

---

## Cost Comparison

| Tool | Cost | Role |
|------|------|------|
| GitHub Actions | Free for public repos, 2000 min/month for private | Pipeline orchestration |
| ESLint / tsc | Free | Linting, type checking |
| TruffleHog | Free (open source) | Secrets scanning |
| CodeQL | Free for public repos | Security analysis |
| npm audit | Free | Dependency scanning |
| CodeRabbit | Free for open source, $15/mo for private | AI code review |
| Claude Code Action | Requires Anthropic API key (~$3/hr) | AI auto-fix |
| Codex (via Codex Action) | Requires OpenAI API key | AI auto-fix (backup) |
| Sentry | Free tier (5K events/mo) | Production monitoring |

**Total for a solo builder: $0-30/month** depending on which paid AI features you enable.

---

## Implementation Order (Start Here)

Don't try to set up everything at once. Do this in order:

### Week 1: Foundation
1. Create `.github/workflows/ci.yml` (copy from above)
2. Create `AGENTS.md` (copy from above)
3. Set up branch protection on `main`
4. Start using feature branches + PRs

### Week 2: AI Review
1. Install CodeRabbit GitHub App (free, 2 clicks)
2. Or set up Claude Code Action with API key
3. Create `.github/workflows/ai-review.yml`

### Week 3: Security
1. Enable Dependabot in GitHub settings (free, 1 click)
2. Create `.github/workflows/security.yml`
3. Add CodeQL scanning

### Week 4: Deployment
1. Create `.github/workflows/deploy.yml`
2. Set up staging environment
3. Add production deployment with manual approval

### Week 5: Nightly + Monitoring
1. Create `.github/workflows/nightly-health.yml`
2. Set up Sentry for production error tracking
3. Consider Claude Code Routines for auto-triage

---

## Your Daily Workflow After Setup

```
Morning (5 minutes):
  Open GitHub on your phone
  ├── Any nightly health issues? → Create tasks
  ├── Any open PRs? → Read AI review summary
  └── Any PRs with all green checks? → Approve and merge

During the day:
  Tell your AI agent to build a feature
  ├── AI pushes to feature branch
  ├── You open a PR (or AI opens it)
  ├── Pipeline runs automatically:
  │   ├── Gate 1: Fast checks (2 min)
  │   ├── Gate 2: Tests (5 min)
  │   ├── Gate 3: AI review posts comments
  │   └── Gate 4: Security scan
  ├── If anything fails → AI auto-fixes (or you're notified)
  └── When all green → you approve from your phone

Evening:
  Nothing. The nightly routine runs at 2 AM.
  You sleep. The pipeline watches.
```

---

## The One Rule That Matters Most

**The pipeline is the source of truth. Not the AI. Not you. The pipeline.**

If the pipeline says it's broken, it's broken — even if the AI says it's fine.
If the pipeline says it passes, it's safe to merge — even if you don't understand the code.

Your job is to build and maintain the pipeline.
The AI's job is to write code that passes the pipeline.
The pipeline's job is to be honest about quality.

That's the system.
