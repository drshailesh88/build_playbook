# Pattern: Event roster "At a Glance" (count vs capacity, status-segmented, inline approve/decline)

**Surface:** people-registration / event roster & registration admin · **Observed in:** Luma (refs: https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d , https://mobbin.com/flows/e688bd8e-2edf-4fc4-9984-f8795837cc85)

## Flow
1. The event's Guests tab opens with "At a Glance": big count against capacity ("1 guest · cap 1,000") over a progress bar, with a status-breakdown line of colored dots beneath ("1 Going · 1 Invited", "1 Pending Approval · 1 Invited").
2. Action cards under the glance: Invite Guests / Check In Guests / Guest List — the Guest List card wears its visibility state as a sublabel ("Shown to guests" / "Hidden").
3. Roster rows: avatar, name, email (muted), ticket/category chip ("Standard"), status chip (Going green / Invited blue / Pending Approval amber), relative registration time; toolbar = search + "All Guests ▾" status filter + sort by Register Time.
4. Pending rows expose inline "✓ Approve / ✗ Decline" on hover — moderation without a detail-page detour; green toast "Guest approved." flips the chip in place.
5. Download icon on the roster header exports the guest list.

## Use when
The roster is a working queue (approvals, capacity watching, day-of ops), not just a report — true for paid/curated medical conferences.

## Avoid when
Registrations are auto-approved and uncapped; then the glance reduces to a count and the approve/decline affordances should not render at all.

## Sad paths observed
- Empty roster: "No Guests Yet — Share the event or invite people to get started!" (actionable, not blank).
- Capacity context is ambient (bar) before it is blocking; "Sold Out"/"Near Capacity" surfaces on event cards elsewhere in Luma before users hit walls.

## Accessibility
Status is text-in-chip, never color-only; approve/decline are real buttons, not hover-only icons (keyboard reachable).

## Default verdict for our stack
RECOMMENDED — GEM's event-people page is a flat table; the rebuild's registration-admin roster should open with the glance bar (counts by registration status against event capacity) and inline status transitions (the `updateRegistrationStatus` action already exists).
