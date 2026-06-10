# Pattern: Inline resend + revoke with visible result states
**Surface:** pending-invites · **Observed in:** Slack, Threads, 1Password, Cloaked, Vercel (refs: [Slack](https://mobbin.com/screens/d4441a40-cfb0-42b1-aee9-6f2ba84ebad7), [Slack result states](https://mobbin.com/screens/2fe9271e-36ed-4333-b809-6078dc790098), [Threads](https://mobbin.com/screens/6a8565ed-d3f6-46ce-9706-1bdea8ea0385), [1Password](https://mobbin.com/screens/abe40bad-1db6-416a-9412-ef8ce5f85318), [Cloaked](https://mobbin.com/screens/919db39c-4939-4df3-8d3e-8c343fc4e235), [Vercel](https://mobbin.com/screens/a49185fb-e32e-4eb4-a463-a66569d81a45))

## Flow
1. Each pending row exposes recovery + retraction: Slack — explicit "Resend Invitation" and "Revoke" buttons inline; Threads — "Resend invitation" button + overflow holding destructive "Rescind invitation" (red); 1Password — overflow with Resend / Delete; Vercel — overflow with "Remove"; Cloaked — "Withdraw".
2. After action, the row mutates in place to a result state rather than vanishing silently: Slack shows "✓ Invitation resent" replacing the button, and "✗ Invitation revoked" on retracted rows (row persists as a record).
3. Bulk recovery: 1Password family offers "Resend All" at the list level.
4. Common vocabulary: resend is always positive-styled; revoke/rescind/remove always separated (overflow or right-aligned) and destructive-styled.

## Use when
- Always on a pending list — resend handles the "never got it / expired" support case, revoke handles mis-sent invites; both are table stakes in every observed app.

## Avoid when
- Don't put revoke as a bare primary-row button next to resend without visual separation — only Slack does adjacent buttons and it styles them distinctly; overflow placement (Threads, 1Password, Vercel) is the safer default.

## Sad paths observed
- Slack annotates a row with "email address bounced" — delivery failure surfaces on the list, with resend right there.
- Slack's resent/revoked persistent states create an audit trail in the UI itself.

## Accessibility
- Text-labelled buttons ("Resend Invitation"), not icons; result states are text, announced on re-render if implemented as status updates.

## Default verdict for our stack
RECOMMENDED — resend as inline button with "resent ✓" optimistic state, revoke in the row overflow with confirm; add bounce surfacing when our email provider reports it.
