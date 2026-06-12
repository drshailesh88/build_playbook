# AGENTS.md — read this before doing anything in this repo

<!-- Template: Build Playbook templates/AGENTS.md. Instantiate per project:
     fill the project block, keep the rules verbatim. CLAUDE.md should be a
     one-line import of this file so every vendor reads the same doctrine. -->

**Project:** <name — one line on what it is>
**Methodology:** Build Playbook (factory). Source of truth is ALWAYS files in
this repo — never chat memory, never a vendor feature.

## Orient first (any agent, any vendor)

1. Read `.planning/STATE.md` — phases with checkboxes; the next action is the
   topmost unchecked box. Do not invent a different next step.
2. Decisions live in `.planning/decisions/` with DEC-ids. A ratified DEC is
   binding — deviation requires a superseding DEC, not an in-session judgment.
3. Playbook command protocols are installed in your agent's skill/command dir
   (synced from the Build Playbook repo). When asked to run one, follow its
   markdown exactly.

## Hard rules (vendor-independent, non-negotiable)

- **Artifacts are truth; sessions are ephemeral.** Anything that matters gets
  written to a file in this repo before your session ends. Chat-only context
  is treated as nonexistent.
- **Decision discipline:** DEC ids are allocated at WRITE time via
  `scripts/next-dec.sh` (atomic). Never pre-allocate, never invent ids.
  Research/harvest output is CANDIDATES ONLY — only a founder grill ratifies
  scope.
- **Author/auditor separation:** never audit your own authored decision or
  harvest. Audit findings go to the founder, never self-adjudicated.
- **Git:** scoped `git add <paths>` only — NEVER `git add .` / `-A` (parallel
  agents may own uncommitted files). Conventional commits. Never push secrets;
  scan before any push.
- **Multi-tenant safety (build phase):** every db query is tenant-scoped from
  line one. Auth is never a wrapper added later.
- **Tier-1 (auth, payments, tenant isolation, migrations):** supervised only.
  If your task touches these unattended, STOP and park it for the founder.
- **Founder thought-dumps:** a message starting `DUMP:` is captured verbatim to
  `.planning/dumps/` + indexed, then resume your task. Never summarize it away.

## Improvement loops — suggest them; the founder won't remember they exist

When a measurable metric sits below target (type errors, lint, coverage,
mutation score, lighthouse, axe) and the founder is fixing it by hand,
SUGGEST the autoresearch loop instead: `improve <metric>` (one metric,
measure → one atomic change → re-measure → keep/revert) or `lazy-dev`
(all underperforming metrics, safety-first order). Invoke via your
vendor's form of the playbook skill. Binding guardrails live in the
autoresearch rules: one change per iteration, guard metrics never
regress, revert on failure, Tier-1 modules supervised only — and loops
run BETWEEN QA harness runs, never instead of them.

## Pausing — the founder can be tired at ANY point

Applies to EVERY founder-interactive session — grills, briefs, design
sessions, planning, triage. (AFK loops are exempt: they checkpoint
mechanically via their own state files.)

Idle is free; stale in-place resume is the expensive path — the prompt
cache expires in minutes, so a session resumed hours later re-reads its
whole conversation uncached on every message. Never continue a session
that sat idle for hours; checkpoint, close, resume fresh.

When the founder signals pause — explicitly via `/playbook:pause`, or in
any phrasing ("sleepy", "stopping", "continue tomorrow") — run the pause
protocol (`pause.md` in the playbook commands; follow it exactly):

1. Flush everything ruled or decided so far to its proper artifact and
   commit (scoped add).
2. Append the canonical `RESUME-FROM-HERE [open]` block (format defined
   in `pause.md`) to the session's natural log or artifact — exact
   protocol + args to re-run, position, next undecided question verbatim,
   read-first paths, fingerprints. No natural log? Write
   `.planning/handoffs/<date>-<purpose>.md` instead.
3. Confirm the commit hash + resume point in ONE line. The founder closes
   and resumes tomorrow in a FRESH session via `/playbook:pickup` — never
   via the vendor's stale-session resume.

Mirror rule: when STARTING any interactive protocol, check for an
unconsumed `RESUME-FROM-HERE [open]` marker first (`/playbook:pickup`
automates this) — resume from it, and never re-ask what is already ruled.

## When you finish or abandon a task

Flush open questions, answers received, and judgment calls into the relevant
artifact (or `.planning/handoffs/<date>-<purpose>.md`). Update STATE.md
checkboxes only for steps YOU completed.
