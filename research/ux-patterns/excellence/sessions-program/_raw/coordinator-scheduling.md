# Coordinator builds & manages a multi-track program/schedule — Mobbin sweep

Date: 2026-06-11. Source: Mobbin MCP (search_flows + search_screens), web platform unless noted. EXCELLENCE-mode harvest for medical-conference SaaS sessions module rebuild. Every entry records only what was visible in returned screens/flows.

Note on app coverage: Sched, Sessionize, Notion Calendar (standalone app), Fantastical, Google Calendar, and Hopin/RingCentral Events did NOT surface in any query. Mobbin substituted adjacent best-at-job apps: 7shifts, Deputy (shift scheduling = closest structural analog to room/track lanes), Clockwise, Motion, Amie, Eventbrite, Luma, Fresha, Front, Skiff, Cron Calendar, User Interviews, incident.io, Booking.com.

## 7shifts (web) — strongest analog for multi-lane schedule build + publish

1. **Publishing a schedule (flow)**
   - Mobbin URL: https://mobbin.com/flows/a188ab96-5d5c-4917-bb42-e27d16942411
   - Steps observed:
     1. Week grid: rows grouped by department (Back of House → Cook, Owner; Finance → Cashier), each department has its own "Open Shifts" row; columns are days with weather + headcount per day.
     2. Header shows persistent warning pills: "2 Conflicts" "1 Overtime" (red/orange) next to a "Fix warnings" link, beside the "Publish schedule" primary button.
     3. Unpublished/changed shift renders as a hatched/striped chip (diagonal stripes) until published.
     4. Click Publish → button enters disabled "Publishing…" state.
     5. After publish, header shows "Multiple last published dates" indicator.
   - Problem solved: lets a coordinator see schedule health (conflicts/overtime) at all times in the header, and makes draft-vs-published state visible per cell (striped chip), so publishing is a deliberate reviewed act rather than a silent save.
   - Sad paths observed: conflict count pills in header; "5h Total OT" overtime badge on a person row; "TIME OFF" blocking cells; red-highlighted person row when over budget/conflicted; overtime flame icon on shift chips.
   - Microcopy worth stealing: "Fix warnings" · "Publishing…" · "Multiple last published dates" · "TIME OFF" · "5h Total OT".
   - Mobile/a11y notes: warning pills use color + text + count (not color alone). Bottom budget bar pinned with per-day labor %.

2. **Fixing errors / auto-fix (flow)**
   - Mobbin URL: https://mobbin.com/flows/389ba0ce-9288-4d83-bfbb-c7a8eb426111
   - Steps observed:
     1. Pre-publish modal interrupts: "We found some warnings. Let us fix them!" with subtext "There are a few warnings to look at before publishing. Would you like us to fix them?"
     2. Warnings are categorized with counts and definitions: "0 Exceptions" (with explanation), "0 Conflicts" ("Conflicts include shifts that already exist, or fall on a day when the employee has an approved time off or is unavailable."), "1 Overtime warnings", "0 Unassigned Shifts" ("Unassigned shifts are any shifts that are not assigned to an employee.").
     3. Choice: "Yes, fix them for me" (primary) / "No thanks" + "Do not show me this again" checkbox.
     4. Auto-fix progress modal: "Hang tight, we're building your perfect schedule." with live checklist: "Analyzing and fixing shifts with exceptions / …that would result in overtime / Analyzing and removing duplicate shifts / …with approved time off / …with availability conflicts / Finishing up", each ticking green.
     5. Toast: "Schedule(s) has been copied and set to draft mode (not live)."
   - Problem solved: turns conflict resolution from manual hunting into a categorized triage with an opt-in auto-fixer; definitions inline so the coordinator learns the taxonomy.
   - Sad paths observed: this IS the sad path — categorized warning inventory before publish; explicit "(not live)" reassurance on draft copy.
   - Microcopy worth stealing: "We found some warnings. Let us fix them!" · "Yes, fix them for me" · "Hang tight, we're building your perfect schedule." · "Schedule(s) has been copied and set to draft mode (not live)."
   - Mobile/a11y notes: progress checklist gives perceivable feedback during long-running fix; each category has a plain-language definition.

