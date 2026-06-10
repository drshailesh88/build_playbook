# Pattern: Per-pair duplicate review with merge preview
**Surface:** import-wizard-sad-paths · **Observed in:** folk, Square, Salesforce, Front, Customer.io, ManyChat (refs: [folk duplicates](https://mobbin.com/screens/75065e3c-d49c-43fc-8705-fc5d622b140c), [folk bulk merge](https://mobbin.com/screens/ca3f42a1-bbf0-41fe-a634-9514f736f557), [Square](https://mobbin.com/screens/0f085c42-6e9b-4abb-ad6b-3fd3b369f632), [Salesforce compare](https://mobbin.com/screens/eb7abb1d-f6fe-432c-b6f9-495dfdb360af), [Salesforce select](https://mobbin.com/screens/0f472d18-41db-4d1a-94ff-725266eb6daa), [Front](https://mobbin.com/screens/7dd16e14-0899-4b53-9525-a5fef2def520), [Customer.io](https://mobbin.com/screens/42f2ec5f-f654-45ad-a14a-d6b8ac54b12f), [ManyChat](https://mobbin.com/screens/7f3931a4-2c65-4132-bc83-50f14a9a39af))

## Flow
1. Detected duplicates land in a dedicated review surface: folk has a persistent "Duplicates" sidebar item with a count badge ("We've detected 1 possible duplicate contact"); Square opens a "Review Duplicates" screen post-import.
2. Each group shows the candidate records side by side with their differing fields visible (folk: two cards — same email vs same phone).
3. A third panel previews the merge result: folk composes the merged contact with checkboxes per value (1 company, 2 emails, 2 phones — untick what to drop) before committing.
4. Per-group actions: "Don't merge / Merge" (folk), "Ignore / Merge" (Square); bulk escape hatch "Merge All" (Square).
5. Field conflicts force a pick: Salesforce's "Compare leads" lists every field as radio pairs with "Select All" per side and a "principal record" choice; Front flags "1 conflict found for name" with a swap-value dropdown; Customer.io shows primary vs merge-into columns with discarded values struck through and a "Swap" control.
6. Irreversibility is disclosed before commit: "Merging cannot be undone" (Front's how-it-works callout); ManyChat requires a checkbox acknowledgment — "the system will permanently delete the Secondary Contact and its Inbox records. This action is irreversible."
7. Salesforce caps the group size ("choose up to 3 leads. Then click Next and choose the fields to keep").

## Use when
- Match confidence is partial (same email, different phone) and a wrong auto-merge would destroy data.
- Post-import cleanup: the queue model (folk) lets dedupe happen after the import lands, decoupled from the wizard.

## Avoid when
- Hundreds of duplicate groups — per-pair radio surgery doesn't scale; lead with a bulk policy and reserve review for conflicts only.
- Records have side effects attached (inbox threads, registrations) and you can't honor the "what happens to X" question — ManyChat's acknowledgment text exists because merges delete dependent records.

## Sad paths observed
- Conflict-only escalation: Front only makes the user choose where values genuinely collide ("1 conflict found"), everything else preserved automatically ("Fields that can have multiple values are all preserved").
- Discarded values rendered as strikethrough (Customer.io) — the cost of the merge is visible pre-commit.
- "Don't merge" is a first-class equal-weight button, not a buried link (folk, Square).

## Accessibility
- Field choices are radio inputs with text values — keyboard operable (Salesforce).
- Strikethrough (Customer.io) must be paired with programmatic state, not styling alone.
- ManyChat's consequence text is in the dialog body adjacent to the checkbox, not behind a tooltip.

## Default verdict for our stack
VIABLE — adopt a lightweight version (side-by-side + keep-which-value for email+phone conflicts, "Skip" as first-class) for the conflict subset only; full Salesforce-style field-by-field compare is overkill for event attendee data.
