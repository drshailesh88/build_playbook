# Pattern: Magic-link-primary login with password fallback
**Surface:** sign-in · **Observed in:** Better Stack (refs: [Better Stack login](https://mobbin.com/screens/6e4462ee-35ac-4263-8fd9-7ca9b00b6e00), [Better Stack interstitial](https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e))

## Flow
1. Login card shows one email field and a primary button "Send me a magic link".
2. Directly beneath: a quiet text link "Sign in using password" for holdouts, then an "or" divider and an SSO button.
3. Magic-link path proceeds to the check-your-inbox interstitial (webmail deep links, wrong-email escape).
4. "First time here? Sign up for free" link in the header area.

## Use when
- Passwordless is the strategic default and password is legacy/secondary.
- Login frequency is low (monitoring/admin tools) so the inbox round-trip per session is tolerable.

## Avoid when
- Email+password is the declared primary credential (our stated context) — inverting the hierarchy contradicts it.
- Users log in many times per day or on shared/locked-down machines without inbox access.
- Email deliverability is not yet bulletproof.

## Sad paths observed
- Wrong-email recovery and spam-folder hint handled on the downstream interstitial ([ref](https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e)).

## Accessibility
- Single-field form, clear button verb ("Send me a magic link") states the consequence — no surprise navigation.

## Default verdict for our stack
AVOID — single-app evidence and it inverts our email+password-primary decision; keep magic link (if ever) as the secondary escape, not the headline.
