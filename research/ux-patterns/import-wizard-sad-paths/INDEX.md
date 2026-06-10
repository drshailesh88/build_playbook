# Pattern Index: import-wizard-sad-paths

## Coverage note
Sweep ran 2026-06-10 against Mobbin (platform: web only; iOS not used — all needed material surfaced on web).
- **by-app screen queries (4):** HubSpot error-file/failed-rows; Attio import duplicates/merge; Airtable+Monday sheet/table selection; Notion+Monday import-failure notification.
- **by-pattern screen queries (5):** import history + undo; duplicate merge/skip/create; partial-failure + error report; background processing/navigate-away; upload format errors/worksheet pick; merge side-by-side compare; skipped rows/plan limits. (7 total pattern queries; last two returned only variations of already-captured patterns = dry.)
- **by-flow queries (2):** "import CSV with errors fix and reimport" (Attio Resolving-issues flow, Intercom 13-screen import flow, 15Five error flow, Zoom import flow); "revert/undo a data import" (Squarespace remove-imported-client flow, Attio delete-draft flow, Pipedrive file-detail flow).
- **Apps observed (~30):** HubSpot, Attio, Pipedrive, Airtable, Salesforce, Intercom, Customer.io, Square, folk, Front, Apollo, ManyChat, Workable, Remote, 7shifts, Deel, Okta, Navan, Origin, Klaviyo, Circle, ClickUp, Lightfield, Clay, Equals, 15Five, Notion, Loops, Podia, Rox, Zoom, PandaDoc, Employment Hero, Reflect, AWS, Squarespace, Ghost, mymind, Grain.
- **NOT found (honest gaps):** (1) a dedicated standalone xlsx sheet-picker modal — only preview-embedded sheet tabs (Airtable) and a Table/Workbook toggle (Clay); (2) an undo time-window countdown UI — only Pipedrive's static "within 48 hours" text; (3) any in-app completion notification (toast/bell) for background imports — every swept app promises email only; (4) Monday.com and Notion CSV-import error screens — absent from Mobbin's index for these queries; (5) a merge-result preview shown during the import wizard itself (only post-import dedupe queues show merge previews).

## Patterns

### a) Partial-failure report
- ★ [partial-success-report-with-error-file](partial-success-report-with-error-file.md) — success page leads with N succeeded, warning box with M failed + errors-only CSV (error reason as last column) + Import again loop (Workable, Square, Klaviyo, Circle, Intercom)
- [fix-or-proceed-error-row-review](fix-or-proceed-error-row-review.md) — pre-commit error-row table: fix inline, export-and-fix, or "Continue with N" partial commit (Remote, 7shifts, Deel)
- [inline-resolve-issues-before-import](inline-resolve-issues-before-import.md) — guided per-column resolve loop with create-missing-options and ignore-and-fix-later (Attio, HubSpot)
- [file-level-rejection-with-line-errors](file-level-rejection-with-line-errors.md) — structural failures block fully, errors addressed by line/header, dropzone stays inline (Okta, Navan, Origin, Salesforce, Customer.io, Front)

### b) Undo/rollback an import
- ★ [import-revert-window](import-revert-window.md) — per-import Revert in history, stated 48h window, added/updated/merged/skipped split, drill-in listing created records (Pipedrive, ClickUp)
- [inline-undo-after-import](inline-undo-after-import.md) — "(undo)" link inside the success banner with confirm popover (Squarespace, Attio)
- [import-batch-auto-tagging](import-batch-auto-tagging.md) — every run auto-tags created+updated records for find/clean-up without a bespoke revert engine (Intercom)

### c) Dedupe-review UI
- ★ [bulk-dedupe-policy-at-import](bulk-dedupe-policy-at-import.md) — one merge/skip/create-anyway policy step + disclosed match keys + pre-commit "N updated / M added" counts (Pipedrive, Apollo, Intercom, Attio, Zoom, Clay)
- [duplicate-review-merge-preview](duplicate-review-merge-preview.md) — per-pair side-by-side with merge preview, conflict-only field picks, irreversibility disclosure (folk, Square, Salesforce, Front, Customer.io, ManyChat)

### d) Excel/multi-sheet handling
- ★ [spreadsheet-source-and-sheet-handling](spreadsheet-source-and-sheet-handling.md) — Excel/CSV/Sheets as named sources; workbook sheets as preview tabs; convert-first error for wrong formats (Airtable, Clay, Equals)
- [format-quirks-and-limits-preflight](format-quirks-and-limits-preflight.md) — limits printed at dropzone, violations restate limit+fix, encoding/quota/convention quirks named (Deel, Okta, 15Five, Airtable, HubSpot, Front)

### e) Import history/log
- ★ [import-history-log](import-history-log.md) — file, object chip, rows, actor, timestamp, status chip, error-report/revert per row, stated retention (Attio, Pipedrive, Lightfield, Customer.io, Circle, Klaviyo, Intercom, ClickUp)

### f) In-progress large import
- ★ [background-import-with-completion-notice](background-import-with-completion-notice.md) — "safe to leave, we'll email you — also if it fails"; detail page with pending stat tiles becomes the report (HubSpot, Notion, Loops, Podia, Rox)
- [foreground-blocking-import-progress](foreground-blocking-import-progress.md) — keep-window-open with per-item progress and mid-run cancel; results evaporate on navigation (PandaDoc, Employment Hero, Reflect, AWS) — AVOID except during upload phase
