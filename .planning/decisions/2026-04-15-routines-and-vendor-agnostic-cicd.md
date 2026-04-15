# Planning Session: Claude Code Routines + Vendor-Agnostic CI/CD ("The Fortress")
**Date:** 2026-04-15
**Source:** Claude.ai conversation (continuation of CI/CD literacy session)
**Status:** captured — research phase, NOT a build order

## Context
Continuation of `2026-04-15-ci-cd-devops-literacy.md`. Shailesh discovered Anthropic's **Claude Code Routines** (research preview — Pro/Max/Team/Enterprise, runs on Anthropic cloud infra, triggered by schedule / API / GitHub events) and asked whether it's relevant. Then immediately pushed further: "Max sub is ok. But how about going vendor agnostic?" — which led Claude.ai to produce a full architecture document called **The Fortress** and a companion **Routines setup guide**. Both are attached as artifacts. This session is still research + framing, not a decision to build.

## Key Decisions Made

1. **Routines are relevant but not the architecture** — Routines solve the "AI on GitHub without a terminal" problem cleanly (GitHub-event trigger → autonomous Claude session → PR). They are the easiest on-ramp today. But they are a *vendor feature*, so they cannot sit at the center of the pipeline.

2. **GitHub Actions is the orchestration layer, not any single AI vendor** — The durable architecture puts GitHub Actions as the boss. AI agents (Claude Code Action, Codex, Cursor, Gemini, future tools) are interchangeable workers called from the pipeline. If a vendor raises prices, rate-limits, or disappears, the pipeline still works; only the auto-fix/auto-review convenience degrades.

3. **Five of seven gates in "The Fortress" are AI-free on purpose** — Lint, typecheck, tests, security scan, deploy, post-deploy monitoring don't need AI. AI is used only at Gate 2B (auto-fix on test failure) and Gate 3 (advisory code review). This is the vendor-agnostic property.

4. **Branch protection on `main` is prerequisite #1** — No routine, agent, or pipeline is useful until direct pushes to `main` are blocked. Require PR + passing checks + conversation resolution.

5. **Start with Routines for convenience, but write all gates as GitHub Actions YAML** — Routines can be the UX on top, but any gate logic that matters lives in `.github/workflows/*.yml`. That way migrating to Codex Triggers, Copilot Coding Agent, or self-hosted orchestrators later is a swap of the agent-call step, not a rewrite.

6. **Cap AI auto-fix attempts hard** — "The Fortress" proposes max 2 attempts by Agent 1, then max 2 by Agent 2, then escalate to human. Prevents infinite fix spirals that burn quota and obscure the real bug.

7. **Universal agent-instruction file** — Standardize on a single source of truth (`AGENTS.md`, symlinked or copied to `CLAUDE.md`, `.cursorrules`, etc.) so vendor-specific agents read the same rules. Don't maintain three divergent instruction files.

## Open Questions

- [ ] Routines daily run caps (Pro 5 / Max 15 / Team 25) — how many PRs/day does this realistically cover once you split across CI-fix + reviewer + nightly health routines? Probably tight on Pro.
- [ ] Is a nightly routine worth it before a baseline CI even exists? Probably not — it's noise until the baseline is clean.
- [ ] Are the third-party orchestrators mentioned (**MCO** / Multi-CLI Orchestrator, **Composio Agent Orchestrator**, **AgentFlow**) real, maintained, and adopted — or AI-hallucinated? **I have not verified these yet.** Needs a grounded search before relying on any of them.
- [ ] The "Fortress" YAML files in the artifact — do they actually work end-to-end, or are they plausible-looking templates? Must be read line-by-line before any `.github/workflows/` commit.
- [ ] Gate 3 (AI review) says "advisory, doesn't block" — is that the right call for a non-technical solo builder? Arguably the advisory review *should* block for him, since he can't catch what it catches.
- [ ] Coverage threshold in the artifact is 80% — arbitrary. Calibrate to actual project only after a baseline Stryker run.
- [ ] Where does Ralph + Stryker actually sit in the Fortress diagram? They belong *before* Gate 1 (they are build-time, not PR-time), but the artifact doesn't place them explicitly.

## Constraints & Requirements

- Must stay operable from mobile (established in the prior session).
- Must not lock the builder into any single vendor's pricing or uptime.
- Every gate must produce human-readable output or feed an AI agent — no raw-log-reading for the human.
- Routines, if used, must be paused-able without breaking the pipeline (they are convenience, not load-bearing).
- All gate logic lives in checked-in files (`.github/workflows/`, `AGENTS.md`, branch-protection settings), not in vendor consoles.

## Next Steps

