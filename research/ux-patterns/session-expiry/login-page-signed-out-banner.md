# Pattern: Login page with explanatory signed-out banner
**Surface:** session-expiry · **Observed in:** Mailchimp, Monarch, Intercom, Gamma (refs: [Mailchimp](https://mobbin.com/screens/17299fe4-8a3f-46d4-993b-4fd7d11481e0), [Monarch](https://mobbin.com/screens/ecfdcb42-0350-4e35-b55e-165a1a4757f4), [Intercom](https://mobbin.com/screens/bb64cb96-75db-483b-99af-c30fb69ccd7c), [Gamma](https://mobbin.com/screens/128b9985-637b-420d-bcf5-7384f28a718d))

## Flow
1. Expiry (or sign-out) redirects to the normal login page — but with a contextual banner above the form: Monarch (info-blue) "You have been automatically logged out due to inactivity."; Mailchimp (success-green) "You've been logged out. Don't worry, you can log back in below."
2. Banner tone distinguishes cause: success-styled for intentional sign-out, info-styled for automatic expiry.
3. Re-entry greased: email prefilled (Intercom), "Stay signed in" toggle prominent in the header (Monarch) — addressing the cause of the annoyance.
4. Standard login proceeds; (return-to-previous-page behavior not observable from stills).

## Use when
- The shared login page must serve both fresh logins and bounced sessions — the banner cheaply explains WHY the user is here, preventing "did I do something wrong?".

## Avoid when
- As the only mechanism for mid-edit expiry (input is already lost by redirect time); toast-only variants (Gamma) — they vanish before slow readers/screen readers catch them.

## Sad paths observed
- Monarch couples the explanation with the remedy ("Stay signed in" toggle right in the sign-in card) — the user can opt out of recurrence at the exact moment of frustration.

## Accessibility
- Inline banners adjacent to the form are reliably announced; color-coded banners still carry full text (not color-only).

## Default verdict for our stack
RECOMMENDED (as the redirect fallback) — when we do redirect (unauthenticated deep link, expiry on non-edit pages), login must carry a cause banner + returnTo; never a bare login form.
