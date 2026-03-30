# ScholarSync — Development Workflow Reference

## The Full Journey: Idea → Shipped Feature

```
PHASE 0: CAPTURE        → /capture-planning
PHASE 1: GRILL          → /grill-me (Matt Pocock skill)
PHASE 2: LANGUAGE        → /ubiquitous-language (Matt Pocock skill)
PHASE 3: PRD             → /write-a-prd (Matt Pocock skill)
PHASE 4: MILESTONE       → /prd-to-gsd (bridges Matt → GSD)
PHASE 5: PER PHASE       → /gsd:discuss-phase → /gsd:plan-phase → /gsd:execute-phase
PHASE 6: VERIFY          → /anneal-check --gate (quality must hold)
PHASE 7: CROSS-CHECK     → /verify-with-codex (second model reviews)
PHASE 8: QA              → /qa (Matt Pocock skill — human walks through)
PHASE 9: DOCUMENT        → /generate-feature-doc (auto from GSD + code)
PHASE 10: NEXT           → /where-am-i → next milestone
          ↺ Loop 6-8 until clean
```

## When To Use Each Command

### Starting the day or returning after a break
```
/where-am-i
```
Reads GSD state, quality score, and git log. Tells you exactly where you are and what to do next. Takes 10 seconds.

### After a planning session in Claude.ai or ChatGPT
```
/capture-planning [paste your decisions]
```
Saves the decisions to a dated file in `.planning/decisions/`. Takes 2 minutes. Prevents losing your richest thinking.

### Before building a feature (deep planning)
```
/grill-me          → stress-test the idea
/ubiquitous-language → update shared vocabulary
/write-a-prd       → create the destination document
/prd-to-gsd        → create GSD milestone from the PRD
```

### Building the feature
```
/gsd:discuss-phase N   → flesh out implementation decisions
/gsd:plan-phase N      → create atomic task plans
/gsd:execute-phase N   → build with Ralph loop per task
/anneal-check --gate   → verify quality hasn't dropped
```

### After building
```
/verify-with-codex     → package work for second-model review
/qa                    → human walks through, files issues
/generate-feature-doc  → auto-generate testing doc from GSD + code
```

### Small tasks that don't need full ceremony
```
/gsd:quick "fix the broken RSS feeds"
/gsd:quick --research "add dark mode toggle"
/gsd:quick --discuss --full "refactor the search pipeline"
```

### Periodic maintenance
```
/improve-codebase-architecture   → find shallow modules (Matt Pocock)
/anneal-check                    → check quality score trend
```

## Skill Origin Map

| Skill | Source | Adapted From |
|-------|--------|-------------|
| `/capture-planning` | Custom | runesleo memory-flush + session-end |
| `/prd-to-gsd` | Custom | GSD new-milestone + Superpowers hard-gate + Cole Medin PRP scoring |
| `/where-am-i` | Custom | GSD progress routing + runesleo memory pattern |
| `/anneal-check` | Custom | Superpowers verification-before-completion + Cole Medin validation loop |
| `/generate-feature-doc` | Custom | shinpr recipe-reverse-engineer + ScholarSync doc-feature AST pattern |
| `/verify-with-codex` | Custom | levnikolaevich 4-level quality gate + Superpowers two-stage review |
| `verification-before-completion` | Skill | Jesse Vincent Superpowers (direct adaptation) |
| `/grill-me` | Skill | Matt Pocock |
| `/ubiquitous-language` | Skill | Matt Pocock + DDD |
| `/write-a-prd` | Skill | Matt Pocock |
| `/tdd` | Skill | Matt Pocock |
| `/qa` | Skill | Matt Pocock |
| `/improve-codebase-architecture` | Skill | Matt Pocock |
| `/design-an-interface` | Skill | Matt Pocock |
| `/triage-issue` | Skill | Matt Pocock |
| `/git-guardrails` | Skill | Matt Pocock |
| `/gsd:*` | GSD v1 | TÂCHES (get-shit-done) |

## File System Layout

