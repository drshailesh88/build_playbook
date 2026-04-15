# ralph-watch — Slack + Linear progress monitor for Ralph builds

Drops `ralph/watch.sh` into the target app. The watcher is a pure
observer — polls `ralph/prd.json` + `git log` every 60 seconds, posts
status to Slack, updates Linear issues. It does NOT modify any file
Ralph touches. Run in a separate terminal tab. Kill/restart freely.

**No API keys in env = no posting**, just a terminal heartbeat. This
makes it safe to scaffold in every app by default.

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

- One issue per story, created at watcher startup (`[<id>] <description>`)
- Issue moves to **In Progress** when the next story is up
- Issue moves to **In Review** when Ralph's builder commits `passes:true`
- Issue moves to **Done** (with commit-msg comment) when Codex commits
  `qa_tested:true`
- Falls back gracefully if any Linear state name doesn't exist on your
  team — silently skips the transition rather than erroring

## Flags

- `--force` — overwrite an existing `ralph/watch.sh`.
- `--dry-run` — print what would be copied without writing.

## Process

### Step 1: Find the template

```ts
import { existsSync } from "node:fs";
import { resolve } from "node:path";

const templatePath = [
  process.env.PLAYBOOK_ROOT,
  resolve(process.env.HOME ?? "", "Build Playbook"),
  resolve(process.env.HOME ?? "", "build_playbook"),
]
  .filter(Boolean)
  .map((root) => resolve(root as string, "playbook/qa-scaffold/templates/ralph/watch.sh"))
  .find((p) => existsSync(p));

if (!templatePath) {
  throw new Error(
    "Can't find watch.sh template. Set PLAYBOOK_ROOT to the playbook repo's absolute path.",
  );
}
```

### Step 2: Copy into `ralph/watch.sh`

```ts
import { promises as fs } from "node:fs";
import { join } from "node:path";

const target = join(process.cwd(), "ralph", "watch.sh");
await fs.mkdir(join(process.cwd(), "ralph"), { recursive: true });

const exists = await fs.access(target).then(() => true).catch(() => false);
if (exists && !flags.force) {
  console.log(`skip: ${target} already exists — pass --force to overwrite`);
  process.exit(0);
}
if (flags.dryRun) {
  console.log(`would copy ${templatePath} → ${target}`);
  process.exit(0);
}

await fs.copyFile(templatePath, target);
await fs.chmod(target, 0o755);
console.log(`wrote: ${target}`);
```

### Step 3: Print how to run it

```
✅ ralph/watch.sh installed.

To start the watcher (in a separate terminal tab):

  # All three optional — watcher falls back gracefully if any are missing.
  export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxx/yyy/zzz"
  export LINEAR_API_KEY="lin_api_xxxxx"
  export LINEAR_TEAM_ID="your-team-id"
  ./ralph/watch.sh

Notes:
- Reads ralph/prd.json (Huntley's flat array) + git log every 60s.
- Distinguishes BUILT (passes:true) from QA'd (qa_tested:true).
- Falls back to terminal output when env vars aren't set.
- Kill with Ctrl-C and restart anytime; it rebuilds state from disk.
- Pure observer: never writes to any file Ralph + Codex touch.
```

## Rules

- NEVER overwrite an existing `ralph/watch.sh` without `--force`. A
  customized watcher in progress shouldn't get clobbered by a re-scaffold.
- NEVER embed API keys in the scaffolded script. Read them from env.
- NEVER modify `ralph/prd.json`, `ralph/progress.txt`, or any file Ralph
  writes. The watcher is a read-only observer by design — this is the
  invariant that lets you kill/restart it freely without ever disturbing
  the build.
- NEVER post to Slack / update Linear without the env vars being set. A
  watcher with no env vars should run silently (terminal only).

## Integration

- Runs alongside `./ralph/run.sh` in a second terminal. No coordination
  between them — both read from the same `prd.json` + `git log` state.
- Uses Huntley's flat-array format exclusively (falls back from
  `description` to `title` to `id` for the story label so it works
  whatever field shape you use).
- Not needed for Phase 7 (your hardened QA pipeline) — that pipeline
  writes its own summaries to `.quality/runs/`.
