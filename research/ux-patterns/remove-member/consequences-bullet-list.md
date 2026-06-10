# Pattern: Consequences bullet list in remove dialog
**Surface:** remove-member · **Observed in:** Runway, Cohere (refs: [Runway](https://mobbin.com/screens/3329d4e4-8a76-45b8-be00-222964e9496e), [Cohere flow](https://mobbin.com/flows/07c5295c-c71d-4886-bc7b-502a1964f3dd))

## Flow
1. Admin triggers Remove on a member row (Cohere: trash icon next to role dropdown).
2. Modal enumerates what happens to each data class. Runway uses three bullets: (a) removed member loses access to workspace/projects/assets, (b) team projects and assets they created remain available to the team, (c) their private projects in the team workspace become inaccessible except to users explicitly shared on them.
3. Cohere uses a dense paragraph covering the same classes: loses access to team fine-tuned models and usage; models they created stay accessible to the team.
4. Cancel + destructive Remove ("Yes, remove account" / "Remove →").

## Use when
Member-created content splits into different fates (shared stays, private becomes orphaned/inaccessible) and the admin needs to understand all of them before committing.

## Avoid when
There is only one consequence — a bullet list of one inflates a simple action; also avoid burying the bullets in a paragraph (Cohere's wall of text is harder to scan than Runway's bullets).

## Sad paths observed
Runway explicitly covers the orphaned-private-content edge: private projects become inaccessible to everyone except previously shared users — the dialog is the only warning before that data is stranded.

## Accessibility
Plain text bullets inside the dialog; both examples keep the destructive button visually distinct (orange/red).

## Default verdict for our stack
VIABLE — use instead of the one-liner only if Event State ends up with per-member private content whose fate differs from org-owned events; otherwise it is over-weight.
