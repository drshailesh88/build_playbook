# Pattern: Lifecycle status tabs with counts (Now / Upcoming / Drafts / Past / Canceled)
**Surface:** travel · **Observed in:** TravelPerk (ref: https://mobbin.com/flows/624b7510-8bb7-4516-b513-1631dba78ea9), Qantas ("Upcoming | Following"), Turo ("ACTIVITY | BOOKED | HISTORY"), Tripsy (year-grouped past)

## Flow
1. Trip list segmented by lifecycle tabs, each with a live count: "Now (0) · Upcoming (0) · Drafts (1) · Past (0) · Canceled (0)".
2. "Now" is its own tab — in-progress travel is the hottest segment, not buried in Upcoming.
3. Scope filter alongside ("Only my trips" checkbox) and a search that spans "trips, travelers, or locations".
4. Cards carry status-appropriate actions: Draft → Continue editing / Share / Delete; trip ID visible.

## Use when
Records have a lifecycle (the EventState machine: draft/confirmed/sent/changed/cancelled) and the list serves different jobs per phase (today's ops vs upcoming prep vs audit of cancelled).

## Avoid when
Two states only (the oracle's Active/Cancelled split already handles that); tabs for empty categories with no behavioral difference are dead weight.

## Sad paths observed
- Counts render even at 0 — tab structure is stable, no layout shift.
- Empty tab states are encouraging, not blank: "Ready for your next trip? Nearly there."

## Accessibility
Tabs are a tablist with counts in the accessible name; search labeled with its scope.

## Default verdict for our stack
VIABLE — a status filter row (All / Draft / Confirmed / Sent / Changed / Cancelled with counts) over the oracle's Active/Cancelled split gives ops the "what still needs sending" cut (drafts) the census can't answer today. Cheap; pairs with countdown-first sort.
