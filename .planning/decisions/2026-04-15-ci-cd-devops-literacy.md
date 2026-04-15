# Planning Session: CI/CD & DevOps Literacy for Non-Technical AI Builder
**Date:** 2026-04-15
**Source:** Claude.ai conversation (Q&A learning session)
**Status:** captured

## Context
Shailesh is a non-technical builder shipping with AI coding agents (Claude Code, Ralph, etc.). He set up GitHub Actions CI and needs to understand what he built, why it matters, and how to operate it from a mobile device. This session is mostly knowledge-building — establishing the mental model for CI/CD, pre-commit hooks, Playwright, AI-on-GitHub workflows, and a Ralph + Stryker loop — so he can make informed choices in later build phases.

## Key Decisions Made

1. **Adopt the layered safety-net model** — Pre-commit hook (local) → CI on GitHub (clean env) → CD (deploy only if green). Each layer catches what the previous misses. Rejected: relying only on local checks, or only on CI.

2. **Never push directly to `main`** — All changes go through a feature branch + pull request so CI gates run before code lands. Observed in the failing run: code was pushed straight to main with no PR, no hook, no review — that's how the 11 type errors + 3 warnings slipped in. Rejected: the current "push to main" habit.

3. **Use AI-on-GitHub agents instead of terminal round-trips** — Install Claude Code Action (primary) and/or Codex Triggers so `@claude` / `@codex` mentions on issues and PRs auto-create branches, fix CI failures, and open PRs. Rejected: the copy-error-paste-into-terminal loop.

4. **Treat CodeRabbit as a mandatory second reviewer** — The AI that wrote the code cannot also review it (shared blind spots). CodeRabbit reviews every PR the builder-AI opens. Rejected: single-agent write+review.

5. **Make test coverage the #1 defense against cross-module regressions** — Research cited: ~75% of AI agents break previously-working code during maintenance. Mitigation: broad tests across all modules, frequent commits, small incremental changes. Rejected: trusting the agent to not break module B while fixing module A.

6. **Wire Stryker mutation testing into CI as a merge gate** — Pipeline order: type check → unit tests → Stryker → deploy. Set a mutation-score threshold (starting target ~80%) below which PRs cannot merge. Post Stryker output as a PR comment so Claude Code Action can read surviving mutants and write stronger tests. Rejected: running Stryker only locally, ad hoc.

7. **Prompt AI agents with verification baked in** — Standard instruction pattern: "write the feature, run the tests, fix anything that fails, verify green before stopping." This converts the agent from code-writer to self-correcting builder. Rejected: one-shot "write this feature" prompts.

8. **Start the observability stack with two tools, not ten** — Begin with CodeRabbit (pre-merge review) + Sentry (post-deploy error capture). Add SonarCloud, Codecov, Lighthouse CI, Dependabot, Snyk later as gaps appear. Rejected: setting up all tools at once.

9. **Mobile-first operating workflow is viable** — Comment `@claude` on the failing PR from the phone's GitHub browser with a precise prompt (errors + file names + expected fix + "verify"). Claude Code mobile is the fallback. Editing files directly via GitHub's mobile pencil icon is the last resort. Rejected: "I need a laptop to fix CI."

## Open Questions

- [ ] Is Claude Code Action (or Codex Triggers) actually installed on the repo that produced the failing run? If not, install it before the next push.
- [ ] What mutation-score threshold should Stryker enforce for this project specifically? 80% is a starting guess — needs calibration after first real run.
- [ ] Which repo/module produced the 11 type errors + 3 Node-20-deprecated warnings in the screenshots? (Files referenced: `qa/controller.ts`, `qa/controller.test.ts`, `qa/detection/dependency-analyzer.ts`.) Needs triage + fix PR.
- [ ] Who glues Stryker output → PR comment → Claude Code Action? Is there an existing GitHub Action for this, or does it need a small custom workflow?
- [ ] Branch-protection rules on `main` — not yet configured. Need to decide required checks (type check, unit tests, Stryker ≥ threshold, CodeRabbit approval).
- [ ] Sentry + CodeRabbit: free tiers sufficient, or paid from day one?

