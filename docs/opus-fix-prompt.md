# Opus 4.7 Task: Fix 9 Adversarial Findings in grill-me and write-a-prd

## Your Role

You are editing two prompt files in a Build Playbook system. These files
are instructions that LLM agents follow — they are NOT code. Every change
you make changes how future LLM agents behave. Precision matters.

## System Context

The Build Playbook is a pipeline where founder decisions flow through
multiple compilation stages to become buildable software:

```
Grilling (grill-me, data-grill, ux-brief, ui-brief, infra-grill)
    ↓  writes DEC-NNN records to .planning/
write-a-prd (PRD compiler)
    ↓  compiles decisions into a structured PRD document
prd-to-ralph (Ralph compiler)
    ↓  compiles PRD into prd.json + spec files
build-prompt (builder agent)
    ↓  builds one feature at a time, TDD-first
qa-prompt / harden / contracts / release gates
```

Every DEC record has: Question, Options Considered, Selected, Rationale,
Rejected, Dependencies, Status (DECIDED/DEFERRED/REJECTED), Confidence
(HIGH/MEDIUM/LOW), Reversibility (EASY/MODERATE/HARD), Scope-Risk
(LOCAL/MODULE/SYSTEM), Counterargument, Valid Until, Consequences
(Enables, Constrains, Rollback plan), Prediction, Observation Indicators.

The downstream compiler `prd-to-ralph` expects EVERY decision backing a
story to have Confidence, Reversibility, and Scope-Risk so it can
classify risk tiers. If those fields are missing, it fills permissive
defaults — which we've already identified as a bug and fixed downstream.
Now we need to fix the upstream sources.

## Files to Modify

1. **`vendor/mattpocock-skills/grill-me/SKILL.md`** (736 lines)
   The core interrogation skill. Produces structured DEC records in
   `.planning/grill-log.md` and `.planning/decision-index.md`.

2. **`vendor/mattpocock-skills/write-a-prd/SKILL.md`** (840 lines)
   The PRD compiler. Reads all `.planning/` artifacts and produces a
   structured PRD document that `prd-to-ralph` consumes.

## Constraints

- Do NOT restructure the files. Fix each finding surgically.
- Do NOT change how the user interacts with the grill (question flow,
  phases, escape hatch behavior). Only change persistence and validation.
- Do NOT add new files or scripts. All fixes go into the two SKILL.md files.
- Do NOT remove existing functionality. All fixes are additive.
- Preserve the existing markdown formatting style.
- Keep each edit minimal — change the smallest section needed to fix the
  finding. Do not rewrite surrounding paragraphs.

---

## FINDINGS TO FIX

### Finding G1 [HIGH]: DEC ID allocation is not truly atomic
**File:** `vendor/mattpocock-skills/grill-me/SKILL.md`, lines 88-111
**Section:** "### 4. Reserve DEC IDs via the atomic counter"

**Current state:** The counter protocol says "read next-dec-id, write
ID + 1 back, use the ID" but there is no lock between read and write.
Two parallel grill sessions can read the same value before either writes.

**What to change:** Replace the bash example with a `mkdir`-based lock
protocol. `mkdir .planning/.dec-lock` is atomic on all filesystems — it
either succeeds (you hold the lock) or fails (someone else does).

**Target implementation:**
```bash
# Atomic DEC ID allocation with mkdir lock
acquire_lock() {
  while ! mkdir .planning/.dec-lock 2>/dev/null; do
    sleep 0.1
  done
}
release_lock() {
  rmdir .planning/.dec-lock
}

acquire_lock
NEXT_ID=$(cat .planning/next-dec-id 2>/dev/null || echo 1)
echo $((NEXT_ID + 1)) > .planning/next-dec-id
release_lock
# Use DEC-$NEXT_ID for this record
```

Also add to the text: "If `.planning/.dec-lock` exists and is older than
60 seconds, it is stale — remove it and retry. This handles crashed
sessions that never released the lock."

Also update line ~650 "6. Find the highest DEC-NNN number" in the
"Resuming a Prior Grill" section to say "6. Verify `.planning/next-dec-id`
matches highest DEC + 1. If not, fix it." (removing the scan instruction).

---

### Finding G2 [HIGH]: Save rules still allow up to 3 unsaved decisions
**File:** `vendor/mattpocock-skills/grill-me/SKILL.md`, lines 559-603
**Section:** "## The Save Rule"

**Current state:** The text says "Save IMMEDIATELY after each decision"
but then says "You may batch the display (ask 2-3 questions, then save
all resolved records at once) but never let more than 3 unsaved
decisions accumulate."

**What to change:** Remove the batching allowance entirely. The rule
must be unambiguous: save to disk after EVERY resolved decision before
asking the next question. The display can show a save confirmation
inline (e.g., "[DEC-042 saved to disk]") without interrupting the
conversation flow.

