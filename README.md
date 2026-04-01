# Build Playbook

A plug-and-play system for AI-assisted product development. Works with **any AI tool** — Claude Code, GSD v2, Aider, Codex, or any future agent.

Built by combining methodologies from Geoffrey Huntley (Ralph Loop), Matt Pocock (skills + TDD), Jesse Vincent (Superpowers verification gates), GSD (milestone tracking), Cole Medin (PRP/PIV), and Karpathy (autoresearch).

## How It Works

Your playbook has two halves:

**THINKING** — grilling sessions that pull decisions out of your head into documents. Uses the smartest model you can afford, infrequently.

**BUILDING** — autonomous code generation from those documents. Uses cheap models, high volume.

The `.planning/` folder is the universal handoff between any thinking tool and any building tool.

## The Workflow

```
DAYTIME — Thinking (Claude Code, or any AI)
  /playbook:capture-planning     → .planning/decisions/
  /playbook:compete-research     → .planning/competition-research.md
  /playbook:ux-brief             → .planning/ux-brief.md
  /playbook:ui-brief             → .planning/ui-brief.md
  /playbook:data-grill           → .planning/data-requirements.md
  /playbook:infra-grill          → .planning/infra-requirements.md
  /write-a-prd                   → PRD document
  /playbook:prd-to-gsd           → .planning/REQUIREMENTS.md + ROADMAP.md + STATE.md

EVENING — Building (GSD v2 + cheap model, or Aider)
  gsd → /gsd migrate → /gsd auto    (walks away, builds overnight)

MORNING — Review (Claude Code, or any AI)
  /playbook:where-am-i          → see what got built
  /playbook:harden               → census + specs + test + heal
  /playbook:security-audit       → 6-check OWASP review
  /playbook:verify-with-codex    → cross-model code review
```

## Choose Your Tools

| Adapter | Best for | Install |
|---------|----------|---------|
| **Claude Code** | Thinking, reviewing, grilling sessions | `./install.sh` |
| **GSD v2** | Overnight autonomous building | `npm install -g gsd-pi` |
| **Aider** | Budget pair programming + overnight loops | `pip install aider-chat` |

See `adapters/` for setup guides for each tool.

## The 9-Phase Workflow

```
Phase 1: Capture     → capture-planning
Phase 2: Research    → compete-research
Phase 3: Interview   → ux-brief, ui-brief, data-grill, infra-grill
Phase 4: PRD & Plan  → grill-me → write-a-prd → prd-to-gsd
Phase 5: Architect   → db-architect, infra-architect
Phase 6: Build       → GSD v2 auto (or Aider overnight loop)
Phase 7: Quality     → security-audit, anneal-check, verify-with-codex
Phase 8: Harden      → harden (census → specs → test → heal → done)
Phase 9: Ship        → deploy + post-deploy verify
```

## Repo Structure

```
Build Playbook/
├── playbook/                  ← THE BRAIN (portable, works everywhere)
│   ├── THE-PLAYBOOK.md        ← master 9-phase guide
│   ├── workflows/             ← all grilling/testing/building processes
│   ├── rules/                 ← design rules, verification rules, DB rules
│   └── references/            ← architecture patterns, autoresearch guide
│
├── adapters/                  ← THE WIRING (per platform)
│   ├── claude-code/           ← slash commands + skills for Claude Code
│   ├── gsd/                   ← setup guide for GSD v2
│   └── aider/                 ← setup guide + overnight script for Aider
│
├── commands/                  ← Claude Code command source files
├── skills/                    ← Claude Code skill source files
├── vendor/                    ← Matt Pocock skills (10 skills)
├── research/                  ← competition + engineering research
└── install.sh                 ← Claude Code installer (unchanged)
```

## Key Principle: .planning/ is the Universal Interface

Every thinking tool writes to `.planning/`. Every building tool reads from `.planning/`. Switch tools anytime — your planning artifacts are plain markdown.

```
ANY thinking tool          .planning/           ANY building tool
(Claude Code,        →    ├── ux-brief.md    →  (GSD v2,
 ChatGPT,                 ├── data-reqs.md      Aider,
 any chatbot)             ├── REQUIREMENTS.md    Codex,
                          ├── ROADMAP.md         any future agent)
                          └── STATE.md
```

## 18 Slash Commands (Claude Code)

| Command | Phase | What it does |
|---------|-------|-------------|
| `capture-planning` | 1 | Save planning sessions to repo |
| `compete-research` | 2 | Competition analysis + design inspiration |
| `ux-brief` | 3 | UX interview with 10 design rules |
| `ui-brief` | 3 | Visual language interview |
| `data-grill` | 3 | Plain English database requirements |
| `infra-grill` | 3 | Plain English infrastructure requirements |
| `prd-to-gsd` | 4 | Bridge PRD to build milestone |
| `where-am-i` | 0 | 10-second context resume |
| `generate-feature-doc` | 5 | Auto-generate feature docs from code |
| `census-to-specs` | 7 | Convert feature census to test specs |
| `spec-runner` | 7 | Generate and run Playwright tests |
| `anneal` | 7 | Self-healing test loop |
| `anneal-check` | 6 | Quality score gate |
| `harden` | 7 | Full pipeline: census → specs → test → heal |
| `verify-with-codex` | 6 | Cross-model code review |
| `security-audit` | 6 | 6-check OWASP security review |
| `commands` | 0 | Show all available commands |
| `guide` | 0 | Show the full playbook guide |

## 5 Custom Skills (Auto-Triggered)

| Skill | Triggers when |
|-------|--------------|
| `feature-census` | Need to extract all capabilities from any module |
| `db-architect` | After data-grill — designs PostgreSQL schemas |
| `infra-architect` | After infra-grill — designs hosting setup |
| `verification-before-completion` | Agent claims work is done — blocks without evidence |
| `founders-design-rules` | UX/UI skills reference your 10 design rules |

## 10 Matt Pocock Skills (vendor/)

grill-me, write-a-prd, tdd, ubiquitous-language, design-an-interface, improve-codebase-architecture, write-a-skill, qa, prd-to-plan, triage-issue

## Install (Claude Code)

```bash
./install.sh
```

Then go to any project directory and type `/playbook:where-am-i` to start.

## Key Design Principles

1. Every phase leaves artifacts in the repo, not in chat windows
2. Plain English interviews — no jargon
3. `.planning/` is the universal handoff — works with any AI tool
4. Self-healing test loops inspired by Karpathy's autoresearch
5. Verification-before-completion blocks premature success claims
6. Expensive models for thinking, cheap models for building
