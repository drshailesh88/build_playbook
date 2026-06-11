# Pattern: Bulk selection toolbar (contextual actions with count, undo for soft ops, confirm for hard ops)

**Surface:** people-registration / bulk operations · **Observed in:** Notion, HubSpot, Fibery, Sprig, Neon, Clay (refs: https://mobbin.com/flows/30b98bed-ae6c-4b9d-bf43-b03193211e1f , https://mobbin.com/flows/0f99578e-b531-401b-86cd-8b50ccbeb5f2 , https://mobbin.com/flows/4cb8c8fc-f057-41f5-9dc5-4c5deb7e53a9 , https://mobbin.com/flows/c75267ec-4dec-4717-b8b6-3ebb2034f866 , https://mobbin.com/flows/09eadbd7-fd3a-4694-a70b-f3cc3ca1d888)

## Flow
1. Row checkboxes (+ header select-all) summon a toolbar showing the live count: above the table ("2 selected" Notion; "2 contacts selected — Enrich records · Assign · Edit · Delete · Create tasks · …" HubSpot), as a button with count ("Actions (5 Problems)" Fibery), or as a floating bottom pill ("5 users · Add to Manual Group · ×" Sprig).
2. The toolbar carries the verbs that make sense in bulk: edit shared properties directly (Notion exposes property buttons in the bar), add-to-group/list, assign, export selection, archive/delete.
3. Soft/destructive split: trash via toolbar → undo toast ("Moved to trash — Undo", Notion); permanent deletion → explicit confirm modal naming the consequence ("You are about to permanently delete the selected records", Neon).
4. Multi-select also powers merge (Clay: select 2 → "Merge People").
5. Selection state shows in the status bar ("5 Rows, 2 Selected") and clears with an explicit ×.

## Use when
Any operator task that repeats per-row more than ~3 times: tagging 60 faculty, linking an import cohort to an event, archiving a cancelled event's walk-ins.

## Avoid when
Rows are heavyweight aggregates where bulk edits have non-obvious cascades (bulk-anonymize should NOT exist). Cap or chunk server-side; don't offer select-all across pages without showing the true total being affected.

## Sad paths observed
- Bulk delete of wrong rows → undo toast (soft) or count-naming confirm (hard); never silent.
- Actions inapplicable to the selection are disabled with the reason (HubSpot greys "Enrich records" until eligible).

## Accessibility
Toolbar is announced when selection becomes non-empty; count is live-region text; checkboxes labeled per row.

## Default verdict for our stack
RECOMMENDED — the old app has zero bulk operations (every excellence app treats this as table stakes). V1 verbs: add/remove tag, link to event, archive (with undo), export selection. Role-gate exactly like single-row RBAC; server actions take ID arrays with the same per-person ownership checks.