3. **Copy Schedule modal (screen)**
   - Mobbin URLs: https://mobbin.com/screens/b1a6cf4f-2d79-4776-a012-ddc8651b68d3 , https://mobbin.com/screens/d8172473-e3b4-4d18-9040-0aad7143368b
   - Steps observed: "Copy Schedule" modal → subtext "This will create a draft schedule. You will be able to make additional changes before publishing." → "Select Departments" multi-select chips (Back of House ×, Finance ×, Front of House ×) → "Copy current schedule to" date field → "Also copy the schedule to future weeks?" dropdown ("2 weeks" / "No thanks") → checkboxes "Include labor targets", "Include shift notes" → "Copy schedule" / Cancel.
   - Problem solved: bulk-duplicates a whole week's program scoped by department, into a safe draft, with control over what metadata travels.
   - Sad paths observed: none visible; the draft-first promise is itself the safety net.
   - Microcopy worth stealing: "This will create a draft schedule. You will be able to make additional changes before publishing." · "Also copy the schedule to future weeks?" · "No thanks" as the zero option.

4. **Locations / Departments / Roles management (flow)**
   - Mobbin URL: https://mobbin.com/flows/18bef6a3-f096-4e81-a3e2-77ab2bad68ef
   - Steps observed: Settings → "Locations / Departments / Roles" page with left sub-nav (Locations | Departments | Roles); Departments list rows with star/edit/kebab actions + "Add Department"; Roles list scoped by location dropdown + department dropdown, "Add role"; info banner "To move roles between departments please reach out to 7shifts support for assistance." with "Contact support" button.
   - Problem solved: three-level resource hierarchy (location → department → role) maps directly to venue → hall/track → room management.
   - Sad paths observed: hard constraint surfaced honestly (cannot move roles between departments in-app).
   - Microcopy worth stealing: honest constraint banner pattern.

## Deputy (web) — lane grid by Area + publish/notify

5. **Publishing a schedule (flow)**
   - Mobbin URL: https://mobbin.com/flows/a426e08b-cd76-4cd5-a684-0830b4744e1d
   - Steps observed:
     1. "Week by Area" grid: rows are Areas (Manager, Admin, Support, Cleaner, Sales) each color-dotted; every empty cell shows a "+" affordance; row "Add a New Area" at grid bottom; "Add Team member" in left people rail.
     2. Primary button counts pending work: "Publish 11 shifts".
     3. Publish opens "Notify staff" modal: radio choices "Notify (email, app)" / "Require confirmation (email and app)" / "No notifications (mark as published)" with Back/Publish.
     4. After publish: all shift chips turn green (published), button becomes "All shifts published" (success state), an "OPEN" badge marks unassigned open shifts.
     5. Persistent bottom legend with live counts: "0 empty · 11 unpublished · 1 published · 0 require confirmation · 1 open shifts · 0 warnings · 0 leave approved · 0 leave pending · 0 unavailable".
   - Problem solved: publish is quantified ("Publish 11 shifts"), notification fan-out is an explicit coordinator choice, and chip color encodes published state so drift between draft and live is always visible.
   - Sad paths observed: red-tinted chip with warning triangle for a shift with warnings (Sat column); "1 warnings" count in legend; weekend columns tinted pink (closed/unavailable days).
   - Microcopy worth stealing: "Publish 11 shifts" · "All shifts published" · "No notifications (mark as published)" · "Require confirmation (email and app)".
   - Mobile/a11y notes: bottom status legend doubles as a color key — pairs each color with a label and count.

6. **Location details / Areas ordering (flow)**
   - Mobbin URL: https://mobbin.com/flows/c35a9552-1e9c-4aef-986d-d4d02148eafa
   - Steps observed: Locations list (Name, Address, Areas columns, "Edit Settings", "Add Location"); location detail tabs (General | Areas | Scheduling | Timesheets | Notifications & extensions); Areas tab banner: "Drag the Areas to change the order of how they are arranged on the Scheduling screen."; inline "New area name" + Add; per-area Edit/Delete; Archive action for whole location; notification rules list ("Un-filled Open shift → Send Notification", "Upcoming shift → Send Notification") each noting "Inherited from location 'ASMobbin'. Go to this location to edit this rule."
   - Problem solved: lane ordering on the schedule is controlled where lanes are defined (drag to reorder areas); notification rules inherit down a location hierarchy.
   - Sad paths observed: inherited-rule lock state with pointer to the editable source.
   - Microcopy worth stealing: "Drag the Areas to change the order of how they are arranged on the Scheduling screen."

