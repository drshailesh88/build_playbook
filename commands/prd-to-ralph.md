# prd-to-ralph — Convert PRD to Huntley's prd.json format

Converts the PRD + grilling decisions into the exact flat-array `prd.json`
that Huntley's `build-ralph.sh` expects. After this command, the target
app is ready for Huntley's Ralph loop.

Ralph itself does NOT live in this playbook. You clone/copy his scripts
(`build-ralph.sh`, `qa-ralph.sh`, `build-prompt.md`, `qa-prompt.md`,
`ralph-to-ralph.sh`) from
[github.com/ghuntley/ralph-to-ralph-prod](https://github.com/ghuntley/ralph-to-ralph-prod)
into the target app yourself. This command only builds the structured
input Ralph needs.

Input: `$ARGUMENTS` — optional flags.

## Why This Exists

Huntley's Ralph build loop reads `prd.json` (flat array) one entry at a
time, picks the first `passes: false`, implements it TDD-first, commits,
flips `passes: true`, signals `<promise>NEXT</promise>`. His counting
pattern iterates the flat array directly:

```bash
python3 -c "import json; d=json.load(open('prd.json')); print(sum(1 for x in d if x.get('passes', False)))"
```

Any wrapper (`{ userStories: [...] }`) breaks this. Output MUST be a
flat JSON array.

## Flags

- `--prd=<path>` — explicit PRD path; default `.planning/PRD.md`.
- `--out=<path>` — output path; default `ralph/prd.json`.
- `--from-existing=<path>` — append to an existing prd.json instead of
  overwriting (useful when a new feature needs to land mid-build).

## Preconditions

- A PRD exists at `.planning/PRD.md` (or wherever `--prd` points).
- Ideally, grilling-session decisions in `.planning/decisions/*.md`, and
  a UI brief at `.planning/ui-brief.md` for `ui_details` context.

## Process

### Step 1: Read source artifacts

```ts
const prd = await readFile(flags.prd ?? ".planning/PRD.md", "utf8");
const uxBrief = await readFile(".planning/ux-brief.md", "utf8").catch(() => null);
const uiBrief = await readFile(".planning/ui-brief.md", "utf8").catch(() => null);
const dataReqs = await readFile(".planning/data-requirements.md", "utf8").catch(() => null);
const decisionFiles = await glob(".planning/decisions/*.md");
```

### Step 2: Interview the user to break features into stories

Present the PRD sections as candidate entries, then ask the user to
confirm or edit each. Each entry should be **one build iteration** —
sized so Ralph can implement it end-to-end in one Claude invocation.

Guide rails for sizing:

- **Too big**: "Build the authentication system" — break into schema,
  login API, signup API, login UI, signup UI, middleware.
- **Too small**: "Add a log statement" — fold into the parent feature.
- **Right size**: "Login API endpoint — `POST /api/auth/login` validates
  credentials against the users table, issues a session cookie, returns
  `{ user: { id, email } }` on success, `401` on failure. Covers the
  happy path + invalid-credentials counterexample."

For each story confirmed, collect:

- **id** — kebab-case with category prefix, e.g. `infra-001`, `auth-003`,
  `billing-007`. Category + sequential number.
- **category** — one of Huntley's: `data`, `layout`, `ui`, `crud`,
  `settings`, `interaction`.
- **description** — the "what + why" in one sentence.
- **page** — UI route (e.g. `/login`) or `"N/A — Backend"` for pure
  backend work.
- **ui_details** — visual spec from the UI brief; `"N/A"` for backend.
- **behavior** — the full spec of what this feature does; should be
  long enough that Ralph doesn't need to ask follow-up questions.
- **data_model** — reference to schema tables involved, or
  `"See section X of build-spec.md"` if you're writing one.
- **priority** — integer (1-N). Lower = earlier.
- **core** — `true` if other features depend on it; `false` for
  leaf features.
- **tests** — skeleton with:
  - `unit: [{ name, description, input, expected_output }]`
  - `e2e: [{ name, steps: [], expected }]`
  - `edge_cases: [{ name, steps: [], expected }]`
- **passes** — always `false` on initial write; Ralph flips to `true`.

### Step 3: Topologically sort by priority

Sort by `priority` ascending. Within the same priority, keep the user's
entry order. Verify no cycle between `core` dependencies — if feature A
depends on feature B, A's `priority > B's priority`.

### Step 4: Write `ralph/prd.json` as a flat array

```ts
import { writeFile, mkdir } from "node:fs/promises";
import { dirname } from "node:path";

const outPath = flags.out ?? "ralph/prd.json";
await mkdir(dirname(outPath), { recursive: true });
await writeFile(outPath, JSON.stringify(entries, null, 2));
```

<HARD-GATE>
Output MUST be a flat array. Any wrapper object breaks Huntley's
counting pattern. Do not emit `{ "userStories": [...] }` or
`{ "items": [...] }` — the top-level JSON value MUST be `[ ... ]`.
</HARD-GATE>

### Step 5: Sanity-check the shape

Run a local validator that mimics Huntley's runtime checks:

```bash
python3 -c "
import json
d = json.load(open('ralph/prd.json'))
assert isinstance(d, list), 'prd.json must be a flat array'
required = {'id','category','description','page','ui_details','behavior','data_model','priority','core','passes','tests'}
test_keys = {'unit','e2e','edge_cases'}
for i, entry in enumerate(d):
    missing = required - set(entry.keys())
    assert not missing, f'entry {i} missing keys: {missing}'
    assert entry['passes'] is False, f'entry {i} must start with passes=false'
    assert set(entry['tests'].keys()) >= test_keys, f'entry {i} tests missing {test_keys - set(entry[\"tests\"].keys())}'
print(f'OK: {len(d)} entries, all shape-valid')
"
```

Abort on any assertion failure.

### Step 6: Print the handoff message

```
✅ ralph/prd.json written — N entries, all passes=false.

You're ready for Ralph.

Next steps:
  1. Scaffold the Ralph scripts + prompts (DO NOT download Huntley's raw
     scripts — they reference his product-cloning infra, AWS SES, Ever CLI,
     clone-product-docs/, which you don't have):
       /playbook:scaffold-ralph

     This drops adapted templates into ralph/:
       ralph/build.sh              — Huntley's build loop, adapted
       ralph/build-prompt.md       — build agent instructions (customize per app)
       ralph/qa.sh                 — Codex QA loop (independent evaluator)
       ralph/qa-prompt.md          — QA agent instructions (customize per app)
       ralph/run.sh                — master script, chains build → QA

  2. Customize ralph/build-prompt.md and ralph/qa-prompt.md — fill in the
     CUSTOMIZE sections with your app's module paths, quality-check commands,
     locked paths, and app-specific rules.

  3. (Optional) Add Slack/Linear progress monitoring in a second terminal:
       /playbook:ralph-watch

  4. Run the full three-layer flow:
       ./ralph/run.sh                         # build (Claude Opus) → QA (Codex)

  5. Then run YOUR hardened QA pipeline (the ungameable judge):
       /playbook:install-qa-harness           # if not already installed
       /playbook:define-quality-contracts     # for critical features
       npm run qa:baseline
       npm run qa:run

Reference Ralph repos (for learning the methodology — not to be cloned):
  github.com/ghuntley/ralph-to-ralph-prod    — production-grade build+QA loops
  github.com/ghuntley/how-to-ralph-wiggum    — how-to guide
  github.com/ghuntley/ralph-os               — the pattern's origin
```

## Rules

- NEVER wrap the array in an object. Top-level JSON value is `[...]`,
  period. Huntley's `build-ralph.sh` iterates the array directly.
- NEVER set `passes: true` on initial write. Only Ralph flips this
  during its build loop.
- NEVER invent features the PRD doesn't mention. If the PRD is vague
  on a feature, STOP and ask the user instead of hallucinating.
- NEVER ship Ralph's scripts from the playbook. The user pulls them
  from Huntley's repo at build time. The playbook's responsibility
  ends at writing `prd.json`.
- ALWAYS include at least one `unit` test skeleton and one `e2e` test
  skeleton per feature — otherwise Ralph's TDD discipline is
  undermined.
- ALWAYS sort by priority ascending. Core dependencies must come first.
- ALWAYS keep `behavior` long enough (3+ sentences minimum) that Ralph
  doesn't need to ask follow-up questions. Sparse `behavior` fields
  produce sparse code.

## Integration with the playbook

- Runs after `/playbook:define-quality-contracts` — both consume the
  PRD, but produce different artifacts:
  - `define-quality-contracts` → `.quality/contracts/<feature>/` (the
    ungameable oracle).
  - `prd-to-ralph` → `ralph/prd.json` (the build task list).
- After Ralph finishes, the user runs `/playbook:wire-selectors` per
  feature to reconcile the `data-testid` selectors in contracts with
  the DOM Ralph produced.
- Then `/playbook:qa-run` enforces the contracts against the built app.

## Not in scope

- Ralph's build loop, QA loop, watchdog, or progress monitoring. All
  external to the playbook by design.
- Progress monitoring (watch.sh posting to Slack/Linear) — not shipped
  here; user maintains this in the target app if desired.
