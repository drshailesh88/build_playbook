# Census to Specs — Convert Feature Inventory into Test Specifications

Convert a Feature Census document into structured spec files ready for Playwright-based testing. Each feature becomes a testable checkpoint with clear pass/fail criteria.

Module: $ARGUMENTS (module name — must have a `feature-census/<module>/CENSUS.md` already generated)

## Why This Exists

The Feature Census tells you WHAT the module can do. This command converts that into HOW to test each capability. The output format is structured markdown that can be mechanically converted into Playwright tests — no interpretation needed.

Adapted from a production spec format (hundreds of specs, thousands of checkpoints across multiple modules) — proven at scale.

## Process

### Step 1: Read the Census

```bash
cat feature-census/$ARGUMENTS/CENSUS.md
```

If it doesn't exist, tell the user: "No census found. Run `/feature-census $ARGUMENTS` first."

Also read `feature-census/$ARGUMENTS/merged.json` for the raw data with file:line references.

### Step 2: Group Features into Specs

Each spec file covers one logical section (~25-40 checkpoints). Group by the categories in the Census:

```
Text Formatting      → spec-001.md
Editor Actions       → spec-002.md
Navigation           → spec-003.md
API Interactions     → spec-004.md
State & Data Display → spec-005.md
Error & Empty States → spec-006.md
File Operations      → spec-007.md
Keyboard Shortcuts   → spec-008.md
... (more as needed)
```

If a category has more than 40 features, split into multiple specs (spec-001a, spec-001b or just sequential numbers).

### Step 3: Generate Spec Files

Create directory: `qa/specs/<module>/`

Each spec file follows this exact format:

```markdown
# <module> — Spec NNN

STATUS: PENDING
TESTED: 0/<total>
PASS: 0
FAIL: 0
BLOCKED: 0
PAGE: http://localhost:3000/<route>
MODULE: <module>

---
### <Category Name>
#### <Subcategory if needed>
- [ ] **<Feature name>** — <what to verify, specific and observable>
- [ ] **<Feature name>** — <what to verify>
- [ ] **<Feature name>** — <what to verify>
```

### Step 4: Checkpoint Writing Rules

Each checkbox line is a checkpoint. Follow these rules:

**DO — Good checkpoints:**
```markdown
- [ ] **Bold text toggle** — select text, click Bold button or press Ctrl+B, verify text renders with <strong> tag
- [ ] **Placeholder text** — when editor is empty, shows "Start writing..." placeholder text
- [ ] **Character count** — bottom status bar displays live character count that updates as you type
- [ ] **Table insert** — slash command "/table" inserts a 3x3 table with header row
- [ ] **Drag-drop file upload** — drag a PDF onto the upload zone, verify file appears in upload list
```

**DON'T — Bad checkpoints:**
```markdown
- [ ] Editor works                           # Too vague — WHAT works?
- [ ] Bold functionality is implemented      # Describes code, not user behavior
- [ ] The useState hook manages bold state   # Tests implementation, not behavior
- [ ] Verify the BoldExtension is registered # Not user-visible
```

**Rule: Every checkpoint must be verifiable by a human clicking through the app OR by Playwright automating the browser. If a human can't see it, it's not a checkpoint.**

### Step 5: Tag Source and Status

For each checkpoint, append the source tag from the census:

```markdown
- [ ] **Bold text toggle** — select text, press Ctrl+B, verify bold formatting `[CONFIRMED]`
- [ ] **Smart quotes** — type "hello" and verify curly quotes render `[EMERGENT: @tiptap/extension-typography]`
- [ ] **Export as DOCX** — click Export > Word, verify .docx file downloads `[CONFIRMED]`
- [ ] **Undo stack** — press Ctrl+Z after typing, verify text reverts `[EMERGENT: StarterKit/History]`
```

Status tags:
- `[CONFIRMED]` — found in 2+ census layers. Highest priority test target.
- `[EMERGENT]` — from a library, not explicitly coded. Include library name. Must test — these are the features that break silently.
- `[CODE-ONLY]` — in code but not seen at runtime. Lower priority — may be conditional or behind a flag.
- `[RUNTIME-ONLY]` — seen at runtime but no code match. Test to confirm it's real behavior.

### Step 6: Generate the Queue File

Create `qa/queue.jsonl` (or append if it exists):

```jsonl
{"id":"<module>.spec-001","module":"<module>","spec_file":"qa/specs/<module>/spec-001.md","priority":1,"status":"pending","checkpoints":<count>,"page_url":"http://localhost:3000/<route>","attempts":0,"max_attempts":3}
{"id":"<module>.spec-002","module":"<module>","spec_file":"qa/specs/<module>/spec-002.md","priority":2,"status":"pending","checkpoints":<count>,"page_url":"http://localhost:3000/<route>","attempts":0,"max_attempts":3}
```

### Step 7: Report

```
📋 SPECS GENERATED
━━━━━━━━━━━━━━━━━
Module: <module>
Specs created: <N> files
Total checkpoints: <N>
  CONFIRMED: <N> (high priority)
  EMERGENT: <N> (must test — from libraries)
  CODE-ONLY: <N> (lower priority)
  RUNTIME-ONLY: <N> (verify behavior)

Files: qa/specs/<module>/spec-001.md through spec-NNN.md
Queue: qa/queue.jsonl updated with <N> entries

Next: Run `/spec-runner <module>` to execute tests
      Or `/harden <module>` to run the full self-annealing pipeline
```

### Step 8: Commit

```bash
git add qa/specs/$ARGUMENTS/ qa/queue.jsonl
git commit -m "specs: generate test specs for $ARGUMENTS — <N> checkpoints from feature census"
```

## Rules

- ONLY create checkpoints for features found in the census — no inventing tests for imagined features
- Every checkpoint must describe OBSERVABLE USER BEHAVIOR — not code internals
- Emergent features (from libraries) MUST become checkpoints — these are the features that break without anyone noticing
- Keep checkpoint descriptions under 120 characters — they need to fit in test output
- Include the page URL in every spec header — Playwright needs to know where to navigate
