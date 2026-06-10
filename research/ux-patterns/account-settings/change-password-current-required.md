# Pattern: Change password — current password + new + confirm, with requirements surfaced
**Surface:** account-settings · **Observed in:** Airbnb, Origin, Gorgias, Cohere, Dub, Patreon (refs: [Airbnb](https://mobbin.com/screens/4a204456-6e27-4fec-aed4-417b35a6f80e), [Origin](https://mobbin.com/screens/7eade741-c014-4d64-817b-14a1aff283bb), [Gorgias](https://mobbin.com/screens/cbb2ad18-b1bc-4ee6-89b4-e9cf993b469a), [Cohere](https://mobbin.com/screens/bd35ca3a-9879-448c-83ad-e31a268a1181), [Dub](https://mobbin.com/screens/12d996e1-8a03-4253-8e2b-04e46e8ed103), [Patreon](https://mobbin.com/screens/44c846a2-e24b-40f1-9295-7c74e9a29c21))

## Flow
1. In Security/Login settings: "Current password" field first, then "New password", then "Confirm password" (Dub omits confirm — two fields only).
2. Password requirements are visible before failure: bullet checklist (Origin: 1 uppercase, 1 lowercase, 1 number, 8–64 chars, 1 special), inline hint (Gorgias: "minimum of 14 characters…"), link (Dub: "Password requirements"), or live strength meter (Cohere: segmented bar + "Too weak" label).
3. All fields have show/hide eye toggles (Dub, Origin, Cohere).
4. Submit button ("Update password" / "Save changes") stays disabled until fields are filled/valid (Dub, Origin).
5. Escape hatch for forgotten current password: Airbnb "Need a new password?" link adjacent to the current-password field.

## Use when
- Account has a password credential. Current-password requirement is the baseline defense against session-theft password swaps.

## Avoid when
- OAuth-only accounts (no password exists — show "Add password" instead, as Notion does: [ref](https://mobbin.com/screens/aa59f603-76b1-49d1-82e7-9932068618fe)); avoid burying requirements behind error states only.

## Sad paths observed
- Requirements shown proactively (Origin checklist, Cohere meter) rather than as post-submit errors — the failure is prevented, not reported.
- Airbnb embeds the forgot-password path directly in the form so a forgotten current password doesn't strand the user.

## Accessibility
- Show/hide toggles need accessible names; Origin's static checklist is more screen-reader-friendly than color-only strength meters; Cohere pairs the meter with a text label ("Too weak") — keep the text.

## Default verdict for our stack
RECOMMENDED — the consensus pattern; implement with current+new+confirm, proactive requirement checklist, disabled-until-valid submit, and a forgot-password escape hatch.
