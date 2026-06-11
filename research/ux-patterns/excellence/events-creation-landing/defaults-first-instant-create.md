# Pattern: Defaults-first instant create (the form IS the page)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/flows/70a3e849-a039-482e-a704-c59c6ae1bea2, https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b), Luma iOS (https://mobbin.com/flows/08f11f1e-3068-45bd-9cb2-1c386f625901), Posh web (https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9)

## Flow
1. "Create event" lands on a screen that IS a draft of the public page, not a boxed form: cover art already populated (generated gradient/poster), theme set, giant ghost-text title ("Event Name"), date/time prefilled (today + next slot, end auto-set after start), timezone detected, visibility "Public", tickets "Free", capacity "Unlimited".
2. Section headers read as questions ("Where is the event taking place?", "When will it happen?") — conversation, not schema.
3. Options are rows with edit affordances (pencil/chevron), not exposed inputs: Tickets · Require Approval · Capacity.
4. One CTA ("Create Event"). A valid event is literally one title keystroke away.
5. Post-create lands on the manage hub with toast "Event created successfully! Taking you to the manage page..." — page exists, link exists, share is the next move.
6. Posh variant: single scrolling dark form with a permanently visible flyer preview rail — you style the artifact while filling the data.

## Use when
The event entity has sensible defaults for nearly everything and speed-to-page is the product's promise. Ideal when most events are simple and configuration can happen post-create on the manage surface.

## Avoid when
Required compliance/config fields genuinely block page existence (paid tax settings, legal disclaimers), or the org's events are long-lived structured programs where a deliberate setup pass prevents expensive misconfiguration — then use a checklist builder (see checklist-builder.md) with defaults inside each step.

## Sad paths observed
- Defaults design away empty-required-field errors — no error states appear in any observed create flow.
- Luma iOS shows a time conflict as the end-time value turning red inline in the wheel picker, non-blocking.
- Posh defers date validation (end-before-start visible mid-edit with no inline error) — observed as the anti-pattern to avoid.

## Accessibility
Ghost-text title is a real input with label; option rows are buttons with text labels + leading icons; wheel pickers inline on mobile (no modal stacks).

## Default verdict for our stack
RECOMMENDED — conference coordinators creating their Nth event need speed; defaults (org timezone, free registration, unlimited capacity, generated cover) + question-style sections directly fix the old app's bare 6-field form, and venue fields finally live at create time.
