# Pattern: Session full → waitlist + recovery actions, state announced twice

**Surface:** sessions-program / attendee-program · **Observed in:** Meetup, SeatGeek, Eventbrite, Luma (refs: [Meetup full event](https://mobbin.com/screens/b438104a-4a98-49bf-ae6c-752da7f52cee), [SeatGeek no-availability](https://mobbin.com/screens/714058e6-324f-423a-951a-8719e8dc95e2), [Eventbrite scarcity badge](https://mobbin.com/screens/541607d7-9eb4-4c68-98a6-40136b884128))

## Flow
1. Pre-full scarcity signal at browse level: "🔥 Few tickets left" (Eventbrite); "Sold Out" / "Near Capacity" chips on cards before click-through (Luma, round-1 harvest).
2. When full, the state is announced TWICE — top banner "Event is full." AND sticky bottom bar "Event full | Join Waitlist" — it survives any scroll position (Meetup).
3. Content stays fully browsable; the CTA converts to the alternative action ("Join Waitlist").
4. Hard sold-out still offers two forward actions: "Track the event to be notified or give the box office a try." → "Track Event" / "Box Office" (SeatGeek).

## Use when
Capacity-limited sessions (workshops, wet labs, limited-seat halls) — the full state must convert demand into a waitlist, not bounce it.

## Avoid when
Capacity isn't actually enforced — a fake waitlist is worse than honest unlimited registration.

## Sad paths observed
This card IS the sad-path family: near-capacity → full → waitlist → hard sold-out with recovery.

## Accessibility
State as words in two fixed locations; disabled-feel label paired with an enabled alternative CTA.

## Microcopy worth stealing
"Event is full." · "Join Waitlist" · "Few tickets left" · "Track the event to be notified or give the box office a try."

## Default verdict for our stack
RECOMMENDED (when session capacity ships) — the old app's hall capacity is a free-text string with no enforcement; numeric capacity + full-state + waitlist is the excellence ceiling for workshop-style sessions.
