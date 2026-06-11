# Pattern: Color-coded track filter with legend built into the control

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Amie, Deputy (refs: [Amie calendars dropdown](https://mobbin.com/screens/1a78610f-8071-4015-90c4-bddebf54da35), [Deputy legend](https://mobbin.com/flows/a426e08b-cd76-4cd5-a684-0830b4744e1d))

## Flow
1. A "N calendars" pill of stacked color dots opens a dropdown: search field ("Filter 6 calendars…"), then checkbox + color dot + NAME per item — the filter control IS the legend.
2. Grid events carry a matching left color border; toggling a checkbox shows/hides that track.
3. Past/declined events render struck-through (state without color); "Drag to reorder" in the list variant.
4. Deputy's bottom legend pairs every color with label + live count.

## Use when
Multi-track programs — track color is the fastest grid-level disambiguator, but only if the color→name mapping lives one click away.

## Avoid when
Relying on color alone — both apps pair color with names/counts/strikethrough; tracks must also be readable as text on each chip.

## Sad paths observed
- None; the legend-in-control prevents the "what does orange mean" failure.

## Accessibility
Color always paired with name; strikethrough conveys past/declined without hue.

## Microcopy worth stealing
"Filter {n} calendars…" search placeholder · "Drag to reorder"

## Default verdict for our stack
RECOMMENDED — tracks exist in the schema as free text; the grid gives each track a color + the filter-with-legend control; same control reused on the attendee program (day-strip-filter-summary card).
