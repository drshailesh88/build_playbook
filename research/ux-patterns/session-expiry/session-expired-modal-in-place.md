# Pattern: "Session expired" notice modal over the app (sign-in is a redirect)
**Surface:** session-expiry · **Observed in:** Quicken, Square, Rocket Money (refs: [Quicken](https://mobbin.com/screens/15fc8181-6e51-43aa-ae2c-4fe54c87afbe), [Square](https://mobbin.com/screens/f1311421-d0c3-4f74-923f-d9428dd88378), [Rocket Money](https://mobbin.com/screens/0727897f-0c0a-464c-844e-dd987cb1e671))

## Flow
1. On expiry, a modal appears over the (still-rendered or skeletonized) app: Quicken "Session expired — You have been logged out. You need to sign in to continue."; Square "Session Timeout — You have been signed out due to inactivity. Please sign in again."; Rocket Money softens it: "You're busy, we've got your back. We noticed you were inactive for a significant amount of time. For your security, we've logged you out to keep your information safe."
2. Reason is always stated (inactivity / security).
3. Single CTA "Sign in" / "Log in" → navigates to the login page. Quicken uniquely adds "Keep me logged out" as an explicit decline.
4. Background data is masked or skeletonized (Rocket Money blurs the dashboard) — no sensitive data left readable.

## Use when
- You can detect expiry client-side but cannot (or choose not to) re-auth in place — the modal explains the state before dumping the user on a login screen, preventing "did the app crash?" confusion.

## Avoid when
- Mid-form contexts where the subsequent redirect destroys input — without return-to-page + draft restore, this pattern alone violates our never-lose-input rule; prefer in-place re-auth.

## Sad paths observed
- All three state the WHY ("due to inactivity", "for your security") — expiry is explained, not just enforced; Rocket Money masks the data behind the modal.

## Accessibility
- Simple alert dialog with one primary action; message is plain text. Should use role=alertdialog so the state change is announced.

## Default verdict for our stack
VIABLE — acceptable fallback for non-edit surfaces (dashboards/lists), but pages with user input must get the in-place re-auth modal instead.
