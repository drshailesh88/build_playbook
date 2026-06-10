# Pattern: Admin confirmation step after invite acceptance (two-sided join)
**Surface:** pending-invites · **Observed in:** 1Password (refs: [notifications + Person Details flow](https://mobbin.com/flows/18b64277-b032-44f9-85ef-9af58f24081f), [dashboard onboarding card](https://mobbin.com/screens/ac5da9a2-5cc7-4440-a2fa-1c29b8e8c5a1))

## Flow
1. Invitee accepts the invitation and completes account setup — but does not yet get access.
2. Admin sees a new state: dashboard "Onboarding" card lists "2 People waiting to be confirmed"; bell notifications name each person ("Robert Choi is awaiting confirmation").
3. Person Details screen shows a banner: "Waiting to Be Confirmed — Robert Choi has accepted their invitation and is ready to join" with Reject / Confirm buttons.
4. Only after Confirm does the person become an active member; Reject ends the join even post-acceptance.

## Use when
- High-security domains (1Password is a credential vault) where possession of an invite link must not be sufficient — the admin re-verifies identity before granting access.
- Compliance regimes requiring a human approval audit point.

## Avoid when
- Standard B2B collaboration — it doubles admin workload per member, stalls onboarding on admin availability, and no general-purpose reference app (Linear, Vercel, Slack, Notion) does it.

## Sad paths observed
- The whole pattern is a sad-path defense: a leaked/forwarded invite email cannot mint access on its own.
- Notification → Person Details routing means the approval queue is never more than two clicks away.

## Accessibility
- Confirm/Reject as labelled buttons in a status banner; queue counts in plain text on the dashboard.

## Default verdict for our stack
AVOID — our invite-bound-to-email + expiry already covers the threat at our tier; revisit only if an enterprise tenant demands approval workflows.
