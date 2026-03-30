# Master Skills Repo — Organization Guide

## Repo Structure

```
your-repo/
├── README.md                          # What this repo is, how to use it
│
├── commands/                          # Slash commands (drop into .claude/commands/)
│   ├── planning/
│   │   ├── capture-planning.md        # Save Claude.ai decisions to repo
│   │   ├── prd-to-gsd.md             # Bridge PRD → GSD milestone
│   │   ├── where-am-i.md             # Resumption context after breaks
│   │   ├── anneal-check.md           # Quality score check with gate
│   │   ├── verify-with-codex.md      # Multi-model code review
│   │   └── generate-feature-doc.md   # Auto feature docs from GSD + code
│   │
│   ├── competition/
│   │   └── compete-research.md       # Deep competition + inspiration dive
│   │
│   ├── design/
│   │   ├── ux-brief.md              # UX interview (all questions upfront)
│   │   └── ui-brief.md             # Visual language interview
│   │
│   ├── database/
│   │   └── data-grill.md           # Plain English data requirements extraction
│   │
│   └── testing/
│       ├── census-to-specs.md       # Convert features to test checkpoints
│       ├── spec-runner.md           # Generate + run Playwright tests
│       ├── anneal.md               # Self-healing test loop
│       └── harden.md               # Full pipeline orchestrator
│
├── skills/                           # Auto-triggered skills (drop into .claude/skills/)
│   ├── feature-census/
│   │   ├── SKILL.md                 # 3-layer capability extraction
│   │   └── references/
│   │       └── library-capabilities.md
│   │
│   ├── db-architect/
│   │   ├── SKILL.md                 # Senior PostgreSQL engineer
│   │   └── references/
│   │       ├── postgresql-golden-rules.md
│   │       ├── schema-patterns.md
│   │       ├── migration-safety.md
│   │       └── anti-pattern-detection.md
│   │
│   ├── design-rules/
│   │   └── founders-design-rules.md  # Your 10 portable design rules
│   │
│   └── verification-before-completion.md  # Hard gate on completion claims
│
├── research/                         # Research documents (reference, not installed)
│   ├── RESEARCH-UI-UX-COMPETITION-2026-03-29.md
│   └── HANDOFF-DB-ARCHITECT-2026-03-29.md
│
├── vendor/                           # Forked/copied reference repos (READ-ONLY reference)
│   │
│   │  # ── DATABASE ──────────────────────────────────────────
│   ├── timescale-pg-aiguide/         # Official PostgreSQL best practices
│   ├── supabase-agent-skills/        # Supabase PostgreSQL patterns
│   │
│   │  # ── FRONTEND / DESIGN ────────────────────────────────
│   ├── frontend-design-toolkit/      # Meta-guide to ALL frontend tools
│   ├── figma-to-react/               # Pixel-perfect Figma → React
│   ├── screenshot-to-code/           # Screenshot/URL → React/HTML
│   ├── ux-audit-skills/              # Nielsen, WCAG, Don Norman audits
│   ├── ui-ux-pro-max-skill/          # Design intelligence database
│   │
│   │  # ── WORKFLOW / ENGINEERING ────────────────────────────
│   ├── superpowers/                   # Jesse Vincent's verification + brainstorming
│   ├── get-shit-done/                 # GSD v1 project management
│   └── claude-code-design-skills/     # Figma-to-code workflow
│
└── install.sh                        # Script to copy everything into a project
```

---

## QUESTION 1: Which Repos to Fork/Copy Into vendor/

### DATABASE (2 repos)

| Repo | Why You Need It | What to Copy |
|------|----------------|-------------|
| **timescale/pg-aiguide** | The gold standard for PostgreSQL table design. Written by actual PostgreSQL engineers. Every data type rule, indexing strategy, JSONB pattern, and partitioning guide. Also has pgvector skill for embeddings. | Fork entire repo. Your db-architect skill references it. |
| **supabase/agent-skills** | 35 reference files across 8 priority categories. Covers FK indexing, RLS, connection pooling, pagination, constraint safety, monitoring. Production-tested at Supabase scale. | Fork entire repo. Focus: `skills/supabase-postgres-best-practices/references/` |

### FRONTEND / DESIGN (5 repos)

