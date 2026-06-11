# Pattern: Draft-first lifecycle (save-draft primary, TBD date, autosave)

**Surface:** events-creation-landing · **Observed in:** Partiful web (https://mobbin.com/flows/2055aff1-04b5-4ab3-8541-7b63e604fc54, https://mobbin.com/flows/e2ff50a1-4c52-40aa-9d5e-7459df74393d), Circle web (https://mobbin.com/flows/ee6120bf-4cf7-42da-bc1e-3f123208af79), Eventbrite web (https://mobbin.com/flows/3b85f96b-28c4-44eb-b4f6-658c1f971c23), Aboard web (https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c)

## Flow
1. The only CTA on the create modal is "SAVE DRAFT", subtitled "You can always edit this later!" — date and location are NOT required to save (Partiful).
2. Date picker offers an explicit escape: "Not sure yet? → TBD". Undated events render honestly with a "TBD" chip on dashboard cards, coexisting with scheduled events instead of hiding in a drafts folder.
3. Editing autosaves continuously with a quiet "✓ SAVED!" pill (Partiful) or "Changes saved." toast after each change (Circle).
4. Draft state is always visible: grey "Draft" pill next to the title (Circle), "Draft ▾" status dropdown on the builder's mini event card (Eventbrite), "Drafts" tab/sidebar section in lists (Circle, Aboard).
5. Publish is a separate, explicit act (see publish-review-gate.md). Posh even offers the reverse: "Revert To Draft" on a live event.

## Use when
Organizers start planning before logistics are locked (no venue, no final date) and abandoning a half-configured event must cost nothing. Any multi-session editing experience.

## Avoid when
Drafts would leak externally (draft slug reachable) — draft must be hidden from public lookup. Avoid TBD dates if downstream modules (program, travel) hard-require dates; then TBD must block only those modules, not creation.

## Sad paths observed
- Half-done creation: SAVE DRAFT + autosave + TBD chips mean there is no "lost work" path at all (Partiful).
- Aboard gates publish with a stated checklist banner: "This event is in draft mode. You need to add cover image, text and location before you can publish it." — Publish stays disabled, no surprise validation error.
- Partiful preview drops empty optional rows entirely — no "TBD junk" leaks to guests.

## Accessibility
Autosave state is text ("SAVED!"), not color-only; draft pills are labeled text chips.

## Default verdict for our stack
RECOMMENDED — the old app already has a draft status hidden from public slug lookup; this pattern completes it: autosave on the create/edit surface, visible Draft pill, and publish-readiness checklist instead of submit-time error walls. TBD dates are VIABLE-with-care (conference dates gate travel/program modules).
