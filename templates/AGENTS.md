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

## When you finish or abandon a task

Flush open questions, answers received, and judgment calls into the relevant
artifact (or `.planning/handoffs/<date>-<purpose>.md`). Update STATE.md
checkboxes only for steps YOU completed.
