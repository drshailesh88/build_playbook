# Pattern: Re-authentication gate before removing a member
**Surface:** remove-member · **Observed in:** Lyssna (refs: [Lyssna](https://mobbin.com/screens/5696ab15-e90c-4fb7-80a6-90bd00f5fdbd))

## Flow
1. Admin triggers removal of a collaborator from Team members settings.
2. A toast "Authentication required" appears top-right and a modal opens: "Confirm your password — Please re-enter your password in order to continue."
3. Single password field; buttons Cancel + "Authenticate and remove collaborator" (destructive orange, names the pending action).
4. On success the removal executes in the same step — no second confirm.

## Use when
Member removal is treated as a sensitive/security action (e.g., contractor offboarding, compliance), or the session is long-lived and hijack risk matters.

## Avoid when
Admins remove members routinely (event staffing churn) — password friction on every removal trains password-typing reflexes and slows ops; also avoid when SSO users have no password (need an alternate factor, see GitBook's multi-method re-auth on transfer-ownership surface).

## Sad paths observed
The "Authentication required" toast doubles as the error explanation for why the action was interrupted.

## Accessibility
Single labeled password input with focus in the modal; the confirm button restates the action so screen-reader users know what authenticating will execute.

## Default verdict for our stack
AVOID for plain member removal — reserve re-auth (Better Auth freshness check) for ownership transfer and org deletion; double-gating routine removals misses the Linear-grade flow feel.
