# Build Playbook

A 7-layer system for building unbreakable software with AI. Every decision documented. Every edge case tested. Every sad path handled. Every session smarter than the last.

Built by combining methodologies from Geoffrey Huntley (Ralph Loop), Matt Pocock (skills + TDD), Jesse Vincent (Superpowers verification gates), GSD (milestone tracking), Cole Medin (PRP/PIV), Karpathy (autoresearch), ECC (hooks + agents + GateGuard), and gstack (Boil the Lake + persistent learning).

## The 7 Layers

```
Layer 7: PHILOSOPHY       ← Ethos injected into every skill and session
Layer 6: DIALOGUE          ← Office-hours → grill → brief → PRD
Layer 5: PLANNING          ← Agent delegation, subagent-per-task, phase planning
Layer 4: EXECUTION         ← Sprint build, adversarial loops, TDD
Layer 3: RUNTIME GUARDS    ← Hooks: GateGuard, config protection, quality gate
Layer 2: REVIEW PIPELINE   ← Review → QA → Ship → Canary
Layer 1: LEARNING          ← Session persistence, per-project learnings
```

Each layer catches what the layer above missed.

## How It Works

**THINKING** — grilling sessions that pull decisions out of your head into documents. Uses the smartest model you can afford, infrequently.

**BUILDING** — autonomous code generation from those documents. Uses cheap models, high volume. Hooks fire automatically on every edit.

**LEARNING** — every session records what worked, what broke, what patterns emerged. The next session loads those learnings automatically.

The `.planning/` folder is the universal handoff between any thinking tool and any building tool.

## The Workflow

```
START        → /playbook:where-am-i         (context resume)

THINK        → /playbook:office-hours        (deep product interrogation)
             → /playbook:compete-research    (competition analysis)
             → /playbook:ux-brief            (UX interview)
             → /playbook:ui-brief            (visual language interview)
             → /playbook:data-grill          (database requirements)
             → /playbook:infra-grill         (infrastructure requirements)
             → /write-a-prd                  (PRD document)
             → /playbook:prd-to-gsd          (build milestones)

BUILD        → GSD auto / Aider overnight    (autonomous building)
             → Hooks fire automatically       (GateGuard, quality gate, config protection)

REVIEW       → /playbook:review              (multi-specialist code review)
             → /playbook:security-audit      (OWASP security review)
             → /playbook:verify-with-codex   (cross-model verification)

HARDEN       → /playbook:harden              (census → specs → test → heal)
             → /playbook:investigate         (root cause debugging)

SHIP         → /playbook:ship                (test → push → PR)
             → /playbook:canary              (post-deploy monitoring)

LEARN        → /playbook:learn               (manage project learnings)
```

## What's Installed

### 39 Slash Commands

| Command | Phase | What it Does |
|---------|-------|-------------|
| `office-hours` | Think | Deep YC-style product interrogation (6 forcing questions) |
| `capture-planning` | Think | Save planning sessions to repo |
| `compete-research` | Think | Competition analysis + design inspiration |
| `ux-brief` | Think | UX interview with 10 design rules |
| `ui-brief` | Think | Visual language interview |
| `data-grill` | Think | Plain English database requirements |
| `infra-grill` | Think | Plain English infrastructure requirements |
| `prd-to-gsd` | Plan | Bridge PRD to build milestones |
| `review` | Review | Multi-specialist code review with auto-fix |
| `security-audit` | Review | 6-check OWASP security review |
| `verify-with-codex` | Review | Cross-model code review |
| `investigate` | Debug | Systematic root-cause debugging (no band-aids) |
| `harden` | Harden | Full pipeline: census → specs → test → heal |
| `anneal` | Harden | Self-healing test loop |
| `anneal-check` | Harden | Quality score gate |
| `ship` | Ship | Test → push → PR (automated) |
| `canary` | Ship | Post-deploy production monitoring |
| `learn` | Learn | Manage project learnings |
| `where-am-i` | Any | 10-second context resume |
| `commands` | Any | Show all available commands |
| `guide` | Any | Show the full playbook guide |
| + 18 more | QA/Ralph | QA pipeline, Ralph loop, Linear integration |

### 7 Custom Skills (Auto-Triggered)

| Skill | What it Does |
|-------|-------------|
| `gateguard` | Fact-forcing gate: investigate callers before editing (+2.25 quality) |
| `continuous-learning` | Auto-capture learnings, load on session start |
| `feature-census` | Extract complete module capabilities (3-layer analysis) |
| `verification-before-completion` | Block completion claims without evidence |
| `db-architect` | Design PostgreSQL schemas (after data-grill) |
| `infra-architect` | Design hosting setup (after infra-grill) |
| `founders-design-rules` | 10 design rules for UX/UI skills |

