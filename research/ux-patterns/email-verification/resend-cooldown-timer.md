# Pattern: Resend button with visible cooldown countdown
**Surface:** email-verification · **Observed in:** Wise, Revolut Business, Databricks, Canva, Frame.io, Amazon, Plane (refs: [Wise](https://mobbin.com/screens/efb34824-14cc-45b0-a065-44f1976c8a35), [Revolut](https://mobbin.com/screens/a36d8a26-7ff5-4f42-ab59-1c9f17675c29), [Databricks](https://mobbin.com/screens/d2bf25c5-982d-4a90-ac7e-1397d6e833d6), [Canva](https://mobbin.com/screens/144d9924-b5ea-40f9-92ae-66d45621fe05), [Frame.io](https://mobbin.com/screens/537ca3c6-d5dd-4945-a785-0449998c2e40), [Amazon](https://mobbin.com/screens/a392358c-1227-4197-a16c-e4daf603e958), [Plane](https://mobbin.com/screens/6222747b-7fbc-4846-af96-5fdf5cac85e9))

## Flow
1. After the first send, the resend control is disabled and shows a live countdown: "Resend email 0:59" (Wise), "Resend email in 00:13" (Revolut), "Resend code in 29" (Databricks), "Didn't get the code? Resend in 29 seconds" (Canva), "You can resend the code in 0:54" (Frame.io), "Resend in 28 seconds" (Plane).
2. Amazon variant: link stays visible but muted, with an info note "Please wait 53 seconds before requesting another code."
3. Timer hits zero → control becomes an active "Resend" button.
4. Each resend restarts the cooldown (observed windows: ~15s to ~60s).

## Use when
- Any email/OTP send surface — verification, reset, login codes. Prevents the resend-spam → rate-limit-error loop entirely by making the constraint visible before violation.

## Avoid when
- Never avoid entirely; only the duration tunes. A pure server-side throttle with error-after-click (PlanetScale's "Email was just sent" toast) is the inferior fallback, not an alternative.

## Sad paths observed
- This pattern preempts the sad path; Binance shows what happens without it — "Too many requests. Please try again later.(015002)" inline error after the fact ([ref](https://mobbin.com/screens/649d8c32-0f98-4912-800e-90f3f962b170)).
- Amazon pairs the wait notice with an alternate path: "if you can't receive the code... try a different way."

## Accessibility
- Countdown updates once per second — must NOT be `aria-live` per-tick in our build; announce only disabled state and re-enable. Disabled button must remain visible (all observed apps keep it rendered, never hidden).

## Default verdict for our stack
RECOMMENDED — non-negotiable companion to any send/resend action; mirror the server's Better Auth rate-limit window in the client timer (30–60s).
