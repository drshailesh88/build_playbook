# Pattern: Partial-success report with downloadable error file
**Surface:** import-wizard-sad-paths · **Observed in:** Workable, Square, Klaviyo, Circle, Intercom (refs: [Workable](https://mobbin.com/screens/0bd3f7cb-3199-4ce0-98de-2fe47db02b83), [Square](https://mobbin.com/screens/fc83d818-9930-4e55-ab69-a29d4833e97b), [Klaviyo](https://mobbin.com/screens/83524275-5198-484b-b793-ab578dfc0c9d), [Circle](https://mobbin.com/screens/9903fe71-aab2-4b4a-ab11-8351a9733497), [Intercom flow](https://mobbin.com/flows/c7c65d83-e2e9-4de0-85a4-aebf6b295b79))

## Flow
1. Import completes; success page leads with the win: "You successfully imported 1 employee" (Workable) with a green check.
2. A visually distinct warning box below states the failure count: "2 employees could not be imported."
3. Primary action in the warning box: "Download file with errors." Workable's fine print: "This CSV file will only contain rows with errors to review, fix and re-upload" — errors-only file, not the full dataset.
4. Square's variant ("10 customers were not imported") adds an inline "Error preview" — the error message plus affected row ranges ("Rows 2–11") — so users see the dominant failure cause without downloading.
5. Square explains the file format: "The error file lists the customers that were not imported and gives error details in the last column" — error reason appended as a trailing column.
6. A prominent "Import again" button closes the fix-and-reimport loop (Square).
7. The report stays reachable later: Klaviyo's import history row shows a "Skipped records" warning chip with a per-import "Report" download; Circle's Bulk Logs keep both "Input file.csv" and "Output file.csv" links per run; Intercom's history shows a red "4 errors" link.

## Use when
- Batch import where row failures are independent and the rest should commit (matches our decided batch-import behavior).
- Users own the source file and will fix it in Excel/Sheets rather than in-app.
- The error report must survive the session (audit, hand-off to whoever owns the data).

## Avoid when
- Failure counts are tiny and errors are editable inline — a download round-trip is heavier than fixing 3 cells in the UI (see fix-or-proceed card).
- Errors are systemic (wrong file, wrong headers) — then block the whole import instead of importing a near-empty success.

## Sad paths observed
- Zero-success case: Klaviyo shows "0 imported / 3 skipped" with status chip "Skipped records" — same layout, no celebration copy.
- Error file is errors-only (Workable) vs full-file-with-error-column (Square) — both observed; errors-only is what enables direct re-upload of just the failed rows.
- Report retrieved after the fact via history (Klaviyo, Circle, Intercom) when the user closed the success page.

## Accessibility
- Success and failure are conveyed by icon + count + text, not color alone (Workable: green check vs amber alert icon with explicit counts).
- Download is a real button with a text label, not an icon-only control.
- Error preview text (Square) is plain text in the dialog — screen-reader reachable without downloading a file.

## Default verdict for our stack
RECOMMENDED — exactly the delta our wizard's success page lacks: failed-row count, errors-only CSV with an error column, and an "Import again" loop; pairs cleanly with our existing success-page stats.
