# Pattern: Countdown-first flight list (time-until as the primary column)
**Surface:** travel · **Observed in:** Flighty (ref: https://mobbin.com/flows/822e5e87-5e54-4117-b556-362464cac7e1), Kiwi.com ("Departs in 37 days" hero — https://mobbin.com/screens/916e5287-a538-48d7-a5af-dbaa17da0048), Navan group cards ("In 56 days")

## Flow
1. List is sorted by time-until-departure; the LEFT rail is a big countdown unit that compresses as the event nears: "16 DAYS" → "2 DAYS" → "8 HOURS" → "5h 41 MINUTES".
2. Row body: airline logo + flight number chip, route in plain words ("San Francisco to London"), dep/arr airport codes + local times.
3. Right edge: live status ("Departs On Time") or calendar date for far-future rows.
4. In-flight rows replace countdown with state ("IN AIR", "Landing in 3h 29m").

## Use when
The user's question is "what's next and how soon" — ops day-of triage, traveler home screen. Works as the default sort for an event's travel list around event dates.

## Avoid when
Browsing/auditing historical or draft records (countdown is meaningless); admin tables needing column sort by person/route.

## Sad paths observed
- Empty state is an invitation, not a blank: "Let's Fly Somewhere — Tap the search bar to add your next flight" (Flighty).
- Past flights drop to a separate year-grouped history (Tripsy "My Trips 2025").

## Accessibility
Countdown is text, not a graphic; unit words ("DAYS", "HOURS") included for screen readers.

## Default verdict for our stack
RECOMMENDED — the oracle sorts by createdAt desc (A5), which buries the urgent; departure-proximity sort + countdown column is the single highest-leverage list change for ops.
