# install-qa-harness — Install the QA controller into a Next.js app

Scaffolds the full QA pipeline into a target Next.js app: controller code,
service detection, locked config, enforcement layers (permissions.deny, bash
hook, husky pre-commit), and the `.quality/` tree.

Input: `$ARGUMENTS` — optional flags.

## What It Does

1. **Copies the controller** (`playbook/qa-scaffold/controller/`) into the
   target app's `qa/` directory.
2. **Detects services** by scanning `package.json` + `.env.example` against
   the service registry (Clerk, Razorpay, Drizzle, Stripe, NextAuth, Auth.js,
   Supabase, Resend, Sentry, Upstash, Prisma, Lemon Squeezy).
3. **Generates `.env.test.example`** with the right env vars per detected
   service.
4. **Injects global-setup snippets** into `tests/global-setup.ts` for auth
   services (Clerk's `clerkSetup()`, NextAuth's session restore, etc.).
5. **Merges tier hints** into `.quality/policies/tiers.yaml` so auth and
   payment paths are automatically tagged `critical_75`.
6. **Scaffolds `.quality/`** with `contracts/`, `policies/`, `runs/` subdirs.
7. **Writes `providers.yaml`** (Claude enabled; Codex/Gemini scaffolded but
   disabled pending Seatbelt wrapper).
8. **Writes `thresholds.yaml`** with defaults (`max_attempts: 10`,
   `plateau_window: 3`, per-tool timeouts).
9. **Generates `lock-manifest.json`** — SHA256 of every locked config file.
10. **Installs enforcement templates** — `.claude/settings.json`,
    `.claude/hooks/block-locked-paths.sh`, `.husky/pre-commit`.
11. **Runs `npm install -D`** for queued dev dependencies
    (`@clerk/testing`, `msw`, etc.).
12. **Writes `.quality/install-report.md`** summarizing detection + install.

## Flags

- `--upgrade` — Idempotent re-run. Preserves user edits to policy files and
  snippets.
- `--strict-detection` — Abort if any unknown service is detected (F1 mode).
- `--stub-unknowns` — Generate `.yaml.stub` manifests for unknown services
  (F3 mode).
- `--dry-run` — Compute actions without writing anything.

## Steps

From the playbook repo:

```bash
cd <target-app>
tsx playbook/qa-scaffold/controller/installer/install.ts [flags]
```

Or invoke this slash command from Claude Code running in the target app
directory; Claude will run the installer script directly.

## After Install

1. Copy `.env.test.example` → `.env.test` and fill in real test-mode values.
   **Never commit `.env.test`.**
2. Review `.quality/policies/tiers.yaml` — every source file must match a
   glob (`unclassified_behavior: fail_fast`). Run
   `/playbook:qa-doctor` to check coverage.
3. Author contracts for your critical features:
   `/playbook:contract-pack <feature-name>`.
4. Run the first baseline: `npm run qa baseline`.
5. Run the first QA session: `npm run qa run`.
6. Install the Ralph loop stack (build + qa + harden + optional Tier 3
   standalone loops): `/playbook:scaffold-ralph`. The harden loops rely
   on this `.quality/` tree to read mutation baselines and verify scores,
   so `/playbook:install-qa-harness` must run FIRST, then
   `/playbook:scaffold-ralph`. See `/playbook:scaffold-ralph` for the
   full file manifest (currently 17 Ralph template files).

## Rules

- NEVER edit files under `.quality/` directly — they're locked. Use the
  controller commands.
- NEVER bypass the pre-commit hook without `QA_CONTROLLER_COMMIT=1`. The
  hook exists to catch accidental locked-path commits.
