---
name: write-a-prd
description: COMPILE a production-grade PRD from decision artifacts on disk. Reads grill logs, decision indexes, and context files — does NOT re-interview. Every claim traces to a decision ID. Untraced claims are flagged as assumptions. Use when the user wants a PRD that will feed downstream AI builders such as /playbook:prd-to-gsd and /playbook:prd-to-ralph.
---

# Write a PRD — The Decision Compiler

This skill COMPILES a PRD from decision artifacts already on disk. It is NOT a fresh interview.

The grill commands (`/grill-me`, `/playbook:office-hours`, `/playbook:data-grill`, `/playbook:ux-brief`, `/playbook:ui-brief`, `/playbook:infra-grill`) produce decision records with unique IDs. This command reads those records and assembles them into a build contract.

## Core Principle: Compiler, Not Interviewer

The PRD step reads decision artifacts and finds gaps/conflicts. It does not conduct a new interview from scratch.

Every claim in the PRD MUST trace to a decision ID (DEC-NNN). If a claim cannot be traced:
- It is flagged as `[ASSUMPTION]`
- The user is asked to confirm or reject it
- If confirmed, it gets a new DEC-NNN ID and is appended to the grill log
- If rejected, it is removed

**A PRD with untraced claims is invalid, even if it is otherwise well-written.**

## Session Bridge Principle

The PRD must be SELF-CONTAINED. Any agent — human or AI — must be able to read this PRD cold, in a fresh session with zero prior context, and understand EVERYTHING needed to build correctly.

This means:
- **No implicit knowledge.** Every term is defined in the glossary. Every constraint is stated explicitly.
- **No "as discussed" references.** The discussion happened in the grill. The PRD captures the OUTPUT of that discussion with full context.
- **No ambient context dependency.** The PRD does not rely on what was "in the conversation" or "obvious from the codebase." If it matters, it's in the document.
- **Complete decision trail.** A builder reading DEC-045 in a story can trace it to the grill log, read the full question-options-rationale chain, and understand WHY that choice was made.

Test: If you copied this PRD into a new Claude session with a brand-new agent that has never seen this project, could that agent build correctly from the PRD alone? If no, the PRD is incomplete.

## Scope Discipline — Vertical Slicing and Anti-Rationalization

Every story in the PRD must pass scope discipline checks:

**Rule 0.5: Touch ONLY what the task requires.**
- Each story is a VERTICAL SLICE through the system — one user-visible behavior from UI to database.
- No story should include "while we're at it" additions.
- No story should bundle unrelated behaviors because they touch the same file.
- If a story requires changes to 3 modules, that's fine — but it should be one user-visible behavior that happens to cross modules, not 3 separate behaviors packaged together.

**Anti-Rationalization Test for each BUILD story:**

| Check | Question | If fails |
|-------|----------|----------|
| Problem trace | Does this story trace to the problem statement in Phase 1? | If not → how does building this solve the stated problem? |
| Evidence backing | Is there a user need, data point, or competitive gap backing this? | If not → DEFER until evidence exists |
| V1 survival | Does V1 ship without this? | If yes → DEFER |
| Scope creep | Was this feature mentioned in Phase 2 scope, or did it appear later? | If appeared later → extra scrutiny, must trace to a DEC |
| Complexity budget | Does adding this story push the build past the time/effort estimate? | If yes → something else must be cut |

## Absolute Rules

- The prerequisite gate is MANDATORY. Never skip it.
- If upstream decision artifacts exist, read ALL of them completely. Never skim.
- Every buildable story MUST trace its acceptance criteria to decision IDs.
- Every claim without a decision ID is an ASSUMPTION and must be flagged.
- Never convert casual discussion into build requirements without explicit decision records.
- Never treat "nice to have", "later", "maybe", "eventually", or "would be cool" as V1 scope.
- Do not finalize the PRD until the Founder Verification Round is complete.
- Do not invent requirements not stated or approved by the user.
- DEFERRED decisions become Deferred Stories, never BUILD stories.
- REJECTED decisions become Explicit Non-Goals.

## Why This Matters

This PRD feeds downstream systems:

- `/playbook:prd-to-gsd`
- `/playbook:prd-to-ralph`
- `harden-completeness.sh`

Each approved buildable story may become a build unit in `prd.json`.

Stories without decision ID traceability, testable acceptance criteria, clear boundaries, and verification anchors will cause:
- hallucinated missing-feature audits
- over-building
- under-building
- false positives in completeness checks
- wasted build/QA loops

## Process

### 0. Prerequisite Gate — Check Decision Artifacts

Before ANYTHING else, check what decision artifacts exist and score readiness.

```bash
ls .planning/grill-log.md 2>/dev/null
ls .planning/decision-index.md 2>/dev/null
ls .planning/CONTEXT.md 2>/dev/null
ls .planning/decisions/*.md 2>/dev/null
ls .planning/adrs/*.md 2>/dev/null
ls .planning/ux-brief.md 2>/dev/null
ls .planning/ui-brief.md 2>/dev/null
ls .planning/data-requirements.md 2>/dev/null
ls .planning/infra-requirements.md 2>/dev/null
ls .planning/competition-research.md 2>/dev/null
ls UBIQUITOUS_LANGUAGE.md 2>/dev/null
ls docs/handover-context.md 2>/dev/null
```

