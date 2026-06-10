# Pattern: In-place re-auth modal over the blurred app (state preserved)
**Surface:** session-expiry · **Observed in:** Employment Hero, Microsoft Loop (refs: [Employment Hero](https://mobbin.com/screens/80a62519-da66-4bc6-b988-92bbf392b408), [variant](https://mobbin.com/screens/af43b91f-b1fa-4983-9690-8c2de48d6263), [Microsoft Loop](https://mobbin.com/screens/6fee5771-0825-4de8-8a2c-c3ec89de5e07))

## Flow
1. Session expires while the user is mid-page; the app does NOT redirect — the page stays mounted, blurred behind a modal.
2. Employment Hero: personalized "Hi Jane, are you still there?" + "Please enter your password to continue" + password field + "Log in" button; "Not Jane?" link to switch account; footer fallback countdown: "You will be redirected to the login page in 1:52:42".
3. Microsoft Loop: "Authentication — We need to reload the page to sign you back in. If you enable popups for this site, we won't have to reload the page in the future." with Sign Out / Continue / Retry Popup — silent token refresh via popup, page state retained when popups allowed.
4. On success the modal dismisses and the user continues exactly where they were — underlying document/form state never unmounted.

## Use when
- Expiry mid-action where input loss is unacceptable (our case). The page-stays-mounted property is what guarantees drafts survive — no persistence layer needed for the common case.

## Avoid when
- The identity might have changed (workspace SSO forced logout, user switched) — re-auth as the same user must be verifiable ("Not Jane?" handles this); OAuth-only users need a popup/redirect variant (Loop), not a password field.

## Sad paths observed
- Employment Hero: wrong-user case handled by "Not Jane?"; total inaction handled by the eventual-redirect countdown — the modal is not an indefinite dead end.
- Loop: popup-blocker failure handled explicitly with "Retry Popup" and an explanation of how to avoid the reload next time.

## Accessibility
- Single-field dialog with explicit button; countdown text is visible (should be aria-live). Personalized title doubles as confirmation of which account re-auths.

## Default verdict for our stack
RECOMMENDED — our primary expiry handler: intercept 401s, keep the route mounted, show a re-auth dialog (credentials or social popup via Better Auth), resume the failed request after success.
