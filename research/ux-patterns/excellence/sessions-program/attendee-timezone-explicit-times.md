# Pattern: Timezone-explicit time display, everywhere a time appears

**Surface:** sessions-program / attendee-program · **Observed in:** WWDC, Unity, Meetup, Zomato, Front (refs: [WWDC SGT headers](https://mobbin.com/screens/ee3a8dc6-1947-4aaa-8992-c56123eaaad1), [Unity WIB rows](https://mobbin.com/screens/feacd322-bdc8-4a73-b81b-d141fdb4f4f3), [Meetup local-tz note](https://mobbin.com/screens/b438104a-4a98-49bf-ae6c-752da7f52cee), [Zomato IST](https://mobbin.com/screens/8e8818d3-fead-4e24-b0ae-0fce398d6af2), [Front PDT](https://mobbin.com/screens/9c36ddbe-c23d-40e5-914f-f6f79d04358c))

## Flow
1. Every rendered time carries its zone: "1:00 AM SGT" (WWDC headers), "01:00 PM - 04:00 PM IST" (Zomato rows), "1:00 PM - 2:00 PM PDT" (Front detail).
2. Or the page declares the frame once, explicitly: "Times are displayed in your local time zone." (Meetup, directly under the date).
3. Cross-midnight rendered in words: "11:00 pm - 12:00 am (1 Day Later) WIB" (Unity).

## Use when
Always, for any program consumed by remote/traveling attendees — ambiguous times are the most expensive class of schedule bug.

## Avoid when
Never skip it; the only choice is per-time suffix vs one page-level declaration (suffix wins when a page mixes zones).

## Sad paths observed
The pattern exists to PREVENT the sad path (attendee shows up an hour off); Unity's "(1 Day Later)" handles the overnight edge.

## Accessibility
Zone as text in the same string as the time — read together by screen readers.

## Microcopy worth stealing
"Times are displayed in your local time zone." · "(1 Day Later)"

## Default verdict for our stack
RECOMMENDED (non-negotiable) — the old app's worst chronic scar is timezone display (UTC-shown-instead-of-IST, naive Date parsing, force-fixed rendering). The rebuild rule: no bare time strings anywhere in this module; every time carries "IST" or the page declares the frame.
