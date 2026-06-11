# Pattern: Decline/cancel with consequence honesty, optional reason, and audit trail

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Navan, Calendly, Cal.com (refs: [Navan decline flow](https://mobbin.com/flows/4db6e38d-eb3d-4821-a99c-b21253c9a03d), [Calendly cancel flow](https://mobbin.com/flows/b585ee1f-1669-49b5-a8d2-99c3d1f63e63), [Cal.com bookings flow](https://mobbin.com/flows/5dca9c69-b27c-4b13-bfca-088efc9d7781))

## Flow
1. Decline confirm states the consequence before commit: "Decline {event}? — Your organizer will be informed that you can't join this event." (Navan)
2. Cancel modal restates the object, forces awareness of notification ("A cancellation email will also go out to the invitee."), and offers a free-text reason box. Buttons are explicit verbs: "No, don't cancel" / "Yes, cancel" (Calendly).
3. Afterwards the row is NOT deleted: strikethrough title with inline annotation "Canceled by {name}: '{reason}'" — an audit trail in place (Calendly).
4. Confirmation toast repeats the consequence: "The organizer will be informed that you can't join {event}." (Navan)

## Use when
Any decline/cancel in a two-party commitment — faculty declining an invite, coordinator cancelling a session with assigned faculty.

## Avoid when
Don't make the reason REQUIRED — Cal.com keeps it "(Optional)"; forced reasons produce garbage text and abandonment.

## Sad paths observed
- This pattern IS the sad path, designed: notify + reason + history instead of silent row deletion.
- Navan surfaces invite expiry to the invitee proactively: "Expires in 104 days."

## Accessibility
Strikethrough paired with red "Canceled by…" text — never strikethrough alone.

## Microcopy worth stealing
"Your organizer will be informed that you can't join this event." · "A cancellation email will also go out to the invitee." · "No, don't cancel" / "Yes, cancel" · "Canceled by {name}: '{reason}'"

## Default verdict for our stack
RECOMMENDED — decline-with-reason feeds the coordinator's tracker ("declined: schedule conflict"), and cancelled sessions/invites should render as annotated history, matching the module's existing soft-cancel philosophy.
