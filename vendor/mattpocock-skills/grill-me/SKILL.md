---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Saves decisions to disk incrementally so nothing is lost to context compaction. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me — Structured Interrogation with Incremental Capture

Interview the user relentlessly about every aspect of this plan. Walk down each branch of the design tree, resolving dependencies one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time. If a question can be answered by exploring the codebase, explore the codebase instead.

## Critical Difference from a Casual Conversation

**This is not a chat. This is a structured interrogation that writes decisions to disk.**

After every 3-5 resolved questions, you MUST append the decisions to the grill log file on disk. This is non-negotiable. Context compaction will erase your conversation — the file on disk is the only durable record.

## Before You Start

1. Check if upstream artifacts exist and read them:
   - `.planning/decisions/*.md` (prior planning sessions)
   - `.planning/ux-brief.md`
   - `.planning/ui-brief.md`
   - `.planning/data-requirements.md`
   - `.planning/infra-requirements.md`
   - `.planning/competition-research.md`
   - `UBIQUITOUS_LANGUAGE.md`

2. Create the grill log file:
   ```
   .planning/grill-log.md
   ```

3. If a grill log already exists, read it first. You are CONTINUING a prior session, not starting fresh. Do not re-ask questions that are already answered in the log.

## The Grill Log File Format

```markdown
# Grill Log — [Feature/Project Name]
Last updated: [timestamp]

## Session [N] — [date]

### Problem & User
- **Problem:** [what we're solving]
- **Who:** [specific user persona]
- **Current workaround:** [how they handle this today]
- **Pain point:** [the specific moment of frustration]

### Scope Decisions
- **V1 includes:** [explicit list]
- **V1 excludes:** [explicit list]
- **Deferred:** [ideas discussed but not for V1]

### UX & Flow Decisions
- [decision 1]
- [decision 2]

### Data & Integration Decisions
- [decision 1]
- [decision 2]

### Edge Cases & Error Handling
- [decision 1]
- [decision 2]

### Open Questions
- [question still unresolved]

### Raw Notes
[verbatim notes from this session — never summarize these away]
```

## The Eight Grill Phases

Work through these in order. After each phase, WRITE the decisions to the grill log on disk.

### Phase 1: Problem & Actor (SAVE AFTER)
- What specific problem are we solving?
- Who exactly experiences this problem?
- How do they handle it today? Walk me through the current workflow step by step.
- What is the specific moment of frustration?
- What evidence exists that this problem matters? (users, revenue, complaints)
- How will we know if we solved it?

**→ WRITE Phase 1 decisions to `.planning/grill-log.md`**

### Phase 2: Scope & V1 Boundaries (SAVE AFTER)
- What MUST be in V1?
- What is explicitly NOT in V1?
- What "nice to haves" were mentioned that should be deferred?
- Is the user confusing a feature request with the actual need?
- What is the narrowest wedge that would be worth shipping?

**→ APPEND Phase 2 decisions to `.planning/grill-log.md`**

### Phase 3: User Experience & Flow (SAVE AFTER)
- What does the user see first?
- What is the happy path? Walk through every click/action.
- What happens when something goes wrong? (error states)
- What happens when there's no data? (empty states)
- What happens during loading? (loading states)
- What happens on mobile vs desktop?
- Are there any accessibility requirements?

**→ APPEND Phase 3 decisions to `.planning/grill-log.md`**

### Phase 4: Data & State (SAVE AFTER)
- What data entities are involved?
- What are the relationships between them?
- Who can create/read/update/delete each entity?
- What happens to related data when something is deleted?
- Are there any data validation rules?
- What data needs to persist vs what is ephemeral?

**→ APPEND Phase 4 decisions to `.planning/grill-log.md`**

### Phase 5: Integrations & Dependencies (SAVE AFTER)
- What external services does this touch?
- What internal modules does this depend on?
- What API contracts are involved?
- What happens when an external service is down?
- Are there any rate limits or quotas to handle?

**→ APPEND Phase 5 decisions to `.planning/grill-log.md`**

### Phase 6: Edge Cases & Failure Modes (SAVE AFTER)
- What happens with concurrent access?
- What happens with very large inputs?
- What happens with malicious input?
- What happens with missing permissions?
- What happens with network failures?
- What are the timing-dependent scenarios?
- What are the boundary conditions?

**→ APPEND Phase 6 decisions to `.planning/grill-log.md`**

### Phase 7: Performance & Operations (SAVE AFTER)
- What are the latency requirements?
- How much data will this handle at scale?
- Are there any caching needs?
- How will this be monitored in production?
- What are the deployment considerations?

**→ APPEND Phase 7 decisions to `.planning/grill-log.md`**

### Phase 8: Ambiguity Audit (SAVE AFTER)
Before declaring the grill complete, scan for:

- [ ] Any umbrella terms hiding sub-features? ("user management" = 8 features)
- [ ] Any vague verbs? ("manage", "handle", "support")
- [ ] Any aspirational ideas mixed into V1?
- [ ] Any UI flows without specific screen descriptions?
- [ ] Any data entities without CRUD clarity?
- [ ] Any error scenarios without specified behavior?
- [ ] Any "it should just work" handwaving?

If ANY box cannot be checked, go back and ask more questions. Do NOT proceed.

**→ APPEND the ambiguity audit results to `.planning/grill-log.md`**

## Completion Gate

The grill is done when:
1. All 8 phases have been written to the grill log
2. The ambiguity audit passes with zero unresolved items
3. The "Open Questions" section is either empty or contains only questions that require external research (not questions the founder could answer)

When complete, tell the user:
```
Grill complete. Decisions saved to .planning/grill-log.md

Next steps:
  /write-a-prd    ← generate the PRD (it will read the grill log)
  /grill-me       ← continue grilling if new questions arise
```

## The Save Rule

**NEVER rely on conversation context for decisions. ALWAYS write to disk.**

If you've resolved 3-5 questions and haven't saved, stop asking and save. The user's richest thinking happens in dialogue. If the context window compacts, that thinking is gone forever. The grill log file survives compaction, session restarts, and tool switches.

This is the single most important rule in this skill.

## Resuming a Prior Grill

If `.planning/grill-log.md` exists:
1. Read it completely
2. Identify which phases are already completed
3. Continue from where the last session left off
4. Do NOT re-ask resolved questions
5. If prior answers seem incomplete, ask follow-up questions — don't start over

## If Time Is Short

If the user wants a faster grill:
- Phases 1-2 are MANDATORY (problem + scope)
- Phases 3-6 are IMPORTANT (UX + data + integrations + edge cases)
- Phases 7-8 can be deferred if needed

But warn the user: skipping phases means the PRD will have gaps that downstream builders will fill with guesses.
