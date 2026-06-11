# Pattern: CSV import wizard with auto-mapping + row-level remediation

**Surface:** certificates / bulk-issuance (custom recipient lists) · **Observed in:** Attio, Apollo, Customer.io, Height, Rox, HoneyBook, 15Five, Cloaked (refs: https://mobbin.com/flows/535a7828-5915-47a2-b782-c6bfd708adc0, https://mobbin.com/flows/5b22533b-8aa7-4446-9016-0ffe74856ed1, https://mobbin.com/flows/246ac8d9-3fc6-42e1-a04c-aede744f7879, https://mobbin.com/flows/71d21f5c-123c-4071-9879-6cd7bd270d71, https://mobbin.com/flows/e88d71cc-ca76-4aec-848f-01c78fc7b29c, https://mobbin.com/flows/27cfd50f-ed50-40ba-a356-aaa5f23c83bc)

## Flow
1. Stepper: Upload file → Map columns → Review values → Preview import (Attio).
2. Auto-map with honest counts: "8 columns detected: ✓ 6 recognized, 2 need mapping" (Apollo); unmapped flagged: "Unmapped attributes will not be imported." (Height); "This column will be skipped." (Customer.io).
3. Review step fixes data IN PLACE: red "Invalid domain" chip with inline editor; "+ Create 3 missing select options" bulk-fix (Attio).
4. Dedupe policy is explicit: "If contacts already exist → Update the existing record with information from CSV" (Apollo).
5. Pre-flight summary tiles: NEW PEOPLE / EXISTING / ID CHANGES / WARNINGS / ERRORS + "Complete import" (Customer.io).
6. Async with notify: "Great, we're adding your clients… we'll notify you when it's complete." (HoneyBook); template download offered up front ("download our template" — HoneyBook, "Download current structure" — 15Five).

## Use when
The "custom" recipient group (legacy census #26) arrives as a file — every error caught BEFORE issuance, never as a failed certificate.

## Avoid when
Recipients already exist in the people module — import belongs there (onboarding-import module owns the generic wizard); certificates should only CONSUME a selected group.

## Sad paths observed
- File-level: "Cannot decode file. Please ensure file is ASCII or UTF-8 encoded." (15Five — actionable, names the fix).
- Required mapping missing blocks continue (Height modal).
- Post-import row taxonomy: Bounced / Verification Failed / Needs Attention / "Enrichment failed" chips (Rox).
- Backup warning before destructive overwrite (15Five).

## Accessibility
Status chips carry text labels; needs-attention grouping is navigable as sections, not color-coded cells alone.

## Default verdict for our stack
RECOMMENDED for the custom-list path, scoped: reuse the project-wide import wizard pattern (onboarding-import surface) and add the certificate-specific pre-flight ("N will receive delegate_attendance; 3 already hold one — will be superseded/skipped").

## Live-web corroboration (2026-06-11, issuer-side harvest — help-doc evidence)
All 7 surveyed credential platforms ship the same wizard shape. Steals beyond the Mobbin set: errors-block/warnings-flow-through with "Exclude records with warnings" opt-out + error-only CSV export preserving column order with an appended message column (Accredible); 6-option re-upload update-strategy dialog, e.g. "Update this campaign + set defaults for future" (Sertifier); and a GDPR consent checkbox at import — "Confirm that you have permission to use the personal data" (Certifier) — directly relevant for medical-conference recipient data. Refs: `_raw/live-web-issuer-side.md`, `issuer-console-patterns` card.
