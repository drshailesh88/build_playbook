# Improve — Single-Metric Autoresearch Loop

Drives one metric toward a target using Karpathy's autoresearch pattern: measure → diagnose → ONE change → re-measure → commit or revert → log → repeat.

## Usage

```
/improve [metric]
/improve coverage
/improve tsc-errors --target 100
/improve mutation --intensity aggressive
```

If no metric is provided, show available metrics and ask.

## Available Metrics

Run `./scripts/score.sh` with any of:
- `tsc-errors` — TypeScript type errors (target: 100 = zero errors)
- `eslint` — Lint errors and warnings (target: 100 = clean)
- `coverage` — Line coverage % (target: 80+)
- `mutation` — Mutation score % (target: 75+)
- `lighthouse-perf` — Lighthouse performance (target: 90+)
- `lighthouse-a11y` — Lighthouse accessibility (target: 95+)
- `axe-violations` — axe-core violations (target: 100 = zero violations)
- `playwright-pass` — Playwright pass rate (target: 100)

## Workflow

### 1. Read reference materials

Read these files to understand the GOAL.md pattern:
- `vendor/goal-md/template/GOAL.md` — the canonical template (5 required elements)
- `vendor/goal-md/examples/scoring-scripts.md` — fitness function patterns
- At least one example: `vendor/goal-md/examples/api-test-coverage.md` or `perf-optimization.md`

### 2. Determine operating mode

Check which files will be touched. If any are in Tier 1 modules (auth, payments, user data):
- **Supervised** — pause for human approval before each commit

If Tier 2 (core features):
- **Converge** — stop when target is met

If Tier 3 (UI, utils, helpers):
- **Continuous** — run until stall detected

If module tiers are available from `/classify-modules`, use those. Otherwise, ask the user.

### 3. Establish baseline

```bash
./scripts/score.sh <metric>
```

Record the output. This is iteration 0.

### 4. Write GOAL.md

Create `.quality/goals/GOAL.md` with:

```markdown
# GOAL: <metric> improvement

## Fitness Function
./scripts/score.sh <metric>

## Baseline
Score: <N> / <max> (<unit>)
Target: <target>
Started: <ISO timestamp>

## Operating Mode
<Supervised | Converge | Continuous>

## Metric Mutability
Split — agent may fix measurement bugs in score.sh but not redefine what "good" means.

## File Map
Editable: <list based on phase — see rules/autoresearch.md>
Locked (READ-ONLY): <list based on phase>

## Constraints
- See rules/autoresearch.md for full guardrails
- Guard metrics: <list from rules>
- Max iterations: <5/10/20 based on intensity>
- Stall threshold: <3/5/7 based on intensity>

## Action Catalog
<Generate 5-10 concrete actions ranked by estimated point impact>
<Each action: description → estimated improvement → method → risk>
```

### 5. Run the improvement loop

For each iteration:

1. **Measure**: `./scripts/score.sh <metric>` → record score
2. **Diagnose**: Pick the highest-impact action from the catalog (or discover new ones)
3. **Change**: Make ONE atomic change. Minimal diff. Single concern.
4. **Verify**: `./scripts/score.sh <metric>` → record new score
5. **Guard check**: Verify guard metrics haven't regressed
6. **Decision**:
   - Improved + guards pass → `git add <files> && git commit -m "[S:OLD->NEW] component: what"`
   - Regressed or guard failed → `git checkout -- <files-touched> && git clean -f <new-files-created>`
7. **Log**: Append to `.quality/goals/iterations-<metric>-active.jsonl`
8. **Stall check**: If 3 consecutive iterations < 0.5% improvement, stop

### 6. On completion

1. Record final score in GOAL.md
2. Archive: move `GOAL.md` → `.quality/goals/GOAL-<metric>-<YYYY-MM-DD>.md`
3. Archive: move iterations file → `.quality/goals/iterations-<metric>-<YYYY-MM-DD>.jsonl`
4. Report summary: metric, before → after, iterations run, iterations kept

## Intensity Levels

| Level | Max Iterations | Stall Threshold | Default |
|-------|---------------|-----------------|---------|
| Quick | 5 | 3 consecutive | - |
| Moderate | 10 | 5 consecutive | Yes |
| Aggressive | 20 | 7 consecutive | - |

## Integration with Supermemory

After the loop completes, save key findings to persistent memory:
```
memory("Improved <metric> from X to Y by: <top 3 actions that worked>", containerTag="<project-slug>")
```

## Integration with QA Harness

This command runs BETWEEN QA harness runs. After `/improve` completes, the user should run the full QA harness to verify no regressions across all metrics.
