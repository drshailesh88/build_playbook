# Pattern: Hollow widgets with per-widget CTAs (dashboard stays structured)
**Surface:** zero-data-empty-states · **Observed in:** Amplitude, Neon, Asana, Attio, Notion, Linktree (refs: https://mobbin.com/screens/966b2301-6f26-4f65-aa90-a9d2fff5821d, https://mobbin.com/flows/a15904ee-ae55-46a9-b1bf-cfb6a3ac6924, https://mobbin.com/screens/2623e252-4ac9-429d-9482-369027fefb80, https://mobbin.com/screens/71029752-a359-4494-ae9a-28454142dd97, https://mobbin.com/screens/6f460796-c4d9-4d90-8694-f7d7346f2b78, https://mobbin.com/screens/7067e838-bccc-46fd-ad9e-af2425a82e95)

## Flow
1. The dashboard renders its real layout — every widget keeps its title, frame, and position — but each widget shows its own zero state instead of a chart/list.
2. Zero states take one of three observed forms: zeroed metrics with placeholder chart lines ("DAU 0", dotted trend line — Amplitude; zero-line chart — Linktree), text-only ("There is no data to display at the moment" — Neon Monitoring), or skeleton rows with guidance + CTA ("Organize links to important work... [Add work]" — Asana Curated work; "No reports in this dashboard yet [Create first report]" — Attio Reporting).
3. Each widget's CTA routes to the specific action that feeds it (Amplitude "Go To Template" per card; Asana "Create goal" on Goals widget).
4. Notion's empty dashboard widget adds a 3-option inline guide ("Ask AI to build your dashboard / Add charts, tables, lists / Learn about filters") with a Skip link.
5. Neon adds a dismissible "Get connected" strip above the hollow widgets — page-level CTA plus widget-level emptiness.

## Use when
- You want the new tenant to learn the dashboard's information architecture before data exists — the layout itself is onboarding.
- Widgets have independent data sources, each with a distinct fill action.
- Combined with a top-of-page checklist (Neon, Asana do both).

## Avoid when
- All widgets depend on the same single upstream action (first event) — six hollow widgets each saying "create an event" is noise; collapse to one takeover or checklist instead.
- Zeroed metrics could be mistaken for real data ("0 attendees" reads as a measurement, not an absence — Amplitude's "DAU 0" has this ambiguity).

## Sad paths observed
- Amplitude home shows real residual data inside one hollow card ("Singapore · 3 users") next to zeroed cards — partially-filled dashboards look broken.
- Linktree renders a spiky chart from a single stray datapoint amid zeros — sparse data is uglier than no data.
- Asana stacks widget CTAs + setup checklist + invite banner: 4+ CTAs visible at once.

## Accessibility
- Skeleton/ghost rows are purely decorative — they carry no text; the guidance sentence under them (Asana) is what a screen reader gets. Ensure every hollow widget has real text, not just skeleton blocks.
- Low-contrast gray placeholder text was common (Neon, Spline); zero-state copy needs the same contrast budget as live content.

## Default verdict for our stack
RECOMMENDED — for Event State's dashboard widgets that survive the checklist phase (e.g., upcoming events, registrations chart), keep the frame and give each widget one true zero-state sentence + the one CTA that feeds it; pair with the checklist hero rather than replacing it.
