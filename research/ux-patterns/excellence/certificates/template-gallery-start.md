# Pattern: Template gallery / start-from-template

**Surface:** certificates / template-design · **Observed in:** Canva, Adobe Express, Postman, Bonsai, Lovable, Figma, ClickUp, Coda (refs: https://mobbin.com/flows/8d21cd49-0c4d-4a9e-9319-29107cbdea51, https://mobbin.com/flows/e96ed881-58f4-4e52-a792-715f2dc890c6, https://mobbin.com/flows/53bb52bb-53e5-4d94-b267-74396f69e271, https://mobbin.com/flows/58625560-054a-4da8-b784-da8ee50948d9, https://mobbin.com/flows/d0fce046-940c-406c-bf93-0f281b0d9500)

## Flow
1. Gallery grid of template thumbnails with filters — by category/industry (Bonsai "Industry" tabs with counts), by role (Figma), with quick-filter chips (Adobe Express).
2. "Blank — Start from scratch" card coexists with named templates (Bonsai).
3. Template detail pane before committing: large preview, byline, value-prop bullets, "More like this" row (Canva), tags + "Recommended for" (Postman).
4. Single CTA: "Use Template" / "Customize this template" → opens pre-populated editor.
5. In-context insertion confirms with a toast ("Selected Template has been used successfully!" — ClickUp).

## Use when
First template creation, or any time the alternative is a blank canvas — sets the quality floor and teaches what a good certificate looks like.

## Avoid when
Gallery has fewer than ~4 genuinely distinct options — a thin gallery reads as filler; ship 1 strong default instead.

## Sad paths observed
None surfaced in-flow; the failure mode is the gallery itself going stale (Canva mitigates with "Inspired By Your Last Design" rows).

## Accessibility
Card grids with full preview pages (Bonsai) beat hover-only "Add template" affordances (Figma) for keyboard users.

## Default verdict for our stack
RECOMMENDED — ship 5–8 conference-grade starters (per certificate type: delegate, faculty, speaker, CME…) so the 7 legacy types (census #11) each open pre-populated, never blank.
