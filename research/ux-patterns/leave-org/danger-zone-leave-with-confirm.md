# Pattern: Danger-zone "Leave workspace" with consequence confirm
**Surface:** leave-org · **Observed in:** Notion (refs: [flow](https://mobbin.com/flows/7959317d-41b6-4140-a318-e3329f4ee400), [confirm dialog](https://mobbin.com/screens/1bc1d1e4-32eb-47c1-b0ef-65afdbca7c31), [danger zone](https://mobbin.com/screens/a81dcc97-2027-42f5-80a1-ea39065ddd86), [teamspace variant](https://mobbin.com/screens/06c78757-1f7c-43be-9fe8-46a71c2049f5))

## Flow
1. Settings → General scrolls to a "Danger zone" section listing "Leave workspace" beside "Delete workspace", each with its own description and red-tinted button.
2. The row description carries the consequence: "Remove your account from this workspace. You'll lose access to the workspace and all of its content, including your own pages."
3. Clicking opens a minimal confirm: "Are you sure you want to leave the samlee's Space workspace?" with stacked Leave (red-tinted) / Cancel buttons.
4. On confirm the user is ejected from that workspace and lands in another workspace / neutral context.
5. Teamspace variant repeats the shape one level down, with softer consequence copy: "You'll no longer see this teamspace in your sidebar and you may lose permissions to the teamspace's pages."

## Use when
Leave is a rare, deliberate action and you want it discoverable in exactly one predictable place, adjacent to other destructive org actions.

## Avoid when
The product expects frequent multi-org hopping where leave belongs on the org card/list itself (see inline-leave pattern); or when the leaver is the last owner — Notion's dialog shows no last-owner branch (gap; see last-admin-guard surface).

## Sad paths observed
Consequence copy warns the member's own pages stay behind ("including your own pages") — loss of self-created content is disclosed before confirm. No last-member or last-owner special case observed.

## Accessibility
Confirm uses stacked full-width buttons, destructive first; danger-zone rows pair each red button with a plain-text explanation rather than icon-only affordances.

## Default verdict for our stack
RECOMMENDED — danger-zone placement in org settings + AlertDialog with explicit access-loss copy is the cleanest fit for a fail-closed tenant model; wire the last-admin case to the last-admin-guard pattern instead of letting this dialog submit.
