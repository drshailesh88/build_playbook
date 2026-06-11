# extract-pathways — Compile per-module behavior pathways from planning artifacts

Compiles the UX brief, PRD, data requirements, and decision ledger into
**per-module behavior pathways**: "in this module, when X happens, Y must
happen, then these 3 things must happen, then terminal state Z." Pathways are
the missing artifact between planning and E2E testing — they carry UX intent
through the compile chain so Playwright tests are DERIVED from the plan
instead of reverse-engineered from whatever got built.

Input: `$ARGUMENTS` — optional module name (default: all modules found in the
PRD/ux-brief).

## Why This Exists — The Second Lossy Compression Problem

The grill → PRD → prd.json chain preserves WHAT to build (features, scope,
escalation). It silently drops HOW THE APP MUST BEHAVE AS A SEQUENCE — the
causal chains the founder described in `/ux-brief` and `/grill-me`:

> "When the user submits the form, the button disables, a toast appears,
> the list refreshes with the new row on top, and the draft is cleared."

That sentence is four assertions in a mandatory order. Today it dissolves
into a one-line acceptance criterion ("user can submit form"), and the
Playwright tests written at the end check whatever the census found — not
what was planned. Tests "just happen" instead of being the plan's shadow.

Pathways fix this at the same point contracts fix decision leak: BEFORE the
build, compiled from artifacts, with traceability, frozen during runs.

## This Is a COMPILER, Not an Interviewer

Like `/write-a-prd` and `/prd-to-ralph`: every pathway field derives from a
specific planning artifact via a documented mapping. The LLM does not invent
behavior. If a causal chain cannot be extracted, the gap is flagged as an
OPEN QUESTION — asked to the founder in ONE batch at the end, never silently
filled.

## Reads

| Artifact | What it contributes |
|---|---|
| `docs/done-spec/*.DONE.md` (if present, from `/done-spec`) | DONE-MEANS statements become pathway chains; SCARS become must-not-reproduce sad branches; oracle confidence per module (a module whose done-spec is mostly UNFINISHED is delta-track, not oracle-track) |
| `.planning/ux-brief.md` | Per-module interaction models, feedback patterns, motion/speed expectations, navigation flows |
| PRD (latest) | Feature behavior, acceptance criteria, user stories |
| `.planning/data-requirements.md` | Data lifecycle effects (what a create/update/delete must visibly cause) |
| `.planning/decision-index.md` + grill logs | DEC-NNN traceability for every behavioral claim |
| `UBIQUITOUS_LANGUAGE.md` | The nouns and verbs pathways must use |
| `.planning/competition-research.md` | Expected-behavior references ("like X's instant search") |

## Produces

```
.planning/pathways/<module>.pathways.md     human-readable, reviewable
.planning/pathways/pathways.json            machine-readable, consumed downstream
.planning/pathways/INDEX.md                 one-line-per-pathway overview
```

## Pathway Record Format

Every pathway gets a stable ID: `PATH-<module>-NNN`.

```markdown
### PATH-editor-003: Submit comment on a document

- **Trace:** DEC-014, PRD §4.2, ux-brief "Feedback patterns"
- **Persona/State:** logged-in member, document open, comment draft non-empty
- **Trigger:** user presses Cmd+Enter or clicks Submit

**Chain (ordered, all observable):**
1. WHEN the trigger fires THEN the submit button disables within 100ms
   AND a pending indicator appears on the draft
2. THEN (on success) these 3 things happen:
   a. the comment appears at the top of the thread with the user's avatar
   b. the draft editor clears and refocuses
   c. the document's comment count increments in the sidebar
3. TERMINAL: thread scrolled to the new comment, no pending indicators

**Sad branches:**
- Network failure → draft preserved, error toast with retry action,
  button re-enables. NEVER lose the draft text.
- Validation failure (empty after trim) → inline message, no request fired.

**Selector anchors:** `comment-submit`, `comment-draft`, `comment-thread`,
`comment-count` (data-testid contract — /wire-selectors enforces these exist)
```

Mapping rules:
- Every numbered chain step MUST be observable in the DOM, the URL, the
  network log, or persisted data. "User feels confident" is not a step.
- Every pathway MUST have ≥1 sad branch. A module's error handling is part
  of its planned behavior, not an implementation detail (Boil the Lake).
- Every pathway MUST trace to at least one artifact. Untraceable behavior
  the agent believes is implied gets `Trace: ASSUMED` and is listed in the
  OPEN QUESTIONS batch for founder confirmation.
