# thought-dump — Capture raw founder streams without forcing structure

The founder's richest input arrives as unstructured streams: voice-to-text
rambles, mid-session interjections, memories ("I've attended 100 CMEs
and..."), complaints, hunches. Grills and capture-planning force structure
at intake — wrong tool: a dump is PRE-DECISIONAL ore. This command captures
everything verbatim, routes fragments lightly, decides NOTHING, and feeds
the next grill.

Input: `$ARGUMENTS` — the dump itself, optionally prefixed with a module
("certificates: ...") . Empty input = invite the dump: "Talk. I'll catch it."

## The contract

1. **Verbatim first.** The raw text lands untouched in
   `.planning/dumps/YYYY-MM-DD-<slug>.md` under `## Raw` before any
   processing. Typos, fragments, mixed topics — preserved. Structure is
   derived BELOW the raw, never instead of it.
2. **Route, don't resolve.** Split the dump into fragments and tag each:
   - `module:<name>` — feeds that module's next grill/wow-grill agenda
   - `decision-candidate` — looks decision-shaped, but is NOT a DEC yet;
     grills ratify (no DEC IDs allocated from a dump, ever)
   - `wow-candidate` — a stolen-feature/quality idea for the excellence track
   - `correction` — contradicts an existing artifact/DEC; flag the target
     ("contradicts DEC-049") for a superseding decision at the next grill
   - `testimony` — domain experience worth quoting in grills verbatim
   - `factory-feedback` — about the playbook/process itself → also append
     one line to the playbook's FACTORY-LACUNAE or L-015 roadmap
   - `open-question`
3. **Update the index.** `.planning/dumps/INDEX.md`: one line per fragment —
   date, tags, 10-word gist, CONSUMED-BY (empty until a grill consumes it).
4. **Confirm in two lines, max.** "Captured N fragments: 3→certificates
   grill, 1 contradicts DEC-049, 1 factory-feedback." Then stop. No
   follow-up questions — interrogation is the grill's job, later.

## Consumers (this is why dumps don't rot)

- **grill-me / wow-grill prerequisite:** before grilling any topic/module,
  read `.planning/dumps/INDEX.md` for unconsumed fragments tagged to it;
  open the grill WITH them ("you said X on the 11th — let's resolve it");
  mark them CONSUMED-BY: DEC-NNN when ratified.
- **morning-review:** surfaces unconsumed fragments older than 7 days —
  decaying ore is lost ore.
- **write-a-prd:** treats unconsumed `decision-candidate` fragments as
  blockers to flag, never as decisions to silently absorb.

## Mid-session protocol (the `DUMP:` prefix)

The founder may interject in ANY running session (a harvest, a grill, a
build review) with a message starting `DUMP:`. The session must: append it
verbatim to today's dump file with a timestamp + what-this-session-was-doing
tag, add INDEX lines, confirm in ONE line, and resume its task unchanged.
The dump does not alter the session's course unless it explicitly says
"stop" or "change X". Capture is cheap; derailing is not.

## Rules

- NEVER allocate DEC IDs from a dump — dumps propose, grills dispose
- NEVER summarize away the raw text; structure lives below it
- NEVER reply to a dump with questions — capture, route, confirm, stop
- One file per dump event; INDEX is the cross-dump router
- A fragment contradicting a DEC is flagged loudly, not silently filed
