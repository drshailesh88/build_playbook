# Opus 4.7 Task: Fix 5 Adversarial Findings in prd-to-ralph.md

## Your Role

You are editing a single prompt file that serves as the Ralph compiler —
it transforms a structured PRD document into `prd.json` + spec files that
downstream build/QA agents consume. This file is instructions for an LLM
agent, not executable code. Every change you make changes how future
compilations behave. Precision matters.

## System Context

The Build Playbook pipeline:

```
grill-me → write-a-prd → [prd-to-ralph] → build-prompt → qa-prompt → harden → release gates
                              ^^^
                          YOU ARE HERE
```

**Upstream (write-a-prd produces):** A PRD document with BUILD stories,
each containing: Story ID (S01, S02...), Dependencies (story-ID-only),
External Prerequisites (non-story deps), Decision Backing (DEC-NNN),
Decision Metadata (Confidence, Reversibility, Scope-Risk, Tier),
In Scope, Out of Scope, Acceptance Criteria (EARS format), Verification
Anchors, Completeness Verifiability, Escalation Conditions, Builder
Notes. DEFERRED decisions appear in Deferred Stories. REJECTED decisions
appear in Explicit Non-Goals.

**Downstream (build-prompt expects):** `prd.json` entries with: id
(kebab-case), category (data/layout/ui/crud/settings/interaction),
description, page, ui_details, behavior (7 sections), data_model,
priority (integer), core (boolean), passes (boolean), tests (structured),
fail_to_pass (array of test names). Also `ralph/specs/{id}.md` enriched
spec files that the builder reads for full context.

**Key invariant:** prd-to-ralph is a MECHANICAL compiler. No LLM
judgment. Every value traces to a specific PRD section.

## File to Modify

**`commands/prd-to-ralph.md`** (797 lines)

## Constraints

- Do NOT restructure the file. Fix each finding surgically.
- Do NOT change the fundamental compilation approach (mechanical, no LLM
  judgment). Only add fields, validation rules, and mapping clarity.
- Do NOT add new files. All fixes go into prd-to-ralph.md.
- Preserve existing markdown formatting style.
- Keep each edit minimal — change the smallest section needed.

---

## FINDINGS TO FIX

### Finding R1 [HIGH]: External Prerequisites and new PRD metadata dropped
**File:** `commands/prd-to-ralph.md`, lines 100-113
**Section:** Step 2 extraction table and Step 4 field mapping

