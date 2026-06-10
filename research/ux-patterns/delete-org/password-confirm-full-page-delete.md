# Pattern: Full-page deletion with password + acknowledgement + off-ramps
**Surface:** delete-org · **Observed in:** Slack (refs: [Slack](https://mobbin.com/screens/596ce9b6-5e27-433e-b93f-faac2ce040c8))

## Flow
1. Deletion is a dedicated page, not a modal: "You are deleting Jsmith Mobbin".
2. Two warning callouts offer off-ramps before the form: "Important Note! If you just want to change your workspace's name or URL, you can do that from your Settings page. You also might want to export your data before deleting" and "Planning to re-use this URL? Workspace URLs can take some time to become available after deletion…".
3. "Confirm Deletion" card: acknowledgement checkbox ("I understand that all of my workspace's messages and files will be deleted.") + Slack password field (with helper distinguishing it from SSO passwords and a reset link).
4. "Yes, delete my workspace" (red) + Cancel.

## Use when
Deletion deserves a full page: you want room for export-your-data prompts, mistaken-intent off-ramps ("you might just want to rename"), and slug-reuse caveats.

## Avoid when
Password-only confirmation excludes SSO/passwordless users (Slack needs a helper paragraph to explain which password — a smell); a modal suffices when there are no off-ramps to present.

## Sad paths observed
Richest mistaken-intent handling observed: rename-instead, export-first, and URL-reuse timing are all addressed before the form; password-reset link handles the forgot-password case inline.

## Accessibility
Full-page layout with checkbox before password gives a linear, form-like tab order; helper text is attached to the password field.

## Default verdict for our stack
AVOID as a whole (password gate clashes with headless multi-method auth), but steal the off-ramps: an "export your data first" line and "want to rename instead?" link belong in our delete dialog.