**Artifact Readiness Scoring:**

| Artifact | Points | Status |
|----------|--------|--------|
| `.planning/grill-log.md` with decision IDs and ambiguity audit passed | 4 | Found / Missing |
| `.planning/decision-index.md` with DECIDED/DEFERRED/REJECTED counts | 2 | Found / Missing |
| `.planning/CONTEXT.md` with glossary | 1 | Found / Missing |
| `.planning/decisions/*.md` (at least 1 file) | 1 | Found / Missing |
| `.planning/ux-brief.md` | 1 | Found / Missing |
| `.planning/ui-brief.md` | 1 | Found / Missing |
| `.planning/data-requirements.md` | 1 | Found / Missing |
| `.planning/infra-requirements.md` | 1 | Found / Missing |
| `.planning/competition-research.md` | 1 | Found / Missing |
| `.planning/adrs/*.md` (architecture decisions) | 1 | Found / Missing |
| **Total** | **14** | |

**Gate rules:**
- **Score 10-14:** Proceed to PRD compilation. Read ALL found artifacts.
- **Score 6-9:** Warn the user that decision coverage is thin. Compilation will produce many `[ASSUMPTION]` flags. Recommend running `/grill-me` first. Proceed only if user explicitly confirms.
- **Score 0-5:** STOP. Do not write a PRD. Tell the user:
  ```
  Not enough decision artifacts to compile a reliable PRD.

  Missing decision records mean I would fill gaps with assumptions,
  which will cause bad builds downstream.

  The grill-to-PRD pipeline works like this:
    1. /grill-me              <- structured interrogation (writes DEC-NNN records)
    2. /playbook:ux-brief     <- UX requirements
    3. /playbook:data-grill   <- data requirements
    4. /write-a-prd           <- COMPILES from the above (you are here)

  Run the grilling commands first. They write decisions to disk.
  Then come back to /write-a-prd — it will read everything and compile.
  ```

**Integrity checks (run AFTER scoring):**

If score >= 10, verify artifact integrity before proceeding:

1. Parse `.planning/grill-log.md` — count DECIDED, DEFERRED, REJECTED
2. Parse `.planning/decision-index.md` — count rows
3. If counts don't match: STOP. "Decision index has [X] entries but
   grill log has [Y] decisions. Run `/grill-me` to reconcile."
4. If `.planning/next-dec-id` exists, verify its value equals
   highest DEC ID + 1. Mismatch means parallel corruption.
5. For each DEFERRED decision in the grill log, verify it exists in
   the index with status DEFERRED. Missing DEFERRED records are the
   most dangerous integrity failure — they become invisible to the PRD.
6. Check file freshness: if `grill-log.md` was modified more recently
   than `decision-index.md`, the index may be stale. Warn the user.

### 1. Load Decision Artifacts — Hot/Cold Strategy

Use a tiered loading strategy to manage token budget efficiently. Not everything needs to be loaded at full resolution upfront.

**Level 1 — HOT (always load completely, first):**
These are compact, high-signal files that inform every downstream operation.
- `.planning/CONTEXT.md` — domain glossary and guiding principles
- `.planning/decision-index.md` — the decision inventory with status, confidence, reversibility, scope-risk

**Level 2 — WARM (load for decision map and gap analysis):**
Read these completely to build the decision map and identify gaps.
- `.planning/grill-log.md` — the FULL grill transcript with all decision records
- `.planning/decisions/*.md` — every decision file, chronologically
- `.planning/adrs/*.md` — architecture decision records

**Level 3 — COLD (load per-section as needed during story compilation):**
These are detailed domain artifacts. Load the relevant one when compiling stories in that domain.
- `.planning/ux-brief.md` — load when compiling UX/flow stories
- `.planning/ui-brief.md` — load when compiling frontend/visual stories
- `.planning/data-requirements.md` — load when compiling data/schema stories
- `.planning/infra-requirements.md` — load when compiling deployment/operations stories
- `.planning/competition-research.md` — load when writing problem statement and positioning
- `UBIQUITOUS_LANGUAGE.md` — merge with CONTEXT.md glossary if both exist
- `docs/handover-context.md` — load if it exists

For brownfield projects, also:
1. Explore the repo to understand current behavior and constraints.
2. Identify what is already decided vs still ambiguous.

**After loading Level 1 + Level 2, report the inventory:**

```
Decision Artifact Inventory:
  HOT (loaded):
  - CONTEXT.md: [N] glossary terms, [N] guiding principles
  - decision-index.md: [N] decisions (DECIDED: [n], DEFERRED: [n], REJECTED: [n], SUPERSEDED: [n])

  WARM (loaded):
  - grill-log.md: [N] decision records across [N] sessions
  - adrs/: [N] architecture decision records
  - decisions/: [N] planning capture files

  COLD (available, will load per-section):
  - ux-brief.md: [found/missing]
  - ui-brief.md: [found/missing]
  - data-requirements.md: [found/missing]
  - infra-requirements.md: [found/missing]
  - competition-research.md: [found/missing]

  Risk Dashboard (from decision index):
  - ⚠ LOW confidence + HARD reversibility: [list DEC IDs or "none"]
  - SYSTEM scope-risk decisions: [list DEC IDs or "none"]

  Readiness score: [N]/12
```

