# Pattern: Dedicated forgot-password request form
**Surface:** password-reset · **Observed in:** Mixpanel, Strut, Patreon, TheyDo, Cal.com, Campsite, n8n, Plane (refs: [Mixpanel](https://mobbin.com/screens/56433c70-f37f-4a7a-9fd3-b16be857ff7d), [Strut](https://mobbin.com/screens/b6cab4d0-4aff-406f-bfae-b7ad9041da18), [Patreon](https://mobbin.com/screens/39941545-f6b4-4fee-93a6-e932ae09f318), [TheyDo](https://mobbin.com/screens/3be93afa-a7db-485c-bad4-d76938caf27e), [Cal.com](https://mobbin.com/screens/b874e858-788a-48b4-a814-cec35bdee8f4), [Campsite](https://mobbin.com/screens/a7c21fd3-5f0d-4984-9bc5-c12aff0c9446), [n8n](https://mobbin.com/screens/23d4c773-0c39-4613-9392-d3528f226100), [Plane](https://mobbin.com/screens/6222747b-7fbc-4846-af96-5fdf5cac85e9))

## Flow
1. User clicks "Forgot password?" on the login form.
2. Standalone page: heading ("Forgot password?" / "Trouble signing in?" — Patreon), one sentence of instruction, single email field (often prefilled from the login attempt — Patreon, n8n).
3. Single primary CTA ("Send reset email" / "Send instructions" / "Email me a recovery link").
4. Secondary link back to login ("Back to sign in" / "Remembered your password? Log in" — TheyDo).

## Use when
- Password auth exists at all. This is table stakes; every password app observed uses a dedicated page rather than a modal.
- You want to prefill the email captured on the login screen to cut a step.

## Avoid when
- Auth is passwordless-only (magic link / OTP) — there is no password to reset (see `passwordless-recovery.md`).
- Inside a settings "change password" flow for a logged-in user — that is a different surface (Notion/Rocket Money handle it in account settings).

## Sad paths observed
- Mixpanel mounts reCAPTCHA on this form (badge bottom-right) — bot defense at the request step.
- Plane disables the submit and shows "Resend in 28 seconds" after sending — throttles repeat requests in place.

## Accessibility
- All observed forms are single-field with a visible label or large placeholder; logical tab order (field → submit → back link). Nothing notable announced beyond standard form semantics.

## Default verdict for our stack
RECOMMENDED — Better Auth's `requestPasswordReset` maps 1:1; standalone route keeps the login page clean and matches the Linear/Vercel minimal-card aesthetic.
