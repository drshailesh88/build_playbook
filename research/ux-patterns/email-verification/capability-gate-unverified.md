# Pattern: Capability gate — explore freely, sensitive actions blocked until verified
**Surface:** email-verification · **Observed in:** PayPal, Brilliant (refs: [PayPal](https://mobbin.com/screens/14c8559c-723a-4e4e-87ec-a19ee816c28e), [PayPal settings](https://mobbin.com/screens/61cc199f-ed5f-4f7d-8921-592debc6aaa8), [Brilliant flow](https://mobbin.com/flows/f4f26525-7f1c-4187-9bf1-94610abb100b))

## Flow
1. Unverified user gets full read/explore access; specific capabilities are blocked.
2. The block is named in a persistent banner tied to the capability, not generic nagging: "To start accepting payments, add more profile info — You're free to explore your account, but we need to confirm it's really you" (PayPal).
3. Settings reflect the state: email listed as "Primary, **Unconfirmed**" (PayPal); "send verification" action per address (Brilliant).
4. Brilliant's rationale copy: "For your safety and privacy, some features on Brilliant require email verification to prove that the email address provided upon signup belongs to you."
5. Verifying flips status to "verified" with a confirmation banner ("Thanks for confirming <email> as yours, Alex" — Brilliant).

## Use when
- Verification protects specific actions (sending invites/emails, payments, going live) rather than all access — block exactly those, explain why at the point of block.
- B2B onboarding where exploration drives activation but outbound actions carry abuse risk.

## Avoid when
- Almost everything in the product is sensitive — the gate list converges to a hard wall; use the wall instead.
- You can't reliably enforce the gate server-side per action (client-only gating is a security hole).

## Sad paths observed
- PayPal pairs the banner with account-alert cards listing exactly which documents/confirmations are missing — the "what's blocked and why" is enumerated, not vague.

## Accessibility
- Capability-tied banners sit adjacent to the blocked feature's UI; status words ("Unconfirmed"/"verified") are text, not color-only.

## Default verdict for our stack
RECOMMENDED (as companion) — for Event State: unverified users can explore their workspace, but inviting members, publishing events, and sending attendee email require verification; enforce in Better Auth middleware per-route.
