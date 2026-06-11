# Pattern: Scoped clone/copy with disclosure of what does NOT travel

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** 7shifts, Luma, incident.io (refs: [7shifts copy schedule](https://mobbin.com/screens/b1a6cf4f-2d79-4776-a012-ddc8651b68d3), [Luma clone event](https://mobbin.com/screens/b8fdd256-4466-4d17-b435-d75a2b3bfd04), [incident.io duplicate](https://mobbin.com/screens/10c0ca5d-18c0-40f0-851c-0328439b44cb))

## Flow
1. The copy modal STATES the scope up front: "Everything except the guest list and event blasts will be copied over." (Luma); "This is a copy of your Engineering schedule, overrides are not copied." (incident.io).
2. Copies land as DRAFTS: "This will create a draft schedule. You will be able to make additional changes before publishing." (7shifts).
3. Scope controls: department multi-select, target date(s), "Also copy the schedule to future weeks?", checkboxes for what metadata travels ("Include labor targets", "Include shift notes") (7shifts). Luma clones one event to MANY dates in one action (editable date-row list + "+ Add Time", timezone selector).
4. incident.io adds a live preview pane ("How your schedule will look once created.") and a captured hard-failure toast: "● Failed to create schedule".

## Use when
Annual conferences and recurring event series — duplication is the real-world creation path for event N+1.

## Avoid when
Cloning silently with undisclosed scope — person-linked data (assignments, invites, registrations) must NEVER travel implicitly.

## Sad paths observed
- "Failed to create schedule" error toast — duplication can fail and says so.

## Accessibility
Scope disclosure is body text in the modal, not a tooltip.

## Microcopy worth stealing
"Everything except {x} and {y} will be copied over." · "This will create a draft schedule." · "Also copy to future weeks?"

## Default verdict for our stack
RECOMMENDED — event duplication (sessions + halls WITHOUT person-linked data) is old-app NEVER-ATTEMPTED #46 with the scope rule already written in the PRD; this card supplies the exact UX: scope disclosure + draft landing + copy-what checkboxes.
