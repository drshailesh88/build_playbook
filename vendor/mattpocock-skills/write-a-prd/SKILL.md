---
name: write-a-prd
description: Create a production-grade PRD through mandatory user grilling, repo/context review, and explicit scope verification. Use when the user wants a PRD that will feed downstream AI builders such as /playbook:prd-to-gsd and /playbook:prd-to-ralph.
---

This skill creates a PRD that will be consumed by AI coding agents and completeness auditors.

This is not a lightweight brainstorming artifact. It is a build contract.

## Core Principle

If the specification is ambiguous, incomplete, or aspirational, DO NOT guess.

Ask more questions.
Grill harder.
Resolve ambiguity before writing the PRD.

The cost of over-questioning is minutes.
The cost of under-specifying is hours of bad builds, false completeness gaps, and hallucinated scope.

## Absolute Rules

- The interview is MANDATORY. Never skip it.
- Repo/context review is MANDATORY for brownfield work. Never skip it.
- If upstream planning docs exist, read them before grilling:
  - `.planning/decisions/*.md`
  - `.planning/data-requirements.md`
  - `.planning/ux-brief.md`
  - `.planning/ui-brief.md`
  - `UBIQUITOUS_LANGUAGE.md`
  - `docs/handover-context.md`
  - `docs/multi-domain/MASTER_CONTEXT.md`
  - wireframes, mockups, or screen references if available
- If any important point is unclear, ask follow-up questions instead of making assumptions.
- If there are still unanswered questions at PRD time, continue grilling instead of writing assumptions.
- A PRD with unresolved ambiguity is invalid, even if it is otherwise well-written.
- Never convert a casual founder idea into a build requirement without explicit confirmation.
- Never treat "nice to have", "later", "maybe", "eventually", or "would be cool" as V1 scope.
- Every buildable user story MUST include:
  - a MoSCoW priority
  - 2-3 testable acceptance criteria
  - explicit in-scope and out-of-scope boundaries where ambiguity is possible
  - a screen/wireframe reference if UI exists
  - at least one verification anchor
- Every story MUST pass this filter:
  - "Would the founder pay to build this for V1?"
- If the answer is no, it is not a MUST.
- Do not finalize the PRD until the Founder Verification Round is complete.
- Do not invent requirements not stated or approved by the user.

## Why This Matters

This PRD feeds downstream systems:

- `/playbook:prd-to-gsd`
- `/playbook:prd-to-ralph`
- `harden-completeness.sh`

Each approved buildable story may become a build unit in `prd.json`.

Stories without testable acceptance criteria, clear boundaries, and verification anchors will cause:
- hallucinated missing-feature audits
- over-building
- under-building
- false positives in completeness checks
- wasted build/QA loops

`COULD` and `WON'T` stories are useful for planning context, but they should NOT enter the build queue.

## Process

### 0. Prerequisite Gate — Check Upstream Artifacts

Before ANYTHING else, check what planning artifacts exist. This determines how much grilling is still needed.

```bash
# Check for upstream artifacts
ls .planning/grill-log.md 2>/dev/null
ls .planning/decisions/*.md 2>/dev/null
ls .planning/ux-brief.md 2>/dev/null
ls .planning/ui-brief.md 2>/dev/null
ls .planning/data-requirements.md 2>/dev/null
ls .planning/infra-requirements.md 2>/dev/null
ls .planning/competition-research.md 2>/dev/null
```

**Artifact Readiness Scoring:**

| Artifact | Points | Status |
|----------|--------|--------|
| `.planning/grill-log.md` with ambiguity audit passed | 3 | Found / Missing |
| `.planning/decisions/*.md` (at least 1 file) | 1 | Found / Missing |
| `.planning/ux-brief.md` | 1 | Found / Missing |
| `.planning/data-requirements.md` | 1 | Found / Missing |
| At least one of: ui-brief, infra-requirements, competition-research | 1 | Found / Missing |
| **Total** | **7** | |

