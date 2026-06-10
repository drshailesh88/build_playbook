# Pattern: Role edit inside a member detail panel/modal
**Surface:** change-role · **Observed in:** Whop, 1Password (refs: [Whop flow](https://mobbin.com/flows/f4380728-e65f-44c4-a4d2-5b380103f966), [1Password Person Details](https://mobbin.com/flows/18b64277-b032-44f9-85ef-9af58f24081f))

## Flow
1. Clicking a member opens a detail surface (Whop: centered modal; 1Password: full Person Details page) showing identity, memberships, activity, and stats.
2. A "Team" section holds the role select (Whop: Owner / Admin / Sales Manager / Moderator dropdown) with the current role badged on the section header.
3. Changing the role saves with a toast ("Settings have been saved successfully") and may chain into a confirm dialog ("Are you sure you want to change their role?" — [Whop](https://mobbin.com/screens/661e0854-e759-4525-9f95-80a4378ee1b3)).
4. Destructive "Remove from team" lives in the same panel, styled red, below the role control.
5. 1Password's page adds an activity timeline and per-person state actions (Confirm/Reject, Delete) — role/state management co-located with audit context.

## Use when
- Members have rich per-person context worth a page (activity, billing, devices, event assignments) and role is one of several editable attributes.
- Audit trail should be visible at the point of change.

## Avoid when
- Role is the only editable attribute — forcing a detail-panel detour for a one-field change is slower than the inline dropdown (Notion/Vercel model).

## Sad paths observed
- Whop keeps Remove visually quarantined (full-width red button) from the role select — no adjacency mis-clicks.
- 1Password shows last-access and linked devices beside the controls — evidence for "should this person still be an admin?".

## Accessibility
- Form controls in a labelled section; modal variant needs focus trap. Red removal button is text-labelled.

## Default verdict for our stack
VIABLE — we'll likely grow a member detail page (event assignments per person), and role edit should appear there too; but it complements, not replaces, the inline row dropdown.
