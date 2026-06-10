# Pattern: Card-per-setting with individual Save and constraint footer
**Surface:** account-settings · **Observed in:** Vercel, Chatbase (refs: [Vercel general settings](https://mobbin.com/screens/16950d2b-6048-460f-8f24-0410eb0b05c0), [Vercel name/email/avatar cards](https://mobbin.com/screens/8ee81c81-b0ea-471e-9d23-226654627286), [Chatbase account](https://mobbin.com/flows/cab78f01-211d-4a84-8f3e-c487d89b393a))

## Flow
1. Settings page is a vertical stack of cards; each card owns exactly one setting (Name, Email, Username, Avatar).
2. Card anatomy: title, one-line description, the input, then a footer row with a constraint/explanation hint ("Please use 32 characters at maximum." / "We will email you to verify the change.") and a right-aligned Save button.
3. Save is disabled until the card's value changes; each card saves independently.

## Use when
- Settings are independent scalar values with different validation rules and side effects (email triggers verification, username has length limits); you want zero risk of a global "unsaved changes" state.

## Avoid when
- Fields are interdependent and must commit atomically (profile forms where name + avatar save together); many cards make the page long and Save-button noise repetitive.

## Sad paths observed
- Side effects are pre-announced in the card footer before the user commits (Vercel: "Emails must be verified to be able to login with them or be used as primary email.").

## Accessibility
- Each card is a self-contained form — clear label/input/submit grouping; per-card Save gives an unambiguous target after editing one field.

## Default verdict for our stack
RECOMMENDED — composes cleanly from shadcn Card + per-field server actions, eliminates dirty-state tracking, and is the established Vercel-quality look for account pages.
