# Pattern: Pre-filled identity, questions-only form on personal link
**Surface:** tokened-access-landing · **Observed in:** Luma (refs: https://mobbin.com/screens/285818cd-c1e8-4b63-9e8f-8e77a8471df5, https://mobbin.com/screens/f3e54997-7bc9-4347-a576-d369bf4dd693, https://mobbin.com/screens/7b2c8f55-8bc8-4383-ac22-b9dd8703f8ef), Partiful (ref: https://mobbin.com/screens/50f3ad55-f0b0-4f28-b1b9-dd58550f3b64), Sana AI (ref: https://mobbin.com/screens/8d33905f-cb89-432b-9c0e-6b32aef4a837)

## Flow
1. Registrant opens form from their link; "Your Info" header shows avatar + name + email as read-only context — identity is asserted, not asked.
2. Only the host-configured custom questions render below (e.g., "Is this your first time attending a RubySG meetup?" required dropdown).
3. Single "Register"/Submit button; one screen, no wizard for short question sets.
4. Organizer side (evidence of the model): Luma/Partiful question builders mark Name + Email as always-required system fields, custom questions typed (text/checkbox/terms) with per-question Required flags; Partiful pitches "Collect emails, dietary restrictions, anything!".
5. Sana AI variant (identity NOT known): flat single-card form — email, name, company, job title, "Food preferences or allergies", marketing consent checkbox, Submit.

## Use when
- Attendee fills travel/dietary/bio details via personal link: token resolves identity, so the form asks ONLY the unknown fields.
- Question sets are organizer-configurable — store as typed question definitions (text/select/checkbox/terms + required flag) like Luma's builder.

## Avoid when
- More than ~8-10 fields (travel + documents + dietary) — switch to the progressive task-card pattern (see save-and-finish-later card) instead of one long scroll.
- Never re-ask name/email on a tokened link "to verify" — that breaks the no-account promise; verification belongs at the token layer.

## Sad paths observed
- Required-question validation implied by required flags; no explicit error states captured on Mobbin for these forms (gap).
- Sana shows explicit consent checkbox for marketing — separate consent from submission.

## Accessibility
- Read-only identity block must still be exposed as text (it is), not an image.
- Single-column, label-above inputs throughout all observed examples — keep it.

## Default verdict for our stack
RECOMMENDED — the core of sub-area (d): token resolves who, form asks only what's missing; organizer-defined typed questions, one screen for short sets.
