# Pattern: Draft-vs-published visual encoding per grid cell

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** 7shifts, Deputy (refs: [7shifts striped chips](https://mobbin.com/flows/a188ab96-5d5c-4917-bb42-e27d16942411), [Deputy grey→green chips](https://mobbin.com/flows/a426e08b-cd76-4cd5-a684-0830b4744e1d))

## Flow
1. Every schedule chip encodes its publish state visually: unpublished/changed = diagonal-striped chip (7shifts) or grey chip (Deputy); published = solid/green.
2. The encoding is per-cell, so PARTIAL drift (3 edited sessions among 200 published) is scannable at a glance.
3. Header surfaces the aggregate: "Multiple last published dates" (7shifts) when different parts of the schedule were published at different times.

## Use when
A draft/publish model where edits accumulate between publishes — the coordinator's constant question is "what have I changed since the live version?"

## Avoid when
You have true versioned diffs at publish time — per-cell encoding complements but doesn't replace a session-level diff review (see publish-diff-adjacency card).

## Sad paths observed
- "Multiple last published dates" — the honest mixed-state indicator most tools hide.

## Accessibility
Stripes/pattern fill (not hue alone) distinguishes unpublished; the Deputy legend names every state.

## Microcopy worth stealing
"Multiple last published dates"

## Default verdict for our stack
RECOMMENDED — the old app's live tables vs published snapshot are invisible to the coordinator until they hit Publish; striped "changed since v3" chips on the schedule grid make version drift ambient. Pairs with the quantified-publish card.
