# Capture Planning Session

Capture the decisions from a planning session (Claude.ai, ChatGPT, or verbal) into a durable artifact in the repo. Run this EVERY time you finish a planning conversation elsewhere.

Input: $ARGUMENTS (paste your planning session notes, decisions, or a summary of what was decided)

## Why This Exists

Planning sessions in Claude.ai or ChatGPT produce the richest artifacts — your intent, decisions, constraints, trade-offs, and the "why" behind every feature. But they disappear after use. This command captures them as files in the repo so every downstream agent can read them.

Adapted from runesleo's memory-flush principle: "Don't rely on user triggers — auto-save. User might close the window at any time."

## Process

### 0. Load Decision Context

Check existing decision artifacts to continue numbering:
```bash
ls .planning/decision-index.md 2>/dev/null
ls .planning/CONTEXT.md 2>/dev/null
ls .planning/grill-log.md 2>/dev/null
```

If a decision index exists, find the highest DEC-NNN number and continue from there.

### 1. Create the Decisions File

Generate a timestamped file:

```
.planning/decisions/YYYY-MM-DD-<topic-slug>.md
```

If `.planning/decisions/` does not exist, create it.

### 2. Structure the Content

Extract and organize the raw input. **Every decision gets a DEC-NNN ID.**

```markdown
# Planning Session: [Topic]
**Date:** YYYY-MM-DD
**Source:** [Claude.ai / ChatGPT / verbal / other]
**Status:** captured
**Decision range:** DEC-[start] to DEC-[end]

## Context
_What problem is being solved? What triggered this planning session?_

## Decisions

#### DEC-[NNN]: [Short title]
- **Question:** [What was being decided]
- **Options Considered:**
  1. [Option A] — [tradeoff]
  2. [Option B] — [tradeoff]
- **Selected:** [What was decided]
- **Rationale:** [Why]
- **Rejected:** [Alternatives not chosen, with reasons]
- **Dependencies:** [DEC-NNN] or "None"
- **Status:** DECIDED | DEFERRED | REJECTED
- **Confidence:** HIGH | MEDIUM | LOW
- **Reversibility:** EASY | MODERATE | HARD
- **Scope-Risk:** LOCAL | MODULE | SYSTEM
- **Counterargument:** [Strongest genuine attack on the selected option. What evidence would change this?]
- **Valid Until:** [YYYY-MM-DD — 6 months for HARD, 12 months for MODERATE, "indefinite" for EASY]
- **Consequences:**
  - Enables: [what this unlocks]
  - Constrains: [what this limits]
  - Rollback plan: [how to undo, or "N/A"]
- **Prediction:** [optional — "If this is right, we will see [observable] reach [threshold] by [verify_after date]." Required for HARD reversibility + LOW/MEDIUM confidence.]
- **Observation Indicators:** [optional — "[metric] — watch for [concern]." Metrics to WATCH but NOT optimize.]

[Repeat for each decision extracted from the planning session]

## Open Questions
_Anything that was discussed but NOT resolved. Each could become a DEC in a future session._

- [ ] ...

## Constraints & Requirements
_Non-negotiable requirements that came up during the session._

- ...

## Next Steps
_What should happen next based on these decisions?_

- ...

## Raw Notes
_Paste of the original planning session content, preserved for reference._
```

### 3. Update Decision Artifacts

After creating the session file:

1. **Append DEC records** to `.planning/grill-log.md` (under a "Captured Planning Session" heading)
2. **Update `.planning/decision-index.md`** with all new DEC rows
3. **Update `.planning/CONTEXT.md`** with any new terms defined in the session

### 4. Quality Gate

Before saving, verify:
- [ ] At least 1 key decision captured with a DEC-NNN ID
- [ ] Every DEC record has Confidence, Reversibility, and Scope-Risk fields filled
- [ ] Every DEC record has a Consequences section (Enables, Constrains, Rollback plan)
- [ ] No placeholder text ("TBD", "figure out later") without an entry in Open Questions
- [ ] Topic slug is descriptive (not "planning-1" — use "multi-domain-expansion" or "sidebar-customization")
- [ ] Decision index is updated with new DEC rows including metadata columns
- [ ] Any LOW confidence + HARD reversibility combinations are flagged

### 5. Commit

```bash
git add .planning/decisions/YYYY-MM-DD-<topic-slug>.md .planning/decision-index.md .planning/grill-log.md .planning/CONTEXT.md
git commit -m "docs: capture planning decisions with DEC-NNN IDs — <topic>"
```

### 6. Link to Downstream

After saving, tell the user:

> "Decisions captured in `.planning/decisions/<filename>`. [N] decisions (DEC-[start] to DEC-[end]).
> Decision index updated. `/write-a-prd` will compile these into the PRD.
> Or use `/grill-me` to stress-test these decisions first."

## Superseding Prior Decisions

If an extracted decision contradicts or replaces a prior decision from an earlier session:
1. Create the new DEC record as normal
2. Add `Supersedes: DEC-[old ID]` to the new record
3. Update the old DEC's status to `SUPERSEDED by DEC-[new ID]` in the grill-log
4. Update the decision-index Superseded Decisions table

## The Save Rule

If extracting more than 10 decisions from a large planning paste, save incrementally:
1. Extract and write the first batch of DEC records to `.planning/grill-log.md`
2. Update `.planning/decision-index.md` with the new rows (include Confidence, Reversibility, Scope-Risk)
3. Continue extracting the next batch
4. Repeat until all decisions are captured

Do NOT hold all decisions in context and write at the end. Large planning sessions can produce 30+ decisions — save as you go.

## The Counter Rule

Display progress as decisions are extracted:
> "[DEC-101 through DEC-108 extracted — saving to disk...]"

## Rules

- NEVER summarize away the raw notes — keep them in the file as a "Raw Notes" section
- NEVER invent decisions that weren't in the input — if the input is vague, ask the user
- Structure is more important than polish — a rough but complete capture beats a polished but lossy one
- One file per planning session topic — don't merge unrelated sessions
