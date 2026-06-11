# Pattern: Import pipeline — mapping with typed badges, duplicate policy, and the Added/Updated/Skipped/Errors receipt
**Surface:** rooming · **Observed in:** Customer.io, HubSpot, Attio, Dovetail, Wix, Square, Zoho, Pipedrive, AWS, Fibery
(refs: https://mobbin.com/flows/2c5ec636-6d46-416e-b798-ae09d51881c3 , https://mobbin.com/screens/0d38bdc3-8b30-40f8-90a9-630fb0404efd , https://mobbin.com/screens/36a46394-af7d-4eba-8987-8d94d5430896 , https://mobbin.com/screens/b03fcca3-e1d1-45c9-a8d6-461e3e9062f7 , https://mobbin.com/screens/5ac63322-3aa1-4f5d-a878-6e976c6c0bee ; raw: `_raw/by-flow.md` §F30–F33, `_raw/by-pattern.md` §P20/P22)

## Flow
1. Stepper: Upload → Map columns → Review values → Preview import (Attio); sample values under EVERY column header (prevents mis-mapping).
2. Mapping with typed badges: "MAP TO ATTRIBUTE" carrying `Identifier` / `Reserved` / `Required`; unmapped columns gate progress: "You have 1 unmapped column" + "Don't import data in unmapped column" before Next enables (HubSpot/Customer.io).
3. Duplicate policy forced as an explicit choice: "If this data contains duplicates of existing data, what should we do?" + unique-identifier picker (Dovetail); destination toggle "Import data to: New Database / Existing Database" (Fibery).
4. Dry-run preview: "+3 will be created / 0 will be updated"; bad values visible pre-import ("Invalid date", "NaN" in cells); row cap stated ("We only support 500 rows per import").
5. Error gate: "8 ERRORS — Some rows will not be imported · invalid email address · Export the error file" with Complete DISABLED (Customer.io).
6. Receipt: "ADDED / UPDATED / SKIPPED / TOTAL" per module + "Edit Mapping and re-run Migration" (Zoho); undo window: "Imports can be reverted within 48 hours after their upload." (Pipedrive); per-file progress states with cancel (AWS/PandaDoc).

## Use when
Delegate lists from registration, hotel block sheets, agency spreadsheets — any external schema entering the system, especially RE-imports mid-cycle.

## Avoid when
Never skip the receipt — even a 5-row import deserves created/updated/skipped counts.

## Sad paths observed
The richest sad-path family in the sweep: quantified error rows with exportable error file; disabled completion; stated revert window; keep-window-open vs safe-to-leave both declared.

## Accessibility
Counts and error reasons as text; stepper position announced; error file downloadable, not toast-only.

## Default verdict for our stack
RECOMMENDED — old app has CSV import with per-row errors; the steals: Identifier/Required badges, explicit duplicate policy (update existing delegate vs create), created-vs-updated dry-run for idempotent re-imports, error-file export, and a revert window before changes propagate.
