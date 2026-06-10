# Pattern: Expired/Invalid Link Page with Self-Serve Recovery CTA
**Surface:** invite-error-states · **Observed in:** NordVPN, Jitter, Sentry (refs: [NordVPN](https://mobbin.com/screens/dfa9ee24-160c-445b-b605-623b2f588d2b), [Jitter](https://mobbin.com/screens/afbfda33-219a-4d01-b1cd-d25b1289c6ca), [Sentry](https://mobbin.com/screens/0dbee83b-078f-4234-ac44-939735152a23))

## Flow
1. Dead link resolves to a dedicated page that names the failure plainly: NordVPN "400 error — This link has expired"; Jitter "Invalid login link. This login link is invalid or has been used already"; Sentry "Either the link you followed is invalid, or it has expired."
2. The page explains the path to a fresh link: NordVPN "To request a new link, go back to login and select Forgot your password?"; Sentry inline "You can always try again" link.
3. Primary escape hatch is a single link/button: "Back to login" (NordVPN, Jitter); Sentry adds "Need help? … help center".
4. NordVPN appends an "Attempt ID" for support correlation.

## Use when
Token-based invite/auth links that expire or are single-use; whenever the user can self-serve a replacement (re-request invite, ask for new email) — say exactly how.

## Avoid when
The user cannot self-recover (invite must be re-sent by an admin) — then say who to contact instead of pointing at login (see blocked-invite-human-escalation); never reuse a generic 404.

## Sad paths observed
These pages ARE the sad path; differentiator is whether recovery is actionable: NordVPN/Sentry name the next step, Jitter only offers "Back to login" with "please try again" (retrying a dead link is non-actionable copy).

## Accessibility
Failure headline as h1; the recovery action as a real link/button, not body-text-colored; support/attempt ID as selectable text.

## Default verdict for our stack
RECOMMENDED — for expired invites: name the org, say "This invite has expired", offer "Ask {inviter} to send a new one" plus a "Go to login" secondary, include a support reference ID.
