# Pattern: Filtered-empty vs true-empty — distinct copy and affordances
**Surface:** zero-data-empty-states · **Observed in:** Midday, OpenSea, Going, Codecademy, Fey, Slite, Amplitude, June, Linktree; anti-pattern in Todoist (refs: https://mobbin.com/screens/764b3128-3a79-43ca-8815-9a9024832473, https://mobbin.com/screens/536f3b96-4af8-4051-9f6d-95f34caeff60, https://mobbin.com/screens/45a834a8-d95b-43fe-8420-7f0660bb528b, https://mobbin.com/screens/71eb64b3-b380-486e-b0ca-0d10ad694e17, https://mobbin.com/screens/98950d41-eb89-49b7-8dc7-0b9bb585e3a0, https://mobbin.com/screens/7ff1da87-ed3c-4b42-b83d-1d0889946ef3, https://mobbin.com/screens/183843ab-eca8-4ecd-affa-0d665122535a, https://mobbin.com/screens/1c4908e9-c1e6-4ed7-97f2-a757099c5462, https://mobbin.com/screens/50215c96-2658-4f67-b176-1fa42d5131ab, https://mobbin.com/screens/7067e838-bccc-46fd-ad9e-af2425a82e95, https://mobbin.com/flows/8ebaf4bc-c201-4e91-a115-c4b4a16a2eff)

## Flow
1. FILTERED-EMPTY (data exists, query excludes it): copy names the search/filter as cause and the single CTA undoes it — Midday: "No results — Try another search, or adjusting the filters [Clear filters]"; OpenSea: "No results found — Try removing some filters [Clear filters]" with the active filter chips still visible and individually removable; Going: "0 DEALS MATCHING YOUR FILTER [Clear]"; Codecademy: "[Reset filters]"; Fey: keyboard affordance "Try pressing ⌫ to clear your latest filter, or ⌘⌫ to clear all".
2. The same screen in true-empty condition shows creation copy instead — Midday (same product, same page family): "No projects — You haven't created any projects yet. Go ahead and create your first one. [Create project]". The CTA verb flips from undo (clear/reset) to create.
3. Analytics variant — three-way split: no data for THIS QUERY ("Oops! No data matches your current chart setup. Try adjusting the events, properties, or date range" — Amplitude; "We found no data for your prompt" — June), no data in RANGE/integration off ("No data found in selected time range. Check your integrations in Settings" — Linktree), vs not instrumented at all (setup CTA — see connect-or-demo card).
4. Context preservation: filtered-empty keeps the query/chips/filter bar fully visible and editable; only the result region swaps (all observed apps).

## Use when
- Always. Any list/table that supports both search/filter and creation needs both states wired to the actual cause; for a new Event State tenant, filters on empty modules should ideally be disabled or the state should resolve to true-empty copy.

## Avoid when
- Never skip the distinction. Do not show "create your first X" when a filter is hiding existing records (user creates a duplicate), and do not show "clear filters" on a truly empty tenant (clears to another void).

## Sad paths observed
- Todoist conflates the two: a brand-new joined workspace shows "No projects found — Try adjusting your search. Or start a new project. [Add project]" — search-blame copy with zero data and no search entered. The exact failure this pattern exists to prevent.
- Going adds a third cause ("Check back later" — inventory may appear over time), showing copy must also distinguish "you filtered it out" from "nothing exists yet, globally".

## Accessibility
- Result-count announcements: Going/Todoist render explicit counts ("0 deals", "0 projects") — text count near the results region helps screen readers detect the state change after filtering.
- Fey's keyboard-only affordance (⌫ to clear) must be paired with a visible button — Fey provides both ("Clear all filters" button).
- Clear-filters button should return focus to the results region after clearing.

## Default verdict for our stack
RECOMMENDED — wire three distinct states per Event State list: true-empty (create CTA, per old app's decided micro-pattern), filtered-empty (cause-naming copy + Clear filters, chips preserved), and out-of-range for date-scoped analytics; copy Midday's pair as the reference implementation.
