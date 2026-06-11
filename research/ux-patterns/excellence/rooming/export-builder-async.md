# Pattern: Export builder with column chooser, scope honesty, async generation + past-exports ledger
**Surface:** rooming · **Observed in:** Slack, Whop, Zoho CRM, Upwork, Coinbase, Revolut, Deputy, TravelPerk, Navan
(refs: https://mobbin.com/screens/85dd544d-465c-4062-9048-ae3111f7daea , https://mobbin.com/screens/71f41e02-2914-4a2c-af28-1a941435f274 , https://mobbin.com/screens/69d2b814-eb28-49c1-b06f-470ac85d559f , https://mobbin.com/screens/ea97d85e-684c-4dc7-afa1-1fea0c1c5165 ; raw: `_raw/by-pattern.md` §P8/P30, `_raw/by-app.md` §A17/A18)

## Flow
1. Column chooser before export: master "All 45/45" + per-field checkboxes (Whop); live preview "Preview shown with limited number of rows…" (Zoho).
2. Scope honesty in two columns: "Here's what's included:" vs "What's not included:" (Slack).
3. Per-format independent generation: "CSV report [Generate] / PDF report ⟳ Generating…" with "Both formats contain the same info." (Coinbase); time expectation always stated ("less than 3-5 minutes", "up to a few hours").
4. Async with email promise: "You'll receive an email when the export is ready for download." + Past Exports table (Started / Type / Set by / Status) (Slack).
5. Retention stated: "Exports will be permanently removed 10 days after they are downloaded." / "Files are removed after 30 days." (Slack/Upwork).
6. The rooming-specific artifact exists: TravelPerk Events Accommodation tab "Download csv" (Hotel / Check-In / Check-Out / Travelers); Navan "Download travel manifest".

## Use when
Per-hotel rooming lists, the global manifest, emergency-kit exports — any artifact an external party will operate from.

## Avoid when
Tiny instant exports — async ceremony on a 20-row CSV is friction; generate inline.

## Sad paths observed
Volatile progress warned ("After you navigate away… no longer available"); expiring artifacts; zero-state exports still produce a well-formed empty file with the scope statement.

## Accessibility
Generation status as text rows, not spinner-only; email fallback frees the user from waiting.

## Default verdict for our stack
RECOMMENDED — per-hotel export = format choice (PDF front-desk / XLSX PMS) + column template per hotel + scope statement ("Includes confirmed + pending for Hilton. Not included: 4 unassigned delegates") + past-exports ledger per hotel feeding `hotel-handoff-tracking.md`.
