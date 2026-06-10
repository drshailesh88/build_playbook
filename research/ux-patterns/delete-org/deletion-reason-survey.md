# Pattern: Exit survey before workspace deletion
**Surface:** delete-org · **Observed in:** Notion (refs: [Notion](https://mobbin.com/screens/1ebb0d66-8334-4931-8648-963f7410e71d))

## Flow
1. User clicks "Delete workspace" in the danger zone.
2. Before the destructive confirm, a modal asks "We'd love your input to help us make Notion better for everyone — Let us know why you're deleting your workspace" with checkbox reasons (Missing features, Not using it enough, Consolidating Notion workspaces, Too expensive, Switching to another tool, Too difficult to use, Other).
3. Continue advances to the actual deletion confirm; Cancel aborts everything.

## Use when
Churn-reason data is strategically vital and the survey is a soft, skippable step that never blocks the deletion.

## Avoid when
It delays a user who has already decided — every screen between intent and completion of a destructive action they're entitled to perform erodes trust; never make reasons required.

## Sad paths observed
None beyond the coupling problem: Cancel abandons both survey and deletion together.

## Accessibility
Checkbox group + full-width Continue; Cancel as secondary text button.

## Default verdict for our stack
AVOID for v1 — capture org-deletion events server-side instead; reconsider only as an optional single question once there's real churn volume to learn from.
