# Pattern: Passwordless recovery (magic link / login code replaces reset)
**Surface:** password-reset · **Observed in:** Linear, Notion (refs: [Linear](https://mobbin.com/screens/cb4db689-0099-47d5-9d98-682e7b3f3f34), [Linear code-entry](https://mobbin.com/screens/da6825c0-a150-48bb-af3a-6a0f3ea08bb1), [Notion](https://mobbin.com/screens/1e8421b1-07d9-4ed4-bc91-6f0a9d97ceee))

## Flow
1. There is no (or a de-emphasized) password; "forgot password" collapses into "email me a way in".
2. Linear: "Check your email — We've sent a temporary login link. Please check your inbox at <email>", with an "Enter code" field + "Continue with login code" so the user can type the code instead of clicking the link ("Enter code manually" variant).
3. Notion: after requesting reset, the login page itself shows inline "Check your inbox for the link to reset your password" while keeping Google/Apple/SSO buttons available.
4. Clicking link or entering code authenticates directly; "Back to login" escape on every screen.

## Use when
- Magic-link/OTP is a first-class login method — recovery and login become the same flow, deleting an entire surface.
- Cross-device/webmail-on-another-machine cases matter: the manual code entry (Linear) is the fix for "link opens in the wrong browser".

## Avoid when
- Password is the only credential and enterprise users expect a conventional reset — replacing it wholesale confuses IT-driven onboarding.
- Email delivery is unreliable for your audience; there is no fallback credential.

## Sad paths observed
- folk's same-browser failure ([ref](https://mobbin.com/screens/52557853-0b2e-4151-89e9-05ff86d08d58)) is exactly what Linear's manual code entry prevents.

## Accessibility
- Linear's code input is a single text field (not split boxes) — simpler for screen readers and paste.

## Default verdict for our stack
VIABLE — Better Auth supports magic-link/OTP plugins; strong candidate as a secondary "email me a login link" escape on the login form, but not a replacement for password reset in a B2B product with enterprise expectations.
