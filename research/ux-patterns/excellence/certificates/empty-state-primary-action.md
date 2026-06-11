# Pattern: Empty state that teaches the object + single primary action

**Surface:** certificates / all lists · **Observed in:** Workable, Linear, Teachable, Sana AI, Frame (refs: https://mobbin.com/screens/c6191351-f538-49b2-9be9-235e5f61cf9b, https://mobbin.com/screens/a57bbcb6-f66e-4147-8bc3-09011b17d11b, https://mobbin.com/flows/21f569ff-7862-482d-85e8-3f33d1d25c22, https://mobbin.com/screens/cb749274-3f52-4b87-9890-aaf47229b701)

## Flow
1. One-line state + one-line WHY + single CTA, duplicated in the page header: "No document templates yet. Create templates for documents requiring signatures." + "➕ Add template" (Workable).
2. Certificate-specific version: "You don't have any certificates yet — You can distribute a certificate of completion to students who have completed your course." + "Create new certificate" + docs link (Teachable).
3. Multi-path variant when creation has real alternatives: Create from Doc / from template / from AI template + Import (Frame).

## Use when
Every zero-state list in the module: templates, issued certificates, bulk runs, verification log.

## Avoid when
The state is zero because of an ERROR or a disabled feature flag — say that instead (see census #31 flag gating); an onboarding empty state over a failure is a lie.

## Sad paths observed
None — this card IS the sad-path pattern for first-run.

## Accessibility
Action duplicated in header keeps it reachable when the illustration area is skipped.

## Default verdict for our stack
RECOMMENDED — pair with template-gallery-start: the templates empty state should open the gallery, not a blank editor.
