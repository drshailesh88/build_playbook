# Anneal Check

Run the self-annealing quality scorer and report whether the score held, dropped, or improved. Use after any feature build, bug fix, or before claiming work is done.

Optional: $ARGUMENTS (pass `--gate` to fail hard if score drops, `--phase N` to check a specific phase)

## Why This Exists

The annealing system (quality-score.mjs) measures 18 dimensions across 5 phases. This command wraps it into a structured workflow that detects regressions, identifies which dimension broke, and prevents shipping quality drops.

Adapted from:
- Jesse Vincent's verification-before-completion — "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"
- Cole Medin's 3-level validation loop — syntax → unit → integration, applied to quality scoring

## Process

### 1. Capture Baseline

Read the current score BEFORE running:
```bash
cat quality-score.json 2>/dev/null
```

Store: `$BASELINE_COMPOSITE`, `$BASELINE_TEMPERATURE`, `$BASELINE_WEAKEST`

If quality-score.json doesn't exist, set baseline to 0 (first run).

### 2. Run the Scorer

```bash
node quality-score.mjs
```

If `--phase N` was passed:
```bash
node quality-score.mjs --phase $N
```

### 3. Read Fresh Results

```bash
cat quality-score.json
```

Store: `$NEW_COMPOSITE`, `$NEW_TEMPERATURE`, `$NEW_WEAKEST`

### 4. Compare and Report

Calculate delta: `$DELTA = $NEW_COMPOSITE - $BASELINE_COMPOSITE`

Output format:

```
🔬 ANNEALING CHECK
━━━━━━━━━━━━━━━━━
Score: [XX.XX] → [XX.XX] ([+/-delta])
Temperature: [TEMPERATURE]
Weakest: [dimension] ([score])

Verdict: [IMPROVED ✅ / HELD ⚖️ / REGRESSED ❌]
```

If regressed, also show:

```
📉 REGRESSIONS DETECTED
[For each dimension where score decreased:]
  - [Dimension]: [old] → [new] ([delta])
    Details: [relevant detail from dimensions object]
```

### 5. Gate Behavior

If `--gate` was passed:
- **Score improved or held** (delta ≥ 0): Print "✅ Quality gate PASSED" and continue
- **Score dropped** (delta < 0): Print "❌ Quality gate FAILED — score dropped by [delta]" and list the regressions. Do NOT proceed to the next task. Tell the user: "Fix the regressions before continuing. The weakest dimension is [X]."

If `--gate` was NOT passed:
- Report results but don't block. This is informational.

### 6. Log the Check

Append to `annealing-log.jsonl`:
```json
{"timestamp":"[ISO]","composite":[score],"temperature":"[temp]","currentPhase":[phase],"phaseAverages":{...},"weakest":{"dimension":"[dim]","label":"[label]","score":[score]}}
```

This is already done by quality-score.mjs, but verify the log was written:
```bash
tail -1 annealing-log.jsonl
```

## Wiring into GSD

To use this as a GSD verification command, add to `.planning/config.json` (GSD settings):

```json
{
  "verification_commands": [
    "npx tsc --noEmit",
    "npm run lint",
    "npm test",
    "node quality-score.mjs"
  ]
}
```

GSD's execute-phase will then run the annealing check after every task automatically.

## Rules

- ALWAYS read baseline BEFORE running scorer — you need the comparison
- NEVER claim "quality held" without running the scorer fresh — evidence before claims
- If the scorer fails to run (missing dependencies, errors), report the error clearly — don't assume the score is fine
- When used with `--gate`, a regression is a hard stop — no exceptions, no "it's probably fine"
