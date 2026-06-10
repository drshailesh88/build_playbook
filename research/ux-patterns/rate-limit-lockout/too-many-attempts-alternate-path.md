# Pattern: "Too many attempts" with an alternate way in
**Surface:** rate-limit-lockout · **Observed in:** Surfshark, Uber (refs: [Surfshark](https://mobbin.com/screens/a216f75b-1823-4834-820d-c15b5a3e1685), [Uber](https://mobbin.com/screens/aeb08f69-9115-4a9b-8358-c1582a4f182d), [Uber modal](https://mobbin.com/screens/52bfdf6d-753f-43f5-bde1-d858179783db))

## Flow
1. After N failed logins, error surfaces both inline (red text under the password field) AND as a modal: "There have been too many attempts to log in." (Surfshark).
2. Crucially, the message offers a different path rather than a dead end: "Please try to resolve the challenge or log in with code" with a "Login with code" button beside "Ok" (Surfshark).
3. Uber variant on blocked identifier: "The phone number you entered is blocked. Choose another option to continue." — inline red error plus the remaining auth options (Google, Apple, QR code) directly below.
4. The login form's alternative methods (SSO, email code) remain enabled while password attempts are locked.

## Use when
- Multiple auth methods exist — lockout on one credential should never lock out the account; route to OTP/SSO.
- You want lockout messaging that is actionable (what happened + what to do now), not just "try again later".

## Avoid when
- Password is the only method — then the alternate path must be password reset or support, stated explicitly.
- The "alternate path" would let an attacker bypass the throttle — alternates must carry their own rate limits.

## Sad paths observed
- This IS the sad path; Surfshark layers modal + inline error so the state survives modal dismissal. No cooldown duration was disclosed in either app (user not told how long the lock lasts) — observed weakness to improve on.

## Accessibility
- Surfshark's modal carries an alert icon + heading; inline error remains for screen-reader re-discovery after dismissal. Modal needs `role="alertdialog"` in our build.

## Default verdict for our stack
RECOMMENDED — render inline (not modal) at our quality bar: "Too many attempts. Try again in N minutes, or sign in with an emailed code / reset your password." Better Auth returns 429 + retry-after to drive the copy.
