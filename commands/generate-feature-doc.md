# Generate Feature Doc

Generate a feature testing document for a module by reading GSD plan/summary files AND inspecting actual code. Never hallucinate features — only document what provably exists.

Module to document: $ARGUMENTS

## Why This Exists

Previously, feature docs were written AFTER the app was built by asking LLMs to reverse-engineer what exists. This took 5 passes across multiple LLMs with hallucinations in each. This command eliminates that by generating docs from two sources of truth: GSD artifacts (what was planned and built) and AST extraction (what actually exists in code).

Adapted from:
- shinpr's recipe-reverse-engineer — scope discovery → generation → code verification → review → revision loop (max 2 cycles)
- an existing `/doc-feature` command — AST extractor produces machine-verified feature lists with exact file:line references

## Process

### Phase 1: Gather Source Truth (Two Independent Sources)

**Source A — GSD Artifacts (what was intended):**

Read these files for the module (if they exist):
```
.planning/phases/*-PLAN.md         → Planned features and tasks
.planning/phases/*-SUMMARY.md      → What was actually built per task
.planning/REQUIREMENTS.md          → Original requirements
.planning/phases/*-CONTEXT.md      → Implementation decisions
```

Extract:
- Every planned feature/behavior from PLAN files
- Every completed task from SUMMARY files  
- Every acceptance criterion from REQUIREMENTS
- Every design decision from CONTEXT files

**Source B — Code Inspection (what actually exists):**

Check if the AST extractor exists:
```bash
test -f e2e/pipeline/extract-features.cjs && echo "EXISTS" || echo "MISSING"
```

If AST extractor EXISTS:
```bash
node e2e/pipeline/extract-features.cjs $ARGUMENTS
```
Read `e2e/extracted/$ARGUMENTS/raw-extraction.json` and `e2e/extracted/$ARGUMENTS/import-tree.json`.

If AST extractor MISSING, do manual code inspection using a subagent:
```
subagent_type: Explore
prompt: |
  Analyze the module at src/app/(app)/$ARGUMENTS/ and its components.
  List every:
  - User-visible feature (buttons, forms, panels, actions)
  - API route called
  - State variable and its effect on UI
  - Conditional rendering (what shows/hides and when)
  - Error states and empty states
  - Keyboard shortcuts and accessibility features
  Report with exact file paths and line numbers.
```

### Phase 2: Cross-Reference and Merge

Create a merged feature list where each item has:
- **Feature description** (behavior language, not code language)
- **Source**: `planned` (from GSD only), `built` (from code only), or `both` (in GSD and code)
- **File reference**: exact path:line from extraction

Flag discrepancies:
- `planned but not built` — feature in GSD plan but not found in code
- `built but not planned` — feature in code but not in any GSD artifact (scope creep or emergent feature)

### Phase 3: Write the Feature Doc

Create or update `${ARGUMENTS.toUpperCase()}_FEATURES_TESTING.md` in the repo root.

Structure (matching the existing feature doc format):

```markdown
# [Module Name] — Feature Testing Document

> Auto-generated from GSD artifacts + code inspection on [date]
> Source: .planning/ artifacts + AST extraction
> Module: src/app/(app)/$ARGUMENTS/

## Feature Summary
- Total features: [N]
- From GSD plans: [N] | From code inspection: [N] | Both: [N]
- Planned but not built: [N] (flagged below)

## Features

### [Category — e.g., "Page Load & Layout"]

- [ ] **[Feature description]** — [file_path:line]
  - [Specific testable behavior]
  - [Expected state/outcome]

### [Next Category]

- [ ] ...

## Discrepancies

### Planned But Not Built
_Features in GSD plans that were not found in code:_
- [ ] [Feature] — Source: [plan file]

### Built But Not Planned  
_Features found in code with no corresponding GSD plan:_
- [ ] [Feature] — Source: [file:line]

## Components Rendered on This Route
_From import tree (if AST extraction was used):_
- [Component] — [file_path]

## Components NOT Rendered on This Route
_Exist in codebase but not in this module's import tree:_
- [Component] — [file_path]
```

### Phase 4: Verification (Adapted from shinpr's consistency scoring)

After writing, score the document:

```
Consistency Score = (features with file:line references) / (total features) × 100
```

Quality gate:
- **Score ≥ 80**: Document is trustworthy. Proceed.
- **Score 60-80**: Some features lack code references. Flag them and ask user: "These [N] features don't have code references. Should I investigate further or mark them as unverified?"
- **Score < 60**: Too many unverified claims. Re-run code inspection with deeper exploration. Maximum 2 revision cycles (from shinpr's loop control).

### Phase 5: Commit and Report

```bash
git add ${ARGUMENTS.toUpperCase()}_FEATURES_TESTING.md
git commit -m "docs: auto-generate feature doc for $ARGUMENTS from GSD + code"
```

Report:
```
📝 Feature doc generated: [FILENAME]
   Features documented: [N] (planned: [N], built: [N], both: [N])
   Consistency score: [XX]%
   Discrepancies: [N] planned-not-built, [N] built-not-planned
   
   Next: Use these as specs for QA testing and E2E generation.
```

## Rules

- **ONLY document what you can prove exists** — if it's not in GSD artifacts AND not in code, it does not exist
- **NEVER infer features from component names** — "CitationPanel" does not mean "citations work." Inspect the actual handlers, state, and API calls.
- **NEVER write features without file references** unless explicitly marking them as "unverified"
- **DO cross-reference both sources** — GSD plans tell you intent, code tells you reality. Both are needed.
- **Max 2 revision cycles** — if the doc still has low consistency after 2 attempts, flag for human review (don't loop forever)
- Follow the existing feature doc format (checkboxes, categories, file:line references) for consistency with existing docs