### 2. Build the Decision Map

Before writing any PRD content, create an internal map of which decisions feed which stories.

For each DECIDED decision:
- What feature area does it belong to? (problem, scope, UX, data, integration, edge case, performance)
- Which other decisions does it depend on?
- Which other decisions depend on it?
- Does it define a buildable behavior or a constraint?

For each DEFERRED decision:
- Is it blocking any DECIDED decisions?
- Can it become a Deferred Story?

For each REJECTED decision:
- Does it need to become an Explicit Non-Goal to prevent downstream inference?

### 3. Gap Analysis — Find Missing Decisions

Compare the decision inventory against what a complete PRD needs:

**Required coverage areas:**
- [ ] Problem statement grounded in decisions
- [ ] Actor/persona defined
- [ ] V1 scope boundaries (in/out) defined
- [ ] Every feature has at least one DECIDED decision
- [ ] Error states addressed for each feature
- [ ] Empty states addressed for each feature
- [ ] Data entities and relationships decided
- [ ] Permissions and roles decided
- [ ] Performance expectations set

For each gap, either:
1. Find a decision that covers it (search the grill log more carefully)
2. Flag it as `[ASSUMPTION]` with your best guess
3. Ask the user to resolve it NOW (this is the only acceptable fresh grilling)

Report the gap analysis:
```
Gap Analysis:
  Coverage: [N]/[total] areas have decision backing
  Gaps found: [N]
    - [Gap 1]: No decision about [topic]. Will flag as [ASSUMPTION].
    - [Gap 2]: DEC-015 is DEFERRED but DEC-022 depends on it.

  New questions needed: [N]
```

If gaps require more than 5 new decisions, recommend running `/grill-me` again before proceeding.

### 4. Resolve Assumptions (Focused Grilling)

For each gap that cannot be traced to a decision:

1. Present it as a specific question with options
2. Record the answer as a new DEC-NNN
3. Append the new decision to `.planning/grill-log.md`
4. Update `.planning/decision-index.md`

This is targeted gap-filling, not a re-interview. Keep it to the minimum needed.

### 5. Compile Buildable Story Units

**Before compiling stories, load and map the COLD domain-specific files.**

When compiling stories that touch a specific domain, load the relevant file and apply these mapping rules:

**From `.planning/data-requirements.md`:**
- Each data subject's **Lifecycle rules** (created by, deletion behavior, history needed) → acceptance criteria on CRUD stories
- Each data subject's **Limits** (max per user, size limits, name rules) → testable acceptance criteria with specific numbers
- Each data subject's **Access levels** (owner/editor/viewer) → acceptance criteria on permission stories
- **Relationships table** (cascade-on-delete, orphan behavior) → explicit constraint notes on stories that touch related entities
- **Search & Filter fields** → acceptance criteria on list/search stories
- **Billing impact** → acceptance criteria on subscription/plan stories

**From `.planning/infra-requirements.md`:**
- **Response time expectations** → non-functional acceptance criteria (e.g., "page loads in under [N] seconds")
- **Reliability requirements** (downtime tolerance, monitoring need) → operational constraint in Implementation Decisions
- **Budget constraints** (monthly budget, payment preference) → Implementation Decisions constraint
- **File upload specs** (size limits, types) → acceptance criteria on upload stories
- **Scaling projections** (current users, 6-month, 2-year) → story sizing notes for downstream builders
- **Scheduled tasks** → dedicated stories or acceptance criteria

**From `.planning/ui-brief.md`:**
- **Typography, color palette, spacing** → design constraint notes on frontend stories
- **Component style** (button, input, icon choices) → design constraint notes
- **CSS variables template** → reference in Implementation Decisions (not story-level)
- **Motion specs** (transition speeds, loading states) → acceptance criteria on UX-heavy stories

**From `.planning/ux-brief.md`:**
- **Per-module decisions** (empty state, loading, feedback, error handling) → acceptance criteria on the corresponding module stories
- **Navigation pattern** → acceptance criteria on shell/layout stories
- **Content density and list behavior** → acceptance criteria on list/search stories

Convert DECIDED decisions into buildable stories. Each story must:

- Map to one or more DEC-NNN records
- Be independently understandable
- Be independently testable
- Be small enough for one downstream build unit or small cluster
- Be explicit about behavior AND exclusions

**Story compilation rules:**
- Group related decisions into coherent stories
- A story with 0 decision IDs is invalid — it's an invention
- A story with only DEFERRED decisions is not a BUILD story
- If a story's acceptance criteria can't be traced to decisions, flag each untraced criterion as `[ASSUMPTION: no DEC backing]`
- **Depth-aware compilation:** DECs tagged as **note** or **tactical** tier may have compact metadata. Do not flag missing fields (Counterargument, Prediction, Observation Indicators) on note/tactical DECs — those fields are only required at standard/deep tiers. When a story is backed by a mix of tiers, inherit risk metadata from the highest-tier DEC.

