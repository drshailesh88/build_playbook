# Pattern: On-behalf-of mode (persistent acting-as banner)
**Surface:** travel · **Observed in:** KAYAK for Business (refs: https://mobbin.com/flows/c90ce0c5-2eb0-4c3d-91ff-d7695b190c71, https://mobbin.com/flows/5da98a69-4aad-4be8-9f03-4e397efcb90a), TravelPerk ("Add a traveler" on booking home), Navan ("Guest travel" nav item)

## Flow
1. Explicit mode switch: "Book for yourself / Book for traveler" toggle; picking a traveler enters the mode.
2. While active, EVERY screen carries a persistent banner: "You are searching on behalf of John Smith" + "Exit mode" button; the account chip also flips ("Booking for John").
3. All artifacts created in the mode attach to the traveler, not the operator; cart panel restates "You are viewing John Smith's cart".
4. Navan separates "Guest travel" (non-employee) from employee booking as a distinct entry point.

## Use when
Admins/ops create or edit records that belong to another person — exactly the conference-ops situation where one coordinator enters 40 delegates' flights. Whenever acting-as state exists, it must be visible on every screen.

## Avoid when
The system has no self-serve path at all (then everything is implicitly on-behalf and the banner is noise) — though the moment delegates can self-view, attribution matters again.

## Sad paths observed
- Exit is one click from anywhere ("Exit mode") — no buried escape.
- Mode never persists silently across sessions (re-entered deliberately).

## Accessibility
Banner is a landmark region announced on page change; mode state also in the account chip text.

## Default verdict for our stack
VIABLE — the oracle's travel form already picks a person per record (G1–G2), which is lightweight on-behalf; the persistent-banner version becomes RECOMMENDED if a delegate-facing self-view ships (ops "viewing as delegate" needs the same banner).
