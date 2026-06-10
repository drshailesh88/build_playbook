# Pattern: Expired link bounces to request form with inline error
**Surface:** password-reset · **Observed in:** Podia (refs: [Podia](https://mobbin.com/screens/200cca5a-3725-4ad6-93bd-b69d82be9f5b))

## Flow
1. User opens an expired reset link.
2. App redirects to the reset-request form (not a dead-end error page).
3. Inline alert above the form: "Your reset link has expired. Please try again."
4. Email field is prefilled with the address from the expired token.
5. One click on "Send reset email" issues a fresh link.

## Use when
- The expired token still identifies the email — recovery becomes one click instead of error page → back to login → forgot password → retype email.

## Avoid when
- Token is invalid/tampered rather than merely expired (you can't trust the email inside it) — fall back to the dedicated error page.
- Treating the reset link as a session-sensitive secret where echoing the email back is unacceptable.

## Sad paths observed
- This is itself sad-path handling; only Podia observed doing the full bounce-with-prefill. No secondary failure states captured.

## Accessibility
- Error rendered as a visible alert directly above the field it relates to; needs `role="alert"` in our build.

## Default verdict for our stack
RECOMMENDED — best-in-class expired handling at near-zero extra cost; combine with `expired-link-dedicated-error.md` as the fallback for unparseable tokens.
