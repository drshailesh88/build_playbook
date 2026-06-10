# Pattern: Re-authentication gate before privileged org actions
**Surface:** transfer-ownership · **Observed in:** GitBook, Lyssna, Fresha (refs: [GitBook multi-method](https://mobbin.com/screens/be343c3c-3ab0-46e9-88e8-be6a1d61a93f), [GitBook password](https://mobbin.com/screens/9f79f7ed-574c-49b5-b0b6-12068313d1a9), [Lyssna](https://mobbin.com/screens/5696ab15-e90c-4fb7-80a6-90bd00f5fdbd), [Fresha](https://mobbin.com/screens/e0bc15ba-f81f-493d-92f6-888061a51ce1))

## Flow
1. User triggers a sensitive action (account/org change, collaborator removal, money movement).
2. A modal interrupts: GitBook — "Reauthenticate. You need to reauthenticate yourself to perform this sensitive action" offering the user's available methods as buttons: Google / Password / Email Link; choosing Password swaps to a password field with Cancel / Sign in.
3. Lyssna — password-only variant whose confirm button names the pending action ("Authenticate and remove collaborator").
4. Fresha — password modal scoped to enabling transfer authorisation ("please enter Alex Smith account password to proceed").
5. On success the original action executes without re-asking.

## Use when
Action grants/removes control of the org (transfer ownership, delete org, change owner email) and sessions are long-lived; mandatory when the actor may be on a shared/hijacked session.

## Avoid when
The action is routine (member invite/remove, rename) — re-auth fatigue degrades the security signal; never offer ONLY password when SSO/passkey users exist (GitBook's multi-method menu is the fix).

## Sad paths observed
GitBook's method menu handles the no-password user (OAuth-only accounts get Google or Email Link); Lyssna precedes the modal with an "Authentication required" toast explaining the interruption.

## Accessibility
GitBook lists each method as a full-width labeled button (keyboard-traversable); password fields are single, labeled, and auto-focused.

## Default verdict for our stack
RECOMMENDED (as a composable gate) — Better Auth session-freshness check before transfer-ownership and delete-org, with GitBook's multi-method shape since Event State auth is headless and supports social providers.
