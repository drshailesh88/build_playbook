# Pattern: Soft gate — persistent verify-email banner over a working app
**Surface:** email-verification · **Observed in:** Squarespace, Podia, Epidemic Sound, Airbnb (refs: [Squarespace](https://mobbin.com/screens/ed3cd289-8713-4288-8ca3-bf11c72df70a), [Podia](https://mobbin.com/screens/5cc5f542-8e94-4704-9384-550f7f93d6b3), [Epidemic Sound flow](https://mobbin.com/flows/39d03687-ce7d-4880-8df6-b3178d590d66), [Airbnb](https://mobbin.com/screens/92057989-028b-4d2a-8808-cbd520ace128))

## Flow
1. User lands in the full product unverified; a banner pinned at top (Squarespace, Podia) or bottom (Epidemic Sound) persists across pages.
2. Copy + actions in the banner itself: "Verify your email address — Send a verification email to confirm" + SEND VERIFICATION + DISMISS (Squarespace); "Please confirm that <email> is your email address. Change email • Resend confirmation" (Podia); "Please verify your email to get the most out of Epidemic Sound" + Send verification email (Epidemic Sound).
3. Sending triggers a toast ("Confirmation email sent to <email>" — Podia).
4. On link click, banner disappears and a confirmation toast/banner shows ("Email address confirmed" — Epidemic Sound).
5. Airbnb variant: the nudge lives in the notifications panel instead of a banner, with request-new-email and change-email links.

## Use when
- Activation-first products: let users explore and build before forcing inbox round-trip.
- Banner must carry its own actions (send/resend, change email) — never just a warning.

## Avoid when
- Verified email is a security precondition (tenant invites, billing, outbound email sending) — soft nudges get ignored; use a hard or capability gate.
- Banner stacking: Dialpad shows two stacked warning banners ([ref](https://mobbin.com/screens/675f52b6-1824-4c86-bb49-b7606781873a)) — avoid competing persistent banners.

## Sad paths observed
- Squarespace's DISMISS makes the nudge recoverable-but-ignorable — pair dismissal with a settings entry point or it becomes permanent unverified state.
- Podia keeps "Change email" in the banner — typo recovery without digging into settings.

## Accessibility
- Banner is first element in DOM/tab order (Squarespace) — gets seen by screen readers immediately; toasts supplement, never carry, state.

## Default verdict for our stack
VIABLE — good for trial/sandbox tenants, but our multi-tenant invite + notification flows need verified email; use only if paired with capability gates on sensitive actions.
