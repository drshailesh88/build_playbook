# Pattern: Auto-tag every import batch for traceability and cleanup
**Surface:** import-wizard-sad-paths · **Observed in:** Intercom (refs: [Intercom flow](https://mobbin.com/flows/c7c65d83-e2e9-4de0-85a4-aebf6b295b79), [Intercom import history](https://mobbin.com/screens/f5985c42-1dfb-4139-8303-b5b59add5951))

## Flow
1. The wizard's "Choose tags" step explains: "Each import gets a unique tag to help you find the users you've created and updated."
2. A non-removable auto-tag is pre-applied, named with provenance: "CSV Import - 2024-06-01 12:00:17 UTC"; the user can add extra tags ("+ Add another tag").
3. After import, the history page shows the Auto Tag Name per run alongside Users count, Status, and an Errors count link.
4. Because every created/updated record carries the tag, the user can filter to the exact cohort an import touched — and bulk-edit or bulk-delete it using normal list tooling, even without a dedicated revert feature.

## Use when
- You want undo-capability and segmentation without building a bespoke revert engine — the tag IS the import_batch_id, surfaced to users.
- Updated records matter: revert can't safely restore overwritten values, but the tag still lets users find and inspect everything the import touched.

## Avoid when
- The tag namespace is user-facing and precious — dozens of machine-named tags pollute tag pickers unless they're segregated or filterable.
- Records can belong to many imports over time; a single import tag misleads about "source of truth."

## Sad paths observed
- The auto-tag covers both created AND updated records — Intercom's copy calls this out, which is more honest than delete-only revert.
- History row links the tag to "4 users" and "4 errors" — one row answers who/what/how-many-failed.

## Accessibility
- Tag is shown as a removable-chip control with text label; the explanation copy sits directly above the control, not in a tooltip.
- History table uses text links for drill-ins (users, errors), not icon-only actions.

## Default verdict for our stack
RECOMMENDED — as the data-model substrate: stamp every imported/updated attendee with the import batch (and optionally expose it as a filterable system tag); it makes revert, partial cleanup, and "which import added this person?" all answerable.