**Gate rules:**
- **Score 5-7:** Proceed to PRD generation. Read ALL found artifacts before writing.
- **Score 3-4:** Warn the user that coverage is thin. Recommend running `/grill-me` first. Proceed only if user explicitly confirms.
- **Score 0-2:** STOP. Do not write a PRD. Tell the user:
  ```
  Not enough upstream context to write a reliable PRD.
  
  Missing artifacts will cause me to fill gaps with assumptions,
  which will cause bad builds downstream.
  
  Run these first:
    /grill-me              ← structured interrogation (saves to disk)
    /playbook:ux-brief     ← UX requirements
    /playbook:data-grill   ← data requirements
  
  Then come back to /write-a-prd.
  ```

### 1. Load ALL Existing Context

Read EVERY upstream artifact that exists. Do not skim. Do not summarize. Read completely.

**Mandatory reads (if they exist):**
- `.planning/grill-log.md` — the FULL grill transcript with all 8 phases
- `.planning/decisions/*.md` — every decision file, chronologically
- `.planning/ux-brief.md` — UX requirements
- `.planning/ui-brief.md` — visual language
- `.planning/data-requirements.md` — data model decisions
- `.planning/infra-requirements.md` — infrastructure constraints
- `.planning/competition-research.md` — competitive landscape
- `UBIQUITOUS_LANGUAGE.md` — domain vocabulary
- `docs/handover-context.md` — if it exists
- wireframes, mockups, or screen references if available

For brownfield projects, also:
1. Explore the repo to understand current behavior and constraints.
2. Identify what is already decided vs still ambiguous.
3. Build a list of unresolved questions.

If you find contradictions between artifacts, surface them immediately and ask for clarification.

**After reading, state what you loaded:**
```
Loaded upstream context:
  - grill-log.md: 8 phases complete, 23 decisions captured
  - ux-brief.md: 10 design rules applied
  - data-requirements.md: 5 entities defined
  - decisions/2026-05-28-office-hours.md: problem reframed, wedge defined
  
  Missing:
  - ui-brief.md (visual language not yet defined — will ask during grilling)
  - infra-requirements.md (no infrastructure constraints captured)
```

### 2. Mandatory Grilling Round (Focused on Gaps)

Interview the user — but ONLY on topics NOT already resolved in upstream artifacts.

You MUST probe for:

- the exact problem being solved
- who the actor is
- what success looks like
- what V1 includes
- what V1 explicitly excludes
- failure cases
- edge cases
- permissions and roles
- state transitions
- dependencies on existing modules
- required integrations
- data implications
- UX flow implications
- UI and screen mapping
- performance or reliability expectations
- operational constraints
- what the founder said casually vs what they actually want built

If upstream grilling already exists from:
- `grill-me`
- `data-grill`
- `ux-brief`
- `ui-brief`

use it, but do NOT assume it resolved everything. Continue grilling until the PRD itself is unambiguous.

### 3. Hard Gate on Ambiguity

Before writing the PRD, check:

- Are there any umbrella terms hiding sub-features?
  - Example: "user management" may hide signup, login, logout, password reset, email verification, profile edit, account delete, role assignment.
- Are there any vague verbs?
  - Example: "manage", "handle", "support", "allow", "works well", "fast", "secure"
- Are there any aspirational ideas mixed into V1?
- Are there any UI flows without screen references?
- Are there any stories that cannot be verified later by route, action, or UI?

If yes, STOP and ask more questions.

Do not proceed until ambiguity is either:
- resolved
- explicitly deferred
- explicitly excluded

### 4. Define Buildable Story Units

Convert the approved feature scope into buildable stories.

A good story is:
- independently understandable
- independently testable
- small enough to become one downstream build unit or a small cluster of build units
- explicit about behavior
- explicit about what is not included

Do not write a single giant story like "Build the authentication system".

Break large themes into concrete stories.

### 5. Founder Verification Round

After drafting the stories, run a mandatory review with the founder or user.

For each story, ask the founder to mark exactly one:
- `BUILD`
- `DEFER`
- `REMOVE`