```
ScholarSync/
├── .claude/
│   ├── commands/                    # Explicitly invoked via /command-name
│   │   ├── capture-planning.md      # NEW — save planning session decisions
│   │   ├── prd-to-gsd.md            # NEW — bridge PRD → GSD milestone
│   │   ├── where-am-i.md            # NEW — resumption context
│   │   ├── anneal-check.md          # NEW — quality score check
│   │   ├── generate-feature-doc.md  # NEW — auto feature docs
│   │   ├── verify-with-codex.md     # NEW — multi-model review
│   │   ├── doc-feature.md           # EXISTING — AST-based feature extraction
│   │   ├── sr-grill.md              # EXISTING — SR module grilling
│   │   ├── sr-spec.md               # EXISTING — SR spec creation
│   │   └── sr-verify.md             # EXISTING — SR verification
│   ├── skills/                      # Auto-triggered based on description match
│   │   ├── verification-before-completion.md  # NEW — hard gate on completion claims
│   │   ├── grill-me.md              # EXISTING (Matt Pocock)
│   │   ├── write-a-prd.md           # EXISTING (Matt Pocock)
│   │   ├── tdd.md                   # EXISTING (Matt Pocock)
│   │   ├── qa.md                    # EXISTING (Matt Pocock)
│   │   └── ... (6 more Matt Pocock skills)
│   └── commands/gsd/                # GSD v1 commands (installed via npx)
│       ├── new-milestone.md
│       ├── discuss-phase.md
│       ├── plan-phase.md
│       ├── execute-phase.md
│       ├── progress.md
│       ├── quick.md
│       └── ... (50+ GSD commands)
├── .planning/                       # GSD state directory
│   ├── PROJECT.md                   # What the project is
│   ├── REQUIREMENTS.md              # Current milestone requirements
│   ├── ROADMAP.md                   # Phase structure with checkboxes
│   ├── STATE.md                     # Current status at a glance
│   ├── decisions/                   # Captured planning sessions
│   │   └── YYYY-MM-DD-topic.md
│   ├── reviews/                     # Cross-verification review packages
│   │   └── review-YYYY-MM-DD.md
│   ├── codebase/                    # From /gsd:map-codebase
│   ├── phases/                      # Per-phase plans and summaries
│   └── quick/                       # Quick task plans
├── quality-score.mjs                # Annealing scorer (18 dimensions)
├── quality-score.json               # Current scores
├── annealing-log.jsonl              # Score history
├── *_FEATURES_TESTING.md            # Feature docs (20 modules)
└── UBIQUITOUS_LANGUAGE.md           # Shared vocabulary
```

## Key Principles

### From Geoffrey Huntley (Ralph Wiggum)
- Sit ON the loop, not IN it
- Context is everything — keep orchestrator lean, give subagents fresh windows
- Steer upstream (specs/code patterns) and downstream (tests/validation)
- Backpressure (tests, lints, annealing) rejects invalid work automatically

### From Matt Pocock
- Skills don't have to be long — just well-worded at the right time
- Deep modules: small interface, large implementation
- Durable issues: no file paths, describe behaviors
- TDD: one RED→GREEN at a time, never horizontal

### From Jesse Vincent (Superpowers)
- HARD-GATE: no execution until design is approved
- Verification before completion: evidence before claims, always
- Two-stage review: spec compliance first, then code quality
- Subagent per task: fresh context, no pollution

### From TÂCHES (GSD)
- State lives on disk: `.planning/` survives between sessions
- One milestone at a time: define → build → ship → next
- Discuss before plan, plan before execute
- Quick mode for small tasks that don't need ceremony

### From Cole Medin (Context Engineering)
- Confidence scoring: rate the plan before executing it
- Validation loops: syntax → unit → integration
- ULTRATHINK before execution on complex tasks
- Self-evolving system: errors should improve the rules

### From runesleo
- Auto-save on every task completion — don't rely on user triggers
- SSOT: one canonical location for each type of info
- Sunday optimization rule: ship on weekdays, tinker on Sundays