1. **Verify the orchestrators claim.** Grounded search on MCO, Composio Agent Orchestrator, AgentFlow — real repos, stars, last commit, maintainers, any production users. If they're vapourware, cut them from the plan.
2. **Read the Fortress YAML end-to-end** before copying any of it into the repo. Treat it as a draft to critique, not a spec to execute.
3. **Clone the shortlist** from the prior research doc (`anthropics/claude-code-action`, `stryker-mutator/stryker-js`, `calcom/cal.com`, `step-security/harden-runner`, `evilmartians/lefthook`, `treosh/lighthouse-ci-action`) and compare their real workflow YAMLs against the Fortress draft.
4. **Decide Routines scope** only after #1–#3. Likely answer: one routine (CI-failure auto-fix on PR), not three — keep the daily-run budget headroom.
5. **Set branch protection on `main` today** — independent of everything above; it costs nothing and unblocks every later step.
6. Place Ralph + Stryker explicitly in the diagram: pre-Gate-1, as the *build-side* loop that produces the PR, not as a CI gate.

## Raw Notes

### On Claude Code Routines (from the Claude.ai dump)
- Research preview. Pro/Max/Team/Enterprise plans. Runs on Anthropic-managed cloud — works when laptop is closed.
- A routine = saved prompt + repo(s) + connectors, with one or more triggers.
- Three trigger types:
  - **Scheduled** (min interval 1 hour, cron via `/schedule update`)
  - **API** (per-routine `/fire` endpoint with bearer token; `anthropic-beta: experimental-cc-routine-2026-04-01`)
  - **GitHub event** (requires Claude GitHub App install; events: pull_request, release; filters on author/title/body/branches/labels/draft/merged/fork)
- Per-routine + per-account hourly caps during preview. Events beyond the cap are dropped.
- Runs fully autonomous — no permission picker, no approval prompts mid-run. Tool scope = repo branch-push setting + environment network/env-vars + connectors.
- Default push restriction: only `claude/`-prefixed branches unless you enable unrestricted pushes.
- Routines belong to an individual account. Actions appear as the linked user (commits, PRs, Slack messages).
- Create from web, CLI (`/schedule`), or Desktop app ("New remote task" — *not* "New local task", which is a machine-local thing).

### Claude.ai's recommended starter routines (from `claude-code-routines-setup-guide.md`)
- Routine 1 — **CI Failure Fixer**: trigger `pull_request.opened` + `synchronized`, filter `draft=false`. Max 2 fix attempts, forbidden from touching business logic. Only fixes type errors, import paths, missing types, failing tests.
- Routine 2 — **Nightly Code Health**: daily schedule. Runs `tsc --noEmit`, `npm audit`, scans for large files / TODOs / `console.log`, runs coverage, opens chore PRs or issues.
- Routine 3 — **PR Quality Reviewer**: trigger `pull_request.opened`. Posts inline + summary comments (🟢/🟡/🔴). Explicitly instructed **not** to make changes.
- Emphasis: "Set up branch protection first, or the routines are useless."

### On vendor-agnostic architecture (from the Fortress artifact)
- 7-gate pipeline:
  1. Fast checks (lint, typecheck, secret scan, build) — no AI
  2. Test suite + coverage gate — no AI
  2B. AI auto-fix on failure — Agent 1 → fallback to Agent 2 → human
  3. AI code review — advisory, non-blocking
  4. Security scan (Dependabot + Snyk/npm-audit + CodeQL/Semgrep) — no AI; critical/high block, medium/low warn
  5. Human approval
  6. Deploy + smoke test + auto-rollback — no AI
  7. Post-deploy monitoring (Sentry); optional AI-triggered diagnosis
- Key file: a single `AGENTS.md` that all agents read (Claude via `CLAUDE.md`, Codex via `AGENTS.md`, Cursor via `.cursorrules`). Write once, translate across vendors.
- Companion YAML files referenced (not yet verified): `ci.yml`, `security.yml`, `ai-autofix.yml`, `ai-review.yml`, `deploy.yml`.
- One-liner philosophy cited in the artifact:
  > "The pipeline is the source of truth. Not the AI. Not you. The pipeline. If it says it's broken, it's broken. If it says it passes, it's safe to merge."

### Orchestrator tools mentioned by Claude.ai (UNVERIFIED)
- **MCO (Multi-CLI Orchestrator)** — described as a neutral layer dispatching prompts to Claude/Codex/Gemini CLIs in parallel.
- **Composio Agent Orchestrator** — fleets of coding agents, each with its own worktree/branch/PR; agent-, runtime-, tracker-agnostic.
- **AgentFlow** — dependency-graph orchestration of Codex/Claude/Kimi with fanout and cycles.
- *None of these are verified to exist / be maintained / have real adoption. The prior research agent did not surface any of them.* Treat as claims to fact-check.

## Related Artifacts
- `.planning/decisions/research-artifacts/2026-04-15-claude-code-routines-setup-guide.md` — Claude.ai's three-routine starter guide, verbatim.
- `.planning/decisions/research-artifacts/2026-04-15-the-fortress-vendor-agnostic-cicd.md` — 760-line "Fortress" architecture doc, verbatim (includes the 7-gate diagram, YAML templates, week-by-week plan, `AGENTS.md` template).
- `.planning/decisions/research-artifacts/2026-04-15-ai-era-ci-hooks-landscape.md` — grounded landscape research from the prior session.
- `.planning/decisions/2026-04-15-ci-cd-devops-literacy.md` — earlier literacy session this builds on.
