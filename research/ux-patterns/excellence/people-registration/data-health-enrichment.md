# Pattern: Data-health surface (the database reports its own completeness)

**Surface:** people-registration / data quality · **Observed in:** Apollo, HubSpot, folk, Clay (refs: https://mobbin.com/flows/7ec939cf-1a63-451d-8c3f-9c2f80b970f3 , https://mobbin.com/flows/0f99578e-b531-401b-86cd-8b50ccbeb5f2 , https://mobbin.com/flows/5c821a07-3a83-489a-a180-d748eaca1300)

## Flow
1. A health dashboard aggregates completeness per critical field: Apollo's donut cards ("Missing emails", "74% up-to-date / 9% need enrichment / 17% unknown") — each card links straight to the affected rows ("View contacts") and to a fix action ("Schedule").
2. Bulk fix runs from the table selection: HubSpot's "Enrich records" in the bulk toolbar, gated by a coverage preview slide-over (match rate %, eligible/matched counters, "Overwrite all values when enriching" checkbox, credit-limit error state).
3. Progress is ambient: folk's sidebar shows "Enriching 28 contacts" with a live bar; activity log records each job.
4. Clay's variant: enrichment is per-column with provider waterfalls and recipes (B2B-sales-specific; the relevant skeleton is "pick data point → run → fill blanks").

## Use when
Field completeness has operational consequences — for conferences: a delegate without email cannot receive a certificate; a faculty without phone can't be reached day-of.

## Avoid when
Third-party enrichment providers are irrelevant/PII-inappropriate (medical attendee data!) — the HEALTH surface still applies, the external-data FILL does not.

## Sad paths observed
- Enrichment blocked → explicit credit-limit error with the recovery path; "Overwrite" is opt-in, defaulting to fill-blanks-only.
- Unknown/unenrichable records are their own counted slice (17% unknown), not hidden.

## Accessibility
Donuts always have text equivalents (percent + count); cards are link-buttons.

## Default verdict for our stack
VIABLE (V2) — strip the external-data part, keep the health math: "N people missing email / phone / city", each count linking to the pre-filtered list, with bulk-edit as the fix path. Pairs with the certificates and communications modules' delivery needs.
