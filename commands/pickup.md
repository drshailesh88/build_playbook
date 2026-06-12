# /pickup — resume a paused session in THIS fresh session, for cents

Counterpart of `/playbook:pause`. A paused session left a canonical
`RESUME-FROM-HERE [open]` marker in its natural artifact; this command
finds it, claims it, loads ONLY what the marker cites, and re-enters the
original protocol at the exact undecided question. Named `pickup` — not
`resume` — deliberately: the vendor's `/resume` reopens the stale session
in-place, which re-reads the whole conversation uncached at full price.
Never do that for a session that sat idle for hours.

**Argument (optional):** a marker-id or module/slug fragment to
disambiguate when several markers are open.

## Steps

### 0. Interrupted-pause check

`git status --short .planning/` first. Uncommitted planning artifacts may
be a pause that crashed mid-flush (checkpoint written, commit never
happened). If any exist, name them and ask the founder whether they are
this session's resume state before hunting for markers. Do not commit
files of unknown ownership — parallel agents may own them.

### 1. Find open markers

```bash
grep -rln --include="*.md" "RESUME-FROM-HERE \[open\]" .
```

- **Zero found:** say so, and fall back to `/playbook:where-am-i` —
  there is nothing mid-session to pick up; orient at project level
  instead.
- **One found:** proceed.
- **Several found:** list each as `marker-id — protocol — position —
  paused-at` and ask which (or match the argument). Parallel cmux
  sessions pause independently; multiple open markers are normal, not an
  error.

### 2. Claim the marker BEFORE doing any work

Double-resume guard (two terminals may run `/pickup` simultaneously):

1. Edit the heading `[open]` → `[consumed]` and fill
   `consumed-by: <session/agent id> <YYYY-MM-DD HH:MM>`.
2. Re-read the block immediately. If it shows someone ELSE's consumed-by,
   another session won the race — stop and pick a different marker.
3. Scoped-commit the claim now, not at the end.

### 3. Staleness checks — warn, don't silently resume

- For each `fingerprints` entry: recompute
  `git hash-object <path> | cut -c1-12`. A mismatch means the artifact
  changed after the pause (overnight agent, parallel session). Name the
  changed files and ask the founder before proceeding — the marker's
  `position` may no longer be true.
- Recompute the hash of `protocol-source`. A mismatch means the command
  protocol itself changed since the pause. Report the drift in one line;
  the current command file wins, but the founder should know.
- If `pause-commit` is not an ancestor of HEAD (different machine, branch
  drift), say so — the flushed state may not be present here.

### 4. Load minimally, confirm, re-enter

1. Read ONLY the `read-first` paths. `ruled-artifacts` are settled — do
   not re-read them wholesale, do not re-open anything they hold.
2. Confirm the resume point to the founder in ONE line:

   ```
   Resuming <protocol> at <position> (paused <paused-at>, commit <pause-commit>).
   ```

3. Re-enter the protocol named in `protocol` at `position`, opening with
   `next-question` VERBATIM. Never re-ask what is already ruled — if the
   founder's answer contradicts a ruled item, that is a superseding
   decision (new DEC), not a re-litigation.

From here the original protocol's own markdown governs the session,
including its own pause/close discipline. If the founder tires again,
`/playbook:pause` writes a fresh marker.

## Rules

- Read-first list is a CEILING, not a starting point — resist exploring
  the repo before speaking. The whole point is that resume costs cents.
- A `[consumed]` marker is history, never re-runnable. To revisit a
  finished topic, start the protocol normally.
- If the marker is malformed (missing `protocol` or `next-question`),
  fall back to the artifact it sits in: read it end to end, infer the
  stopping point, confirm with the founder before continuing — and say
  the marker was malformed so the pause discipline gets fixed.
