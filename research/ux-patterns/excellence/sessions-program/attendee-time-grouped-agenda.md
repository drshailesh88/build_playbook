# Pattern: Time-grouped agenda list with sticky headers

**Surface:** sessions-program / attendee-program · **Observed in:** WWDC, Eventbrite, Zomato (refs: [WWDC sessions list](https://mobbin.com/screens/ee3a8dc6-1947-4aaa-8992-c56123eaaad1), [WWDC filtered](https://mobbin.com/screens/4794ea69-0135-4544-b633-f626859328d8), [Eventbrite agenda](https://mobbin.com/screens/4e0310b8-22bf-46f6-b4a3-1a006417892f), [Zomato artist schedule](https://mobbin.com/screens/8e8818d3-fead-4e24-b0ae-0fce398d6af2))

## Flow
1. Sessions list grouped under sticky uppercase time headers: "TUESDAY, 1:00 AM SGT" — day AND start-time AND timezone in the header.
2. Each row: title, then one grey metadata line "1:00 – 3:00 AM – Hall 2" (time + venue together).
3. Star/save icon at row-right; search bar above the list.
4. Eventbrite variant for the public page: day pills (FRIDAY/SATURDAY/SUNDAY) above time-slot rows.

## Use when
Dense multi-day programs where attendees scan by time ("what's on at 2pm?") — the dominant conference mental model.

## Avoid when
Few sessions per time slot — sticky time headers add chrome without aiding scanning; day pills + flat list suffice.

## Sad paths observed
- Cross-midnight sessions: "5:00 PM - 12:00 AM (+1 day)" (Eventbrite) — the overnight edge handled in copy.

## Accessibility
Headers are text (sticky positioning only); time+venue on one line reads in a single screen-reader pass.

## Microcopy worth stealing
"(+1 day)" suffix for sessions crossing midnight.

## Default verdict for our stack
RECOMMENDED — matches the old app's date-grouped sessions list but adds sticky time headers and row-level save; pairs with the timezone-explicit display card (the module's chronic IST scar).
