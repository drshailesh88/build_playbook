# Pattern: Export dialog with scope controls (range, columns, timezone)

**Surface:** dashboard-reports / export · **Observed in:** Stripe (refs: https://mobbin.com/flows/319c3b60-0e5b-4bc9-9e6d-1fb95fa43183, https://mobbin.com/flows/465c67dd-e73e-4a6c-a495-6c179f00bbe5)

## Flow
1. Export button opens a dialog, never an instant download: "Export payments" — Time zone radios (local GMT+7 vs UTC), Date range radios with resolved previews next to each ("Last 7 days — 2 Dec–8 Dec"), Columns dropdown ("Default (23)") with the full column list printed as text below.
2. "Download report" variant adds a searchable column checklist ("Filter by name or metadata key", All (14) selector, Hide button) and a Notifications row: "Email samlee@… when your report is ready to download" — async opt-in inside the same dialog.
3. Submit → toast "Download will begin shortly…" → completion dialog: "Your export is ready. If you don't see your file, you can try downloading it again." — recovery link is part of the success state.
4. Table context: status tab-cards with counts (All 6 / Succeeded 1 / Failed 3 …) and an Edit-columns popover (fixed vs active columns, drag to reorder) define what the export will contain.

## Use when
Exports feed external recipients with different needs (registration desk wants 5 columns; the chair wants all 23) — column sets and explicit timezone prevent the "re-export with one more column" loop and the classic off-by-one-day timezone bug.

## Avoid when
The export is a fixed-format compliance artifact (emergency kit, audit archive) where configurability undermines the guarantee — keep those one-click with a manifest preview.

## Sad paths observed
- File didn't arrive → "try downloading it again" link in the ready dialog (Stripe).
- Date previews beside each radio kill "which dates is 'last month' exactly" ambiguity.

## Accessibility
Radio groups + checkboxes are native form controls; column list is rendered as text (screen-reader enumerable).

## Default verdict for our stack
VIABLE — full column-picker is V2; the date-range + timezone radios and the email-when-ready opt-in are the high-value subset (Excel exports for an Indian conference with UTC timestamps is a live foot-gun in the old app's UTC-only date format).