7. **Insights overlays on grid (screen)**
   - Mobbin URL: https://mobbin.com/screens/93321432-f493-451e-9bc7-551746341583
   - Steps observed: "Insights" dropdown on schedule toolbar: "Show stats panel / Show coverage in areas / Show hours in areas / Give feedback"; toolbar also has "Auto" (auto-scheduling), "Copy", view switcher.
   - Problem solved: optional data overlays (coverage per lane) without leaving the grid.

## Clockwise (web) — conflict detection & resolution ceiling

8. **AI scheduling with conflict disclosure (screen)**
   - Mobbin URL: https://mobbin.com/screens/671e0870-f520-4d92-bc16-8ee9b332bb3b
   - Steps observed: assistant panel beside week grid: "I can schedule this meeting, but there is a **conflict** for Sam." → expandable "Sam has conflicts that I can't fix:" → "You have inconveniences:" → chip "1 hour of Focus Time lost" → actions ✓ Confirm / Share / Cancel, thumbs up/down → footer "Nothing will change until explicitly confirmed." → free-text "Refine request…" input. Candidate slot rendered on grid as a distinct solid block among ghosted alternatives.
   - Problem solved: separates hard conflicts ("can't fix") from soft costs ("inconveniences"), prices the trade-off in human terms, and guarantees no mutation without confirmation.
   - Sad paths observed: conflict-that-cannot-be-fixed state; lost-focus-time cost surfaced.
   - Microcopy worth stealing: "I can schedule this meeting, but there is a conflict for Sam." · "Sam has conflicts that I can't fix:" · "You have inconveniences:" · "1 hour of Focus Time lost" · "Nothing will change until explicitly confirmed."

9. **Move event modal with before/after + conflict breakdown (screen)**
   - Mobbin URL: https://mobbin.com/screens/d0f17573-9dc2-41f5-9a9c-abe93e0449c2
   - Steps observed: "Move event" modal: event name; "Tomorrow, 1pm - 2pm  New" above struck-through "~~Tomorrow, 9am - 10am~~  Original"; collapsible "Conflicts · 1 attendee" (expanded: "Outside of working hours" with avatar) and "Inconveniences · 1 attendee"; single Save button. Grid behind shows dashed-outline ghost at original slot, solid block at proposed slot, plus "Alex OOO 9:00am - 10:00am" red banner strip on day column.
   - Problem solved: a reschedule confirm that shows old vs new time and itemizes who is harmed before committing — the diff-on-move pattern.
   - Sad paths observed: OOO ribbon; "Outside of working hours" per-attendee conflict.
   - Microcopy worth stealing: "New / Original" labels with strikethrough on original.

10. **Conflict hand-off message (screen)**
    - Mobbin URL: https://mobbin.com/screens/d91d7384-97bf-415d-94e3-de3c3c57d4e6
    - Steps observed: "Text copied to clipboard" card: "Are you free to meet for Alex // Sam on Tomorrow, 9:00am? There are a few issues with that time, which Clockwise will fix if it can: • Busy - Conflict. Does that work? Respond to Alex".
    - Problem solved: exports the conflict negotiation to the human channel with the issues enumerated.

## Motion (web)

11. **Rescheduling an event (flow)**
    - Mobbin URL: https://mobbin.com/flows/8f2d65fa-0247-4de3-a3d4-0e7caa9de1c2
    - Steps observed: week view; drag event block to new slot; right rail is a rolling task/agenda list grouped by day; rail status line flips between "All tasks are scheduled on time" (calm state) and "No upcoming events today — Schedule an event below" (empty state); "Refresh all tasks" footer button; current-time red line across grid.
    - Problem solved: drag-reschedule with an always-on textual agenda mirror of the visual grid.
    - Sad paths observed: empty-day state in rail.
    - Microcopy worth stealing: "All tasks are scheduled on time" · "No upcoming events today".

12. **Creating an event — quick popover (flow)**
    - Mobbin URL: https://mobbin.com/flows/7fb07f5b-e929-4bf3-8e40-4ffc86c9577c
    - Steps observed: click slot → in-grid popover: title placeholder "Event title", Event|Task segmented toggle, date + time range, "All day", "Repeat", "Travel time", Add guests, description, conferencing, location, busy/visibility; "Create ⌘↵" button with keyboard hint; Cancel/Esc.
    - Problem solved: full event creation without leaving grid context; keyboard path advertised on the button.
    - Mobile/a11y notes: explicit ⌘↵ and Esc affordances printed in UI.

## Amie (web)

