# Capture Planning Session

Capture the decisions from a planning session (Claude.ai, ChatGPT, or verbal) into a durable artifact in the repo. Run this EVERY time you finish a planning conversation elsewhere.

Input: $ARGUMENTS (paste your planning session notes, decisions, or a summary of what was decided)

## Why This Exists

Planning sessions in Claude.ai or ChatGPT produce the richest artifacts — your intent, decisions, constraints, trade-offs, and the "why" behind every feature. But they disappear after use. This command captures them as files in the repo so every downstream agent can read them.

Adapted from runesleo's memory-flush principle: "Don't rely on user triggers — auto-save. User might close the window at any time."

## Process

### 1. Create the Decisions File

Generate a timestamped file:

```
.planning/decisions/YYYY-MM-DD-<topic-slug>.md
```

If `.planning/decisions/` does not exist, create it.

### 2. Structure the Content

Extract and organize the raw input into this structure:

```markdown
# Planning Session: [Topic]
**Date:** YYYY-MM-DD
**Source:** [Claude.ai / ChatGPT / verbal / other]
**Status:** captured

## Context
_What problem is being solved? What triggered this planning session?_

## Key Decisions Made
_For each decision: what was decided, why, and what alternatives were rejected._

1. **[Decision]** — [Rationale]. Rejected: [alternatives considered].
2. ...

## Open Questions
_Anything that was discussed but NOT resolved._

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

### 3. Quality Gate

Before saving, verify:
- [ ] At least 1 key decision captured (if none, ask user what was decided)
- [ ] No placeholder text ("TBD", "figure out later") without an entry in Open Questions
- [ ] Topic slug is descriptive (not "planning-1" — use "multi-domain-expansion" or "sidebar-customization")

### 4. Commit

```bash
git add .planning/decisions/YYYY-MM-DD-<topic-slug>.md
git commit -m "docs: capture planning decisions — <topic>"
```

### 5. Link to Downstream

After saving, tell the user:

> "Decisions captured in `.planning/decisions/<filename>`. When you're ready to build this, run `/prd-to-gsd` and reference this file. Or use `/grill-me` to stress-test these decisions first."

## Rules

- NEVER summarize away the raw notes — keep them in the file as a "Raw Notes" section
- NEVER invent decisions that weren't in the input — if the input is vague, ask the user
- Structure is more important than polish — a rough but complete capture beats a polished but lossy one
- One file per planning session topic — don't merge unrelated sessions
