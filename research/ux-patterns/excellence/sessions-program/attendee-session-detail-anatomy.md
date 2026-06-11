# Pattern: Session detail anatomy — time/venue/speakers/what-to-bring/social proof

**Surface:** sessions-program / attendee-program · **Observed in:** Open, WWDC, Eventbrite, Front, GroupMe (refs: [Open class detail flow](https://mobbin.com/flows/586efb2c-a941-4d2f-9b22-03c2d1185ecb), [WWDC detail](https://mobbin.com/screens/6032ac36-cdd9-4204-9e5d-0ab0b4bbbd97), [Eventbrite agenda editor](https://mobbin.com/screens/33f1830d-f4e4-4dd5-8a1c-3e926708f3d7), [Front session page](https://mobbin.com/screens/9c36ddbe-c23d-40e5-914f-f6f79d04358c))

## Flow
1. Canonical session card: time range, title, speaker chips (avatar + full name, never icon-only), truncated description with "View more" (Eventbrite).
2. Detail page adds: venue floor-plan snippet for the hall (WWDC), type label ("ZOOM WEBINAR EVENT", Front), level badge ("INTERMEDIATE", Peloton).
3. Practical-prep section: "WHAT TO BRING" icon row (Open) — transferable as "CME credits · materials · prerequisites".
4. Social proof: "PRACTICING WITH (19) SEE ALL" avatar row (Open); attendee counts.
5. Save + share + add-to-cal all reachable from the detail nav.

## Use when
The detail page is the decision point ("do I attend this?") — it must answer when/where/who/what-do-I-need/who-else in one screen.

## Avoid when
Duplicating the full program chrome on detail — detail is for depth; navigation back to list must stay trivial.

## Sad paths observed
- None on these screens; the venue-map snippet pre-empts the "where is Hall 2?" day-of question.

## Accessibility
Speaker chips read as names; venue shown as map AND text; "For sessions with amplified sound, hearing loop technology is available on request." (Apple Store) — explicit accessibility disclosure ON the session page.

## Microcopy worth stealing
"What to bring" · "Practicing with (19)" · the Apple hearing-loop line — directly transferable to medical conferences.

## Default verdict for our stack
RECOMMENDED — the old app's attendee detail is expandable cards with speakers/roles; the rebuild's detail adds hall context, CME line, and accessibility disclosures (medical-conference table stakes).
