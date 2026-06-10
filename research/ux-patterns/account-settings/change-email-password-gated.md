# Pattern: Password-gated email change (re-auth before edit)
**Surface:** account-settings · **Observed in:** Babbel, Notion (refs: [Babbel change-email form](https://mobbin.com/flows/e702b095-4858-4d45-9b04-fd8e70847edc), [Notion password-confirm modal](https://mobbin.com/screens/27c11172-8341-4fd1-8060-a568593c659f))

## Flow
1. User clicks "Change email".
2. System demands the current password before (Notion: dedicated modal "Your current email is X. Please enter your password.") or alongside (Babbel: "Current password (required)" field inside the change-email form) the new address.
3. "Forgot your password?" escape hatch offered (Babbel).
4. On success, verification email is sent to the new address; Babbel shows a green success banner: "Your email address has been successfully changed. The last step you need to take is to verify it."

## Use when
- Email is the login identifier and session theft is a concern: a stolen open session alone cannot hijack the account. Combine with the verification-link pattern (this gates the request; that proves the new address).

## Avoid when
- User has no password (OAuth-only accounts) — must offer an alternative proof (email link re-auth, see GitBook step-up card in session-expiry) or the flow dead-ends.

## Sad paths observed
- Notion shows inline "Incorrect password." under the field; modal stays open for retry.
- Babbel keeps a "Forgot your password?" link inside the gate so a forgotten password doesn't dead-end the email change.

## Accessibility
- Notion's modal is small and single-purpose (one field, one button) — minimal focus-trap surface; error text rendered adjacent to the input.

## Default verdict for our stack
RECOMMENDED — combine with verification-link pattern; Better Auth supports password re-verification server-side, and B2B tenant data warrants gating credential changes.
