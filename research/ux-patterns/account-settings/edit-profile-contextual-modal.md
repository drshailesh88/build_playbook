# Pattern: Edit profile in a contextual modal with explicit Cancel/Save
**Surface:** account-settings · **Observed in:** Slack (refs: [edit-your-profile modal](https://mobbin.com/screens/10f59803-4ce6-45ed-b0f8-62a16a48ba85), [filled variant](https://mobbin.com/screens/8ac978ea-6d97-44c7-964f-c6cf4f1d8937))

## Flow
1. From the profile card/panel (visible beside the working context), user clicks Edit.
2. A single modal contains the whole profile form: Full name, Display name, Title, Pronouns, Time zone, plus photo upload — each field with a one-line explanation of where it's used ("This could be your first name, or a nickname — however you'd like people to refer to you").
3. Footer: Cancel + Save Changes; the whole form commits atomically.
4. Modal closes back to the unchanged underlying context.

## Use when
- Profile fields are interrelated and reviewed together; profile editing is reachable from many places (member lists, mentions) and shouldn't navigate away; identity fields benefit from per-field explanations (display name vs full name in a multi-tenant directory).

## Avoid when
- Profile includes heavy sub-flows (email change with verification, password) — those need their own gated flows, not a bundled modal; form is long enough to scroll awkwardly inside a dialog.

## Sad paths observed
- None visible in stills; atomic Cancel/Save means abandoned edits are cleanly discarded.

## Accessibility
- One dialog, linear field order, explicit footer buttons — straightforward focus trap; per-field helper text gives accessible descriptions.

## Default verdict for our stack
VIABLE — good companion for editing display identity from member-directory contexts, but our primary profile editing belongs in the settings page; don't make this the only path.
