# Pattern: Proactive context microcopy (explain what the data means for ME)
**Surface:** travel · **Observed in:** Flighty (refs: https://mobbin.com/screens/0b1b9d14-b576-44ea-b93b-c40ba046fbfd, https://mobbin.com/screens/aabd3462-222b-43ad-91c6-8c8364e515a1), American Airlines, Kiwi.com

## Flow
1. Reassurance with evidence, ahead of the question: "Gate Departure in 5h 55m — **Inbound aircraft is in air from Seoul, with enough time for 9:50 PM departure**" (Flighty).
2. "Good to Know" block translates gotchas: "Operated as KE 438 by Korean Air" (codeshare → which counter to find), "+2 Hours Timezone Change — 6:50 AM arrival is 4:50 AM Jakarta time" (body-clock translation).
3. Time-window facts stated as countdowns: "Check in beginning 24 hours before departure — Time until check-in: 6d" (AA); "Online check-in opens 48 hours before departure" (Singapore Airlines).
4. App-value framing on the booking page: "Check our app when traveling for the unique live updates… terminal, gates, flight delays" (Kiwi).

## Use when
Itinerary data has non-obvious implications (overnight arrival +1 day, codeshare carrier, tight transfer); delegate-facing pages where the reader is not a travel professional.

## Avoid when
Ops power-user tables — explanatory prose between rows slows scanning; keep it to detail pages and traveler-facing surfaces.

## Sad paths observed
- The +1-day arrival is flagged inline ("6:50 AM **+1**") everywhere times are shown — the single most-missed itinerary fact.

## Accessibility
Microcopy is body text adjacent to the value it explains, not a hover tooltip.

## Default verdict for our stack
VIABLE — cheap to add to the delegate itinerary view (+1-day markers, timezone note for international arrivals); skip for V1 ops tables.
