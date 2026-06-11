# Pattern: Self-serve name/language fix on the artifact (reissue-lite)

**Surface:** certificates / recipient-correction · **Observed in:** Udemy, Codecademy (refs: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d, https://mobbin.com/flows/d3c6841c-5d55-4314-a12a-73f5bddc9d7c, https://mobbin.com/flows/943886cb-68e4-4bba-84df-f6926b0bebd9)

## Flow
1. Correction affordance lives ON the certificate surface: link "Update your certificate with your correct name or preferred language." (Udemy) / "Edit Name" footer link on the certificate modal (Codecademy).
2. Recipient edits → artifact regenerates → same certificate ID/URL keeps working (observed: Udemy cert no/url block unchanged across the localized variant).

## Use when
Display-name typos and language preference — the two corrections that should never need an admin.

## Avoid when
The name is part of the VERIFIED claim (medical license name matching) — self-editing becomes a forgery vector; route through an admin-approved change with audit instead. Also avoid silent regeneration if old PDFs must stay tamper-evident — regenerate as a supersession, not an overwrite.

## Sad paths observed
- None shown beyond the affordance itself; neither app shows rate-limiting or change-history for repeated edits (design from first principles: cap edits or log them).

## Accessibility
Text links, not icon-only; modal edit field pre-filled.

## Default verdict for our stack
RECOMMENDED with the supersession guard — legacy ALREADY has the machinery (supersession chain, census #17–18) and DEC-062 plans a delegate name-fix page (external-links). Certificates module must expose the regeneration as a normal supersession (new row, old row superseded) so self-serve fixes stay auditable.