13. **Rescheduling an event (flow)**
    - Mobbin URL: https://mobbin.com/flows/d71bc3f8-79c4-420c-bd69-63b8af1867f4
    - Steps observed: week grid; dragging shows both original chip and moving copy; on drop, confirmation toast bottom-right: "✓ Created: Schedule medical appointment — 6 Sept 2023, 09:45"; left rail lists the same item as a todo with date chip (calendar/task duality).
    - Problem solved: drag feedback with ghost-at-origin and post-action toast receipt.
    - Microcopy worth stealing: toast "Created: <title>" + exact timestamp.

14. **Calendar filter dropdown / color coding (screen)**
    - Mobbin URL: https://mobbin.com/screens/1a78610f-8071-4015-90c4-bddebf54da35 (also fe6808b0…, 3b12d0ed…)
    - Steps observed: "N calendars" pill with stacked color dots opens dropdown: "Filter 6 calendars…" search field; per-account groups; checkbox + color dot + name per calendar; events on grid carry left color border matching calendar; past/declined events render struck-through; list dropdown variant says "Drag to reorder".
    - Problem solved: track/category visibility toggling with color legend built into the control — the multi-track filter pattern.
    - Mobile/a11y notes: color is paired with name in the dropdown; strikethrough conveys state without color.

## Eventbrite (web) — agenda builder

15. **Agenda section in event builder (screens)**
    - Mobbin URLs: https://mobbin.com/screens/8d36da0b-8fab-4a22-add6-c0e9c26a9008 , https://mobbin.com/screens/96bc7ce3-cbc3-4579-8df9-47da5ac32378 , https://mobbin.com/screens/888bf94c-06df-445b-8f91-bf7d82aa4437 , https://mobbin.com/screens/996d29e5-8def-4a7e-af06-f592e5cb51d0
    - Steps observed:
      1. Left rail: event card with "Draft" status dropdown + numbered steps (Basic Info → Details → Online Event Page → Tickets → Publish) or (Build event page → Add tickets → Publish); "Preview your event ↗".
      2. "Agenda" section: helper text "Add an itinerary or schedule to your event. You can include the time, a description of what will happen, and who will host this part of the event, if applicable. (Ex. Speaker, performer, guide, etc.)" and "If your event has multiple dates, you can add a second agenda."
      3. Tabs per agenda: "Agenda ⋮" + "+ Add new agenda" (multi-track/multi-day as tabs).
      4. Slot editor: "Slot title*", Start time / End time (empty state shows "--:-- --"), "Add host" / "Host/Artist name" with avatar upload, "Add description", trash icon with "Delete slot" tooltip; "+ Add slot" full-width button; completed slots collapse into timeline cards "19:00 Check-in", "19:15 Welcome and introduction" with colored left bars.
      5. "Delete section" for whole agenda; Discard / "Save & Continue".
    - Problem solved: progressive slot-by-slot agenda assembly with inline collapse to a readable program; multiple agendas for multiple days/tracks.
    - Sad paths observed: required-field asterisk on slot title; empty time placeholders.
    - Microcopy worth stealing: the agenda helper text above (verbatim); "+ Add slot" · "+ Add new agenda".

16. **Event preview as attendee (screen)**
    - Mobbin URL: https://mobbin.com/screens/15f70af4-7799-4358-b818-a28e2d8a3500
    - Steps observed: "Event preview" overlay with "Close preview"; desktop/mobile toggle icons top-right; agenda rendered read-only as attendee sees it (time, title, speaker avatars+names); Tags section below.
    - Problem solved: publish-confidence via device-toggled preview of the public agenda.
    - Mobile/a11y notes: explicit mobile preview toggle is the mobile story here.

## Luma (web)

17. **Clone Event modal (screen)**
    - Mobbin URL: https://mobbin.com/screens/b8fdd256-4466-4d17-b435-d75a2b3bfd04
    - Steps observed: "Clone Event" modal: "Everything except the guest list and event blasts will be copied over."; editable list of target date+time rows (Wed Dec 25 06:00, Mon Dec 30 06:00, …) each removable ×; "+ Add Time" and "Recurrence" buttons; timezone selector "GMT+08:00 Singapore"; checkbox "Create new Zoom meetings"; primary "Clone Event".
    - Problem solved: one-to-many cloning of a session across arbitrary dates in one action — bulk duplication without a recurrence rule.
    - Microcopy worth stealing: "Everything except the guest list and event blasts will be copied over."

