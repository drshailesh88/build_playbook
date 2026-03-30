# PRD to GSD Milestone

Bridge a PRD (from grill-me + write-a-prd) into a GSD milestone. Skips GSD's redundant questioning because the PRD already captured your decisions.

Input: $ARGUMENTS (path to PRD file, GitHub issue number, or "latest" to use most recent .planning/decisions/ file)

## Why This Exists

Matt Pocock's workflow produces a PRD (destination document). GSD's `/gsd:new-milestone` produces REQUIREMENTS.md and ROADMAP.md (journey documents). Without this bridge, you'd repeat the same planning conversation twice. This command feeds the PRD directly into GSD's milestone structure, asking only the questions the PRD didn't answer.

Adapted from:
- GSD new-milestone command (questioning → requirements → roadmap flow)
- Jesse Vincent's brainstorming HARD-GATE (readiness checklist before execution)
- Cole Medin's PRP confidence scoring (rate the plan's completeness)

## Process

### 1. Load the PRD

Resolve the input:
- If a file path: read it directly
- If a GitHub issue number: `gh issue view $ARGUMENTS --json body -q '.body'`
- If "latest": find the most recent file in `.planning/decisions/`
- If no argument: check for open GitHub issues with "PRD" in the title, list them

Also load existing context:
- `.planning/PROJECT.md` (if exists — brownfield project)
- `.planning/codebase/` (if `/gsd:map-codebase` was run)
- `UBIQUITOUS_LANGUAGE.md` (if exists)
- `docs/multi-domain/MASTER_CONTEXT.md` or `docs/handover-context.md` (if exists)

### 2. Readiness Gate

<HARD-GATE>
Do NOT create GSD milestone files until the PRD passes this readiness checklist. A PRD that fails this gate needs more grilling, not more planning.
</HARD-GATE>

Score the PRD on these dimensions (1-10 each):

| Dimension | What to check | Minimum |
|-----------|--------------|---------|
| **Problem clarity** | Is the problem statement specific and testable? | 7 |
| **User stories** | Are there at least 5 concrete user stories? | 6 |
| **Scope boundaries** | Is "out of scope" explicitly defined? | 6 |
| **Decision completeness** | Are implementation decisions made, not deferred? | 5 |
| **Testability** | Can acceptance criteria be verified by a human in a browser? | 7 |

Calculate average. Report the score.

- **Average ≥ 6**: Proceed to milestone creation
- **Average 4-6**: List the weak dimensions. Ask user: "These areas need more detail. Want to grill on them now, or proceed with what we have?"
- **Average < 4**: Stop. "This PRD isn't ready for implementation. Run `/grill-me` to flesh out: [list weak areas]."

### 3. Extract Requirements

From the PRD, extract and write `.planning/REQUIREMENTS.md`:

```markdown
# Requirements — [Milestone Name]

## Version
v[next milestone number] — [milestone name from PRD]

## Must Have (v1)
_Extracted from PRD user stories and acceptance criteria_
- [ ] [Requirement in behavior language, not code language]
- [ ] ...

## Should Have (v1.1)
_From PRD "nice to have" or "stretch goals" sections_
- [ ] ...

## Out of Scope
_Directly from PRD "out of scope" section_
- ...

## Source
PRD: [path or issue number]
Planning decisions: [path to .planning/decisions/ file if exists]
```

Rules for extraction (adapted from GSD templates):
- Requirements describe BEHAVIOR, not implementation ("Users can search across all 15 domains" not "Add domain parameter to search API")
- Each requirement must be independently testable
- Use the project's ubiquitous language (check UBIQUITOUS_LANGUAGE.md)

### 4. Generate Roadmap

Create `.planning/ROADMAP.md` from the requirements:

```markdown
# Roadmap — [Milestone Name]

## Phases

- [ ] Phase N: [Phase title — one clear deliverable]
  - [Which requirements this addresses]
  - Risk: [LOW/MEDIUM/HIGH]
  
- [ ] Phase N+1: [Next phase]
  ...
```

Roadmap rules (adapted from GSD roadmapper):
- Each phase is ONE demoable deliverable (not "all database work" — that's a horizontal slab)
- First phase should be the tracer bullet — thinnest end-to-end slice that proves the architecture
- Order by: dependencies first, then risk (high-risk early to fail fast)
- If continuing from a previous milestone, continue phase numbering
- 4-8 phases per milestone (fewer = phases too big, more = too granular)

### 5. Update State

Update `.planning/STATE.md`:

```markdown
# Project State

## Current Milestone
**[Milestone Name]** — Created [date]

## Current Phase
Phase N: [title] — Status: NOT STARTED

## Source Documents
- PRD: [path]
- Requirements: .planning/REQUIREMENTS.md
- Roadmap: .planning/ROADMAP.md

## Quick Reference
- Next action: `/gsd:discuss-phase N` or `/gsd:plan-phase N`
```

Also update `.planning/PROJECT.md` if it exists (append new milestone goals).

### 6. Commit

```bash
git add .planning/REQUIREMENTS.md .planning/ROADMAP.md .planning/STATE.md
git add .planning/PROJECT.md 2>/dev/null
git commit -m "milestone: [name] — requirements and roadmap from PRD"
```

### 7. Next Steps

Tell the user:

> "Milestone '[name]' created with [N] phases and [M] requirements.
> 
> **Readiness score: [X]/10**
> 
> Next steps:
> - `/gsd:discuss-phase [N]` — flesh out implementation decisions for Phase [N]
> - `/gsd:plan-phase [N]` — skip discussion, go straight to planning (if decisions are clear)
> - `/gsd:quick '[task]'` — do a small task that doesn't need full ceremony"

## Rules

- NEVER skip the readiness gate — it prevents half-baked plans from reaching execution
- NEVER invent requirements not in the PRD — if something is missing, flag it, don't fill it
- ALWAYS use vertical slices for phases, not horizontal layers
- If PRD was a GitHub issue, reference it in REQUIREMENTS.md (traceability)
- If `.planning/decisions/` files exist for this topic, cross-reference them too
