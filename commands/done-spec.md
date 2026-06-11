# done-spec — Extract the definition of DONE from an existing app or module

Mines a reference implementation — your own legacy app, a module you're
rebuilding, or (degraded mode) a competitor you can only run — into
per-module DONE specifications: testable statements of what "complete"
means, tagged by how far the reference actually got. Born in the EventState
rebuild, where the legacy app's status files claimed COMPLETE for modules
the founder knew never worked.

One artifact, four consumers:
- **/goal conditions** — every DONE-MEANS statement is goal-condition
  material (measurable end state + the check that proves it)
- **prd-to-ralph** — statements seed `fail_to_pass` and verification anchors
- **Playwright** — statements are written so a real-user test derives
  mechanically (spec-runner / pathways consume them)
- **coverage-audit** — done-specs are a coverage generator: any DONE-MEANS
  statement with no pathway is a GAP

Input: `$ARGUMENTS` — module name (one module per session/agent) plus
optional `--mode code|runtime|hybrid`.

## Three access modes

| Mode | When | Evidence sources |
|---|---|---|
| `code` | You own the reference repo | Source + tests + git history + QA/red-team reports |
| `runtime` | App runs but no code (competitor/inspiration) | Census crawl + golden traces (record real journeys: screenshots, DOM, request/response shapes) |
| `hybrid` | Both (the rebuild case) | Everything; code claims verified against runtime |

In runtime mode, WORKS means "observed working in the live app" and the
SCARS section is replaced by OBSERVED-ROUGH-EDGES (visible bugs, slow
paths, confusing flows — competitor pain is your design input).

## Investigation order (code mode)

1. Map the module: routes, server actions/controllers, components, schema
   tables, and its tests (unit + e2e + locked contracts).
2. WORKS requires a test that exercises the behavior (cite it). Code-reading
   alone yields UNPROVEN, never WORKS. Status files (STATE.md, phase
   checklists) are claims, not evidence — founder testimony outranks them.
3. Unfinished intent: TODO/FIXME/HACK, commented-out blocks, handlers wired
   to nothing, schema columns nothing writes, flags never enabled,
   abandoned branches. Cite file:line each.
4. Scars: `git log` for fix/revert chains on the module's paths, QA: / RED: /
   SEC: commits, bug-triage and adversarial-report entries touching the
   module. Same-file-fixed-3+-times = chronic, flag it.
5. Original intent: the PRD/origin scope for what was promised, including
   the never-attempted.

## Output: `docs/done-spec/<module>.DONE.md`

```
## 1. WORKS (proven)            statement — code ref — test ref
## 2. INTENDED-BUT-UNFINISHED   what — evidence — how far it got
## 3. DONE MEANS (the goal)     numbered TESTABLE statements, each tagged
                                [WORKS] / [UNFINISHED] / [NEVER-ATTEMPTED]
## 4. SCARS                     what broke — ref — the lesson
## 5. CROSS-MODULE EDGES        triggers/dependencies, named not explored
## 6. SALVAGE                   templates, copy, validation rules, fixtures
COVERAGE NOTE                   what could not be determined and why
```

DONE-MEANS statements are the product. Write each so a Playwright test
falls out mechanically: actor + action + observable result + sad-path
twin. "Bulk-generating certificates for 500 delegates completes and every
PDF is individually downloadable" — not "certificates work". Include the
selector/data anchor when known.

## Parallelization (the cmux pattern)

Modules are disjoint — run one agent per module concurrently. Hard rules:
each agent writes ONLY its own `docs/done-spec/<module>.DONE.md`; source is
read-only; **no agent commits** (parallel agents race the git index) — a
final aggregator agent reads all files, writes `INDEX.md` ranking modules
by (UNFINISHED + SCARS), lists the top NEVER-ATTEMPTED statements
project-wide, and makes the single commit.

## Downstream wiring

- `/extract-pathways`: DONE-MEANS statements become pathway chains; SCARS
  become must-not-reproduce sad branches; EDGES seed cross-module pathways.
- `/playbook:coverage-audit`: add done-specs to sources — uncovered
  DONE-MEANS = GAP.
- `/playbook:prd-to-ralph`: statements map into acceptance criteria and
  `fail_to_pass`; chronic-scar modules warrant `hitl: true` consideration.
- `/ralph-goal` //goal: a story's goal condition quotes its DONE-MEANS
  statements verbatim — they are already measurable end states with checks.

## Rules

- Evidence or it doesn't exist: every claim cites file:line, test path,
  commit hash, report entry, or (runtime mode) a captured trace/screenshot
- Founder testimony beats status files; status files beat vibes
- Stay in the assigned module; name edges, don't chase them
- A healthy module gets a short honest report — never invent debt
- End every report with the COVERAGE NOTE; silent unknowns are how oracles
  get falsely trusted