18. **Sessions tab / series registration mode (screen)**
    - Mobbin URL: https://mobbin.com/screens/5f0acabe-c68a-480f-ba2c-fcf6cb869490
    - Steps observed: event admin tabs (Overview | Guests | Sessions | Registration | Emails | Insights | More); "Registration Mode — Choose what guests are allowed to register for the series." cards: "Series or Sessions" (selected ✓) / "Series Only" / "Sessions Only"; "10 Sessions" expandable list rows "8 Jun, 14:00 GMT-4 · Thu".
    - Problem solved: program-level vs session-level registration policy as a single explicit choice.

## Fresha (web)

19. **Resource-column day view + availability warning (screen)**
    - Mobbin URL: https://mobbin.com/screens/ac5e971e-8cfb-47ca-9b36-bb6ae392b53f
    - Steps observed: day view with one column per staff member (avatar header) — the room/resource-column pattern; hatched background = unavailable hours, white = working hours; right "Edit service" panel: service, price, start time, duration, team member, "Extra time" (Processing time 10min); inline amber warning box: "⚠ Alex Smith is not working between 7:00am and 7:45am" while still allowing Apply; "Add client — Or leave empty for walk-ins".
    - Problem solved: booking against a resource outside its availability is warned inline but not hard-blocked (soft conflict).
    - Sad paths observed: out-of-hours placement warning; hatched non-working zones.
    - Microcopy worth stealing: "<Resource> is not working between <start> and <end>" · "Or leave empty for walk-ins".

## Front (web)

20. **Creating an event with details side panel (flow)**
    - Mobbin URL: https://mobbin.com/flows/15d5b8d3-7685-4275-b3a1-7cc1274ae027
    - Steps observed: drag on week grid paints a range → "New event" right panel: title; start/end date + time with 15-min increment dropdown; "All day"; "Add guests"; "Add a location"; **"Add meeting room"** dedicated field; calendar account picker; "No video conference ▾"; "Attach files"; rich-text description (B I U strikethrough); notification row "30 minutes" + "+ Add notification"; "Show as busy…"; "Default visibility"; "Email guests" checkbox; Cancel/Save. Left rail: calendar checklist incl. "[DISCONNECTED] - Squ…" account.
    - Problem solved: full-fidelity event composer adjacent to grid; meeting-room as first-class field.
    - Sad paths observed: disconnected calendar account labeled "[DISCONNECTED]" in the calendar list.

## Skiff (web)

21. **Creating event + drag-resize + recurrence (flow/screens)**
    - Mobbin URLs: flow https://mobbin.com/flows/278b5778-83b4-4ad3-a5ea-296d26fa2abb ; recurrence screens https://mobbin.com/screens/57b4fabe-1140-4dca-bdd3-eac72c999761 , https://mobbin.com/screens/c91a1352-18d5-48bc-8511-f33114905fe5 , https://mobbin.com/screens/6623f7ea-53b9-4b67-b63e-b5b112b5e121
    - Steps observed: left-panel inline event editor (title, date, time range, All day, "Repeats" toggle, participant, conferencing, location, description, row of color swatches); event created small then drag-resized on grid (6:00–6:30 → 5:30–7:30); "Customize recurring event" modal: "Repeat every [1] [week]" / "Repeats on" S-M-T-W-T-F-S day pills / "Ends": never · on [date] · after [N] times; Cancel/Save.
    - Problem solved: minimal persistent editor + direct manipulation for duration; the canonical custom-recurrence editor.

## Cron Calendar (web + ios)

22. **Repeat modal with event side panel (web screen)**
    - Mobbin URL: https://mobbin.com/screens/ebea84b5-e1ee-49a8-8322-11c6e38d5dd9
    - Steps observed: right event panel (title, time, All-day, timezone "GMT-4 New York", "Custom…" repeat row, participants, conferencing, location, description, busy/visibility, reminder "30mins before"); "Repeat" modal: Every [2][weeks], On day pills, Ends Never/On/After [4] times; week grid behind shows the series rendered across days.
    - Problem solved: same recurrence grammar as Skiff; timezone visible at point of edit.

