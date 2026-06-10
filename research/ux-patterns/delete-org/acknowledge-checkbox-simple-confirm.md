# Pattern: Lightweight delete confirm (checkbox or plain consequence dialog)
**Surface:** delete-org · **Observed in:** Superlist, Amie, Current, Strut (refs: [Superlist](https://mobbin.com/screens/9631d090-c06b-4b81-8029-d675b0841a80), [Amie](https://mobbin.com/screens/ddd188c2-5760-4a6b-80f1-a1a9d8b95a0c), [Current](https://mobbin.com/screens/bd0d7f4b-0966-4c46-ad9b-b1dda5cce979), [Strut](https://mobbin.com/screens/444ae772-7140-409c-b307-4a5fffe91b0d))

## Flow
1. Delete triggered from danger zone (Amie: "DELETE WORKSPACE" badge dialog) or workspace menu.
2. Dialog states consequences in one or two sentences: Superlist — "This will permanently delete all your tasks and lists and any Pro subscription will be cancelled. This action cannot be undone."; Amie — "Your active workspace subscriptions will be cancelled"; Current — "This workspace will no longer be available, all users will be removed and all content will be deleted."; Strut — "All content inside the workspace will also be deleted."
3. Superlist adds a single acknowledge checkbox ("Yes, I want to delete this team") gating the red Delete team button; the others go straight to Cancel/Delete.

## Use when
Consumer-ish or small-team products where the workspace holds modest data; billing-cancellation side effects still must be stated (Superlist and Amie both do).

## Avoid when
The org is a multi-user tenant with significant shared data — one misclick (or one checkbox tick) destroying other people's work is below the bar B2B users expect from infra-grade tools; no identity verification of any kind here.

## Sad paths observed
Subscription-cancellation side effect disclosed pre-confirm (Superlist, Amie); Strut's Delete button renders disabled until the dialog settles.

## Accessibility
Single checkbox + clearly labeled destructive button (Superlist); others are two-button dialogs with color-only destructive signaling.

## Default verdict for our stack
AVOID for org deletion — too light for tenant destruction; acceptable shape only for sub-org objects (a single event, a view).
