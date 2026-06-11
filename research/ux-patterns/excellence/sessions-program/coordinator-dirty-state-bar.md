# Pattern: Dirty-state sticky bar (Discard / Save) instead of exit modal

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** User Interviews, Jira (refs: [UI availability grid](https://mobbin.com/screens/11470727-6632-40ef-aa43-bce674f3b4b7), [Jira unsaved pill](https://mobbin.com/screens/624820e8-d6fe-4107-bc8d-5bc9df81cd85))

## Flow
1. While grid edits are uncommitted, a persistent bar/pill appears: sticky footer "× Discard changes / Save changes" (User Interviews) or header pill "Unsaved changes" (Jira).
2. The bar stays through scrolling and further edits — dirty state is ambient, not discovered at exit time.
3. Saving or discarding dismisses it; navigation away is where the bar earns its keep (no surprise modal).

## Use when
Batched grid editing — paint availability, drag several sessions, THEN commit once. The bar is the contract that nothing is live yet.

## Avoid when
Every action auto-saves (Motion/Amie model) — mixing auto-save and a dirty bar confuses which edits are committed.

## Sad paths observed
- The pattern exists to kill the exit-modal sad path ("you have unsaved changes" ambush).

## Accessibility
The bar is a landmark-positioned region with two labeled buttons; state is announced by its appearance.

## Microcopy worth stealing
"Discard changes / Save changes" · "Unsaved changes"

## Default verdict for our stack
RECOMMENDED (decide save model first) — if the schedule grid batches edits before hitting the optimistic-concurrency layer, this bar is the shape; if every drag commits immediately (receipt-toast model), skip it. The two models must not mix.