23. **iOS week views (screens)**
    - Mobbin URLs: https://mobbin.com/screens/3b91c850-4eff-416f-80ca-b9f0ccde05ba , https://mobbin.com/screens/59da54a2-f73e-4ffa-9f2c-7f614d97e870 , https://mobbin.com/screens/6e9f0809-9cbc-4163-82e3-85ee9c8723b1
    - Steps observed: 2-day column view on phone (not 7); colored left-edge bars per calendar; bottom sheet status "Upcoming in 1h 39mins" / "No upcoming meeting" with "+" FAB; dark mode variant.
    - Problem solved: mobile week = 2 visible day columns + status sheet; dense grids don't survive on phones.
    - Mobile/a11y notes: this is the key mobile note for grid design — collapse to 1–2 columns, keep a textual "next up" strip.

## Microsoft Outlook (ios)

24. **3-day week view (screen)**
    - Mobbin URL: https://mobbin.com/screens/7c44fcd6-a3a0-43c8-81a1-dac8619cf607
    - Steps observed: month strip on top, 3-day column grid below; weather icons per day; current-time line "2:29 PM"; dashed horizontal half-hour gridlines; color-coded event chips; compose FAB.
    - Mobile/a11y notes: 3-day compromise between context and tap-target size.

## TimeTree (ios)

25. **Long-press Move/Copy on month grid (screen)**
    - Mobbin URL: https://mobbin.com/screens/090f84e4-a389-4521-b18a-339c3a036610
    - Steps observed: month view; long-press on a day cell raises a black context bubble with two actions: "Move" | "Copy", targeting the selected event to that date.
    - Problem solved: touch-native reschedule/duplicate without drag precision.
    - Mobile/a11y notes: explicit verb menu beats drag on touch.

## Notion (web)

26. **Creating a database calendar / agenda (flows)**
    - Mobbin URLs: https://mobbin.com/flows/4c9b91d1-4168-489d-916a-b495e3bd0c21 , https://mobbin.com/flows/0cd3dbda-d238-4f4c-a4ce-5e840710fe6b
    - Steps observed: view switcher dropdown on a database (Table / Board / Chart / List / Timeline / Calendar / Gallery / Feed) — same data re-projected; Timeline view with month header + "Manage in Calendar" button + "Bi-week ▾" zoom; Calendar month view with "+" affordance on hover per day cell and "+ New" row; event page = full document with properties (Launch date, Medium "Empty", Owner "Empty", Status "Not started") + "+ Add a property" + Comments; created item appears on calendar.
    - Problem solved: one source of truth, many projections (table for bulk, timeline for sequence, calendar for dates) — the multi-view program database pattern; session-as-document with structured properties.
    - Sad paths observed: "Empty" placeholder property values.

## Workable (web)

27. **People-lane week calendar with time-off (screens)**
    - Mobbin URLs: https://mobbin.com/screens/e3ef1c9a-a0f1-40b4-90a6-e11722b779cd , https://mobbin.com/screens/6b113f7c-1532-49f1-9822-2988a3e9c16d
    - Steps observed: "Work calendar" — rows = employees (name + role), columns = days; chips per cell ("09:00 AM - 05:00 PM / Remote", "Paid time off · 1 day", "Emergency Leave · 2 days" spanning multiple columns, "Unpaid leave · 0.5 days"); pending chips carry amber clock badge; subhead "No employees out of office today"; filters (time-off types, departments, entities & locations, View: All employees); "Show time-off only" toggle; green "+" appears on hovered empty cell; toast "Success! Time-off request has been processed."
    - Problem solved: lane-per-person availability matrix with multi-day spanning blocks — structurally identical to room-per-lane with multi-slot sessions.
    - Sad paths observed: pending-approval badge on chips; half-day representation.

## User Interviews (web)

28. **Manage availability + scheduling rules + unsaved changes (screens)**
    - Mobbin URLs: https://mobbin.com/screens/e6e4ff11-5e88-497e-905e-ad03de19e100 , https://mobbin.com/screens/11470727-6632-40ef-aa43-bce674f3b4b7 , https://mobbin.com/screens/8ea38f7e-ce8c-4e67-a178-930db26d80f6
    - Steps observed: "Manage availability" week grid where coordinator paints open slots (8:30-8:40 etc. micro-slots); right rules panel: "Scheduling type: Manual", "Minimum scheduling notice [4][Hours]", "Maximum number of confirmed sessions per day [6]", "Show open time slots on my connected calendar" checkbox, session attendance role "Moderator", connected calendar with "Disconnect"; sticky footer bar "× Discard changes / Save changes" while dirty; "Confirmed sessions" page groups booked slots by day; success toast "Jon Smith has been scheduled for the session on 12/20/2023 at 08:45 AM EST"; "Preview participant view" link + "Manage schedule" button.
    - Problem solved: constraint-driven slot publishing (notice period, per-day caps) and an explicit dirty-state bar — the unsaved-changes pattern for schedule grids.
    - Sad paths observed: dirty state handled via persistent Discard/Save bar (not modal-on-exit).
    - Microcopy worth stealing: "Minimum scheduling notice" · "Maximum number of confirmed sessions per day" · "Preview participant view".

