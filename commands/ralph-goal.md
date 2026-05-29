# ralph-goal — Generate `/goal` conditions from prd.json stories

Generates a complete Claude Code `/goal` condition for a single Ralph
story. The condition is optimized for the Worker/Judge pattern: measurable
end state, explicit check instructions, constraints as prohibitions, and
a turn limit.

Input: `$ARGUMENTS` — the story ID from ralph/prd.json (e.g. `auth-001`).

## Why /goal instead of build.sh

`build.sh` loops externally: bash calls `claude -p` per iteration, parses
promise tags, and decides whether to continue. Each iteration gets a fresh
context window — no memory of prior attempts.

`/goal` loops INTERNALLY: Claude Code's Worker (Opus) works continuously
within a single context window while a Judge (Haiku) evaluates completion
after each turn. The worker retains full context across turns — it
remembers what it tried, what failed, and what worked.

**When to use `/goal`:** Single stories, debugging stuck stories, stories
that need deep context (multi-file changes, complex dependencies).

**When to use `build.sh`:** Overnight batch runs, full PRD builds, when
you want external circuit breakers and logging.

## The Judge's Constraints

The judge (Haiku) has these limitations — the goal condition must work
within them:

1. **Model-only**: The judge cannot run commands. It only evaluates what
   the worker surfaced in the conversation transcript.
2. **Reads CLAUDE.md every tick**: Keep CLAUDE.md under 200 lines. Use
   `ralph/CLAUDE.goal.md` (lean version) during goal runs.
3. **4,000 char limit**: Goal conditions must be concise.
4. **Pattern-matching**: The judge looks for evidence of completion in
   the transcript — test output, commit messages, file changes.

**Compensating with Stop hooks**: Since the judge can't run commands,
a Stop hook (`goal-acceptance-gate.sh`) runs deterministic checks after
each worker turn and feeds results back into the transcript. The judge
sees these results and uses them for evaluation.

## Process

### Step 1: Read the story

```bash
cat ralph/prd.json
```

Find the entry matching `$ARGUMENTS`. If not found:
```
ERROR: Story '$ARGUMENTS' not found in ralph/prd.json.
Available stories: [list IDs]
```

If the story already has `passes: true`:
```
Story '$ARGUMENTS' already passes. Nothing to build.
To re-verify, run /playbook:ralph-goal-qa $ARGUMENTS
```

### Step 2: Extract goal components

From the prd.json entry, extract:

```python
import json

prd = json.load(open('ralph/prd.json'))
story = next(s for s in prd if s['id'] == STORY_ID)

# Components for the goal condition
story_id = story['id']
description = story['description']
fail_to_pass = story.get('fail_to_pass', [])
behavior = story.get('behavior', '')

# Parse structured sections from behavior
import re

def extract_section(text, heading):
    pattern = rf'## {re.escape(heading)}\s*\n(.*?)(?=\n## |\Z)'
    match = re.search(pattern, text, re.DOTALL)
    return match.group(1).strip() if match else ''

acceptance_criteria = extract_section(behavior, 'Acceptance Criteria')
out_of_scope = extract_section(behavior, 'Out of Scope — DO NOT BUILD THESE')
escalation = extract_section(behavior, 'Escalation Conditions — STOP AND ABORT IF')
verification_anchors = extract_section(behavior, 'Verification Anchors')
```

### Step 3: Generate the goal condition

Compose the goal condition under 4,000 characters using this template:

```
Build story {story_id} from ralph/prd.json: "{description}"

SUCCESS — all must be true:
1. These tests exist and pass (run `npm run test:run -- --reporter=verbose` and show output):
{fail_to_pass list, one per line, prefixed with "   - "}
2. `npx tsc --noEmit` exits 0 (run it and show output)
3. `npm run lint --if-present` exits 0 (run it and show output)
4. ralph/prd.json entry {story_id} has passes:true
5. ralph/progress.txt has a dated entry for {story_id}
6. A git commit with prefix "RALPH: {story_id}" exists

CONSTRAINTS — never violate:
- Read ralph/build-prompt.md for methodology (TDD-first, one story only)
- Read ralph/specs/{story_id}.md for full spec context (if it exists)
- Read CLAUDE.md for project rules
- Never modify locked files: .quality/**, e2e/contracts/**, vitest.config.ts, playwright.config.ts, tsconfig.json, .claude/settings.json, .claude/hooks/**, ralph/*.sh, ralph/*-prompt.md
- Out of scope — DO NOT build: {out_of_scope items}
- ABORT if: {escalation conditions}

VERIFICATION — after each significant change, run and show the output:
  npm run test:run && npx tsc --noEmit

Stop after 30 turns if not complete.
```

