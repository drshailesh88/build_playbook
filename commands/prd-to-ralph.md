# prd-to-ralph — Compile PRD to Huntley's prd.json format

Mechanically transforms the PRD into the exact flat-array `prd.json`
that Huntley's `build-ralph.sh` expects. After this command, the target
app is ready for Huntley's Ralph loop.

**This is a COMPILER, not an interview.** Every prd.json field is derived
from a specific PRD section via a documented mapping rule. The LLM does
NOT interpret, rephrase, or add to the PRD content. If a mapping rule
cannot extract a value, the field is flagged — never silently filled.

Ralph itself does NOT live in this playbook. You clone/copy his scripts
(`build-ralph.sh`, `qa-ralph.sh`, `build-prompt.md`, `qa-prompt.md`,
`ralph-to-ralph.sh`) from
[github.com/ghuntley/ralph-to-ralph-prod](https://github.com/ghuntley/ralph-to-ralph-prod)
into the target app yourself. This command only builds the structured
input Ralph needs.

Input: `$ARGUMENTS` — optional flags.

## Why This Exists — The Lossy Compression Problem

The PRD has 15+ fields per story: DEC-NNN traceability, risk metadata
(confidence/reversibility/scope-risk), escalation conditions,
counterarguments, predictions, verification anchors, in-scope/out-of-scope.

Huntley's prd.json has ~11 fields. A naive conversion DROPS the metadata
that tells builders where risk lives, when to stop, and what NOT to build.

This compiler solves the gap by injecting critical metadata as structured
blocks inside the `behavior` field — the ONE field the builder reads
most carefully. The prd.json schema stays flat and simple (Huntley's
counting pattern works unchanged). The builder gets full signal.

## Core Principle: Compiler, Not Interviewer

The old version interviewed the user to break features into stories.
That re-introduction of LLM interpretation is exactly what the grill →
PRD pipeline was designed to eliminate.

**This version has ZERO interpretation steps.** The mapping is mechanical:

| PRD Section | prd.json Field | Rule |
|-------------|---------------|------|
| Story ID | `id` | Kebab-case: `{domain}-{NNN}` from story ID |
| Story domain | `category` | Map: data→data, layout/nav→layout, frontend/UI→ui, CRUD→crud, settings→settings, interaction→interaction |
| Story sentence | `description` | Copy story sentence verbatim |
| Screen/Wireframe | `page` | Copy route path, or `"N/A — Backend"` |
| UI brief references | `ui_details` | Extract from UI brief per-module; `"N/A"` for backend |
| **Enriched behavior** | `behavior` | Compiled from 7 PRD sub-sections (see below) |
| Data model references | `data_model` | Copy from Implementation Decisions data section |
| Story ordering | `priority` | Integer from dependency-sorted position |
| Has dependents? | `core` | `true` if other BUILD stories list this as dependency |
| Acceptance criteria + edge cases | `tests` | Structured extraction (see below) |
| Test names from tests field | `fail_to_pass` | Pinned oracle names: `{module}.{feature}.{behavior}` |
| Initial state | `passes` | Always `false` |

## Flags

- `--prd=<path>` — explicit PRD path; default `.planning/PRD.md`.
- `--out=<path>` — output path; default `ralph/prd.json`.
- `--from-existing=<path>` — append to an existing prd.json instead of
  overwriting (useful when a new feature needs to land mid-build).
- `--dry-run` — print compiled entries without writing.

## Preconditions

- A PRD exists at `.planning/PRD.md` (or wherever `--prd` points).
  The PRD MUST have been produced by `/write-a-prd` (decision-backed
  stories with acceptance criteria, verification anchors, etc.).
- `.planning/ui-brief.md` for `ui_details` context (optional but recommended).
- `.planning/CONTEXT.md` for the domain glossary (optional but recommended).

## Process

### Step 1: Read source artifacts

```bash
cat .planning/PRD.md 2>/dev/null          # required
cat .planning/ui-brief.md 2>/dev/null     # for ui_details
cat .planning/ux-brief.md 2>/dev/null     # for behavior context
cat .planning/data-requirements.md 2>/dev/null  # for data_model
cat .planning/CONTEXT.md 2>/dev/null      # for glossary injection
cat .planning/decision-index.md 2>/dev/null     # for risk metadata lookup
```

If the PRD doesn't exist, STOP:
```
ERROR: No PRD found at .planning/PRD.md
This command COMPILES from a PRD — it cannot generate one.
Run /write-a-prd first.
```

### Step 2: Extract BUILD stories from PRD

Read the PRD's Buildable User Stories section. For each story marked
`BUILD`, extract these sections verbatim — do NOT rephrase, summarize,
or interpret:

1. **Story ID** and **Short Title**
2. **Actor** and **Story sentence** ("As a..., I want..., so that...")
3. **Decision Backing** (DEC-NNN list)
4. **Decision Metadata** (lowest confidence, hardest reversibility, widest scope-risk)
5. **In Scope** items (with DEC references)
6. **Out of Scope** items (with DEC references)
7. **Acceptance Criteria** (with DEC references)
8. **Verification Anchors** (Route, Action, UI)
9. **Escalation Conditions**
10. **Completeness Verifiability** description
11. **Notes for Downstream Builders**
12. **Dependencies** on other stories
13. **Screen/Wireframe** reference
14. **Priority** (MUST / SHOULD)

<HARD-GATE>
If ANY BUILD story in the PRD is missing acceptance criteria or decision
backing, STOP. Do not compile an incomplete PRD.

```
COMPILATION BLOCKED: Story [ID] has no acceptance criteria.
A PRD without testable acceptance criteria produces vague prd.json
entries that the builder fills with guesses.

Fix the PRD first: /write-a-prd
```
</HARD-GATE>

### Step 3: Dependency-sort into priority order

1. Build a dependency graph from each story's `Dependencies` field.
2. Topological sort: stories with no dependencies come first.
3. Within the same dependency level, MUST before SHOULD.
4. Assign integer `priority` values (1, 2, 3, ...) from the sorted order.
5. Mark `core: true` for any story that appears in another story's
   dependencies list.

Verify no cycles. If cycles exist, STOP and report:
```
COMPILATION BLOCKED: Circular dependency detected:
  Story S03 → Story S07 → Story S03
Fix the PRD's dependency declarations before compiling.
```

### Step 4: Compile each story into a prd.json entry

For each BUILD story, compile the entry using these exact mapping rules.
**No field may be filled by LLM judgment. Every value traces to a
specific PRD section.**

#### 4a. The `id` field

Convert the PRD story ID to kebab-case with a category prefix:
- `Story S01 - Login API` → `auth-001`
- `Story S05 - Dashboard Layout` → `layout-005`

Category prefix from the story's primary domain. If ambiguous, use the
first module mentioned in the story's In Scope section.

#### 4b. The `category` field

Map to one of Huntley's categories:
- Data/schema/migration → `data`
- Layout/navigation/shell → `layout`
- Frontend/visual/component → `ui`
- CRUD/API/endpoint → `crud`
- Settings/config/preferences → `settings`
- Interaction/workflow/real-time → `interaction`

If a story spans multiple categories, use the primary one (where most
acceptance criteria live).

#### 4c. The `description` field

Copy the story sentence verbatim: "As a [actor], I want [capability],
so that [outcome]."

Do NOT rephrase.

#### 4d. The `page` field

Copy the Screen/Wireframe reference. If the story says `"N/A - backend"`,
use `"N/A — Backend"`.

#### 4e. The `ui_details` field

If `.planning/ui-brief.md` exists and the story's module is covered:
- Extract the relevant typography, color, spacing, component specs
- Include CSS variable references from the brief

If no ui-brief exists or the story is backend: `"N/A"`.

Do NOT invent visual specs.

#### 4f. The `behavior` field (ENRICHED — the critical field)

This is where the metadata that would otherwise be lost gets injected.
Compile the behavior field from 7 PRD sub-sections in this exact
structure:

```markdown
## What This Does
[Copy the story sentence + Business Value from PRD]

## Acceptance Criteria (EARS format)
[Copy EVERY acceptance criterion verbatim from the PRD in EARS format]
- WHEN [trigger] THE SYSTEM SHALL [behavior] (DEC-NNN)
- WHEN [trigger] THE SYSTEM SHALL [behavior] (DEC-NNN)
- IF [error condition] THEN THE SYSTEM SHALL [fallback behavior] (DEC-NNN)

## In Scope
[Copy In Scope items verbatim]
- [Item] (DEC-NNN)

## Out of Scope — DO NOT BUILD THESE
[Copy Out of Scope items verbatim. This section is critical — it tells
the builder what to EXCLUDE.]
- [Item] (DEC-NNN)

## Escalation Conditions — STOP AND ABORT IF
[Copy Escalation Conditions verbatim. The builder must ABORT (not
work around) if any of these trigger.]
- [Condition]
- [Condition]
[If the PRD says "None — proceed autonomously", copy that.]

## Risk Flags
- Decision backing: [DEC-NNN, DEC-NNN, ...]
- Lowest confidence: [HIGH/MEDIUM/LOW]
- Hardest reversibility: [EASY/MODERATE/HARD]
- Widest scope-risk: [LOCAL/MODULE/SYSTEM]
[If LOW confidence or HARD reversibility, copy the PRD's warning:]
- ⚠ [Warning text from PRD about the specific risky DEC]

## Verification Anchors
- Route: [route path]
- Action: [server action / API handler]
- UI: [screen > element description]

## Completeness Check
[Copy the Completeness Verifiability text — this tells the completeness
auditor exactly how to verify this story exists in the running code.]

## Builder Notes
[Copy Notes for Downstream Builders verbatim]
```

<HARD-GATE>
The `behavior` field MUST contain all 7 sections. If the PRD story is
missing a section, use the appropriate empty marker:

- Missing acceptance criteria: COMPILATION BLOCKED (see Step 2 gate)
- Missing out-of-scope: `## Out of Scope — DO NOT BUILD THESE\nNone declared.`
- Missing escalation conditions: `## Escalation Conditions — STOP AND ABORT IF\nNone — proceed autonomously.`
- Missing risk flags: Extract from decision-index.md using the DEC-NNN IDs
- Missing verification anchors: `## Verification Anchors\nNone declared — auditor should verify via acceptance criteria.`
- Missing completeness check: `## Completeness Check\nVerify acceptance criteria pass from the running app.`
- Missing builder notes: `## Builder Notes\nNone.`
</HARD-GATE>

#### 4g. The `data_model` field

From the PRD's Implementation Decisions section, extract the schema/data
references relevant to this story. If the story's DEC-NNN IDs include
data-grill decisions, reference the relevant data subjects.

If no data model is relevant: `"N/A"`.

#### 4h. The `tests` field

Compile from the PRD's acceptance criteria and verification anchors:

```json
{
  "unit": [
    {
      "name": "[test name derived from acceptance criterion]",
      "description": "[the acceptance criterion text]",
      "input": "[implied input from the criterion]",
      "expected_output": "[the observable outcome from the criterion]",
      "source": "[DEC-NNN that backs this criterion]"
    }
  ],
  "e2e": [
    {
      "name": "[end-to-end scenario name]",
      "steps": ["[step 1 from verification anchors]", "[step 2]"],
      "expected": "[expected outcome]",
      "source": "[DEC-NNN]"
    }
  ],
  "edge_cases": [
    {
      "name": "[edge case from Builder Notes or Out of Scope boundaries]",
      "steps": ["[trigger the edge case]"],
      "expected": "[expected behavior at the boundary]",
      "source": "[DEC-NNN if applicable]"
    }
  ]
}
```

**Mapping rules for tests:**
- Each acceptance criterion → at least 1 unit test
- Each verification anchor with a Route → at least 1 e2e test
- Each Out of Scope item → at least 1 edge_case test (verify the
  builder did NOT build it)
- Each Escalation Condition → at least 1 edge_case test (verify the
  boundary is respected)

The `source` field traces each test back to a decision. This is how
the QA agent knows WHY each test exists.

#### 4i. The `fail_to_pass` field (test oracle)

Pin the exact test names the builder MUST use. This is the deterministic
oracle — QA verifies these specific test names exist and pass.

```json
"fail_to_pass": [
  "auth.login.returns-jwt-on-valid-credentials",
  "auth.login.rejects-expired-token",
  "auth.login.rate-limits-after-5-failures"
]
```

**Naming convention:** `{module}.{feature}.{behavior-in-kebab-case}`

Generate one `fail_to_pass` entry per:
- Each unit test in `tests.unit` → use the `name` field
- Each e2e test in `tests.e2e` → use the `name` field prefixed with `e2e.`
- Each edge case in `tests.edge_cases` → use the `name` field prefixed with `edge.`

The builder MUST name its test files and test descriptions to match
these entries. The QA agent verifies the exact names exist in the test
suite output.

### Step 4j. Checkpoint gate — validate compiled entry before continuing

After compiling EACH story entry, validate it immediately before moving
to the next story. Do not batch all stories then validate at the end.

```python
def validate_entry(entry, idx):
    errors = []
    beh = entry.get('behavior', '')
    for section in ['## Acceptance Criteria', '## Out of Scope', '## Escalation Conditions',
                    '## Risk Flags', '## Verification Anchors', '## Completeness Check', '## Builder Notes']:
        if section not in beh:
            errors.append(f'entry {idx} ({entry.get("id","?")}) missing behavior section: {section}')
    if not entry.get('fail_to_pass'):
        errors.append(f'entry {idx} ({entry.get("id","?")}) has empty fail_to_pass')
    for t in entry.get('tests', {}).get('unit', []):
        if not t.get('source'):
            errors.append(f'entry {idx} ({entry.get("id","?")}) test "{t.get("name","?")}" missing DEC source')
    # EARS format check: at least one AC uses WHEN/SHALL or IF/THEN
    ac_section = beh.split('## Acceptance Criteria')[1].split('##')[0] if '## Acceptance Criteria' in beh else ''
    if ac_section and 'SHALL' not in ac_section and 'SHALL' not in ac_section.upper():
        errors.append(f'entry {idx} ({entry.get("id","?")}) acceptance criteria not in EARS format (missing SHALL)')
    return errors
```

If any entry fails the checkpoint, STOP and report. Do not write
partial prd.json with some entries valid and others broken.

### Step 5: Generate per-story spec files (full-spec-per-iteration)

For each compiled story, write a standalone spec file that contains the
FULL PRD story text — uncompressed, with all context a builder needs.

```bash
mkdir -p ralph/specs
```

For each story entry, write `ralph/specs/{story-id}.md`:

```markdown
# Spec: {story-id} — {description}

## Original PRD Story Text
[Copy the ENTIRE PRD story section verbatim — all fields, all sections,
all decision backing, all risk metadata. This is the FULL context.]

## Decision Records (referenced by this story)

[For each DEC-NNN referenced in this story's acceptance criteria,
escalation conditions, risk flags, or builder notes, find the full
record in `.planning/decisions/` files or `.planning/grill-log.md`
and include it here.]

### DEC-NNN: [short title]
- **Selected:** [what was decided]
- **Rationale:** [why, in the user's words]
- **Options Considered:**
  1. [Option A] — [tradeoff]
  2. [Option B] — [tradeoff]
- **Counterargument:** [strongest genuine attack on the selected option]
- **Confidence:** [HIGH/MEDIUM/LOW]
- **Reversibility:** [EASY/MODERATE/HARD]
- **Scope-Risk:** [LOCAL/MODULE/SYSTEM]
- **Consequences:**
  - Enables: [what this unlocks]
  - Constrains: [what this limits]
  - Rollback plan: [how to undo]

[Repeat for each referenced DEC. If a DEC record cannot be found in
.planning/ files, note: "DEC-NNN: record not found in .planning/ —
see PRD for inline reference only."]

## Data Model Context
[IF this story's `data_model` field is NOT "N/A", extract the relevant
data subject sections from `.planning/data-requirements.md`.]

### Subject: [name]
- **Lifecycle:** Created by [who]. [Deletion behavior]. History: [yes/no].
- **Ownership:** Belongs to [scope]. Sharing: [model]. Access levels: [list].
- **Content:** Contains [list]. Cascade on delete: [behavior].
  Shared references: [yes/no]. Ordering: [method].
- **Limits:** Max per user: [N]. Size: [limit]. Name rules: [rules].
- **Billing:** [impact or "none"]

### Relationships involving [subject]
| Subject A | Relationship | Subject B | On Delete A | On Delete B |
|-----------|-------------|-----------|-------------|-------------|
| [A] | [rel] | [B] | [behavior] | [behavior] |

[IF `data_model` is "N/A", omit this entire section.]

## UX Context
[IF this story's `page` field is NOT "N/A — Backend", extract the
relevant per-module UX decisions from `.planning/ux-brief.md`.]

- **Model:** [Bear / Wizard / Hybrid]
- **Empty state:** [treatment]
- **Primary actions (top 3):** [list]
- **Loading:** [pattern]
- **Feedback:** [mechanism]
- **Error handling:** [approach]

[IF the story is backend-only, omit this section.]

## UI Context
[IF this story's `category` is "ui" or "layout", OR if `page` is not
"N/A — Backend", extract relevant visual specs from `.planning/ui-brief.md`.]

- **Component style:** Buttons: [style]. Inputs: [style]. Icons: [style].
- **Spacing:** Base unit: [px]. Border radius: [px].
- **Typography:** [font] at [size], line-height [ratio].
- **Key CSS variables:**
  ```
  --accent: [hex]; --bg-primary: [hex]; --radius: [px];
  --space-unit: [px]; --font-body: '[font]';
  ```

[IF the story is backend-only with no UI component, omit this section.]

## Infrastructure Context
[IF this story's acceptance criteria reference file uploads, performance
thresholds, response time expectations, or scaling behavior, extract
relevant constraints from `.planning/infra-requirements.md`.]

- **Response time:** [expectation]
- **File limits:** [size/type constraints]
- **Scaling:** [relevant projection]

[IF no infra constraints are relevant, omit this section.]

## Compiled prd.json Entry Reference
id: {id}
priority: {priority}
category: {category}
fail_to_pass: {fail_to_pass list}

## Domain Glossary (if applicable)
[Terms from CONTEXT.md that appear in this story]
```

**Section inclusion rules:** Only include a domain context section if
the story touches that domain. A backend CRUD story gets Decision Records
and Data Model Context but NOT UX/UI Context. A frontend layout story gets
Decision Records, UX Context, and UI Context but NOT Data Model Context.
Never include empty sections — omit the heading entirely if the story
doesn't need it.

**Size budget:** Each domain section adds 20-40 lines. A story touching
all four domains (rare) adds ~120 lines. Most stories touch 1-2 domains.
This is well within context budget since only one spec file is read per
iteration.

The build-prompt instructs the builder to read
`ralph/specs/{story-id}.md` for full context when the compressed
`behavior` field in prd.json isn't sufficient. This is the
full-spec-per-iteration pattern — the builder always has access to
the uncompressed original, the full decision records, and the relevant
domain context.

### Step 5a: Inject domain glossary

If `.planning/CONTEXT.md` exists, extract glossary terms that appear in
the compiled entries. Append a glossary block to the FIRST entry's
`behavior` field and to each `ralph/specs/{id}.md` file:

```markdown
## Domain Glossary (applies to all stories)
| Term | Definition | Source |
|------|-----------|--------|
| [term] | [definition] | DEC-NNN |
```

This ensures the builder has precise definitions without needing to
read .planning/ files.

### Step 5b: Checkpoint gate — validate glossary + spec files + decision context

Before writing prd.json, verify:
1. Every glossary term referenced in behavior fields has a definition
   (either in the FIRST entry's glossary block or in the spec file).
2. Every `ralph/specs/{id}.md` file exists for each compiled entry.
3. Every `fail_to_pass` entry matches a test name in the `tests` field.
4. Every DEC-NNN referenced in the story's behavior field has a
   corresponding entry in the spec file's `## Decision Records` section.
5. Every spec file with `data_model != "N/A"` has a `## Data Model Context`
   section (unless `.planning/data-requirements.md` doesn't exist).
6. Every spec file with `page != "N/A — Backend"` has a `## UX Context`
   section (unless `.planning/ux-brief.md` doesn't exist).

```python
import re

for entry in entries:
    spec_path = f"ralph/specs/{entry['id']}.md"
    assert os.path.exists(spec_path), f"Missing spec file: {spec_path}"

    spec_content = open(spec_path).read()

    # fail_to_pass ↔ tests alignment
    ftp = set(entry.get('fail_to_pass', []))
    test_names = set()
    for t in entry.get('tests', {}).get('unit', []):
        test_names.add(t['name'])
    for t in entry.get('tests', {}).get('e2e', []):
        test_names.add(f"e2e.{t['name']}")
    for t in entry.get('tests', {}).get('edge_cases', []):
        test_names.add(f"edge.{t['name']}")
    orphans = ftp - test_names
    assert not orphans, f"fail_to_pass entries without matching tests: {orphans}"

    # Decision record coverage
    beh = entry.get('behavior', '')
    dec_refs = set(re.findall(r'DEC-\d+', beh))
    for dec_id in dec_refs:
        assert dec_id in spec_content, \
            f"spec {entry['id']}: {dec_id} referenced in behavior but missing from Decision Records section"

    # Domain context presence (conditional)
    if entry.get('data_model', 'N/A') != 'N/A':
        if os.path.exists('.planning/data-requirements.md'):
            assert '## Data Model Context' in spec_content, \
                f"spec {entry['id']}: data_model is set but no Data Model Context section"
    if entry.get('page', 'N/A') != 'N/A — Backend':
        if os.path.exists('.planning/ux-brief.md'):
            assert '## UX Context' in spec_content, \
                f"spec {entry['id']}: page is set but no UX Context section"
```

### Step 6: Write `ralph/prd.json` as a flat array

```bash
mkdir -p ralph
# Write the compiled entries
python3 -c "
import json, sys
entries = json.load(sys.stdin)
assert isinstance(entries, list), 'must be flat array'
with open('ralph/prd.json', 'w') as f:
    json.dump(entries, f, indent=2)
print(f'Wrote {len(entries)} entries to ralph/prd.json')
"
```

<HARD-GATE>
Output MUST be a flat array. Any wrapper object breaks Huntley's
counting pattern. Do not emit `{ "userStories": [...] }` or
`{ "items": [...] }` — the top-level JSON value MUST be `[ ... ]`.
</HARD-GATE>

### Step 7: Sanity-check the shape AND content

Run a validator that checks BOTH structural shape and content quality:

```bash
python3 -c "
import json
d = json.load(open('ralph/prd.json'))
assert isinstance(d, list), 'prd.json must be a flat array'

required = {'id','category','description','page','ui_details','behavior','data_model','priority','core','passes','tests','fail_to_pass'}
test_keys = {'unit','e2e','edge_cases'}
behavior_sections = ['## Acceptance Criteria', '## Out of Scope', '## Escalation Conditions', '## Risk Flags', '## Verification Anchors', '## Completeness Check', '## Builder Notes']

errors = []
for i, entry in enumerate(d):
    missing = required - set(entry.keys())
    if missing:
        errors.append(f'entry {i} missing keys: {missing}')
    if entry.get('passes') is not False:
        errors.append(f'entry {i} must start with passes=false')
    if 'tests' in entry:
        tmissing = test_keys - set(entry['tests'].keys())
        if tmissing:
            errors.append(f'entry {i} tests missing {tmissing}')
    # Content quality: check behavior has structured sections
    beh = entry.get('behavior', '')
    for section in behavior_sections:
        if section not in beh:
            errors.append(f'entry {i} ({entry.get(\"id\",\"?\")}) behavior missing section: {section}')
    # EARS format: acceptance criteria must contain at least one SHALL
    ac_start = beh.find('## Acceptance Criteria')
    if ac_start >= 0:
        ac_end = beh.find('##', ac_start + 1)
        ac_text = beh[ac_start:ac_end] if ac_end > ac_start else beh[ac_start:]
        if 'SHALL' not in ac_text:
            errors.append(f'entry {i} ({entry.get(\"id\",\"?\")}) acceptance criteria not in EARS format (missing SHALL keyword)')
    # fail_to_pass must not be empty
    if not entry.get('fail_to_pass'):
        errors.append(f'entry {i} ({entry.get(\"id\",\"?\")}) has empty or missing fail_to_pass')

if errors:
    for e in errors:
        print(f'ERROR: {e}')
    raise SystemExit(1)
print(f'OK: {len(d)} entries, all shape-valid, all behavior sections present')
"
```

Abort on ANY error. Do not proceed with a structurally incomplete prd.json.

### Step 8: Write the compilation manifest

Save a manifest alongside prd.json so the pipeline is auditable:

```bash
cat > ralph/compilation-manifest.md << 'EOF'
# prd.json Compilation Manifest
**Compiled at:** [ISO timestamp]
**Source PRD:** [path]
**PRD decision count:** [N] decisions compiled
**Stories compiled:** [N] BUILD stories

## Compilation Map
| prd.json ID | PRD Story | DEC Backing | Risk Level | Escalation? |
|-------------|-----------|-------------|------------|-------------|
| [id] | Story [ID] | DEC-NNN, ... | [HIGH/MED/LOW risk] | [yes/no] |

## Glossary injected: [yes/no] ([N] terms)
## UI brief used: [yes/no]
## UX brief used: [yes/no]
## Data requirements used: [yes/no]
## Infra requirements used: [yes/no]

## Spec File Enrichment
- Decision records injected: [N] unique DEC records across [N] spec files
- Data model context: [N] spec files enriched (stories with data_model != N/A)
- UX context: [N] spec files enriched (stories with page != N/A — Backend)
- UI context: [N] spec files enriched (ui/layout category stories)
- Infra context: [N] spec files enriched (stories referencing perf/upload/scaling)

## Verification
- Shape validation: PASSED
- Content validation: PASSED (all behavior sections present)
- EARS format: PASSED (all AC use WHEN/SHALL or IF/THEN)
- Dependency sort: [N] stories, 0 cycles
- Test coverage: [N] unit, [N] e2e, [N] edge_case skeletons
- fail_to_pass oracles: [N] total test names pinned
- Spec files: [N] files in ralph/specs/
- Decision record coverage: PASSED (all DEC refs in behavior have spec entries)
- Domain context coverage: PASSED (data/UX/UI sections present where needed)
- Checkpoint gates: 2/2 passed (per-entry + pre-write)
EOF
```

### Step 9: Print the handoff message

```
✅ ralph/prd.json compiled — N entries, all passes=false.
   Compilation mode: DETERMINISTIC (zero LLM interpretation)
   Every behavior field contains: acceptance criteria, out-of-scope,
   escalation conditions, risk flags, verification anchors.

   Manifest: ralph/compilation-manifest.md

You're ready for Ralph.

Next steps:
  1. Scaffold the Ralph scripts + prompts:
       /playbook:scaffold-ralph

  2. Customize ralph/build-prompt.md and ralph/qa-prompt.md — fill in the
     CUSTOMIZE sections with your app's module paths, quality-check commands,
     locked paths, and app-specific rules.

  3. (Optional) Add Slack/Linear progress monitoring in a second terminal:
       /playbook:ralph-watch

  4. Run the full three-layer flow:
       ./ralph/run.sh

  5. Then run YOUR hardened QA pipeline (the ungameable judge):
       /playbook:install-qa-harness
       /playbook:define-quality-contracts
       npm run qa:baseline
       npm run qa:run
```

## Rules

- NEVER wrap the array in an object. Top-level JSON value is `[...]`.
- NEVER set `passes: true` on initial write.
- NEVER invent features the PRD doesn't mention.
- NEVER rephrase, summarize, or interpret PRD content. Copy verbatim.
- NEVER fill a field with LLM judgment. Every value traces to a PRD section.
- NEVER skip the behavior enrichment. All 7 sections are mandatory.
- NEVER compile a story that lacks acceptance criteria — block compilation.
- ALWAYS include the `source` field in test skeletons linking to DEC-NNN.
- ALWAYS sort by priority ascending. Core dependencies come first.
- ALWAYS keep `behavior` long enough (all 7 sections) that Ralph doesn't
  need to ask follow-up questions.
- ALWAYS write the compilation manifest for auditability.
- ALWAYS write `ralph/specs/{id}.md` per-story spec files.
- ALWAYS generate `fail_to_pass` test oracle names for every story.
- ALWAYS use EARS format (WHEN/SHALL, IF/THEN) for acceptance criteria.
- ALWAYS run checkpoint gates after each compiled entry AND before write.

## Compilation vs the old interview approach

| Aspect | Old (interview) | New (compiler) |
|--------|-----------------|---------------|
| LLM interpretation | Re-interprets PRD stories | Zero — copies verbatim |
| Risk metadata | Lost | Injected into behavior field |
| Escalation conditions | Lost | Injected into behavior field |
| Out-of-scope | Compressed/lost | Explicit section in behavior |
| DEC traceability | Lost | In risk flags + test sources |
| Verification anchors | Lost | Explicit section in behavior |
| Domain glossary | Lost | Injected into first entry |
| Acceptance criteria | Rewritten as prose | Copied verbatim with DEC refs |
| Determinism | Low (LLM judgment) | High (documented mapping rules) |
| Test oracle | None (builder names tests freely) | fail_to_pass pins exact names |
| AC format | Prose | EARS (WHEN/SHALL, IF/THEN) |
| Full spec access | Lost after compression | ralph/specs/{id}.md per story |
| Decision rationale | Lost (only DEC-NNN refs survive) | Full DEC records in spec files |
| Data model context | One-line reference | Structured lifecycle/ownership/limits in spec |
| UX/UI context | Compressed extract | Per-module UX + CSS variables in spec |
| Validation | End-to-end only | Checkpoint gates per-entry + pre-write |
| Auditability | None | Compilation manifest |

## Integration with the playbook

- Runs after `/write-a-prd` produces `.planning/PRD.md`.
- Runs after `/playbook:define-quality-contracts` — both consume the
  PRD, but produce different artifacts.
- After Ralph finishes, the user runs `/playbook:wire-selectors` per
  feature to reconcile selectors.
- Then `/playbook:qa-run` enforces the contracts against the built app.

## Not in scope

- Ralph's build loop, QA loop, watchdog, or progress monitoring.
- The compilation does not VALIDATE the PRD's quality — that's
  `/write-a-prd`'s job (quality gate, cross-reference verification).
  This compiler assumes the PRD is already validated and complete.
