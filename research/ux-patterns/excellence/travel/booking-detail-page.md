# Pattern: Booking detail page (reference header + segment timeline + actions rail)
**Surface:** travel · **Observed in:** KAYAK (ref: https://mobbin.com/screens/b5afe65f-4575-4b4b-b40e-ae3415d11008), Kiwi.com (refs: https://mobbin.com/screens/916e5287-a538-48d7-a5af-dbaa17da0048, https://mobbin.com/screens/8997532f-572a-48ba-8143-9431217e86f1), Navan (ref: https://mobbin.com/screens/51f3a7c8-4cc1-4ce5-94c1-8f8afe68ab37), American Airlines (ref: https://mobbin.com/flows/63e2f645-0315-4c35-bf51-9a07aa1aefda)

## Flow
1. Header = identity + freshness: route/title, "Booking reference: PE24FB" (record locator copyable), "Booking created: Tue Mar 4 2025", "Updated 32 minutes ago" (AA), countdown hero "Departs in 37 days" (Kiwi).
2. Body = segment timeline: vertical dep→arr per segment with times, airports, carrier+number, layover rows ("2h 16m layover at YUL" — Navan), baggage info.
3. Right rail / sheet = every lifecycle action in one place: Change booking · Cancel booking · **Print receipt** · **Resend confirmation email** (KAYAK); Share trip · **See PDF itinerary** · **Add to calendar** · View visa requirements (Navan); Share trip / Cancel trip / accessibility services (AA).
4. Outstanding tasks as chips on the page: "Add details for check in" (Kiwi) — the record tells you what it still needs.

## Use when
Any travel record detail/edit page — the page IS the booking's home: identity, journey, actions, and gaps in one view.

## Avoid when
Inline list editing suffices for trivial records — don't force a page navigation for a one-field fix (offer inline status changes from the list too).

## Sad paths observed
- Unknown gate/terminal/bag: "--" placeholders with structure intact (AA).
- Cancel is present but visually subordinate, and leads to a rules disclosure (see cancel-with-rules-disclosure), never fires directly.

## Accessibility
Actions are real links/buttons in a labeled region; reference copyable as text.

## Default verdict for our stack
RECOMMENDED — the oracle's edit page is a bare form (G-series); wrapping it as record home (ref header + timeline + actions incl. resend/PDF/calendar) is the shape delegates' and ops' mental model expects.