**Current state:** The extraction table maps Dependencies, Screen/Wireframe,
and Priority from each BUILD story. But write-a-prd now produces additional
fields: `External Prerequisites` (non-story dependencies like "Stripe API
configured"), `Tier` (note/tactical/standard/deep from grill), and
`Criticality` on DEFERRED decisions (BLOCKING/NON-BLOCKING). None of these
are extracted or mapped.

**What to change:**

1. In the extraction/mapping table (around line 43-56), add rows:
   ```
   | External Prerequisites | `external_prerequisites` | Copy verbatim; "None" if absent |
   | Decision Tier | `tier` | Highest tier among backing DECs (deep > standard > tactical > note) |
   ```

2. In Step 4, add a new field `4k. The external_prerequisites field`:
   ```
   Copy from the PRD story's External Prerequisites field. If the story
   lists external prerequisites (e.g., "Stripe API configured", "Auth
   provider deployed"), these must be present at build time. The builder
   should verify these before starting implementation.

   If no external prerequisites: `"None"`.
   ```

3. Add the `external_prerequisites` field to the required keys set in
   Step 7 validation (around line 596).

4. In the enriched spec file template (Step 5), add an
   `## External Prerequisites` section that lists these so the builder
   sees them in the full spec context.

---

### Finding R2 [HIGH]: Risk gating uses unreachable category values
**File:** `commands/prd-to-ralph.md`, lines 160-257
**Section:** Step 4b (category mapping) and the HARD-GATE risk tier block

**Current state:** The risk tier block classifies stories as HIGH-RISK
when `category is auth, payments, user_data`. But the category mapping
(Step 4b) only allows: data, layout, ui, crud, settings, interaction.
The values `auth`, `payments`, `user_data` can never appear in the
category field, making the category-based HIGH-RISK detection dead code.

**What to change:**

1. Add a new field after category: `4b2. The risk_domain field`
   ```markdown
   #### 4b2. The `risk_domain` field

   Separate from `category` (which drives build ordering), `risk_domain`
   drives safety classification. Extract from the story's domain:

   - Story touches authentication, login, sessions, tokens → `"auth"`
   - Story touches payments, billing, subscriptions, pricing → `"payments"`
   - Story touches PII, user profiles, account deletion, data export → `"user_data"`
   - Story touches data migrations, destructive operations → `"migrations"`
   - None of the above → `null`

   Derive mechanically from: the story title, In Scope items, acceptance
   criteria triggers, and backing DEC topics. If ANY acceptance criterion
   mentions auth/login/token/session/password, set `"auth"`. If ANY
   mentions payment/charge/invoice/subscription, set `"payments"`. Etc.
   ```

2. Update the HARD-GATE risk tier block to use `risk_domain` instead of
   `category`:
   ```
   **HIGH-RISK:** risk_domain is "auth", "payments", "user_data", or
   "migrations", OR any backing DEC has HARD reversibility, OR any
   backing DEC has SYSTEM scope-risk.
   ```

3. Add `risk_domain` to the required keys in Step 7 validation.

4. Add `risk_domain` to the prd.json entry template.

---

### Finding R3 [MEDIUM]: Step 7 validator checks headings, not schema
**File:** `commands/prd-to-ralph.md`, lines 624-653
**Section:** Step 7 validation

**Current state:** Validator checks: required key presence, passes===false,
tests subkey presence, behavior headings, SHALL substring, non-empty
fail_to_pass. But doesn't check field types, enum validity, array shapes,
or fail_to_pass↔tests correspondence.

**What to change:** Add type/shape validation after the existing checks.
Insert after the existing validation block:

```markdown
**Type and shape validation (Step 7b):**

For each entry, also verify:
1. `id` is a non-empty string matching `^[a-z][a-z0-9-]+$` (kebab-case)
2. `category` is one of: data, layout, ui, crud, settings, interaction
3. `risk_domain` is one of: auth, payments, user_data, migrations, null
4. `description` is a non-empty string
5. `page` is a non-empty string
6. `priority` is a positive integer, unique across all entries
7. `core` is a boolean
8. `passes` is `false` (for new compilations)
9. `tests.unit`, `tests.e2e`, `tests.edge_cases` are arrays (may be empty)
10. Every test object in those arrays has `name` (string), `description`
    (string), and `source` (string matching `DEC-\d+` or known sources)
11. `fail_to_pass` is a non-empty array of strings
12. Every `fail_to_pass` entry corresponds to a test name:
    - Unit test names appear directly
    - E2E test names appear prefixed with `e2e.`
    - Edge case names appear prefixed with `edge.`
13. `external_prerequisites` is a string

If any entry fails type/shape validation, fix it before writing to
prd.json. Log the violation in the manifest.
```

---

### Finding R4 [MEDIUM]: Spec file naming inconsistency
**File:** `commands/prd-to-ralph.md`, lines 402-558
**Section:** Step 5 (spec file generation)

**Current state:** Step 5 says "write `ralph/specs/{story-id}.md`" but
the prd.json entry uses a compiled ID (e.g., `auth-001`), not the
original PRD story ID (`S01`). The build prompt reads
`ralph/specs/{story-id}.md` without clarifying which ID format.

**What to change:**

1. In Step 5, replace `{story-id}` with `{entry['id']}` explicitly:
   ```
   For each compiled entry, write `ralph/specs/{entry['id']}.md` — using
   the COMPILED prd.json ID (e.g., `auth-001`), not the original PRD
   story ID (e.g., `S01`).
   ```

2. Add the original PRD story ID as a field in the spec file header:
   ```
   # Spec: {entry['id']}
   Original PRD Story: {original PRD story ID}
   ```

3. In the validation section (Step 5b), verify the spec file path
   matches: `ralph/specs/{entry['id']}.md` must exist.

---

### Finding R5 [MEDIUM]: --out and --from-existing flags not threaded
**File:** `commands/prd-to-ralph.md`, lines 61-621
**Section:** Throughout

**Current state:** The command documents `--out` and `--from-existing`
flags but every write, validation, and manifest step hardcodes
`ralph/prd.json`.

**What to change:**

1. After the argument parsing section (around line 60), add:
   ```markdown
   **Flag threading:**
   - `--out=<path>`: All references to `ralph/prd.json` below use this
     path instead. The spec directory is derived as `{dirname(out)}/specs/`.
   - `--from-existing`: Read the existing file at the output path first.
     Preserve all entries where `passes:true`. Append new entries. Skip
     any entry whose `id` already exists (no duplicates). Log skipped
     and preserved counts in the manifest.

   Default (no flags): output to `ralph/prd.json`, specs to `ralph/specs/`.
   ```

2. In the manifest template (end of file), add:
   ```
   - Output path: {resolved output path}
   - Existing entries preserved: {count}
   - New entries appended: {count}
   - Duplicates skipped: {count}
   ```

---

## Success Criteria

1. External Prerequisites and Tier fields are extracted, mapped, and validated
2. Risk classification uses `risk_domain` (mechanically derived) instead of unreachable category values
3. Step 7 validates field types, enum values, array shapes, and fail_to_pass↔tests correspondence
4. Spec files use the compiled prd.json ID consistently
5. --out and --from-existing flags are threaded through all paths

## Execution Order

1. R2 (risk_domain field) — adds a new field referenced by R1 and R3
2. R1 (external_prerequisites + tier) — adds fields, updates spec template
3. R3 (schema validation) — validates all fields including new ones
4. R4 (spec file naming) — standalone
5. R5 (flag threading) — standalone

## Commit Message

```
fix(prd-to-ralph): add risk_domain field, schema validation, spec naming consistency, and flag threading

5 findings from Codex adversarial review:
- R1: External Prerequisites and Tier fields now extracted and mapped
- R2: risk_domain field replaces unreachable category-based risk detection
- R3: Step 7 validates field types, enums, array shapes, fail_to_pass↔tests
- R4: Spec files use compiled prd.json ID consistently
- R5: --out and --from-existing flags threaded through all paths

Found by: Codex adversarial review
```