## incident.io (web)

29. **Duplicate schedule with live preview + failure toast (screen)**
    - Mobbin URL: https://mobbin.com/screens/10c0ca5d-18c0-40f0-851c-0328439b44cb
    - Steps observed: "Duplicate Engineering" full-page form: Schedule name "Engineering (Copy)", Timezone, Holidays shown on schedule (+ Add public holidays), info banner "This is a copy of your Engineering schedule, overrides are not copied."; right half = live "Preview — How your schedule will look once created." with rota lanes and date scrubber (Today ◀▶, "2 weeks ▾"); rotation details tabs (Rota | Shadowing | + Add rota); bottom error toast "● Failed to create schedule ×"; Cancel / "Create schedule".
    - Problem solved: duplication with WYSIWYG preview before commit; honest copy-scope disclosure; visible failure state.
    - Sad paths observed: "Failed to create schedule" error toast — a rare captured hard-failure.
    - Microcopy worth stealing: "This is a copy of your X schedule, overrides are not copied." · "How your schedule will look once created."

## Booking.com (web)

30. **Bulk edit across calendar (screen)**
    - Mobbin URL: https://mobbin.com/screens/4d156f44-252e-4f42-a4f4-40b38c7e5b74
    - Steps observed: rate/availability calendar; "Bulk edit" right panel: date range "From / Up to and including"; "Which days of the week do you want to apply changes to?" Mon–Sun checkboxes; room-type tabs ("Two-Bedroom Apartment" | "Multiple room types"); collapsible action sections each with one-line explanation: "Rooms to Sell — Update the number of rooms to sell for this room type", "Prices", "Room Status — Open or close this room", "Restrictions".
    - Problem solved: bulk-editing a property across a date range × weekday mask × resource type — the strongest bulk-session-edit analog found.

## Linear / Asana / Jira / ClickUp (web) — timeline-lane adjacency

