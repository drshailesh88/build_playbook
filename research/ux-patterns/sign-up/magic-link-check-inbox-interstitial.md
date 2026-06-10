# Pattern: "Check your inbox" magic-link interstitial
**Surface:** sign-up · **Observed in:** Better Stack, Felt, Loops, Qatalog, Fey, Clay, Depop, Productboard (refs: [Better Stack](https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e), [Felt](https://mobbin.com/screens/67db25a6-d5a2-4382-9cf0-321ab7f32d48), [Loops](https://mobbin.com/screens/74845a20-3a31-4cab-b895-bb647f771421), [Qatalog](https://mobbin.com/screens/7c9f8135-29b9-4613-aada-ba572b5c4fcb), [Fey](https://mobbin.com/screens/225ce64d-ab72-4d1f-8d4f-a4aeeddf30eb), [Clay](https://mobbin.com/screens/424a3b7e-a12b-4ca8-b919-54c3d0b7bbc1), [Depop](https://mobbin.com/screens/d461052f-b041-457b-aaf1-7b65a82432fa), [Productboard](https://mobbin.com/flows/54bce0a9-613c-4770-85e0-92c09b001e90))

## Flow
1. After email submit, a dedicated full-screen state: headline "Check your inbox / Check your email", echoing the exact address sent to (bolded).
2. Deep-link buttons to webmail clients: "Open Gmail / Open Outlook / Open Superhuman" (Better Stack, Felt, Loops, Productboard).
3. Recovery row: spam-folder hint + "Send it again" / "Resend link" (Felt, Qatalog, Depop) and wrong-address escape "Wrong email? Please re-enter your address" (Better Stack) or "Back" (Loops, Fey).
4. Clicking the emailed link completes auth in a new tab; this screen is abandoned.

## Use when
- Magic link is a signup/sign-in channel — the interstitial is mandatory, not optional polish.
- You can deep-link major webmail clients to shave the inbox hunt.

## Avoid when
- Magic link is not offered (dead pattern without it).
- Desktop-app or kiosk contexts where the user's mail client is unknown/absent — prefer an OTP code field (Clay pairs both: "Enter code manually").

## Sad paths observed
- Wrong-email recovery link directly on the interstitial (Better Stack) — prevents a dead-end when users typo their address.
- Resend with implicit rate limiting (Qatalog "Send again" chip; Depop "Resend link").
- Productboard adds "If you meant to sign in using password or SSO, go to the Sign in page" — channel-confusion escape ([ref](https://mobbin.com/flows/54bce0a9-613c-4770-85e0-92c09b001e90)).

## Accessibility
- Single-purpose screen with one heading announces state change clearly.
- Email-client buttons are real links with text labels; spam-folder hint is plain text not tooltip.

## Default verdict for our stack
VIABLE — required companion only if we ship magic-link auth; if built, copy Better Stack's wrong-email + resend + spam-hint trio wholesale.
