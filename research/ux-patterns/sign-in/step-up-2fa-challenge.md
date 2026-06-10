# Pattern: Step-up 2FA challenge after password
**Surface:** sign-in · **Observed in:** Stripe (refs: [SMS code](https://mobbin.com/screens/986ec6f2-e1fd-44a0-b8a2-bdd48a4f0089), [authenticator app](https://mobbin.com/screens/96617c73-605f-4d93-8d71-c020cf12dcf8), [reset-identity check](https://mobbin.com/screens/ab78ca83-67ce-43bf-912a-10250408ca75), [2FA enrollment](https://mobbin.com/screens/4a05abed-e696-47b6-a3d9-deefc07fa85b))

## Flow
1. After successful password entry, a dedicated challenge card: "We sent a text to your phone" with masked target ("your phone ending in 7379") or "Use an authenticator app".
2. Segmented 6-digit code input (3+3 groups); auto-submit/loading state in the continue button.
3. "Didn't receive a code? Resend (8)" with visible countdown; "Sign in another way" link to alternate factors.
4. Same challenge anatomy reused for sensitive operations: password reset asks "Confirm your identity" via authenticator code.

## Use when
- Accounts with payment/finance/PII access (our events platform handles attendee data — qualifies for admins).
- Offer at minimum as opt-in for tenant owners/admins.

## Avoid when
- Forcing on all users at launch of an unproven product — friction before value.
- SMS-only as the sole factor (SIM-swap risk); Stripe offers authenticator + SMS + fallbacks.

## Sad paths observed
- Resend rate-limited behind countdown ("Resend (8)").
- "Sign in another way" / "Authenticate another way" prevents lockout when one factor is unavailable ([ref](https://mobbin.com/screens/ab78ca83-67ce-43bf-912a-10250408ca75)).

## Accessibility
- Masked phone number communicates destination without leaking it; segmented inputs need paste support and single-label announcement (Stripe's auto-advancing groups observed).

## Default verdict for our stack
VIABLE — defer to post-launch; Better Auth twoFactor plugin covers TOTP, and Stripe's challenge anatomy (masked destination, resend countdown, alternate-factor link) is the template when we do.
