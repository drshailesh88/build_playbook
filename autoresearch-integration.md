# Autoresearch Integration — Self-Improving Everything

How to use Karpathy's autoresearch pattern across your entire playbook. Three applications: improve your skills overnight, self-heal your code, and optimize performance — all while you sleep.

## Install

```bash
# The generalized Claude Code autoresearch plugin
claude plugin marketplace add uditgoenka/autoresearch

# Also fork for reference
cd your-repo/vendor/
git clone --depth 1 https://github.com/uditgoenka/autoresearch.git
git clone --depth 1 https://github.com/karpathy/autoresearch.git karpathy-autoresearch
```

## The Pattern (3 Components, Always the Same)

```
1. ONE FILE TO CHANGE    (the thing being improved)
2. ONE METRIC TO MEASURE (a number that says "better" or "worse")
3. ONE LOOP              (change → measure → keep if better, revert if worse → repeat)
```

Everything below is this pattern applied to different targets.

---

## APPLICATION 1: Self-Improving Skills

Your skills produce output (UX briefs, security audits, feature docs). That output quality depends on how well the SKILL.md instructions are written. Autoresearch can improve the instructions by testing them against eval criteria.

### How It Works

```
SKILL.md ──→ Agent generates output ──→ Eval scores output ──→ Score improved?
   ↑                                                              │
   └──────── Agent modifies SKILL.md ←────── YES: keep ──────────┘
                                       ←────── NO: revert ────────┘
```

### Which Skills to Improve First

Start with skills that have the most inconsistent output — the ones where you sometimes get great results and sometimes get mediocre ones.

| Skill | Eval Criteria | Metric Command |
|-------|--------------|----------------|
| `/ux-brief` | Covers all 10 design rules? Asks about progressive disclosure? References competition? Includes visual examples? Per-module decisions present? | Score out of 10 criteria |
| `/ui-brief` | Extracts visual DNA from inspirations? Recommends font pairings? Generates CSS variables? Pushes back on positioning mismatches? | Score out of 8 criteria |
| `/data-grill` | Covers all 8 categories per subject? Uses zero database jargon? Includes future-proofing questions? Cross-references subjects? | Score out of 8 criteria |
| `/compete-research` | Separates competitors from inspirations? Extracts visual DNA? Produces feature matrix? Identity synthesis present? | Score out of 6 criteria |
| `/security-audit` | Checks all 6 areas? Provides file:line refs? Gives fix code? Orders by severity? | Score out of 6 criteria |

### Example: Improve /ux-brief

```
/autoresearch
Goal: Improve UX brief output quality
Scope: .claude/commands/ux-brief.md
Metric: eval score (criteria met out of 10)
Direction: higher_is_better
Verify: |
  # Generate a test UX brief for a mock project
  claude -p "Read .claude/commands/ux-brief.md and generate a UX brief for a hypothetical todo app" > /tmp/test-output.md

  # Score against criteria
  SCORE=0
  grep -q "progressive disclosure" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "Bear model\|Wizard model" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "feedback.*anxiety\|feedback.*effort" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "navigation.*collapse\|sidebar.*launcher" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "module.*independence\|win the module" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "knowledge work.*instant\|150ms" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "persona\|user.*not.*founder" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "mobile\|device.*priority" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "vibe.*competition.*inspiration\|identity" /tmp/test-output.md && SCORE=$((SCORE+1))
  grep -q "zero.*ambiguity\|follow.*up\|exhaustive" /tmp/test-output.md && SCORE=$((SCORE+1))
  echo "Score: $SCORE/10"
Iterations: 20
```

The agent modifies the ux-brief instructions, generates test output, scores it, keeps changes that increase the score, reverts changes that decrease it. 20 iterations. Run before bed.

### Important Rule for Skill Improvement

<HARD-GATE>
Never let autoresearch remove your core principles or design rules from a skill. The eval criteria must INCLUDE checks for the 10 design rules. If the agent "optimizes" by removing the progressive disclosure requirement, the eval should catch it and revert.
</HARD-GATE>

---

## APPLICATION 2: Self-Healing Code (Quality Score)

You already have `quality-score.mjs` measuring 18 dimensions. Autoresearch turns it into an autonomous improvement loop.

### How It Works

```
Source code ──→ quality-score.mjs ──→ Score improved?
    ↑                                      │
    └──── Agent fixes weakest dimension ←──┘
```

### Run It

```
/autoresearch
Goal: Increase quality score to 99.9
Scope: src/**/*.ts, src/**/*.tsx
Metric: composite quality score
Direction: higher_is_better
Verify: node quality-score.mjs && cat quality-score.json | python3 -c "import json,sys; print('Score:', json.load(sys.stdin)['composite'])"
```

### Smarter: Target the Weakest Dimension

Instead of optimizing the composite (which may already be 99.71), target the weakest:

```
/autoresearch
Goal: Improve weakest quality dimension above 99
Scope: src/**/*.ts, src/**/*.tsx
Metric: weakest dimension score
Direction: higher_is_better
Verify: node quality-score.mjs && cat quality-score.json | python3 -c "import json,sys; d=json.load(sys.stdin); print('Score:', d['weakest']['score'])"
```

### Connect to Existing Pipeline

Your `/anneal` command is ALREADY a Karpathy loop — it reads failures, fixes code, verifies, repeats. Autoresearch can run as a SECOND pass after anneal:

