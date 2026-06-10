# Pattern: Change email via verification link to the new address
**Surface:** account-settings · **Observed in:** Linear, Chatbase, Preply, Record Club (refs: [Linear step 1](https://mobbin.com/screens/65d23a06-40ca-4aea-b44b-79f552d17953), [Linear step 2](https://mobbin.com/screens/e8b79488-0647-4503-93b4-1db2be786a84), [Chatbase flow](https://mobbin.com/flows/cab78f01-211d-4a84-8f3e-c487d89b393a), [Preply flow](https://mobbin.com/flows/fbe35a88-b8fa-4763-a0f9-a5868f699b1e), [Record Club flow](https://mobbin.com/flows/677c8381-4cde-4231-9fa5-fbcf97b7ab1d))

## Flow
1. User initiates email change (Linear: "Change email" modal; Chatbase/Preply: edit the email field inline and Save).
2. (Linear only) System first checks the new address: "We did not find an existing account for X. You can safely proceed" → explicit conflict pre-check before sending.
3. System sends a verification link to the NEW address; UI confirms: Chatbase toast "Please follow the verification link sent to <new email>"; Preply toast "We have sent a verification link to your new email address. In order to confirm changes, please click on it."; Record Club banner "Please check your email to verify your new email address."
4. Email remains the old one until the link is clicked; current screen stays put (no logout).

## Use when
- Always for login-email changes — proves ownership of the new address before it becomes the identifier. Linear's pre-check step is the strongest variant for multi-tenant apps where the email may already own another account.

## Avoid when
- Never skip verification for a credential email. Avoid the silent variant (changing the field with no pending-state indicator) — user can't tell whether the change took effect.

## Sad paths observed
- Linear surfaces the account-collision case explicitly before sending ("Please check if the new email address is tied to an existing account before proceeding").
- Linear warns scope: "This change will apply across all workspaces that you are a member of" — cross-tenant impact stated upfront.

## Accessibility
- Confirmation via toast only (Chatbase/Preply) is easy to miss for screen readers; Record Club's persistent inline banner is the more robust announcement.

## Default verdict for our stack
RECOMMENDED — matches Better Auth's changeEmail verification flow; adopt Linear's pre-check messaging plus a persistent pending-verification banner (not just a toast).