Do not write a single giant story like "Build the authentication system." Break large themes into concrete stories, each traceable to decisions.

### 6. Founder Verification Round

After compiling the stories, run a mandatory review with the founder or user.

For each story, ask the founder to mark exactly one:
- `BUILD`
- `DEFER`
- `REMOVE`

Also show:
- How many decision IDs back each story
- Any `[ASSUMPTION]` flags that need resolution

Rules:
- `BUILD`: eligible for downstream implementation
- `DEFER`: keep in PRD as deferred context, not part of the build queue
- `REMOVE`: remove from PRD entirely unless useful as explicit non-goal context

Do not finalize the PRD until this review is complete.

### 7. Cross-Reference Verification (MANDATORY)

Before finalizing, cross-reference the PRD against ALL decision artifacts to ensure nothing was dropped.

**For each upstream artifact:**

| Source | Check |
|--------|-------|
| `.planning/grill-log.md` | Every DECIDED decision is reflected in a PRD story, implementation decision, or explicit non-goal |
| `.planning/decision-index.md` | Every decision ID appears in the PRD's traceability section |
| `.planning/CONTEXT.md` | Every glossary term is used consistently in the PRD |
| `.planning/decisions/*.md` | Every planning decision is addressed |
| `.planning/adrs/*.md` | Every ADR is reflected in Implementation Decisions |
| `.planning/ux-brief.md` | Every UX requirement maps to a story or constraint |
| `.planning/ui-brief.md` | Every visual/component decision maps to a frontend story or design constraint |
| `.planning/data-requirements.md` | Every data entity is covered |
| `.planning/infra-requirements.md` | Every infrastructure requirement maps to an implementation decision or operational constraint |

**Procedure:**
1. Build the master decision set from the UNION of:
   - All DEC records in `.planning/grill-log.md`
   - All DEC records in `.planning/decisions/*.md`
   - All rows in `.planning/decision-index.md`
   If a DEC ID appears in one source but not another, flag it as an
   integrity error. Do NOT proceed until resolved.
2. For each DECIDED decision, find the corresponding PRD section
3. For each DEFERRED decision, verify it appears in Deferred Stories
4. For each REJECTED decision, verify it appears in Explicit Non-Goals
4b. For each DEFERRED decision in the master set, verify:
   - It appears in the Deferred Stories section of the PRD
   - If it has `Criticality: BLOCKING`, any BUILD story that depends on
     it (directly or transitively) must be flagged
   - BLOCKING deferrals without resolution block PRD finalization
5. If a decision has NO corresponding PRD entry, either:
   - Add a story for it
   - Add it to Implementation Decisions
   - Add it to Explicit Non-Goals (with reason)
6. Report the cross-reference results:

```
Cross-Reference Results:
  Total decisions in index: [N]
  DECIDED decisions: [n]
    -> Mapped to PRD stories: [n]
    -> Mapped to implementation decisions: [n]
    -> Mapped to constraints: [n]
  DEFERRED decisions: [n]
    -> In Deferred Stories section: [n]
  REJECTED decisions: [n]
    -> In Explicit Non-Goals section: [n]
  DROPPED (not in PRD): 0  <- this MUST be zero
  ASSUMPTIONS flagged: [n]  <- this should be minimized
```

7. Reverse check — extract ALL `DEC-NNN` references from the PRD text.
   For each:
   - The DEC ID must exist in the master decision set
   - The DEC status must be compatible with its location:
     - DECIDED DECs can appear in BUILD stories
     - DEFERRED DECs can appear in Deferred Stories only
     - REJECTED DECs can appear in Explicit Non-Goals only
     - SUPERSEDED DECs must NOT appear anywhere — only their
       replacements
   - The PRD location (e.g., 'Story S01, AC 3') must actually exist
   Flag any violations as blocking errors.

If any decision was DROPPED (exists in decision index but not in PRD), do NOT finalize. Ask the user what to do with each dropped item.

### 8. Independent Quality Gate (Recommended)

Before finalizing, run the PRD through an independent review for "executability by an unfamiliar implementer." This catches blind spots the compiler missed.

**Option A — Cross-model review (preferred):**
If available, spawn a subagent (different model or fresh context) to score the PRD on 5 dimensions:

| Dimension | Question | Score 0-10 |
|-----------|----------|-----------|
| **Completeness** | Could an unfamiliar implementer build this without asking questions? | |
| **Consistency** | Do stories contradict each other or the glossary? | |
| **Clarity** | Are acceptance criteria unambiguous and testable? | |
| **Scope** | Are boundaries clear? Could a builder accidentally over-build? | |
| **Feasibility** | Are there stories that assume impossible or unverified capabilities? | |

If any dimension scores < 7, iterate on that section. Maximum 3 review iterations.

**Option B — Self-review (minimum):**
Re-read the PRD as if you are a brand-new agent who has never seen this project. For each story, ask: "Could I build this from only what's written here?" If the answer is "no" for any story, the PRD is not ready.