Rules:
- `BUILD`: eligible for downstream implementation
- `DEFER`: keep in PRD as deferred context, not part of the build queue
- `REMOVE`: remove from PRD entirely unless useful as explicit non-goal context

Do not finalize the PRD until this review is complete.

### 6. Cross-Reference Verification (MANDATORY)

Before finalizing, cross-reference the PRD against ALL upstream artifacts to ensure nothing was dropped.

**For each upstream artifact:**

| Source | Check |
|--------|-------|
| `.planning/grill-log.md` | Every decision in the grill log is reflected in a PRD story, implementation decision, or explicit exclusion |
| `.planning/decisions/*.md` | Every captured planning decision is addressed |
| `.planning/ux-brief.md` | Every UX requirement maps to a story or constraint |
| `.planning/data-requirements.md` | Every data entity is covered in implementation decisions |

**Procedure:**
1. Re-read the grill log
2. For each decision in the grill log, find the corresponding PRD section
3. If a grill decision has NO corresponding PRD entry, either:
   - Add a story for it
   - Add it to Implementation Decisions
   - Add it to Explicit Non-Goals (with reason)
4. Report the cross-reference results to the user:

```
Cross-Reference Results:
  Grill log decisions: 23
  Mapped to PRD stories: 18
  Mapped to implementation decisions: 3
  Explicitly excluded: 2
  DROPPED (not in PRD): 0  ← this MUST be zero
```

If any decision was DROPPED (exists in grill log but not in PRD), do NOT finalize. Ask the user what to do with each dropped item.

### 7. Finalize the PRD

The final PRD should contain:
- only approved, clearly specified buildable stories in the buildable section
- deferred and excluded items clearly separated from build scope
- no unresolved ambiguity hidden inside story language
- ZERO dropped decisions from upstream artifacts

If GitHub issue creation is part of the workflow, submit the PRD as a GitHub issue.
If not, write it as a Markdown artifact the next command can consume.

## PRD Template

<prd-template>

# PRD - [Feature / Milestone Name]

## Purpose

This PRD is a build contract for downstream AI implementation.

It feeds:
- `/playbook:prd-to-gsd`
- `/playbook:prd-to-ralph`

It may also be audited later by:
- `harden-completeness.sh`

Stories without testable acceptance criteria or verification anchors will create false positives and wasted implementation cycles.

## Problem Statement

Describe the problem from the user's perspective.

Include:
- who is affected
- what is failing today
- why it matters now
- what business or user outcome is required

## Solution Summary

Describe the intended solution from the user's perspective.

Keep this behavioral, not implementation-heavy.

## Scope Summary

### In Scope for This PRD
- [explicit scope item]
- [explicit scope item]

### Out of Scope for This PRD
- [explicitly excluded item]
- [explicitly excluded item]

### Deferred Ideas
- [future idea not approved for this build]
- [future idea not approved for this build]

## Buildable User Stories

Only include stories marked `BUILD` in the Founder Verification Round.

For each story, use this template:

### Story [ID] - [Short Title]

