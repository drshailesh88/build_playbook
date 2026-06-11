# Pattern: Action-ownership status language ("Need to sign" vs "Waiting for {name}")

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** DocuSign, 1Password, Rise (refs: [DocuSign agreements flow](https://mobbin.com/flows/d0bd4d11-7924-4e3d-8d28-ede69571628a), [1Password manage invites](https://mobbin.com/screens/abe40bad-1db6-416a-9412-ef8ce5f85318), [Rise responses flow](https://mobbin.com/flows/7a7718c7-1bfa-4da2-b427-ef25bc1cfafb))

## Flow
1. Every pending item's status states WHOSE move it is, not just a state name: "Need to sign" (your move — primary "Sign" button on the row) vs "Waiting for Alex Smith" (their move — "Resend" button on the row).
2. Progress bar per multi-party item; last-change timestamp.
3. 1Password variant: invite status "Waiting on user". Rise variant: per-participant "Accepted & organizer" / "Waiting for response".

## Use when
Any two-sided commitment list — coordinator's faculty-invite tracker AND a speaker's own list of responsibilities. The same data renders with opposite ownership labels per viewer.

## Avoid when
Single-actor lists (plain task lists) — ownership framing adds nothing when everything is "your move".

## Sad paths observed
- The waiting-on-them state pairs with a nudge affordance (Resend) instead of a dead label.

## Accessibility
Status is words, not color-coded dots alone; action button text matches the status verb.

## Microcopy worth stealing
"Need to sign" / "Waiting for {name}" · "Waiting on user" · "Waiting for response"

## Default verdict for our stack
RECOMMENDED — the spine of both halves of the faculty-invite tracker: coordinator sees "Waiting on Dr. Mehta · Resend", faculty portal sees "Needs your response: 2 of 5 responsibilities". Maps directly onto the invite FSM states.
