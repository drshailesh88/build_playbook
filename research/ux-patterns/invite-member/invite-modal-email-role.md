# Pattern: Invite modal — email tokens + role picker
**Surface:** invite-member · **Observed in:** Slack, Stripe, Sana AI, Fibery, Clay (refs: [Slack](https://mobbin.com/screens/25019c93-8f16-4c0c-a8c5-b7343f8ebf25), [Slack w/ channels+message](https://mobbin.com/screens/f3dc90b5-c5d7-4734-ae20-9471e7d378cb), [Stripe](https://mobbin.com/screens/59346a7c-6296-4444-b7d7-281d1574a94e), [Sana AI flow](https://mobbin.com/flows/25e08ff3-d61d-44d9-ada3-d2d2e21ee493), [Fibery flow](https://mobbin.com/flows/8fafe082-2716-4c06-a7e1-937aba52bb4d), [Clay flow](https://mobbin.com/flows/de055025-303e-4336-8ce3-5a7c174d9f2b))

## Flow
1. "Invite people" button (members page header or global top bar) opens a modal.
2. Multi-email field accepts paste/comma separation: Slack renders entries as removable tokens; Stripe hints "ada@stripe.com, andy@example.com, etc."; Sana uses a free textarea; Clay "Enter one or more email addresses, separated by commas".
3. One role picker applies to the whole batch ("Invite as: Member/Guest" — Slack; "Select role" — Sana; Stripe uses grouped role checkboxes with a live description panel).
4. Optional extras: Slack adds default channels + custom message; Fibery pairs the email form with an invite-link toggle in the same modal.
5. Send → button shows progress ("Inviting…" — Fibery) → modal closes, toast/row confirms.

## Use when
- Inviting is a batch action with one role per batch (typical: "invite these 5 ops people").
- You want the members page to stay read-focused and put compose behind one click.

## Avoid when
- Each invitee routinely needs a different role in one batch — use per-row email+role repeater instead.
- During first-run onboarding (no page to anchor a modal to) — use a dedicated step page.

## Sad paths observed
- Fibery disables Send until a valid email exists and shows an in-button loading state.
- Slack guest invites force "Add to channels (required)" + expiration date before Send is allowed ([ref](https://mobbin.com/screens/8eb96adc-b86c-4936-9d20-f2528855f57d)).

## Accessibility
- Token fields need backspace-to-delete and announce-on-add; Stripe's checkbox role list is more screen-reader-friendly than a custom dropdown. Modal = standard focus trap.

## Default verdict for our stack
RECOMMENDED — shadcn Dialog + token email input + role Select with descriptions; matches Slack/Stripe and keeps B4's table clean.