**Status:** BUILD
**Priority:** MUST | SHOULD
**Actor:** [who]
**Story:** As a [actor], I want [capability], so that [outcome].
**Business Value:** [why this matters now]
**Screen / Wireframe:** [M## reference, route, mock, or "N/A - backend"]
**Dependencies:** [upstream stories, modules, integrations, or "None"]

**In Scope**
- [explicit included behavior]
- [explicit included behavior]

**Out of Scope**
- [explicit excluded behavior]
- [explicit excluded behavior]

**Acceptance Criteria**
- [Verb-led, testable criterion with observable outcome]
- [Verb-led, testable criterion with observable outcome]
- [Optional third criterion]

Acceptance criteria should be quantified where possible.
Prefer:
- "Loads event dashboard in under 2 seconds on seeded local data"
- "Rejects invalid coupon code with inline error message"
- "Sends confirmation email exactly once after successful registration"

Avoid:
- "works well"
- "is intuitive"
- "is fast"
- "supports management"
- "handles edge cases"

**Verification Anchors**
At least one anchor is required. Prefer 2-3.

- Route: `[route path]`
- Action: `[server action / API handler / job / command name]`
- UI: `[screen reference + label/button/table/modal name]`

Examples:
- Route: `/api/events/[eventId]/certificates`
- Action: `src/lib/actions/issueCertificate.ts`
- UI: `M61 Certificate Issuance screen, "Issue" button`

**Completeness Verifiability**
Describe how a later auditor should verify that this story exists in the running code.

Use at least one of:
- route exists and is reachable
- UI control exists and triggers the behavior
- named handler or action exists
- visible screen state proves completion
- browser flow reproduces the expected outcome

**Notes for Downstream Builders**
- [critical clarification]
- [critical constraint]
- [known edge case]

Repeat this structure for every BUILD story.

## Deferred Stories

These were discussed and intentionally not approved for the current build queue.

Use this template:

### Story [ID] - [Short Title]

**Status:** DEFER
**Priority:** SHOULD | COULD
**Reason Deferred:** [why not now]
**Would Revisit When:** [future trigger]

## Explicit Non-Goals

These are intentionally excluded so downstream builders do not infer them.

Use this template:

### Story [ID] - [Short Title]

**Status:** REMOVE or WON'T
**Reason Excluded:** [why this is not being built]

## Implementation Decisions

Document stable, planning-level decisions only.

Include:
- modules to build or modify
- major interfaces or boundaries
- architecture decisions
- schema and data implications
- API contracts
- role and permission model
- critical UX or UI interaction decisions
- operational constraints
- performance constraints
- security and privacy constraints

Do NOT include fragile code snippets.
Avoid file-path-level implementation plans unless a path itself is required as a verification anchor.

## Testing Decisions

Document how the behavior should be tested.

Include:
- what makes a good test for this PRD
- which behaviors require browser verification
- which behaviors require unit and integration coverage
- which risks need explicit counterexample tests
- prior art in the codebase if useful

Rule:
Test external behavior, not implementation details.

## Founder Verification Round

List every candidate story and the founder's final decision.

| Story ID | Title | Decision | Priority | Notes |
|----------|-------|----------|----------|-------|
| [ID] | [Title] | BUILD / DEFER / REMOVE | MUST / SHOULD / COULD / WON'T | [notes] |

No story enters the buildable section unless it is marked `BUILD`.

## Readiness Check

Before finalizing, confirm:

- [ ] Repo and context reviewed
- [ ] User grilled on unresolved ambiguity
- [ ] Build scope separated from aspiration
- [ ] Every BUILD story has a priority
- [ ] Every BUILD story has 2-3 testable acceptance criteria
- [ ] Every BUILD story has explicit in-scope and out-of-scope if ambiguity exists
- [ ] Every BUILD story has a screen or wireframe reference if applicable
- [ ] Every BUILD story has at least one verification anchor
- [ ] Founder Verification Round completed
- [ ] Deferred and excluded items are separated from build scope

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

- Prefer behavioral language over implementation language
- Be precise
- Be concrete
- Be testable
- Be non-aspirational
- Be explicit about exclusions
- Use the project's ubiquitous language
- If a screen exists, reference it
- If a capability will later be audited, give it a verification anchor
- If a story cannot be verified, it is not finished as a spec

## Anti-Patterns to Avoid

Do NOT do any of the following:

- "This list should be extremely extensive"
- Turning brainstorms into commitments
- Using vague umbrella labels as final story text
- Writing user stories without acceptance criteria
- Writing global out-of-scope only, while leaving story-level ambiguity unresolved
- Finalizing the PRD without founder review
- Assuming missing details from the AI's own judgment
- Sending unclear stories downstream and hoping builders infer correctly

## Final Instruction

When in doubt:
- ask another question
- split the story
- mark it deferred
- mark it explicitly out of scope

Do not guess.

The PRD step is the cornerstone of downstream quality.
