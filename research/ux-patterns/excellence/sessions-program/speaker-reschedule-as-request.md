# Pattern: Reschedule-as-request (change is a pending object, not fiat)

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Cal.com, Airbnb (refs: [Cal.com request-reschedule flow](https://mobbin.com/flows/5dca9c69-b27c-4b13-bfca-088efc9d7781), [Airbnb change request](https://mobbin.com/screens/4fcdc600-a842-4a54-8dbf-a66edcb65cde))

## Flow
1. "Request reschedule" modal states the mechanics honestly: "This will cancel the scheduled meeting, notify the scheduler and ask them to pick a new time." + "Reason for reschedule request (Optional)".
2. Toast "Reschedule request sent"; the affected booking gets a "Rescheduled" badge — the list never lies about state.
3. Airbnb variant: the change request is itself a stateful object — counterparty accepts/declines, requester can "Cancel request" while pending.

## Use when
The other party's consent genuinely matters — e.g. asking a speaker whether they can move to a different day, or a speaker requesting a slot change from the coordinator.

## Avoid when
The organizer is authoritative over the schedule (normal conference program moves) — then change-diff + re-confirmation is correct, not a consent round-trip.

## Sad paths observed
- Cal.com's "Unconfirmed" tab models bookings awaiting confirmation as a first-class bucket.

## Accessibility
Badges are words ("Rescheduled"); pending requests visibly distinct from confirmed state.

## Microcopy worth stealing
"This will cancel the scheduled meeting, notify the scheduler and ask them to pick a new time." · "Reason for reschedule request (Optional)" · "Cancel request"

## Default verdict for our stack
VIABLE (narrow) — useful as the speaker-initiated "I can't make this slot" request from the portal; coordinator-initiated program moves should use change-diff + reconfirm instead.
