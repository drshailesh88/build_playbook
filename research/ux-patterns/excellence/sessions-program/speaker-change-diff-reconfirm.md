# Pattern: Change diff + consequence + re-confirmation on every change

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Tripadvisor, Booking.com, Preply, Airbnb, Fresha (refs: [Tripadvisor change date](https://mobbin.com/screens/4dc8152c-3057-487f-8aff-561fa54de813), [Booking.com change dates](https://mobbin.com/screens/5337fb1f-6fc2-4b70-b923-c9f5a2dcf361), [Preply rescheduled](https://mobbin.com/screens/ee31c088-516f-4463-81d3-14afe0ca5a99), [Airbnb change request](https://mobbin.com/screens/4fcdc600-a842-4a54-8dbf-a66edcb65cde), [Fresha rescheduled](https://mobbin.com/screens/ea94be39-97ee-4763-b0d7-334bc1942a2a))

## Flow
1. The change screen shows old vs new side-by-side: "Current Date: April 29, 2025 / New Date: Apr 28, 2025" (Tripadvisor); "New guests: 2 guests / Original: 1 guest" (Airbnb).
2. Consequences are computed and stated, not implied: "This activity costs less on the new date you selected." + refund amount (Tripadvisor).
3. An escape is always present: secondary "Keep date".
4. Every committed change triggers a re-confirmation message: "An updated confirmation has been sent to {email}." (Booking.com); success page restates the NEW time + "Add to Google Calendar" (Preply).

## Use when
Notifying a committed party that the thing they committed to changed — the raw material for "your session moved" faculty notifications.

## Avoid when
High-frequency micro-edits (draft-stage tinkering) — diff-and-reconfirm spam trains recipients to ignore it; batch behind explicit publish instead.

## Sad paths observed
- Airbnb models the change as a stateful REQUEST: "You will be notified when your host accepts or declines this request", cancellable while pending.

## Accessibility
Diffs are labeled text pairs (Current/New), not color-only highlights.

## Microcopy worth stealing
"Current Date / New Date" · "Keep date" · "An updated confirmation has been sent to {email}." · "We've rescheduled your lesson."

## Default verdict for our stack
RECOMMENDED — no app showed a true multi-field diff (time AND room AND co-speaker), so the program-change notification composes this pattern first-principles: per-field Current/New block + consequence line + refreshed calendar attachment, batched per publish (matches the existing version-diff cascade).
