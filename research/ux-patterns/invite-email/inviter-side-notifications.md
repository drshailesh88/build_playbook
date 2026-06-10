# Pattern: Inviter-side emails and notifications (the other half of the loop)
**Surface:** invite-email · **Observed in:** Superhuman, 1Password, Airwallex (refs: [Superhuman](https://mobbin.com/screens/7dc3d38a-9e20-49c9-8149-03f2d77b7cd5), [1Password notifications flow](https://mobbin.com/flows/18b64277-b032-44f9-85ef-9af58f24081f), [Airwallex](https://mobbin.com/screens/b069cb69-2cec-487c-be2a-9afc4e5ffae3))

## Flow
1. After sending an invite, the INVITER gets a confirmation email: Superhuman "Team invite sent! Help jsmith@gmail.com get started" — the only actual email body captured in this sweep. Structure: thank-you line naming the invitee, a pre-written shareable note ("I've just invited you to Superhuman! …"), a numbered list of collaboration features unlocked, and a "to add more teammates, click here" CTA.
2. On acceptance, the inviter/admin is notified in-app: 1Password bell notifications "Robert Choi is awaiting confirmation" linking to a Person Details screen with Reject/Confirm.
3. Airwallex sets expectations at send time with a lifecycle tracker (Invitation sent → User accepts → Active user), telling the inviter what emails/states come next.

## Use when
- Invites can sit pending for days — the inviter needs acceptance/bounce signals without polling the members page.
- Optional: an admin-confirmation step after acceptance (1Password) for high-security tenants.

## Avoid when
- Don't email the inviter for every lifecycle tick of a bulk send — digest or in-app only; Superhuman's email exists because invites are 1:1 there.

## Sad paths observed
- 1Password's awaiting-confirmation state means acceptance isn't access — Reject is available right up to admin confirm.

## Accessibility
- Notification text names the person and the required action; the actionable screen has explicit Confirm/Reject buttons.

## Default verdict for our stack
VIABLE — skip inviter emails at MVP; rely on the pending tab + an in-app/email notification on acceptance only. Admin-confirm step is AVOID for us (adds friction our roles don't need).
