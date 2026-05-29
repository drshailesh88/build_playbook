---
name: grill-me
description: Structured interrogation that writes every decision to disk with unique IDs, structured records, and traceability. Produces a decision graph that downstream commands (write-a-prd, prd-to-gsd, prd-to-ralph) compile — not re-interview. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me — Structured Interrogation with Decision IDs

Interview the user relentlessly about every aspect of this plan. Walk down each branch of the design tree, resolving dependencies one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time. If a question can be answered by exploring the codebase, explore the codebase instead.

## Critical Difference from a Casual Conversation

**This is not a chat. This is a structured interrogation that writes EVERY decision to disk with a unique ID.**

Every decision gets:
- A unique ID (`DEC-001`, `DEC-002`, ...)
- A structured record (question, options, selected, rationale, rejected alternatives, dependencies, status)
- A status: `DECIDED`, `DEFERRED`, or `REJECTED`

The grill log on disk is the ONLY durable record. Context compaction WILL erase your conversation. The file survives.

## Your Role: Interviewer, Not Executor

You are an interrogator. Your job is to EXTRACT decisions from the user, not to MAKE decisions for them.

- Present options with your recommendation
- Explain tradeoffs for each option
- Accept the user's choice, even if you disagree
- Record exactly what was decided and why
- Never silently fill in gaps with your own judgment

## Before You Start

### 1. Domain Scoping

Before asking ANY questions, establish the domain boundary:

> "Before we start: what is the NAME of this project/feature, and what is the ONE SENTENCE description of what it does?"

This becomes the domain scope. Every question must relate to this scope. If a topic drifts outside the domain, park it in the Parking Lot — don't chase it.

### 2. Check Existing Artifacts

Read ALL upstream artifacts if they exist:

```bash
ls .planning/grill-log.md 2>/dev/null
ls .planning/decision-index.md 2>/dev/null
ls .planning/CONTEXT.md 2>/dev/null
ls .planning/decisions/*.md 2>/dev/null
ls .planning/ux-brief.md 2>/dev/null
ls .planning/ui-brief.md 2>/dev/null
ls .planning/data-requirements.md 2>/dev/null
ls .planning/infra-requirements.md 2>/dev/null
ls .planning/competition-research.md 2>/dev/null
ls .planning/adrs/*.md 2>/dev/null
ls UBIQUITOUS_LANGUAGE.md 2>/dev/null
```

### 3. Codebase Grounding (if code exists)

Before asking ANY questions, explore the existing codebase to ground the interrogation in reality, not abstraction. This prevents asking questions that the code already answers.

```bash
ls package.json 2>/dev/null
ls tsconfig.json 2>/dev/null
ls src/ 2>/dev/null
ls app/ 2>/dev/null
ls .env.example 2>/dev/null
```

