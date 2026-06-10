# Pattern: Auto-Join After Signup with Progress Feedback
**Surface:** accept-invite-new-user · **Observed in:** Notion, Retool, Clay, Bonsai (refs: [Notion](https://mobbin.com/screens/651bd8c4-cdab-456e-9f19-6f1d7e6b2076), [Retool flow](https://mobbin.com/flows/4976cb81-97fd-4bbf-8b43-478e0111c588), [Clay flow](https://mobbin.com/flows/c633c6c4-340d-4ba9-84ca-161c0d546a21), [Bonsai flow](https://mobbin.com/flows/174c5855-65a9-4360-8caf-cfadac836bd3))

## Flow
1. After the signup/verification step completes, membership is granted automatically — no separate "Accept" click.
2. Notion shows an explicit transient state: "Joining team…" spinner overlaying the profile step, so the auto-join is visible, not silent.
3. User lands directly inside the invited workspace (Retool ends on workspace home with teammates' apps; Clay ends inside Sam's Workspace; Bonsai ends on the shared project with a success toast "Your password was set successfully. You are now signed in.").
4. No workspace-picker detour, no second confirmation.

## Use when
Invite token unambiguously identifies one org and the user arrived via that token — the user's intent to join was the click on the email.

## Avoid when
The user has multiple pending invites (use a picker — Notion shows "You've been invited to 1 workspace" chooser when signup happened outside the token path: [Notion picker](https://mobbin.com/screens/1f794a8f-3b4d-4f47-99a5-158c604317dc)); or when joining has side effects worth confirming (seat billing — Perplexity warns admins "Your organization will be billed for any additional members that accept an invitation").

## Sad paths observed
Bonsai gates the invite URL behind auth with a toast "You need to sign in or sign up before continuing" then returns to the invite — redirect-back-after-auth observed working end-to-end.

## Accessibility
Notion's "Joining team…" state needs aria-live announcement; landing in the workspace should move focus to the app shell, not leave it on a dead form.

## Default verdict for our stack
RECOMMENDED — accept-on-signup-success with a brief visible "Joining {org}…" state, then land in the org dashboard with the new org active.