```
Phase 1: /harden editor         ← Feature census → specs → tests → self-healing
Phase 2: /autoresearch           ← Autonomous improvement loop on remaining gaps
         Goal: All specs passing
         Metric: spec pass rate
         Verify: npx playwright test qa/generated/editor/ --reporter=json | grep "passed"
```

---

## APPLICATION 3: Performance Optimization

Point autoresearch at Lighthouse, bundle size, or Core Web Vitals.

### Bundle Size Reduction

```
/autoresearch
Goal: Reduce First Load JS below 150KB
Scope: src/**/*.tsx, src/**/*.ts, next.config.*
Metric: bundle size in KB
Direction: lower_is_better
Verify: npm run build 2>&1 | grep "First Load JS" | head -1 | awk '{print $4}'
Iterations: 30
```

The agent will: tree-shake imports, dynamic import heavy components, remove unused code, optimize dependencies. Each change is atomic — if it breaks the build, it reverts.

### Lighthouse Score

```
/autoresearch
Goal: Lighthouse performance score above 95
Scope: src/**/*.tsx, src/**/*.ts, public/**, next.config.*
Metric: Lighthouse performance score
Direction: higher_is_better
Verify: npx lighthouse http://localhost:3000 --output=json --quiet | python3 -c "import json,sys; print('Score:', int(json.load(sys.stdin)['categories']['performance']['score']*100))"
Iterations: 20
```

### API Response Time

```
/autoresearch
Goal: All API routes respond under 200ms
Scope: src/app/api/**/*.ts
Metric: p95 response time in ms
Direction: lower_is_better
Verify: |
  # Run a quick load test
  npx autocannon -d 10 -c 10 http://localhost:3000/api/health | grep "p95" | awk '{print $NF}'
```

---

## APPLICATION 4: Security Hardening

The autoresearch plugin has a built-in security workflow.

```
/autoresearch:security
```

This runs: STRIDE threat model → OWASP Top 10 (70+ checks) → 4 red-team personas → structured report. Read-only by default.

To auto-fix findings:
```
/autoresearch:security --fix
```

To integrate with CI (block deploys on critical findings):
```
/autoresearch:security --diff --fail-on critical
```

---

## APPLICATION 5: Debugging (Scientific Method)

When a bug is stubborn, autoresearch has a debugging workflow that uses falsifiable hypotheses:

```
/autoresearch:debug
Scope: src/app/api/**/*.ts
Symptom: API returns 500 on POST /users with large payloads
Iterations: 20
```

It uses 7 investigation techniques: binary search, differential debugging, minimal reproduction, trace execution, pattern search, working backwards, rubber duck. Every hypothesis is logged — confirmed, disproven, or inconclusive.

---

## WHEN TO RUN AUTORESEARCH (Playbook Integration)

Add to your playbook after Phase 7 (Testing & QA):

```
PHASE 7.5: AUTONOMOUS IMPROVEMENT (Optional — Run Overnight)

Pick one or more:

□ Skill improvement
  /autoresearch Goal: Improve [skill] output quality
  Scope: .claude/commands/[skill].md
  Run overnight. Review changes in morning.

□ Code quality
  /autoresearch Goal: Increase quality score
  Scope: src/**/*.ts
  Metric: node quality-score.mjs composite
  Run overnight. Check score in morning.

□ Performance
  /autoresearch Goal: Reduce bundle size / Increase Lighthouse score
  Scope: src/**/*.tsx
  Run overnight. Check metrics in morning.

□ Security hardening
  /autoresearch:security --fix
  Run overnight. Review fixes in morning.

Morning review:
  git log --oneline -20    ← See what the agent changed
  cat results.tsv          ← See metrics per iteration
  /anneal-check            ← Verify quality didn't drop
```

---

## SAFETY RULES

1. **Always run on a branch** — never let autoresearch modify main directly
   ```bash
   git checkout -b autoresearch/improve-ux-brief
   # Run autoresearch
   # Review in morning
   # Merge if satisfied
   ```

2. **Always review before merging** — autoresearch commits are atomic and reviewable. Read the git log. Check the diffs. The agent is optimizing for YOUR metric, not for overall code quality.

3. **Bound iterations** — don't run unbounded overnight on your first try. Start with `Iterations: 10` to see what happens. Scale up once you trust the output.

4. **Check for gaming** — if your eval criteria are too narrow, the agent will find ways to pass them that don't actually improve quality. Example: if you only check "does output mention progressive disclosure," the agent might add "progressive disclosure" as a keyword without actually implementing the concept in the skill.

5. **Protect core principles** — your 10 design rules, your verification-before-completion iron law, your no-jargon hard gates. These are non-negotiable. Eval criteria must test for their presence.

---

## REPOS TO ADD TO VENDOR

| Repo | Why |
|------|-----|
| **uditgoenka/autoresearch** | Install as plugin. The generalized autoresearch for Claude Code. |
| **karpathy/autoresearch** | Reference only. The original 630-line implementation. Read program.md for the philosophy. |
| **alvinunreal/awesome-autoresearch** | Bookmark. Curated index of everything built on the pattern. |

---

## THE MENTAL MODEL

```
WITHOUT AUTORESEARCH:
  You build → You test → You fix → You ship
  Quality = how much time YOU have

WITH AUTORESEARCH:
  You build → You define "good" → Agent loops overnight → You review
  Quality = how many iterations the agent runs × how well you defined "good"
```

The bottleneck shifts from YOUR time to YOUR eval criteria. Write better criteria → get better results. This is why your grilling sessions matter so much — they produce the criteria that autoresearch optimizes against.
