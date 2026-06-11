# Pattern: Dependency links between timeline bars

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Linear (refs: [timeline dependencies](https://mobbin.com/screens/39048d90-578a-4eda-abe7-69427e17502b))

## Flow
1. An arrow drawn between two timeline bars expresses ordering; a context menu manages it: "Blocking → [item]" / "× Remove dependency".
2. The dependency is visible on the grid itself — sequence constraints aren't hidden in item metadata.

## Use when
True sequence constraints exist: "Part 2 follows Part 1", a wet-lab requiring its setup block, sub-sessions ordered within a parent symposium.

## Avoid when
General agendas — most conference sessions are independent; dependency chrome on every bar is overkill (Linear uses it for project work, not calendars).

## Sad paths observed
- None captured; the implicit one (moving a blocker past its dependent) was not observed.

## Accessibility
The relationship exists in the menu ("Blocking…") as text, not only as a drawn arrow.

## Microcopy worth stealing
"Blocking" · "Remove dependency"

## Default verdict for our stack
AVOID for V1 — the existing parent/child (one-level) session nesting covers the real need; revisit only if multi-part sessions with strict ordering become a complaint.
