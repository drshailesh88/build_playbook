# Pattern: Tokened invite landing with in-place state swap

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Luma (refs: [accept-invitation flow](https://mobbin.com/flows/28703fea-9a9b-4a8c-aff3-f3946bd89f14))

## Flow
1. Emailed token link lands on the event page with an invite card: "You are Invited — We'd love to have you join us." Invitee's name + email pre-filled from the token; no login.
2. Paired actions of equal visibility: primary "Accept Invite", secondary "Decline". Host named with a "Contact the Host" link.
3. On accept the card swaps in place (same URL) to "You're In — A confirmation email has been sent to {email}", with countdown to the event, "Add to Calendar", and an inline undo: "No longer able to attend? Notify the host by canceling your registration."

## Use when
The invitee has no account and shouldn't need one — faculty/speaker confirm pages, guest RSVPs. The page doubles as the durable status surface (revisit the same link, see your current state).

## Avoid when
Acceptance carries legal/contractual weight (responsibility agreements) — pair with the attestation-confirm pattern instead of a one-click accept.

## Sad paths observed
- Undo is offered proactively inside the success state, as a calm text link — not a destructive button.
- Decline is one click, equal in visibility to accept (captures the negative signal instead of ghosting).

## Accessibility
Single-column card; state swap keeps URL stable so refresh/back never loses the invitee.

## Microcopy worth stealing
"You are Invited" · "You're In" · "A confirmation email has been sent to {email}." · "No longer able to attend? Notify the host by canceling your registration."

## Default verdict for our stack
RECOMMENDED — this is exactly the existing `/e/[eventSlug]/confirm/[token]` page done right: in-place accept/decline → confirmed state with calendar link + undo, page = status surface for invite FSM (sent→opened→accepted/declined/expired).