**Size management**: If the condition exceeds 3,800 chars (leaving buffer):
1. Truncate out_of_scope to first 3 items + "... and N more (see behavior field)"
2. Truncate escalation to first 2 items + "... see behavior field"
3. Truncate fail_to_pass to first 8 items + "... and N more"

### Step 4: Generate the goal-qa condition

Also generate a QA goal condition for the same story:

```
QA story {story_id} from ralph/prd.json: "{description}"

You are an INDEPENDENT QA evaluator. The builder claims this is done.
Verify from first principles.

SUCCESS — all must be true:
1. These pinned tests exist and pass (show verbose output):
{fail_to_pass list}
2. `npx tsc --noEmit` exits 0
3. Each acceptance criterion verified:
{acceptance_criteria}
4. No out-of-scope items were built:
{out_of_scope}
5. Verification anchors exist:
{verification_anchors}
6. qa_tested:true set in ralph/prd.json for {story_id}
7. ralph/qa-report.json has an entry for {story_id}

CONSTRAINTS:
- Read ralph/qa-prompt.md for methodology
- Fix bugs in SOURCE CODE only — never weaken tests
- Commit fixes with "QA: {story_id}" prefix

Stop after 20 turns if not complete.
```

### Step 5: Write goal files

```bash
mkdir -p ralph/goals
```

Write `ralph/goals/{story_id}.build.goal`:
```
[the build goal condition text]
```

Write `ralph/goals/{story_id}.qa.goal`:
```
[the QA goal condition text]
```

### Step 6: Check for goal-mode prerequisites

Verify the environment is goal-ready:

```bash
# Check lean CLAUDE.md exists
ls ralph/CLAUDE.goal.md 2>/dev/null

# Check Stop hook exists
ls .claude/hooks/goal-acceptance-gate.sh 2>/dev/null

# Count lines in CLAUDE.md
wc -l CLAUDE.md 2>/dev/null
```

Report any issues:
```
Goal prerequisites:
  ✓ ralph/CLAUDE.goal.md exists (lean CLAUDE.md for judge)
  ✓ .claude/hooks/goal-acceptance-gate.sh exists (deterministic verification)
  ✗ CLAUDE.md is 450 lines — judge reads this every tick. Consider:
      cp CLAUDE.md CLAUDE.full.md && cp ralph/CLAUDE.goal.md CLAUDE.md
      (restore after goal run)
```

### Step 7: Print usage instructions

```
Goal conditions generated:
  Build: ralph/goals/{story_id}.build.goal
  QA:    ralph/goals/{story_id}.qa.goal

═══ Interactive usage ═══

  1. Swap to lean CLAUDE.md (optional but recommended):
     cp CLAUDE.md CLAUDE.full.md && cp ralph/CLAUDE.goal.md CLAUDE.md

  2. Open Claude Code and paste:
     /goal [paste contents of ralph/goals/{story_id}.build.goal]

  3. After build completes, QA it:
     /goal [paste contents of ralph/goals/{story_id}.qa.goal]

  4. Restore CLAUDE.md:
     cp CLAUDE.full.md CLAUDE.md

═══ CLI usage (non-interactive) ═══

  ./ralph/goal-build.sh {story_id}
  ./ralph/goal-qa.sh {story_id}

═══ Environment tuning ═══

  # Max retries before judge gives up (default: session default)
  export CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES=5

  # Override judge model (default: Haiku)
  export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5-20251001

  # Permission mode (build needs file access)
  Use --permission-mode acceptEdits for build goals
  Use --allowedTools "Bash,Read,Edit,Write" for tighter control
```

## Rules

- NEVER generate a goal condition over 4,000 characters.
- NEVER include secrets or env var values in the goal condition.
- ALWAYS include the fail_to_pass test names — they're the oracle.
- ALWAYS include "show output" instructions — the judge needs transcript evidence.
- ALWAYS include a turn limit ("stop after N turns").
- ALWAYS check for goal prerequisites and warn if missing.
- The goal condition is a CONTRACT with the judge. Make it unambiguous.
