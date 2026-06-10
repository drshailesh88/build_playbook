# Pattern: Parent Grants Override, Child Shows "Controlled at Parent" Default
**Surface:** multi-scope-settings-ia · **Observed in:** Vercel, Cursor, GitLab (refs: [Vercel team-side toggle](https://mobbin.com/screens/f085cf74-1b25-4b2c-9e90-05b76e437d0e), [Vercel project-side dropdown](https://mobbin.com/screens/c681207e-c335-4e34-96a2-018cfa69baff), [Cursor installation defaults](https://mobbin.com/screens/a1caf968-ed6d-49fc-b754-f92f0ceedc33), [GitLab override policy](https://mobbin.com/screens/1208b9fc-c774-445b-8e1e-35c762c0c1f8))

## Flow
1. Team-side (Vercel, "Vercel Toolbar" card): the setting's dropdowns read "Default (on)" and beneath them sits an explicit toggle — "Allow this setting to be overridden on the project level: Enabled". The parent decides whether children may diverge at all.
2. Project-side (Vercel, "Preview Comments" card): the same setting renders as a dropdown whose selected value is "Default (controlled at the team level)" — inherited state is a first-class, named option, not an empty field.
3. Overriding = picking a concrete value from that dropdown; reverting = re-selecting the "Default (…)" option. No separate inherit/override mode switch.
4. Cursor's variant: every org-governed repo setting defaults to a "Use Installation Default" / "Use Installation Defaults" dropdown value, with helper text naming the source ("Using your organization's default autofix settings").
5. GitLab's policy variant warns at override time: "If selected, the following choices will overwrite project settings … for approval rules created by this policy" — override is a deliberate, consequence-labelled act.

## Use when
- Per-event settings inherit org defaults (our sender display name, module toggles, branding) — the dropdown-with-named-default makes the three states (inherit / overridden / parent-locked) all visible in one control.
- The org needs a lockdown lever: the parent-side "allow override" toggle is the cleanest governance primitive observed.

## Avoid when
- The setting is free-text or structured (branding JSONB, templates) rather than enumerable — a dropdown can't host "Default (…)" plus a rich editor; use the override-table pattern instead.
- There is no real org-level default yet; showing "controlled at the team level" for a value nobody set reads as broken.

## Sad paths observed
- Vercel disables the Save button on the project card until the value diverges from the inherited default — prevents no-op override writes.
- GitLab pairs override with "Fallback behavior in case of policy failure (Fail open / Fail closed)" — the override UI forces a decision about what happens when the parent rule can't be evaluated.

## Accessibility
- Inherited state is conveyed in the option's TEXT ("Default (controlled at the team level)"), not color or icon alone — screen-reader safe.
- Helper text under Cursor's dropdowns names the inheritance source explicitly.

## Default verdict for our stack
RECOMMENDED — adopt the pair: org-side "allow event override" toggle + event-side select whose first option is "Org default (current: X)"; it is the exact Vercel mechanic our team→event model mirrors.
