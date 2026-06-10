# Pattern: Excel/Sheets as named sources with per-sheet preview tabs
**Surface:** import-wizard-sad-paths · **Observed in:** Airtable, Clay, Equals (refs: [Airtable data menu](https://mobbin.com/screens/9a589da1-b8f6-47a7-a737-a6938ae6f24c), [Airtable add-table sources](https://mobbin.com/screens/4eabbcb5-4d22-4dd0-b210-5174879b8dda), [Airtable import preview](https://mobbin.com/screens/caf7c9fe-1945-41da-a1d2-870cc7501462), [Clay workbook tabs](https://mobbin.com/screens/e53e063e-b58a-4133-a70f-ecaa1759d486), [Equals](https://mobbin.com/screens/fd7b7313-202e-4d22-8375-a9ef8c34ae64))

## Flow
1. Excel, CSV, and Google Sheets are separate named entry points, not one generic "upload" ("Import from CSV / Import from Excel / Import from Google Sheets" — Airtable's Data menu and add-table source list), setting parser expectations per format.
2. After upload, the import preview renders the workbook's sheets as tabs above the data grid (Airtable's "Import Into … — Resources" dialog shows the sheet tab; Clay's preview has an explicit "Table | Workbook" toggle) — the user picks which sheet's data is being mapped.
3. The preview states the consequence in a sentence: "You're importing 320 new records from Airtable Updates.csv to Resources" with an "Adjust your import" section (Map Fields, Other settings) before the Import button.
4. Wrong-format files get a conversion instruction rather than a dead end: "Sheet is not in Google Sheet format. Convert it to Google Sheet format first and try again" (Equals).

## Use when
- Accepting .xlsx where multi-sheet workbooks are common (event teams keep attendees + sessions + budget in one file) — silently importing sheet 1 is a data-corruption trap.
- You support multiple source formats and want each to advertise its own quirks.

## Avoid when
- You only genuinely parse CSV — offering an "Excel" entry point that converts lossily without saying so; Equals' explicit convert-first message is the honest fallback.
- Multi-sheet import in one pass (all tabs at once) — no swept app did this; one sheet per import run is the observed norm.

## Sad paths observed
- Format mismatch handled with a directive error naming the fix (Equals).
- Sheet selection is embedded in the preview rather than a separate wizard step — fewer steps, but the tab is easy to miss; Clay's labeled "Workbook" toggle is more discoverable.
- Coverage note: no swept app showed a dedicated standalone "pick a sheet" modal — evidence here is preview-tab based only.

## Accessibility
- Sheet tabs need real tab semantics and keyboard arrows; a visual-only tab strip above a grid is easy to skip.
- The one-sentence consequence line ("importing 320 new records from X to Y") doubles as a screen-reader summary of the whole operation.
- Distinct source buttons with text labels beat a single dropzone sniffing file types silently.

## Default verdict for our stack
RECOMMENDED — for our xlsx delta: parse the workbook, render sheets as tabs in the existing preview step (default to first non-empty sheet), and show the "importing N records from {file}/{sheet}" sentence; reject unsupported formats with a convert-to-CSV instruction.
