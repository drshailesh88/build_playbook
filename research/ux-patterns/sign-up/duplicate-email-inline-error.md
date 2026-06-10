# Pattern: Duplicate-email inline error with login redirect
**Surface:** sign-up · **Observed in:** Spotify, Biosites, The Leap, Oyster (refs: [Spotify](https://mobbin.com/screens/16082076-0599-4645-9ec8-0a94e3d96f9a), [Biosites](https://mobbin.com/screens/13212991-3292-4b1a-ba25-d872c80abdb5), [The Leap](https://mobbin.com/screens/ad2475a9-9407-4c46-b938-8f326c9a7b20), [Oyster](https://mobbin.com/screens/3b614711-2da4-444e-a92b-e76b552d9e48))

## Flow
1. User submits (or blurs) an email that already has an account.
2. Red inline message renders directly under the email field — never a toast or modal: "An account with this email already exists." (Biosites), "Email has already been taken" (Oyster, The Leap).
3. Best variant adds the fix in the message: Spotify's "This email is already connected to an account. Log in." with "Log in" as a live link that carries the user (and ideally the typed email) to sign-in.
4. Field gets error border; rest of the form state is preserved.

## Use when
- Always — this is a mandatory sad path for any sign-up form with unique emails.

## Avoid when
- Security-hardened flows where account-existence disclosure is unacceptable (enumeration risk) — alternative is the "we sent you an email" blind response; none of the observed B2B apps do this on signup, accepting the trade-off for usability.

## Sad paths observed
- This card IS the sad path. Notable: Oyster and The Leap state the error but omit the login link — user must find "Sign in" themselves; Spotify closes the loop.

## Accessibility
- Inline message adjacent to the field (associable via aria-describedby); error color paired with text, not color alone, in all four instances.

## Default verdict for our stack
RECOMMENDED — ship Spotify's variant (error + inline "Log in" link prefilled with the email); accept the enumeration trade-off as the observed B2B norm.
