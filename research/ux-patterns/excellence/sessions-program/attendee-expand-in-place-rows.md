# Pattern: Public program hub with search + facets + expand-in-place rows

**Surface:** sessions-program / attendee-program · **Observed in:** Unity (refs: [sessions hub](https://mobbin.com/screens/0d59fbdc-b2d3-4530-bced-188f1d5a4881), [expanded row](https://mobbin.com/screens/feacd322-bdc8-4a73-b81b-d141fdb4f4f3))

## Flow
1. Toolbar: list/grid view toggle, search field, dropdown facets (Industry / Topic / Time of day).
2. List rows: date block (MAR 27), time + explicit timezone "11:00 pm - 12:00 am (1 Day Later) WIB", track tags, title, collapsed description with chevron.
3. Chevron expands the row IN PLACE — full description, "Who should attend:" bullets, "Associated tutorial:" link — no detail-page round trip, list position preserved.
4. Card view offers "Learn More" + "Register" per card.

## Use when
Public web program pages where visitors triage many sessions quickly — expansion answers "is this for me?" without navigation cost.

## Avoid when
Session detail is rich (speakers, maps, related content) — expansion can't carry it all; expand for triage, link out for depth.

## Sad paths observed
- Sparse content (a single card) rendered honestly without filler.

## Accessibility
Expansion is a chevron button per row; content appears in document order below the row.

## Microcopy worth stealing
"Who should attend:" — the audience-fit section heading.

## Default verdict for our stack
RECOMMENDED — the public program page (`/e/[slug]/program`) should expand-in-place for abstracts/speakers; "Who should attend" maps perfectly to CME-audience descriptions in medical programs.