| Repo | Why You Need It | What to Copy |
|------|----------------|-------------|
| **wilwaldon/Claude-Code-Frontend-Design-Toolkit** | THE meta-guide. Curates every MCP, plugin, and skill for frontend design. Explains Figma integration, design audits, animation tools, Code Connect. This is your table of contents for frontend tools. | Fork entire repo. Read first before installing anything else. |
| **gbasin/figma-to-react** | Claude Code PLUGIN. Converts Figma → pixel-perfect React + Tailwind. Has a visual validation loop (screenshot → compare → fix → loop until ≤5% diff). Downloads assets, extracts CSS variables. Your main Figma-to-code tool. | Fork entire repo. Install as plugin: `claude plugin marketplace add gbasin/figma-to-react` |
| **abi/screenshot-to-code** | The gold standard for UI cloning. Drop a screenshot or paste a URL → get React/HTML/Tailwind/Vue. Uses Claude or GPT-4 Vision. Also supports screen RECORDING to code. Your workaround for the HTML-to-React problem. | Fork entire repo. Run locally when you need to clone a competitor's UI. |
| **mastepanoski/claude-skills** | UX audit skills using industry standards: Nielsen's 10 heuristics, WCAG accessibility, Don Norman's design principles. Audit any page from URL, screenshot, or code. Your design quality gate. | Fork entire repo. Install: `npx skills add mastepanoski/claude-skills --skill ux-audit-rethink` |
| **nextlevelbuilder/ui-ux-pro-max-skill** | Searchable databases: 500+ UI styles, color palettes, font pairings, chart types, UX guidelines. Covers 12+ frontend stacks. Has a BM25 search engine for finding design patterns. Your design reference library. | Fork entire repo. Install: `claude plugin add nextlevelbuilder/ui-ux-pro-max-skill` |

### WORKFLOW / ENGINEERING (3 repos)

| Repo | Why You Need It | What to Copy |
|------|----------------|-------------|
| **obra/superpowers** (Jesse Vincent) | Brainstorming HARD-GATE pattern, verification-before-completion (evidence before claims), subagent-driven-development, writing-plans. The engineering discipline layer. Your verification-before-completion skill is adapted from here. | Fork entire repo. Reference for skill updates. |
| **nichochar/get-shit-done** (GSD v1) | Project management inside Claude Code. Milestones, phases, plans, execution, progress tracking. STATE.md on disk survives between sessions. Your prd-to-gsd and where-am-i commands integrate with this. | Install via `npx get-shit-done-cc@latest`. Fork for reference. |
| **scoobynko/claude-code-design-skills** | Figma-to-code workflow skill. Systematic MCP usage (metadata → context → screenshot → variables), component reuse strategy, Figma variant mapping. More structured than gbasin's plugin. | Fork entire repo. Study the workflow pattern. |

---

## QUESTION 2: Which Frontend Tools Go Into the Repo

### INSTALL IMMEDIATELY (Plugins/MCPs — not forked, just installed)

These are tools you INSTALL into Claude Code, not files you copy. Run these commands in any project:

```bash
# 1. Official Figma MCP (bidirectional design ↔ code)
claude mcp add --transport http figma https://mcp.figma.com/mcp

# 2. Playwright MCP (Claude can browse and interact with web apps)
claude mcp add playwright -s user -- npx @playwright/mcp@latest

# 3. Anthropic's official frontend-design skill (opinionated, distinctive UI)
claude plugin add anthropic/frontend-design

# 4. Figma-to-React plugin (pixel-perfect conversion with validation loop)
claude plugin marketplace add gbasin/figma-to-react

# 5. UI/UX design intelligence database
claude plugin add nextlevelbuilder/ui-ux-pro-max-skill

# 6. Timescale PostgreSQL guide
claude plugin marketplace add timescale/pg-aiguide

# 7. Supabase PostgreSQL best practices
claude plugin marketplace add supabase/agent-skills

# 8. GSD v1 project management
npx get-shit-done-cc@latest
```

### COPY INTO VENDOR (Reference repos — forked for offline access)

```bash
# Clone all vendor repos
cd your-repo/vendor/

# Database
git clone --depth 1 https://github.com/timescale/pg-aiguide.git timescale-pg-aiguide
git clone --depth 1 https://github.com/supabase/agent-skills.git supabase-agent-skills

# Frontend / Design
git clone --depth 1 https://github.com/wilwaldon/Claude-Code-Frontend-Design-Toolkit.git frontend-design-toolkit
git clone --depth 1 https://github.com/gbasin/figma-to-react.git figma-to-react
git clone --depth 1 https://github.com/abi/screenshot-to-code.git screenshot-to-code
git clone --depth 1 https://github.com/mastepanoski/claude-skills.git ux-audit-skills
git clone --depth 1 https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git ui-ux-pro-max-skill

# Workflow
git clone --depth 1 https://github.com/obra/superpowers.git superpowers
git clone --depth 1 https://github.com/nichochar/get-shit-done.git get-shit-done
git clone --depth 1 https://github.com/scoobynko/claude-code-design-skills.git claude-code-design-skills
```

### REPOS CONSIDERED BUT NOT INCLUDED (and why)

| Repo | Why Excluded |
|------|-------------|
| wshobson/agents | Massive (112 agents, 72 plugins). We extracted the database patterns we need into our own reference files. Too heavy to fork whole. |
| alirezarezvani/claude-skills | 192 skills. We took what we needed (database-designer patterns). Too broad to fork whole. |
| affaan-m/everything-claude-code | We extracted database-migrations and postgres-patterns into our reference files. The rest is redundant with our skills. |
| superyhee/claude-ui-copilot | Decent but abi/screenshot-to-code is more mature and widely used. |
| arinspunk/claude-talk-to-figma-mcp | Only needed if you don't have Figma Dev Mode. Official Figma MCP covers most needs. Keep as bookmark. |
| wondelai/skills | 25 UX skills from books. Interesting but mastepanoski covers the same ground with better structure. Bookmark, don't fork. |
| ehmo/platform-design-skills | 300+ design rules. Useful reference but ui-ux-pro-max-skill covers this with a searchable database. Bookmark. |

