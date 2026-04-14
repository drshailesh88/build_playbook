Show the user a quick-reference of ALL available playbook commands, organized by workflow phase.

## Phase 1: Capture & Research
- `/playbook:capture-planning` — Save planning session notes to repo
- `/playbook:compete-research` — Deep dive into competitors + design inspirations

## Phase 2: Grill & Interview
- `/playbook:ux-brief` — UX interview (all questions upfront, bulk brain dump)
- `/playbook:ui-brief` — UI/visual language interview (fonts, colors, spacing)
- `/playbook:data-grill` — Database requirements interview (plain English)
- `/playbook:infra-grill` — Infrastructure requirements interview (plain English)

## Phase 3: Language & PRD
- `grill-me` skill — Stress-test your idea (auto-triggers)
- `write-a-prd` skill — Write the PRD from gathered context (auto-triggers)
- `ubiquitous-language` skill — Define shared vocabulary (auto-triggers)

## Phase 4: Technical Architecture
- `db-architect` skill — Designs PostgreSQL schemas (auto, after data-grill)
- `infra-architect` skill — Designs hosting setup (auto, after infra-grill)

## Phase 4b: Define Quality Contracts (pre-code, oracle-pure-by-construction)
- `/playbook:define-quality-contracts` — Chain contract-pack + author-locked-tests + initial tiers.yaml for every critical feature BEFORE any source exists. After Ralph builds, the only manual step is `/playbook:wire-selectors` per feature; everything else is `npm`.

## Phase 5: Build
- `/playbook:prd-to-gsd` — Bridge PRD to GSD milestone (single-agent interactive workflow)
- `/playbook:gsd-to-linear` — Push GSD requirements to Linear as agent-sized subtask issues with dependency mapping
- `/playbook:prd-to-linear` — Skip GSD, break PRD directly into agent-sized Linear issues (multi-agent shortcut)
- `/playbook:where-am-i` — Where am I? What's next? (10 seconds)
- GSD commands: `/gsd:discuss-phase N`, `/gsd:plan-phase N`, `/gsd:execute-phase N`, `/gsd:quick "task"`

## Phase 5b: Ralph Loops (via Linear)
- `./adapters/linear/ralph-loop.sh "Project"` — Simple Ralph: Claude builds each issue, Linear tracks progress
- `./adapters/linear/ralph-loop-adversarial.sh "Project"` — Adversarial Ralph: Claude builds, Codex attacks, Claude fixes, repeat until clean
- `./adapters/linear/sprint-executor.sh DRS-10` — Build one issue, leave branch for integration
- `./adapters/linear/parallel-sprint.sh --group A` — Run parallel group from execution plan
- `./adapters/linear/parallel-sprint.sh --all` — Run all groups respecting dependencies
- `./adapters/linear/merge-coordinator.sh` — Serial integration of Built branches with conflict resolution
- `BUILDER_AGENT=aider REVIEWER_AGENT=codex ./adapters/linear/sprint-executor.sh DRS-10` — Mix agents

## Phase 6: Quality Gates (single-shot audits)
- `/playbook:security-audit` — 6-check OWASP security review
- `/playbook:anneal-check` — Quality score gate (--gate flag for hard stop)
- `/playbook:verify-with-codex` — Cross-model code review

## Phase 6b: Independent Oracle (per-feature, manual path)
- `/playbook:contract-pack <feature>` — Author or version-bump a frozen contract for one feature (source-denied authoring). Use when the pre-build `/playbook:define-quality-contracts` path wasn't taken, or for a post-build addition.
- `/playbook:author-locked-tests <feature>` — Generate `acceptance.spec.ts` from a frozen contract (source-denied)
- `/playbook:wire-selectors <feature>` — Adjust `data-testid` selectors to match the real DOM after build (assertions locked by AST diff audit)
- `/playbook:classify-modules` — Interactive `tiers.yaml` builder
- `/playbook:classify-check` — Verify every source file is covered by a tier glob
- `/playbook:mutation-gate` — Run Stryker mutation testing, strengthen weak assertions

## Phase 7: QA Controller Harness (install once, runs forever)
- `/playbook:install-qa-harness` — Scaffold `qa/` + `.quality/` into a target app (detects services, writes policies, installs enforcement hooks)
- `/playbook:qa-run` — Full session: preflight → baseline → features → release gates → summary
- `/playbook:qa-baseline` — Populate module mutation baselines (run once after install)
- `/playbook:qa-baseline-reset` — Explicit ratchet-down with audit-log entry
- `/playbook:qa-status` — Current state snapshot + per-tier floor check
- `/playbook:qa-report` — List all runs or open a specific run's summary
- `/playbook:qa-doctor` — Drift checks (services, contract hashes, deprecated commands, tier coverage)
- `/playbook:qa-clean` — Clear stale locks + archive old runs' heavy artifacts
- `/playbook:qa-unblock` — Reset a BLOCKED feature → pending + clear plateau buffer
- `/playbook:qa-audit-violations` — Aggregate `violations.jsonl` across all runs by pattern

## Phase 7 (legacy): Harden & Test
- `/playbook:harden` — Full pipeline in one command (census → specs → test → heal)
- `/playbook:census-to-specs` — Convert features to test specs (post-build coverage discovery)
- `/playbook:spec-runner` — Run Playwright tests from specs
- `/playbook:anneal` — Self-healing test loop (with no-oracle-drift rules)
- `/playbook:generate-feature-doc` — Auto-generate feature docs
- `./adapters/linear/ralph-loop-qa.sh "Project"` — Overnight QA: adversary attacks, fixes, mutation hardening, per-module locking

## The One Rule
When in doubt: `/playbook:where-am-i`
