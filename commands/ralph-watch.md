# ralph-watch — Slack + Linear progress monitor for Ralph builds

Drops `ralph/watch.sh` into the target app. The watcher is a pure
observer — polls `ralph/prd.json` + `git log` every 60 seconds, posts
status to Slack, creates/updates Linear issues via the `linear` CLI. It
does NOT modify any file Ralph touches. Run in a separate terminal tab.
Kill/restart freely; issue map persists to `ralph/.linear-issues.txt`.

**Per-project config lives in `ralph/.env`** (gitignored). No command-
line secrets. Same repo can target different Slack channels in
different checkouts.

Input: `$ARGUMENTS` — optional flags.

## What You See

### Slack

```
🚀 Ralph build started
Features: 0/42 built, 0/42 QA'd
⬜ infra-001: Database schema — Drizzle ORM models
⬜ auth-001: Login API endpoint
⬜ auth-002: Signup API endpoint
...

✅ Built: infra-001 — Database schema — Drizzle ORM models
Progress: 1/42 built, 0/42 QA'd
Commit: `RALPH: infra-001 - Database schema — added users, events, sessions`

🟢 QA'd: infra-001 — Database schema — Drizzle ORM models
Progress: 1/42 built, 1/42 QA'd
Commit: `QA: infra-001 - fixed 0 bugs in Database schema`

🎉 Ralph COMPLETE!
All 42 features built AND QA'd.

Next: run your hardened QA pipeline (`npm run qa:run`).
```

### Linear

- One issue per story, created at watcher startup (`[<id>] <description>`).
  The mapping `<story-id>:<LINEAR-KEY>` is persisted to
  `ralph/.linear-issues.txt` so restarts never double-create.
- Moves to **In Progress** when the next story is up.
- Moves to **In Review** when the builder commits `passes:true`.
- Moves to **Done** (with commit-msg comment) when Codex commits
  `qa_tested:true`.
- Skips silently if any state name doesn't exist on your team.

## Dependencies

- **`linear` CLI** — required for Linear updates. `brew install linear`.
  Authenticate once with `linear auth login`. The watcher detects auth
  via `linear auth whoami` and falls back to Slack-only if missing.
- **`curl`, `python3`** — standard on macOS.
- **Optional: global launcher** (see below).

## Flags

- `--install-launcher` — also install `~/.local/bin/ralph-watch` (a thin
  wrapper that `cd`s into any project and runs its `ralph/watch.sh`).
  One-time install; idempotent.
- `--force` — overwrite an existing `ralph/watch.sh`.
- `--dry-run` — print what would be copied without writing.

## Process

### Step 1: Locate the playbook templates

```ts
import { existsSync } from "node:fs";
import { resolve } from "node:path";

const playbookRoot = [
  process.env.PLAYBOOK_ROOT,
  resolve(process.env.HOME ?? "", "Build Playbook"),
  resolve(process.env.HOME ?? "", "build_playbook"),
]
  .filter(Boolean)
  .find((root) =>
    existsSync(resolve(root as string, "playbook/qa-scaffold/templates/ralph/watch.sh")),
  );

if (!playbookRoot) {
  throw new Error(
    "Can't find the playbook repo. Set PLAYBOOK_ROOT to its absolute path.",
  );
}

const watchTemplate = resolve(playbookRoot as string, "playbook/qa-scaffold/templates/ralph/watch.sh");
const launcherTemplate = resolve(playbookRoot as string, "playbook/qa-scaffold/templates/bin/ralph-watch");
```

### Step 2: Copy watch.sh into the project

```ts
import { promises as fs } from "node:fs";
import { join } from "node:path";

const target = join(process.cwd(), "ralph", "watch.sh");
await fs.mkdir(join(process.cwd(), "ralph"), { recursive: true });

const exists = await fs.access(target).then(() => true).catch(() => false);
if (exists && !flags.force) {
  console.log(`skip: ${target} already exists — pass --force to overwrite`);
} else if (!flags.dryRun) {
  await fs.copyFile(watchTemplate, target);
  await fs.chmod(target, 0o755);
  console.log(`wrote: ${target}`);
}
```

