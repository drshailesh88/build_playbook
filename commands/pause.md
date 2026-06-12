# /pause — checkpoint this session so a FRESH one resumes it for cents

The founder can be tired at any point. An idle session costs nothing, but
its prompt cache expires within minutes — typing into a long stale session
re-reads the entire conversation uncached at full price, every message.
The cheap path is always: checkpoint → close → resume FRESH. This command
is the deterministic button for that ritual. (Tired phrasing — "sleepy",
"stopping", "continue tomorrow" — triggers the same protocol implicitly,
per AGENTS.md; `/pause` just removes the detection step.)

The counterpart is `/playbook:pickup`, run in a fresh session tomorrow.
NEVER suggest the vendor's built-in session-resume (`claude --resume` /
`/resume`) for a session that sat idle for hours — that is the exact
expensive path this command exists to avoid.

**Argument (optional):** a one-line note from the founder about where their
head was. Goes into the marker verbatim under `founder-note`.

**Scope:** founder-interactive sessions — grills, briefs, planning, PRD
work, design, triage, supervised execution. AFK loops (ralph and friends)
are exempt: they checkpoint mechanically via their own state files.

## Steps

### 1. Identify the in-flight protocol and its natural artifact

What protocol is this session running (`/playbook:wow-grill comms`, a
data-grill, ad-hoc planning…) and where does its state naturally live
(grill log, brief file, decisions file)? If the session has no natural
artifact, the marker goes into a new
`.planning/handoffs/<YYYY-MM-DD>-<purpose-slug>.md` instead.

### 2. Flush everything ruled so far — artifacts are truth

Write every decision, verdict, and answer received to its PROPER artifact:
DECs to the ledger (ids via `scripts/next-dec.sh`, never pre-allocated),
grill verdicts to the grill log, WOW-DELTA stamps to the delta file, brief
answers to the brief. Chat-only context is treated as nonexistent the
moment the founder closes the terminal.

If NOTHING has been ruled yet (paused before the first decision), skip the
flush — the marker alone, with the next question, is the whole checkpoint.

### 3. Scoped commit of the flushed state

`git add <exact paths you own>` — NEVER `git add .` / `-A` (parallel cmux
agents may own uncommitted files). Conventional commit. Note the hash; the
marker cites it as `pause-commit`.

### 4. Append the canonical RESUME-FROM-HERE block

Append to the natural artifact from step 1 (or the handoff file). This
exact format — `/playbook:pickup` greps the heading and parses the fields:

```markdown
## RESUME-FROM-HERE [open]

- marker-id: RFH-<YYYYMMDD-HHMM>-<slug>
- paused-at: <YYYY-MM-DD HH:MM local>
- protocol: <exact command + args to re-run, e.g. /playbook:wow-grill comms>
- protocol-source: <command file path> @ <git hash-object, first 12 chars>
- position: <precise location, e.g. "WOW-DELTA item 4 of 9 (live-poll overlays)">
- next-question: "<the next undecided question, VERBATIM>"
- ruled-artifacts: <paths holding what is already decided — do NOT re-open>
- read-first: <minimal paths pickup must load before speaking — token budget anchor>
- pause-commit: <hash from step 3, or "none — nothing ruled yet">
- fingerprints: <path @ git hash-object first-12, one per read-first path>
- founder-note: <argument verbatim, or —>
- consumed-by: —
```

Field discipline:
- `next-question` verbatim is what makes resume lossless — the fresh
  session opens with it, zero re-asking.
- `read-first` is the token ceiling: pickup reads these paths and NOTHING
  else before speaking. Keep it minimal — the ruled state is already on
  disk and listed under `ruled-artifacts` for reference, not re-reading.
- `fingerprints` (`git hash-object <path> | cut -c1-12`) lets pickup
  detect that an artifact changed under the marker (another agent edited
  it overnight) and warn instead of resuming blind.
- `protocol-source` lets pickup detect that the command file itself
  changed since the pause and report the drift.

### 5. The three-question self-check (every pause, silent)

Before committing the marker, audit it:

1. Is `next-question` actually the question the founder would have
   answered next — verbatim, in their language, about their module?
2. Is `read-first` short? It is a token ceiling, not a bibliography.
3. Did everything ruled land in its proper artifact (DEC ledger, grill
   log, delta file) — with the marker only POINTING at it?

Fix before committing; a marker that fails any of these fails tomorrow's
resume.

### 6. Commit the marker, confirm — first pause gets a founder audit

Scoped commit of the marker file.

**First pause in this repo?** Check:
`grep -rl --include="*.md" "RESUME-FROM-HERE" . | wc -l` — if the marker
you just wrote is the only hit, this discipline has never been
founder-verified here. Show the FULL marker block and the three questions
from step 5, and ask the founder to sanity-check once. Their "looks
right" is the trust handoff: every later pause runs the check silently
and confirms in one line only.

**Every pause after that**, exactly one line:

```
Paused at <position> — commit <hash>. Tomorrow, fresh session: /playbook:pickup
```

The founder closes the terminal. Done — do not summarize the session, do
not list what was accomplished; the artifacts already hold all of it.

## Rules

- `/pause` vs `/handoff`: `/pause` is the same-protocol interruption
  primitive — same command, same args, same next question tomorrow.
  `/handoff` is purpose-shaped compaction for a DIFFERENT next session
  ("debug the judge ladder") and requires that purpose as an argument.
  Pausing a grill to continue the grill = `/pause`. Closing a session so a
  differently-purposed agent picks up the project = `/handoff`.
- Never write a decision into the marker — decisions go to the ledger
  FIRST (step 2); the marker only points at them.
- One marker per pause. A session paused twice (resumed, then paused
  again) gets a fresh marker; the old one is already `[consumed]`.
- Redact secrets and PII from the marker, always.
