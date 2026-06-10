# Pattern: Inline invite section pinned above the members table
**Surface:** invite-member · **Observed in:** Vercel, Visitors, 1Password (refs: [Vercel](https://mobbin.com/screens/a10e73e0-e3cd-4d17-a267-1d84051af6a8), [Vercel pending tab variant](https://mobbin.com/screens/a49185fb-e32e-4eb4-a463-a66569d81a45), [Visitors flow](https://mobbin.com/flows/384e0f66-ca2f-4149-bae9-a4ae5b3d8468), [1Password "Send invites" tab](https://mobbin.com/screens/ac5da9a2-5cc7-4440-a2fa-1c29b8e8c5a1))

## Flow
1. Members settings page opens with a persistent "Invite new members by email address" card at the top — no modal.
2. Email input + role dropdown side by side; "Add more" appends additional email+role rows (Vercel).
3. "Invite Link" secondary button sits in the same card; "Invite" primary at the card's footer.
4. Below the card: Team Members / Pending Invitations tabs — invite, members, and pending are one screen.

## Use when
- Inviting is the page's primary job early in a workspace's life (empty team) — zero clicks to compose.
- Form is small (email + role only).

## Avoid when
- The invite form needs many options (channels, message, expiry) — inline bloats the page; move to a modal.
- Members page is information-dense at 100+ rows; a permanent compose card wastes the most valuable viewport band.

## Sad paths observed
- Vercel keeps the role dropdown's descriptions ("Owner — Admin-level access to the entire team") attached even inline, so a mis-grant is harder.
- Visitors disables Invite until the email field validates.

## Use when / Avoid when verdict context
- Vercel is the only top-tier reference doing this; Linear, Slack, Notion, Stripe all chose modal or link.

## Accessibility
- Plain form controls, no overlay — the most screen-reader-friendly compose variant observed.

## Default verdict for our stack
VIABLE — clean and low-friction, but a modal scales better as our invite gains role descriptions and multi-row; pick inline only if invite stays email+role forever.
