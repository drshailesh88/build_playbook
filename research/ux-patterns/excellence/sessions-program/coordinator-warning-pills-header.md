# Pattern: Persistent schedule-health warning pills in the grid header

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** 7shifts (refs: [publish flow](https://mobbin.com/flows/a188ab96-5d5c-4917-bb42-e27d16942411))

## Flow
1. The schedule header always shows live warning counts as colored pills — "2 Conflicts" (red), "1 Overtime" (orange) — placed NEXT TO the "Publish schedule" button.
2. A "Fix warnings" link sits beside the pills — the path from awareness to resolution is one click.
3. Warnings also render in place: red-tinted person rows, flame icons on offending chips, "TIME OFF" blocker cells.

## Use when
Conflicts accumulate while editing a dense schedule — health must be ambient, visible from any scroll position, and adjacent to the act (publish) it gates.

## Avoid when
Warnings are rare — permanent zero-count pills are noise; show the pills only when count > 0.

## Sad paths observed
- The pills ARE the sad-path surface: conflict and overtime states quantified in the chrome.

## Accessibility
Count + word + color on every pill — never color alone.

## Microcopy worth stealing
"Fix warnings" · "{n} Conflicts"

## Default verdict for our stack
RECOMMENDED — the old app has a conflict banner on the sessions list and a Fix CTA on the grid (PKT-C-004); the upgrade is making counts persistent in the schedule header, adjacent to Publish, so publishing with known conflicts is a visible choice.
