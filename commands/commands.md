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

## Phase 4: Architecture
- `db-architect` skill — Designs PostgreSQL schemas (auto, after data-grill)
- `infra-architect` skill — Designs hosting setup (auto, after infra-grill)

## Phase 4b: Quality Contracts (pre-code)
- `/playbook:define-quality-contracts` — Chain contract-pack + author-locked-tests + tiers.yaml for every critical feature BEFORE any source exists. Oracle pure by construction.
- `/playbook:contract-pack <feature>` — Per-feature frozen contract (source-denied authoring). Use for post-build additions or when `define-quality-contracts` wasn't the entry point.
- `/playbook:author-locked-tests <feature>` — Generate `acceptance.spec.ts` from a frozen contract (source-denied).
- `/playbook:classify-modules` — Interactive `tiers.yaml` builder.
- `/playbook:classify-check` — Verify every source file is covered by a tier glob.

## Phase 5: Build (choose one)

### GSD path — single-agent, phase-by-phase
- `/playbook:prd-to-gsd` — Convert PRD into `REQUIREMENTS.md` + `ROADMAP.md` + `STATE.md`
- `/playbook:gsd-to-linear` — Push GSD requirements to Linear as agent-sized issues with dependency mapping
- `/playbook:prd-to-linear` — Skip GSD, break PRD directly into Linear issues
- `/gsd:discuss-phase N`, `/gsd:plan-phase N`, `/gsd:execute-phase N`, `/gsd:quick "task"` — Execute one phase at a time

### Ralph path — autonomous overnight loop (external)
- `/playbook:prd-to-ralph` — Convert the PRD + grilling decisions into Huntley's exact `prd.json` format (flat array with id, category, description, page, ui_details, behavior, data_model, priority, core, passes, tests.{unit,e2e,edge_cases}). After this, you're ready for Ralph.
- Ralph itself is **external** — pull [github.com/ghuntley/ralph-to-ralph-prod](https://github.com/ghuntley/ralph-to-ralph-prod) into your target app (`build-ralph.sh`, `qa-ralph.sh`, `build-prompt.md`, `qa-prompt.md`). The playbook only writes the `prd.json` Ralph consumes.
- Flow: `prd-to-ralph` → `./build-ralph.sh 999` (Huntley builds, TDD-first, one feature per iteration) → `./qa-ralph.sh 999` (Huntley's first-pass QA via Codex) → Phase 7 QA pipeline below.

## Phase 6: Wire Selectors (post-build)
- `/playbook:wire-selectors <feature>` — Adjust `data-testid` selectors to match real DOM (assertions locked by AST diff audit). Run once per feature after Ralph or GSD finishes.

## Phase 7: QA Pipeline (install once, runs forever)
- `/playbook:install-qa-harness` — Scaffold `qa/` + `.quality/` into the target app (detects services, writes policies, installs enforcement hooks). Run once per app.
- `/playbook:qa-run` — Full session: preflight → baseline → features → release gates → summary. This is the one you run.
- `/playbook:qa-baseline` — Populate module mutation baselines (run once after install)
- `/playbook:qa-baseline-reset` — Explicit ratchet-down with audit-log entry
- `/playbook:qa-status` — Current state snapshot + per-tier floor check
- `/playbook:qa-report` — List all runs or open a specific run's summary
- `/playbook:qa-doctor` — Drift checks (services, contract hashes, deprecated commands, tier coverage)
- `/playbook:qa-clean` — Clear stale locks + archive old runs' heavy artifacts
- `/playbook:qa-unblock` — Reset a BLOCKED feature → pending + clear plateau buffer
- `/playbook:qa-audit-violations` — Aggregate `violations.jsonl` across all runs by pattern

## Standalone
- `/playbook:security-audit` — 6-check OWASP security review
- `/playbook:verify-with-codex` — Cross-model code review
- `/playbook:where-am-i` — Where am I? What's next? (10 seconds)

## The Flow

```
Phase 1–4: think, grill, PRD, architecture
Phase 4b:  define-quality-contracts   ← all contracts frozen here
Phase 5:   build (GSD or Ralph)       ← walk away
Phase 6:   wire-selectors <feature>   ← 5 min per feature after build
Phase 7:   install-qa-harness → qa:baseline → qa:run   ← walk away
```

## The One Rule
When in doubt: `/playbook:where-am-i`

## Archived commands

Older commands (harden, anneal, spec-runner, census-to-specs, mutation-gate, adversarial-*-builds, ralph-loop.sh, sprint-executor.sh, merge-coordinator.sh, etc.) have been archived to [drshailesh88/playbook-archive](https://github.com/drshailesh88/playbook-archive) (private repo). Their roles are subsumed by the Phase 4b + Phase 7 pipeline above.
