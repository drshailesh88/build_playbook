# Pattern: Badge pickup logistics on the credential surface

**Surface:** check-in-qr / badge desk · **Observed in:** WWDC (Apple Developer) (refs: https://mobbin.com/screens/87dc057a-e5e3-499c-8086-acf6d88ad754)

## Flow
1. A "Check-in" section on the venue/event surface answers the four desk questions before arrival: WHERE ("McEnery Convention Center"), WHEN (per-day pickup hours, earliest day called out), WHAT TO BRING ("valid government-issued photo ID"), and THE RULES ("Wear your badge at all times… **We don't re-issue badges**; do not share it").
2. The digital badge itself is wallet-addable (Add to Apple Wallet) — pickup logistics and the credential live on one screen.
3. Notifications opt-in sits adjacent ("Receive updates about schedule changes…").

## Use when
Conferences with physical badge/lanyard handout — the badge desk queue is mostly people who didn't know the hours, the ID rule, or which door.

## Avoid when
Fully digital admission (QR-only events) — don't invent a badge desk; fold any pickup info into the ticket view instead.

## Sad paths observed
- Lost badge: policy stated up front ("we don't re-issue") — expectation set before the sad path happens.

## Accessibility
Hours are structured text (day–range lines), not an image; keep them parseable.

## Default verdict for our stack
VIABLE — medical conferences hand out physical badges; legacy has nothing connecting the delegate's QR/credential to desk logistics. Cheap content surface, but it belongs to whichever module owns the attendee event page — flag for the founder to place.
