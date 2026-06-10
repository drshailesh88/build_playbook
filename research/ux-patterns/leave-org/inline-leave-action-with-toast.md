# Pattern: Inline leave action on the org list/page, confirm + toast
**Surface:** leave-org · **Observed in:** Typeform, ClickUp, Clay, FLORA (refs: [Typeform flow](https://mobbin.com/flows/4e712886-a558-4124-bb91-e4dfda2f16d5), [ClickUp flow](https://mobbin.com/flows/b37505d4-9943-40ba-a46b-b31de7750d5d), [Clay flow](https://mobbin.com/flows/2d748867-8820-462a-88b4-6bb7a5e873ab), [FLORA flow](https://mobbin.com/flows/7a39d0d1-ffb3-46e9-a371-0d86e336c837))

## Flow
1. Leave lives where the org is shown, not buried in danger zone: Typeform — workspace overflow menu (Rename / Leave / Delete); ClickUp — "My Workspaces" grid page; Clay — "Leave workspace" link at top-right of Settings → Team; FLORA — "Leave workspace" button directly on workspace Settings.
2. Confirm step varies in weight: ClickUp shows a full-page interstitial "Are you sure you want to leave Alex's Workspace?" with Cancel / Leave Workspace; Typeform and FLORA proceed with minimal/no modal observed.
3. After leaving, the user lands on the surviving context: ClickUp returns to the My Workspaces grid without the left workspace; Typeform returns to the remaining workspace list.
4. Typeform confirms with a toast: "Gone! You fled the workspace and disappeared into the night."

## Use when
Users belong to many orgs and treat membership as lightweight; the post-leave destination (org list/picker) already exists.

## Avoid when
Leaving has heavy consequences (content loss, billing) — the inline placement under-signals weight; FLORA-style no-confirm leave is one misclick from lockout in a fail-closed tenant model.

## Sad paths observed
ClickUp's flow demonstrates the post-leave landing problem: the user ends on a neutral workspace picker rather than a dead context. No last-member handling observed in any of the four apps — none showed what happens when the only remaining member leaves (Clay's leaver left a 2-member workspace; the survivor remained).

## Accessibility
ClickUp's full-page confirm gives a large click target and an unambiguous focus context; Typeform's humor toast is announce-only (auto-dismissing).

## Default verdict for our stack
VIABLE — keep danger-zone as canonical, but the post-leave redirect-to-org-picker behavior (ClickUp) and success toast (Typeform, minus the joke) should be adopted regardless of entry point.