**Option C — User conducts review:**
Tell the user: "The PRD is ready for independent review. You can paste it into a fresh Claude/ChatGPT session and ask: 'Score this PRD for executability. Could you build this without asking questions?'"

### 9. Finalize the PRD

The final PRD should contain:
- Only approved, clearly specified buildable stories in the buildable section
- Every story traces to decision IDs
- Deferred and excluded items clearly separated from build scope
- No unresolved ambiguity hidden inside story language
- ZERO dropped decisions from upstream artifacts
- All `[ASSUMPTION]` flags resolved or explicitly acknowledged

## PRD Template

<prd-template>

# PRD - [Feature / Milestone Name]

## Purpose

This PRD is a build contract compiled from decision artifacts.

**Decision source:** `.planning/grill-log.md` ([N] decisions)
**Decision index:** `.planning/decision-index.md`
**Domain glossary:** `.planning/CONTEXT.md`

It feeds:
- `/playbook:prd-to-gsd`
- `/playbook:prd-to-ralph`

It may also be audited later by:
- `harden-completeness.sh`

Every story in this PRD traces to one or more decision IDs (DEC-NNN). Claims without decision backing are flagged as `[ASSUMPTION]`.

## Decision Traceability Summary

| Metric | Count |
|--------|-------|
| Total decisions compiled | [N] |
| DECIDED -> stories | [n] |
| DECIDED -> implementation decisions | [n] |
| DEFERRED -> deferred stories | [n] |
| REJECTED -> non-goals | [n] |
| SUPERSEDED (replaced by newer decisions) | [n] |
| Assumptions (no DEC backing) | [n] |
| Dropped decisions | 0 |

### Risk Dashboard

| Risk Category | Count | Decision IDs |
|--------------|-------|-------------|
| LOW confidence decisions | [n] | DEC-NNN, ... |
| HARD to reverse decisions | [n] | DEC-NNN, ... |
| ⚠ LOW confidence + HARD reversibility | [n] | DEC-NNN, ... |
| SYSTEM scope-risk decisions | [n] | DEC-NNN, ... |

Stories backed by ⚠ dangerous-combination decisions are flagged individually in the story template.

### Pending Predictions

| DEC ID | Prediction | Observable | Threshold | Verify After | Status |
|--------|-----------|-----------|-----------|-------------|--------|
| DEC-NNN | [claim] | [what to measure] | [success criterion] | [date] | PENDING / VERIFIED / FALSIFIED |

Predictions from backing decisions that have passed their verify_after date should be flagged for review. Falsified predictions may trigger decision re-evaluation.

### Observation Indicators (Watch, Don't Optimize)

| DEC ID | Metric | Concern | Status |
|--------|--------|---------|--------|
| DEC-NNN | [metric] | [what would signal a problem] | WATCHING |

These metrics are explicitly NOT optimization targets. If a team starts optimizing an observation indicator, flag it — that defeats the purpose.

## Problem Statement

