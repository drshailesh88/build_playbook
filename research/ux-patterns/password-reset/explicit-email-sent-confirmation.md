# Pattern: Explicit "email sent to <address>" confirmation with resend
**Surface:** password-reset · **Observed in:** Coda, Mural, Navan, Fibery, Uxcel, Patreon, Plane (refs: [Coda](https://mobbin.com/screens/cf09489f-9e86-4c96-9b4e-1f583054ee0a), [Mural](https://mobbin.com/screens/92bcc018-df92-48ab-ad2d-8c0d4baa86f4), [Navan](https://mobbin.com/screens/05400a03-0b22-4db2-9215-16a363adb4a9), [Fibery](https://mobbin.com/screens/71739693-7da1-4a2c-94e3-f5e12d166881), [Uxcel](https://mobbin.com/screens/f6522a85-9741-4a84-b517-9768648abb50), [Patreon flow](https://mobbin.com/flows/753b0154-51d5-497f-98dd-1b972655b834), [Plane](https://mobbin.com/screens/6222747b-7fbc-4846-af96-5fdf5cac85e9))

## Flow
1. User submits the reset request.
2. Confirmation card states plainly that the email WAS sent and names the exact address ("We just sent a link to jdoe@gmail.com" — Coda).
3. Spam-folder hint ("If you don't see the email after a minute, please check your spam folder" — Navan; "check your email (including spam)" — Fibery).
4. Resend affordance: button ("Resend password reset email" — Mural; "Resend email" — Navan), link ("Didn't receive an email? Send again" — Uxcel), or timed button ("Resend in 28 seconds" — Plane).
5. Optional escalation: "try another email address or contact us via Intercom" (Fibery), "contact support" (Patreon).

## Use when
- You accept confirming account existence (consumer products, or products where signup already reveals it).
- You want the lowest-friction recovery: naming the address catches typos immediately.

## Avoid when
- Account-enumeration resistance is a requirement — this pattern confirms the account exists (see `neutral-email-sent-confirmation.md`).

## Sad paths observed
- Plane: resend button disabled with countdown + success toast describing spam fallback — resend abuse handled inline.
- Uxcel: confirmation toast ("Your request has been sent") layered on the static state.
- Fibery: wrong-address path made explicit ("try another email address").

## Accessibility
- Toast confirmations (Uxcel, Plane) supplement, never replace, the static state — state survives toast dismissal.

## Default verdict for our stack
VIABLE — cleaner UX than hedged copy, but only adopt if the founder explicitly accepts enumeration disclosure; otherwise the neutral variant wins.
