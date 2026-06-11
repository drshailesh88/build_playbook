# Pattern: Two-pane record detail (activity left, attributes rail right, prev/next stepping)

**Surface:** people-registration / person detail · **Observed in:** Attio, Front, Clay (refs: https://mobbin.com/flows/723a0c99-c91a-486b-816b-9ebe1f2bd387 , https://mobbin.com/flows/6cd12873-6ff6-401c-a5d0-e312ea3be131 , https://mobbin.com/flows/78502e69-41ed-4e62-86f5-66cf2f7298d2)

## Flow
1. Header: avatar + name + favorite star, quick actions (Attio: "Add to List", "Run workflow", "Compose Email"), breadcrumb back to the list, and **prev/next arrows with list context** ("1 of 1 in Stage → Meeting") — step through the filtered list without bouncing back.
2. Left pane: tabbed content — Activity / Emails (count badges) / Team / Notes / Tasks / Files.
3. Right rail: "Details" card of inline-editable attributes with "Show all values" overflow, plus a "Lists" card showing this record's memberships (per-membership attributes editable in place) — answers "what is this person part of" without navigation.
4. Lightweight variant: Front/Clay render the same anatomy as a side panel over the list (peek) — click a row, see detail + timeline + sources without losing table position.

## Use when
A person aggregates cross-module facts (registrations, sessions, travel, certificates) — the rail holds identity, the tabs hold per-module histories.

## Avoid when
Records are shallow (≤8 fields, no related entities) — a single-column page is simpler. Don't add a peek panel AND a full page with different capabilities; the peek should be a subset that links to the page.

## Sad paths observed
- Empty tabs get purposeful empty states (Attio Files: drag-drop target + "Upload file", not a blank pane).
- Missing values render as named placeholders ("No Job title" chip), keeping slots discoverable.

## Accessibility
Tabs are a tablist; the rail reads after main content; prev/next are buttons with positional labels.

## Default verdict for our stack
RECOMMENDED — evolve the existing detail page: identity + tags + status in a right rail, tabs for Events / Registrations / Sessions / Travel / History (data the person-detail API already aggregates). Prev/next stepping inherits the list filter context. Side-panel peek from the list is V2.
