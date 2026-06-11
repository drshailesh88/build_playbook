# Pattern: Invite-lifecycle admin console (expiry as first-class)

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Slack, 15Five, 1Password, Threads (refs: [Slack invitations admin](https://mobbin.com/screens/d4441a40-cfb0-42b1-aee9-6f2ba84ebad7), [15Five pending invites](https://mobbin.com/screens/c2d103be-a9aa-4755-a0bc-8e269678ede5), [15Five expired section](https://mobbin.com/screens/8c6008e7-96a7-40ae-b06a-fcbc0f8c7141), [1Password manage invites](https://mobbin.com/screens/abe40bad-1db6-416a-9412-ef8ce5f85318), [Threads pending tab](https://mobbin.com/screens/6a8565ed-d3f6-46ce-9706-1bdea8ea0385))

## Flow
1. Invitations page with tabs by state: Requests / Pending / Accepted (Slack); search by email.
2. Per-row: invitee, who invited, scope/role, sent date, and an EXPIRY column ("Expires in 30 days" countdown, or "Deactivate on Aug 31, 2024"); row actions "Resend Invitation" / "Revoke".
3. Expired invites move to a separate "Expired invitations" section — a visible graveyard, not silent disappearance (15Five).
4. Bulk select → Actions: "Reset expiration date", "Resend invitation", "Deactivate"; toast "You successfully reset 1 expiration date."
5. The expiry policy is stated inline where the admin works: "Invitations can be resent at any time and expire after 5 days." (1Password)

## Use when
Any tokened-invite system at coordinator scale — faculty invites with TTL. Expiry, resend, and revoke must be visible operations, not DB-only facts.

## Avoid when
Expiry policy lives only in docs — 1Password proves it belongs on the table itself.

## Sad paths observed
- Expired section with its own empty state ("There are no expired invitations.").
- Delete requires explicit confirm naming the object ("Delete invitation").

## Accessibility
Status as words in a column; countdowns as text.

## Microcopy worth stealing
"Expires in {n} days" · "Reset expiration date" · "Invitations can be resent at any time and expire after {n} days." · "Resend Invitation" / "Revoke"

## Default verdict for our stack
RECOMMENDED — directly fixes two old-app gaps: lazy-only expiry (stale `sent` rows shown forever) and no resend/revoke surface. The invite list gets state tabs, an expiry countdown column, resend/revoke/extend actions, and the 30-day policy stated inline.
