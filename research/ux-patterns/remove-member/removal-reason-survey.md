# Pattern: Reason survey interjected into member removal
**Surface:** remove-member · **Observed in:** Notion (refs: [Notion flow](https://mobbin.com/flows/8449d0f1-05f5-4656-b45a-e5507e29d9c4))

## Flow
1. Admin chooses "Remove from workspace" on a member row in Settings → People.
2. Before (or alongside) the removal confirm, a modal asks "Why are you removing this member from your workspace? We'd love your input to make Notion better" with checkbox reasons (Not using it enough, Switching to another tool, No longer works here, Too expensive, Switching to another Notion workspace, Other + free text).
3. Continue proceeds with removal; Cancel aborts.

## Use when
Seat changes are a churn signal the business genuinely acts on, and the survey is skippable.

## Avoid when
Almost always for a B2B admin tool — it inserts vendor-serving friction into an org-management task; admins removing many members hit it repeatedly.

## Sad paths observed
None observed beyond Cancel abandoning the whole removal (survey and action are coupled — declining feedback means redoing the removal).

## Accessibility
Checkbox group with an Other free-text field; primary Continue is full-width, Cancel is a text link below.

## Default verdict for our stack
AVOID — telemetry can capture seat churn without taxing the admin; conflicts with the fast, respectful Linear/Vercel feel.
