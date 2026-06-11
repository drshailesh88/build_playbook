# Pattern: Ops table — status tabs with counts, filter chips, saved views, bulk bar, taught empty states
**Surface:** rooming · **Observed in:** Squarespace, Relevance AI, Whop, QuickBooks, Notion, ManyChat, folk, Attio, Linear
(refs: https://mobbin.com/screens/f0391f62-aff1-49ba-91e9-cade37d045ea , https://mobbin.com/screens/11dc1da7-db6d-4887-8f2e-13916ca07ed8 , https://mobbin.com/screens/0ec7fd15-b0bd-4c4d-9a6d-c67cbef1c1f4 , https://mobbin.com/screens/50bd214b-d94c-4a11-96fd-a4b800afb668 ; raw: `_raw/by-pattern.md` §P5/P8/P9/P16)

## Flow
1. Status tabs with counts above the table: "All tasks 17 | To review 4 | Escalated | Errored | ✓ Completed 17" (Relevance AI) — tabs double as a progress readout.
2. Search scoped in words: "Search by customer name, email, product, or order number" (Squarespace).
3. Active filters as removable chips ("Payment • Failed ×"), filter builder ("Where status Is not Completed"), "Save view", "Export (17)" with count in the button (Relevance AI).
4. Rich status taxonomy, each colored + worded: Succeeded / Pending / Failed / Past due / Canceled / Refunded / Dispute warning… (Whop).
5. Bulk: header checkbox indeterminate, "2 selected" persistent toolbar with contextual actions; Bulk Actions disabled at zero selection (ManyChat).
6. Empty states teach: column headers stay rendered; multi-path CTA list ("Add people / Start from a template / Import from a file / Connect an integration") (folk); filter-induced emptiness disclosed ("1 issue hidden by filters · Clear Filters") (Linear).
7. Result count always visible: "Showing 1-2 out of 2 records".

## Use when
The rooming list at 500-delegate scale — the default working surface of the module.

## Avoid when
Building view complexity before there's data volume — but search + status tabs are floor, not ceiling.

## Sad paths observed
Over-filtered empty results explainable (chips + counts + hidden-by-filters); destructive bulk action isolated and red.

## Accessibility
Status pills = word + color everywhere; selection count text in a persistent toolbar; counts in tab labels.

## Default verdict for our stack
RECOMMENDED — `Unassigned (42) | Assigned (180) | Confirmed (160) | Changed (12) | Cancelled (8)` tabs, search by person/hotel, saved views ("Hilton only", "Cancellations this week"), bulk bar (resend, export, reassign). The old app's list has ONLY a flagged-only toggle — this whole card was never attempted.
