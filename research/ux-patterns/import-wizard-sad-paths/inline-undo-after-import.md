# Pattern: Inline undo link on the import success banner
**Surface:** import-wizard-sad-paths · **Observed in:** Squarespace, Attio (refs: [Squarespace flow](https://mobbin.com/flows/bf9cd7c9-5ca6-4362-b231-662e7f15f2b1), [Squarespace banner](https://mobbin.com/screens/d8fefd3b-5562-4898-a81f-9a81d38b7838), [Squarespace confirm](https://mobbin.com/screens/1e823e62-3928-4cf2-9354-0fd4e4a62f13), [Attio delete-import confirm](https://mobbin.com/screens/52160735-55ab-4600-a72b-1b29ab6b93cf))

## Flow
1. Import completes; a green banner on the Import/Export page reads "Successfully imported 1 client (undo)" — the undo is a parenthetical link inside the success message itself (Squarespace).
2. Clicking undo opens a small confirm popover anchored to the link: "Are you sure you want to remove this imported client? OK / Cancel."
3. Confirming removes the records the import created; the banner is dismissible with an X if the user is happy.
4. Attio's adjacent variant: from the Import history row's overflow menu, deleting an import raises "Are you sure? This import will be permanently deleted, this cannot be undone" with red Confirm.

## Use when
- Small imports where regret is immediate ("wrong file" realized seconds after commit) — zero navigation cost to undo.
- As a complement to history-based revert, not a replacement: the banner dies with the session.

## Avoid when
- Large multi-object imports — a one-line undo link understates the blast radius; route users to a detail view (Pipedrive-style) that shows what will be deleted.
- The undo's own irreversibility isn't explained — Attio's "this cannot be undone" on the delete-the-import action is the necessary second-order warning.

## Sad paths observed
- Double-confirm kept lightweight: popover, not modal, for a 1-record import (Squarespace).
- Undo affordance disappears once the banner is dismissed — the only observed recovery is the history page.
- Deleting an import record vs deleting imported records is ambiguous in Attio's copy ("This import will be permanently deleted") — copy must say which one happens.

## Accessibility
- Undo link is text inside the live-region success message — ensure the banner is announced and the link is reachable by keyboard before auto-dismiss.
- Confirm popover has explicit OK/Cancel text buttons.
- Don't rely on green alone for success; Squarespace pairs color with full-sentence copy.

## Default verdict for our stack
VIABLE — cheap goodwill for small imports, but only as a shortcut layered on top of the revert-from-history mechanism; copy must state record counts so users know what undo deletes.
