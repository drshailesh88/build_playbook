# Pattern: Invite guardrails — external-domain confirm, billing notes, quotas, post-send feedback
**Surface:** invite-member · **Observed in:** Linear, Perplexity, Cloaked, Fibery, Airwallex, Plane (refs: [Linear external confirm](https://mobbin.com/screens/61a7170f-57fb-4d6b-9776-012177d457fe), [Linear sent toast](https://mobbin.com/screens/ae99a607-158a-4642-a69f-00c024381bd0), [Perplexity](https://mobbin.com/screens/22be9a34-4b6c-447e-8b44-84d9b643b4d5), [Cloaked quota](https://mobbin.com/screens/919db39c-4939-4df3-8d3e-8c343fc4e235), [Fibery flow](https://mobbin.com/flows/8fafe082-2716-4c06-a7e1-937aba52bb4d), [Airwallex](https://mobbin.com/screens/b069cb69-2cec-487c-be2a-9afc4e5ffae3), [Plane success toast](https://mobbin.com/screens/6ef35f33-04c0-44be-bf0a-acfee718a167))

## Flow
1. Pre-send checks: Linear interrupts with "Are you sure you want to invite external users (jsmith@gmail.com)? They will receive access to all information in the X team" when the email is outside the org's domain — Cancel / Invite.
2. Cost/quota disclosure at compose time: Perplexity "You will not be charged until invites are accepted"; Fibery banner "Users invited with Member or Admin permissions will start your 30-day pro trial. First 5 Guests are free!"; Cloaked shows a 4/5 invite-quota meter.
3. Post-send feedback: Linear toast "3 invites sent — Invited members have been notified by email"; Plane "Success" toast; Airwallex renders a full confirmation screen with a status tracker (Invitation sent → User accepts invitation → Active user) plus "Invite another user".

## Use when
- Multi-tenant B2B where an external-domain invite is a data-exposure event — exactly our threat model.
- Per-seat billing or invite quotas exist.

## Avoid when
- Don't confirm every invite — only domain-mismatch, quota-edge, or privileged-role sends; blanket confirms train click-through.

## Sad paths observed
- This card IS the sad-path catalogue: external-domain interception (Linear), at-quota state (Cloaked), trial/billing side-effects disclosed pre-send (Fibery), and explicit lifecycle visibility post-send (Airwallex).

## Accessibility
- Confirm dialogs name the actual email address in the message — screen-reader users get the same evidence as sighted users.

## Default verdict for our stack
RECOMMENDED — external-domain confirm + sent-toast are cheap and fit our tenancy model; Airwallex-style tracker is overkill, a toast plus the pending tab suffices.
