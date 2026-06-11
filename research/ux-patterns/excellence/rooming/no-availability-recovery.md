# Pattern: No-availability states that never dead-end (cause + live controls + next action)
**Surface:** rooming · **Observed in:** SIX, Shangri-La Circle, Marriott, IHG, Vrbo, Hopper, Lyft, Klook
(refs: https://mobbin.com/screens/44a50144-a889-475e-8284-2a5e02944f25 , https://mobbin.com/screens/c3fa2b2c-7a34-48a9-b53d-ad3843788b19 , https://mobbin.com/screens/9ed3acc2-a741-41b5-a9c1-a99c031e70ca , https://mobbin.com/screens/fe4be35c-fb32-4c18-b9ab-8e4db272b144 ; raw: `_raw/by-app.md` §A20, `_raw/by-flow.md` §F4)

## Flow
1. Keep the page intact; replace only the CTA with a labeled disabled state: "⚡ ROOM NOT AVAILABLE" while dates stay editable in place (SIX).
2. Name the cause at the right level: hotel-level ("no rooms available for the dates you selected"), rate-level ("The offer you selected is not available for the dates you selected"), engine failure ("…or we're having some technical issues. Check back in a bit."), shortfall ("You need more points to book this room for your length of stay.").
3. Offer the concrete next action: other dates ("Please try our other dates"), other inventory ("Change car"), or a human ("Email Us / Call Us").
4. Failed transactional actions emit a quotable reference: "…your transaction was declined… Please reach out to customer support. [4870290793]" (Klook).

## Use when
Block exhausted for requested nights/room type; delegate change request can't be satisfied; quote/availability check fails.

## Avoid when
Never — every zero-result state needs cause + next action.

## Sad paths observed
This card is the sad-path family itself: hotel-level, rate-level, points-shortfall, quote-failure, and sold-out-with-alternative variants all observed.

## Accessibility
Disabled CTA carries the reason as its label, not a generic "Continue" that errors later.

## Default verdict for our stack
RECOMMENDED — block-full states should name the constraint ("Hilton Twin block full for Oct 12–14") and offer the next hotel/room type; every failed ops action emits a reference ID for the support trail.
