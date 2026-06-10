# Pattern: Blocking dialog offering both exits (transfer or delete)
**Surface:** last-admin-guard · **Observed in:** Zoom (refs: [Zoom](https://mobbin.com/screens/39492397-759e-478a-9a69-14fd6a9a0c5a))

## Flow
1. The owner attempts to exit a channel they own.
2. A dialog blocks the action and explains the rule plus both ways out: "You are the owner of this channel. Delete the channel for all or assign a new owner before leaving to keep the channel for existing members."
3. Three actions: "Delete Channel" (destructive, text-styled, left), Cancel, "Assign New Owner" (primary, right).
4. Choosing either branch routes into the corresponding flow; the leave completes after the chosen resolution.

## Use when
Both resolutions (transfer vs delete-for-all) are legitimate and you cannot know which the owner intends — e.g., last admin of an org that may simply be obsolete.

## Avoid when
Only one resolution is valid (then deep-link straight into it, Fireflies-style); or as a bare error with no action buttons — that dead-end variant was NOT observed in any swept app, and nothing on Mobbin endorses it.

## Sad paths observed
The dialog itself is the sad path made graceful: the invalid leave is intercepted pre-submit and converted into a decision between the only two valid outcomes.

## Accessibility
Primary (Assign New Owner) carries default emphasis so Enter routes to the safe choice; destructive Delete is de-emphasized as a text button on the opposite side.

## Default verdict for our stack
VIABLE — use this exact dialog as the branch point when the last admin is also the last member or when we want delete-org reachable from the leave attempt; otherwise default to the Fireflies inline wizard.