Replace the paragraph starting "You may batch the display" with:
"Save each decision to disk BEFORE asking the next question. Display
a brief inline confirmation: `[DEC-NNN saved to disk]`. This does not
interrupt conversation flow — it takes one tool call to append the
record and update the index."

Also update the counter rule section to say the counter confirms
each save, not batches.

---

### Finding G3 [HIGH]: Escape hatch can defer critical decisions
**File:** `vendor/mattpocock-skills/grill-me/SKILL.md`, lines 711-726
**Section:** "## Escape Hatch — Respect User Pushback"

**Current state:** After two pushbacks, the grill records DEFERRED and
moves on. The completion gate doesn't block on critical deferrals.

**What to change:** Add a criticality classification to the escape hatch.
After recording DEFERRED, classify it:

- **BLOCKING DEFERRAL:** The decision is about permissions, deletion,
  authentication, payment, data lifecycle, tenant isolation, or any topic
  where a builder guessing wrong causes irreversible harm. Mark with
  `Criticality: BLOCKING`. The completion gate MUST list these and warn
  the user that `write-a-prd` will refuse to compile stories that depend
  on BLOCKING deferrals.

- **NON-BLOCKING DEFERRAL:** The decision is about UI preference,
  wording, non-critical UX, or anything where a safe default exists.
  Mark with `Criticality: NON-BLOCKING`. The completion gate allows
  these.

Add this AFTER the "Second pushback" instruction (line 716) and BEFORE
the "Never:" list. Also add a `Criticality` field to the DEFERRED
record format.

Then update the completion gate section (search for "Completion Gate")
to require: "All BLOCKING deferrals must be resolved, converted to
explicit non-goals, or tied to a safe default with acceptance criteria
before the grill can complete."

---

### Finding G4 [MEDIUM]: Depth tier not persisted in records or index
**File:** `vendor/mattpocock-skills/grill-me/SKILL.md`, lines 688-709
**Section:** "## Depth Calibration"

**Current state:** The text says "The decision index should tag each DEC
with its tier" but the tier is not a field in the DEC record format, and
the decision-index table template (lines 564-568) has no Tier column.

**What to change:**
1. Add `- **Tier:** note | tactical | standard | deep` to the DEC record
   format (after `Scope-Risk`, around line 121).
2. Add a `Tier` column to the decision-index table template (line 564).
3. Add a deterministic escalation rule after the calibration table:
   "**Mandatory tier escalation:** Any decision with HARD reversibility
   MUST be `deep`. Any decision with SYSTEM scope-risk MUST be
   `standard` or `deep`. Any decision with LOW confidence MUST be
   `standard` or `deep`. If the user's chosen tier conflicts with these
   rules, escalate automatically and note why."

---

### Finding W1 [HIGH]: Prerequisite gate only checks file existence
**File:** `vendor/mattpocock-skills/write-a-prd/SKILL.md`, lines 88-127
**Section:** "### 0. Prerequisite Gate"

**Current state:** The gate runs `ls` on files and scores Found/Missing.
A project can have all files present but with stale or incomplete content.

**What to change:** After the existing `ls` commands (line 105), add an
integrity check block. Keep the existing scoring table but add a second
gate after it:

```markdown
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
```

This keeps the existing presence scoring but adds content validation
that catches stale, corrupt, or out-of-sync artifacts.

---

### Finding W2 [HIGH]: DEFERRED decisions can be lost
**File:** `vendor/mattpocock-skills/write-a-prd/SKILL.md`, lines 330-374
**Section:** "### 7. Cross-Reference Verification"

**Current state:** The cross-reference checks `.planning/grill-log.md`
for DECIDED decisions, and uses the decision index for DEFERRED/REJECTED.
If a DEFERRED record is in the grill log but NOT in the index, it's
invisible.

**What to change:** Change the procedure (lines 348-374) to build the
cross-reference from the UNION of all sources:

Replace step 1 ("Re-read the decision index") with:
"1. Build the master decision set from the UNION of:
   - All DEC records in `.planning/grill-log.md`
   - All DEC records in `.planning/decisions/*.md`
   - All rows in `.planning/decision-index.md`
   If a DEC ID appears in one source but not another, flag it as an
   integrity error. Do NOT proceed until resolved."

Then add after step 4:
"4b. For each DEFERRED decision in the master set, verify:
   - It appears in the Deferred Stories section of the PRD
   - If it has `Criticality: BLOCKING`, any BUILD story that
     depends on it (directly or transitively) must be flagged
   - BLOCKING deferrals without resolution block PRD finalization"

