# Pattern: Expiry display + stated policy on the pending list
**Surface:** pending-invites · **Observed in:** 1Password, Slack, Upwork (refs: [1Password manage invites](https://mobbin.com/screens/ac5da9a2-5cc7-4440-a2fa-1c29b8e8c5a1), [1Password family](https://mobbin.com/screens/1499832f-ba87-44a5-bd79-002c5f55975d), [Slack](https://mobbin.com/screens/d4441a40-cfb0-42b1-aee9-6f2ba84ebad7), [Upwork](https://mobbin.com/screens/25a18f7c-828b-4770-b348-bd545f693458))

## Flow
1. Expiration is a first-class column: 1Password — "Expiration Date: Mar 12th, 2025 at 4:56 AM" per row, plus Status ("Waiting on user").
2. The policy is stated as list-level copy: 1Password — "Invitations can be resent at any time and expire after 5 days."; family variant — "Invitations expire after 5 days. You can resend an invitation at any time." with per-row "Expires {timestamp}".
3. Provenance shown alongside: "Invited by Sam Lee" + sent date (Slack), "Invited by {name} on Sep 9, 2025" (Upwork) — accountability for who created the pending access.
4. Slack guest invites display the future account deactivation date ("Deactivate on Aug 31, 2024") on the pending row.

## Use when
- Invites expire (they should — see B6 expiry-statement): the admin-facing list must show when, or admins can't distinguish "ignored" from "dead".
- Sortable expiry/sent columns once volume grows (1Password sorts on Expiration Date).

## Avoid when
- Don't show expiry as a relative countdown only — observed apps use absolute timestamps (auditable, timezone-explicit).

## Sad paths observed
- 1Password's Status column separates "Waiting on user" from other states — expired invites become visually distinct rather than silently broken.
- Policy copy adjacent to the list preempts "why did my invite die" tickets.

## Accessibility
- Absolute dates as text; status as words not color. Sortable headers keyboard-operable.

## Default verdict for our stack
RECOMMENDED — Sent + Expires columns (absolute dates), "Invited by" attribution, one line of policy copy above the table; trivially cheap, high support-ticket payoff.
