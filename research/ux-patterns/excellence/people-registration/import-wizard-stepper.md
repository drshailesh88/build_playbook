# Pattern: Import wizard stepper with auto-match feedback and mandatory-field gating

**Surface:** people-registration / CSV-XLSX import · **Observed in:** Attio, Workable, AutoSend, Clay, Copy.ai (refs: https://mobbin.com/screens/66a5a32c-0b06-4b83-b48b-d96cb4da4e12 , https://mobbin.com/screens/2b9586cc-f107-451b-b72c-73b7a8733a6e , https://mobbin.com/screens/ecb994a6-1de0-46a4-9a80-5774130e8065 , https://mobbin.com/screens/bb348fea-3889-455d-b06c-6de93abca2ad , https://mobbin.com/screens/0ff9041a-e81a-404a-b4a0-38fa42ffc2cb)

## Flow
1. Visible stepper: Upload file → Map columns → Review values → Preview import (Attio); filename becomes the page title; "Start over" is always available.
2. Auto-match announces itself: "⚡ Matched 3 fields" banner (Workable), "✓ 8 Mapped · ⚠ 0 Unmapped" counters (AutoSend) — the user verifies a count, not 22 dropdowns.
3. Every mapping row shows SAMPLE DATA from the file next to the column name (Copy.ai shows two examples; Attio shows a live right-rail preview of the selected column's values) — mapping decisions are made against real data.
4. Mandatory gating is a visible checklist: Workable's right rail ("Mapping Mandatory fields: First name ✓, Work email …") ticks as you map; Continue stays disabled until complete. Conflicting maps (two columns → one attribute) get amber warnings (Attio).
5. Clay's compact variant: one screen, config left (delimiter, "First row contains column names", required-field asterisks, "+ Create column" inline), full live preview table right.
6. Pre-import counts: "We found 5 contacts to import" (AutoSend); compliance attestation checkbox where the data is outreach-sensitive.

## Use when
Recurring bulk ingestion from heterogeneous spreadsheets (every conference's delegate list arrives as someone else's Excel).

## Avoid when
Import is rare and the schema is 2 columns — a paste-emails box beats a wizard. Don't auto-import on upload without the mapping checkpoint; silent wrong mappings poison the master DB.

## Sad paths observed
- Unparseable/oversized files rejected at step 1 with the limit stated (keep GEM's byte/row caps, with an ACCURATE message — done-spec §30 has 20MB-vs-50MB drift).
- Duplicate-column mapping → warning, not silent last-wins (Attio).
- Sample-file download offered before upload (Pipedrive "Download a sample file (.XLSX, .CSV)") so users can fix format issues themselves.

## Accessibility
Stepper is an ordered list with current step announced; mapping rows are labeled selects, not drag targets.

## Default verdict for our stack
RECOMMENDED — GEM's Upload→Map→Preview→Import flow already matches the skeleton; steal the auto-match count banner, per-column sample data, mandatory-checklist gating (already partially: fullName + email-or-phone), and the sample-file download.
