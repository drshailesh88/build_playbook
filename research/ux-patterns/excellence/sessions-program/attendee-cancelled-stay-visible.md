# Pattern: Cancelled/postponed sessions stay visible, visually demoted

**Surface:** sessions-program / attendee-program · **Observed in:** Uber, GetYourGuide, Fixtured (refs: [Uber cancelled reservation](https://mobbin.com/screens/92266535-6b41-4e75-a079-d856bc00b57b), [GetYourGuide cancelled](https://mobbin.com/screens/7b85ebf5-62ed-4a66-9ea9-37ce25ea7047), [Fixtured postponed card](https://mobbin.com/screens/87d6e07a-eb58-4156-8b5f-3fcbeeab48fb))

## Flow
1. The cancelled item REMAINS in "My Calendar / Upcoming" where the user expects it, with a "Canceled" pill on the thumbnail (Uber) — never silently deleted from a personal schedule.
2. Consequence stated explicitly in a sheet: "Your reservation for {name} has been cancelled. Please allow 5-7 days to process your refund in the amount of $38.00."
3. Postponed renders as a GREYED card with DASHED border labeled "Postponed", kept in timeline position (Fixtured) — three redundant cues (border, color, label).
4. Locked end-state copy: "This booking can no longer be canceled or rescheduled." (GetYourGuide).

## Use when
Anything a user saved/committed to gets cancelled or moved — their mental model includes it; vanishing items read as data loss.

## Avoid when
Draft-stage items never shown to the user — demote-don't-delete applies to COMMITTED visibility only.

## Sad paths observed
This card IS the sad path: cancellation display, postponement, and the no-longer-changeable lock state.

## Accessibility
Badge + sheet announcement (state is told, not just styled); dashed+grey+label = not color-only.

## Microcopy worth stealing
"Canceled" pill · "Postponed" on a dashed ghost card · "This booking can no longer be canceled or rescheduled."

## Default verdict for our stack
RECOMMENDED — the module already soft-cancels sessions and filters them from the public page; in MY-SCHEDULE context the rule inverts: a cancelled session I saved must stay visible with a "Cancelled" badge (else attendees show up to ghost sessions).
