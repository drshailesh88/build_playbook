# Pattern: Progressive filter builder (chips → quick dropdowns → advanced groups)

**Surface:** people-registration / search & filtering · **Observed in:** Notion, Clay, Attio, HubSpot, Airtable (refs: https://mobbin.com/flows/3250dd04-9241-4db0-843a-51e4a8a5bf34 , https://mobbin.com/flows/f69ff737-7883-4c07-85d1-ede0488fd093 , https://mobbin.com/flows/a91dfb3c-c3d9-4a31-bca7-261f27332669 , https://mobbin.com/flows/b70ccea5-109c-4b46-b964-9510aa9e0a91 , https://mobbin.com/flows/0f99578e-b531-401b-86cd-8b50ccbeb5f2)

## Flow
1. Entry tier 1 — quick dropdowns: HubSpot pins the 3–4 highest-traffic properties as always-visible dropdowns above the table (Contact owner / Create date / Lead status) + an "Advanced filters" link.
2. Entry tier 2 — chips: Notion renders each active filter as an editable chip under the toolbar ("Status: Not Done ▾", "+ Add filter"); clicking a chip edits it in place.
3. Entry tier 3 — advanced builder: Where/And rows (field / operator / value), "+ Add filter rule", and "Add filter group — a group to nest more filters" for OR-of-ANDs (Notion, Clay).
4. Applied state is always visible as a count chip ("Advanced filter 3" in Attio, "1 Filter" in Clay, "2 rules" in Notion); row count live-updates as conditions change (Clay status bar "5 Rows, 0 Selected").
5. Column header shortcut: "Filter by this field" / "Group by this field" in the column menu (Airtable) — zero-distance pivot from seeing a column to filtering on it.

## Use when
The table has more queryable fields than fit as columns (org, city, specialty, tag, event linkage) — true for any conference people DB.

## Avoid when
Nested OR groups are overkill for V1 ops users; ship tiers 1–2 first. Don't build a builder for fields users can't see anywhere (filter on indexed, displayed attributes).

## Sad paths observed
- Filter excludes everything → Notion's filtered-empty state offers "Edit filters" inline instead of a dead "no results".
- Removing the last rule collapses cleanly back to unfiltered; "Delete filter" is explicit in the rule popover.

## Accessibility
Chips are buttons with the full condition as accessible name; the builder is a form, not a canvas.

## Default verdict for our stack
RECOMMENDED — the old app already accepts org/city/specialty/tag URL params with zero UI (done-spec §15 UNFINISHED). Ship tier 1 (quick dropdowns for view/tag/org/city/event) + tier 2 (chips) in V1; tier 3 groups are V2.
