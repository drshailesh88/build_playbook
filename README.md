# Build Playbook

A plug-and-play system of global slash commands and skills for AI-assisted development. Take this to any project directory and start building with a structured engineering workflow.

Built by combining methodologies from Geoffrey Huntley (Ralph Loop), Matt Pocock (skills + TDD), Jesse Vincent (Superpowers verification gates), GSD v1 (milestone tracking), Cole Medin (PRP/PIV), and others.

## What's Inside

### 16 Slash Commands (`/playbook:*`)

| Command | Phase | What it does |
|---------|-------|-------------|
| `capture-planning` | 1 | Save Claude.ai/ChatGPT planning sessions to repo |
| `compete-research` | 2 | Competition analysis + design inspiration extraction |
| `ux-brief` | 3 | UX interview with 10 design rules baked in |
| `ui-brief` | 3 | Visual language interview with font/color guidance |
| `data-grill` | 3 | Plain English database requirements interview |
| `infra-grill` | 3 | Plain English infrastructure requirements interview |
| `prd-to-gsd` | 4 | Bridge PRD to GSD milestone with readiness gate |
| `where-am-i` | 6 | 10-line resumption context |
| `generate-feature-doc` | 8 | Auto-generate feature docs from code + plans |
| `census-to-specs` | 8 | Convert feature census to testable specs |
| `spec-runner` | 8 | Generate and run Playwright tests from specs |
| `anneal` | 8 | Self-healing test loop (diagnose, fix, verify) |
| `anneal-check` | 7 | Quality score gate with regression detection |
| `harden` | 8 | Full pipeline: census, specs, test, heal, done |
| `verify-with-codex` | 7 | Cross-model code review (PASS/CONCERNS/REWORK/FAIL) |
| `security-audit` | 7 | 6-check OWASP security review |

### 5 Custom Auto-Triggered Skills

| Skill | Triggers when |
|-------|--------------|
| `feature-census` | Need to extract all capabilities from any module |
| `db-architect` | After `/data-grill` — designs future-proof PostgreSQL schemas |
| `infra-architect` | After `/infra-grill` — designs complete hosting setup |
| `verification-before-completion` | Agent claims work is done — blocks without evidence |
| `founders-design-rules` | UX/UI skills reference your 10 portable design rules |

### 10 Matt Pocock Skills (vendor/)

grill-me, write-a-prd, tdd, ubiquitous-language, design-an-interface, improve-codebase-architecture, write-a-skill, qa, prd-to-plan, triage-issue

## The 9-Phase Workflow

```
Phase 1: Capture     → /capture-planning
Phase 2: Research    → /compete-research
Phase 3: Interview   → /ux-brief, /ui-brief, /data-grill, /infra-grill
Phase 4: PRD & Plan  → grill-me → write-a-prd → /prd-to-gsd
Phase 5: Architect   → db-architect skill, infra-architect skill
Phase 6: Build       → GSD phases (discuss → plan → execute → next)
Phase 7: Quality     → /security-audit, /anneal-check, /verify-with-codex
Phase 8: Harden      → /harden (census → specs → test → heal → done)
Phase 9: Ship        → deploy + post-deploy verify
```

## Install

Run the install script to copy everything into your global `~/.claude/`:

```bash
./install.sh
```

Or manually:

```bash
# Commands
cp -r commands/*.md ~/.claude/commands/playbook/

# Skills
cp -r skills/feature-census ~/.claude/skills/
cp -r skills/db-architect ~/.claude/skills/
cp -r skills/infra-architect ~/.claude/skills/
cp -r skills/verification-before-completion ~/.claude/skills/
cp skills/founders-design-rules.md ~/.claude/skills/

# Matt Pocock skills
cp -r vendor/mattpocock-skills/* ~/.claude/skills/

# Reference docs
cp THE-PLAYBOOK.md ~/.claude/
cp WORKFLOW-REFERENCE.md ~/.claude/
cp MASTER-REPO-GUIDE.md ~/.claude/
```

Then go to any project directory and type `/playbook:where-am-i` to start.

## Reference Docs

- `THE-PLAYBOOK.md` — Master 9-phase workflow guide
- `WORKFLOW-REFERENCE.md` — Skill origin map + when-to-use guide
- `MASTER-REPO-GUIDE.md` — Repos to fork + install script
- `research/` — Competition, UI/UX, and engineering team research

## Key Design Principles

1. Every phase leaves artifacts in the repo, not in chat windows
2. Plain English interviews — no jargon (data-grill, infra-grill, ux-brief)
3. Two-layer pattern: interviewer (talks to you) → engineer (does the work)
4. Self-healing test loops (anneal) inspired by Karpathy's auto-research
5. Verification-before-completion blocks premature success claims
6. Feature census catches emergent capabilities from library defaults