## Constraints & Requirements

- Builder is non-technical — every tool must produce human-readable output or be operable via AI prompt, not raw log-reading.
- Mobile-operable — the full fix loop (diagnose → prompt AI → verify green → merge) must work from a phone.
- Codebase is TypeScript with strict typing — agents must be told this up-front so they stop emitting implicit-`any` parameters.
- No direct pushes to `main` once branch protection is enabled.
- Secrets (API keys, tokens) must live in GitHub Secrets, never in code.
- Every AI-authored PR must pass: type check + unit tests + Stryker threshold + CodeRabbit review before merge.

## Next Steps

1. Fix the current failing run — draft the `@claude` prompt covering the 11 type errors (missing modules in `qa/controller.ts`, `qa/controller.test.ts`, `qa/detection/dependency-analyzer.ts`; implicit-`any` on params `c, opts, i, p, d`) and the 3 Node 20 deprecation warnings. Push as a PR, not to `main`.
2. Install Claude Code Action on the repo (and/or Codex Triggers).
3. Turn on branch protection for `main`: require PR + passing CI + 1 review.
4. Add CodeRabbit to the repo.
5. Add a Stryker job to the GitHub Actions workflow; set an initial 80% mutation-score gate; post results as a PR comment.
6. Add Sentry to the deployed app for post-deploy error capture.
7. Revisit this doc after first full green run and calibrate thresholds.

## Raw Notes

_Original Q&A session with Claude.ai, captured verbatim. Topics in order: CI basics → CI vs local checks → pre-commit hooks → Playwright "run tests all the time from everywhere" → reading a GitHub Actions summary → going from summary to detailed report → tools for detailed diagnosis → can AI fix everything in one shot → AI agents on GitHub (Claude Code Action, Codex Triggers) → cross-module regressions (75% stat) → mobile-first fix workflow on a screenshot showing 11 errors + 3 warnings → where the errors came from (no PR, no hook, pushed to main) → Ralph + Stryker loop in CI._

### Q1 — What is CI / CI-CD / GitHub Actions?
CI = automatic quality check on every push. CD = auto-deploy after CI passes. GitHub Actions = one implementation of CI/CD (not a different concept). Workflow file lives in `.github/workflows/`. Value: safety net for AI-written code.

### Q2 — Why CI on GitHub if I check locally?
Local = first line of defense, fast feedback. CI = always runs, clean environment, source of truth across collaborators/agents. Complementary, not either/or.

### Q3 — Pre-commit hooks
Automatic checks that run before a commit is saved; block the commit if they fail. In Claude Code: formatter + linter + tests before each commit. Safety chain = pre-commit → CI → CD. Catches problems at the earliest (cheapest) moment.

### Q4 — Playwright "all the time from everywhere"
Playwright = real-browser end-to-end testing. "All the time" = local + commit + push + pre-deploy + post-deploy. "From everywhere" = multiple browsers, screen sizes, scenarios. More layers = fewer escapes to users.

