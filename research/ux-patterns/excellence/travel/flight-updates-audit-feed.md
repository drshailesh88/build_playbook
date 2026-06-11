# Pattern: Per-record Updates feed (timestamped change history on the detail page)
**Surface:** travel · **Observed in:** Flighty (refs: https://mobbin.com/screens/aabd3462-222b-43ad-91c6-8c8364e515a1, https://mobbin.com/screens/a2d54db3-312a-4a25-8a3c-6639bef55d7c), Turo activity feed (https://mobbin.com/screens/9c1b81a8-4c43-425a-ad8c-b6ec2b90a1ec)

## Flow
1. Flight detail page has an "Updates" section: count header ("25 updates for this flight") + reverse-chronological entries.
2. Each entry: what changed in plain words ("Predicted Gate Arrival 8:00 PM") + when it was learned ("Dec 02 at 3:03 PM").
3. Data provenance credited ("Powered by FlightAware Foresight").
4. Adjacent (Turo): pending changes are first-class entries with a deadline — "Change request pending — Bryan has until 10:00 AM on Friday to confirm the changes."

## Use when
Records that mutate after creation and whose history answers ops questions ("when did we learn the flight moved?", "who changed the PNR?"). Pairs naturally with a status state machine — every transition and field edit appends an entry.

## Avoid when
Write-once records; or as a substitute for actionable alerts (a feed is for reconstruction, not interruption).

## Sad paths observed
- Zero updates → section shows count 0 / placeholder, never hidden (keeps the affordance learnable).
- Entries never overwrite: a correction is a NEW entry (feed is append-only).

## Accessibility
Chronological list semantics; timestamps as text.

## Default verdict for our stack
RECOMMENDED — the oracle already computes human-readable diffs (`buildTravelChangeSummary`, census D10) but only mails them; surfacing the same summaries as an on-record feed is near-free and makes the cascade auditable in-UI.
