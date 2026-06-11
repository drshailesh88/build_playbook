# Pattern: Segment builder — condition rows with live count and matching-people preview
**Surface:** audience-selection · **Observed in:** Loops, Salesforce, Churnkey, Mailchimp (refs: [Loops audience step](https://mobbin.com/screens/953dcba1-a0cc-4b9a-8009-a0447eae6d3d), [Salesforce segment](https://mobbin.com/screens/2e76c385-807e-443a-a332-696494cebbbd), [Churnkey conditions](https://mobbin.com/screens/8c41f8e2-ea77-405c-b2da-3d75a21c4942), [Mailchimp segment](https://mobbin.com/screens/b07d5c26-86e9-4fec-9060-569ca8bf2bae))

## Flow
1. Condition rows of [attribute] [operator] [value] with "+ Add filter" (Loops) / "Add Another Condition →" joined by AND/OR chips (Churnkey); match-any vs match-all selector ("Contacts match [any▾] of the following conditions" — Mailchimp).
2. LIVE COUNT updates as conditions change: "1 subscribed contact currently in audience" (Loops); Salesforce shows a population number + refresh + bar.
3. Loops renders a live PREVIEW TABLE of the actual matching people (email, name, source, paginated) under the builder — not just a number.
4. Named save: "Unsaved Segment ▾" → "Save segment" + success toast (Loops); Churnkey opens with "Who's the audience? Give this segment a memorable, distinct name."
5. Semantic condition values where possible: "Date Added is after **the last campaign was sent**" (Mailchimp).

## Use when
Audiences need ad-hoc logic beyond named cohorts and the data model has queryable attributes; the live count + preview is what makes filter-building trustworthy.

## Avoid when
Most sends target fixed role groups — build named cohorts first; a full builder without live preview is worse than no builder.

## Sad paths observed
- Zero-match conditions surface immediately via the live count hitting 0 — caught at build time, not after a silent empty send.
- Churnkey autosaves ("✓ Saved") so half-built segments survive navigation.

## Accessibility
Condition rows are native selects; AND/OR chips have text labels; preview table is a real table.

## Default verdict for our stack
VIABLE (V2-leaning) — live count + preview-the-people is the bar if we build it; until then Fresha-style named cohorts (see audience-picker card) cover conference jobs.
