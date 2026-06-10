# Pattern: Import history log with status, actor, counts, and artifacts
**Surface:** import-wizard-sad-paths · **Observed in:** Attio, Pipedrive, Lightfield, Customer.io, Circle, Klaviyo, Intercom, ClickUp (refs: [Attio](https://mobbin.com/screens/89d498a0-f1b3-4c10-8fd0-3c8d01f85a7f), [Pipedrive](https://mobbin.com/screens/3d5ac1a9-1479-4a9e-ba8c-cadaf314c5be), [Lightfield](https://mobbin.com/screens/18e38f34-e69b-45d8-a538-303ba331b09c), [Customer.io](https://mobbin.com/screens/da49e12c-c4f7-4314-a4fa-0bb4cecc06bd), [Circle](https://mobbin.com/screens/9903fe71-aab2-4b4a-ab11-8351a9733497), [Klaviyo](https://mobbin.com/screens/83524275-5198-484b-b793-ab578dfc0c9d), [Intercom](https://mobbin.com/screens/f5985c42-1dfb-4139-8303-b5b59add5951), [ClickUp](https://mobbin.com/screens/e9e161e4-635b-45b5-8288-70218c04a5b0))

## Flow
1. "Import history" is a named destination in settings/data navigation (Attio: Settings > Data > Import history; Pipedrive: Import data > Import history tab; Intercom: Settings > Import history).
2. Each row records: file name, object type chip (Contacts/Companies — Attio), columns x rows (Attio: "9 columns, 28 rows"), who ran it ("Alex Smith confirmed 1 day ago" — Attio; Uploader column — Lightfield; User — Pipedrive), timestamp, and a status chip (Done / Success / Complete / Failed / Skipped records / Pending / Draft).
3. Per-row actions vary by app and define the page's power: Revert (Pipedrive, with "revertible within 48 hours" note), Delete imported tasks (ClickUp), Report download (Klaviyo), original file download (Lightfield), Details drill-in (Pipedrive, Intercom's users/errors links).
4. Circle's Bulk Logs keep both artifacts per run — "Input file.csv / Output file.csv" — plus a human message ("Added 1 user without email…") and progress fraction (3/3).
5. Object-type tabs partition the log when multiple entities are importable (Lightfield: Accounts / Opportunities / Contacts; Intercom: CSV / Mixpanel / Mailchimp by source).
6. In-flight and unfinished runs appear in the same list: Circle shows Pending ("This task has not yet started"); Attio shows Draft imports awaiting confirmation.
7. Retention is bounded and stated: "Import history covers the past 90 days" (Klaviyo); "Past imports (last 30 days)" (Pipedrive).

## Use when
- Multi-admin tenants (our case): "who imported this file and when" is an accountability requirement, not a nicety.
- As the anchor for everything else on this surface — revert, error reports, and in-progress status all hang off history rows.

## Avoid when
- Never omit it once imports mutate shared data; the only observed "avoid" is scope — single-user tools (Reflect, Podia) skip it.
- Don't keep source files forever silently — observed apps state retention windows; ours must align with data-retention policy.

## Sad paths observed
- Failed and partially-failed runs stay in the list with their error artifacts (Klaviyo Report, Intercom "4 errors", Salesforce Failed status) — history is the recovery surface, not just a trophy case.
- Pending/Draft states visible so a stuck background import is discoverable.
- Empty "rows imported: 0" runs listed honestly (Customer.io).

## Accessibility
- Status as text chips, not color dots; counts and actors as plain table text.
- Per-row actions are labeled buttons/links (Revert, Report), not unlabeled icons (Lightfield's bare download icon is the weak example).
- Tables searchable/filterable (Attio search + filter) for long histories.

## Default verdict for our stack
RECOMMENDED — table stakes for multi-tenant B2B: file, object type, row counts, actor, timestamp, status, error-report download, revert action, stated retention; this page is where sub-areas a/b/f converge.
