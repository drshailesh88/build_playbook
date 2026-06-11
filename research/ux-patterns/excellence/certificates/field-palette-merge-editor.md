# Pattern: Field-palette canvas editor with merge fields + fallbacks

**Surface:** certificates / template-design · **Observed in:** Docusign, Workable, Contractbook, Ditto, Employment Hero, Klaviyo, Deputy (refs: https://mobbin.com/flows/568bf51e-01d3-4a2f-aaf2-d9703ec6a243, https://mobbin.com/screens/7013adec-6af9-4dfc-9676-d982b9cbbfb7, https://mobbin.com/flows/6f5d8a4e-f906-4da1-98be-22fd44b6ff9a, https://mobbin.com/screens/2b141851-1e98-431e-975b-ea0b09f391bf, https://mobbin.com/screens/527b14ef-fd1f-4b0c-9145-726550a744b5, https://mobbin.com/flows/8a292cb8-bc2e-4e8f-bff5-a95916e18b32)

## Flow
1. Persistent side panel lists available fields, searchable and grouped (Docusign: Standard Fields — Signature, Date Signed, Name, Email, Company… ; Workable: auto-fill fields vs signature fields vs standard fields).
2. Fields drag onto the document canvas as colored boxes/chips; inline tokens render as highlighted chips in body text (Contractbook bracket placeholders → colored chips; Employment Hero blue tokens).
3. Selecting a placed field opens a right-rail inspector: Required checkbox, data label, tooltip, assigned-to (Deputy/Docusign).
4. Variable creation includes an explicit **Fallback (Optional)** value (Ditto "Enter fallback…"); Klaviyo renders fallbacks inline in the tag: `{{ first_name|default:'firstname' }}`.
5. Coach mark on first use: "Assign fields — Assign specific fields for each recipient." (Docusign)

## Use when
Free-form layout is required AND per-recipient data must be bound to arbitrary positions — i.e., the advanced certificate designer.

## Avoid when
The user is a non-designer doing a standard certificate — parametric editor wins; canvas editors produce overlap/overflow defects with long names.

## Sad paths observed
- Blank-data risk is handled by fallback values (Ditto, Klaviyo) — the only observed guard against an empty merge field on a generated artifact.
- Empty panel state: "You haven't added data fields in this document. Choose fields to add or use the recommended ones." (Contractbook)

## Accessibility
Canvas drag-drop is the weak point; every observed app keeps a persistent (non-floating) panel and chip-styled tokens, which at least keeps field INSERTION keyboard-possible.

## Default verdict for our stack
VIABLE — this is what the legacy pdfme Designer already is (census #47). Steal the two missing pieces: grouped/searchable field palette with per-type required variables (census #15) surfaced as chips, and explicit fallback values per field.
