# Pattern: Publish as a review gate (readiness checklist + discoverability metadata at peak motivation)

**Surface:** events-creation-landing · **Observed in:** Eventbrite web (https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2), Aboard web (https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c), Circle web (https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968), Posh web (https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9)

## Flow
1. Publish is its own step, framed as review: "Your event is almost ready to publish — Review your settings and let everyone find your event." Left: a rendered preview card (image, title, date range, address, price, capacity, "Preview ↗"). Right: discoverability metadata collected at the exact moment of maximum motivation — Type/Category/Subcategory ("Your type and category help your event appear in more searches.") and Tags with a "5/10 tags" counter (Eventbrite).
2. Readiness is a stated checklist, not a surprise error: "This event is in draft mode. You need to add cover image, text and location before you can publish it." with Publish rendered disabled until met (Aboard).
3. The Publish button is persistent across all editor tabs while the Draft pill shows — publishable from anywhere (Circle).
4. Publishing is reversible where excellence allows it: "Revert To Draft" exists on a live event (Posh).
5. Status is always a visible control: "Draft ⌄" dropdown flips to "● On Sale" post-publish (Eventbrite).

## Use when
Publish has real consequences (public visibility, registration opens, notifications) — the gate prevents half-configured pages going live and harvests metadata nobody fills in later.

## Avoid when
Ultra-light social events where any gate kills momentum (Partiful ships draft-as-shareable instead). Don't gate on fields that aren't genuinely required.

## Sad paths observed
- Publish blocked by missing content → disabled button + named missing items (Aboard).
- Publish blocked by plan limits → paywall surfaces at publish, composition stays free (Locals: "Ready to publish event? — Upgrade to Locals Pro", https://mobbin.com/flows/c91ca78e-3961-43d4-8612-708a73604b9b).
- Old-app scar this prevents: silent create/publish failures (5 separate fixes) — a review gate with explicit result states is the structural fix.

## Accessibility
Disabled Publish carries an adjacent text explanation (the banner); checklist items are text, not icon-only.

## Default verdict for our stack
RECOMMENDED — replace the old app's bare `confirm()` status buttons with a publish review step: rendered page preview + readiness checks (cover, venue, dates, registration fields configured) + the public slug shown for confirmation. Category/tags only if EventState grows discovery surfaces.
