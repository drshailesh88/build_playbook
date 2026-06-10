# Pattern: Expired/used/invalid token page with one-click recovery
**Surface:** tokened-access-landing · **Observed in:** Jitter (ref: https://mobbin.com/screens/afbfda33-219a-4d01-b1cd-d25b1289c6ca), Grok (ref: https://mobbin.com/screens/185ae7f2-66c4-4de5-aa9a-6ca42347c09d), NordVPN (ref: https://mobbin.com/screens/dfa9ee24-160c-445b-b605-623b2f588d2b), Podia (ref: https://mobbin.com/screens/200cca5a-3725-4ad6-93bd-b69d82be9f5b), folk (ref: https://mobbin.com/screens/52557853-0b2e-4151-89e9-05ff86d08d58)

## Flow
1. Dead token renders a dedicated full-page state, never a generic 404/500.
2. Plain-language headline: "Invalid login link." (Jitter), "This link has expired" (NordVPN), "Verification failed" (Grok).
3. One-line cause, covering reuse explicitly: "This login link is invalid or has been used already, please try again." (Jitter); guidance to use the most recent email: "please use the most recent link we sent you" (NordVPN).
4. Single recovery action, three observed grades:
   - direct resend button: "Resend email" (Grok);
   - inline re-request form with the email pre-filled + error banner "Your reset link has expired. Please try again." (Podia);
   - route back to start: "Back to login" (Jitter, NordVPN).
5. Support affordance: NordVPN prints an "Attempt ID" UUID + support email for escalation.

## Use when
- All five sub-areas: every tokened URL in our product needs this state for expired, already-used, and revoked tokens.
- Best grade for us is Podia/Grok style: re-request a fresh link in place (email or reg# pre-known from the token's metadata where safe), because externals have no login to go "back" to.

## Avoid when
- Never reveal what the token pointed to (event, person) on an invalid-token page — none of the observed pages leak target details; keep ours equally blank.
- Don't auto-resend on page load — resend must be a deliberate click (rate-limited).

## Sad paths observed
- This page IS the sad path; secondary sad path covered: reused token gets the same page with "has been used already" wording (Jitter).
- folk covers a browser-mismatch case: "open the provided link in the same browser you requested it from" — a security posture note if tokens are browser-bound.

## Accessibility
- Single H1 + one primary action = ideal screen-reader recovery; NordVPN's Attempt ID gives support a handle without the user reading a stack trace.
- Error banner (Podia) is colored AND worded — not color-only.

## Default verdict for our stack
RECOMMENDED — Podia-style inline re-request + Jitter's "invalid or already used" copy + NordVPN's support reference ID; recovery sends to the address/phone on file, never to an attacker-supplied one.