[Describe the problem from the user's perspective.]

**Traced to:** DEC-001, DEC-002, DEC-003

Include:
- who is affected (DEC-NNN)
- what is failing today (DEC-NNN)
- why it matters now (DEC-NNN)
- what business or user outcome is required (DEC-NNN)

## Solution Summary

[Describe the intended solution from the user's perspective.]

**Traced to:** DEC-NNN, DEC-NNN

Keep this behavioral, not implementation-heavy.

## Domain Glossary

[Copied from `.planning/CONTEXT.md` — the canonical definitions for this PRD]

| Term | Definition | Source |
|------|-----------|--------|
| [term] | [definition] | DEC-NNN |

## Guiding Principles

[Copied from `.planning/CONTEXT.md` — stable truths that constrain all stories]

1. [Principle] (DEC-NNN)
2. [Principle] (DEC-NNN)

## Scope Summary

### In Scope for This PRD
- [explicit scope item] (DEC-NNN)
- [explicit scope item] (DEC-NNN)

### Out of Scope for This PRD
- [explicitly excluded item] (DEC-NNN — REJECTED)
- [explicitly excluded item] (DEC-NNN — REJECTED)

### Deferred Ideas
- [future idea not approved for this build] (DEC-NNN — DEFERRED)
- [future idea not approved for this build] (DEC-NNN — DEFERRED)

## Buildable User Stories

Only include stories marked `BUILD` in the Founder Verification Round.

For each story, use this template:

### Story [ID] - [Short Title]

**Status:** BUILD
**Priority:** MUST | SHOULD
**Actor:** [who]
**Story:** As a [actor], I want [capability], so that [outcome].
**Business Value:** [why this matters now]
**Decision Backing:** DEC-NNN, DEC-NNN, DEC-NNN
**Screen / Wireframe:** [reference, route, mock, or "N/A - backend"]
**Dependencies:** [Story IDs only: S01, S03, or "None"]
**External Prerequisites:** [Non-story dependencies: "Stripe API configured", "Auth module deployed", or "None"]

> Every ID in Dependencies must be a BUILD story defined in this PRD.
> `prd-to-ralph` builds a dependency graph from this field — prose
> entries or non-existent story IDs will cause compilation failure.

**Decision Metadata (inherited from backing decisions):**
- Lowest confidence: [HIGH/MEDIUM/LOW — inherited from the least-confident backing DEC]
- Hardest reversibility: [EASY/MODERATE/HARD — inherited from the hardest-to-reverse backing DEC]
- Widest scope-risk: [LOCAL/MODULE/SYSTEM — inherited from the widest-scope backing DEC]

If any backing decision has LOW confidence, flag it:
> ⚠ This story is backed by DEC-NNN (LOW confidence). Consider early validation: prototype, user test, or technical spike before full build.

If any backing decision has HARD reversibility, flag it:
> ⚠ DEC-NNN is HARD to reverse. Rollback plan: [from DEC record]. Allocate extra review and testing.

**In Scope**
- [explicit included behavior] (DEC-NNN)
- [explicit included behavior] (DEC-NNN)

**Out of Scope**
- [explicit excluded behavior] (DEC-NNN)
- [explicit excluded behavior] (DEC-NNN)

**Acceptance Criteria (EARS format)**

Use EARS (Easy Approach to Requirements Syntax) for machine-parseable
criteria. Every criterion follows one of these patterns:

| Pattern | Template | When to use |
|---------|----------|-------------|
| Event-driven | WHEN [trigger] THE SYSTEM SHALL [behavior] | User action triggers a response |
| State-driven | WHILE [state] THE SYSTEM SHALL [behavior] | Ongoing behavior during a condition |
| Unwanted | IF [condition] THEN THE SYSTEM SHALL [behavior] | Error/edge case handling |
| Optional | WHERE [feature] IS SUPPORTED THE SYSTEM SHALL [behavior] | Optional/conditional features |
| Ubiquitous | THE SYSTEM SHALL [behavior] | Always-on constraint |

- WHEN [user submits login with valid credentials] THE SYSTEM SHALL [return a JWT and redirect to /dashboard] (DEC-NNN)
- WHEN [user submits login with invalid credentials] THE SYSTEM SHALL [display inline error "Invalid email or password" without page reload] (DEC-NNN)
- IF [the third-party payment API returns a 5xx error] THEN THE SYSTEM SHALL [retry once after 2s, then display "Payment unavailable, try again later"] (DEC-NNN)

Acceptance criteria must be verifiable from code or UI alone — an auditor running the app should be able to confirm each criterion without access to the grill log, conversation history, or any context beyond the running code and this PRD.

Acceptance criteria should be quantified where possible.
Prefer:
- "WHEN [user navigates to /events] THE SYSTEM SHALL [load event dashboard in under 2 seconds on seeded local data]" (DEC-045)
- "WHEN [user applies an invalid coupon code] THE SYSTEM SHALL [reject with inline error message below the input]" (DEC-032)
- "WHEN [user completes registration] THE SYSTEM SHALL [send confirmation email exactly once]" (DEC-018)

Avoid:
- "works well"
- "is intuitive"
- "is fast"
- "supports management"
- "handles edge cases"
- Prose acceptance criteria without WHEN/SHALL structure

**EARS Validation Gate (apply to every criterion before finalizing):**

Each acceptance criterion MUST match one of these patterns:
- `WHEN [trigger] THE SYSTEM SHALL [behavior] (DEC-NNN)`
- `WHILE [state] THE SYSTEM SHALL [behavior] (DEC-NNN)`
- `IF [condition] THEN THE SYSTEM SHALL [behavior] (DEC-NNN)`
- `WHERE [feature] IS SUPPORTED THE SYSTEM SHALL [behavior] (DEC-NNN)`
- `THE SYSTEM SHALL [behavior] (DEC-NNN)`

Validation rules:
1. Exactly one criterion per bullet point (no compound criteria)
2. Keywords WHEN/WHILE/IF/WHERE/SHALL must be UPPERCASE
3. Every criterion must end with `(DEC-NNN)` tracing to a decision
4. The [trigger]/[condition] must name a specific user action, system
   state, or error condition — not vague phrases like "when appropriate"
5. The [behavior] must be verifiable from code or UI — not "works well"

If a criterion fails validation, rewrite it before including it in the
PRD. Do NOT include unvalidated criteria and hope downstream will fix
them.

If any criterion lacks a DEC reference: `[ASSUMPTION: no decision backing — needs founder confirmation]`

**Verification Anchors**
At least one anchor is required. Prefer 2-3.

- Route: `[route path]`
- Action: `[server action / API handler / job / command name]`
- UI: `[screen reference + label/button/table/modal name]`

**Completeness Verifiability**
Describe how a later auditor should verify that this story exists in the running code. The verification description must be self-contained — no references to "as discussed" or "the usual approach." An auditor reading this cold should know exactly what to check.

**Escalation Conditions**
Required for stories backed by LOW confidence or HARD reversibility decisions. Tells downstream build agents when to STOP and ask the human instead of proceeding.

- "If implementation requires changing the schema beyond what DEC-NNN specifies, STOP and escalate."
- "If the third-party API does not support [assumed capability from DEC-NNN], STOP and escalate."
- "If performance testing shows response time > [threshold from DEC-NNN], STOP and escalate."

For stories where all backing decisions are HIGH confidence + EASY reversibility: `Escalation Conditions: None — proceed autonomously.`

**Notes for Downstream Builders**
- [critical clarification]
- [critical constraint]
- [known edge case]
- [rollback implications if any backing DEC has HARD reversibility]
- [counterarguments from backing DECs that builders should be aware of]

Repeat this structure for every BUILD story.

## Deferred Stories

These were discussed and intentionally deferred. Each traces to a DEFERRED decision.

### Story [ID] - [Short Title]

**Status:** DEFER
**Priority:** SHOULD | COULD
**Decision Backing:** DEC-NNN (DEFERRED)
**Reason Deferred:** [why not now — from the decision record]
**Would Revisit When:** [future trigger — from the decision record]

## Explicit Non-Goals

These are intentionally excluded so downstream builders do not infer them. Each traces to a REJECTED decision.

### Story [ID] - [Short Title]

**Status:** REMOVE or WON'T
**Decision Backing:** DEC-NNN (REJECTED)
**Reason Excluded:** [why this is not being built — from the decision record]

## Implementation Decisions

Document stable, planning-level decisions. Each traces to decision records and/or ADRs.

Include:
- modules to build or modify (DEC-NNN)
- major interfaces or boundaries (ADR-NNN if applicable)
- architecture decisions (ADR-NNN)
- schema and data implications (DEC-NNN from data-grill)
- API contracts (DEC-NNN)
- role and permission model (DEC-NNN)
- critical UX or UI interaction decisions (DEC-NNN from ux-brief)
- operational constraints (DEC-NNN from infra-grill)
- performance constraints (DEC-NNN)
- security and privacy constraints (DEC-NNN)

Do NOT include fragile code snippets.

## Testing Decisions

Document how the behavior should be tested.

Include:
- what makes a good test for this PRD
- which behaviors require browser verification
- which behaviors require unit and integration coverage
- which risks need explicit counterexample tests
- prior art in the codebase if useful

Rule: Test external behavior, not implementation details.

## Founder Verification Round

List every candidate story and the founder's final decision.

| Story ID | Title | Decision | Priority | DEC Backing | Assumptions | Notes |
|----------|-------|----------|----------|-------------|-------------|-------|
| [ID] | [Title] | BUILD / DEFER / REMOVE | MUST / SHOULD / COULD / WON'T | DEC-NNN, ... | [count] | [notes] |

No story enters the buildable section unless it is marked `BUILD`.

## Full Decision Cross-Reference

Every decision ID from the decision index must appear somewhere in this PRD.

| DEC ID | Title | Status | Confidence | Reversibility | PRD Location |
|--------|-------|--------|-----------|--------------|-------------|
| DEC-001 | [title] | DECIDED | HIGH | EASY | Story S01, Acceptance Criterion 1 |
| DEC-002 | [title] | DECIDED | HIGH | MODERATE | Problem Statement |
| DEC-003 | [title] | DEFERRED | MEDIUM | — | Deferred Story D01 |
| DEC-004 | [title] | REJECTED | HIGH | — | Non-Goal NG01 |
| DEC-023 | [title] | SUPERSEDED | — | — | Replaced by DEC-089 |
| ... | | | | | |

**Dropped count: 0** (any non-zero value means the PRD is incomplete)

**Bidirectional verification:**
The table above verifies index → PRD (every decision appears somewhere).
Step 7 of the Cross-Reference Verification verifies PRD → index (every
DEC reference in PRD text resolves to a valid decision with compatible
status). Both directions must pass. A PRD that only satisfies one
direction is incomplete.

**SUPERSEDED decisions** must NOT appear in BUILD story backing, acceptance
criteria, or verification anchors. Only their replacement DEC should be
referenced. If a superseded DEC appears in the PRD, replace it with the
superseding DEC ID.

## Sprint-Scoping Readiness

The PRD must be decomposable into sprint-scoped build packs. This section verifies the PRD is structured for downstream consumption by `/playbook:prd-to-gsd` and `/playbook:prd-to-ralph`.

**Dependency ordering:**
- Every BUILD story's Dependencies must contain only story IDs that exist in this PRD. External Prerequisites are tracked separately and do not affect build ordering.
- No circular dependencies between BUILD stories
- Stories should be orderable into a build sequence where each story's dependencies are satisfied by prior stories
- If Story S05 depends on Story S02, S02 must be buildable and testable independently

**Vertical slice verification:**
- Each BUILD story represents one user-visible behavior
- Each story can be demonstrated to a non-technical person ("show me this working")
- No story is a pure "infrastructure" or "setup" task without user-visible output (exception: explicit technical foundation stories marked as such with clear downstream consumers listed)

**Size calibration:**
- MUST stories should each be completable in 1-3 focused build sessions
- If a story feels like "build the entire backend," it needs further decomposition — run `/grill-me` on that story's scope
- If a story is so small it's trivial, consider merging with a related story

**Build pack readiness test:**
A downstream builder (human or AI) should be able to:
1. Pick up any single BUILD story from this PRD
2. Read its acceptance criteria, in-scope, out-of-scope, and verification anchors
3. Build it without reading ANY other document (the story is self-contained)
4. Verify it passes using only the acceptance criteria and verification anchors
5. Submit it for review

If any story fails this test, it is underspecified.

## Readiness Check

Before finalizing, confirm:

**Artifact integrity:**
- [ ] All decision artifacts loaded using hot/cold strategy
- [ ] Decision map built — every DEC-NNN accounted for
- [ ] Gap analysis completed — missing coverage identified
- [ ] Cross-reference verification: zero dropped decisions
- [ ] Domain glossary consistent between CONTEXT.md and PRD

**Decision quality:**
- [ ] All `[ASSUMPTION]` flags resolved
- [ ] LOW confidence + HARD reversibility decisions flagged with warnings
- [ ] SUPERSEDED decisions not referenced (only their replacements)
- [ ] Decision metadata propagated to stories (confidence, reversibility, scope-risk)

**Story quality:**
- [ ] Every BUILD story has decision ID backing
- [ ] Every BUILD story has a MoSCoW priority
- [ ] Every BUILD story has 2-3 testable acceptance criteria with DEC references
- [ ] Every BUILD story has explicit in-scope and out-of-scope
- [ ] Every BUILD story has a screen or wireframe reference if applicable
- [ ] Every BUILD story has at least one verification anchor
- [ ] Every BUILD story passes the anti-rationalization test
- [ ] Every BUILD story is a vertical slice (one user-visible behavior)
- [ ] Every acceptance criterion is verifiable from code/UI alone (no ambient context needed)

**Scope discipline:**
- [ ] Build scope separated from aspiration
- [ ] Deferred and excluded items separated from build scope
- [ ] No "while we're at it" additions without DEC backing
- [ ] No stories that appeared after Phase 2 without explicit DEC records

**Process gates:**
- [ ] Founder Verification Round completed
- [ ] Session bridge test: a cold reader could build from this PRD alone
- [ ] Sprint-scoping readiness: stories are orderable, sized, and independently buildable

If any box cannot be checked, the PRD is not ready.

</prd-template>

## MoSCoW Rules

Use these meanings exactly:

- `MUST`: required for V1; failure to build this means the milestone is incomplete
- `SHOULD`: important but stretch for V1; may be deferred if time or risk forces a cut
- `COULD`: future candidate; not part of the current build queue
- `WON'T`: explicitly excluded; builders must not infer it

Downstream rule:
- Only `BUILD` stories with `MUST` or approved `SHOULD` status should flow into `prd-to-gsd` or `prd-to-ralph`
- `COULD` and `WON'T` must not become build tasks

## Writing Rules

- Use the project's glossary terms from CONTEXT.md — consistently
- Be precise, concrete, testable, non-aspirational
- Be explicit about exclusions
- Trace every claim to a decision ID
- Flag untraced claims as `[ASSUMPTION]`
- If a screen exists, reference it
- If a capability will later be audited, give it a verification anchor
- If a story cannot be verified, it is not finished as a spec

## Anti-Patterns to Avoid

**Compilation anti-patterns:**
- Conducting a fresh interview instead of compiling from decisions
- Silently filling gaps with AI judgment instead of flagging as ASSUMPTION
- Finalizing the PRD without cross-referencing the decision index
- Assuming missing details from the AI's own judgment
- Having a non-zero dropped decision count

**Scope anti-patterns:**
- "This list should be extremely extensive" — scope creep disguised as thoroughness
- Turning brainstorms into commitments
- Adding features that weren't in grill Phase 2 scope without explicit new DEC records
- Bundling multiple user-visible behaviors into a single story because they touch the same code
- Including "nice to have" language in BUILD stories — it's BUILD or DEFER, no middle ground

**Story quality anti-patterns:**
- Writing acceptance criteria without DEC references
- Writing acceptance criteria that require ambient context to verify ("works as expected")
- Sending unclear stories downstream and hoping builders infer correctly
- Ignoring decision metadata — treating HIGH confidence + EASY reversibility the same as LOW confidence + HARD reversibility
- Referencing SUPERSEDED decisions instead of their replacements

**Process anti-patterns:**
- Skipping the Founder Verification Round to save time
- Skipping the cross-reference verification because "I read everything carefully"
- Treating the session bridge test as optional — if a cold reader can't build from this, it's incomplete

## Final Instruction

When in doubt:
- trace the claim to a decision ID
- if no decision exists, flag it as ASSUMPTION
- ask the user to resolve it
- split the story into a vertical slice
- mark it deferred
- mark it explicitly out of scope

Do not guess. Do not rationalize. Do not add scope.

**The PRD is a compiler output.** Its quality is bounded by the quality of its inputs. If the inputs are thin, the PRD will have assumptions. If the inputs are thorough, the PRD will be bulletproof.

**The PRD is a session bridge.** It carries the full weight of weeks of planning into any fresh context — a new Claude session, a new developer, a new build agent. Everything that matters is in this document. Nothing is left in a conversation that will disappear.

**The PRD is a build contract.** Every story is a promise of what will be built, backed by decisions, bounded by explicit scope, and verifiable from the running code. Downstream builders trust this document as the single source of truth. That trust must be earned by completeness, traceability, and discipline.
