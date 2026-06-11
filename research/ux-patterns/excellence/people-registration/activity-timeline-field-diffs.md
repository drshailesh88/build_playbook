# Pattern: Activity timeline with grouped field-level diffs and provenance events

**Surface:** people-registration / change history · **Observed in:** Attio, Clay (refs: https://mobbin.com/flows/723a0c99-c91a-486b-816b-9ebe1f2bd387 , https://mobbin.com/flows/78502e69-41ed-4e62-86f5-66cf2f7298d2)

## Flow
1. Timeline grouped by period ("This week", month headers), newest first.
2. Human edits are COLLAPSED into one entry per save: "Alex Smith changed Stage and 7 other attributes — 3 minutes ago" → expands to field rows with → arrows (Stage → Meeting, Owner → Alex Smith, value → $50,000.00), "Hide all changes" to collapse.
3. System/provenance events are first-class timeline citizens: "sweetgreen was created", "X was added to Domains", Clay's "Jane imported via Bulk Import" / "Alex imported via Email" — every record answers "where did this come from".
4. Actor is always a resolved display name + avatar, never a raw ID.

## Use when
Multiple staff + automated sources (registration form, CSV import, merge) write to the same person — disputes get settled by the timeline.

## Avoid when
Single-writer data with no compliance need; a created/updated stamp suffices. Don't render raw audit JSON — if you can't resolve diffs into labeled field rows, summarize instead.

## Sad paths observed
- Bulk multi-field changes don't spam N timeline rows — one grouped entry, expandable (Attio).
- Merge survivors keep BOTH source timelines (Clay) — history is unioned, not dropped.

## Accessibility
Expandable entries are disclosure buttons; diffs are text rows, not color-only indicators.

## Default verdict for our stack
RECOMMENDED — the audit meta already stores `changes{field:{from,to}}` and `source`; the rebuild needs the Attio rendering: grouped per save, expandable diffs, resolved actor names (done-spec §43 UNFINISHED: today shows truncated user IDs), and import/registration/merge provenance lines.
