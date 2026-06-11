# Pattern: Steps-checklist builder with merchandised page sections

**Surface:** events-creation-landing · **Observed in:** Eventbrite web (https://mobbin.com/flows/3b85f96b-28c4-44eb-b4f6-658c1f971c23, https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2, https://mobbin.com/screens/a8321be6-f638-4ba8-92c6-68db041b82b8)

## Flow
1. Left rail: mini event card (title, date, "Draft ⌄" status dropdown, "Preview ↗") above a numbered "Steps" checklist — "Build event page" → "Add tickets" → "Publish" — each with a one-line promise ("Add all of your event details and let attendees know what to expect").
2. Main pane is the actual landing page as editable sections (WYSIWYG): hero upload, title, date/location, "Overview" rich section.
3. Optional sections are merchandised with conversion stats, not listed neutrally: "Frequently asked questions — 💡 Events with FAQs have 8% more organic traffic"; "Add more sections to your event page (Recommended) … which means more ticket sales and less time answering messages." with per-section "See examples" links (Agenda etc.).
4. "Good to know" highlights are one-tap chips: "+ Add Age info / + Add Door Time / + Add Parking info". Partiful's mobile equivalent: "+ Link · + Playlist · + Registry · + Food situation" and "More to say? + New section" (https://mobbin.com/flows/9b50876d-84ad-4498-a39b-df06ce40006f).
5. "Save and continue" advances the checklist; steps stay visibly unchecked until done; progressive disclosure hides advanced settings under "More options".

## Use when
Creation is genuinely heavyweight (tickets, agenda, FAQs, multi-section page) and organizers need a map of what's left. The page-section model fits content-rich landing pages.

## Avoid when
The event is light (a meetup) — a checklist adds ceremony Luma-style instant create avoids. Don't use stats-merchandising copy you can't substantiate.

## Sad paths observed
- Draft status is permanent context in the rail, so abandoning mid-checklist is safe and resumable.
- Capability limits stated inline at point of use ("Our tool can only generate one General Admission ticket for now.").

## Accessibility
Checklist is text with numbered steps; section adders are labeled buttons; "See examples" opens contrastive good/bad teaching content.

## Default verdict for our stack
RECOMMENDED (hybrid) — conferences ARE heavyweight: instant create for the core record (defaults-first card), then the workspace presents a checklist of page sections (overview, agenda preview, venue/FAQ blocks) with named one-tap section adders for the public page. This is the shape the never-built `publicPageSettings` admin surface should take.
