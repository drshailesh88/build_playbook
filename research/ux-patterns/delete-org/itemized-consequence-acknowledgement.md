# Pattern: Itemized live-count consequence acknowledgement
**Surface:** delete-org · **Observed in:** GitBook, Fibery (refs: [GitBook](https://mobbin.com/screens/99a4e516-0551-4401-8d36-38bc876b8c3f), [Fibery](https://mobbin.com/screens/59b68706-022a-4537-892a-e73b87951b1d))

## Flow
1. Delete-organization modal enumerates the real, counted blast radius as individual checkboxes (GitBook): "I understand **34 spaces** will be deleted forever", "I understand **1 collection** will be deleted forever", "I understand **3 members** will be unlinked", "I understand deleted content will not be recoverable".
2. Every checkbox must be ticked, THEN the type-name field ("Type \"SLMobbin\" to confirm") unlocks the red Delete — acknowledgement stacks on top of type-to-confirm, not instead of it.
3. Fibery variant (space-level): dialog lists the named child objects that die with the parent ("The following Databases (with all the data!) will be deleted: Database 1") plus second-order effects ("Views that rely on these Databases will require reconfiguration"); delete button shows in-progress state ("Deleting…").
4. GitBook also links Terms of Service regarding deletions above the checklist.

## Use when
The org contains live counted assets (events, attendees, files) — concrete numbers convert an abstract warning into a real inventory; strongest possible guard for the highest-stakes action.

## Avoid when
The org is empty or counts are zero (checkboxes acknowledging "0 events will be deleted" are absurd — render conditionally); or for anything less than tenant-level destruction, where four checkboxes is harassment.

## Sad paths observed
Second-order breakage disclosed (Fibery: dependent views require reconfiguration); "not recoverable" is its own separate acknowledgement line in GitBook, making the retention statement un-skippable.

## Accessibility
Each consequence is an individually focusable checkbox with the count in bold — screen readers announce each fact separately; progressive unlock communicates required order.

## Default verdict for our stack
RECOMMENDED (as the upgrade of the base modal) — fetch real counts ("3 events, 240 attendees, 5 members") into acknowledge lines above the type-name gate; this is the differentiating detail at the Linear/Vercel bar.
