# Pattern: Blocking "we sent you a link" wall
**Surface:** email-verification · **Observed in:** PlanetScale, Discord, Clay, Coinbase, Wise, Revolut Business (refs: [PlanetScale](https://mobbin.com/screens/244fa06c-4e83-4efc-8a77-4fa87e7cc2ef), [Discord](https://mobbin.com/screens/750cce9a-817a-473b-aab0-cb71c9e093b9), [Clay](https://mobbin.com/screens/42d357a8-deb9-4c8e-b2f8-e168b8711e10), [Coinbase](https://mobbin.com/screens/399f4059-615f-4b2d-9413-6a1d012f9838), [Wise](https://mobbin.com/screens/efb34824-14cc-45b0-a065-44f1976c8a35), [Revolut Business](https://mobbin.com/screens/a36d8a26-7ff5-4f42-ab59-1c9f17675c29))

## Flow
1. Post-signup (or post-login while unverified) the entire app is replaced by a card: "Please verify your email — We just sent an email to <email>. Click the link in the email to verify your account" (PlanetScale).
2. Standard affordance set, all observed: **Resend** ("Resend email" — PlanetScale; "Resend my verification email!" — Discord; timed "Resend email 0:59" — Wise; "Resend email in 00:13" — Revolut), **change/update email** (PlanetScale "Update email", Discord "Click here to change your email"), **sign out** (PlanetScale, Clay, Coinbase).
3. Helper sad-path copy: "Email didn't arrive?" (Coinbase), "The email can take up to 1 minute to arrive" (Wise), contact us (Clay).
4. Clicking the emailed link verifies and drops the user into the product (see `verified-success-landing.md`).

## Use when
- Verification must be hard-required before ANY product access (compliance, abuse-prone free tier, financial context).
- The wall must keep all three escape hatches (resend / change email / sign out) — every quality implementation has them; Discord adds "Think you're seeing this by mistake? Support | Log Out".

## Avoid when
- Activation speed matters more than verified email — a hard wall is the highest-drop-off option; prefer the soft gate for exploratory products.
- Cross-browser link opening breaks your session model (folk's same-browser error) and you haven't added a code fallback.

## Sad paths observed
- PlanetScale resend throttle toast: "Email was just sent. Please check before trying again." — resend is rate-limited with explicit feedback.
- Wise/Revolut: cooldown timers ON the resend button prevent the throttle error entirely.
- Wrong-address recovery handled by "Update email" without restarting signup (PlanetScale, Discord).

## Accessibility
- Single-card pages, one primary action; timers update text in place (needs `aria-live="polite"` in our build to announce when resend unlocks).

## Default verdict for our stack
VIABLE — correct skeleton if we hard-gate, but for our stack the OTP code gate is stronger; if link-based, must include resend-cooldown + update-email + sign-out trio.