### Q5 — Reading a GitHub Actions report
Each row = one job. Red X = failed (with annotation count = # of specific problems). Green check = passed. Grey/skipped = didn't run because an upstream job failed (e.g., Build skipped when Type Check fails — CD safety working as intended). Action: click into failed jobs, read annotations.

### Q6 — Beyond the summary: detailed reports + the fix loop
Click "View workflow run" → failed job → annotations (file + line + error). As a non-technical builder: don't read errors yourself — route them. Copy log → paste to AI → AI fixes → push → CI green. "You're the project manager. CI is the inspector. AI is the developer."

### Q7 — Tools for detailed diagnosis + auto-fix
- Auto-review/fix: CodeRabbit, SonarCloud, GitHub Copilot Autofix.
- Visual reports: Codecov (coverage map), Lighthouse CI (perf/a11y/SEO scores), Sentry (runtime error capture).
- Security: Dependabot (built-in), Snyk.
- Recommended starting pair: **CodeRabbit + Sentry**.

### Q8 — Can AI fix everything without 10 manual steps?
No single product does the full loop yet, but you can chain it: push → CI fails → AI agent reads failure → opens fix PR → CodeRabbit reviews → CI green → human taps approve. Key habit: always prompt the agent to "write + run tests + fix failures + verify" in one instruction, not just "write the feature."

### Q9 — AI agents on GitHub, no terminal
- **Claude Code Action** — `@claude` on issue/PR → branch + fix + PR. Has auto-fix watcher for CI failures and reviewer comments.
- **OpenAI Codex** — `@codex` mentions + Triggers that respond to GitHub events automatically.
Both remove the terminal from the loop.

### Q10 — What if fixing module A breaks module B?
Real risk. Research cited in-session: ~75% of AI coding agents break previously-working code during maintenance; even top models fail ~25% of the time. Defenses:
1. Comprehensive test coverage (B's tests catch A's fix breaking B).
2. Small incremental changes (failing test → minimal code → pass).
3. Commit often (instant rollback).
4. Separate writer-AI from reviewer-AI (no shared blind spots).

Practical setup: Claude Code Action auto-fixes CI; CodeRabbit reviews; CI runs *all* modules' tests; merge only if fully green.

### Q11 — Reading a real failing report (screenshots: 11 errors + 3 warnings)
Two root causes:
- **"Cannot find module"** in `qa/controller.ts`, `qa/controller.test.ts`, `qa/detection/dependency-analyzer.ts` — AI imported files that don't exist / were renamed / moved.
- **"Parameter implicitly has an 'any' type"** — params `c, opts, i, p, d` missing TypeScript types.
- 3 warnings = `actions/*@v3` using deprecated Node 20 — workflow file update, not a code bug.
- Observation: code was pushed directly to `main` — no PR, no hook, no review. That's the process gap.

Mobile fix options:
1. Comment `@claude` on the PR from phone browser with a precise prompt.
2. Use Claude Code mobile.
3. Copy errors → paste to any AI chat → edit files via GitHub mobile pencil icon.

Prompt template used:
> My CI type check is failing with 11 errors. Here are the annotations: [paste]. The codebase uses TypeScript. Fix all missing module imports and add proper type annotations to all parameters that implicitly have 'any' type. After fixing, verify there are no other type errors.

### Q12 — Where did these errors creep in?
- Missing-module errors = AI "hallucinated" files it never actually created.
- Implicit-any errors = AI wrote loose code without explicit types.
- The deeper cause = **no checkpoint between "AI wrote code" and "code in main."** Fix is process (branch + PR + CI gate before merge) + upfront prompt ("strict TypeScript, always add explicit types, verify imports exist").

### Q13 — Ralph + Stryker in CI
- Ralph = autonomous build loop (fail → retry until green).
- Stryker = mutation testing; flips small bits of code and checks if tests catch it. Exposes passing-but-useless tests.
- Pipeline: type check → unit tests → Stryker → deploy. Gate merges on a mutation-score threshold (starting ~80%).
- Full automated loop (not yet a polished product — requires glue):
  Ralph writes code + tests → CI runs Stryker → surviving mutants posted as PR comment → Claude Code Action reads the comment → writes stronger tests → CI re-runs Stryker → merge when threshold is met.
- This gives a builder who not only writes code but *proves* its tests are real by surviving Stryker's challenges.

## Related Artifacts
Research outputs from Claude.ai's research tool that informed the answers in this session have been copied into this repo:
- `.planning/decisions/research-artifacts/2026-04-15-github-ai-agents-research.md` (Claude Code Action / Codex Triggers / cross-module regression research)
- `.planning/decisions/research-artifacts/2026-04-15-ralph-stryker-ci-research.md` (Ralph + Stryker CI pipeline research)
