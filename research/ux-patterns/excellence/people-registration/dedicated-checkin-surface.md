# Pattern: Dedicated check-in surface (search-first, counters, honest early check-in)

**Surface:** people-registration / event roster day-of ops — PRIMARY HOME: check-in/QR module (recorded here because Luma fuses it with the guest list) · **Observed in:** Luma (ref: https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198)

## Flow
1. A stripped page separate from admin chrome: event name + countdown, session selector, one big "Search for a Guest…" box, "Scan" (QR) top-right — built for a volunteer at a door, not an admin at a desk.
2. Guest row: avatar, name, email, status chips, primary "Check In" button that flips to "Update" after; toast "✓ Checked in guest."
3. Running counters pinned: "0 Guests Approved · 0 Guests Checked In".
4. Early check-in is allowed and labeled honestly: "✓ Checked In in 13 hours" (13h before start) rather than blocked or silently timestamped.
5. Pending-approval guests remain visible with their amber chip — the door sees the same truth as the admin.

## Use when
Physical events with door staff; check-in volume makes the full admin table too heavy.

## Avoid when
Virtual events or when check-in IS attendance capture handled by QR self-scan only.

## Sad paths observed
- Un-approved guest at the door: status chip shows Pending Approval; check-in is still possible (host's call) — policy is visible, not hidden.
- Mobile apps offered for the door context (iOS/Android promos).

## Accessibility
Search-first layout works with screen readers; check-in state change is announced via toast + button label flip.

## Default verdict for our stack
VIABLE here / RECOMMENDED for the check-in module — cross-reference this card when that module's harvest runs; from the people side, the requirement is that roster search and status chips be fast enough to power it.
