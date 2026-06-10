# Pattern: Nominate-and-accept ownership transfer (consent + time window)
**Surface:** transfer-ownership · **Observed in:** Canva (refs: [Canva](https://mobbin.com/screens/6d9a7445-0b03-4f9d-8157-32da646d98ed))

## Flow
1. Owner picks a member to nominate; a two-step modal (step indicator "1 2") opens: "Sure you want to change owner?"
2. Left pane shows the nominee card and the terms: "You're about to ask John Smith to replace you as the owner of Sam Lee's team Team. They'll have 30 days to respond and you'll remain the owner until they accept."
3. Right pane "Here's how it works" enumerates: (1) Nominate someone to replace you, (2) Wait for them to accept — they take on new administrator responsibilities, (3) Once they accept, your role switches from owner to administrator, with the warning "You won't be able to undo this action after the new owner accepts."
4. CTA: "Nominate this member". Ownership is unchanged until acceptance.

## Use when
Ownership carries obligations the recipient must consent to (billing, legal/compliance), or transfers happen between people who may not be in the same room.

## Avoid when
The transfer must complete now (offboarding today, last-admin unblocking) — a 30-day pending window leaves the org in limbo; also adds a pending-state machine (nominated/accepted/expired/withdrawn) you must build and surface.

## Sad paths observed
The non-response case is pre-handled by design: nominator "remains the owner until they accept" with a 30-day expiry; irreversibility after acceptance is warned inline.

## Accessibility
Numbered "how it works" steps give the full state machine in plain language before commit; back arrow on the modal title allows revisiting step 1.

## Default verdict for our stack
VIABLE — correct long-term answer if org ownership ever carries billing liability, but overkill for v1; ship immediate transfer first and revisit when payments land.