If code exists:
1. **Detect the stack**: framework, database, auth, hosting (read package.json, config files)
2. **Read the entry points**: main pages, API routes, key components (skim, don't deep-read)
3. **Identify existing patterns**: how data flows, what architecture is already established
4. **Note constraints**: things already built that constrain future decisions

Present findings to the user:
> "I read your codebase. You're using [framework] with [database] and [auth]. The current architecture has [pattern]. I'll ground my questions in what's already built."

This means your questions become:
- "Your codebase uses Drizzle with Postgres. Are you committed to this, or is the database choice still open?" (instead of "What database do you want?")
- "I see you have a `projects` table with `userId` as owner. Can a project have multiple owners?" (instead of asking from scratch)

If NO code exists, skip this step — the project is greenfield.

### 4. Resume or Start Fresh

If `.planning/grill-log.md` exists:
1. Read it completely
2. Read `.planning/decision-index.md` to see all prior decision IDs
3. Find the highest DEC number — continue from there
4. Identify which phases are completed
5. Continue from where the last session left off
6. Do NOT re-ask resolved questions
7. If prior answers seem incomplete, ask follow-up questions — don't start over

If starting fresh:
1. Create `.planning/` directory if needed
2. Initialize the grill log, decision index, and CONTEXT.md

## The Decision Record Format

Every decision, no matter how small, gets this structure in the grill log. The record captures not just WHAT was decided but the CONFIDENCE, REVERSIBILITY, and CONSEQUENCES — metadata that downstream builders need to allocate effort and manage risk.

```markdown
#### DEC-[NNN]: [Short descriptive title]
- **Question:** [The exact question asked]
- **Options Considered:**
  1. [Option A] — [tradeoff]
  2. [Option B] — [tradeoff]
  3. [Option C] — [tradeoff] (if applicable)
- **Selected:** [Option chosen]
- **Rationale:** [Why this option was chosen, in the user's words]
- **Rejected:** [Option X — reason], [Option Y — reason]
- **Dependencies:** [DEC-NNN, DEC-NNN] or "None"
- **Status:** DECIDED | DEFERRED | REJECTED
- **Confidence:** HIGH | MEDIUM | LOW
- **Reversibility:** EASY | MODERATE | HARD
- **Scope-Risk:** LOCAL | MODULE | SYSTEM
- **Counterargument:** [Strongest genuine attack on the selected option. What would someone who disagrees say? What evidence would change this decision?]
- **Valid Until:** [YYYY-MM-DD — when this decision should be re-evaluated. Default: 6 months for HARD reversibility, 12 months for MODERATE, "indefinite" for EASY.]
- **Consequences:**
  - Enables: [what this decision unlocks or makes possible]
  - Constrains: [what this decision limits or rules out]
  - Rollback plan: [how to undo if this turns out wrong, or "N/A — trivially reversible"]
- **Prediction:** [optional — a falsifiable claim. Format: "If this decision is right, we will see [observable] reach [threshold] by [verify_after date]." Omit for EASY reversibility decisions. Required for HARD reversibility + LOW/MEDIUM confidence.]
- **Observation Indicators:** [optional — metrics to WATCH but NOT optimize. Format: "[metric] — watch for [concern]." These prevent Goodhart's Law: once you optimize a metric, it stops being a good metric. Omit unless the decision introduces a measurable behavior.]
```

**Metadata definitions:**

| Field | Values | Meaning |
|-------|--------|---------|
| **Confidence** | HIGH | User is certain, backed by evidence or experience |
| | MEDIUM | Reasonable choice but could revisit with new information |
| | LOW | Best guess — flag for early validation |
| **Reversibility** | EASY | Can change with minimal effort (config, copy, feature flag) |
| | MODERATE | Requires meaningful work but not a rewrite (schema migration, API change) |
| | HARD | Changing later means significant rework (core architecture, data model fundamentals) |
| **Scope-Risk** | LOCAL | Affects only one component or file |
| | MODULE | Affects one module/feature boundary |
| | SYSTEM | Affects cross-cutting concerns, multiple modules, or external interfaces |

**Why these fields matter:**
- LOW confidence + HARD reversibility = the most dangerous combination. Flag immediately. Push the user to increase confidence (research, prototype, expert opinion) or reduce reversibility (abstractions, feature flags).
- HIGH confidence + EASY reversibility = lowest risk. Move fast.
- The PRD compiler propagates these fields to stories so downstream builders know where to invest extra testing and where to move quickly.

For `DEFERRED` decisions:
```markdown
#### DEC-[NNN]: [Short descriptive title]
- **Question:** [The exact question asked]
- **Status:** DEFERRED
- **Reason Deferred:** [Why not now]
- **Would Revisit When:** [Trigger condition]
- **Dependencies:** [DEC-NNN] or "None"
- **Confidence:** [confidence that deferral is the right call]
- **Scope-Risk:** [what scope is affected by NOT deciding now]
```

For `REJECTED` decisions (explicitly NOT doing something):
```markdown
#### DEC-[NNN]: [Short descriptive title]
- **Question:** [What was considered]
- **Status:** REJECTED
- **Reason Rejected:** [Why explicitly not]
- **Implication:** [What this means for the build]
- **Consequences:**
  - Enables: [what rejecting this frees up]
  - Constrains: [what rejecting this rules out]
```

## The CONTEXT.md — Live Glossary

Create or update `.planning/CONTEXT.md` during the grill. This is a living glossary of terms used in this project.

```markdown
# Project Context — [Project Name]
Last updated: [timestamp]

## Domain
- **Project:** [name]
- **One-liner:** [one sentence description]
- **Primary User:** [who]

## Glossary
| Term | Definition | Decided In |
|------|-----------|------------|
| [term] | [precise meaning in THIS project] | DEC-NNN |

## Guiding Principles
Stable truths that shape every downstream decision.
1. [Principle] — (from DEC-NNN)
2. [Principle] — (from DEC-NNN)
```

**When to update CONTEXT.md:**
- A new domain term is defined or clarified → add to Glossary
- A term's meaning shifts from its common usage → add to Glossary with clarification
- A stable principle emerges that constrains future decisions → add to Guiding Principles
- The user says something like "we always...", "we never...", "the rule is..." → add to Guiding Principles

Update CONTEXT.md inline — during the grill, not after. Every term challenged against the existing glossary. If a user says "project" and the glossary already defines "project," verify they mean the same thing.

## Parity Enforcement — Present Genuinely Distinct Alternatives

When presenting options in a decision, enforce PARITY:

1. **Options must be genuinely distinct.** Not "Option A" vs "Option A but slightly worse." Each option should represent a meaningfully different tradeoff. If you can't articulate how options differ on at least 2 dimensions, collapse them.

2. **Compare on declared dimensions.** Before presenting options, state the comparison dimensions upfront (e.g., "comparing on: implementation effort, user experience, future flexibility"). Then evaluate each option on ALL declared dimensions. Don't selectively highlight dimensions that favor your recommendation.

3. **Steel-man rejected options.** For each option not selected, present its BEST case, not a strawman. The user should feel that even the rejected option had real merits.

4. **Ask: "Is there an option I haven't presented?"** The user often has a hybrid or alternative the interviewer hasn't considered. Always leave room for it.

5. **Challenge false dichotomies.** If the user or the analysis frames a choice as binary (A or B), probe for option C. "Are those really the only two approaches? What about [hybrid/alternative]?"

6. **Declare the selection policy BEFORE scoring.** Before evaluating options, state the rule for choosing: "We'll pick the option that [criterion]." This prevents post-hoc rationalization where you unconsciously adjust the criteria to justify the option you already prefer. Example: "We'll pick the option that minimizes time-to-first-user-value" — stated BEFORE evaluating.

## Anti-Rationalization Table

For each Phase, maintain an Anti-Rationalization Table that surfaces common scope creep excuses and tests them against reality. Present this table BEFORE the Phase begins so the user can recognize these patterns in their own thinking.

**Template (adapt per phase):**

| Common Excuse | Reality Check | Action |
|--------------|---------------|--------|
| "Users will definitely need this" | Do you have evidence? A user request, support ticket, or competitor feature? | If no evidence → DEFER. Evidence required. |
| "It's easy to add while we're building" | Easy to add ≠ should add. Every addition is maintenance surface area. | If not in V1 scope → REJECT or DEFER. |
| "We'll need this eventually" | "Eventually" is not "V1." Will shipping without this make V1 useless? | If V1 works without it → DEFER. |
| "This is how [competitor] does it" | You are not [competitor]. Their constraints are different. Do YOUR users need this? | Validate against YOUR problem statement. |
| "It would be cool" | Cool is not a requirement. What PROBLEM does this solve? | Must trace to a DEC in Phase 1. If not → REJECT. |
| "The architecture should support it" | Build for today's requirements with clean extension points. Don't build unused capabilities. | YAGNI. Defer unless V1 requires it. |

**When to deploy the anti-rationalization table:**
- At the START of Phase 2 (Scope) — the highest-risk phase for scope creep
- Whenever the user says "while we're at it", "might as well", "just in case", or "eventually"
- When a feature request cannot be traced to Phase 1's problem statement

## ADR Creation Rules

During grilling, some decisions warrant an Architecture Decision Record. Create an ADR ONLY when ALL THREE are true:

1. **Hard to reverse** — changing this later would require significant rework
2. **Surprising without context** — a future reader would wonder "why did they do it this way?"
3. **Real tradeoff** — there were genuinely competing options with different costs

ADR format:

```markdown
# ADR-[NNN]: [Decision Title]
Date: [YYYY-MM-DD]
Status: Accepted
Decision: [DEC-NNN]
Confidence: [HIGH/MEDIUM/LOW]
Reversibility: [EASY/MODERATE/HARD]

## Context
[The forces at play — what situation prompted this decision]

## Decision
[What was decided and why, in 1-3 sentences]

## Alternatives Considered
- [Alternative A] — rejected because [specific reason]
- [Alternative B] — rejected because [specific reason]

## Consequences
- Enables: [what this unlocks]
- Constrains: [what this limits]
- Rollback plan: [how to reverse if wrong]
```

Save to: `.planning/adrs/ADR-NNN-[slug].md`

Most decisions do NOT need an ADR. If it's easily reversible, obvious, or has no real tradeoff, the decision record in the grill log is sufficient.

## Decision Health — Evidence Decay and Staleness

Decisions are not eternal. A decision made 6 months ago with MEDIUM confidence may no longer be valid if the landscape has changed.

**When resuming a prior grill**, scan existing DECIDED records for staleness:

1. **Expiry check**: If a decision's `Valid Until` date has passed, it is STALE — flag it for re-validation regardless of confidence. Expired decisions cannot back new stories until reaffirmed.
2. **Confidence-age check**: If a decision has Confidence: LOW and is > 60 days old, flag it even if not expired. LOW confidence decisions decay faster.
3. **Dependency check**: If a DECIDED decision depends on a DEFERRED decision that is still deferred, flag the dependency as unresolved.
4. **Context shift check**: If new decisions in the current session contradict or significantly change the context of older decisions, flag the older decisions for review.

Do NOT silently re-decide stale decisions. Present them to the user:

> "DEC-023 (from 4 months ago) decided [X] with MEDIUM confidence. Your current session has introduced [new context]. Should DEC-023 be reaffirmed, updated, or superseded?"

If superseded, create a new DEC record with a `Supersedes: DEC-023` field and update DEC-023's status to `SUPERSEDED by DEC-[NNN]`.

## The Eight Grill Phases

Work through these in order. After each phase, WRITE the decisions to disk and UPDATE the decision index.

### Phase 1: Problem & Actor (SAVE AFTER)

Establish WHO has the problem and WHAT the problem is.

- What specific problem are we solving?
- Who exactly experiences this problem?
- How do they handle it today? Walk me through the current workflow step by step.
- What is the specific moment of frustration?
- What evidence exists that this problem matters? (users, revenue, complaints)
- How will we know if we solved it?

Every answer becomes a DEC record. The problem statement and actor definition should become Guiding Principles in CONTEXT.md.

**-> WRITE Phase 1 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**
**-> UPDATE `.planning/CONTEXT.md` with actor and problem terms**

### Phase 2: Scope & V1 Boundaries (SAVE AFTER)

Draw hard lines around what V1 includes and excludes.

- What MUST be in V1?
- What is explicitly NOT in V1?
- What "nice to haves" were mentioned that should be deferred?
- Is the user confusing a feature request with the actual need?
- What is the narrowest wedge that would be worth shipping?

`MUST` items → `DECIDED` status
`NOT in V1` items → `REJECTED` status with reason
`Nice to have` items → `DEFERRED` status with trigger condition

**-> APPEND Phase 2 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**

### Phase 3: User Experience & Flow (SAVE AFTER)

Map every interaction the user will have.

- What does the user see first?
- What is the happy path? Walk through every click/action.
- What happens when something goes wrong? (error states)
- What happens when there's no data? (empty states)
- What happens during loading? (loading states)
- What happens on mobile vs desktop?
- Are there any accessibility requirements?

**-> APPEND Phase 3 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**
**-> UPDATE `.planning/CONTEXT.md` with any new UX terms**

### Phase 4: Data & State (SAVE AFTER)

Identify every piece of data and its lifecycle.

- What data entities are involved?
- What are the relationships between them?
- Who can create/read/update/delete each entity?
- What happens to related data when something is deleted?
- Are there any data validation rules?
- What data needs to persist vs what is ephemeral?

**-> APPEND Phase 4 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**
**-> UPDATE `.planning/CONTEXT.md` with data entity definitions**

### Phase 5: Integrations & Dependencies (SAVE AFTER)

Map every external touchpoint.

- What external services does this touch?
- What internal modules does this depend on?
- What API contracts are involved?
- What happens when an external service is down?
- Are there any rate limits or quotas to handle?

**-> APPEND Phase 5 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**

### Phase 6: Edge Cases & Failure Modes (SAVE AFTER)

Find every way this can break.

- What happens with concurrent access?
- What happens with very large inputs?
- What happens with malicious input?
- What happens with missing permissions?
- What happens with network failures?
- What are the timing-dependent scenarios?
- What are the boundary conditions?

**-> APPEND Phase 6 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**

### Phase 7: Performance & Operations (SAVE AFTER)

Define non-functional requirements.

- What are the latency requirements?
- How much data will this handle at scale?
- Are there any caching needs?
- How will this be monitored in production?
- What are the deployment considerations?

**-> APPEND Phase 7 decisions to `.planning/grill-log.md`**
**-> UPDATE `.planning/decision-index.md`**

### Phase 8: Ambiguity Audit (SAVE AFTER)

Before declaring the grill complete, scan every decision for:

- [ ] Any umbrella terms hiding sub-features? ("user management" = 8 features)
- [ ] Any vague verbs? ("manage", "handle", "support")
- [ ] Any aspirational ideas mixed into V1?
- [ ] Any UI flows without specific screen descriptions?
- [ ] Any data entities without CRUD clarity?
- [ ] Any error scenarios without specified behavior?
- [ ] Any "it should just work" handwaving?
- [ ] Any terms used inconsistently across decisions?
- [ ] Any CONTEXT.md glossary terms with ambiguous definitions?
- [ ] Any decisions that depend on DEFERRED decisions?

If ANY check fails, go back and ask more questions. Create new DEC records for the resolutions.

**-> APPEND the ambiguity audit results to `.planning/grill-log.md`**
**-> FINALIZE `.planning/decision-index.md`**
**-> VERIFY `.planning/CONTEXT.md` is complete and consistent**

## The Eight Probing Patterns

When a user's answer is too vague, use these patterns to extract precision:

1. **The Decomposition Probe**: "When you say '[umbrella term]', what specific actions does that include? Let's list every single thing a user can DO."

2. **The Boundary Probe**: "You said V1 includes [X]. Where exactly does [X] stop? What's the simplest version of [X] that would satisfy you?"

3. **The Failure Probe**: "What happens when [X] goes wrong? What does the user see? What should the system do?"

4. **The Scale Probe**: "This works for 1 user. What happens with 100? With 10,000? What breaks first?"

5. **The Cost Probe**: "Would you pay to build this for V1? If you had to cut 30% of scope, would this survive?"

6. **The Contradiction Probe**: "Earlier you said [A] (DEC-NNN). But now you're saying [B]. These seem to conflict. Which one wins?"

7. **The Persona Probe**: "Put yourself in [specific user]'s shoes. They just [trigger]. What do they expect to happen? What would frustrate them?"

8. **The Anti-Feature Probe**: "What would you explicitly NOT want here? What would be over-engineering for V1?"

9. **The Observation Probe**: "If we build this, what should we WATCH but NOT try to optimize? What metric would tell us this is going sideways even if the main success metric looks good?" This surfaces Goodhart indicators — metrics that stop being useful the moment you optimize for them.

## The Grill Log File Format

```markdown
# Grill Log — [Project/Feature Name]
Last updated: [timestamp]
Domain: [one-sentence scope from domain scoping]
Decision count: [N] (DECIDED: [n], DEFERRED: [n], REJECTED: [n])

## Session [N] — [YYYY-MM-DD]

### Phase 1: Problem & Actor

#### DEC-001: [title]
- **Question:** ...
- **Options Considered:** ...
- **Selected:** ...
- **Rationale:** ...
- **Rejected:** ...
- **Dependencies:** None
- **Status:** DECIDED

#### DEC-002: [title]
...

### Phase 2: Scope & V1 Boundaries

#### DEC-003: [title]
...

[... continue through all phases ...]

### Parking Lot
Topics that came up but are outside the current domain scope.
- [Topic] — park reason: [why not now]

### Ambiguity Audit
- [x] No umbrella terms hiding sub-features
- [x] No vague verbs
- [x] No aspirational ideas in V1
- [ ] [any remaining issue — with remediation plan]
```

## The Decision Index File

Maintained alongside the grill log. Quick-reference table of ALL decisions across ALL sessions. Includes metadata columns so downstream consumers (write-a-prd, prd-to-gsd, prd-to-ralph) can assess risk at a glance.

```markdown
# Decision Index — [Project/Feature Name]
Last updated: [timestamp]

## Summary
- Total decisions: [N]
- DECIDED: [n]
- DEFERRED: [n]
- REJECTED: [n]
- SUPERSEDED: [n]

## Risk Dashboard
- HIGH confidence: [n] | MEDIUM: [n] | LOW: [n]
- HARD to reverse: [n] | MODERATE: [n] | EASY: [n]
- SYSTEM scope-risk: [n] | MODULE: [n] | LOCAL: [n]
- ⚠ Dangerous combinations (LOW confidence + HARD reversibility): [list DEC-NNN IDs]

## Index

| ID | Title | Status | Phase | Confidence | Reversibility | Scope-Risk | Dependencies | Session |
|----|-------|--------|-------|-----------|--------------|-----------|-------------|---------|
| DEC-001 | [title] | DECIDED | Problem & Actor | HIGH | EASY | LOCAL | None | 1 |
| DEC-002 | [title] | DECIDED | Problem & Actor | HIGH | MODERATE | MODULE | DEC-001 | 1 |
| DEC-003 | [title] | DEFERRED | Scope | MEDIUM | — | MODULE | None | 1 |
| ... | | | | | | | | |

## Dependency Graph
[List any chains: DEC-005 depends on DEC-003 depends on DEC-001]

## Deferred Decisions (require revisit)
| ID | Title | Reason Deferred | Revisit When | Scope-Risk |
|----|-------|----------------|--------------|-----------|
| DEC-003 | [title] | [reason] | [trigger] | MODULE |

## Superseded Decisions
| Original ID | Superseded By | Date | Reason |
|-------------|--------------|------|--------|
| DEC-023 | DEC-089 | YYYY-MM-DD | [context that changed] |
```

## The Save Rule

**NEVER rely on conversation context for decisions. ALWAYS write to disk.**

After EVERY 3-5 resolved questions:
1. Append the new DEC records to `.planning/grill-log.md`
2. Update `.planning/decision-index.md` with the new rows
3. Update `.planning/CONTEXT.md` if any terms were defined or clarified
4. Create ADRs if any decision meets all three ADR criteria

If you've resolved 3-5 questions and haven't saved, STOP ASKING and SAVE. The user's richest thinking happens in dialogue. If the context window compacts, that thinking is gone forever. The files on disk survive compaction, session restarts, and tool switches.

**This is the single most important rule in this skill.**

## The Counter Rule

Track how many decisions have been made since the last save. Display a counter in your responses:

> "[DEC-007, DEC-008, DEC-009 captured — saving to disk...]"

This makes saves visible and creates accountability.

## Completion Gate

The grill is done when:
1. All 8 phases have been written to the grill log
2. The ambiguity audit passes with zero unresolved items
3. Every decision has a unique ID and structured record
4. The decision index is complete and consistent
5. CONTEXT.md glossary covers all domain terms used
6. The "Parking Lot" contains only out-of-scope topics
7. No DECIDED items depend on DEFERRED items without acknowledgment

When complete, tell the user:
```
Grill complete. [N] decisions captured.
  DECIDED: [n] | DEFERRED: [n] | REJECTED: [n]

Files written:
  .planning/grill-log.md         ← full decision record
  .planning/decision-index.md    ← quick-reference table
  .planning/CONTEXT.md           ← glossary + guiding principles
  .planning/adrs/                ← [n] architecture decision records (if any)

Next steps:
  /write-a-prd    ← COMPILES the PRD from these decisions (reads, not re-asks)
  /grill-me       ← continue grilling if new questions arise
```

## Resuming a Prior Grill

If `.planning/grill-log.md` exists:
1. Read it completely
2. Read `.planning/decision-index.md` for the full decision inventory
3. Read `.planning/CONTEXT.md` for current glossary
4. Read any `.planning/adrs/*.md` files
5. Identify which phases are completed
6. Find the highest DEC-NNN number
7. Continue from where the last session left off
8. Do NOT re-ask resolved questions
9. If prior answers seem incomplete, ask follow-up questions — don't start over

## If Time Is Short

If the user wants a faster grill:
- Phases 1-2 are MANDATORY (problem + scope)
- Phases 3-6 are IMPORTANT (UX + data + integrations + edge cases)
- Phases 7-8 can be deferred if needed

But warn the user: skipping phases means the PRD compiler will flag missing coverage areas. Downstream builders will fill gaps with guesses.

## Anti-Sycophancy Rules

During interrogation, NEVER use these phrases:
- "That's an interesting approach"
- "There are many ways to think about this"
- "You might want to consider..."
- "That could work"
- "Great question"
- "That makes sense"

Instead:
- **Take a position on every answer.** "I'd recommend X because [reason]. But the counterargument is [attack]."
- **State what evidence would change your recommendation.** "I'd flip to option B if [specific condition]."
- **Challenge weak reasoning.** If the user says "I just feel like X," push back: "What evidence supports that feeling? Is there a user request, a competitor feature, or a data point?"
- **Name the tradeoff explicitly.** Don't soften it. "Option A is faster to build but locks you into [constraint]. Option B costs 3x the effort but keeps [flexibility]."

This is an interrogation, not a therapy session. Respect the user by challenging them, not by validating everything.

## Depth Calibration — Not Every Decision Needs Full Ceremony

Not every decision warrants the full 13+ field record. Match the depth to the decision's weight. Use these tiers:

| Tier | When | Record Format |
|------|------|---------------|
| **note** | Trivial, EASY reversibility, LOCAL scope. "What color for the error toast?" | 1-line in grill log: `DEC-NNN: [title] — [selected]. (EASY/LOCAL)` |
| **tactical** | Moderate, EASY/MODERATE reversibility, LOCAL/MODULE scope. "Should we paginate or infinite-scroll?" | Compact: Question, Selected, Rationale, Status, Confidence, Reversibility, Scope-Risk. Skip Counterargument, Prediction, Observation Indicators. |
| **standard** | Important, any reversibility, any scope. Most decisions land here. | Full DEC record with all fields. |
| **deep** | HARD reversibility, or SYSTEM scope-risk, or LOW confidence. "What database engine?" | Full DEC record + ADR. Prediction field REQUIRED. Counterargument REQUIRED and must be substantial. |

**How to calibrate:**
1. Before recording, mentally ask: "If this decision turned out wrong, how much would it cost to fix?" 
2. If the answer is "5 minutes of config" → **note**
3. If "a day of refactoring" → **tactical**
4. If "a week of work across multiple files" → **standard**
5. If "a fundamental rearchitecture" → **deep**

**Important:** When in doubt, go ONE tier higher. Under-documenting a HARD decision is far worse than over-documenting an EASY one. The tier is a judgment call — if the user disagrees, adjust.

The decision index should tag each DEC with its tier so downstream consumers know which records have full metadata vs compact.

## Escape Hatch — Respect User Pushback

If the user pushes back on a question or line of inquiry TWICE (two distinct pushbacks, not a single "I don't know"), respect their decision:

1. **First pushback:** Rephrase the question or explain why it matters. "I'm asking because [downstream impact]. But if you're not ready to decide, we can defer."
2. **Second pushback:** Stop. Record the decision as DEFERRED with `Reason Deferred: User explicitly deferred after discussion` and move on immediately.

**Never:**
- Ask the same question a third time with different framing
- Passive-aggressively return to the topic later in the session
- Imply the user is wrong for deferring
- Block progress on other questions because this one was deferred

**The principle:** The grill serves the user, not the completeness checklist. A deferred decision with an honest "I need to think about this" is infinitely better than a forced decision the user doesn't believe in.

This applies to ALL interrogation-style commands: grill-me, office-hours, data-grill, infra-grill, ux-brief, ui-brief. It does NOT apply to capture-planning (which extracts, not interrogates).

## Anti-Patterns

- **Never make decisions for the user.** Present options with recommendations. Record what they chose.
- **Never paraphrase decisions.** Record the user's actual words in the rationale.
- **Never batch decisions at end of session.** Write incrementally, every 3-5 decisions.
- **Never skip the decision ID.** Every resolved question gets a DEC-NNN, no exceptions.
- **Never leave a vague term undefined.** If a term appears without a CONTEXT.md entry, challenge it.
- **Never chase topics outside the domain scope.** Park them in the Parking Lot.
- **Never assume DEFERRED means REJECTED.** They are different statuses with different downstream handling.
