# scaffold-ralph — Install adapted Ralph scripts into the target app

Drops the three-layer Ralph stack (build.sh → qa.sh chained via run.sh)
plus the build and QA prompt templates into the target app's `ralph/`
directory. Scripts are generic; the prompt templates have `CUSTOMIZE:`
markers you fill in with your app's specifics.

**Do NOT download Huntley's raw scripts.** They reference his
product-cloning infra (build-spec.md, clone-product-docs/, AWS SES,
Ever CLI) that you don't have. The templates this command drops are the
Huntley methodology adapted for PRD-based app-building.

Input: `$ARGUMENTS` — optional flags.

## What This Installs

In the target app's `ralph/` directory:

| File | Purpose |
|---|---|
| `ralph/build.sh` | Build loop. Invokes Claude Code (Opus 4.6) with `--dangerously-skip-permissions --print`. One feature per iteration. Parses `<promise>NEXT\|COMPLETE\|ABORT</promise>` to drive the loop. Reads `ralph/prd.json`, `ralph/build-prompt.md`, `ralph/progress.txt`. Default 999 iterations, 20-minute per-iter timeout. |
| `ralph/qa.sh` | QA loop. Invokes `codex exec --dangerously-bypass-approvals-and-sandbox`. Picks the first `passes:true` feature that isn't `qa_tested:true` yet. Fixes bugs in the code (never the tests), commits with `QA: <story-id>` prefix, flips `qa_tested:true`. |
| `ralph/run.sh` | Master entrypoint. Chains `build.sh` → `qa.sh`. Logs everything to `ralph/ralph-<timestamp>.log`. macOS notification + opens `progress.txt` on completion. |
| `ralph/build-prompt.template.md` | Build agent instructions. Generic Huntley methodology + ABORT decision tree + `CUSTOMIZE:` placeholders for your app's module paths, quality-check commands, external services, locked paths. You rename to `build-prompt.md` after customizing. |
| `ralph/qa-prompt.template.md` | QA agent instructions. Generic independent-evaluator pattern + `CUSTOMIZE:` markers. Rename to `qa-prompt.md` after customizing. |
| `ralph/RESUME.md` | Stall recovery runbook in plain English. What to check, how to soft/hard interrupt, how to triage untracked files, how to restart. Read this BEFORE you panic at 2am. |

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
```

### Step 2: Copy templates into target app's `ralph/`

```ts
import { promises as fs } from "node:fs";
import { join, resolve as pathResolve } from "node:path";

const targetRalph = pathResolve(process.cwd(), "ralph");
await fs.mkdir(targetRalph, { recursive: true });

const TEMPLATE_MAP: Array<[string, string]> = [
  // [src name in templates/, dst name in target ralph/]
  ["build.sh", "build.sh"],
  ["qa.sh", "qa.sh"],
  ["run.sh", "run.sh"],
  ["watch.sh", "watch.sh"],
  ["build-prompt.template.md", "build-prompt.template.md"],
  ["qa-prompt.template.md", "qa-prompt.template.md"],
  ["RESUME.md", "RESUME.md"],
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
```

### Step 3: Print customization checklist

```
✅ Ralph scripts scaffolded at ./ralph/

Next (required before running):

1. Customize ralph/build-prompt.template.md:
   - Replace {APP_NAME}
   - Fill in every "CUSTOMIZE:" section with your app's specifics:
       * Module-path references (e.g. "src/lib/actions/travel.ts")
       * App-specific absolute rules (port numbers, scoping invariants)
       * Quality-check commands (your exact npm run scripts)
       * Locked paths beyond the defaults
   - Rename to build-prompt.md

2. Customize ralph/qa-prompt.template.md:
   - Same placeholders as above
   - Rename to qa-prompt.md

3. Ensure ralph/prd.json exists (run /playbook:prd-to-ralph if not).

4. Run:
   ./ralph/run.sh                # full build → QA chain, default 999 iters each
   ./ralph/run.sh 50 50          # cap each phase at 50 iters

5. (Optional) In a second terminal, monitor progress on Slack + Linear:
   /playbook:ralph-watch         # drops ralph/watch.sh
   SLACK_WEBHOOK_URL=... LINEAR_API_KEY=... LINEAR_TEAM_ID=... ./ralph/watch.sh

After Ralph finishes, run YOUR hardened QA pipeline (the ungameable judge):
   /playbook:install-qa-harness           # if not already installed
   /playbook:define-quality-contracts     # for critical features
   npm run qa:baseline
   npm run qa:run
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
- Produces the input layer for the Phase 5 Ralph path in `/playbook:commands`.
- After Ralph's build+QA finishes, the user moves to Phase 6
  (`/playbook:wire-selectors`) and Phase 7
  (`/playbook:install-qa-harness` → `/playbook:qa-run`).
