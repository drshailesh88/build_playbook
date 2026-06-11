# TRANSPORT module — UX pattern harvest (BY-APP mode)

- Mode: by-app
- Date: 2026-06-11
- Source: WebSearch/WebFetch over vendor docs (Mobbin MCP unavailable this session)
- Job-to-be-done mapping: conference ops team moving attendees between hubs in batches — plan batches from travel data, assign vehicles/passengers under capacity, dispatch drivers, run day-of boarding states, react to flight changes, notify passengers/drivers, roll-up counts for planning.

Sourcing notes:
- Onfleet Support Center (Zendesk) and FlightAware Support (Zendesk) return HTTP 403 to direct fetches. Where a support-center article is cited, the behavior description comes from the search-result excerpt of that exact article (URL given). Onfleet's API docs (docs.onfleet.com) serve raw markdown and were fetched in full.
- Moovs help center articles were fetched in full via the canonical Intercom host `intercom.help/moovs-05c940f1970e/...` (the `support.moovsapp.com` vanity domain has a broken TLS cert / 404s).
- Circuit for Teams has rebranded to "Spoke Dispatch"; its help center articles were fetched in full at help.spoke.com.
- TripShot rider UX comes from an official TripShot-produced Rider App Guide PDF hosted by Nevada State University (read page-by-page, screenshots included exact microcopy).

---

## ONFLEET (last-mile dispatch)

### A1 — Onfleet: Drag-and-drop dispatch board assignment
- Source: https://support.onfleet.com/hc/en-us/articles/360023910111-Task-Assignment (content via search excerpt; Zendesk blocks direct fetch)
- Behavior as documented:
  1. Unassigned tasks sit in a dedicated "Unassigned" section at the top of the dashboard sidebar.
  2. Dispatcher drags a task from Unassigned onto a driver — dropping on the driver's name appends it to the end of their route; dropping into a specific position inserts it there.
  3. The order shown in the sidebar matches the order the driver sees in the Onfleet mobile app.
  4. Multiple tasks can be assigned to a driver's queue with one right-click action.
- Problem solved: direct manual passenger/vehicle assignment with sequence control — our "assign passengers to vehicles" step, where sidebar order == driver-visible order eliminates a whole class of miscommunication.
- Microcopy worth stealing: none shown in excerpt.
- Sad paths documented: none documented in excerpt.

### A2 — Onfleet: Auto-assign with explicit strategy choice
- Source: https://support.onfleet.com/hc/en-us/articles/360023669852-Auto-Assignment (content via search excerpt)
- Behavior as documented:
  1. Dispatcher selects task(s) in the sidebar, right-clicks, chooses auto-assign.
  2. Two documented strategies: assign to the driver currently the shortest distance from the task's destination, OR to the driver who, after assignment, will have the shortest total distance to travel.
- Problem solved: machine suggestion with human trigger — the human initiates, the system picks, matching our "system suggests, human finalizes" doctrine.
- Microcopy worth stealing: none shown.
- Sad paths documented: none documented.

### A3 — Onfleet: 4-value task state machine with color-coded board states
- Source: https://docs.onfleet.com/reference/state.md (fetched in full); https://support.onfleet.com/hc/en-us/articles/20509786766228-Task-Status (via search excerpt)
- Behavior as documented:
  1. API state enum: `0` Unassigned ("task has not yet been assigned to a worker"), `1` Assigned, `2` Active ("task has been started by its assigned worker"), `3` Completed ("Includes both successful and failed completions").
  2. "A Task's state cannot be modified directly with the exception of Complete task" — state transitions are driven by events, not direct edits.
  3. Dashboard colors per the Task Status article: Unassigned = grey pin (top of sidebar), Assigned = purple pin (beneath driver), In Transit = blue pin, Succeeded = green pin (map only).
  4. Delayed tasks get "a small gold dot on the top right corner of the task's icon" in both map and sidebar — delay is an overlay on state, not a state itself.
- Problem solved: clean separation of lifecycle state (planned→active→completed) from exception flags (delayed) — exactly how our red-flag overlay should sit on top of batch/passenger states.
- Microcopy worth stealing: state descriptions above (quoted from API docs).
- Sad paths documented: completed wraps both success and failure; failure details live in `completionDetails` (`failureNotes`, `failureReason`, `photoUploadIds`, `signatureUploadId` — fields visible in the example payload at the State doc).

### A4 — Onfleet: Route Plans — a named container independent of driver
- Source: https://docs.onfleet.com/reference/routeplan.md (fetched in full); https://support.onfleet.com/hc/en-us/articles/25492148360596-Route-Plans (via search excerpt)
- Behavior as documented:
  1. "A Route Plan (Route) is a container used to track a driver's work throughout a shift, day, or planned segment of work (e.g., morning route and afternoon route)."
  2. "A driver can be assigned to a Route or changed at any time before the Route is started." — vehicle/driver binding is late-bound.
  3. "Even after a Route has started, tasks can be added or removed."
  4. Tasks join a Route manually (drag-and-drop, shift-click multi-select per the support article) or "seamlessly through the Route Optimization process when an Admin or a Dispatcher 'Accepts' the Route Optimization results."
  5. API returns computed `taskStates` array — per-task state inside the container: "0 (unassigned), 1 (assigned to worker), 2 (active), 3 (completed)".
  6. Dashboard: "+" symbol upper right → "Create Route" → 'Create new route' modal → 'Create route'. Routes can be named and given a color.
- Problem solved: this IS our batch object — a named, colored container of passenger-tasks whose driver/vehicle can be swapped until execution starts, with per-member state rollup.
- Microcopy worth stealing: "Accepts" (human accepting optimization results); "Create Route".
- Sad paths documented: none beyond late driver swap allowance.

### A5 — Onfleet: Linked tasks (dependencies) — pickup must complete before dropoff
- Source: https://docs.onfleet.com/reference/dependencies.md (fetched in full)
- Behavior as documented:
  1. Create pickup task, note its ID; create dropoff task with `dependencies: [pickupTaskId]`.
  2. "This will allow the tasks to be linked, where the Pickup has to complete prior to starting the Dropoff."
  3. Dependency management must be enabled in dashboard settings; equivalent to the dashboard concept of "Linked Tasks".
