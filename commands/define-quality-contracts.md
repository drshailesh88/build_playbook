# define-quality-contracts — Author ALL contracts before a single line of code

Runs AFTER the PRD + grilling sessions, BEFORE Ralph builds. Chains
`classify-modules` (from PRD, not code), `contract-pack` for every
critical feature, and `author-locked-tests` for each — all in one
planning session, while the oracle is maximally pure (there's literally
no source code to contaminate it).

After this command: `.quality/contracts/` is fully populated and frozen.
After Ralph builds, the only manual step is `/playbook:wire-selectors`
per feature (selectors don't match the DOM until the UI exists).

Input: `$ARGUMENTS` — optional flags (see below).

## Why This Exists

Contract-pack and author-locked-tests already enforce oracle independence
via source-denied permissions. But "source-denied" is a mechanical safety
net. When you author contracts BEFORE the code exists at all, the oracle
is pure by construction — there is no source to deny reading. This is
TDD applied to the entire app: define correct → build to it → test
against it.

The practical win: no more interviews mid-build. After Ralph finishes,
you run `wire-selectors` once per feature, then `npm run qa:baseline`
and `npm run qa:run`. Everything else is `npm`.

## When to Run

```
/playbook:capture-planning         ← if grilling happened elsewhere
/playbook:ux-brief
/playbook:ui-brief
/playbook:data-grill
/playbook:infra-grill
/playbook:write-a-prd
/playbook:db-architect
/playbook:define-quality-contracts ← HERE (all contract authoring)

# Bridge — scaffold Next.js app + install deps
/playbook:prd-to-gsd                (or prd-to-ralph when it exists)

# Build (walk away)
./ralph/run.sh                      (or /playbook:ralph-loop)

# Wire selectors (5 min per feature after Ralph finishes)
/playbook:wire-selectors <feature>

# Install harness + test (walk away)
/playbook:install-qa-harness        ← --upgrade preserves .quality/contracts/
npm run qa:baseline
npm run qa:run
```

## Flags

- `--features="<a>,<b>,<c>"` — explicit feature list; skip the interview
  that picks features from the PRD.
- `--tiers-only` — write `tiers.yaml` only; skip contract authoring.
- `--skip-locked-tests` — author contract packs only; skip the
  `author-locked-tests` step (useful when you want to review the
  contracts before tests are generated).
- `--prd=<path>` — explicit PRD path; default searches `.planning/`.

## Preconditions

- A PRD exists at `.planning/PRD.md` (or wherever `--prd` points).
- Ideally, grilling-session decisions in `.planning/decisions/*.md`.
- **There should be no `src/`, `app/`, `lib/`, `components/`, or
  `pages/` directory yet.** If any of these exist, Claude must refuse
  and direct the user to run the per-feature commands (`contract-pack`,
  `author-locked-tests`) individually with source-denied authoring — the
  "before any code" purity invariant is violated.

<HARD-GATE>
Abort if any of `src/`, `app/`, `lib/`, `components/`, `pages/` contain
source files (`.ts`, `.tsx`, `.js`, `.jsx`). The guarantee this command
makes — "oracle pure by construction" — only holds pre-code. Post-code,
use per-feature commands instead.
</HARD-GATE>

## Process

### Step 1: Bootstrap `.quality/` (manual — no installer yet)

`install-qa-harness` needs a `package.json` to run service detection,
but at this stage there isn't one. Write the directory skeleton directly:

```bash
mkdir -p .quality/contracts
mkdir -p .quality/policies
mkdir -p .quality/runs
```

### Step 2: Read the PRD + grilling decisions

```ts
import { readFile } from "node:fs/promises";

const prdPath = flags.prd ?? ".planning/PRD.md";
const prd = await readFile(prdPath, "utf8");

// Optional — grilling session captures
import { globby } from "globby";
const decisionFiles = await globby(".planning/decisions/*.md");
const decisions = await Promise.all(
  decisionFiles.map((p) => readFile(p, "utf8")),
);
```

### Step 3: Swap in contract-authoring settings

```bash
cp .claude/settings.json .claude/settings.json.loop 2>/dev/null || true
cp .claude/settings-contract-authoring.json .claude/settings.json 2>/dev/null \
  || echo "(settings-contract-authoring not installed yet — proceed with caution)"
```

Post-install-qa-harness this will snap into place automatically. Pre-install,
the file may not exist — that's acceptable here because there's no source to
guard against.

### Step 4: Identify features from the PRD

Present features found in the PRD to the user:

```
I found these features in your PRD:

  1. user-authentication          (auth)         → suggest critical_75
  2. certificate-generation       (user_data)    → suggest critical_75
  3. cascade-assignment           (business_logic) → suggest critical_75 (high-blast-radius)
  4. notification-dispatch        (business_logic) → suggest business_60
  5. admin-dashboard              (ui)           → suggest ui_gates_only

Confirm which to author contracts for [Y/n for each]:
Confirm the tier for each [critical_75 / business_60 / ui_gates_only]:
```

Security-sensitive categories (`auth`, `payments`, `user_data`) always
get `critical_75` + `security_sensitive: true` per blueprint 12e.

### Step 5: Draft `tiers.yaml` from PRD architecture

Look for an "Architecture" or "Folder Structure" section in the PRD.
Draft globs from the planned directories, not scanned ones:

```yaml
# .quality/policies/tiers.yaml
schema_version: 1
tiers:
  critical_75:
    - "src/auth/**"
    - "src/certificates/**"
    - "src/cascade/**"
    - "middleware.ts"
    - "app/api/auth/**"
  business_60:
    - "src/lib/**"
    - "app/api/**"
  ui_gates_only:
    - "src/components/**"
    - "app/**/page.tsx"
    - "app/**/layout.tsx"
unclassified_behavior: fail_fast
```

Show the draft to the user and ask for approval. Save on confirmation.

**Note:** `classify-check` won't meaningfully verify at this stage —
there are zero source files to classify. Defer verification to post-build
(`/playbook:classify-check` after Ralph finishes).

### Step 6: For each critical feature → run contract-pack interview

For each feature the user confirmed in Step 4, invoke the full
`contract-pack` interview. This is the long part — plan for 15-30 min
per feature. The user answers:

- 5–15 happy-path examples
- 3–10 counterexamples
- 3–8 invariants
- 3–5 edge cases
- API shape (if applicable)

Claude writes `.quality/contracts/<feature>/` and calls
`initializeContract` + `freezeContract` from `qa/contract-utils.js`
(or the equivalent bundled path pre-install).

**Use the existing `/playbook:contract-pack` command logic** — this
command doesn't duplicate it, it chains it. Invoke via subprocess or
agent call, one feature at a time. Commit after each feature so progress
is never lost:

```bash
git add .quality/contracts/<feature>/
git commit -m "contract(<feature>): frozen pack — N examples, N counterexamples"
```

### Step 7: For each frozen contract → run author-locked-tests

Once all contracts are frozen, chain `author-locked-tests` for each.
This generates `acceptance.spec.ts` under source-denied permissions (no
source exists anyway — this is doubly safe):

```bash
# For each feature:
/playbook:author-locked-tests <feature>
# Renames .draft → .spec.ts manually, commits.
```

The tests will reference `data-testid` values the user guesses from the
UI brief. They will NOT match the DOM when Ralph first builds — that's
expected. `/playbook:wire-selectors` fixes that post-build under tight
permissions.

### Step 8: Best-effort `.env.test.example`

Grep the PRD for known service mentions (Clerk, Razorpay, Stripe,
Drizzle, Supabase, NextAuth, Resend, Sentry, Upstash, Prisma, Lemon
Squeezy). For each hit, look up the service manifest in
`playbook/qa-scaffold/registry/services/<service>.yaml` and emit its
`env_test_vars`:

```bash
# .env.test.example — generated pre-install from PRD service mentions
# Copy to .env.test and fill in real test-mode values. Never commit .env.test.
#
# Clerk test keys
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
# ...
```

This is a starting point — `install-qa-harness` will re-scan
`package.json` later and merge anything missed.

### Step 9: Sanity check + report

Write `.quality/pre-build-manifest.md`:

```markdown
# Pre-Build Quality Manifest

Authored: <timestamp>
PRD source: .planning/PRD.md
Grilling captures: N files in .planning/decisions/

## Contracts frozen

- auth-login (critical_75, auth, security_sensitive=true)
- certificate-issue (critical_75, user_data, security_sensitive=true)
- cascade-assign (critical_75, business_logic)
- notification-send (business_60, business_logic)

## tiers.yaml drafted

- 5 globs under critical_75
- 2 globs under business_60
- 3 globs under ui_gates_only
- unclassified_behavior: fail_fast

## Next steps

1. Scaffold the app (`/playbook:prd-to-gsd` + Ralph, or manual).
2. `/playbook:install-qa-harness --upgrade` — merges service detection
   without clobbering the contracts + tiers written here.
3. Build the features (Ralph or manual).
4. `/playbook:wire-selectors <feature>` per feature to fix data-testid
   selectors against the real DOM.
5. `npm run qa:baseline` to populate module mutation baselines.
6. `npm run qa:run` for the first QA session.
```

### Step 10: Swap settings back + commit

```bash
cp .claude/settings.json.loop .claude/settings.json 2>/dev/null || true
git add .quality/
git commit -m "contracts: define quality contracts pre-build — N features"
```

## Rules

- NEVER run this after source code exists. If any
  `src/`/`app/`/`lib/`/`components/`/`pages/` file is present, abort and
  tell the user to run `/playbook:contract-pack` + `/playbook:author-locked-tests`
  per feature instead. The oracle-pure-by-construction guarantee only
  holds pre-code.
- NEVER accept a PRD as "done" without user sign-off — if the PRD is
  vague on a feature, STOP and interview the user instead of
  hallucinating examples.
- NEVER skip the user-approval loop in contract-pack. Chaining doesn't
  mean automating the judgment — every example, counterexample, and
  invariant must be explicitly confirmed.
- NEVER author contracts for `ui_gates_only` features. Presentation
  components use static + a11y + visual gates, not mutation oracles.
- ALWAYS commit after each feature's contract freezes. A 10-feature
  session is long; don't lose progress if the user quits mid-way.
- ALWAYS re-run `/playbook:classify-check` AFTER Ralph builds. The
  pre-build tiers.yaml is a prediction — verify it matches the real
  source tree before the first `qa run`.

## Integration with other commands

- Assumes `/playbook:contract-pack` and `/playbook:author-locked-tests`
  are globally installed (symlinked from this repo's `commands/` into
  `~/.claude/commands/playbook/`).
- Writes to the same `.quality/contracts/` tree that
  `/playbook:install-qa-harness --upgrade` preserves on later install.
- The `--upgrade` flag on the installer merges `tiers.yaml` additively,
  so any service tier hints added post-install don't clobber the
  hand-picked globs written here.
