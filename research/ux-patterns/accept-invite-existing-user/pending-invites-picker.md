# Pattern: Pending-Invites Picker with Auto-Switch
**Surface:** accept-invite-existing-user · **Observed in:** Notion, Synthesia, Steep, Otter.ai (refs: [Notion](https://mobbin.com/screens/1f794a8f-3b4d-4f47-99a5-158c604317dc), [Notion in-app](https://mobbin.com/screens/af8c3aec-a932-4988-adde-b5baba6d6a01), [Synthesia](https://mobbin.com/screens/d6f457ba-dc5b-4349-a3cb-07691902f475), [Steep flow](https://mobbin.com/flows/5e806a28-dd2f-4b93-b0b7-1d81123ace6f), [Otter.ai](https://mobbin.com/screens/c6a2effd-d510-40e9-8472-8b17689a245b))

## Flow
1. After auth (or in-app), the user sees every workspace invitation attached to their email as a list: Notion "Join teammates or create a workspace — You've been invited to 1 workspace" with per-row Join; Synthesia "Join workspaces — Pending invites" with per-row buttons plus "Accept all".
2. Each row carries org avatar, name, member count/role (Synthesia shows "Guest"; Notion "1 member · Created by Jane Smith").
3. Joined state flips inline ("Joined" badge) and a continue CTA switches into the product ("Continue to Synthesia", header counts "1 workspace joined").
4. Fallbacks on the same screen: "Create a new workspace" (Notion, Synthesia), Steep adds dismiss "X" per invite and Log out; Notion surfaces the same picker in-app later ("Collaborate with teammates" modal with Join workspace).
5. Otter.ai variant: domain-based suggestion ("Based on your email, you may be interested in joining the workspace with other @content-mobbin.com members") with Join + Skip.

## Use when
Email may hold multiple pending invites (agencies, contractors); user signed up organically and invites arrived before the account existed; you want invites discoverable beyond the email click.

## Avoid when
The user arrived via a specific invite token — do not detour them through a picker for the org they already chose (auto-join that one, list the rest after).

## Sad paths observed
Steep allows dismissing an invite (X) without accepting — explicit decline; Synthesia disables already-joined rows ("Joined") preventing double-accept.

## Accessibility
List rows need the org name + action in the button label ("Join Jane's Workspace"), not bare "Join"; joined-state change should be announced.

## Default verdict for our stack
VIABLE — worth building as the post-login "invitations inbox" for invites that arrive while signed out, but never as an interruption to a direct token accept.
