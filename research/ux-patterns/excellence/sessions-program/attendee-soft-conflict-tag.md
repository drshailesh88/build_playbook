# Pattern: Personal-agenda conflict — soft per-item tag, not a hard block

**Surface:** sessions-program / attendee-program · **Observed in:** TimeTree, Calendly (refs: [TimeTree soft tag](https://mobbin.com/screens/4eadd1df-a0c0-4415-bdec-25d9b3b89dda), [Calendly hard block](https://mobbin.com/screens/7a62e2bb-29d4-4817-bf9a-7462a842f68c))

## Flow
1. TimeTree (soft): adding an event flags the affected person with a per-row tag "Attending another event" + a red note above the list — but the action still completes. Warning, not block.
2. Calendly (hard): a red full-width banner at the moment of action — "Sorry, you cannot schedule over a Calendly event." — with the colliding item visible behind the attempted slot.
3. The choice between them is about WHO owns the consequence: personal agendas (user's own tradeoff) warn; resource integrity (a bookable slot) blocks.

## Use when
"Add to my schedule" overlapping an already-saved session → soft tag on both rows ("Overlaps: {other session}"). Attendees legitimately schedule-hop between parallel tracks.

## Avoid when
Hard-blocking personal-agenda overlaps — parallel-track conferences make overlap NORMAL attendee behavior; blocking it breaks the core use case.

## Sad paths observed
This card IS the conflict sad path, in both severities; Calendly keeps the colliding event visible so the user understands WHY.

## Accessibility
Conflict conveyed by tag text on the affected row, not color alone.

## Microcopy worth stealing
"Attending another event" (per-row tag) · "Sorry, you cannot schedule over a {x} event."

## Default verdict for our stack
RECOMMENDED — mirrors the module's existing coordinator-side philosophy (warnings never block saving); attendee my-schedule gets the TimeTree soft tag. No app showed conference-agenda conflict UX directly — this is a transfer (flagged in coverage).
