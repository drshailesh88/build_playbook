# Pattern: Insights side panel attached to a filtered list

**Surface:** dashboard-reports / in-context analytics · **Observed in:** Linear (refs: https://mobbin.com/flows/a21b30a0-4995-4adb-b339-2e411ed0fb5a)

## Flow
1. On any issues list, a chart icon opens an Insights side panel: Measure (Issue Age) × Slice (Assignee) × Segment (Priority) dropdowns, a chart, and a breakdown table — beside the live list, not on a separate analytics page.
2. The panel reflects the list's CURRENT filters: filter the list to 4/15 items and the insights recompute; "11 issues hidden by filters · Clear Filters" keeps the scope honest.
3. Clicking a breakdown row highlights/filters the corresponding list rows (table↔chart linkage).
4. "Set as default" persists the configuration per view.

## Use when
Users ask aggregate questions ABOUT the table they're looking at ("registrations by category for the rows I've filtered") — separating list and analytics forces scope re-creation by hand and the two always drift.

## Avoid when
The list is short enough to eyeball, or aggregates need heavy precomputation that can't track live filters — a stale side panel next to a live list is worse than none.

## Sad paths observed
- Filters reduce the list to zero → panel must show "no data for current filters", not the previous chart.
- Scope honesty line ("N hidden by filters") prevents silent mismatch between what's counted and what's visible.

## Accessibility
Panel is supplementary — every number it shows must be reachable as text in the breakdown table.

## Default verdict for our stack
VIABLE (V2) — the strongest candidate surface is the registrations table (slice by category/status/day); requires the table views to have structured filters first. First-principles note: this pattern, not a dashboard page, is how "reports" stay next to the work.
