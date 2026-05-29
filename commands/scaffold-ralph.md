# scaffold-ralph — Install adapted Ralph scripts into the target app

Drops the full Ralph stack (build + verify + 5 harden loops chained via
run.sh) plus all prompt templates into the target app's `ralph/`
directory. Scripts are generic; the prompt templates have `CUSTOMIZE:`
markers you fill in with your app's specifics.

**Installed loops by tier:**

- **Tier 1 — Build + Verify** (always chained in run.sh): `build.sh`, `qa.sh`
- **Tier 2 — Harden** (chained in run.sh as Phase 3): `harden.sh`
- **Tier 3 — Completeness, Stress, Monitor** (installed as standalone; chain
  into run.sh after each is runtime-proven): `harden-completeness.sh`,
  `harden-adversarial.sh`, `harden-drift.sh`, `harden-security.sh`

**Do NOT download Huntley's raw scripts.** They reference his
product-cloning infra (build-spec.md, clone-product-docs/, AWS SES,
Ever CLI) that you don't have. The templates this command drops are the
Huntley methodology adapted for PRD-based app-building.

Input: `$ARGUMENTS` — optional flags.

## What This Installs

In the target app's `ralph/` directory:

| File | Purpose |
|---|---|
| `ralph/build.sh` | Build loop. Invokes Claude Opus 4.6. One feature per iteration. Parses `<promise>NEXT\|COMPLETE\|ABORT</promise>`. Reads `ralph/prd.json`, `ralph/build-prompt.md`, `ralph/progress.txt`. Default 999 iterations, 30-minute per-iter timeout. |
| `ralph/qa.sh` | Verify loop. Invokes Codex with dual-account failover. Picks first `passes:true` feature not yet `qa_tested:true`. Fixes bugs in code (never tests), commits with `QA:` prefix, flips `qa_tested:true`. |
| `ralph/harden.sh` | Harden loop. Claude Sonnet 4.6 kills surviving mutants per module. Reads `.quality/state.json` for work source. Writes `ralph/harden-report.json`. Commit prefix `HARDEN:`. Model override via `HARDEN_MODEL` env var. |
| `ralph/harden-completeness.sh` | Completeness loop. Claude Opus 4.6 detects features promised by the PRD but missing from the running app using deterministic extractor output (`ralph/completeness-is-list.json` + `ralph/completeness-evidence.json`), and appends them back to `ralph/prd.json`. Then triggers build + qa automatically. Commit prefix `COMPLETENESS:`. |
| `ralph/completeness-is-extractor.sh` | Deterministic pre-pass. Runs `node ./qa/completeness/extract-is.mjs` and writes `ralph/completeness-is-list.json` plus `ralph/completeness-evidence.json` before each completeness iteration. The same completeness fitness is enforced by `qa-run` as a release gate. |
| `ralph/specmatic-verify.sh` | Specmatic wrapper. Resolves or generates an OpenAPI spec, runs `specmatic test` against the running app, and writes `ralph/specmatic-report.json`. Specmatic is also integrated into `qa-run` and auto-skips until an OpenAPI spec exists. |
| `ralph/harden-adversarial.sh` | Red-team loop. Codex with dual-account failover. Systematically attacks every `qa_tested:true` feature using a 7-category attack catalog (injection, auth, race, resource, state, UX, info leakage). Commit prefix `RED:`. |
| `ralph/harden-drift.sh` | Drift loop. Claude Sonnet 4.6 runs all contract acceptance tests (`.quality/contracts/*/acceptance.spec.ts`) and fixes source code to match any failing contract. Contracts are locked — code bends to match them, never the other way. Commit prefix `DRIFT:`. |
| `ralph/harden-security.sh` | Security loop. Codex with dual-account failover. Systematic pass through OWASP Top 10 (2021) — A01..A10, one category per iteration. Override categories via `OWASP_CATEGORIES=A01,A03,A07` env var. Commit prefix `SEC:`. |
| `ralph/run.sh` | Master entrypoint. Chains `build.sh` → `qa.sh` → `harden.sh`. Env skips: `BUILD_SKIP=1` `QA_SKIP=1` `HARDEN_SKIP=1`. Logs to `ralph/ralph-<timestamp>.log`. macOS notification + opens `progress.txt` on completion. Other harden loops run standalone until runtime-proven, then get chained in here. |
| `ralph/build-prompt.template.md` | Build agent instructions. Rename to `build-prompt.md` after customizing. |
| `ralph/qa-prompt.template.md` | QA agent instructions. Rename to `qa-prompt.md` after customizing. |
| `ralph/harden-prompt.template.md` | Harden (mutation-killer) agent instructions. Reads Stryker surviving-mutants report; adds tests, never weakens existing ones. Rename to `harden-prompt.md`. |
| `ralph/harden-completeness-prompt.template.md` | Completeness agent instructions. Reads deterministic IS files from the extractor, diffs vs PRD, writes full story entries for missing features. APPEND-only to `prd.json`. Rename to `harden-completeness-prompt.md`. |
| `ralph/harden-adversarial-prompt.template.md` | Red-team agent instructions. Full 7-category attack catalog; fixes bugs in source only, adds regression tests. Rename to `harden-adversarial-prompt.md`. |
| `ralph/harden-drift-prompt.template.md` | Drift agent instructions. Fixes source to match locked contracts; never touches contract files. Rename to `harden-drift-prompt.md`. |
| `ralph/harden-security-prompt.template.md` | Security agent instructions. OWASP Top 10 category table with specific patterns per code. Rename to `harden-security-prompt.md`. |
| `ralph/watch.sh` | Optional Slack + Linear progress monitor. |
| `ralph/RESUME.md` | Stall recovery runbook in plain English. What to check, how to soft/hard interrupt, how to triage untracked files, how to restart. Read this BEFORE you panic at 2am. |
| `.claude/hooks/pre-commit-quality-gate.sh` | Claude Code PreToolUse hook. Intercepts `git commit` calls and runs `npx tsc --noEmit` + `npm run lint --if-present` first. Blocks the commit if either fails. Bypass: `SKIP_QUALITY_GATE=1`. |
| `.claude/hooks/goal-acceptance-gate.sh` | Claude Code Stop hook for `/goal` mode. Fires after each worker turn. When the worker signals completion, runs deterministic fail_to_pass verification + tsc + lint. Blocks until all checks pass. Only active when `ralph/goal-current-story.txt` exists (written by goal scripts). |
| `ralph/goal-build.sh` | Goal-mode build. Runs a single story via Claude Code `/goal` instead of the bash loop. Auto-swaps CLAUDE.md to lean version, sets `CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES`, cleans up on exit. Usage: `./ralph/goal-build.sh <story-id>`. |
| `ralph/goal-qa.sh` | Goal-mode QA. Verifies a single built story via `/goal` with independent evaluation. Same auto-swap and cleanup as goal-build.sh. Usage: `./ralph/goal-qa.sh <story-id>`. |
| `ralph/CLAUDE.goal.template.md` | Lean CLAUDE.md (<80 lines) optimized for `/goal` judge. Judge (Haiku) reads CLAUDE.md every evaluation tick — a 500-line CLAUDE.md wastes judge tokens. Rename to `CLAUDE.goal.md` after customizing. |

