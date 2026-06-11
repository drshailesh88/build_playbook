# Pattern: Preview-as-attendee with device toggle before publish

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Eventbrite, User Interviews (refs: [event preview](https://mobbin.com/screens/15f70af4-7799-4358-b818-a28e2d8a3500), [preview participant view](https://mobbin.com/screens/11470727-6632-40ef-aa43-bce674f3b4b7))

## Flow
1. "Preview your event ↗" / "Preview participant view" renders the public agenda EXACTLY as the audience will see it, read-only, in an overlay with "Close preview".
2. Desktop/mobile toggle icons switch the rendered viewport — the mobile story is checked before publish, not after complaints.

## Use when
Anything with a public-facing render (program page, attendee app view) — preview is the cheapest publish-confidence mechanism that exists.

## Avoid when
Preview diverges from the real renderer — a lying preview is worse than none; render through the actual public component.

## Sad paths observed
- None; this pattern pre-empts the "published it broken" sad path.

## Accessibility
The preview IS the accessibility check surface — coordinators see the mobile reading order.

## Microcopy worth stealing
"Preview participant view" · "Close preview"

## Default verdict for our stack
RECOMMENDED — the module's publish-version flow should offer "Preview public program" rendering the snapshot through the real public-page component (the old app already renders public from snapshots — preview = render the candidate snapshot pre-publish). Pairs with the visual-blindness mitigation in REBUILD-KICKOFF (human eyeball on UI).
