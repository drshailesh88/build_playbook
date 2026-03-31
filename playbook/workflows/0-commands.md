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

## Phase 5: Build
- `/playbook:prd-to-gsd` — Bridge PRD to GSD milestone
- `/playbook:where-am-i` — Where am I? What's next? (10 seconds)
- GSD commands: `/gsd:discuss-phase N`, `/gsd:plan-phase N`, `/gsd:execute-phase N`, `/gsd:quick "task"`

## Phase 6: Quality Gates
- `/playbook:security-audit` — 6-check OWASP security review
- `/playbook:anneal-check` — Quality score gate (--gate flag for hard stop)
- `/playbook:verify-with-codex` — Cross-model code review

## Phase 7: Harden & Test
- `/playbook:harden` — Full pipeline in one command (census → specs → test → heal)
- `/playbook:census-to-specs` — Convert features to test specs
- `/playbook:spec-runner` — Run Playwright tests from specs
- `/playbook:anneal` — Self-healing test loop
- `/playbook:generate-feature-doc` — Auto-generate feature docs

## The One Rule
When in doubt: `/playbook:where-am-i`
