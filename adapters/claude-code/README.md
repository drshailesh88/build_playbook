# Claude Code Adapter

This is the original adapter. It copies playbook commands and skills into ~/.claude/ for use as slash commands.

## Install

```bash
./install.sh
```

This copies:
- 18 playbook commands → ~/.claude/commands/playbook/
- 5 custom skills → ~/.claude/skills/
- 10 Matt Pocock skills → installed via npx

## Usage

All commands available as `/playbook:*` inside Claude Code:

```
/playbook:capture-planning
/playbook:compete-research
/playbook:ux-brief
/playbook:ui-brief
/playbook:data-grill
/playbook:infra-grill
/playbook:prd-to-gsd
/playbook:where-am-i
/playbook:harden
/playbook:security-audit
/playbook:anneal
/playbook:anneal-check
/playbook:census-to-specs
/playbook:spec-runner
/playbook:generate-feature-doc
/playbook:verify-with-codex
/playbook:commands
/playbook:guide
```

## What It Produces

All commands output to `.planning/` in your project directory. These files are plain markdown and can be read by GSD v2, Aider, or any other tool.
