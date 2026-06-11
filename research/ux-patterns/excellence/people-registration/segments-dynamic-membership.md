# Pattern: Dynamic segments (criteria-defined membership with live count)

**Surface:** people-registration / cohorts & lists · **Observed in:** AutoSend, Wix, Klaviyo (refs: https://mobbin.com/flows/bd72f575-7436-4a2c-8fff-4f46b2e7da06 , https://mobbin.com/flows/fc7d53d5-c91e-45f3-b833-f139799d85a6 , https://mobbin.com/flows/45c97c57-1f68-4615-abe8-23a3752d7da7)

## Flow
1. Lists (static membership) and Segments (criteria-defined, auto-updating) are distinct typed objects, labeled in the index (AutoSend rows: GLOBAL LIST / SEGMENT / LIST with counts; Wix: "Segment — a dynamic list of contacts that auto-updates").
2. Segment builder: name + criteria rows (Field / Condition / Value, "+ Add condition") with a LIVE matching count while you build ("0 matching contacts", Klaviyo's profile counter + "Preview details").
3. Filter vocabulary can be behavioral, not just attribute-based (Wix: "Didn't book session", "Opened email campaign") and is searchable with a "Request a Filter" escape hatch.
4. Templates seed common segments ("New subscribers", Klaviyo's "Engaged (30/60/90 Days)", "Churn Risks").
5. Segment detail: Members / Edit definition / Growth / Engagement tabs; refresh cadence stated ("updated automatically once a day", Wix).

## Use when
Downstream modules consume cohorts (communications: "email all unpaid delegates"; certificates: "all faculty of event X") — the segment is the handoff object.

## Avoid when
Tags + saved views already express every cohort in use; a second membership system fragments truth. Don't build segments before the filter builder exists — a segment IS a saved filter with an identity.

## Sad paths observed
- Zero-match segments save fine and show 0 — building against live count prevents surprise-empty sends.
- Refresh cadence is stated, preventing "why isn't my new contact in the segment" tickets.

## Accessibility
Builder rows are labeled form controls; live count is a polite live region.

## Default verdict for our stack
AVOID for V1 (role-footprint views + tags cover the conference cohorts); revisit in V2 as the bridge between people and communications modules — the live-count builder is the variant to copy.
