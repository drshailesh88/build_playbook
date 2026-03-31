# GSD v2 Adapter

Use your Build Playbook with GSD v2 for overnight autonomous building.

## Prerequisites

```bash
npm install -g gsd-pi@latest
gsd
/login    # connect your API key (GLM-5, DeepSeek, etc.)
```

## The Workflow

### DAYTIME — Thinking (Claude Code or any AI)

Run your playbook grilling sessions. These produce `.planning/` files:

```
/playbook:capture-planning     → .planning/decisions/
/playbook:compete-research     → .planning/competition-research.md
/playbook:ux-brief             → .planning/ux-brief.md
/playbook:ui-brief             → .planning/ui-brief.md
/playbook:data-grill           → .planning/data-requirements.md
/playbook:infra-grill          → .planning/infra-requirements.md
/playbook:prd-to-gsd           → .planning/REQUIREMENTS.md + ROADMAP.md + STATE.md
```

If you're NOT using Claude Code, you can run any grilling session manually:
1. Open `playbook/workflows/3-data-grill.md` in any AI chatbot
2. Tell the AI: "Follow these instructions and interview me"
3. Save the output to `.planning/data-requirements.md`

The questions and process work in ANY AI. The `.planning/` folder is the universal handoff.

### EVENING — Building (GSD v2)

```bash
cd your-project

# Option A: If you used /playbook:prd-to-gsd (has .planning/ files)
gsd
/gsd migrate              # converts .planning/ → .gsd/ format
/gsd auto                 # builds overnight

# Option B: If starting fresh in GSD
gsd
/gsd                      # guided mode — GSD interviews you
/gsd auto                 # builds overnight
```

### MORNING — Review (Claude Code or any AI)

```bash
# In Claude Code:
/playbook:where-am-i      # see what got built
/playbook:harden           # test everything
/playbook:security-audit   # check for issues

# Or without Claude Code:
git log --oneline -20      # see what GSD committed
cat .gsd/STATE.md          # see progress
```

## GSD v2 Preferences

Configure in `/gsd prefs`:

```yaml
models:
  research: glm-5          # or deepseek-chat for cheaper
  planning: glm-5
  execution: glm-5
  completion: glm-5
budget_ceiling: 10.00      # USD limit per session
```

## The .planning/ → .gsd/ Migration

GSD's `/gsd migrate` reads:
- `ROADMAP.md` phases → GSD slices
- `REQUIREMENTS.md` → GSD tasks
- `STATE.md` → GSD state
- Phase completion status is preserved
- Research files are consolidated

Run `/gsd migrate` once per project. After that, GSD manages `.gsd/` directly.