### Step 3: Optionally install the global launcher

If `--install-launcher` is set:

```ts
import { join } from "node:path";
import { promises as fs } from "node:fs";

const launcherDst = join(process.env.HOME ?? "", ".local", "bin", "ralph-watch");
await fs.mkdir(join(process.env.HOME ?? "", ".local", "bin"), { recursive: true });

await fs.copyFile(launcherTemplate, launcherDst);
await fs.chmod(launcherDst, 0o755);
console.log(`wrote launcher: ${launcherDst}`);
console.log(`(ensure ~/.local/bin is on PATH — add \`export PATH="$HOME/.local/bin:$PATH"\` to your shell rc if needed)`);
```

### Step 4: Write an example `ralph/.env` if none exists

Don't clobber an existing one. Write a template the user edits:

```ts
const envPath = join(process.cwd(), "ralph", ".env");
const envExists = await fs.access(envPath).then(() => true).catch(() => false);
if (!envExists && !flags.dryRun) {
  await fs.writeFile(
    envPath,
    [
      "# ralph/.env — per-project secrets for watch.sh. Gitignored.",
      "# Copy to ralph/.env and fill in. Never commit.",
      "",
      "# Required for Slack updates:",
      "SLACK_WEBHOOK_URL=",
      "",
      "# Optional — overrides auto-detected Linear team (first team from `linear team list`).",
      "# LINEAR_TEAM=DRS",
      "",
    ].join("\n"),
  );
  console.log(`wrote template: ${envPath}`);
}
```

### Step 5: Ensure gitignore

Append (idempotently) to the project's `.gitignore`:

```
# ralph watcher — per-project secrets + state
ralph/.env
ralph/.linear-issues.txt
```

### Step 6: Print usage

```
✅ ralph/watch.sh installed.

Per-project config:
  ralph/.env               — SLACK_WEBHOOK_URL (required), LINEAR_TEAM (optional)

Linear CLI (optional — skip silently if missing):
  brew install linear
  linear auth login

To run:
  ./ralph/watch.sh                    # from project root

Or (if you installed the launcher via --install-launcher):
  ralph-watch                         # from project root
  ralph-watch /path/to/any/project    # from anywhere

Notes:
- Pure observer — never writes to files Ralph touches.
- Issue map persists to ralph/.linear-issues.txt — safe to restart.
- Both ralph/.env and ralph/.linear-issues.txt are added to .gitignore.
```

## Rules

- NEVER overwrite `ralph/watch.sh` without `--force`. A customized
  watcher in progress shouldn't get clobbered.
- NEVER embed API keys in the scaffolded script. Only `ralph/.env`.
- NEVER modify `ralph/prd.json`, `ralph/progress.txt`, or any file
  Ralph writes. Pure observer by design.
- NEVER post to Slack without `SLACK_WEBHOOK_URL` set. Unset = silent.
- NEVER create Linear issues without `linear` CLI + auth. Missing =
  Slack-only operation.

## Integration

- Runs alongside `./ralph/run.sh` in a separate terminal. No
  coordination — both read from the same `prd.json` + `git log` state.
- Uses Huntley's flat-array format exclusively (falls back from
  `description` → `title` → `id` for the story label).
- Not needed for Phase 7 (hardened QA pipeline) — that writes its own
  summaries to `.quality/runs/`.

## Why `linear` CLI instead of GraphQL

Early drafts used raw GraphQL with `LINEAR_API_KEY`. We switched to the
`linear` CLI because:

- Auth is handled once globally (`linear auth login`), not per-project.
- Team resolution, state name lookup, and issue creation are one-liners
  — no manual schema queries.
- Errors surface in readable form instead of JSON-in-JSON.
- The watcher silently skips Linear if the CLI isn't present, so
  Slack-only environments are unaffected.