- Problem solved: enforces hub→hotel→venue ordering at the data layer (a passenger can't be "dropped" before being "picked up").
- Microcopy worth stealing: "Linked Tasks".
- Sad paths documented: none documented.

### A6 — Onfleet: Webhook event taxonomy for the full task lifecycle
- Source: https://docs.onfleet.com/reference/webhooks.md (fetched in full)
- Behavior as documented (trigger names verbatim):
  - `taskCreated`, `taskAssigned`, `taskUnassigned`, `taskStarted`, `taskUpdated`, `taskDeleted`, `taskCloned`.
  - `taskEta` — "Worker ETA less than or equal to `threshold` value provided, in seconds." Limit 10 webhooks; fires once per task, at most every 30s.
  - `taskArrival` — "Worker arriving, at or closer than `threshold` value provided, in meters."
  - `taskCompleted` — "Task marked as successful." / `taskFailed` — "Task failed." Constraint: "Task cannot be both successful and failed."
  - `taskDelayed` — "Task is delay time is greater than or equal to `threshold` value provided, in seconds." "applies only to active tasks, will only fire once."
  - `workerDuty` — worker on/off duty (`0`/`1`).
  - `smsRecipientResponseMissed` — "Recipient responds to a notification via SMS, but the organization is unable to handle it at that time." (includes `from`, `to`, `body`)
  - `SMSRecipientOptOut` — "When a recipient replied 'STOP' to opt out of SMS communications."
  - `taskAssigned` limitation: only fires on container changes, not when a task is created pre-assigned.
- Problem solved: complete event vocabulary for our notification engine and red-flag system — threshold-based ETA/proximity/delay events are precisely the "react to changes" hooks we need.
- Microcopy worth stealing: event names above.
- Sad paths documented: missed inbound SMS replies and opt-outs are first-class events — passengers who text back must land somewhere.

### A7 — Onfleet: Recipient SMS notifications + branded tracking page
- Source: https://onfleet.com/chat-and-sms (fetched); https://support.onfleet.com/hc/en-us/articles/41314013074068-Notifications-and-Tracking-Page (via search excerpt); https://onfleet.com/visibility-and-tracking
- Behavior as documented:
  1. "You can set up and customize any number of automated SMS messages that can be sent to a recipient based on varying driver actions and triggers" — delivery started / expected / arriving.
  2. "The tracking page is what recipients will view if the tracking link is included in their notifications" — live map, ETA, driver chat on a branded page; task payloads carry a `trackingURL` (e.g., `https://onf.lt/51f5dae0` in the State doc example).
  3. Marketing page documents "AI-powered delay alerts" on recipient-facing tracking.
- Problem solved: passenger pickup-detail notification with a no-app live tracking link — our "notify passengers" requirement verbatim.
- Microcopy worth stealing: none quoted in accessible sources.
- Sad paths documented: opt-out and missed-reply handling via A6 webhooks.

### A8 — Onfleet: Completion with custom success/failure reasons; dispatcher can correct status
- Source: https://support.onfleet.com/hc/en-us/articles/9382652814228-Custom-Task-Completion-Reasons, https://support.onfleet.com/hc/en-us/articles/10373142665364-Complete-a-Task, https://support.onfleet.com/hc/en-us/articles/20508526302868-Edit-Task-Completion-Status (all via search excerpts)
- Behavior as documented:
  1. Driver unable to complete selects "Failure" and "choose[s] the most appropriate reason for failure from the list"; org can replace defaults with custom reasons.
  2. Admin adds a reason categorized under "Success" or "Failed"; can "enforce the requirement to have drivers input notes if they select a specific reason"; saves via "Add Reason"; drivers see it at next app login.
  3. "If a task is marked as failed incorrectly, a dispatcher would have the ability to edit the status to 'Succeeded'."
  4. Free-text "Notes" field accompanies the reason.
- Problem solved: structured no-show/failure taxonomy with required notes per reason, plus dispatcher correction of mis-marked passengers — our no_show flow plus the inevitable "driver fat-fingered it" undo.
- Microcopy worth stealing: "Failure", "Success", "Failed", "Add Reason", "Notes".
- Sad paths documented: this entire entry is the sad path; correction path is explicit.

### A9 — Onfleet: Team Auto-Dispatch with hard operational constraints
- Source: https://docs.onfleet.com/reference/team-auto-dispatch.md (fetched in full)
- Behavior as documented (parameter names verbatim):
  1. "dispatch tasks assigned to a team to on-duty drivers... tasks already assigned to the driver remain with them while automatically interleaving new tasks and potentially re-arranging the driver's route."
  2. `maxTasksPerRoute` (default 100, max 200); `maxAllowedDelay` — "Time in Minutes a task can be late. Default value is 10"; `serviceTime` default 2 min; `taskTimeWindow` and `scheduleTimeWindow` with documented bounds.
  3. `routeEnd` options: team hub, worker routing address, specific hub (`hub://<hubId>`), or "null - end anywhere". "All routes return to the team's hub by default".
  4. Response includes `dispatchId` "useful to keep... in case there is any questions regarding to how the route was calculated."
- Problem solved: auto-suggestion under explicit capacity/lateness constraints, preserving existing human assignments — our clustering engine's contract, and `dispatchId` models suggestion provenance/auditability.
- Microcopy worth stealing: parameter names above.
- Sad paths documented: existing assignments are never reshuffled away from their driver.

### A10 — Onfleet: completeAfter / completeBefore time windows on every task
- Source: https://docs.onfleet.com/reference/create-task.md (fetched in full)
- Behavior as documented: `completeAfter` — "earliest time the task should be completed"; `completeBefore` — "latest time"; plus `pickupTask` boolean and `quantity` field per task.
- Problem solved: arrival/departure windows per passenger pickup — the raw data our batch clustering aggregates.
- Microcopy worth stealing: field names.
- Sad paths documented: none here (lateness handled by `taskDelayed`/`maxAllowedDelay`).

---

## MOOVS + LIMO ANYWHERE (chauffeur / event ground transport)

### A11 — Moovs: Escalating driver nags to keep status truth fresh
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/8007480-driver-notification-remind-driver-to-update-trip-statuses (fetched in full; vanity URL https://support.moovsapp.com/en/articles/8007480-...)
- Behavior as documented:
  1. Sent "via text OR push notification. If driver has driver app installed and is logged in, they will receive a push notification. If not, they will receive a text."
  2. 'On the Way' reminder: "If trip status has not been updated to 'On the way' and trip is 45 minutes away — Sent every 10 minutes or until driver updates status."
  3. 'On Location' reminder: not updated and trip is 5 minutes away — every 5 minutes.
  4. 'Passengers on Board' reminder: not updated and trip is 10 minutes AFTER pick-up time — every 5 minutes.
  5. 'Done' reminder: not updated and trip is 30 minutes after scheduled drop-off — every 15 minutes.
- Problem solved: dispatcher dashboards are only as good as driver status discipline; automated time-anchored nags make the boarded/completed states self-healing.
- Microcopy worth stealing: "Are you on the way to pick up your passengers? If so, please update your trip status to 'On the Way'! [trip link]" / "Have you arrived to the pick-up location yet? If so, please update your trip status to 'On Location'! [trip link]" / "Are the passengers in the vehicle yet? If so, please update your trip status to 'Passengers on Board' [trip link]" / "Have you arrived to the drop-off location yet? If so, please update your trip status to 'Done'! [trip link]"
- Sad paths documented: the whole feature is a sad-path mitigator (stale statuses); fallback channel (SMS when no app) documented.

### A12 — Moovs: Two-stage driver trip reminders (24h + 1h)
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/8006883-driver-notification-send-trip-reminder-texts-to-driver (fetched in full)
- Behavior as documented: "Two text notifications will be sent to driver prior to trip: 24 hours prior to trip pick-up time; 1 hour prior to trip pick-up time."
- Problem solved: our "dispatch drivers + notify of pickup details" with a standard two-horizon cadence.
- Microcopy worth stealing: "You have an upcoming trip in X hours. Please update your status when you are on the way: [driver link]"
- Sad paths documented: none documented.

### A13 — Moovs: Flight change auto-propagates to the driver with a delta message
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/8002457-driver-notifications-send-driver-a-text-if-flight-time-is-updated (fetched in full)
- Behavior as documented: "If pick-up is at airport and flight arrival time is updated by 15 minutes or more" the driver gets a text. The 15-minute threshold suppresses noise from minor jitter.
- Problem solved: flight-change red flag closed loop — change detected → trip time updated → affected driver told old AND new time, automatically.
- Microcopy worth stealing: "Hey [driver first name], Your trip [confirmation number] for original [trip date & time] has been updated to [new trip date & time] due to a change in flight time."
- Sad paths documented: this is the sad-path (flight delay) handler itself.

### A14 — Moovs: Configurable notification recipients with per-trip override
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/9938857-trip-reminders-and-trip-status-update-notifications (fetched in full)
- Behavior as documented:
  1. Two notification classes configured at Operator App > Settings > General > Communication: trip reminders and trip status updates.
  2. For reminders: choose default recipients — "Passengers, Booking Contacts, or both." For status updates: choose triggers ("if members, drivers, or both") and recipients. "If no triggers are selected no status update notifications will be sent, even if recipients are selected."
  3. Per-trip override: "click on 'More' > 'Notify' within the relevant reservation, and turn on the desired notifications for that specific trip." A pop-up mimics the general settings. "Note: You cannot override status update triggers per trip."
  4. POB (passenger-on-board) notification to Booking Contact is a dedicated checkbox "within the Trip Status Updates section."
  5. Booking Contact can self-subscribe per trip "by clicking on the bell" in the Customer Portal confirmation pages.
- Problem solved: conference ops has the same booking-contact vs traveler split (PA books for the speaker); recipient/trigger matrix with per-trip override is the model.
- Microcopy worth stealing: 'More' > 'Notify'; 'Booking Contact'; 'Trip Status Updates'.
- Sad paths documented: explicit zero-trigger = zero-send rule prevents silent misconfiguration ambiguity.
- Adjacent (same help center, surfaced in search excerpt of passenger-app docs): passenger status texts "The driver is on the way...", "The driver is on location for pick up...", "Thank you for riding with [company name]..." — flagged as excerpt-sourced, see https://support.moovsapp.com/en/articles/8449136-getting-started-with-your-passenger-app

### A15 — Moovs: Dispatch Alerts — toggleable icon shorthand on the driver manifest
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/6946029-what-are-dispatch-alerts (fetched in full)
- Behavior as documented: "Dispatch Alerts are a short-hand way of communicating essential items about the reservation to the driver and internally... From the Reservation page the Dispatch Alerts are located in the Dispatch block. These can be clicked to select them as on/visible/highlighted in blue to the Drivers, or off/grey... They are displayed on the Driver app as icons".
- Problem solved: per-passenger flags (wheelchair, VIP, extra luggage) that travel from planner to driver app as glanceable icons.
- Microcopy worth stealing: none beyond feature name.
- Sad paths documented: none documented.

### A16 — Moovs: Auto Dispatch — system finds a driver, first acceptance wins
- Source: https://support.moovsapp.com/en/collections/3513392-moovs-software (collection; per-article content via search excerpts of "What is Auto Dispatch?", "How to Trigger Auto Dispatch for a Trip", "How to Configure Auto Dispatch Settings")
- Behavior as documented: trigger Auto Dispatch on a trip "immediately or schedule it for a future time"; it "pings nearby drivers and assigns the trip to the first one" to accept; settings "control how Moovs searches for drivers and how long it waits for responses."
- Problem solved: offer-based driver dispatch with timeout — alternative to direct assignment for our dispatcher.
- Microcopy worth stealing: none shown.
- Sad paths documented: response-timeout configuration implies non-response handling (move on), though the exhaust path isn't spelled out in excerpts.

### A17 — Moovs: Farm-out economics and shared-system sync
- Source: https://www.moovsapp.com/post/farm-out-and-farm-in-trips-build-a-profitable-network (fetched via search excerpt)
- Behavior as documented: overflow trips are farmed to an affiliate (~80/20 revenue split described); "everyone is working on the same system, and if you change anything, it automatically updates for everyone involved."
- Problem solved: overflow capacity — when conference demand exceeds the contracted fleet, subcontracted vehicles stay inside the same state machine.
- Microcopy worth stealing: none shown.
- Sad paths documented: none documented.

### A18 — Limo Anywhere: Flight-tracking auto-adjusts pickup time by a chosen offset
- Source: https://kb.limoanywhere.com/docs/how-the-set-up-and-use-real-time-flight-tracking/ (fetched in full)
- Behavior as documented:
  1. Flight tracking activates automatically once routing has pickup date/time, airport, airline, flight number; verified and monitored "via FlightStats."
  2. Setting: My Office > Company Settings > Company Preferences > Reservations → "Update Pick Up time based on the Arrival flight's ETA and flight offset" = "Yes".
  3. On the airport routing leg, "Driver should Arrive" offers 8 selections: "Do not adjust based on flight arrival", "When your flight arrives", then "15 min after gate arrival" through "120 min after gate arrival".
  4. Pickup time recalculates from ACTUAL arrival, preserving offset — documented example: offset "15 min after gate arrival", flight slips 12:30 PM → 12:50 PM, pickup auto-moves to 1:05 PM.
  5. Only the pickup routing leg accepts an offset; updates key off the pickup flight only.
- Problem solved: the core arrival-batch mechanic — pickup time is a derived value (flight ETA + buffer), not a manually maintained one.
- Microcopy worth stealing: "Driver should Arrive"; "Update Pick Up time based on the Arrival flight's ETA and flight offset"; "Do not adjust based on flight arrival"; "When your flight arrives"; "15 min after gate arrival".
- Sad paths documented: cancellation handling not specified in this article (noted gap); delay handling fully specified.

### A19 — Limo Anywhere: Custom trip statuses with protected system statuses
- Source: https://kb.limoanywhere.com/docs/How-to-Customize-and-Manage-Trip-Statuses/ (fetched in full)
- Behavior as documented:
  1. "A status lets interested parties know the situation of a reservation at a particular time such as 'On The Way', 'Arrived', 'Assigned', 'Cancelled', etc."
  2. Each status = Code ("3-5 letters... unique to each status and cannot be changed once it has been set on a reservation"), Name, Color ("appears on the Dispatch Grid and Calendar").
  3. Managed at My Office → Company Settings → System Settings → System Mapping; "+ Add Status" to add; pencil to edit Name/Color (Code locked); drag to "Inactive Statuses" or X to deactivate.
  4. System statuses that must not be modified: "Online and eFarm in", "Dispatched", "Cancelled by Affiliate".
  5. Status-to-Time Mapping stamps timestamps on settlements when statuses change (used for driver pay by travel/passenger time).
- Problem solved: extensible status vocabulary with immutable codes + protected system states — how to let conference ops add custom states without breaking the machine; status→timestamp mapping powers our roll-up reporting.
- Microcopy worth stealing: status names above; "+ Add Status"; "Inactive Statuses".
- Sad paths documented: "Cancelled by Affiliate" is a distinct system state (farm-out cancellation is its own event).

### A20 — Limo Anywhere: Status-change guardrails (too-early warning with optional override)
- Source: https://kb.limoanywhere.com/docs/5172/ (How-to Setup Status Change Limitations, fetched in full)
- Behavior as documented:
  1. My Office → Company Preferences → Driver Anywhere: "Turn Status Change Limitation ON"; "Do not allow status change X hours before Pickup Time" (default 24, customizable); "Allow drivers to override status change limitation".
  2. Driver attempting On The Way / Arrived etc. too early gets a warning; with override=YES they "can acknowledge the alert and proceed anyway"; with NO "the system blocks status changes until the designated window passes."
- Problem solved: protects state-machine integrity against drivers pre-marking statuses (which would corrupt live boards and trigger wrong passenger notifications).
- Microcopy worth stealing: setting labels above.
- Sad paths documented: this is a guardrail against the human-error sad path; both soft (acknowledge) and hard (block) modes documented.

### A21 — Limo Anywhere: Driver app statuses stream onto the dispatch grid
- Source: https://www.limoanywhere.com/driver-app/; https://www.limoanywhere.com/2025/11/06/give-operators-more-control-over-driver-trip-timing-in-driver-anywhere/ (search excerpts); https://kb.limoanywhere.com/docs/trip-on-time-performance-report/
- Behavior as documented:
  1. Driver marks "On Location" (spot time) or "Passenger on Board" (pickup time) in DriverAnywhere; "dispatchers can see the progress in real-time directly on the dispatch grid."
  2. Trip On-Time Performance Report "compar[es] actual arrival and pickup times against what was scheduled, based on trip checkpoint data rather than trip status changes" — performance measurement deliberately decoupled from driver-entered statuses.
- Problem solved: live boarded/no-show visibility, plus an honest after-action metric immune to status gaming.
- Microcopy worth stealing: "On Location"; "Passenger on Board".
- Sad paths documented: report design acknowledges drivers mis-time their status taps.

### A22 — Limo Anywhere: Dispatch grid with flight columns, filter presets, and tabs
- Source: https://www.limoanywhere.com/2026/02/11/making-the-most-of-the-new-dispatch-grid-setting-up-your-grid/ and https://www.limoanywhere.com/2026/02/20/making-the-most-of-the-new-dispatch-grid-optimizing-your-workflow/ (fetched); https://kb.limoanywhere.com/docs/new-dispatch-grid/ and release notes (search excerpts); https://www.limoanywhere.com/2024/03/28/making-the-most-of-your-dispatch-grid/
- Behavior as documented:
  1. Grid columns include Trip Type (In-House, Farm-In, Farm-Out), Confirmation Number, Pick-Up Time, Passenger Name, Vehicle Type, Primary Driver Name, Trip Status, Flight Status.
  2. Multi-flight reservations: "In the Flight Tracking columns, you will see a notepad icon that you can hover over to see the multiple flights and the flight tracking for each flight" (release notes excerpt).
  3. Filters panel: "define your criteria" via field/operator/value, "+ Add Filter" to stack; "Save as New Preset/Tab" via Actions menu; "Tabs organize those presets." Documented preset use cases include "Farm-Out Trips" and "Vehicle-Specific" views.
  4. 2024 dispatch-grid post (search excerpt): trips to/from a given airport (e.g. JFK) can be filtered "to help you group nearby pickups and drop-offs for easier routing."
- Problem solved: the ops board for our job — airport-filtered grouping is literally "10 arriving 10:00 from BOM" workflow; saved tabs = per-hub or per-day working views.
- Microcopy worth stealing: "+ Add Filter"; "Save as New Preset/Tab".
- Sad paths documented: none documented.

### A23 — Limo Anywhere: Auto Farm — rules-driven cascading offers to affiliates
- Source: https://www.limoanywhere.com/2026/04/28/auto-farm-by-limo-anywhere-turn-affiliate-farm-outs-into-a-scalable-workflow/ (fetched in full)
- Behavior as documented:
  1. Built on "regions, affiliate pools, triggers, offer types, messaging, and monitoring."
  2. Trigger: "Auto Farm may be triggered when a reservation matches a configured region or when a specific reservation status is selected."
  3. Matching by region + vehicle type (different affiliates for "SUV work in one city and a different partner for vans or specialty vehicles").
  4. Offer modes — Round Robin: "The trip is sent to one affiliate at a time based on your priority settings. Your most preferred affiliate receives the offer first. If they reject it or do not respond within the configured time, the system can move to the next affiliate in line." Bidding: pool-wide offer, affiliates "respond with the price they can complete the trip for."
  5. Offers go out via "email, SMS, or both" with customizable messages; monitoring view shows "what has been sent, what has been accepted, and where action may still be needed."
- Problem solved: status-triggered automation entering a workflow, sequential offer/timeout/escalation, and an outstanding-action monitor — a reusable pattern for any "find a resource" loop (extra vehicles for a surge batch).
- Microcopy worth stealing: "Round Robin"; "affiliate pool".
- Sad paths documented: reject/no-response → cascade to next affiliate; "where action may still be needed" surfaces stuck offers.

---

## ROUTIFIC + CIRCUIT FOR TEAMS / SPOKE (auto-suggested routes a human finalizes)

### A24 — Routific: Optimize → hand-edit → Reoptimize, with route locking
- Source: https://academy.routific.com/en/articles/1317935-how-to-make-changes-to-your-routes (fetched in full)
- Behavior as documented:
  1. Stops tab: "+" to add, pencil to edit, trash to delete.
  2. Drag a stop to a new position; or "drag and drop the stop onto the driver's name" and "Routific will slot the stop in the best position" — reassign with machine-chosen placement.
  3. Shift-select to drag multiple stops together.
  4. "Reoptimize" button reshuffles after manual changes; "lock routes" to "stop them from being re-optimized."
  5. "Unschedule" removes a stop from routes but keeps it in the project.
  6. Manual edits unlimited before dispatch; after dispatch requires Live Tracking subscription.
- Problem solved: the exact suggested-batch UX contract — system proposes, human drags, system re-balances only what isn't locked; "Unschedule" = our unassigned-passenger pool.
- Microcopy worth stealing: "Reoptimize"; "Unschedule".
- Sad paths documented: post-dispatch edits gated.

### A25 — Routific: Dispatch = SMS link; drivers need no pre-setup
- Source: https://academy.routific.com/en/articles/1317927-how-to-dispatch-routes (fetched in full)
- Behavior as documented: enter driver phone numbers in the "Dispatch" tab; click "Dispatch To Drivers" then "Publish Routes" (bottom-right); each driver receives "a text message with a link to their route."
- Problem solved: zero-friction driver onboarding for one-off event drivers — SMS link instead of app provisioning.
- Microcopy worth stealing: "Dispatch To Drivers"; "Publish Routes".
- Sad paths documented: none documented.

### A26 — Routific: Post-dispatch edits are staged, then explicitly published
- Source: https://academy.routific.com/en/articles/1317942-make-last-minute-changes-to-routes-after-dispatch (fetched in full)
- Behavior as documented:
  1. Requires Live Tracking; switch to "Plan" mode (vs "Live" mode) to edit.
  2. Can remove/update stops, add stops, add/delete drivers; edit via timeline, map, or search; "Edit" / "Unschedule" / trash options.
  3. "Any changes you make aren't officially published to your drivers until you click 'Publish Changes'" — pending state marked by "a red notification icon."
  4. On publish, the driver "app will automatically refresh and update to reflect those changes."
  5. "Driver information cannot be edited once their routes begin."
- Problem solved: draft-vs-published separation for in-progress batches — dispatcher stages a re-plan, then atomically pushes it; prevents drivers seeing half-finished edits.
- Microcopy worth stealing: "Publish Changes"; "Plan"/"Live" mode names.
- Sad paths documented: driver identity frozen after route start.

### A27 — Routific: Customer ETAs assume in-order execution; re-dispatch re-notifies
- Source: https://academy.routific.com/en/articles/2577961-re-ordering-stops-with-customer-notifications (fetched in full)
- Behavior as documented:
  1. "The Customer Notification feature requires drivers to complete stops in the same order they were dispatched."
  2. If drivers deviate, "the original Planned Delivery ETA and Out for Delivery notifications may no longer be accurate."
  3. After changes + re-dispatch: "The customers who are still expecting their delivery will automatically be notified of their updated ETA."
- Problem solved: defines who gets re-notified after a re-plan — only people still awaiting service — and names the ordering assumption our passenger ETAs depend on.
- Microcopy worth stealing: "Planned Delivery ETA"; "Out for Delivery".
- Sad paths documented: out-of-order execution explicitly called out as the accuracy-breaker.

### A28 — Routific: Unit-agnostic load/capacity constraint
- Source: https://academy.routific.com/en/articles/1317930-driver-capacity-and-delivery-loads (fetched in full); https://docs.routific.com/v1.6.3/reference/capacity-constraints
- Behavior as documented:
  1. "Load is the number of units (boxes, meals, flowers, items, etc.) associated with a delivery stop. Capacity is the maximum number of units a vehicle can carry at once."
  2. Load set per stop or via spreadsheet column titled 'Load'; capacity set in driver settings; then "leave it to Routific to ensure your drivers are not assigned more than they can carry."
  3. API: load/capacity values "are unit-agnostic, so they can denote whatever unit makes sense for your business"; variable sizes via weighted units (small=1, medium=5, large=15).
- Problem solved: passengers-plus-luggage capacity math — weighted units handle "1 passenger + 3 bags" cleanly.
- Microcopy worth stealing: 'Load'.
- Sad paths documented: overflow outcome (unserved stops) not specified in this article — noted gap.

### A29 — Circuit/Spoke: Editing mode with banner, pencil markers, and 3 reorder scopes
- Source: https://help.spoke.com/en/articles/6208915-how-to-make-changes-to-an-optimized-route (fetched in full)
- Behavior as documented:
  1. Any change puts the route in editing mode with a blue banner: "Route has unsaved changes - Discard or preview changes to continue"; changed/new stops get a pencil icon in list and map.
  2. Bottom options: "Discard changes" / "Preview changes".
  3. Preview offers three scopes (verbatim): "Reorder changed stops - Reorder only changed stops where possible"; "Reorder all stops - Reorder all stops based on changes"; "Redistribute stops between drivers - redistribute and reorder all stops". First two keep the assigned driver; third may not.
  4. Then "Save changes" → "Send route to driver".
  5. Without re-entering edit mode: click driver → "Reassign route" or "Swap route" — saves automatically.
  6. "Discard changes... cannot be undone."
- Problem solved: graduated blast radius for re-optimization — the human chooses whether the machine may touch only their edit, the whole vehicle, or the whole batch set. Directly answers our re-planning red-flag UX.
- Microcopy worth stealing: all quoted strings above.
- Sad paths documented: irreversible discard warned in doc; driver-preserving vs driver-changing options labeled.

### A30 — Circuit/Spoke: Live-route edits notify the driver "now or later"
- Source: https://help.spoke.com/en/articles/6962409-how-to-make-changes-to-a-live-route (fetched in full)
- Behavior as documented:
  1. Live edit banner: "Route is in editing mode - You can make changes to plan and preview routes".
  2. Preview on live routes constrains to "Reorder changed stops - Reorder only changed stops where possible" (minimal disruption mid-execution).
  3. "Click the Save changes button, and this will simultaneously save your changes and send a notification to your driver... It tells the driver that changes have been made and gives them the option to view those changes now or later."
  4. Live stop status icons (verbatim): "Orange dot = The stop is at risk of being early or late; Green tick = The stop was completed on time; Orange tick = The stop was completed early or late; Red cross = The stop was not completed". Hover shows Delivery status, Arrival time, Customer ETA.
- Problem solved: mid-execution re-plan delivery to drivers without yanking their screen, plus a predictive "at risk" indicator — the at-risk orange dot is a ready-made red-flag visual for batches drifting off schedule.
- Microcopy worth stealing: all quoted strings above.
- Sad paths documented: "Red cross = The stop was not completed" is a first-class visual state; at-risk is predictive, not just reactive.

### A31 — Circuit/Spoke: Three-stage recipient notifications with template variables
- Source: https://help.spoke.com/en/articles/7041450-how-to-set-up-recipient-notifications (fetched in full)
- Behavior as documented:
  1. Enable at Controls > External parties > Tracking notifications; sends email (free) or SMS (Twilio-priced) only "if recipient contact information... has been provided. If no details are provided, no recipient notifications can be sent."
  2. 1st notification "is sent when your driver starts their route" (out for delivery + expected time). 2nd "when the recipient's stop is next in the queue" ("arriving shortly"). 3rd "when your driver marks the stop as successful or failed" — and "the dynamic tracking link now shows any proof of delivery."
  3. Per-message tick boxes by channel; editable default templates in a pop-up editor.
  4. Custom fields (verbatim list): Team name, Customer name, Driver name, Tracking link, Date, Position in queue, Earliest time, Latest time, Seller name, Seller Order ID, Products.
  5. Operator controls what the dynamic tracking link reveals.
- Problem solved: complete passenger-notification spec — staged triggers (dispatch / next-in-queue / outcome), templating with queue position and time-window variables, channel selection, and graceful no-contact-info behavior.
- Microcopy worth stealing: custom field names; "Position in queue".
- Sad paths documented: failed outcome explicitly notified (stage 3 covers failure); missing contact info = silent skip, documented.

---

## FLIGHTY + FLIGHTAWARE (flight delay/cancellation alerting → our red-flag feed)

### A32 — Flighty: Named alert taxonomy across the flight lifecycle
- Source: https://flighty.com/help/flighty-notifications (fetched in full)
- Behavior as documented (names + descriptions verbatim):
  - Delay Prediction: "Predicts delays before the airline announces them by tracking your inbound aircraft."
  - Cancellation or Diversion: "Notifies you the moment your flight is cancelled or diverted."
  - Gate Changes: "Instant notification when your departure or arrival gate changes."
  - Connection Assistant: "Monitors your flights and alerts you about the status of your connection".
  - Check-in Reminder: "Lets you know when check‑in opens for your flight."
  - Inbound Plane Alert; Taxi, Takeoff & Landing Times; Airport Delay Alert: "Warns you when there are major delays at your departure or arrival airport."; Baggage Claim Info; Aircraft Type & Tail Assignments; Flight Plan filed.
  - Managed via Settings → Alerts; can also track "Flighty Friends and Friends' Flights" (third-party watching someone else's flight).
- Problem solved: a graded severity vocabulary for our red-flag engine — inbound-aircraft lateness and airport-wide delays are leading indicators before a passenger's flight officially slips; "Friends' Flights" is exactly the ops-team-watches-attendee-flights relationship.
- Microcopy worth stealing: all alert names/descriptions above.
- Sad paths documented: cancellation/diversion are dedicated alert types, not generic updates.

### A33 — Flighty: Predicted vs official times shown side-by-side, with delay reasons
- Source: https://flighty.com/help/delay-predictions (fetched in full)
- Behavior as documented:
  1. ML over "aviation authority data and your incoming aircraft" — needs only the tail number; covers ~2/3 of US delays; regional coverage tiers documented (USA full; Canada/Europe partial; rest-of-world late-aircraft + airport ops only).
  2. "Flighty shows both: our predicted times alongside the official ones, so you always see the full picture." — prediction never overwrites the official value.
  3. Identifiable causes: weather, ground stops, closed runways, taxiway congestion, low ATC staffing, large events; "explicitly cannot determine plane maintenance or crew issues."
  4. "When delay reasoning is determined, it automatically appears in push notifications."
- Problem solved: how to present our suggested/derived data against source-of-truth data (suggested batch time vs airline schedule) without lying to the user; reasons-in-the-alert raises dispatcher trust.
- Microcopy worth stealing: "Flighty shows both: our predicted times alongside the official ones, so you always see the full picture."
- Sad paths documented: honest about unknowable causes (maintenance/crew) — an explicit "we don't know" category.

### A34 — FlightAware: User-configured per-flight alerts with channel + event selection
- Source: https://support.flightaware.com/hc/en-us/articles/30995945415319-How-Do-I-Set-Up-Flight-Alerts (via search excerpt; Zendesk blocks fetch); https://support.flightaware.com/hc/en-us/articles/31705965269271-How-Do-I-Edit-The-Alerts-On-My-IOS-FlightAware-App (excerpt)
- Behavior as documented:
  1. Events: "departure, arrival, cancellations, gate changes, delays, and diversions" — free alerts.
  2. Channels: "push, text, or email."
  3. Web: bell icon top right → "Set up a new alert"; pencil to edit, red "X" to delete. iOS: blue "+" to add; per-alert edit of "alert date, alert type, and the 'minutes out'". Limits: 5 active alerts (basic), unlimited (Premium).
- Problem solved: per-traveler alert subscription model — our ops team subscribing to specific attendee flights with chosen channels.
- Microcopy worth stealing: "Set up a new alert"; "minutes out".
- Sad paths documented: none beyond plan limits.

### A35 — FlightAware AeroAPI: Machine-consumable flight event webhooks
- Source: https://www.flightaware.com/commercial/aeroapi/ (fetched)
- Behavior as documented: "set up alerts to be notified of the information you need in real time"; events include "notification of impending departure", "notification of impending arrival", "cancels", "diverted", and "when a flight has entered or left a holding pattern"; delivered as "push webhooks" to a configured callback URL.
- Problem solved: the ingestion side of our red-flag system — flight events arrive as webhooks that mutate batch suggestions, mirroring how Limo Anywhere consumes FlightStats (A18).
- Microcopy worth stealing: n/a (API).
- Sad paths documented: cancellation and diversion are primary event types.

---

## TRIPSHOT (shuttle ops: fixed route + reservations + boarding)

### A36 — TripShot: Seat-capacity reservations with confirmed/standby lists and boarding confirmation
- Source: https://www.tripshot.com/all-products/ (fetched); https://www.tripshot.com/resources/blog/use-reservation-to-streamline-operations/ and https://www.tripshot.com/resources/blog/transit-101-reservations-faqs/ (via search excerpts; pages now 404 directly); https://www.tripshot.com/reservations/
- Behavior as documented:
  1. "Admins can configure maximum seat capacity at the route or ride level, and maintain confirmed or standby reservation lists."
  2. "Ridership Tracking — Confirm when riders have physically boarded vehicles and can be counted in reporting."
  3. "Proactive Planning — Scheduling in advance allows vehicles and drivers to be assigned based on which routes are filling up."
  4. "Full Rider Control — Riders can setup recurring reservations and manage future reservations individually."
  5. Driver side (product/search excerpts): "easy validation of reservations for the respective route", "drivers can determine if a rider has a reservation and whether or not they should be allowed to board", "automatic passenger counting, digital pass validation, and rider manifest"; passenger app shows "how many of the seats on board a vehicle are filled."
- Problem solved: our entire passenger-capacity model — capacity at route OR ride level, confirmed vs standby (overbooking pressure valve), boarding as a verified physical event feeding roll-up counts, and demand-driven vehicle planning.
- Microcopy worth stealing: "Ridership Tracking"; "Proactive Planning"; feature phrasing above.
- Sad paths documented: standby list is the documented overflow path; what happens to a confirmed no-boarder is not specified (gap).

### A37 — TripShot rider app: Inline seat availability + RESERVE at the point of choice
- Source: https://nevadastate.edu/wp-content/uploads/2023/08/TripShot-Rider-App-Guide.pdf (official TripShot guide, read page-by-page)
- Behavior as documented:
  1. Home screen tiles: Favorites, Trip Planner, Routes, Nearby Stops, Boarding, Vanpool; sidebar: Wallet, My Trips, Notifications, Settings, Help & Feedback.
  2. Trip Planner results list each departure option with route, duration, and "25 reservable seats available." inline per option.
  3. Trip detail sheet shows "25 reservable seats available." next to a "RESERVE" action, plus per-stop "Scheduled Departure: 3:00 PM / ETA: 3:00 PM" pairs and "1 intermediate stop." expanders; screenshot also shows contextual note "This vehicle has been retrofitted for safe distancing."
  4. Routes screen: tap stop times to shift the whole route's displayed times ("clicking on any of the stop times will update all the times shown for this route").
- Problem solved: passengers self-serve into batches only where capacity exists — availability is shown at decision time, and scheduled-vs-ETA pairs set honest expectations.
- Microcopy worth stealing: "25 reservable seats available."; "RESERVE"; "Scheduled Departure:" / "ETA:"; "Where would you like to go?" (search placeholder).
- Sad paths documented: none in rider guide.

### A38 — TripShot: True-Time® subscription notifications with delay and approach thresholds
- Source: same Rider App Guide PDF (Set Up Notifications section, exact UI shown); https://www.tripshot.com/ (True-Time® branding)
- Behavior as documented:
  1. On a route map, swipe up for trip details; tap the alarm icon next to a departure; "Set Notification" screen appears.
  2. Settings shown verbatim: "For 3:30 PM departures from 1st Stop on 'Blue Route'." → checkbox "Notify me when vehicle is delayed — by 5 minutes ▾"; checkbox "When vehicle is approaching — and is 5 minutes ▾ away"; "On Days of Week: Mon, Tue, Wed, Thu, Fri"; checkbox "Only on date"; checkbox "Use mobile push notifications"; "SAVE".
  3. FAQ page: vehicle GPS "approximately every second"; ETAs factor "traffic, accidents, and construction" via Google Maps traffic data; alerts "when the shuttle is arriving or when the shuttle is delayed."
- Problem solved: passenger-side self-subscribed alerts with user-chosen delay/approach thresholds and recurrence — the consumer analog of our dispatcher red-flag thresholds (cf. Onfleet taskEta/taskDelayed thresholds, A6).
- Microcopy worth stealing: "Notify me when vehicle is delayed by [5 minutes]"; "When vehicle is approaching and is [5 minutes] away"; "Only on date"; "Use mobile push notifications".
- Sad paths documented: delay notification is a primary, user-configurable path.

---

## UBER FOR BUSINESS / UBER CENTRAL (coordinator books for app-less guests)

### A39 — Uber Central: Coordinator books a ride; guest needs no app
- Source: https://help.uber.com/business/article/arranging-uber-central-rides?nodeId=a459906c-5ed2-4d48-b09d-90e5196cb3af (fetched in full); https://www.uber.com/us/en/business/products/central/
- Behavior as documented:
  1. Coordinator at central.uber.com clicks "New ride" (upper left); enters rider info including "number of riders and preferred language," pickup/dropoff, vehicle type, driver instructions.
  2. Rider with a phone number receives "a text message or automated call (if selected) with trip details"; product page: "SMS confirmation with their ride details and a link to track their trip—no Uber app required"; guests don't pay or tip.
  3. Ride shapes: "One-way trip" / "Round-trip"; timing "Today"+"Now" or scheduled.
  4. "Flexible rides": coordinator selects only a day — "riders then request the trip via text message themselves, rather than having a specific time assigned."
  5. Constraint: "a maximum of two riders can join a ride using the multi-stop feature on Uber Central."
  6. Coordinators monitor progress, message the driver, and view upcoming bookings on the dashboard.
- Problem solved: the conference VIP flow verbatim — ops books, attendee gets SMS + tracking link, never installs anything; "preferred language" field matters for international attendees; flexible rides fit unknown landing-to-kerb timing.
- Microcopy worth stealing: "New ride"; "One-way trip"; "Round-trip"; "Flexible rides".
- Sad paths documented: edit window and cancellation (A40).

### A40 — Uber Central: Guest SMS sequence + edit/cancel windows
- Source: https://help.uber.com/business/article/text-messages-riders-receive?nodeId=1d773c1e-db7c-4a9a-bb98-7c8a8f89eb23 (via search excerpt; help.uber.com blocks fetch); arranging-rides article above (fetched)
- Behavior as documented:
  1. Message sequence: (a) confirmation as soon as the ride is scheduled, naming the business profile that booked it; (b) driver info — "driver's first name, vehicle information, license plate, estimated arrival time, and contact information" plus a real-time tracking link; (c) arrival notification — driver is arriving + "how to get help if they need it."
  2. "Scheduled rides can be edited up to 25 minutes before pickup through 'Edit ride.'"
  3. "Cancellation is available via a 'Cancel' button on the ride card, though canceling after driver pickup may trigger cancellation fees."
- Problem solved: a proven 3-touch guest SMS cadence (booked → driver assigned → arriving) including who-booked-this-for-you context and a help path — our passenger notification sequence template.
- Microcopy worth stealing: "Edit ride"; "Cancel".
- Sad paths documented: late-cancel fee; hard edit cutoff (25 min) before pickup.

---

## ZŪM + HOPSKIPDRIVE (student transport: responsible-party tracking, no-shows)

### A41 — Zūm: Milestone notifications to the responsible party
- Source: https://www.ridezum.com/faqs/zum-app/ (fetched in full)
- Behavior as documented:
  1. Default in-app notifications: "driver on the way, driver arriving, student picked up, and student dropped off." Multiple notification methods selectable per account; preferences at "Menu" → "Account → Notification preferences."
  2. "Rides" tab shows, for active trips, "scheduled and actual pickup and dropoff times, including ETAs, and a map of the ride"; home-screen ride banner shows current in-progress or next upcoming ride.
  3. Driver and vehicle profile shown for the child's ride; parents can leave instructions for the driver and post-ride feedback.
- Problem solved: the responsible-party model — conference ops (and the attendee's coordinator) get picked-up/dropped-off milestones for people in their care, with scheduled-vs-actual times for accountability.
- Microcopy worth stealing: "driver on the way", "driver arriving", "student picked up", "student dropped off"; "Manage Ride".
- Sad paths documented: cancellation flow (A42).

### A42 — Zūm: Cancel-with-reason and the system-of-record caveat
- Source: https://www.ridezum.com/faqs/zum-app/ (fetched in full)
- Behavior as documented: tap "Rides" → select ride → "Manage Ride" → "Cancel Ride" and provide a reason; FAQ warns users "must also notify your school that your student will be absent in order for the absence to be captured in school records."
- Problem solved: passenger cancellation feeding our state machine with a required reason — and an honest pattern for when transport cancellation does NOT auto-update the upstream system of record (conference registration).
- Microcopy worth stealing: "Manage Ride"; "Cancel Ride".
- Sad paths documented: explicit double-entry warning (transport vs school records).

### A43 — HopSkipDrive: "I Can't Find Rider" guided no-show flow with timed escalation
- Source: https://help.hopskipdrive.com/how-does-rider-no-show-work-Bk0WVJ5LY (via search excerpt; direct fetch 404s — article retitled "What Do I Do if I Can't Find a Rider?"); https://help.hopskipdrive.com/payment-for-riderorganizer-cancellations-HkZVU0B9Xm (excerpt)
- Behavior as documented:
  1. "At pickup, drivers can tap 'I Can't Find Rider' and the app will guide them through the necessary steps to look for the rider, alert the appropriate people if they can't find them, or report that the ride isn't needed."
  2. "If a rider does not show up for a pickup and HopSkipDrive is unable to reach the rider and the other contacts listed on the rider's account, the ride will be canceled after 20 minutes."
  3. Late definition: driver arriving "between 10 and 20 minutes after the pickup time listed in the app" counts as late.
  4. Cancellation fee tiers: >8h before pickup = free; <8h = 50% of estimated fare; <1h with claimed driver = 100%; "the fee goes directly to the CareDriver."
- Problem solved: the no-show state transition as a guided wizard, not a single button — search, escalate to listed contacts, time-boxed wait, then auto-cancel; gives our passenger `no_show` a defensible procedure.
- Microcopy worth stealing: "I Can't Find Rider".
- Sad paths documented: this entire entry; multi-contact escalation chain and 20-minute timeout are explicit.

### A44 — HopSkipDrive: Ride lifecycle with identity verification and safe-arrival confirmation
- Source: https://www.hopskipdrive.com/blog/hopskipdrive-ride-experience/ (fetched in full)
- Behavior as documented:
  1. Booking via "Schedule a Ride" (≥6h ahead; repeats claimable 6 weeks out).
  2. On claim: account holder gets "a text notification and an email with their information" — driver photo, vehicle info, bio.
  3. Day-of: text when driver departs; in-progress ride labeled "NOW" in app; arrival text includes "a photo of the CareDriver and their vehicle."
  4. Pickup verification: "the CareDriver will say the established code word to confirm they're the right CareDriver. The rider will then confirm their birthday to the CareDriver." (mutual authentication)
  5. Drop-off: driver ensures "the rider is safely inside their destination before leaving"; organizer gets confirmation text that "your rider has arrived safely at their destination," then rating pop-up and receipt.
- Problem solved: chain-of-custody for passengers who aren't the account holder — driver-claim notification, mutual code-word verification at boarding (prevents wrong-car/wrong-passenger), and a closing safe-arrival message to the coordinator.
- Microcopy worth stealing: "NOW" (in-progress label); "your rider has arrived safely at their destination" (paraphrase-quoted in source).
- Sad paths documented: verification step exists precisely to catch wrong-match at pickup.

---

## VIA (microtransit — thin public docs, noted)
Via's public pages document only high-level behavior; no public help center was found. Captured for completeness:

### A45 — Via: Driver app no-show reason requirement + offline resilience
- Source: https://ridewithvia.com/solutions/paratransit/operator-app (fetched); https://ridewithvia.com/integrated-transit (search excerpt)
- Behavior as documented:
  1. Driver App shows "relevant passenger information at pickup — like rider notes, payment method, and accommodations"; configurable to "require a reason for a no-show."
  2. "Offline Mode" keeps step-by-step directions running through signal loss; "riders continue to receive notifications and other communications as usual, despite the driver's loss of connectivity."
  3. "Via's automated booking, dispatch, and reassignment technology absorbs delays and no-shows."
  4. Real-time trip history and "timestamped activity logs for incident resolution"; masked-number calls to riders.
- Problem solved: no-show requires structured reason (matches A8, A42); rider notifications decoupled from driver connectivity; timestamped activity log = our audit trail.
- Microcopy worth stealing: "Offline Mode".
- Sad paths documented: connectivity loss and no-shows explicitly designed for.

---

## FIRST-PRINCIPLES CANDIDATES (unsourced — do NOT attribute to any app)

- FP1 — Roll-up arrival counts by origin/time ("10 arriving 10:00 from BOM"): no surveyed product documents an origin-grouped arrivals roll-up widget. Closest documented neighbors: Limo Anywhere airport filtering on the dispatch grid (A22) and TripShot demand-based planning (A36). The counts-by-hub-by-slot board itself must be designed first-principles.
- FP2 — Batch-level state machine (planned→ready→in_progress→completed/cancelled): surveyed products track per-task/per-trip/per-route states; none document a named "batch readiness" gate (e.g., ready = vehicle assigned AND all passengers assigned AND driver acknowledged). Compose from Onfleet Route Plans (A4) + Circuit publish gates (A26/A29).
- FP3 — Red-flag triage queue for travel changes: flight products alert the traveler (A32–A35) and Moovs retimes the trip + texts the driver (A13, A18), but no product documents a dispatcher-facing queue of "passengers whose travel changed and whose batch assignment is now suspect." Build from AeroAPI webhooks → batch diff → Circuit-style at-risk markers (A30).
- FP4 — Auto-SUGGEST batches with explicit accept step over passenger clusters: route optimizers (A24, A29) and Onfleet RO "Accept" (A4) prove the review-then-accept pattern for stops/routes, but clustering attendees into arrival/departure batches by travel record similarity is undocumented anywhere surveyed.
- FP5 — Passenger `boarded` event captured by driver per-passenger from a manifest (tap each name): TripShot documents boarding validation and counting (A36) and Limo Anywhere documents trip-level "Passenger on Board" (A21), but a per-passenger tap-to-board manifest UI is not explicitly documented in any source found.

---

## Coverage log

WebSearch queries run (in order):
1. "Onfleet dispatch dashboard task assignment driver app documentation support" — hit (support articles)
2. "Onfleet customer SMS notifications live tracking link proof of delivery failed delivery help center" — hit
3. "Moovs software trip status driver assignment flight tracking documentation help center" — hit
4. "Limo Anywhere flight tracking pickup time driver app trip statuses 'on the way' 'passenger on board' documentation" — hit (kb.limoanywhere.com)
5. "Moovs help center article auto dispatch trip 'support.moovsapp.com'" — hit
6. "Moovs help center flight tracking 'trip status' passenger text notifications driver app" — hit (passenger text microcopy in excerpt)
7. "Moovs 'farm out' affiliate trip help center moovsapp" — hit (blog)
8. "Moovs driver notification 'flight' text if flight time updated help center" — hit; revealed canonical intercom.help/moovs-05c940f1970e host
9. "'Send driver a text if flight time is updated' Moovs" — confirmed article; URL extracted from related-links HTML
10. "Routific help docs review edit routes before dispatch re-optimize add stops capacity constraints" — hit (academy.routific.com)
11. "Circuit for Teams help docs optimize routes edit before sending to drivers reoptimize live routes vehicle capacity" — hit (rebrand to Spoke noted)
12. "Flighty app delay cancellation alerts features 'before airlines' push notification documentation" — hit (flighty.com/help)
13. "FlightAware flight alerts configure notifications delays cancellations gate changes help" — hit (Zendesk excerpts)
14. "TripShot documentation dispatcher rider boarding vehicle capacity shuttle operations driver app" — hit (incl. Nevada State PDF)
15. "Via TransitTech documentation operations console driver app boarding no-show rider notifications" — hit (marketing-level only)
16. "Uber Central book rides for guests no app SMS text link coordinator dashboard help documentation" — hit (help.uber.com fetchable)
17. "Zum student transport parent app notifications driver live tracking no-show help documentation" — hit (ridezum.com FAQs)
18. "Onfleet driver app mark task failed failure reason 'could not complete' support" — hit (completion reasons)
19. "HopSkipDrive help no-show ride cancellation policy CareDriver waits live tracking" — hit
20. "'HopSkipDrive' no-show '10 minutes' OR '20 minutes' driver 'can't find' rider procedure help center" — hit ("I Can't Find Rider")
21. "Via 'Flexible Fixed Route' OR microtransit reassignment absorb delays no-shows dispatch documentation ridewithvia" — marginal (repeat info)
22. "Onfleet 'Task Status' support article unassigned assigned active completed dashboard colors" — hit (status colors, delayed gold dot)
23. "Routific help vehicle capacity 'load' units per stop set driver capacity academy.routific.com" — hit
24. "Limo Anywhere knowledge base passenger manifest grid dispatch farm out affiliate trip kb.limoanywhere.com" — hit (Auto Farm, dispatch grid)
25. "Circuit for Teams help center 'help.getcircuit.com' edit live route add stop driver notified recipient updates" — hit (article slugs)
26. "TripShot reservations 'standby' confirmed list seat capacity documentation" — hit (confirmed/standby)
27. "'Uber Central' guest text message example 'track' ride no app required what does guest receive" — hit (3-message sequence)
28. "Onfleet route plan dashboard 'Routes tab' create route assign driver vehicle support article" — hit (create-route modal)
29. "Limo Anywhere dispatch grid airport view arrivals flight status column blog 2026" — hit (flight columns, JFK filter)
30. "TripShot driver app manifest check-in vehicle assignment pass validation documentation" — mostly repeat (diminishing returns)
Loop ended: queries 21 and 30 were largely repeats; post-#30 only refinement fetches were performed. Two-consecutive-dry threshold effectively met at the category level.

Direct fetches — successes:
- docs.onfleet.com markdown: llms.txt, tasks.md, webhooks.md, create-task.md, routeplan.md, dependencies.md, team-auto-dispatch.md, state.md (all 200)
- kb.limoanywhere.com: flight tracking, trip statuses, status change limitations
- intercom.help/moovs-05c940f1970e: articles 8007480, 8006883, 9938857, 6946029, 8002457 (full microcopy)
- academy.routific.com: 1317935, 1317942, 1317927, 2577961, 1317930
- help.spoke.com (Circuit): 6208915, 6962409, 7041450 (full microcopy); collection page yielded full article slug list
- flighty.com/help: flighty-notifications, delay-predictions
- flightaware.com/commercial/aeroapi
- help.uber.com arranging-uber-central-rides; ridezum.com/faqs/zum-app; hopskipdrive.com ride-experience blog; ridewithvia.com operator-app; tripshot.com/all-products; Nevada State TripShot Rider App Guide PDF (pages read with screenshots)
- limoanywhere.com Auto Farm + dispatch grid blog posts

Dead ends:
- support.onfleet.com (Zendesk): HTTP 403 via WebFetch AND curl with browser UA — relied on docs.onfleet.com markdown + search excerpts of named articles
- support.flightaware.com (Zendesk): HTTP 403 — search excerpts used
- support.moovsapp.com: TLS cert mismatch (curl exit 60), then 404s even with -k; intercom.help canonical host worked
- help.spoke.com via WebFetch: 403; curl with browser UA worked
- tripshot.com blog posts (reservations, reservations-FAQs): 404 (site restructure); product page + search excerpts used
- help.hopskipdrive.com article: 404 via WebFetch (retitled); search excerpts used
- uberforbusinesshelp.com: ECONNREFUSED
- docs.onfleet.com/reference/tasks via WebFetch returned nav-only; raw .md fetch solved it

Apps skipped / thin:
- Via: no public help center found; only marketing-level pages — documented at A45 with that caveat.
- HopSkipDrive chosen over Zūm for no-show depth; both covered. Zūm driver-side manifest docs not publicly available.
- Onfleet "Courier Client View" and tracking-page article bodies unreachable (Zendesk 403) — covered via marketing page + webhook/API evidence.
