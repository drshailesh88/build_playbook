# Pattern: Spreadsheet-to-design bulk merge ("Generate N designs")

**Surface:** certificates / bulk-issuance · **Observed in:** Canva (refs: https://mobbin.com/flows/e7cf2952-1dcb-4fa9-a408-57c2bfd33d67, https://mobbin.com/flows/d10efe0f-e620-44d4-911c-2f9966930a48)

## Flow
1. Data lives in a grid (Canva Sheets) with one row per output; "Bulk create" tool in the editor's left rail.
2. Stepper: "Connect data to your elements — Select an element in your page, then connect it to a data field." Detected fields listed with first-values preview ("June 25th, June 26th, and 3 more").
3. Selecting a canvas element tags it with a purple data chip showing the binding (Title/Description).
4. "Apply data — Create pages based on the data you entered": checkbox per row, "Select all".
5. CTA bakes the count in: **"Generate 6 designs"**.
6. Adjacent: AI fills gaps in the data table before merge (Magic Write "Fill empty cells").

## Use when
Issuing N certificates from one template where the admin should SEE the binding and the row selection before committing.

## Avoid when
Recipients come from a live system query (registered delegates, checked-in attendees) — re-entering them in a sheet creates a stale copy; bind to the live group instead (legacy census #26 already does this).

## Sad paths observed
None shown in flow — no bad-data/missing-field state observed (gap; pair with csv-import-remediation for the guard).

## Accessibility
Binding shown as labeled chips on elements, not color-only highlights.

## Default verdict for our stack
VIABLE — steal the two interaction ideas (visible element↔field binding chips in the template editor; count-in-the-CTA "Generate 312 certificates"), but keep recipient selection group-driven, not sheet-driven.
