# Pattern: "Log out of other devices" checkbox on password change
**Surface:** account-settings · **Observed in:** Mercury, Later (refs: [Mercury](https://mobbin.com/screens/c08fed01-cf86-4c26-9eba-b0eb0a078960), [Later](https://mobbin.com/screens/e0530c01-9121-44a0-a964-136c015baf75))

## Flow
1. Within the change/reset-password form, below the password fields, a checkbox: Mercury "Log out of all other devices" (with info tooltip icon), Later "Sign out from other devices".
2. Checkbox is pre-checked by default in both observed apps.
3. Submitting saves the new password and (if checked) revokes every session except the current one in the same action.

## Use when
- Always offer on password change — the dominant reason users change a password is suspected compromise, and this is the moment to kill hijacked sessions. Default-checked is the safer default.

## Avoid when
- Don't make revocation unconditional/invisible — users changing a password routinely (not compromised) may want other devices kept signed in; the checkbox preserves choice.

## Sad paths observed
- Mercury attaches an info tooltip to the checkbox explaining the consequence before commit — consequence disclosure at the point of decision.

## Accessibility
- Standard labeled checkbox adjacent to the action it modifies; tooltip content must also be reachable by keyboard (not hover-only) — not verifiable from stills.

## Default verdict for our stack
RECOMMENDED — Better Auth exposes revoke-other-sessions; one pre-checked checkbox on the password form is cheap and directly answers our active-session-handling requirement.
