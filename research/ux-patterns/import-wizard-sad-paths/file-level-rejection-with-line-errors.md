# Pattern: File-level rejection with line-by-line error listing
**Surface:** import-wizard-sad-paths · **Observed in:** Okta, Navan, Origin, Salesforce, Customer.io, Front (refs: [Okta](https://mobbin.com/screens/cab6e65b-dae5-4852-b2f0-b0201bde0141), [Navan](https://mobbin.com/screens/47d724d8-d0bd-474b-a27d-59ee275c55fd), [Origin](https://mobbin.com/screens/ae3c4bbe-9352-4ce9-aa41-e0b015abfa16), [Salesforce](https://mobbin.com/screens/819ed994-1035-4775-bab2-39b01f8f30c6), [Customer.io](https://mobbin.com/screens/36a46394-af7d-4eba-8987-8d94d5430896), [Front](https://mobbin.com/screens/bab57a69-6ffc-42a5-a168-20411cf371bf))

## Flow
1. File fails structural validation (headers, encoding, formats) before any rows are written; the import is fully blocked, not partially applied.
2. Errors are listed against their source location: "Line 1: Null or empty country code … Line 19: …" (Navan, scrollable list); "Error on line 2: Date 3/1/2025 is in an invalid date format" repeated per line in a top banner (Origin).
3. Header-level failures name the exact header: "Missing required attribute from CSV header: lastName" (Okta); "We found duplicate headers: 'Price (Special Pricing) USD' and 'Price (sale) USD'. Remove one of the headers and try again" (Salesforce).
4. The upload control stays on the same screen so the corrected file can be re-dropped immediately (Okta keeps Browse/Upload CSV inline under the error list; Origin keeps the dropzone).
5. Customer.io's review step renders rejection as stat tiles — 0 events / 0 warnings / 8 errors — with the cause ("invalid email address"), an "Export error file" button, and "Go back to upload"; "Complete import" stays disabled.
6. Salesforce records the failed attempt in an "Import Summary" panel (Status: Failed) so the failure itself has history.
7. Front compresses the minimal version into a toast: "Failed to save recipients — The first column should be 'email'."

## Use when
- Structural problems (headers, encoding, date formats) where importing any rows would mis-map data.
- Errors the user must fix in the source file — line numbers are the only address they can act on.

## Avoid when
- Failures are sparse row-level issues in an otherwise valid file — blocking everything for 3 bad rows of 5,000 punishes the user (use partial-success or fix-or-proceed instead).
- The error list can run to hundreds of identical lines (Navan shows 19 near-identical lines; Origin's banner wraps badly) — collapse repeats into "Country code missing on 19 rows."

## Sad paths observed
- Repeated identical errors rendered uncollapsed (Navan, Origin) — observed weakness, both get noisy.
- Okta states limits beside the fix ("max 10MB and 10,000 users" + template link), turning rejection into instructions.
- Failed attempts persisted with status Failed (Salesforce) rather than vanishing.

## Accessibility
- Error lists are text lists, not just colored banners; Okta pairs the red sidebar with a bulleted list.
- Origin's single top banner holding 10 wrapped error sentences is the anti-example — poor reading order and no list semantics.
- Keep the re-upload control in DOM order directly after the error list (Okta does this).

## Default verdict for our stack
RECOMMENDED — as the structural-failure tier only: block on header/encoding/format errors with named headers and collapsed line references, keep the dropzone inline for instant retry; never use it for row-level errors.
