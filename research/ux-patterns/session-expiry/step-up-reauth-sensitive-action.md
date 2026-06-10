# Pattern: Step-up re-authentication for sensitive actions (session still valid)
**Surface:** session-expiry · **Observed in:** GitBook, Figma, Notion (refs: [GitBook reauthenticate](https://mobbin.com/screens/13611ef0-312c-4c95-bda5-bc9998b2a54e), [Figma re-enter password](https://mobbin.com/screens/08104ebb-3da8-4d16-be9a-d09f37a92e97), [Notion password gate](https://mobbin.com/screens/27c11172-8341-4fd1-8060-a568593c659f))

## Flow
1. User triggers a sensitive change (update password, change email, enable 2FA) inside a live session.
2. A re-auth dialog interrupts only that action: GitBook "Reauthenticate — You need to reauthenticate yourself to perform this sensitive action" offering TWO proof methods: Password or Email Link; Figma "For security purposes, please re-enter your password below" with "Forgot password?" link; Notion asks for the password before email change.
3. On success the original action proceeds; the session itself was never invalidated; Cancel abandons only the sensitive action.

## Use when
- Long-lived sessions + high-impact actions (credential changes, billing, deletions, tenant transfer). This is the complement that makes long sessions safe — relevant to expiry policy because it removes the pressure to make ALL sessions short.

## Avoid when
- Every minor setting — re-auth fatigue trains users to type passwords reflexively; OAuth-only users dead-end unless an alternative proof (email link, like GitBook) is offered.

## Sad paths observed
- GitBook's dual method (Password OR Email Link) covers the no-password/forgot-password case in the gate itself; Figma includes "Forgot password?" inline.

## Accessibility
- Small single-purpose dialog, one field + clear title naming the reason ("sensitive action") — the why is announced, not implied.

## Default verdict for our stack
RECOMMENDED — pair with Better Auth freshness checks for credential/billing/tenant-destructive actions; GitBook's dual-method gate is the model since we have headless social + password auth.
