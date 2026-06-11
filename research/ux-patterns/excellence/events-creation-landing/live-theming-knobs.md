# Pattern: Live theming knobs over the real page (theme × color × font × display)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/flows/05561321-93a6-4d22-afb4-6b93137dac47, https://mobbin.com/flows/319afbe7-1939-4ada-ae3c-61a3b4d61bf0), Partiful iOS (https://mobbin.com/screens/881a2632-2dbe-465f-8668-bfe1f1009bcd, https://mobbin.com/screens/3717646b-48a9-43ab-ba27-6a7f020c308c), Posh web (https://mobbin.com/screens/750bfd6e-a317-4830-a40c-dc37ef81f3d1), analogous: Later (https://mobbin.com/screens/b7e5ca04-adf4-4d1c-90cd-5b7c941d1602), SavvyCal/Gamma/Linktree (https://mobbin.com/screens/33df18e6-c18e-4294-9c67-291eed7619f3, https://mobbin.com/screens/d5cb7477-bb1c-4fb0-b818-9221545de6cc, https://mobbin.com/screens/71e1d21b-1c93-4745-8b63-e4827a0fff8d)

## Flow
1. Theming opens as a tray/dock OVER the live page, never a separate screen: theme thumbnails in a row (Minimal / Quantum / Warp / Emoji / Confetti / Pattern / Seasonal), selection restyles the ENTIRE page instantly behind the tray (Luma).
2. Four orthogonal knobs, each a labeled stepper: "Color / Style / Font / Display (Dark·Light)" — combinatorial range from few controls.
3. Typography as named personalities rendered in their own typeface: "Classic / Eclectic / Fancy / Simple" tabs directly under the live title (Partiful) — no font list, zero preview step.
4. Minimal variant: two knobs only — "Title Font" + "Accent Color" hex swatch reflecting on a live flyer preview (Posh).
5. Color customization uses NAMED ROLES, not raw palettes: Background / Text and Icon / Accent / Button Text rows (Later); contrast guardrails appear as auto-adjustment notes ("text colors may be lightened or darkened for contrast and accessibility" — Gamma) or inline ⚠ warnings on risky tints (Linktree).
6. Re-theming stays available on LIVE events from the edit drawer (Luma "Appearance" section).

## Use when
The public page is the product and organizers want per-event identity without design skills. Named roles + guardrails are mandatory the moment you allow custom colors.

## Avoid when
Multi-tenant brand governance requires tenant-level consistency — then expose a curated tenant-approved theme set, not free hex pickers. Skip animated effects for professional/medical audiences.

## Sad paths observed
- Unreadable color combos: only Linktree (⚠ icon) and Gamma (auto-adjust note) handle this; everyone else lets you ship low contrast — design the guardrail in.
- No save step in Luma's tray (instant apply) — needs undo or it's a footgun on live pages.

## Accessibility
The contrast guardrail IS the accessibility feature; "Display: Dark/Light" respects user preference when set to match (SavvyCal "Match user preferences").

## Default verdict for our stack
VIABLE — V1 should bind the landing page to tenant `branding` (logo, palette) with 2–3 curated theme variants and automatic contrast enforcement; the full four-knob live tray is V2 polish. Never raw hex without a contrast check.
