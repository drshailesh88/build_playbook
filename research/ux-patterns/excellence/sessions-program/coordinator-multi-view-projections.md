# Pattern: One dataset, many projections — Table/Timeline/Calendar views + session-as-document

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Notion (refs: [database calendar flow](https://mobbin.com/flows/4c9b91d1-4168-489d-916a-b495e3bd0c21), [agenda flow](https://mobbin.com/flows/0cd3dbda-d238-4f4c-a4ce-5e840710fe6b))

## Flow
1. The same sessions database re-projects through a view switcher: Table (bulk editing), Timeline (sequence, with zoom "Bi-week ▾"), Calendar (dates, "+" on hover per day cell), Board, List.
2. Each session opens as a full DOCUMENT: structured properties (date, owner, status — empty ones shown as "Empty" placeholders) + free content + comments.
3. Creation works from any view; the item appears in all of them.

## Use when
Different program tasks need different shapes: bulk track-assignment wants a table; day-of wants a calendar; a symposium's flow wants a timeline. Forcing one canonical view forces workarounds.

## Avoid when
Only one job exists (a simple single-day list) — view plumbing costs more than it returns.

## Sad paths observed
- "Empty" property placeholders — missing metadata is visible, not blank.

## Accessibility
Views are real alternatives, not visual skins — the table projection is inherently the most screen-reader-friendly.

## Microcopy worth stealing
"Empty" as the explicit unset-property placeholder.

## Default verdict for our stack
RECOMMENDED (two projections) — the old app already has list + schedule grid; the rebuild keeps both as first-class projections of one dataset and adds per-session detail with comments/notes if cheap. Full Notion view-engine generality is AVOID (overkill).
