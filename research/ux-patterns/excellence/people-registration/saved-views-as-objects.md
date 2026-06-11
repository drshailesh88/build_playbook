# Pattern: Saved views as named, shareable objects (with dirty-state guard)

**Surface:** people-registration / list views · **Observed in:** Attio, Airtable, HubSpot (refs: https://mobbin.com/flows/eb12a5f8-d2c3-4b72-bd44-5187b76aa36a , https://mobbin.com/flows/ba9faa69-a275-4e70-ab76-c4ae1b1f946c , https://mobbin.com/flows/3c8b481b-50b3-461f-8f1b-097c30766101 , https://mobbin.com/flows/0f99578e-b531-401b-86cd-8b50ccbeb5f2)

## Flow
1. View name is a chip/dropdown in the table header (Attio: colored chip with dot; HubSpot: tabs across the top with "+ Add view (5/5)" cap; Airtable: views sidebar with "Find a view" search).
2. A view bundles filter + sort + column visibility + grouping. Switching views swaps the whole bundle.
3. Editing a saved view's filters/sort marks it DIRTY: Attio shows "Discard changes / Save ▾" top-right until the user explicitly resolves — ad-hoc exploration never silently mutates a shared view.
4. Airtable splits the problem by type instead: "Collaborative view" (editors can change config) vs "Assign as personal view"; view menu has Rename / Duplicate / Copy another view's configuration / Delete.
5. "+ Create new view" lives at the bottom of the view switcher.

## Use when
Multiple staff roles slice the same people table repeatedly (faculty vs delegates vs VIPs per event); views are shared team artifacts.

## Avoid when
The audience is 1–2 admins with a handful of fixed slices — hardcoded view chips (the old GEM approach) are simpler and cannot be broken by a teammate. Also avoid user-created views before filter UI exists; a view is just a named filter set.

## Sad paths observed
- Unsaved view changes → explicit Discard/Save affordance, never auto-persist (Attio).
- View cap reached → "+ Add view (5/5)" communicates the limit inline (HubSpot).
- Deleting a view is in the per-view menu behind a red item; record data is unaffected.

## Accessibility
View switcher is a searchable listbox; active view is check-marked and announced.

## Default verdict for our stack
VIABLE — keep the six hardcoded role-footprint chips for V1; named custom views become attractive only after the filter builder ships. If adopted, copy Attio's dirty-state guard verbatim.
