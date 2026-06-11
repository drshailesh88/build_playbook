# Pattern: Check-in as a first-class event action — zero-hunt door mode

**Surface:** check-in-qr / navigation · **Observed in:** Luma (ios + web) (refs: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f, https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4, https://mobbin.com/screens/77625847-95c6-46b2-b900-1b8647c84ed4)

## Flow
1. iOS event page: "Check In" sits in the primary action chip row (Invite · **Check In** · Blast · More) — same rank as inviting.
2. Web events list: today's LIVE event card grows a **Check In** button right in the list — on event day, the door is the default job.
3. Web Guests tab: "Check In Guests" is one of three action cards (Invite Guests / Check In Guests / Guest List).
4. The check-in surface itself cross-links: "Guests" button on the scanner, "Manage Event Page ↗" under it, "Scan" button on the list view — list ↔ scanner are two faces of one mode.

## Use when
Always. Door staff at 7:55 AM with a queue forming should reach scan mode in ≤2 taps from launch, with zero admin-IA knowledge.

## Avoid when
Don't surface it to roles without check-in permission, and don't promote it weeks before event day (Luma promotes contextually — LIVE events only on web).

## Sad paths observed
- None observed; the implied one — staffer's role lacks write access — must hide/disable the entry point, not fail at scan time.

## Accessibility
Time-contextual promotion must not reorder tab/landmark structure unpredictably; the button appears within the same labeled card.

## Default verdict for our stack
RECOMMENDED — legacy buries check-in at /events/[eventId]/qr inside the event workspace (census); the deltas are event-day contextual promotion and the role-aware action row.
