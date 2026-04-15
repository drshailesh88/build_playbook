# AI-Era Pre-Commit Hooks & CI Hardening — Landscape Research

**Date:** 2026-04-15
**Purpose:** Ground the CI/hooks strategy in what engineers are actually shipping, not invented patterns.
**Scope:** Companion to `../2026-04-15-ci-cd-devops-literacy.md`. Ralph + Stryker already covers the build loop; this document maps what CI + hooks add *on top* of that.

---

## 1. Pre-Commit Hook Stacks (2025–2026)

Dominant tools: **Husky + lint-staged** (JS/TS default), **Lefthook** (Go-based, parallel, faster), **pre-commit framework** (polyglot). `simple-git-hooks` is a lightweight niche.

Typical hook contents for a TS/JS project:
- Prettier (format)
- ESLint (lint)
- `tsc --noEmit` (type-check) — *now a hard gate, specifically because AI generates plausible-but-broken TS*
- Unit tests on changed files (`jest --onlyChanged` / `vitest related`)
- Gitleaks or TruffleHog (secret scanning)
- commitlint (conventional commits)

AI-specific additions appearing in 2025 blog posts:
- Blocking commits with implicit-`any`, unused imports, hallucinated module paths
- "Whole-repo validation" hooks that confirm every `import` resolves to a real file
- Session-end hooks (Claude Code's stop hook) that run lint+typecheck before the agent is allowed to end its turn

References:
- https://pre-commit.com/
- https://typicode.github.io/husky/
- https://github.com/evilmartians/lefthook
- https://gitleaks.io/
- https://docs.trufflesecurity.com/pre-commit-hooks
- Brian Douglas — "Pre-commit hooks are back thanks to AI" — https://briandouglas.me/posts/2025/08/27/pre-commit-hooks-are-back-thanks-to-ai/
- "Git hooks are your best defense against AI-generated mess" — https://dev.to/jonesrussell/git-hooks-are-your-best-defense-against-ai-generated-mess-5h1a

Gotchas: Husky config is scattered (`.husky/*` + `.lintstagedrc`). TruffleHog verification adds 5–10s. Pre-commit + Node envs occasionally fight.

---

## 2. CI as Hardening (Beyond Pass/Fail)

Modern CI layers five things beyond "run the tests":

**(a) Mutation testing.** Stryker.js with `--incremental` (mutates only changed code, ~2–3 min on small PRs vs 20 min full run). Dashboard upload + HTML report. Merge blocked below killed-mutant threshold.
- https://github.com/stryker-mutator/stryker-js

**(b) Coverage gates.** Codecov / Coveralls comparing **diff-coverage** on new code, not absolute %. New untested code = blocker.

**(c) Static analysis with PR comments.**
- SonarCloud — enterprise standard, ~10 min per scan
- CodeQL — GitHub-native semantic analysis, slow on large repos
- Semgrep — fast (~10s), rule-based, rising star for per-PR feedback
- Qlty, Code Climate — wrappers over multiple tools

**(d) Supply-chain.**
- Dependabot (GitHub-native) — opens update PRs
- Renovate — more configurable alternative
- Snyk — reachability analysis (is the vulnerable path actually called? reduces noise 60–80%)
- OSSF Scorecard — health score for OSS projects
- `step-security/harden-runner` — runtime monitoring of runner network/FS/process activity; used by Microsoft, Google, CISA

**(e) Perf / a11y / SEO / visual budgets.**
- `treosh/lighthouse-ci-action` + `budget.json` thresholds
- Percy / Chromatic for visual regression (Playwright's own `toHaveScreenshot()` works but suffers OS/browser drift — macOS baseline ≠ Linux CI)
- Percy launched an AI Visual Review Agent late 2025 that filters rendering noise

Canonical workflow files to read:
- https://github.com/vercel/next.js/tree/main/.github/workflows
- https://github.com/microsoft/playwright/tree/main/.github/workflows
- https://github.com/calcom/cal.com/blob/main/playwright.config.ts
- https://github.com/treosh/lighthouse-ci-action
- https://github.com/step-security/harden-runner

Gotchas: SonarCloud slow + needs org setup. CodeQL DB build is 30+ min on big repos. Stryker on monorepos without caching will timeout. Percy snapshots are billed by quantity.

---

## 3. Playwright in CI

Mature patterns:
- **Matrix × sharding combo.** `strategy.matrix` for browsers × `--shard=X/Y` within each job. 3 browsers × 4 shards = 12 parallel workers, full coverage in ~5 min.
- **Preview-deployment testing.** Trigger on Vercel/Netlify `deployment_status`, wait for URL (`wait-for-vercel-preview`, `mmazzarolo/wait-for-netlify-action`), run Playwright against preview not localhost.
- **Artifacts.** `trace: 'on-first-retry'` + HTML report as artifact (sometimes published to GitHub Pages).
- **Not in Husky.** Consensus: e2e is too slow for commit-time. CI only.
- **AI + Playwright (emerging).** Auto-healing selectors; experiments feeding traces to Claude Code to fix selector failures. Not yet mainstream.

References:
- https://playwright.dev/docs/ci
- https://github.com/microsoft/playwright/tree/main/.github/workflows
- https://cushionapp.com/journal/how-to-use-playwright-with-github-actions-for-e2e-testing-of-vercel-preview

Gotchas: Screenshot drift across OS → use Percy/Chromatic for visual, not `toHaveScreenshot`. Tune timeouts (CI 30s vs local 120s). Parallel workers may hit DB connection caps — drop to 1 worker for Supabase-style backends.

---

## 4. AI Agents on GitHub — What's Actually Installed

**Claude Code Action** (https://github.com/anthropics/claude-code-action, v1.0 Aug 2025) — the only official Anthropic integration. Triggers: `@claude` mention, issue assignment, `workflow_run` (for CI auto-fix). Multi-auth (Anthropic API / Bedrock / Vertex / Foundry). Tool sandboxing via `--allowedTools`. Example: `examples/ci-failure-auto-fix.yml` listens on `workflow_run conclusion: failure`, extracts logs, asks Claude to fix, pushes to PR branch.

**GitHub Copilot Coding Agent** (GA Sept 2025) — successor to the sunset Copilot Workspace. Native, no external action needed. Error auto-repair, self-healing iteration.

**AI PR reviewers (SaaS):**
- **CodeRabbit** — 2M+ repos, seconds-to-first-comment, "senior engineer vibe," no reachability analysis
- **Greptile** — indexes whole repo, 82% bug-catch in benchmarks, detects duplicates/module mismatches
- **Qodo Merge** (formerly PR-Agent) — multi-agent (bugs, quality, security, coverage), F1 ~60%, on-prem/VPC available
- **Ellipsis** — lightweight, key insights only
- **Cursor Bugbot** — local-only, no GitHub integration
- **OpenAI Codex CLI on GitHub** — no production evidence; Codex largely deprecated in favor of Copilot

References:
- https://github.com/anthropics/claude-code-action
- https://github.com/anthropics/claude-code-action/tree/main/examples
- https://code.claude.com/docs/en/github-actions
- https://docs.github.com/en/copilot/concepts/agents/
- https://www.devtoolsacademy.com/blog/state-of-ai-code-review-tools-2025/

Gotchas: `contents:write` + `id-token:write` in the workflow = trust surface. Restrict to same-repo PRs (`pull_requests[0]`) or trusted authors. SaaS reviewers billed per-PR — teams gate them to main or non-bot authors.

---

## 5. The Composite Pattern — Mature AI-Era Repos

No public repo does all five layers. Closest approximations:

- **vercel/next.js** — distributed test sharding via Vercel KV, Playwright e2e, Codecov. Missing: mutation gate, AI agent.
- **microsoft/playwright** — exemplary matrix + artifacts. Missing: mutation, AI agent, Harden-Runner.
- **calcom/cal.com** — Playwright with separate install job, Vitest, `AGENTS.md` (suggests agent usage). Missing: coverage gate, mutation, visual regression.
- **TanStack** — Nx Cloud distributed testing, coverage → Codecov, type-check across 5 TS versions. Missing: visual regression, mutation, AI agent.

Emerging composite pattern (most teams pick 2–3 of these):
1. Husky/pre-commit → lint + typecheck (seconds)
2. CI → unit tests + diff-coverage
3. CI → Semgrep / SonarCloud with PR comments
4. CI → Playwright against preview deployment
5. CI → Stryker incremental mutation
6. PR → Claude Code Action / CodeRabbit listening for failures
7. Supply-chain → Dependabot + Snyk + Harden-Runner

Engineering-blog references:
- https://ghuntley.com/ralph/ — Ralph Wiggum Loop origin
- https://linearb.io/blog/ralph-loop-agentic-engineering-geoffrey-huntley

---

## What's Missing / Open Questions

1. Mutation testing in CI is still rare in top-100 OSS. Adoption vs ROI unclear.
2. No major public repo yet shows claude-code-action listening on `workflow_run` to auto-fix CI. Pattern exists in examples, not in production.
3. No Anthropic / OpenAI / Stripe / Shopify engineering blog publicly documents their own CI + AI loop.
4. "Whole-repo validation for hallucinated imports" is ad-hoc shell scripts, not yet a pre-commit plugin.
5. Visual regression × AI agents — zero public CI examples integrating Percy/Chromatic AI review with Claude Code.
6. Harden-Runner adoption growing but niche — no public list of OSS projects running it.

---

## Candidate Repos for Deep Inspection

If we go to the "clone and read their workflow files" step, these are the highest signal:

1. https://github.com/anthropics/claude-code-action — `examples/` directory is the canonical "how to wire Claude into GitHub" reference
2. https://github.com/stryker-mutator/stryker-js — mutation testing + its own CI workflow
3. https://github.com/calcom/cal.com — real product, Playwright + AGENTS.md hints
4. https://github.com/microsoft/playwright — the reference CI matrix
5. https://github.com/vercel/next.js — distributed test orchestration
6. https://github.com/step-security/harden-runner — supply-chain hardening patterns
7. https://github.com/treosh/lighthouse-ci-action — perf budget wiring
8. https://github.com/evilmartians/lefthook — fast hook config patterns

Not worth cloning (read docs instead — too big or SaaS-only):
- microsoft/playwright full repo (read only `.github/workflows/`)
- vercel/next.js full repo (same)
- SonarCloud, Snyk, CodeRabbit, Greptile, Qodo — SaaS, docs only
- Sentry (too large)
