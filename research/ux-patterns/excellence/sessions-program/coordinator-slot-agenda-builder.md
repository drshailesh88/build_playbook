# Pattern: Slot-by-slot agenda builder with collapse-to-program and multi-agenda tabs

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Eventbrite (refs: [agenda section](https://mobbin.com/screens/8d36da0b-8fab-4a22-add6-c0e9c26a9008), [slot editor](https://mobbin.com/screens/96bc7ce3-cbc3-4579-8df9-47da5ac32378), [tabs](https://mobbin.com/screens/888bf94c-06df-445b-8f91-bf7d82aa4437), [collapsed timeline](https://mobbin.com/screens/996d29e5-8def-4a7e-af06-f592e5cb51d0))

## Flow
1. Helper text frames the job: "Add an itinerary or schedule to your event. You can include the time, a description… and who will host this part of the event, if applicable. (Ex. Speaker, performer, guide, etc.)"
2. "+ Add slot" appends an editor: "Slot title*", start/end time (empty placeholders "--:-- --"), "Add host" with avatar, "Add description", delete-slot.
3. Saved slots collapse into a readable timeline ("19:00 Check-in", "19:15 Welcome and introduction") with colored left bars.
4. "+ Add new agenda" creates tabbed agendas for additional days/tracks.

## Use when
Simple linear programs (single-track day, workshop itinerary) — slot-by-slot beats a calendar grid when there's no parallelism.

## Avoid when
Multi-hall conference scale — no grid context means no conflict visibility; this is the on-ramp editor, not the scheduling surface.

## Sad paths observed
- Required-field asterisk on slot title; honest empty time placeholders.

## Accessibility
Slots are a vertical form list; collapsed cards read as a plain timeline.

## Microcopy worth stealing
The full agenda helper text above · "+ Add slot" · "+ Add new agenda"

## Default verdict for our stack
VIABLE — as the quick-start path for small events (single hall, one day) inside the same data model; the grid remains the primary surface at conference scale.
