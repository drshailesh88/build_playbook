# Pattern: Explicit expiry statement on the invitation
**Surface:** invite-email · **Observed in:** Clay, Dub, 1Password, Slack (refs: [Clay](https://mobbin.com/screens/c861efe0-7a55-4a5f-8286-f7c6589d0bcd), [Dub](https://mobbin.com/screens/fc305ffc-21f2-4c2b-9804-fecf29bd59a7), [1Password](https://mobbin.com/screens/1499832f-ba87-44a5-bd79-002c5f55975d), [Slack guest expiry](https://mobbin.com/screens/8eb96adc-b86c-4936-9d20-f2528855f57d))

## Flow
1. The invitation artifact states its lifetime in plain words: Clay's accept page — "This invitation expires in a month."
2. The policy is also surfaced to the inviter at compose time (Dub: "Invitations will be valid for 14 days") and on the pending list (1Password: "Invitations expire after 5 days. You can resend an invitation at any time." with per-invite "Expires 2023-02-12 at 4:28 PM").
3. Slack goes further for guests: the invite itself carries an account expiration ("Deactivate on August 31, 2024") chosen by the inviter.

## Use when
- Any invite that grants tenant access — unlimited-lifetime invite links/tokens to a multi-tenant B2B app are a liability.
- Wording: relative + absolute ("expires in 7 days — June 17") beats either alone.

## Avoid when
- Don't enforce expiry without saying so anywhere — the observed apps state the policy at one or more of: email/landing, compose, pending list. Silent expiry produces dead-link support tickets.

## Sad paths observed
- 1Password pairs expiry with the recovery action (Resend) in the same sentence — the fix travels with the failure.
- Clay's relative timestamp ("invited you … 8 hours ago") plus expiry lets the invitee compute freshness.

## Accessibility
- Plain text statements; expiry not conveyed by color or countdown widget anywhere observed.

## Default verdict for our stack
RECOMMENDED — 7–14 day expiry stated in the email body ("This invitation expires on {date}") and echoed on the pending-invites tab with Resend adjacent.
