# Pattern: Post-reset success handoff (auto-login vs. confirm-then-login)
**Surface:** password-reset · **Observed in:** Ghost, Patreon, Notion (refs: [Ghost flow](https://mobbin.com/flows/d13d93ce-12c8-406f-b576-a141d513dc1a), [Patreon flow](https://mobbin.com/flows/753b0154-51d5-497f-98dd-1b972655b834), [Notion](https://mobbin.com/screens/62223749-ea2f-41a7-81cd-eb3a603ad457))

## Flow
Variant A — auto-login (Ghost):
1. User saves the new password.
2. App logs them straight into the dashboard with a dismissible top banner "Password changed successfully."

Variant B — confirm then login (Patreon):
1. User saves the new password.
2. Interstitial: "Success! Your password has been changed." with a single "Log in" CTA.
3. User authenticates with the new password.

Settings variant (Notion): modal confirmation "Your password has been saved — We'll ask for this password when you log in to your account."

## Use when
- Variant A: you want zero-friction recovery and the reset token already proves email control — sign the session in server-side after reset.
- Variant B: you want the user to immediately exercise (and thus remember) the new credential, or your security policy invalidates all sessions on reset.

## Avoid when
- Variant A: avoid when reset should also revoke all sessions including the current device (high-security tenants) — auto-login contradicts the revocation story.
- Variant B: avoid when minimizing drop-off matters more than credential rehearsal.

## Sad paths observed
- None beyond the handoff itself; both variants give explicit textual confirmation that the change happened (important signal if the reset was attacker-initiated).

## Accessibility
- Ghost's success banner is dismissible and visually distinct; should be `aria-live="polite"` in our build.

## Default verdict for our stack
RECOMMENDED (Variant A) — Better Auth's `resetPassword` + immediate `signIn` gives the Linear-grade frictionless path; expose "sign out other sessions" as the security counterweight.
