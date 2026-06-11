# Pattern: Column header menu (per-column sort/hide/pivot in place)

**Surface:** people-registration / table chrome · **Observed in:** Attio, Airtable (refs: https://mobbin.com/flows/ba9faa69-a275-4e70-ab76-c4ae1b1f946c , https://mobbin.com/flows/ed0e54dc-e653-4ca0-992b-a6b9e86be4b0)

## Flow
1. Every column header carries a ▾ menu: Sort ascending / Sort descending, Move left / Move right (Attio) or Insert left/right (Airtable), Edit column label, Hide from view, Formatting.
2. Airtable adds pivots: "Filter by this field", "Group by this field", "Duplicate field" (modal with "Duplicate cells" toggle), "Edit field permissions".
3. Hide is per-view and non-destructive; a "Hide fields" toolbar item shows the hidden count ("2 hidden" in Clay).
4. Multi-key sort accumulates: sort popover lists keys with direction selects and "+ Add sort" (Attio).

## Use when
Tables exceed ~6 columns or users differ in which columns matter (registration desk vs scientific committee).

## Avoid when
A fixed 4-column responsive table (old GEM list) — a menu per header adds chrome without payoff. Don't expose "Edit label"/"Delete field" to non-admin roles.

## Sad paths observed
- Hiding a column never deletes data; it is reversible from "Hide fields" panel.
- Destructive "Delete field" is red and last, separated from safe items (Airtable).

## Accessibility
Header menus open on Enter/Space from a focusable header cell; sort state is reflected via aria-sort.

## Default verdict for our stack
VIABLE — adopt sort asc/desc + hide-from-view on the people table when column count grows past the current responsive card/table; skip move/format/permissions for V1.