---

## INSTALL SCRIPT

Create this at the root of your master repo. When starting a new project, run it to copy everything in:

```bash
#!/bin/bash
# install.sh — Copy skills and commands into a project
# Usage: ./install.sh /path/to/your-project

PROJECT_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing skills and commands into: $PROJECT_DIR"

# Create directories
mkdir -p "$PROJECT_DIR/.claude/commands"
mkdir -p "$PROJECT_DIR/.claude/skills/feature-census/references"
mkdir -p "$PROJECT_DIR/.claude/skills/db-architect/references"
mkdir -p "$PROJECT_DIR/.claude/skills/design-rules"

# Copy commands
cp "$SCRIPT_DIR/commands/planning/"*.md "$PROJECT_DIR/.claude/commands/"
cp "$SCRIPT_DIR/commands/competition/"*.md "$PROJECT_DIR/.claude/commands/"
cp "$SCRIPT_DIR/commands/design/"*.md "$PROJECT_DIR/.claude/commands/"
cp "$SCRIPT_DIR/commands/database/"*.md "$PROJECT_DIR/.claude/commands/"
cp "$SCRIPT_DIR/commands/testing/"*.md "$PROJECT_DIR/.claude/commands/"

# Copy skills
cp -r "$SCRIPT_DIR/skills/feature-census" "$PROJECT_DIR/.claude/skills/"
cp -r "$SCRIPT_DIR/skills/db-architect" "$PROJECT_DIR/.claude/skills/"
cp -r "$SCRIPT_DIR/skills/design-rules" "$PROJECT_DIR/.claude/skills/"
cp "$SCRIPT_DIR/skills/verification-before-completion.md" "$PROJECT_DIR/.claude/skills/"

echo ""
echo "✅ Installed:"
echo "   Commands: $(find $PROJECT_DIR/.claude/commands -name '*.md' | wc -l) files"
echo "   Skills: $(find $PROJECT_DIR/.claude/skills -name '*.md' | wc -l) files"
echo ""
echo "Next steps:"
echo "   1. Install plugins: claude plugin add anthropic/frontend-design"
echo "   2. Install MCPs: claude mcp add --transport http figma https://mcp.figma.com/mcp"
echo "   3. Install GSD: npx get-shit-done-cc@latest"
echo "   4. See README.md for full setup guide"
```

---

## YOUR COMPLETE WORKFLOW (Final Version)

```
PHASE 0:  CAPTURE          → /capture-planning
PHASE 1:  COMPETE           → /compete-research (competitors + inspirations)
PHASE 2:  GRILL             → /grill-me (stress-test the idea)
PHASE 3:  UX BRIEF          → /ux-brief (all questions upfront, bulk brain dump)
PHASE 4:  UI BRIEF          → /ui-brief (visual language from inspiration DNA)
PHASE 5:  LANGUAGE           → /ubiquitous-language
PHASE 6:  PRD                → /write-a-prd (informed by competition + UX + UI)
PHASE 7:  DATABASE           → /data-grill → /db-architect
PHASE 8:  DESIGN             → Figma (wireframes from UX brief + UI brief)
PHASE 9:  CODE FROM DESIGN   → Figma MCP / figma-to-react (pixel-perfect React)
PHASE 10: MILESTONE          → /prd-to-gsd
PHASE 11: BUILD              → /gsd:discuss → /gsd:plan → /gsd:execute
PHASE 12: DESIGN REVIEW      → UX audit (Nielsen heuristics, WCAG)
PHASE 13: VERIFY             → /anneal-check --gate
PHASE 14: CROSS-CHECK        → /verify-with-codex
PHASE 15: QA                 → /qa (human walks through)
PHASE 16: DOCUMENT           → /feature-census → /census-to-specs
PHASE 17: TEST & HARDEN      → /harden (full pipeline)
PHASE 18: NEXT               → /where-am-i → next milestone
```

## TOTAL INVENTORY

| Category | Custom Built | Vendor Repos | Installed Plugins/MCPs |
|----------|:-:|:-:|:-:|
| Planning & Workflow | 6 commands + 1 skill | 2 repos (superpowers, GSD) | 1 (GSD) |
| Competition & Research | 1 command | — | — |
| UX/UI Design | 2 commands + 1 reference | 5 repos | 4 (Figma MCP, Playwright, frontend-design, ui-ux-pro-max) |
| Database | 1 command + 1 skill (4 refs) | 2 repos | 2 (pg-aiguide, supabase) |
| Testing & QA | 4 commands + 1 skill (1 ref) | — | 1 (Playwright) |
| **Total** | **14 commands + 3 skills + 6 refs** | **9 repos** | **8 installs** |
