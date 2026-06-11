# Pattern: Conflict disclosure split — hard conflicts vs "inconveniences", confirm-gated

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Clockwise (refs: [AI scheduling panel](https://mobbin.com/screens/671e0870-f520-4d92-bc16-8ee9b332bb3b), [conflict hand-off](https://mobbin.com/screens/d91d7384-97bf-415d-94e3-de3c3c57d4e6))

## Flow
1. Conflicts are disclosed in two severity tiers: "Sam has conflicts that I can't fix:" (hard — expandable list) vs "You have inconveniences:" (soft — costed chips like "1 hour of Focus Time lost").
2. The trade-off is priced in human terms, then gated: footer guarantees "Nothing will change until explicitly confirmed." with ✓ Confirm / Cancel.
3. The candidate placement renders on the grid as a solid block among ghosted alternatives — the proposal is visible in context before commit.
4. Escalation to humans: a copy-to-clipboard message enumerating the issues for the affected person ("There are a few issues with that time… Does that work?").

## Use when
Any placement that affects other people — assigning a speaker into a slot that collides with their other session vs merely back-to-back across the venue.

## Avoid when
Flattening both tiers into one warning list — burying hard blocks under soft costs is how double-bookings ship.

## Sad paths observed
- The unfixable-conflict state has its own language ("can't fix"); OOO ribbons and "Outside of working hours" per-person annotations.

## Accessibility
Tiers are labeled sections with text chips; confirmation is an explicit button.

## Microcopy worth stealing
"…conflicts that I can't fix:" · "You have inconveniences:" · "Nothing will change until explicitly confirmed."

## Default verdict for our stack
RECOMMENDED — the module already computes hall-overlap and double-booking warnings; the upgrade is the severity split (speaker double-booked = hard tier; tight turnaround between halls = inconvenience tier) with everything still non-blocking per the existing philosophy, plus an optional per-event hard-block toggle (old-app NEVER-ATTEMPTED #21).
