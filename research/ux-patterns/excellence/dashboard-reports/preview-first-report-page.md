# Pattern: Preview-first report page (Summary tab + Exports tab)

**Surface:** dashboard-reports / report detail · **Observed in:** Eventbrite, Amplitude (refs: https://mobbin.com/flows/9261e137-c8a1-4cec-a39c-2786af0e0864, https://mobbin.com/screens/b98182dd-1cf3-45b8-a6e9-43a035eb10d6, https://mobbin.com/flows/faaf0db1-9924-43d8-8ad7-d3c08a6177d5)

## Flow
1. A report is a PAGE, not a download button. Eventbrite's Audit Report: title + "Last updated 2 hours ago", **Summary** and **Exports** tabs.
2. Summary tab: event filter chip + "+ Add filter", KPI strip (Ticket Sold 3 / Unsold 22 / Capacity 25 / Face Value), "Group by: Event > Ticket Type" dropdown, "Edit columns", then the data table itself — the user SEES the rows before downloading anything.
3. "Export" button on the page generates the file from exactly what's on screen; the Exports tab lists past requests (Report Name / Date Requested / Status / Download).
4. Amplitude puts "Export CSV" directly on every chart's breakdown table — preview and export are the same surface.

## Use when
Users repeatedly download a file just to answer "how many rows / does it look right" (the old app's flow: click → wait → open Excel → discover it's the wrong event). Preview kills the round-trip and catches empty/wrong-scope exports before they ship to a committee.

## Avoid when
The artifact is inherently non-tabular (emergency-kit ZIP, archive ZIP) — preview the MANIFEST (file list + row counts per file) instead of faking a table.

## Sad paths observed
- Empty result → headers-only table on screen (and Eventbrite still allows export, producing a valid headers-only file — matches old app's done-spec §3.4 behavior).
- Filters hiding all rows → count chip "4/15" style feedback (Linear) prevents "where did my data go".

## Accessibility
A real HTML table is screen-reader-usable; a blind download is not. 44px touch targets already a project norm.

## Default verdict for our stack
RECOMMENDED — this is the single largest UX upgrade over the old app's blind-download cards; the export queries already exist, the page renders their first N rows.
