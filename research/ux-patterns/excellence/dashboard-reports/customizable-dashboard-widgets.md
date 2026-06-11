# Pattern: Customizable dashboard (add/edit widgets, pinned KPI slots, templates)

**Surface:** dashboard-reports / overview personalization · **Observed in:** Stripe, Mixpanel, Amplitude (refs: https://mobbin.com/flows/545a744c-9b68-4b16-b3ce-25344345c93d, https://mobbin.com/flows/c3c50fee-8601-437d-98fc-4b122861a291, https://mobbin.com/flows/062bd936-df62-4290-a894-495541cf2d65, https://mobbin.com/flows/0d7ba557-161b-48ff-a970-6531eff69918)

## Flow
1. Stripe's overview has "+ Add / Edit" — the default board is curated but every widget is replaceable.
2. Mixpanel's home shows pinned KPI slots: filled slots render the metric; empty slots are dotted "Add a report" placeholders — personalization is visible as an invitation, not hidden in settings.
3. Amplitude's "Add Content" menu: Existing content / New chart / Generate with AI / Text; Mixpanel boards also take Text and Media blocks — dashboards double as narrative documents.
4. Templates gallery bootstraps ("User Activity Dashboard · 9 Charts") so customization never starts from blank.

## Use when
Different roles genuinely watch different numbers (registration lead vs. transport coordinator vs. chair) and the widget library already exists.

## Avoid when
V1 of a domain product — a curated, opinionated dashboard that's RIGHT for the conference-ops job beats an empty canvas plus homework. Customization is what you ship when your defaults are already excellent.

## Sad paths observed
- Empty dashboard (Causal: "This model has no charts!") with a pointing arrow to the create button — blank canvases need aggressive first-step guidance.
- Free-plan sharing caveat surfaced in-modal (Mixpanel) rather than at failure time.

## Accessibility
Drag-to-arrange needs keyboard alternatives (move up/down menu actions).

## Default verdict for our stack
AVOID for V1 / VIABLE for V2 — ship the opinionated 5-card + attention + trend layout first; pinned-KPI-slot personalization is the natural V2 once per-role usage diverges.
