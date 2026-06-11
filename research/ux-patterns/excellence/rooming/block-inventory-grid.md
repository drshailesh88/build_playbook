# Pattern: Room-block inventory grid (per-night × room-type counts with bulk edit)
**Surface:** rooming · **Observed in:** Booking.com extranet, Expedia Groups, TravelPerk Events, Posh
(refs: https://mobbin.com/screens/07541cc9-c756-495e-936c-21a11a2cf768 , https://mobbin.com/screens/2b3af48a-084e-4dea-baf6-bf49f9eae22e , https://mobbin.com/screens/e402101c-86bc-4441-90b8-635b11dc2fda , https://mobbin.com/flows/8c7e207c-f722-4c64-9190-d2591cf1eb2c ; raw: `_raw/by-app.md` §A18, `_raw/by-flow.md` §F23–F25, `_raw/by-pattern.md` §P28)

## Flow
1. Per-hotel calendar matrix: rows per room type with stub rows "Room status / Rooms to Sell / Net Booked" against a day axis; per-night numerals, green "Bookable" vs red "Closed / Multiple blockers" bands (Booking.com extranet).
2. Per-night counts are allowed to VARY across the stay — Expedia Groups renders "Rooms per night: 10" as a per-date grid "Jul 01: 9 / Jul 02: 9 / Jul 03: 7 / Jul 04: 7" per room type (shoulder-night tapering is data, not an error).
3. Bulk edit drawer: date range + "Which days of the week do you want to apply changes to?" (Mon–Sun checkboxes) + per-room-type tabs + accordions (counts / prices / open-close radio / restrictions) + scope line "Changes will be made to the date range: …" → "✓ Your changes were successfully saved!".
4. Capacity-capped counter as the summary primitive: "Sold 3 / 100" per ticket type with sale windows (Posh).
5. The consumed artifact: TravelPerk Events Accommodation tab = sortable Hotel / Check-In / Check-Out / Travelers table with "Download csv".

## Use when
The event contracts rooms from hotels in advance (blocks) and ops must always know contracted vs assigned vs remaining, per room type, per night.

## Avoid when
Bookings are purely ad-hoc per-delegate reservations with no contracted inventory — a status-tabbed list (see `ops-table-status-views.md`) suffices and a grid would be empty ceremony.

## Sad paths observed
- Closed/blocked nights as red bands with named blockers, never silently hidden.
- Closed-state recovery advice card: "Your property is currently closed but ready to be reopened… Open property".
- Inline validation on bulk save ("Enter a price"); per-night tapering counts accepted as valid.

## Accessibility
"N of M" text always accompanies any bar/color; status conveyed by word + color, never color alone.

## Default verdict for our stack
RECOMMENDED — for EventState this is the missing center of the module: rows Contracted / Assigned / Remaining per room type per night, per hotel. The contract lifecycle around the block (cutoff, attrition, release-back) has NO Mobbin precedent — see `first-principles-gaps.md` #4.