Also add a reverse check after step 6:
"7. Reverse check — extract ALL `DEC-NNN` references from the PRD
   text. For each:
   - The DEC ID must exist in the master decision set
   - The DEC status must be compatible with its location:
     - DECIDED DECs can appear in BUILD stories
     - DEFERRED DECs can appear in Deferred Stories only
     - REJECTED DECs can appear in Explicit Non-Goals only
     - SUPERSEDED DECs must NOT appear anywhere — only their
       replacements
   - The PRD location (e.g., 'Story S01, AC 3') must actually exist
   Flag any violations as blocking errors."

---

### Finding W3 [MEDIUM]: Dependencies field allows prose
**File:** `vendor/mattpocock-skills/write-a-prd/SKILL.md`, lines 527-536
**Section:** Story template, `Dependencies` field

**Current state:** `Dependencies: [upstream stories, modules,
integrations, or "None"]` — allows free-text.

**What to change:** Split into two fields:

Replace line 536:
```
**Dependencies:** [upstream stories, modules, integrations, or "None"]
```
With:
```
**Dependencies:** [Story IDs only: S01, S03, or "None"]
**External Prerequisites:** [Non-story dependencies: "Stripe API configured", "Auth module deployed", or "None"]
```

Then add a validation note:
"Every ID in Dependencies must be a BUILD story defined in this PRD.
`prd-to-ralph` builds a dependency graph from this field — prose entries
or non-existent story IDs will cause compilation failure."

Also update the Sprint-Scoping Readiness section (around line 703) to
reference the split: "Every BUILD story's Dependencies must contain only
story IDs that exist in this PRD. External Prerequisites are tracked
separately and do not affect build ordering."

---

### Finding W4 [MEDIUM]: EARS criteria not constrained enough
**File:** `vendor/mattpocock-skills/write-a-prd/SKILL.md`, lines 557-590
**Section:** "Acceptance Criteria (EARS format)"

**Current state:** Shows EARS patterns and examples, warns against prose,
but doesn't enforce a strict grammar or lint step.

**What to change:** After the "Avoid" list (line 588), add an EARS
validation gate:

```markdown
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
```

---

### Finding W5 [MEDIUM]: Cross-reference is one-directional
**File:** `vendor/mattpocock-skills/write-a-prd/SKILL.md`, lines 683-697
**Section:** "## Full Decision Cross-Reference"

**Current state:** The table maps each DEC ID to a PRD location, but
doesn't verify the reverse — whether DEC references in the PRD actually
resolve to valid decisions.

**What to change:** This is partially addressed by the reverse check
added in Finding W2 (step 7). To complete it, add a note after the
cross-reference table (line 697):

```markdown
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
```

---

## Success Criteria

When all 9 findings are fixed:

1. `grill-me/SKILL.md` DEC allocation uses `mkdir`-based lock — no
   race condition between parallel sessions
2. `grill-me/SKILL.md` save rule has zero ambiguity — save after every
   decision, no batching exception
3. `grill-me/SKILL.md` escape hatch classifies deferrals as BLOCKING
   vs NON-BLOCKING, and BLOCKING deferrals prevent grill completion
4. `grill-me/SKILL.md` Tier is a persisted field in records and index,
   with mandatory escalation rules
5. `write-a-prd/SKILL.md` prerequisite gate validates artifact integrity,
   not just presence
6. `write-a-prd/SKILL.md` cross-reference builds from UNION of all
   sources, preventing DEFERRED decisions from being lost
7. `write-a-prd/SKILL.md` Dependencies field is story-ID-only, with
   External Prerequisites as a separate field
8. `write-a-prd/SKILL.md` EARS criteria have a validation gate with
   strict pattern matching
9. `write-a-prd/SKILL.md` cross-reference is bidirectional — both
   index→PRD and PRD→index must pass

## Execution Order

Fix in this order (dependencies):
1. G4 (Tier field) — adds field used by G3
2. G1 (atomic lock) — foundational persistence fix
3. G2 (save rule) — depends on G1's lock protocol
4. G3 (escape hatch criticality) — uses Tier from G4
5. W1 (prerequisite integrity) — standalone
6. W3 (dependencies split) — standalone
7. W4 (EARS validation) — standalone
8. W2 (cross-reference union + reverse check) — most complex, do last
9. W5 (bidirectional note) — trivial addition after W2

Commit message when done:
```
fix(grill+prd): atomic DEC locks, strict save rules, critical deferral gates, EARS validation, bidirectional cross-reference

9 findings from Codex adversarial review resolved:
- G1: mkdir-based lock for DEC ID allocation (no parallel collision)
- G2: save after every decision (no batching exception)
- G3: BLOCKING/NON-BLOCKING deferral classification
- G4: Tier field persisted in records and index
- W1: prerequisite gate validates content integrity, not just presence
- W2: cross-reference from UNION of all sources + reverse check
- W3: Dependencies field is story-ID-only
- W4: EARS validation gate with strict pattern matching
- W5: bidirectional cross-reference verification

Found by: Codex adversarial review
```
