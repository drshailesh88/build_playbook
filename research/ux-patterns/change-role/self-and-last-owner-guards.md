# Pattern: Self-demotion and last-owner guards
**Surface:** change-role · **Observed in:** Asana, Mural, Sana AI, Vercel, Base44 (refs: [Asana](https://mobbin.com/screens/d9b3d4f9-b055-44cc-94b9-961ee6385917), [Mural remove+transfer](https://mobbin.com/screens/8838fac5-7c90-4088-a1f9-7c3f8ea920e7), [Mural choose-new-owner](https://mobbin.com/screens/e79a2051-98b6-44fb-b04d-383508263929), [Sana AI](https://mobbin.com/screens/aa4daa1b-8f70-4583-9281-c56c4eca220a), [Vercel self-row](https://mobbin.com/screens/2bc2dd79-8a1f-4223-b006-61d22aed073e), [Base44](https://mobbin.com/screens/0ca362f4-9c08-4294-a281-3528c9144eba))

## Flow
1. Hard block with reason: Asana — dialog "Cannot remove yourself from the workspace. You are currently the billing owner for this workspace. Billing owners must remain members." (the action is allowed to start, then explained — not silently disabled).
2. Control-level prevention: Vercel renders the viewer's own role as static text while other rows get dropdowns — self-change is impossible by construction.
3. Forced succession: Mural's "Leave workspace" requires "Choose a new owner for your murals, templates, and rooms" via typeahead before Continue enables; removing an owner states "you (samlee@gmail.com) will become the owner of their murals…" with "Remove and transfer".
4. High-friction confirmation: Sana AI's leave dialog explains data loss, warns "If you are the only member… it will be automatically deleted", and requires typing "leave" to enable Confirm.
5. Notification of record: Mural — "You will receive an email with more details" after ownership transfer.

## Use when
- Any tenant must always retain ≥1 owner/super-admin: guard self-demotion of the last admin, self-removal, and owner departure — directly required by our Super Admin role.

## Avoid when
- Don't hard-block where succession solves it: Mural's transfer-then-leave beats Asana's dead-end when another eligible member exists. Reserve hard blocks for the truly impossible (zero other admins).

## Sad paths observed
- This card is entirely sad-path: last-owner removal, orphaned assets, sole-member workspace deletion, and email audit trails for ownership transfer.

## Accessibility
- Block dialogs explain cause + remedy in text; type-to-confirm inputs are labelled; typeahead succession picker is a standard combobox.

## Default verdict for our stack
RECOMMENDED — enforce server-side (last-admin invariant), render self-row role as static text (Vercel), and offer transfer-ownership flow on owner exit; type-to-confirm reserved for org deletion.
