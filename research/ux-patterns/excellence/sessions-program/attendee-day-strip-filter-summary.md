# Pattern: Day strip + always-legible filter state

**Surface:** sessions-program / attendee-program · **Observed in:** Apple Store, WWDC, Insight Timer, Peacock, Peloton (refs: [Apple ios day strip](https://mobbin.com/screens/f793066c-c8d8-487c-b3ed-4ed2977f3522), [Apple web](https://mobbin.com/screens/baa5b1f1-a8f4-4260-90d4-586e49f58afa), [WWDC Filter (On)](https://mobbin.com/screens/4794ea69-0135-4544-b633-f626859328d8), [Peacock filter chip](https://mobbin.com/screens/f015d9ed-304e-4a96-91c2-879af3cb3f4c), [Peloton schedule](https://mobbin.com/screens/dea205e1-85f7-4a27-89bf-b0ea6af81816))

## Flow
1. Horizontal day strip (weekday letter + date; selected day = filled circle); web shows two full weeks.
2. Under it, the active filter state rendered as a plain-text sentence: "All Formats, All Topics, All Types, Anytime" with the "Filter" control beside it (Apple).
3. Filter state lives in the control itself when there's no room for a sentence: "Filter (On)" (WWDC), "Filter(9)" (Apple), "Filters · 20" (Insight Timer), or a removable chip "Hockey ✕" (Peacock).
4. Peloton compresses the whole job into one screen: track chips row + day strip + session rows with one-tap add circles.

## Use when
Filtered program views — the user must always be able to answer "what am I looking at right now?" without opening the filter sheet.

## Avoid when
More than ~4 facets — the summary sentence becomes unreadable; fall back to count-in-control ("Filter (6)") + removable chips.

## Sad paths observed
- Active filters are the #1 cause of "where did my sessions go" — every app here makes the state visible to prevent it (see also the empty-results-recovery card).

## Accessibility
Filter state as text, not a badge dot; selected day is high-contrast filled shape + text.

## Microcopy worth stealing
"All Formats, All Topics, All Types, Anytime" · "Filter (On)" · "Filters · 20"

## Default verdict for our stack
RECOMMENDED — day strip + track/type chips + count-in-filter-control is the right chrome for both the attendee program and the admin sessions list (which already has search + date grouping).
