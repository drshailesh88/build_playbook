# Pattern: Confirm dialog with one-line consequence statement
**Surface:** remove-member · **Observed in:** Slack, Whop, Clay, Notion, Assembly, Current, Charma, Churnkey, Krea AI (refs: [Slack](https://mobbin.com/screens/d6bef83f-27b9-4ef8-9f75-aec00faa25b2), [Whop](https://mobbin.com/screens/55f6ab14-1e42-437d-94b6-e0fa5c5e7de1), [Clay flow](https://mobbin.com/flows/2d748867-8820-462a-88b4-6bb7a5e873ab), [Notion](https://mobbin.com/screens/4933f9fb-88d4-49e0-9090-45de8a9c74c1), [Assembly](https://mobbin.com/screens/4b57f8e8-7600-47ac-9a91-c397adc54fcd), [Current](https://mobbin.com/screens/06ff5fa9-6953-4d88-b706-6d29ad861f73), [Charma](https://mobbin.com/screens/43dd31cd-3d99-427a-ba94-6b779abd037e), [Churnkey](https://mobbin.com/screens/b97d1c19-e8b1-49a0-abf0-11c1f405cbf4), [Krea AI](https://mobbin.com/screens/3c18bf1b-d244-498e-96dd-00d51cc92db8))

## Flow
1. Admin opens members list; each row has an overflow menu or Remove action (Clay, Notion, Churnkey).
2. Clicking Remove opens a small modal titled with the specific person ("Remove Jane D from #design?", "Remove jsmith.mobbin@gmail.com?").
3. Body is a single sentence stating the consequence: "They will no longer have access to this workspace" (Assembly, Current, Whop); Notion adds data fate: "They will immediately lose access … and no one will be able to access their private pages"; Slack adds reversibility: "They'll still be able to rejoin, or be added to the conversation"; Krea adds billing fate: "If they have a plan it will be cancelled. This cannot be undone."
4. Cancel (neutral) + destructive red Remove button.
5. On success: row disappears; Clay shows a success toast ("Successfully removed … from workspace").

## Use when
Removal is reversible (re-invite possible) and the member's org data stays with the org; the consequence fits in one or two sentences.

## Avoid when
Removal destroys or orphans data, cancels billing, or transfers content — those need an explicit consequences list or a transfer choice, not one line.

## Sad paths observed
Krea AI surfaces the member's active plan being cancelled inside the confirm; Whop states the user "will need to be reinvited" (re-entry path made explicit).

## Accessibility
Standard modal with two buttons; destructive action is the rightmost, color-differentiated red button in every example; Notion uses stacked full-width buttons (destructive on top).

## Default verdict for our stack
RECOMMENDED — maps directly to shadcn AlertDialog; one truthful data-fate sentence ("Their events and work stay with the org; they can be re-invited") meets the Linear/Vercel bar without ceremony.