- Selector anchors define the `data-testid` contract the builder must ship.

## pathways.json Schema

```json
{
  "module": "editor",
  "id": "PATH-editor-003",
  "name": "Submit comment on a document",
  "trace": ["DEC-014", "PRD-4.2"],
  "state": "logged-in member, document open, draft non-empty",
  "trigger": "Cmd+Enter or Submit click",
  "chain": [
    {"step": 1, "assert": ["submit disabled <100ms", "pending indicator visible"]},
    {"step": 2, "assert": ["comment at thread top", "draft cleared+refocused", "comment count incremented"]},
    {"step": 3, "terminal": "thread scrolled to new comment, no pending indicators"}
  ],
  "sad": [
    {"when": "network failure", "assert": ["draft preserved", "error toast with retry", "button re-enabled"]},
    {"when": "empty after trim", "assert": ["inline message", "no request fired"]}
  ],
  "selectors": ["comment-submit", "comment-draft", "comment-thread", "comment-count"]
}
```

## Process

1. **Inventory modules.** From PRD section headings + ux-brief per-module
   sections. If `$ARGUMENTS` names a module, restrict to it.
2. **Extract causal chains per module.** Scan each artifact for trigger →
   consequence language ("when/then/after/should immediately/on failure").
   Each chain becomes a candidate pathway.
3. **Assign IDs and trace.** Sequential `PATH-<module>-NNN`. Look up the
   decision index for the DEC that authorized each behavior.
4. **Write sad branches.** From data-requirements lifecycle rules + ux-brief
   feedback patterns. If the artifacts are silent on a failure mode, add it
   as ASSUMED + open question.
5. **Define the selector contract.** Derive `data-testid` names from
   UBIQUITOUS_LANGUAGE terms (kebab-case). These are promises the builder
   must keep — `/wire-selectors` and the spec runner depend on them.
6. **Write the three output files.** Save incrementally per module (the Save
   Rule — don't hold 40 pathways in context).
7. **Quality gate** (before finishing):
   - [ ] Every pathway has trigger, ≥2 chain steps, terminal state, ≥1 sad branch
   - [ ] Every assertion is mechanically observable
   - [ ] Every pathway traces to an artifact or is flagged ASSUMED
   - [ ] No pathway describes implementation ("calls the API") instead of behavior ("the row appears")
   - [ ] Selector anchors use ubiquitous-language terms
8. **Ask the OPEN QUESTIONS batch.** All ASSUMED traces and missing sad
   branches in one founder interview. Update records with answers; promote
   confirmed assumptions to real traces (capture new DECs via the decision
   counter if the founder makes new calls here).
9. **Commit.**
   ```bash
   git add .planning/pathways/
   git commit -m "docs(pathways): compile behavior pathways — <modules>"
   ```

## Downstream Consumers

| Consumer | How it uses pathways |
|---|---|
| `/census-to-specs` | Pathways become the AUTHORITATIVE specs for planned behavior; the census remains the net for EMERGENT features (library freebies, unplanned capabilities). Specs cite PATH IDs. |
| `/spec-runner` | Generates one Playwright test per pathway: each chain step's asserts become `expect()`s IN ORDER; each sad branch becomes a test with the failure injected (route abort, empty input). Selectors come from the anchor contract. |
| `/prd-to-ralph` | Injects PATH IDs into each story's `behavior` Verification Anchors section, so the frozen story contract carries them and the T2 judge checks against them. |
| `/wire-selectors` | Wires the `data-testid` contract into built components. |
| `/ralph` harden-drift | Pathway-derived Playwright specs are lock candidates for `e2e/contracts/`. |

## Freezing

Pathways are planning artifacts, versioned in git. Once a build run starts,
they are covered by a T0 locked-path rule — add to `ralph/t0-rules.jsonl`
in the target app:

```json
{"id": "locked-pathways", "type": "locked-path", "path_regex": "^\\.planning/pathways/", "description": "Behavior pathways are frozen during runs — changing planned behavior requires a human"}
```

## Rules

- NEVER invent behavior not grounded in an artifact — flag it ASSUMED instead
- NEVER write an assertion that cannot be checked by Playwright, an API call, or a DB query
- NEVER collapse ordered steps into an unordered list — order is the plan
- One module per file; pathways.json is regenerated from the md files (md is source of truth)
- If `.planning/ux-brief.md` does not exist, STOP and tell the founder to run `/ux-brief` first — pathways without UX intent are just guesses
