# Pattern: Move-event diff modal — New vs ~~Original~~ + who is harmed

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Clockwise (refs: [move-event modal](https://mobbin.com/screens/d0f17573-9dc2-41f5-9a9c-abe93e0449c2))

## Flow
1. The reschedule confirm shows the time diff explicitly: "Tomorrow, 1pm - 2pm **New**" above struck-through "~~Tomorrow, 9am - 10am~~ **Original**".
2. Below: collapsible impact sections — "Conflicts · 1 attendee" (expanded: "Outside of working hours" with avatar) and "Inconveniences · 1 attendee".
3. The grid behind shows a dashed ghost at the original slot and a solid block at the proposed slot; contextual ribbons ("Alex OOO 9:00am - 10:00am") explain WHY the conflict exists.
4. Single Save commits.

## Use when
Moving a session that has assigned people — the coordinator sees the old time, the new time, and exactly who is affected before committing.

## Avoid when
Trivial drags within free space (no assignments, draft status) — a confirm modal on every drag kills grid fluidity; gate the modal on "has affected people".

## Sad paths observed
- Per-person conflict annotations inside the confirm — the harm is itemized, not aggregated.

## Accessibility
Strikethrough paired with "Original"/"New" text labels; affected people listed with names.

## Microcopy worth stealing
"New" / "Original" (struck through) · per-person impact lines

## Default verdict for our stack
RECOMMENDED — this is the missing UI half of the module's existing data (assignments + conflict detection): any session move with assigned faculty gets the diff + affected-faculty confirm; it also feeds the change-diff notification (speaker-change-diff-reconfirm card).
