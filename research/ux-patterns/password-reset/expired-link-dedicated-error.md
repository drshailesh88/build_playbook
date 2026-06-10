# Pattern: Dedicated expired/invalid-link error page
**Surface:** password-reset · **Observed in:** NordVPN, Jitter, Sentry, Height, folk (refs: [NordVPN](https://mobbin.com/screens/dfa9ee24-160c-445b-b605-623b2f588d2b), [Jitter](https://mobbin.com/screens/afbfda33-219a-4d01-b1cd-d25b1289c6ca), [Sentry](https://mobbin.com/screens/0dbee83b-078f-4234-ac44-939735152a23), [Height](https://mobbin.com/screens/ed9241ab-c1fc-4bbf-b600-c9e0f7c20082), [folk](https://mobbin.com/screens/52557853-0b2e-4151-89e9-05ff86d08d58))

## Flow
1. User opens a stale/used reset or login link.
2. Standalone error page states what happened: "This link has expired" (NordVPN, with "400 error" label), "Invalid login link — invalid or has been used already" (Jitter), "We were unable to confirm your identity. Either the link is invalid, or it has expired" (Sentry).
3. Recovery CTA: "go back to login and select Forgot your password?" (NordVPN), "try again" link (Sentry), "Back to login" (Jitter).
4. Support escape hatch: support email + Attempt ID in footer (NordVPN), help-center link (Sentry), "Chat with support" (Height).

## Use when
- Token-based links can expire, be single-use, or be tampered with — i.e., always; this page is mandatory inventory for any link-based flow.

## Avoid when
- You can carry the user's email through the failure — then prefer bouncing to the request form with an inline error and a one-click re-request (see `expired-link-inline-rerequest.md`).

## Sad paths observed
- This page IS the sad path. Notable sub-cases: link already used (Jitter), correlation/Attempt ID for support diagnosis (NordVPN), same-browser requirement failure "open the provided link in the same browser you requested it from" (folk).

## Accessibility
- Single-action pages with one clear CTA; NordVPN includes dark-mode toggle and language switcher even on the error page.

## Default verdict for our stack
VIABLE — required as the generic fallback for tampered/used tokens, but route expired-with-known-email cases to the inline re-request variant instead.
