# Pattern: Named-invite accept/decline panel on event page
**Surface:** tokened-access-landing · **Observed in:** Luma (refs: https://mobbin.com/flows/28703fea-9a9b-4a8c-aff3-f3946bd89f14, https://mobbin.com/screens/b520e950-3a01-4bff-994c-dcf66672257b)

## Flow
1. Invitee opens emailed invite link; full event page renders (title, date, venue/Zoom, host, About).
2. A "Registration" card inside the page says "You are Invited — We'd love to have you join us." with the recipient's name and email displayed (Alex Smith · alexsmith@…).
3. Two actions side by side: primary "Accept Invite" (full-width) and secondary "Decline" (small, de-emphasized).
4. Accept flips the card in place to the "You're In" state — no page navigation.

## Use when
- Faculty/delegate clicks "confirm your participation" from email: identity is already known from the token, so show WHO the invite is for and ask only accept/decline.
- You want the decision to live inside event context (the person re-reads details before committing).

## Avoid when
- The link may be forwarded and acted on by the wrong person with side effects — pair with a "not you?" escape (see wrong-user patterns), which Luma's panel does not show.
- Multiple decisions are needed (sessions, responsibilities) — a single accept button hides them; use a follow-up step instead of stuffing the panel.

## Sad paths observed
- None shown on this panel itself; Luma handles post-decline via a separate "You're Not Going" state (see decline-and-reopen card). No expired-invite state observed for Luma invites.

## Accessibility
- Decline is rendered as a low-contrast secondary button — keep it a real button with visible focus, not a link, so keyboard users find both options.
- Recipient email is plain text next to the name; ensure it is not truncated for screen readers.

## Default verdict for our stack
RECOMMENDED — maps 1:1 to faculty "confirm participation" landing: tokened identity displayed, accept/decline inline, event context around it; trivial with shadcn Card + two Buttons.