### 6 Specialist Agents

| Agent | When it's Invoked |
|-------|------------------|
| `planner` | Feature spans 3+ files or needs architecture decisions |
| `code-reviewer` | Before PR creation, deep quality review |
| `security-reviewer` | Changes touch auth, payments, user data |
| `tdd-guide` | Starting any new feature or fixing a bug |
| `build-error-resolver` | Build/compile/test suite crashes |
| `database-reviewer` | Schema changes, migrations, complex queries |

### 5 Always-Loaded Rules

| Rule | What it Enforces |
|------|-----------------|
| `security` | OWASP Top 10, no hardcoded secrets, input validation |
| `testing` | 3-tier test system, TDD, 80%+ coverage, failure blame protocol |
| `coding-style` | Immutability, small files, clear naming, minimal comments |
| `git-workflow` | Conventional commits, branch discipline, no force-push |
| `development-workflow` | Search before building, boil the lake checklist, token optimization |

### 6 Automatic Hooks

| Hook | When it Fires | What it Does |
|------|--------------|-------------|
| GateGuard | Before Edit/Write | Forces investigation of callers before editing |
| Config Protection | Before Edit | Blocks weakening of linter/TS configs |
| Careful Check | Before Bash | Warns on destructive commands |
| Quality Gate | After Edit/Write | Runs format + typecheck automatically |
| Session End | When Claude stops | Saves state for next session |
| Session Start | First prompt | Loads learnings + last session state |

### 10 Matt Pocock Skills

grill-me, write-a-prd, tdd, ubiquitous-language, design-an-interface, improve-codebase-architecture, write-a-skill, qa, prd-to-plan, triage-issue

## Repo Structure

```
Build Playbook/
├── ETHOS.md                   ← 5 engineering principles (injected everywhere)
├── THE-PLAYBOOK.md            ← Master 9-phase guide
│
├── rules/                     ← Always-loaded guidelines (steer every session)
│   ├── security.md
│   ├── testing.md
│   ├── coding-style.md
│   ├── git-workflow.md
│   └── development-workflow.md
│
├── agents/                    ← Specialist subagents (delegate complex work)
│   ├── planner.md
│   ├── code-reviewer.md
│   ├── security-reviewer.md
│   ├── tdd-guide.md
│   ├── build-error-resolver.md
│   └── database-reviewer.md
│
├── hooks/                     ← Automatic runtime behaviors
│   ├── hooks.json             ← Hook configuration
│   ├── README.md
│   └── scripts/
│       ├── gateguard-fact-force.sh
│       ├── config-protection.sh
│       ├── quality-gate.sh
│       ├── careful-check.sh
│       ├── session-end.sh
│       └── session-start.sh
│
├── commands/                  ← 39 slash commands
├── skills/                    ← 7 auto-triggered skills
├── playbook/                  ← Reference materials + QA scaffold
│   ├── THE-PLAYBOOK.md
│   ├── workflows/
│   ├── rules/
│   ├── references/
│   └── qa-scaffold/
│
├── adapters/                  ← Per-tool setup guides
├── vendor/                    ← Matt Pocock skills
└── install.sh                 ← Global installer
```

## Install

```bash
./install.sh
```

Then go to any project directory and type `/playbook:where-am-i` to start.

## Key Principles

1. **Boil the Lake** — AI makes completeness cheap. Do 100%, not 90%.
2. **Search Before Building** — Check runtime, then ecosystem, then build from scratch.
3. **User Sovereignty** — AI recommends, human decides. Always.
4. **Evidence Over Assertion** — Run the command. Read the output. THEN claim the result.
5. **Every Session Leaves the System Smarter** — Learnings persist and compound.
6. **.planning/ is the Universal Interface** — Plain markdown. Works with any AI tool.
7. **Hooks Fire Automatically** — No human has to remember to run quality checks.

## Methodology Sources

| Source | What We Took |
|--------|-------------|
| **ECC** (affaan-m) | Hooks architecture, GateGuard, agent delegation, continuous learning, rules system |
| **gstack** (garrytan) | Boil the Lake ethos, office-hours interrogation, review/ship/canary pipeline, learnings system, careful/freeze hooks |
| **Geoffrey Huntley** | Ralph Loop — autonomous task execution |
| **Matt Pocock** | Skills + TDD methodology, deep modules |
| **Jesse Vincent** | Superpowers verification gates |
| **GSD** | Milestone tracking, .planning/ state on disk |
| **Cole Medin** | PRP/PIV quality scoring, confidence loops |
| **Karpathy** | Autoresearch self-healing loops |
