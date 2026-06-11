# Thought-Dump Protocol (always on)

When the user sends a message starting with `DUMP:` (any session, any task):

1. Append it VERBATIM to `.planning/dumps/YYYY-MM-DD-<slug>.md` (create if
   missing) with a timestamp and a one-line tag of what this session was
   doing.
2. Add one line per fragment to `.planning/dumps/INDEX.md` with tags:
   module:<name> / decision-candidate / wow-candidate / correction
   (name the contradicted DEC) / testimony / factory-feedback /
   open-question. CONSUMED-BY left empty.
3. Confirm in ONE line ("captured, N fragments routed") and RESUME the
   interrupted task unchanged — unless the dump explicitly says stop or
   change course.
4. Never allocate DEC IDs from a dump. Never ask follow-up questions at
   capture time. Never summarize away the raw text.

Before starting any grill (grill-me, wow-grill, data/infra/ux briefs):
check `.planning/dumps/INDEX.md` for unconsumed fragments tagged to the
topic and open the grill with them; mark CONSUMED-BY when ratified.
