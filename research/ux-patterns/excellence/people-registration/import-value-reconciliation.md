# Pattern: Import value reconciliation (raw values → canonical options before insert)

**Surface:** people-registration / CSV import, step between mapping and preview · **Observed in:** Attio ("Review values"), Workable ("Map values") (refs: https://mobbin.com/screens/de2ec449-2208-4989-9b59-2f58c1a0fc5c , https://mobbin.com/screens/2b9586cc-f107-451b-b72c-73b7a8733a6e)

## Flow
1. After column mapping, columns mapped to select/category/tag attributes get a dedicated reconciliation step; a left rail lists columns with needs-review status dots.
2. Main pane "Needs review (3)": each distinct RAW value from the file (R&D, Sales, Support) is a row with a mapped-value picker that searches the EXISTING canonical options ("Accounting", "Market Research"…).
3. Bulk escape hatch: "+ Create 3 missing select options" adds all unmatched raw values as new options in one click; per-row undo/skip controls; sort by raw value.
4. Import proceeds only with every select value either mapped to an existing option, created, or skipped — free-text variants never silently become new categories.

## Use when
Imported columns feed categorical fields (tags, person categories, registration types) where uncontrolled variants corrupt filters — exactly the "VIP" vs "vip" / "speaker" vs "faculty" class.

## Avoid when
All imported fields are free text — the step would be empty; skip it dynamically when no categorical column is mapped.

## Sad paths observed
- Unmatched values are BLOCKING for that column, with a one-click bulk resolution — friction is proportional to mess size.
- Skip leaves the field empty rather than inserting an unreviewed value.

## Accessibility
Each raw→canonical row is a labeled combobox; review counts announced per column.

## Default verdict for our stack
RECOMMENDED — this is the structural fix for the BUG-4r scar family (tag normalization bugs, re-opened once) and the csv-import 'VIP'-casing leftover. GEM's tag-canonicalization map (speaker/chair→faculty…) becomes the auto-suggestion layer inside this step instead of a silent rewrite.
