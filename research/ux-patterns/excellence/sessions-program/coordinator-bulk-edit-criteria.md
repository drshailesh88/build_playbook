# Pattern: Criteria-based bulk edit (date range × weekday mask × resource type)

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Booking.com (refs: [bulk edit panel](https://mobbin.com/screens/4d156f44-252e-4f42-a4f4-40b38c7e5b74))

## Flow
1. "Bulk edit" opens a side panel: date range ("From / Up to and including"), weekday mask ("Which days of the week do you want to apply changes to?" Mon–Sun checkboxes), resource-type tabs ("Two-Bedroom Apartment" | "Multiple room types").
2. Collapsible action sections each carry a one-line explanation: "Rooms to Sell — Update the number of rooms to sell…", "Room Status — Open or close this room", "Restrictions".
3. The change applies by RULE across the calendar, not by picking individual cells.

## Use when
The coordinator thinks in rules: "close Hall 3 every morning", "shift all Saturday sessions by 30 minutes".

## Avoid when
The coordinator thinks in instances ("these 5 specific sessions") — selection-based multi-select fits that, and notably it was observed NOWHERE (first-principles candidate, flagged in coverage).

## Sad paths observed
- None captured; the inherent risk is over-broad rules — the explicit weekday mask + date bounds are the guardrails.

## Accessibility
All criteria are labeled form controls; sections explain themselves in one line.

## Microcopy worth stealing
"Which days of the week do you want to apply changes to?" · "Up to and including"

## Default verdict for our stack
VIABLE (V2 shape) — conference programs rarely need rule-based bulk edits in V1; the nearer need is selection-based multi-select (checkbox N sessions → bulk status/track/hall change), which must be designed first-principles.