31. **Timeline lanes, dependencies, unsaved changes (screens)**
    - Mobbin URLs: Linear https://mobbin.com/screens/39048d90-578a-4eda-abe7-69427e17502b ; Asana timeline https://mobbin.com/screens/d3baa960-5d60-4590-9835-1c4704499a42 ; Asana workload https://mobbin.com/screens/ba3b9250-52c4-47d1-988c-7969c4e8aedf ; Jira https://mobbin.com/screens/624820e8-d6fe-4107-bc8d-5bc9df81cd85 ; ClickUp https://mobbin.com/screens/76da241a-f40f-4569-b9b7-1a82360d27db
    - Steps observed: Linear: dependency arrow drawn between two timeline bars, context menu "Blocking → [item]" / "× Remove dependency". Asana Timeline: section rows as lanes, bars draggable, "+ Add task". Asana Workload: person lanes with per-day capacity counts and a highlighted spanning bar. Jira Plans: timeline with "Unsaved changes" pill button in header, "Warnings" tab, "Auto-schedule" button, "Capacity view" dropdown. ClickUp: timeline with unscheduled-tasks edge tray ("Unscheduled 19" vertical tab; Jobber month view shows the same pattern as "Unscheduled 1" side drawer — https://mobbin.com/flows/32be4a4f-22b7-4f85-9e51-db3e905b25f0 ).
    - Problem solved: horizontal-time lane grids with explicit dependency links, capacity overlays, batched-save ("Unsaved changes") and an unscheduled-items parking lot to drag from — all directly transferable to "unassigned sessions" tray + track lanes.
    - Sad paths observed: Jira "Unsaved changes" + "Warnings" affordances; Jobber red conflict-colored items in month cells.

## Posh (web)

32. **Recurring series with validation + natural-language summary (screen)**
    - Mobbin URL: https://mobbin.com/screens/1f1ae6d5-c6a6-4df1-88b1-dfecb66fcfb6
    - Steps observed: "Recurring Series" modal ("Choose the cadence and length of your event series."): Every [1][month], On [the 28th day], Ends ● On [Feb 4th 2026] / ○ After [5] occurrences; red inline validation: "The end date must be at least one month after the start date."; live plain-English summary below: "Repeats every 1 month on the 28th of the month until February 4th, 2026 (2 events)".
    - Problem solved: recurrence rules verified and translated to a human sentence with the resulting event count before saving.
    - Sad paths observed: inline rule-violation error (verbatim above).
    - Microcopy worth stealing: the computed "(2 events)" count in the summary.

## ElevenLabs / Linear (web) — publish-diff adjacency (not calendar-native)

33. **Review changes before publish (screens)**
    - Mobbin URLs: ElevenLabs https://mobbin.com/screens/ff16450b-9de9-4c60-8738-770be8df0a5c ; Linear version history https://mobbin.com/screens/6c14e085-9ff5-4e61-9a21-b04f1b0a3433
    - Steps observed: ElevenLabs "Review Changes" modal: two columns "Published version [Main]" vs "Current changes [Main]", red/green diff highlighting, "Expand 77 lines …" collapsers, "Version description (optional) — Describe what changed in this version" field, Cancel/Publish. Linear: "Version history" with right-rail version list (author + timestamp, "Latest"), "Highlight changes" toggle, strikethrough-removed / highlighted-added inline diff, "1 of 3" change stepper, "Restore version".
    - Problem solved: generic publish-gate diff and named-version restore — the transferable shape for agenda versioning, since no calendar-native agenda diff was found.

## Coverage

Queries run (16 total; limits: flows 3, screens 5-6 deep):

- **by-app (5):** Notion Calendar creating an event (flows, web) → Notion database calendar/agenda flows; Sessionize conference schedule builder (screens, web) → Eventbrite only, NO Sessionize; Fantastical week view (screens, ios) → Cron Calendar/Outlook/TimeTree, NO Fantastical; 7shifts/Deputy surfaced via pattern queries; Motion/Amie surfaced via flow queries.
- **by-pattern (8):** scheduling conflict warning double booking (timed out once, retried as "scheduling conflict warning overlapping events") → Clockwise/7shifts/Fresha; timeline resource lanes gantt → Asana/Linear/Jira/ClickUp; day view columns per staff/room → Workable/Deputy/Deel; recurring event custom repeat rule → Skiff/Posh/Cron; copy schedule duplicate bulk → Luma/7shifts/incident.io/Booking.com; color coded calendar filter legend → Amie ×5; review unpublished changes diff → ElevenLabs/Linear/Google AI Studio (generic, not calendar); event organizer session list speakers tracks → Eventbrite/User Interviews/Luma.
- **by-flow (3):** rescheduling by dragging → Motion/Amie/Jobber; publishing a staff schedule with warnings → 7shifts/Deputy; managing rooms locations venues → 7shifts/Deputy/Whereby (Whereby = video rooms, excluded); creating event in week view → Front/Motion/Skiff.

Came up dry / thin (FIRST-PRINCIPLES CANDIDATES):
1. **Conference room×time program grid** (rooms as columns/lanes against a single day's hours, Sched-style venue grid): NOT found. Closest analogs: Fresha staff-column day view, 7shifts/Deputy department-lane week grids, Workable people lanes. Design the conference grid from first principles, borrowing lane mechanics from these.
2. **Agenda publish diff / "what changed since last publish" for schedules:** not found calendar-native. 7shifts striped unpublished chips + Deputy unpublished counts are state-level, not diff-level; ElevenLabs/Linear diffs are generic. First-principles candidate for session-level change review before re-publish.
3. **Bulk multi-select of sessions on a grid** (checkbox-select N sessions → bulk action bar): not observed anywhere. Booking.com bulk edit is criteria-based (date range × weekday × type), not selection-based. First-principles candidate.
4. **Speaker double-booking conflict** (same speaker in two rooms at once): no event-tool example; Clockwise attendee-conflict and 7shifts employee-conflict are the transferable shapes.
5. Sched, Sessionize, Notion Calendar (standalone), Fantastical, Google Calendar, Hopin, Calendly, Reclaim, Airtable: absent from all result sets on these queries.

Excluded as weak/off-job: Whereby room settings (video-call rooms), Deel calendar (headcount matrix), Google AI Studio diff (code files), Adaline history (prompt versions), Sana AI version history (documents — kept only as adjacency note), Notion teamspace flow (permissions, not scheduling).
