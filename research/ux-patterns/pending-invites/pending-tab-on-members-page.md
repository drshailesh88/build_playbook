# Pattern: Pending Invitations as a sibling tab of the members table
**Surface:** pending-invites · **Observed in:** Vercel, Threads, Miro, Upwork, 1Password, Slack (refs: [Vercel](https://mobbin.com/screens/a49185fb-e32e-4eb4-a463-a66569d81a45), [Threads](https://mobbin.com/screens/6a8565ed-d3f6-46ce-9706-1bdea8ea0385), [Miro](https://mobbin.com/screens/faace447-f5cd-4c6e-96db-c1f5a953e179), [Upwork](https://mobbin.com/screens/25a18f7c-828b-4770-b348-bd545f693458), [1Password](https://mobbin.com/screens/ac5da9a2-5cc7-4440-a2fa-1c29b8e8c5a1), [Slack](https://mobbin.com/screens/d4441a40-cfb0-42b1-aee9-6f2ba84ebad7))

## Flow
1. Members page header carries tabs: "Team Members | Pending Invitations" (Vercel), "Members | User lists | 1 Pending invite" (Threads — tab label carries the count), "Active users | Invitations" (Miro), "Send invites | Manage invites (2)" (1Password).
2. Pending tab is its own table with invite-specific columns: email, invited-by, sent date, expiration date, status, actions — columns the members table doesn't need.
3. Rows show identity-less invitees (email only, envelope/placeholder avatar — Vercel, Upwork).
4. Actions per row: resend + revoke (see inline-resend-revoke card).
5. Slack escalates this to a dedicated admin "Invitations" page with Requests / Pending / Accepted / Invite Links tabs and its own search.

## Use when
- Invite metadata (expiry, invited-by, resend) deserves real columns — our B9 spec exactly.
- Invite volume comes in bursts (event staffing) and would drown the members list.

## Avoid when
- Tiny teams with 1–2 invites in flight — a badge row in the members table (see same-table alternative) is less navigation.

## Sad paths observed
- Threads puts the live count in the tab label so pending work is visible without switching tabs.
- 1Password's banner copy sets policy expectations in-place: "Invitations can be resent at any time and expire after 5 days."

## Accessibility
- Standard tablist semantics; counts in tab labels are plain text. Envelope-only avatars need alt text conveying "invitation, not yet a member".

## Default verdict for our stack
RECOMMENDED — tab with count badge next to Members, dedicated columns (Email, Role, Invited by, Sent, Expires, Status); matches Vercel and isolates invite churn from the member roster.
