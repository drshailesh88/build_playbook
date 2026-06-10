# Pattern: Locked-Email Invite Signup
**Surface:** accept-invite-new-user · **Observed in:** Retool, Dropbox, Air, Optimal Workshop, ClickUp, Charma, Zeplin (refs: [Retool flow](https://mobbin.com/flows/4976cb81-97fd-4bbf-8b43-478e0111c588), [Dropbox flow](https://mobbin.com/flows/0b71cd78-21b8-45dc-b6e2-41b658b225e5), [Air](https://mobbin.com/screens/caafc887-7761-4c10-9af3-5a35a12e5b64), [Optimal Workshop](https://mobbin.com/screens/1b067f3a-09be-49d4-9175-9d165a543250), [ClickUp](https://mobbin.com/screens/289e17aa-831a-4439-bd0b-c4bbff42182d), [Charma](https://mobbin.com/screens/02a6dc7a-717f-4533-bd8a-b89b8a3ca34c), [Zeplin](https://mobbin.com/screens/0df33aa0-5f0c-40a4-abbe-b694fa29d3ba))

## Flow
1. User clicks invite link from email; lands on a signup page headed with org/inviter context ("Sam invited you to make an account!", "Join your team! You've been invited to SLMobbin").
2. Email field is pre-filled from the invite token and rendered read-only/greyed (Retool: "Your email alexsmith@… was invited"; Dropbox, Air, ClickUp, Charma).
3. User fills only the remaining fields: name + password (Retool, Dropbox), or first/last/password (Optimal Workshop, Air).
4. Single CTA combines signup + accept ("Sign up and accept", "Agree and sign up", "Join Workspace").
5. On submit, account is created and user lands directly inside the invited workspace (Retool flow ends on workspace home).

## Use when
Invite tokens are bound to a specific email; you need a real credentialed account (password or OAuth) before org membership; desktop-web B2B onboarding.

## Avoid when
Invites are open link-based (anyone with the link can join) — a locked email field would be wrong; or when you support passwordless-only auth (see passwordless-otp-accept).

## Sad paths observed
ClickUp shows a tooltip on the disabled email field: "This invite can only be used with this email address. To use a different email address, please ask a Workspace admin to send a new invitation" — error copy names the exact escape hatch.

## Accessibility
Read-only email rendered as a disabled input keeps it in the form's tab order and label structure; ClickUp's tooltip-only explanation would not be announced without focus handling — prefer inline helper text.

## Default verdict for our stack
RECOMMENDED — maps 1:1 to Better Auth invitation tokens; locked email kills the wrong-email failure class at the source while keeping the form shadcn-trivial.
