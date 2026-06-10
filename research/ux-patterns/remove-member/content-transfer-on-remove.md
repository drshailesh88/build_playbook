# Pattern: Content transfer offered at removal time
**Surface:** remove-member · **Observed in:** Canva, Amplitude, Mural (refs: [Canva](https://mobbin.com/screens/d34c229c-37ac-47d9-9c7d-f28c82443125), [Amplitude](https://mobbin.com/screens/c86b2e69-f643-45f7-909f-3dd5589b18b9), [Mural](https://mobbin.com/screens/8838fac5-7c90-4088-a1f9-7c3f8ea920e7))

## Flow
Three variants of the same idea — decide the fate of the leaver's content inside the remove step:
1. **Inline checkbox (Amplitude):** confirm dialog contains "Transfer content edit access to other members" checkbox; admin ticks it, then Remove.
2. **Pointer to transfer flow (Canva):** dialog states "Once these people are removed you'll no longer have access to their saved designs and content," then a callout: "Would you like to keep their designs and content? … Turn on ownership transfer in Permissions, then select one person at a time to remove. Go to Permissions."
3. **Automatic transfer to remover (Mural):** dialog states the user will be removed "and you (samlee@…) will become the owner of their murals, templates, and rooms. You will receive an email with more details." Button: "Remove and transfer".

## Use when
Members own content that would otherwise be lost or stranded on removal, and the org wants to retain it.

## Avoid when
All content is org-owned anyway (transfer is a no-op and the extra choice is noise); avoid Canva's variant — bouncing the admin out to a separate Permissions page to do the safe thing adds abandonment risk.

## Sad paths observed
Canva's dialog is itself the sad path warning: remove without transfer = permanent loss of access to that member's content. Mural removes the choice entirely (always transfers) and confirms by email.

## Accessibility
Amplitude's checkbox is a small unlabeled-group control inside the dialog; Mural's single explicit button text ("Remove and transfer") announces the compound action plainly.

## Default verdict for our stack
AVOID (for v1) — Event State's events/tasks are org-scoped, so removal should not orphan anything; Mural's auto-reassign line is the fallback to copy if we ever add personal drafts.