## Flags

- `--force` — overwrite existing files in `ralph/` (DANGEROUS if Ralph
  is already running; skips by default).
- `--dry-run` — print what would be copied without writing.

## Preconditions

- Target app is a git repo with a `CLAUDE.md` in the project root. The
  build loop passes `CLAUDE.md` into every iteration as the authoritative
  rules source.
- `ralph/prd.json` exists (from `/playbook:prd-to-ralph`). Not strictly
  required to scaffold, but you'll need it to actually run `./ralph/run.sh`.
- `claude` CLI + `codex` CLI are both available on PATH.
- Python 3 is available (used for JSON counting inside the scripts —
  matches Huntley's `python3 -c "..."` pattern).
- **Recommended**: `gtimeout` for 30-min hard wall-clock per iteration.
  `brew install coreutils` on macOS. Without it, build.sh runs each
  iteration without a time cap and warns at startup.

## Process

### Step 1: Locate the playbook scaffold

The templates live at
`<playbook-repo>/playbook/qa-scaffold/templates/ralph/`. Find the
playbook repo either via an environment variable or a well-known path:

```ts
import { resolve } from "node:path";
import { existsSync } from "node:fs";

const candidates = [
  process.env.PLAYBOOK_ROOT,
  resolve(process.env.HOME ?? "", "Build Playbook"),
  resolve(process.env.HOME ?? "", "build_playbook"),
  resolve(process.env.HOME ?? "", "code", "build_playbook"),
].filter(Boolean) as string[];

const playbookRoot = candidates.find((p) =>
  existsSync(resolve(p, "playbook/qa-scaffold/templates/ralph")),
);
if (!playbookRoot) {
  throw new Error(
    "Can't find the playbook repo. Set PLAYBOOK_ROOT to its absolute path.",
  );
}
const templatesDir = resolve(playbookRoot, "playbook/qa-scaffold/templates/ralph");
const hooksTemplatesDir = resolve(playbookRoot, "playbook/qa-scaffold/templates/.claude/hooks");
```

### Step 2: Copy templates into target app's `ralph/`

```ts
import { promises as fs } from "node:fs";
import { join, resolve as pathResolve } from "node:path";

const targetRalph = pathResolve(process.cwd(), "ralph");
await fs.mkdir(targetRalph, { recursive: true });

const TEMPLATE_MAP: Array<[string, string]> = [
  // [src name in templates/, dst name in target ralph/]

  // Tier 1 — Build + Verify
  ["build.sh", "build.sh"],
  ["qa.sh", "qa.sh"],
  ["build-prompt.template.md", "build-prompt.template.md"],
  ["qa-prompt.template.md", "qa-prompt.template.md"],

  // Tier 2 — Harden (mutation-kill)
  ["harden.sh", "harden.sh"],
  ["harden-prompt.template.md", "harden-prompt.template.md"],

  // Tier 3 — Completeness + Stress + Monitor (standalone until runtime-proven)
  ["harden-completeness.sh", "harden-completeness.sh"],
  ["completeness-is-extractor.sh", "completeness-is-extractor.sh"],
  ["specmatic-verify.sh", "specmatic-verify.sh"],
  ["harden-completeness-prompt.template.md", "harden-completeness-prompt.template.md"],
  ["harden-adversarial.sh", "harden-adversarial.sh"],
  ["harden-adversarial-prompt.template.md", "harden-adversarial-prompt.template.md"],
  ["harden-drift.sh", "harden-drift.sh"],
  ["harden-drift-prompt.template.md", "harden-drift-prompt.template.md"],
  ["harden-security.sh", "harden-security.sh"],
  ["harden-security-prompt.template.md", "harden-security-prompt.template.md"],

  // Orchestrator + helpers
  ["run.sh", "run.sh"],
  ["watch.sh", "watch.sh"],
  ["RESUME.md", "RESUME.md"],

  // Goal mode — /goal integration (Claude Code Worker/Judge pattern)
  ["goal-build.sh", "goal-build.sh"],
  ["goal-qa.sh", "goal-qa.sh"],
  ["CLAUDE.goal.template.md", "CLAUDE.goal.template.md"],
];

for (const [src, dst] of TEMPLATE_MAP) {
  const srcPath = join(templatesDir, src);
  const dstPath = join(targetRalph, dst);
  const exists = await fs.access(dstPath).then(() => true).catch(() => false);

  if (exists && !flags.force) {
    console.log(`skip: ${dstPath} (already exists — pass --force to overwrite)`);
    continue;
  }
  if (flags.dryRun) {
    console.log(`would copy: ${src} → ${dstPath}`);
    continue;
  }
  await fs.copyFile(srcPath, dstPath);
  if (dst.endsWith(".sh")) {
    await fs.chmod(dstPath, 0o755);
  }
  console.log(`wrote: ${dstPath}`);
}

// --- Claude Code hooks (installed into target .claude/hooks/) ---
const HOOK_MAP: Array<[string, string]> = [
  // [src name in templates/.claude/hooks/, dst name in target .claude/hooks/]
  ["pre-commit-quality-gate.sh", "pre-commit-quality-gate.sh"],
  ["goal-acceptance-gate.sh", "goal-acceptance-gate.sh"],
];

const targetHooks = pathResolve(process.cwd(), ".claude/hooks");
await fs.mkdir(targetHooks, { recursive: true });

for (const [src, dst] of HOOK_MAP) {
  const srcPath = join(hooksTemplatesDir, src);
  const dstPath = join(targetHooks, dst);
  const exists = await fs.access(dstPath).then(() => true).catch(() => false);

  if (exists && !flags.force) {
    console.log(`skip: ${dstPath} (already exists — pass --force to overwrite)`);
    continue;
  }
  if (flags.dryRun) {
    console.log(`would copy: ${src} → ${dstPath}`);
    continue;
  }
  await fs.copyFile(srcPath, dstPath);
  await fs.chmod(dstPath, 0o755);
  console.log(`wrote: ${dstPath}`);
}
```

### Step 3: Print customization checklist

```
✅ Ralph stack scaffolded at ./ralph/
   Tier 1: build.sh, qa.sh
   Tier 2: harden.sh
   Tier 3: harden-completeness.sh, harden-adversarial.sh,
           harden-drift.sh, harden-security.sh
   + run.sh orchestrator
   + .claude/hooks/pre-commit-quality-gate.sh (Tier 1 commit gate)

Next (required before running):

1. Customize Tier 1 prompts (required for ./ralph/run.sh):
   - ralph/build-prompt.template.md → build-prompt.md
   - ralph/qa-prompt.template.md → qa-prompt.md
   For each: replace {APP_NAME}, fill every "CUSTOMIZE:" block with your
   app's specifics (module paths, quality-check commands, locked paths,
   external services).

2. Customize Tier 2 prompt (required for harden.sh):
   - ralph/harden-prompt.template.md → harden-prompt.md
   Fill CUSTOMIZE blocks for Stryker command + test directory.

3. Customize Tier 3 prompts (required only when you run each loop):
   - ralph/harden-completeness-prompt.template.md → harden-completeness-prompt.md
     (fill CUSTOMIZE for PRD source paths + app-specific ubiquitous language)
   - ralph/harden-adversarial-prompt.template.md → harden-adversarial-prompt.md
     (fill CUSTOMIZE with app-specific attack vectors)
   - ralph/harden-drift-prompt.template.md → harden-drift-prompt.md
     (fill CUSTOMIZE with contract test command if non-default)
   - ralph/harden-security-prompt.template.md → harden-security-prompt.md
     (fill CUSTOMIZE with per-OWASP-category hotspot lists)

4. Ensure ralph/prd.json exists (run /playbook:prd-to-ralph if not).

5. Ensure /playbook:install-qa-harness has been run — harden.sh, drift,
   and the qa-controller require the .quality/ tree to exist.

6. Register the pre-commit quality gate hook in .claude/settings.json:
   Add a PreToolUse hook entry pointing to .claude/hooks/pre-commit-quality-gate.sh
   so Claude Code runs typecheck + lint before every git commit. The hook
   was copied to .claude/hooks/ automatically. Bypass with SKIP_QUALITY_GATE=1
   if needed in emergencies.

7. Run:
   ./ralph/run.sh                # build → qa → harden, 999 iters each
   ./ralph/run.sh 50 50 50       # cap each phase at 50 iters
   BUILD_SKIP=1 QA_SKIP=1 ./ralph/run.sh    # run just the harden phase

   Standalone runs (for debugging individual loops):
   ./ralph/completeness-is-extractor.sh    # refresh deterministic IS evidence
   ./ralph/harden.sh 10                 # just harden, 10 iters
   ./ralph/harden-completeness.sh 5     # detect + fill missing features
   ./ralph/harden-adversarial.sh 10     # red-team
   ./ralph/harden-drift.sh 10           # contract drift
   ./ralph/harden-security.sh 5         # OWASP systematic
   ./ralph/specmatic-verify.sh          # optional OpenAPI contract verification
   OWASP_CATEGORIES=A01,A03 ./ralph/harden-security.sh 2   # subset

   Model overrides (A/B testing):
   HARDEN_MODEL=claude-opus-4-6 ./ralph/harden.sh 10
   COMPLETENESS_MODEL=claude-sonnet-4-6 ./ralph/harden-completeness.sh 5

8. (Optional) Goal-mode — build individual stories via Claude Code /goal:

   First, customize the lean CLAUDE.md for goal mode:
   - ralph/CLAUDE.goal.template.md → CLAUDE.goal.md
     Replace {APP_NAME}, fill CUSTOMIZE blocks with your app's rules.
     Keep it under 200 lines — the judge (Haiku) reads it every tick.

   Register the goal acceptance gate hook in .claude/settings.json:
   Add a Stop hook entry pointing to .claude/hooks/goal-acceptance-gate.sh.
   This hook runs deterministic verification (fail_to_pass tests, tsc, lint)
   after each worker turn during /goal runs.

   Then generate goal conditions and run:
   /playbook:ralph-goal <story-id>       # generates goal condition files
   ./ralph/goal-build.sh <story-id>      # build via /goal (CLI)
   ./ralph/goal-qa.sh <story-id>         # QA via /goal (CLI)

   Or interactively in Claude Code:
   /goal [paste contents of ralph/goals/<story-id>.build.goal]

   Environment tuning:
   export CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES=5   # max judge retries
   export GOAL_MODEL=claude-opus-4-6               # worker model
   export QA_GOAL_MODEL=claude-opus-4-6            # QA worker model

9. (Optional) In a second terminal, monitor on Slack + Linear:
   /playbook:ralph-watch
   SLACK_WEBHOOK_URL=... LINEAR_API_KEY=... LINEAR_TEAM_ID=... ./ralph/watch.sh

10. After Ralph finishes, run the release gate — the ungameable judge:
   /playbook:qa-run       # runs deterministic release gates, writes summary.md
```

## Rules

- NEVER overwrite existing `ralph/*.sh` or prompt files silently. If a
  file exists, skip it unless `--force` is passed. (Ralph-in-progress
  sessions must not be disrupted.)
- NEVER edit the generic template logic. The workflow (TDD-first, one
  feature per iteration, promise tags, RALPH:/QA: commit prefixes,
  passes/qa_tested flags) is Huntley's proven pattern — changing it
  breaks the loop.
- NEVER ship app-specific rules inside the templates. Those belong in
  `CUSTOMIZE:` sections the user fills in per-app.
- ALWAYS remind the user to rename `*-prompt.template.md` → `*-prompt.md`
  AFTER customizing. The scripts look for `build-prompt.md` / `qa-prompt.md`,
  not the `.template.md` form.

## Integration with the rest of the playbook

- Runs AFTER `/playbook:prd-to-ralph` writes `ralph/prd.json`.
- Runs AFTER `/playbook:install-qa-harness` has installed the `.quality/`
  tree — harden.sh and harden-drift.sh both need it, and harden.sh calls
  `npx qa-controller` to verify mutation scores each iteration.
- Produces the input layer for the Phase 5 Ralph path in `/playbook:commands`.
- After `./ralph/run.sh` finishes (build + qa + harden), the user moves to
  Phase 6 (`/playbook:wire-selectors`) and Phase 7 (`/playbook:qa-run` for
  release gates producing the signed summary.md verdict).
- Tier 3 loops (completeness, adversarial, drift, security) are installed
  here but NOT chained into run.sh yet. Run them standalone during
  debugging; chain them into run.sh (see run.sh's Phase 3 pattern) once
  each has survived at least one real overnight run on your app.
