# Pattern: Inline role dropdown on the member row
**Surface:** change-role · **Observed in:** Notion, Vercel, Exa, Coda, Sana AI, Current (refs: [Notion](https://mobbin.com/screens/c77d2a3a-7556-4f27-857a-3e7960411086), [Vercel](https://mobbin.com/screens/2bc2dd79-8a1f-4223-b006-61d22aed073e), [Exa flow](https://mobbin.com/flows/2fb3b980-3b0a-43de-975c-d1a63454eff7), [Coda flow](https://mobbin.com/flows/7e68441c-3c40-4431-b4be-5b67cecabc3e), [Sana AI flow](https://mobbin.com/flows/25e08ff3-d61d-44d9-ada3-d2d2e21ee493), [Current flow](https://mobbin.com/flows/a081cb1c-ffb7-436e-b1b1-387a829e9f74))

## Flow
1. The Role cell renders as a dropdown trigger ("Member ▾") directly in the row — no edit mode, no navigation.
2. Open menu lists roles with permission descriptions (Notion: "Member — Cannot change workspace settings or invite new members…"; Exa: full capability sentences) and check-marks the current role.
3. Select → saves immediately; feedback via toast (Coda: "Role updated — 1 member's role was updated.") or silent cell update with status badge context (Exa).
4. Notion appends "Remove from workspace" as the menu's final, separated item.
5. Permission-aware rendering: Vercel shows the dropdown only on rows the viewer can edit — own/owner rows render as static text ("Owner" plain for self).

## Use when
- Role changes are frequent and low-ceremony (default for Member↔Ops-grade flips).
- The roles carry descriptions in the menu (see B5 role-picker card) so the dropdown is self-explanatory.

## Avoid when
- Every change needs confirmation — pair with a confirm dialog for escalations/demotions instead of making the dropdown itself heavier.
- The viewer lacks permission: render static text, never a disabled-looking dropdown (Vercel's static-self treatment).

## Sad paths observed
- Coda's toast quantifies the change ("1 member's role was updated") — verifiable feedback.
- Vercel's static-text-for-self silently enforces a self-change guard at the control level.

## Accessibility
- Menu-button with check-marked current option; descriptions read with options. Static text for non-editable rows avoids confusing disabled controls.

## Default verdict for our stack
RECOMMENDED — shadcn DropdownMenu in the Role cell with described options, permission-gated to static text, + confirm dialog only on privilege boundaries (see role-change-confirm card).
