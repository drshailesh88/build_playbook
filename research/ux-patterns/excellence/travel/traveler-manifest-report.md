# Pattern: Traveler manifest report (who is where / who lands when)
**Surface:** travel · **Observed in:** Navan Safety → Traveler report (ref: https://mobbin.com/flows/bd74505f-dcf4-4549-9322-2ad49ad36901) — ONLY substantive sighting; pattern is THIN on Mobbin → first-principles candidate

## Flow
1. Report intent stated plainly: "Download here all the booking details of your current and future travelers by location, flights or hotels."
2. Pivot tabs: Location / Flights / Hotels.
3. Filters: date range, continent, location (+ add) → "Show list" → tabular list, downloadable.

## Use when
Ops needs a roster cut by time and place: airport pickup manifests ("everyone landing Thursday at DEL"), duty-of-care ("who is in the city right now"), departure waves.

## Avoid when
Fewer than ~10 travelers (the list view already answers it); don't build a separate report surface when a filter+group-by on the main list suffices.

## Sad paths observed
- None observable in flow (no empty/zero-result state captured). Mobbin is dry on day-of arrivals boards — airlines/airports solve this with physical FIDS, not SaaS UI.

## Accessibility
Plain table semantics; export as the primary verb.

## First-principles sketch (flagged, not observed)
Group the event's travel list by arrival date → window (morning/afternoon/evening) → airport; columns: time, person, flight, from, PNR, status badge, transport-assignment link; print/CSV export. This is the conference ops artifact every transport desk improvises in a spreadsheet today.

## Default verdict for our stack
RECOMMENDED (as a grouped view of existing data, not a new module) — census A7 sorts per person; nothing in the oracle answers "who lands Thursday" without manual scanning. Highest-value first-principles build in this surface.
