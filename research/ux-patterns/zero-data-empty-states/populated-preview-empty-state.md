# Pattern: Populated-preview empty state (show the filled future, not a blank)
**Surface:** zero-data-empty-states · **Observed in:** Apollo, monday.com, Airtable, Ditto (refs: https://mobbin.com/screens/4b404d34-01c8-44a0-9e59-2e709a9c4ae1, https://mobbin.com/screens/fc17d45d-8927-4536-a43f-17780e99d0af, https://mobbin.com/screens/91be0fcc-761d-4e31-b96d-248cfc3513b8, https://mobbin.com/screens/f7fa9038-2128-44f8-8e16-4ac6ff6ac4f8, https://mobbin.com/screens/94df29a4-b7a3-421e-bec9-bbadc764bd7b)

## Flow
1. Instead of an icon + sentence, the empty module shows a rendered screenshot/mock of itself populated with realistic data: Apollo "Website visitors" displays a full fake visitors table ("3,112 total visits...") above the value prop "Turn website visitors into pipeline" and a single CTA "[Add website]".
2. In wizards, the preview is live and reactive: monday.com builds a board preview that fills with the project name you type ("Mobile app project" appears in the mock as you type); Airtable's template wizard renders an app preview pane that updates per selected department, labeled "This is your app preview. You'll be able to make changes later."
3. Ditto frames the preview as a guided playground ("Getting Started Playground" card) above dashed ghost slots ("Start a new project") in the real list.
4. CTA completes setup and the preview is replaced by the real, initially-sparse module.

## Use when
- The module's value is invisible until populated (analytics, registration funnels, attendee tables) and you need to justify a setup cost before showing anything real.
- During creation wizards: echoing the user's own input into the preview (monday) makes the payoff concrete.

## Avoid when
- The fake data could be mistaken for real tenant data — Apollo's table is only distinguishable by context, not labeling; never use this for anything resembling financial/attendance truth without a "preview" label.
- The module fills in seconds anyway — a preview of a list the user is about to create manually is wasted weight.

## Sad paths observed
- No observed app lets you interact with the preview — clicks dead-end, which can read as breakage (Airtable mitigates with the caption "This is your app preview").
- Apollo's preview has no "sample" watermark; screenshot-style only by convention.

## Accessibility
- Preview images are decorative screenshots; the value-prop sentence + CTA must carry the meaning (Apollo does this correctly: heading, body, button below the image).
- Live previews (monday) are visual-only feedback; the form itself remains a plain labeled input — keep parity so the preview is enhancement, not requirement.

## Default verdict for our stack
VIABLE — best reserved for Event State's analytics/registration modules pre-first-event and for the event-creation wizard (echo the event name into a preview); label all preview data explicitly as sample.
