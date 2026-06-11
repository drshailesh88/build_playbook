# TRANSPORT — UX Pattern Harvest — BY-FLOW

- Mode: by-flow (search by user task, end to end)
- Date: 2026-06-11
- Source method: WebSearch/WebFetch over vendor docs (Mobbin MCP unavailable this session)
- Sourcing note: Zendesk-hosted help centers (Onfleet, OptimoRoute, Spoke) return HTTP 403 to direct fetch. For those, flows are recorded from search-result excerpts of the named article; the article URL is cited and the limitation is flagged inline and in the Coverage log. Intercom-hosted (Moovs, Dispatch), WordPress KB (Limo Anywhere, Jungleworks/Tookan), readme.io (Bringg), Intercom academy (Routific), and help.uber.com all fetched cleanly.

---

## TASK 1 — Assign passengers/orders to a vehicle/driver

### F1 — Assign tasks to a driver: Onfleet
- Source: https://support.onfleet.com/hc/en-us/articles/360023910111-Task-Assignment ; https://support.onfleet.com/hc/en-us/articles/203798059-Assign-a-Task ; https://support.onfleet.com/hc/en-us/articles/205706985-Auto-assign-tasks-to-drivers (recorded from search excerpts; Zendesk blocks direct fetch)
- Flow as documented:
  1. Drag a task from the Unassigned section in the sidebar onto a driver's name → task appends to the end of that driver's route.
  2. Or drag it directly into a specific position within the driver's route.
  3. Or drag from an existing task marker on the map to the new task → places it immediately after that task; drag from the driver marker → adds it to the start of the route.
  4. Or, while creating a task, select "Assign" at the bottom of the Task creation window → adds to end of driver's route.
  5. Or right-click the task on the dashboard → "Assign task" → select driver or team from a dropdown.
  6. Auto-assign: select task(s) in the sidebar → right-click → auto-assign → choose "closest driver" (shortest distance from destination) or "shortest route" (driver with shortest total distance after assignment).
- Decision points / guardrails: assignment position is an explicit choice (end of route vs. inserted position); auto-assign requires the dispatcher to choose an optimization criterion.
- Problem solved: maps to our "add vehicles and assign passengers" — multiple equivalent gestures (drag, right-click, assign-at-create) reduce friction for batch building.
- Sad paths documented: none documented in these excerpts.

### F2 — Assign a driver to a reservation: Moovs
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/6609944-assigning-a-driver-to-a-reservation
- Flow as documented:
  1. Method 1 (reservation): open the reservation → select "Add a Driver" → choose a driver from the dropdown.
  2. Method 2 (dispatch list): locate the driver column in the Dispatch List View → double-click the driver cell on the desired reservation row → select a driver from the dropdown.
- Decision points / guardrails: none documented (article covers UI mechanics only; no conflict warning is described here — but see F22 for Moovs availability conflicts).
- Problem solved: inline assignment from the day's dispatch grid — assign without leaving the roll-up view.
- Sad paths documented: none documented.

### F3 — Assign agents to tasks: Tookan (Jungleworks)
- Source: https://help.jungleworks.com/knowledge-base/task-assignment-on-tookan/
- Flow as documented:
  1. At creation: "Create Task OR Bulk Import Tasks" → fill the task creation form → "Select a Team from the drop-down" → "Choose one or multiple agents from 'Assign agent'" → "Click on 'Submit' to save the task."
  2. Post-creation: "Click on Tasks in the left pane – Under the Actions column, click on three dots and select Assign. – lastly Fill in the details and click on Submit."
  3. Dashboard: open the Unassigned tab → click the "Assign Agent" button on the task tile → dropdown lists idle agents → selecting an agent assigns the task.
- Decision points / guardrails: the dashboard dropdown only shows idle agents (availability filter at point of choice).
- Problem solved: bulk import + assign maps to our "plan batches from attendee travel data, then attach vehicles/drivers."
- Sad paths documented: a separate article exists for "Can't assign tasks to agents" (https://help.jungleworks.com/knowledge-base/cant-assign-tasks-to-agents/), acknowledging the blocked-assignment case.

### F4 — Reassign orders on a planned route to a different driver: Bringg
- Source: https://help.bringg.com/docs/assign-a-different-driver-for-orders-on-a-planned-route
- Flow as documented:
  1. Navigate to Planning or Dispatch.
  2. Select one or more orders, or an entire route.
  3. Click "Assign To..." (top left) or select a driver name in the "Assigned To" column.
  4. Search for and select the target driver.
  5. Review the summary details at the top of the reassignment window.
  6. Click the action button — "Assign", "Merge", or "Create New..." (bottom right).
  7. If creating a new route, complete required fields (route identifier, start/end times, origin) and select "Create".
  8. Adjust the delivery sequence as needed.
- Decision points / guardrails: "You can only reassign orders from/to drivers on the same team"; orders must have time windows compatible with the target driver's availability; vehicle capacity must accommodate a merged route's combined load; UI shows checkmarks for "Match Skills" (driver qualifications) and "Floating Inventory" before committing.
- Problem solved: directly maps to moving passengers between vehicles with capacity limits enforced at the moment of reassignment.
- Sad paths documented: incompatible time windows / capacity prevent the action (constraints stated); team mismatch blocks reassignment.

---

## TASK 2 — Dispatch a driver / send a route to a driver

### F5 — Dispatch routes to drivers: Routific
- Source: https://academy.routific.com/en/articles/1317927-how-to-dispatch-routes
- Flow as documented:
  1. Prerequisite: enter driver phone numbers in the "Dispatch" tab.
  2. Click "Dispatch To Drivers".
  3. Click "Publish Routes" at the bottom-right of the screen.
  4. "Your drivers will receive a text message with a link to their route."
  5. Alternative: "Download Summary" produces CSV files of delivery stops and driver workload instead of sending to phones.
- Decision points / guardrails: dispatch is a two-step explicit action (Dispatch To Drivers → Publish Routes); SMS-link delivery means drivers need no pre-installed account/app to receive the route.
- Problem solved: the "dispatch" moment is an explicit publish gate — plan freely, then push once; matches our "humans finalize" rule.
- Sad paths documented: none documented in this article (see F16/F17 for post-dispatch changes).

### F6 — Auto Dispatch a trip: Moovs
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/13251153-what-is-auto-dispatch ; https://intercom.help/moovs-05c940f1970e/en/articles/13251239-how-to-trigger-auto-dispatch-for-a-trip ; https://intercom.help/moovs-05c940f1970e/en/articles/13251189-how-to-configure-auto-dispatch-settings (collection index fetched; per-article detail from index summaries)
- Flow as documented:
  1. Auto Dispatch "automatically finds and assigns available drivers to trips in real time."
  2. Start an Auto Dispatch to find/assign a driver immediately, or schedule it for a future time.
  3. Settings control how Moovs searches for drivers (fleet coverage area, driver availability) and how long it waits for responses.
- Decision points / guardrails: configurable response-wait window before moving on; coverage-area scoping.
- Problem solved: automated driver-finding with a human-set policy — the system suggests/executes, the operator sets the rules.
- Sad paths documented: timeout behavior implied by "how long it waits for responses" (see also F21 driver-decline notification).

### F7 — What the driver receives after dispatch: Routific Driver app
- Source: https://help.routific.com/en/articles/16-using-the-routific-mobile-app ; https://academy.routific.com/en/articles/1317927-how-to-dispatch-routes (recorded partly from search excerpts)
- Flow as documented:
  1. Driver receives the dispatched route (SMS link / app).
  2. Driver taps the assigned route → sees it plotted on a map; can switch between map view and stop list.
  3. Driver sees delivery instructions and custom fields (e.g., flags like cash payment or no-contact) per stop.
  4. Driver navigates with their preferred app (Google Maps, Apple Maps, Waze).
  5. Driver posts status updates per stop; GPS location is shared to the dispatcher in real time.
- Decision points / guardrails: none documented.
- Problem solved: defines the minimum driver payload: ordered stops, per-stop instructions, status update affordance, live location back-channel.
- Sad paths documented: none documented.

---

## TASK 3 — Notify the passenger of pickup details

### F8 — Text messages riders receive for rides booked on their behalf: Uber Central / Uber Health
- Source: https://help.uber.com/business/article/text-messages-riders-receive?nodeId=1d773c1e-db7c-4a9a-bb98-7c8a8f89eb23
- Flow as documented:
  - On-demand trips (3 messages): 1) scheduling confirmation — "notifies rider that their company scheduled a ride," shows business name and date/time; 2) driver accepted/arriving — driver first name, vehicle details, license plate, ETA, real-time tracking link; 3) trip canceled (if applicable) — directs rider to contact the company to reschedule.
  - Scheduled trips (4 messages): confirmation; reminders "at 9am the day before and 30 minutes before the trip"; driver accepted/arriving (same content); cancellation notice.
  - Flexible rides (5 messages): booking confirmation prompting the rider to request the ride; reminders with redemption prompt ("at 6pm the day before and 3pm day-of" for future bookings; "2 hours after booking" for same-day) including "when the trip request link will expire"; request confirmation ("driver details coming soon"); driver accepted (driver name, vehicle, plate, ETA, contact info, tracking link); cancellation notice.
  - "Messages use the language your browser is set to during ride arrangement."
- Decision points / guardrails: message cadence is fixed per ride type; cancellation always routes the rider back to the arranging company, not to Uber.
- Problem solved: a complete, timed passenger-notification ladder for rides arranged by a coordinator — exactly our "notify passengers of pickup details" with no app required.
- Sad paths documented: trip-canceled message variant for every ride type; link-expiry warning for flexible rides.

### F9 — Recipient notification triggers and tracking page: Onfleet
- Source: https://support.onfleet.com/hc/en-us/articles/360023669392-Notification-Set-Up-Triggers ; https://support.onfleet.com/hc/en-us/articles/360023669332-Customized-Recipient-Experience ; https://support.onfleet.com/hc/en-us/articles/203798089-Create-a-notification (recorded from search excerpts; Zendesk blocks direct fetch)
- Flow as documented:
  1. Admin opens the Communications tab to set up automated SMS to recipients based on driver-action triggers; "there can only be one notification per trigger."
  2. Triggers available: "Task Started" (driver starts the task), "ETA" (fires when ETA falls below a threshold you specify), "Driver Arriving" (driver within 150 meters / ~500 feet of destination).
  3. Message text fully customizable with tags: recipient name, driver name, ETA, vehicle information, tracking link ({trakLink}).
  4. Tracking page shows driver name, live location, ETA; customizable colors/details; custom domain + branding on Enterprise.
- Decision points / guardrails: one-notification-per-trigger rule; ETA threshold is operator-set.
- Problem solved: trigger-based passenger comms tied to real driver state (started / ETA / proximity) rather than schedule guesses.
- Sad paths documented: none documented in these excerpts.

### F10 — Automated passenger status emails/SMS: Limo Anywhere
- Source: https://kb.limoanywhere.com/docs/setting-up-email-and-sms-notifications-in-limo-anywhere/ ; https://www.limoanywhere.com/2025/03/27/creating-account-specific-scheduled-messaging-templates/ (latter from search excerpt)
- Flow as documented:
  1. Go to My Office → Company Settings → Messaging & Template Settings → "Notifications" tab.
  2. Configure recipients: primary contact (email + SMS), alternate contact, custom email for new-account notifications; for SMS, "select the wireless provider for the primary contact."
  3. Events documented in the setup article: new account creation, online reservation changes/cancellations, quote requests.
  4. Scheduled messaging templates (blog) automate communication based on trip statuses, with account-specific templates "to ensure that bookers, billers, and passengers receive the right information at the right time."
- Decision points / guardrails: doc recommends "Regularly test the notification system to ensure messages are being sent and received as expected."
- Problem solved: status-driven, per-account message templates — the resend/who-gets-what policy lives in settings, not in each booking.
- Sad paths documented: none documented.

---

## TASK 4 — Handle a flight delay for a scheduled airport pickup

### F11 — Auto-text the driver when flight time changes: Moovs
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/8002457-driver-notifications-send-driver-a-text-if-flight-time-is-updated
- Flow as documented:
  1. Trigger: flight arrival time updates by 15 minutes or more, and the pickup location is an airport.
  2. System automatically texts the driver: "Hey [driver first name], Your trip [confirmation number] for original [trip date & time] has been updated to [new trip date & time] due to a change in flight time."
- Decision points / guardrails: 15-minute threshold prevents notification noise from minor ETA jitter.
- Problem solved: detection → adjustment → driver told, with zero dispatcher action — our "react to flight changes" red-flag loop, automated for the driver leg.
- Sad paths documented: none documented (no passenger-side variant described in this article).

### F12 — Real-time flight tracking auto-adjusts pickup time: Limo Anywhere
- Source: https://kb.limoanywhere.com/docs/how-the-set-up-and-use-real-time-flight-tracking/
- Flow as documented:
  1. Flight tracking is "automatically turned on for ALL operators"; auto-tracking via FlightStats activates when pickup date, time, airport, airline, and flight number are entered in routing.
  2. To auto-adjust pickup time: My Office → Company Settings → Company Preferences → Reservations → set "Update Pick Up time based on the Arrival flight's ETA and flight offset" to "Yes."
  3. Eight offset choices then appear on PU routing: "Do not adjust based on flight arrival", "When your flight arrives", and 15/30/45/60/90/120 "minutes after gate arrival."
  4. System continuously monitors arrival ETA and recalculates pickup time. Documented example: "If the Arrival Flight Time is 12:30PM and the offset selection for the reservation is '15 min after gate arrival', then flight arrives at 12:35PM then the PU Time will keep that 15 minute offset and be set to 12:50PM."
  5. Manual tracking also available via right-click dispatch menu (FlightAware or FlightView).
- Decision points / guardrails: only PU (pickup) flights trigger auto-updates; one flight per reservation controls time adjustment; extra flights must be modeled as Stops/Waits.
- Problem solved: the delay is absorbed by a standing offset rule, so the plan self-heals and the manifest stays truthful.
- Sad paths documented: limits stated (DO flights don't adjust; multi-flight reservations constrained). Notifications/recipients not covered in this article.

### F13 — Flight number on a scheduled airport pickup: Uber Reserve
- Source: https://help.uber.com/en/riders/article/using-uber-reserve?nodeId=71708d67-bbac-4dda-9d32-53c2509bdd1b
- Flow as documented:
  1. During airport reservation setup, "Enter your flight number" — this enables driver notifications about delays, early arrivals, and landings.
  2. "Wait time is included once your flight lands, allowing time to retrieve luggage if needed."
  3. Cancellation: "You can cancel a reservation at no charge up to an hour before the start of the ride"; within 60 minutes, a fee applies if a driver accepted; free cancellation if the driver is expected to be more than 10 minutes late.
- Decision points / guardrails: flight-linked wait time replaces fixed wait timers for airport pickups.
- Problem solved: travel-record linkage (flight number) drives both driver alerts and grace-period policy.
- Sad paths documented: late-driver free-cancel path; fee tiers.

### F14 — Flight sync + delay alerts for event attendees: Azavista
- Source: https://www.azavista.com/travel-and-flight-management
- Flow as documented:
  1. "Automatic synchronization of flight details, changes, and cancellations" from integrated booking systems.
  2. "Arrange efficient shuttle services based on clustered arrival/departure times."
  3. "Receive alerts about flight delays affecting your transportation plans."
  4. "Track changes and manage modifications seamlessly in the bookings."
- Decision points / guardrails: none documented (marketing-grade doc; flows asserted, not stepped).
- Problem solved: the exact conference job — cluster arrivals into shuttles from synced travel data and get red-flag alerts on flight changes.
- Sad paths documented: none documented.

---

## TASK 5 — Mark a passenger no-show

### F15 — No-show / late-cancel economics: HopSkipDrive
- Source: https://www.hopskipdrive.com/pricing-and-payment-terms/
- Flow as documented:
  1. "A wait time fee is applied if the rider is 10 or more minutes late to the scheduled pick-up."
  2. Cancellation tiers (after a CareDriver is matched): >8 hours before — no fee; 1–8 hours — "a Cancelation Fee of 50% of your estimated fare will apply"; <1 hour — "you will be charged the full estimated fare."
- Decision points / guardrails: timers are explicit (10-minute lateness threshold; 8h/1h cancel windows).
- Problem solved: precedent for time-boxed no-show rules with escalating consequences — usable as our no-show timer policy.
- Sad paths documented: this page documents only fees; the contact-everyone-then-cancel operational procedure was not found on a fetchable official page (see Coverage log).

### F16 — "No Show" as a trip status: Limo Anywhere
- Source: https://www.limoanywhere.com/2022/02/10/setting-up-custom-statuses-for-your-limo-anywhere-system/ (search excerpt) ; https://kb.limoanywhere.com/docs/how-to-customize-and-manage-trip-statuses/
- Flow as documented:
  1. "No Show" is "an optional status of the trip when a passenger does not show for pickup" — part of the configurable status set.
  2. The DriverAnywhere status workflow can be renamed/extended with custom statuses to match company terminology; status mapping lets the system "interpret the status a trip is in, so that features appropriate to that state or status can be deployed."
- Decision points / guardrails: no-show is a first-class trip status (preserved record), not a deletion.
- Problem solved: our day-of execution states (boarded / no-show / completed) as a configurable status machine with mapped side effects.
- Sad paths documented: none beyond the status itself.

### F17 — Rider no-show on a scheduled ride: Uber (driver side) + Zum (parent side)
- Source: https://help.uber.com/driving-and-delivering/article/reserve-faq?nodeId=edd655fe-d600-44bf-97cf-e917fbd6cc72 (search excerpt) ; https://www.ridezum.com/faqs/parents/
- Flow as documented:
  1. Uber Reserve driver FAQ: "if the rider doesn't show, please follow in-app guidance to get a cancellation fee minus the service fee" — the driver triggers a guided in-app no-show flow after the wait window (5 min UberX/XL/Comfort, 15 min premium, per F13 source).
  2. Zum (pre-emptive no-show avoidance): parents "Cancel any ride that is no longer needed through the Zum app" — navigate to the ride → "Cancel Ride in the action menu and provide a reason"; canceling a ride "does not affect school attendance records" (separate school notification required).
- Decision points / guardrails: wait-window precondition before no-show can be claimed; cancellation requires a reason (recorded).
- Problem solved: two halves of our no-show story — driver-side guided marking with timer preconditions, and passenger-side self-cancel with reason capture to prevent the no-show.
- Sad paths documented: the no-show itself is the sad path; both products give it an explicit guided flow.

---

## TASK 6 — Board passengers / day-of check-in

### F18 — Rider QR boarding via Wallet: TripShot (deployed at 128 Business Council)
- Source: https://128bc.org/new-riders/mobile-rider-app/ ; https://www.ohio.edu/transportation-parking/tripshot-rider-app-guide ; https://apps.apple.com/us/app/tripshot-driver/id988698451 (driver-side description)
- Flow as documented:
  1. Rider sets up Wallet first: main menu (three bars) → "Wallet" → buy "Passes" (single or multi-ride) or load "Balance."
  2. Boarding, Bluetooth method: as the shuttle approaches, open Wallet → select the shuttle from "Nearby Vehicles."
  3. Boarding, QR method: "Find the QR code inside the shuttle door. Open Wallet and tap Board by scanning QR code." Scan happens inside the TripShot app, not the camera.
  4. "Tripshot will activate one ride from your 'unactivated' passes."
  5. Fallback: "You can board without the app—but you'll need to use exact bills/change."
  6. Driver side (App Store description): automatic passenger counting, digital pass validation, rider manifests; drivers can confirm reservations during boarding to decide "whether or not they should be allowed to board."
  7. Alerts: rider must favorite the route ("the heart in the top right corner") to receive service alerts; trip notifications via "tap the alarm icon → Edit your notification settings and Save" for "True-Time push notifications about your shuttle."
- Decision points / guardrails: boarding consumes exactly one pass; reservation check gates boarding; non-app fallback documented.
- Problem solved: scan/tap boarding plus driver-side manifest validation and passenger counting — our boarded-state capture and headcount source.
- Sad paths documented: rider without app (cash fallback); reduced-fare approval delay ("Please allow one full business day").

### F19 — Driver-confirmed pickup with parent notification: Zum
- Source: https://www.ridezum.com/faqs/parents/
- Flow as documented:
  1. Student boards; identity is confirmed; "the driver notes in their app that the passenger has been picked up."
  2. Parent receives a confirmation message; "you will see the actual pickup time on the Ride Details screen, along with an ETA for the dropoff location."
  3. Default in-app notifications: "driver on the way, student picked up, student dropped off"; SMS opt-in via Menu → Account → "Notification preferences."
  4. Live tracking: upcoming ride in a banner on the home screen; "Rides" tab lists all students' upcoming/completed rides.
- Decision points / guardrails: boarding event is driver-attested and timestamped; guardian notification fires on the event, not the schedule.
- Problem solved: per-passenger boarded events that immediately update a stakeholder's view — our boarded → notify loop.
- Sad paths documented: schedule/address changes cannot be made in-app ("reach out to your school or district") — change control is upstream.

### F20 — Shuttle stop check-in with capacity tracking: Moovs Shuttle
- Source: https://www.moovsapp.com/shuttle-app ; https://intercom.help/moovs-05c940f1970e/en/articles/8430112-booking-a-seat-on-the-moovs-shuttle-app
- Flow as documented:
  1. Passenger books: open shuttle link → select date → choose "Pick-up AND Return," "Only pick-up to office," or "Only return from office" → pick stop and time slot → review → confirm; trip appears in "Reservations."
  2. Day-of (product page): drivers "check in passengers—manually or via QR code—at every stop"; "unique QR codes generated for each seat"; drivers "view expected passengers, check-in status, and capacity tracking for each stop."
- Decision points / guardrails: manual check-in fallback alongside QR; per-stop expected-vs-checked-in view is the headcount reconciliation surface.
- Problem solved: per-stop expected/boarded/capacity triad — exactly our hub-to-hub batch boarding screen.
- Sad paths documented: none documented.

### F21 — Offline boarding/completion: Onfleet driver app
- Source: https://support.onfleet.com/hc/en-us/articles/10228814951060-Driver-App-Settings ; https://support.onfleet.com/hc/en-us/articles/10228905705876-Driver-Status (recorded from search excerpts; Zendesk blocks direct fetch)
- Flow as documented:
  1. Offline mode (opt-in setting) keeps drivers productive in low-connectivity areas.
  2. With offline mode disabled (default): "a driver is restricted from completing or starting a new task until they have enough connectivity"; in low/no bandwidth "drivers have two minutes to start or complete tasks before they need to return to bandwidth."
  3. Offline drivers are marked to dispatch with a "slashed cloud icon" and display as "Offline."
- Decision points / guardrails: explicit grace window (2 minutes); dispatcher-visible offline indicator.
- Problem solved: day-of execution at airports/basement garages with bad signal — defines offline policy and its dispatcher-visible signal.
- Sad paths documented: connectivity loss is the documented sad path, including its limits.

---

## TASK 7 — Re-plan after a cancellation

### F22 — Make last-minute changes to routes after dispatch: Routific
- Source: https://academy.routific.com/en/articles/1317942-make-last-minute-changes-to-routes-after-dispatch
- Flow as documented:
  1. Prerequisite: Live Tracking enabled; switch to "Plan" mode (not "Live" mode).
  2. Open the stop (timeline click, map click, or top-right search).
  3. "Edit" to modify stop info; "Unschedule" to move the stop to the yellow unscheduled bar; trash icon to delete entirely.
  4. Add stops: "Stops" tab → "+" icon; drag unscheduled stops into a route individually or click "Insert Unscheduled" to add all.
  5. Drivers tab: "+" to add drivers, pencil icon to edit/remove. "You cannot edit a driver's information once they start their routes."
  6. "Any changes you make aren't officially published to your drivers until you click 'Publish Changes'." A red notification icon marks unpublished edits.
  7. After republishing, "our app will automatically refresh and update to reflect those changes" — drivers get the new route automatically.
- Decision points / guardrails: staged-changes model (edit freely → explicit Publish gate → auto-push to drivers); started-route lock on driver edits.
- Problem solved: the canonical re-plan loop after a cancellation: pull the passenger out, keep the rest of the route intact, publish once.
- Sad paths documented: route-started lock; unpublished-changes indicator prevents silent drift.

### F23 — Undo limits on optimization/dispatch: Routific
- Source: https://academy.routific.com/en/articles/3567272-can-i-stop-or-undo-an-optimization-or-a-dispatched-route
- Flow as documented:
  1. "It is not possible to force-stop the optimization process" — it continues in the background even if the browser closes.
  2. A dispatch cannot be undone; instead "re-dispatch the route with any necessary modifications."
  3. A driver cannot "unstart" a started route.
  4. Recommended instead: last-minute adjustments after dispatch, swapping routes between drivers, locking routes to prevent accidental changes.
- Decision points / guardrails: irreversibility is documented explicitly; route locking offered as the preventive control.
- Problem solved: defines which transport-plan actions are one-way doors — informs where our confirmations must live.
- Sad paths documented: this whole article is the sad-path doc.

### F24 — Delete/cancel a task already on a route: Onfleet + Dispatch
- Source: https://support.onfleet.com/hc/en-us/articles/20498484626580-Edit-or-Delete-a-Task (search excerpt; Zendesk blocks fetch) ; https://support.dispatchit.com/en/articles/8654568-creating-and-managing-a-route (search excerpt)
- Flow as documented:
  1. Onfleet: tasks can only be deleted "if a driver has not started the task yet"; deleted tasks are "immediately removed from the dashboard and driver app"; "once deleted the task can not be recovered."
  2. Dispatch: before a route is sent — drag the delivery back to Unassigned, or three-dot menu → "Unassign Delivery" (returns it to Today's Deliveries). After the route is sent — cancel the delivery in the web app, which "will send a push notification to the driver"; calling the driver and having them skip the stop is also documented.
- Decision points / guardrails: started-task block; pre-send vs post-send paths differ; push notification guarantees the driver hears about the removal.
- Problem solved: removing one passenger/stop without disturbing the rest of the route, with driver informed automatically.
- Sad paths documented: unrecoverable deletion warned; in-motion change handled via push + skip.

---

## TASK 8 — Set up a recurring shuttle schedule

### F25 — Recurring tasks: Tookan
- Source: https://help.jungleworks.com/knowledge-base/recurring-tasks/
- Flow as documented:
  1. Activate: Menu → Extensions → "Activate Recurring Tasks" (ADD-ONS section).
  2. Click "Create Task" (top right).
  3. A REPEAT option appears in the task form. Frequencies: Daily ("the task will repeat on all days"), Weekly (pick days S/M/T/W/F), Monthly (same date each month), Yearly.
  4. End conditions: "After" (number of occurrences) or "On" (exact end date/time).
  5. "Starts On" sets the start; generated tasks begin at 5:00 AM in your timezone.
  6. Click "CREATE."
  7. Optional: "Create Recurring Tasks One Day Prior" auto-generates and assigns tasks 24 hours before the scheduled date.
- Decision points / guardrails: explicit end conditions required; one-day-prior generation keeps the board uncluttered.
- Problem solved: template-once, copy-forward shuttle loops between hubs.
- Sad paths documented: companion article "Recurring tasks cannot be controlled?" (https://help.jungleworks.com/knowledge-base/recurring-tasks-cannot-be-controlled/) acknowledges runaway-recurrence issues.

### F26 — Multi-week planning with day constraints: OptimoRoute
- Source: https://help.optimoroute.com/hc/en-us/articles/27702005314324-Plan-orders-over-multiple-days-or-weeks ; https://help.optimoroute.com/hc/en-us/articles/36301619325588-Create-recurring-orders-beta (recorded from search excerpts; Zendesk blocks direct fetch)
- Flow as documented:
  1. Weekly planning allows planning "up to 5 weeks at a time."
  2. Add an "Allowed Days" constraint per order (edit individually or via an "Allowed Days" import column) to restrict which weekdays an order can be serviced.
  3. Add a "Blackout Date" column on import for unworkable dates.
  4. "Basic view" tab adjusts constraints one date at a time; "Advanced view" adjusts multiple driver constraints across the whole planning window.
  5. "Create recurring orders" exists as a beta feature (article title; steps not retrievable — Zendesk 403).
- Decision points / guardrails: allowed-days/blackout constraints are inputs to the optimizer, not post-hoc edits.
- Problem solved: planning a repeating multi-day conference transport program in one pass.
- Sad paths documented: none documented in retrievable excerpts.

---

## TASK 9 — Give a coordinator/third party visibility into a trip

### F27 — Coordinator books and monitors guest rides: Uber Central
- Source: https://help.uber.com/business/article/arranging-central-rides?nodeId=a459906c-5ed2-4d48-b09d-90e5196cb3af
- Flow as documented:
  1. Sign into central.uber.com → "New ride" (upper left) → choose one-way or round trip.
  2. Enter guest details (passenger count, preferred language), pickup/dropoff (second dropoff via "Add stop"), timing ("Today"/"Now", scheduled, or flexible), vehicle type, optional driver notes, expense code/memo.
  3. Guest "will receive a text message or automated call (if selected) with trip details if you enter their number."
  4. Monitor via "Today's activity" / "Upcoming"; modify with "Edit ride" → "Save changes" — "scheduled rides can only be edited up to 25 minutes prior to the scheduled pickup time."
  5. Cancel from the dashboard (round trips: choose which leg); from "Past activity": "Re-book trip" or "Book return trip."
- Decision points / guardrails: "a maximum of two riders can join a ride using the multi-stop feature"; 25-minute edit cutoff before pickup.
- Problem solved: the coordinator-books-for-attendee pattern with live monitoring, leg-level cancel, and one-click rebook.
- Sad paths documented: edit cutoff; cancellation paths per leg.

### F28 — Client portal for third-party order visibility: Onfleet Courier Client View
- Source: https://support.onfleet.com/hc/en-us/articles/360053621071-Courier-Client-View ; https://support.onfleet.com/hc/en-us/articles/31966212067092-Adding-and-Managing-Courier-Clients ; https://onfleet.com/client-portal (recorded from search excerpts; Zendesk blocks direct fetch)
- Flow as documented:
  1. Courier adds clients; each client gets a portal where they "can create orders, view current or previous order statuses, update contact information, customize your tracking page, and set notifications for your customers."
  2. Client dashboard shows a table view of tasks; clients can brand their own SMS notifications and tracking pages.
- Decision points / guardrails: scoped visibility — clients see their own tasks, not the courier's whole board.
- Problem solved: our "third party (e.g., agency/sponsor) sees only their attendees' trips" requirement.
- Sad paths documented: none documented in excerpts.

---

## TASK 10 — Driver accepts or declines an assignment

### F29 — Offer/accept loop with timers and fallback: Tookan auto-allocation
- Source: https://help.jungleworks.com/knowledge-base/auto-allocation-methods-on-tookan-dashboard/
- Flow as documented:
  1. Settings: Menu → Settings → Account Setup → Auto Allocation.
  2. ONE BY ONE: "Request goes to one agent (nearest & available) first and if the timer runs out or if the agent declines the task, it goes to the second best option." Timer duration ("Request Time", in seconds) is configurable.
  3. SEND TO ALL: request goes to all available agents; whoever "accepts/ acknowledges the task first will receive it."
  4. BATCH WISE: batches of offers at "Batch Processing Time" intervals until acceptance or agent-pool exhaustion.
  5. ROUND ROBIN: forced assignment weighing distance (60%) and task count (40%), bounded by "Maximum number of tasks" and "Radius Limit."
  6. Radius expansion across attempts: "Start Radius," "Radius Increment," "Maximum Radius."
  7. On failure: "the Dashboard gets a notification and tasks shows the option to Retry Auto Assignment, and send a round of notifications back to the available agents."
- Decision points / guardrails: per-offer timeout; decline triggers next-best; exhaustion surfaces a dashboard alert with an explicit "Retry Auto Assignment" action.
- Problem solved: complete offer → timeout/decline → fallback → human-retry loop for dispatching conference drivers.
- Sad paths documented: no-agent-accepts path fully documented (notification + retry affordance).

### F30 — Accept/reject in a chauffeur driver app: Limo Anywhere DriverAnywhere 4.0
- Source: https://kb.limoanywhere.com/docs/how-to-use-driveranywhere-4-0/
- Flow as documented:
  1. Trips arrive in the "Pending" section showing "Confirmation #, Pickup Date and Time, Drop-off Time (if applicable), Passenger's Name, Pick-up and Drop-off Locations, Flight Info (if applicable)."
  2. Driver must accept or reject before the trip moves to the "Upcoming" queue.
  3. Status sequence during the trip: On The Way/En Route → On Location/Arrived → Circling (optional) → Customer in Car → Passenger Dropped Off → Done/Close-out, driven by a bottom status bar.
  4. "You must close out trip in order to start next trip" — one active trip at a time.
  5. Flight icon → "track the flight via FlightAware"; direction icon → Google Maps; phone icon → call passenger.
  6. Close-out (Update screen): add tolls/parking/misc costs, capture signature, attach files, record mileage, driver notes.
- Decision points / guardrails: accept gate before a trip becomes "Upcoming"; single-active-trip lock; ordered status progression.
- Problem solved: the full driver-side day-of state machine including airport specifics (Circling, flight tracking) — closest documented analog to our hub-shuttle driver flow.
- Sad paths documented: rejection path exists (Pending → reject); "Circling" status acknowledges the can't-stop-at-arrivals reality.

### F31 — Operator notified when a driver declines: Moovs
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/9740727-operator-notification-driver-declines-a-trip-assignment ; https://intercom.help/moovs-05c940f1970e/en/articles/8007469-driver-notification-remind-driver-to-accept-or-deny-pending-jobs
- Flow as documented:
  1. Trigger: driver rejects an assigned trip.
  2. Operator receives (email and/or SMS, two independent toggles): "Hi [operatorName], Your driver, [driverName], just declined the trip that you assigned to them."
  3. Companion automation: reminder texts nudge drivers "to accept or deny pending jobs."
- Decision points / guardrails: channel toggles per operator; identical copy across channels.
- Problem solved: closes the assignment loop — a declined trip never sits silent.
- Sad paths documented: the decline is the sad path; what happens to the trip afterward is not specified in the article (manual reallocation implied).

---

## TASK 11 — Edit a vehicle or driver after trips are assigned

### F32 — Vehicle Availability View with drag-drop reassignment: Moovs
- Source: https://intercom.help/moovs-05c940f1970e/en/articles/13764934-vehicle-availability-view
- Flow as documented:
  1. Open the Dispatch page → click the chart icon (top-right) to open Vehicle Availability view.
  2. Vehicles listed left; "booked trips as color-coded blocks on a 24-hour timeline"; date picker for other days.
  3. Hover a block → confirmation number, pick-up/drop-off times, route details; click → full trip details panel.
  4. "Reassign trips by dragging and dropping blocks between different vehicles."
  5. "Review your edits in the pending changes bar and save them all at once."
- Decision points / guardrails: pending-changes bar batches edits behind one explicit save (no instant propagation); Pro/VIP plans only; farm-out routes unsupported.
- Problem solved: our vehicle-swap-after-assignment with visual capacity/timeline context and a review-before-commit gate.
- Sad paths documented: farm-out exclusion noted.

### F33 — Driver edit locks and conflict repair
- Source: https://academy.routific.com/en/articles/1317942-make-last-minute-changes-to-routes-after-dispatch (Routific) ; https://intercom.help/moovs-05c940f1970e/en/articles/11879227-resolving-driver-availability-conflicts-in-moovs-a-step-by-step-guide (Moovs)
- Flow as documented:
  1. Routific: drivers can be added/edited from the Drivers tab pre-execution, but "You cannot edit a driver's information once they start their routes."
  2. Moovs conflict repair: Settings → Drivers → select driver → (...) menu → copy driver app link → open it; click "My Availability"; delete every schedule block ("Delete" → "Yes, delete all") until the calendar is empty; rebuild via empty slots → "Add Event" → "Available" (green checkmark) → set start/end → optional "Repeat" → blue "Add."
- Decision points / guardrails: execution-start freezes driver edits (Routific); Moovs repair is destructive-then-rebuild with explicit "Yes, delete all" confirmation.
- Problem solved: propagation policy — what's editable after assignment vs. after trip start, and how to clear a corrupted availability state.
- Sad paths documented: the conflict state itself is the sad path the Moovs guide exists for.

---

## TASK 12 — Export or print the day's transport plan

### F34 — Reservation Manifest report: Limo Anywhere
- Source: https://kb.limoanywhere.com/docs/how-to-generate-a-reservation-manifest/ ; https://kb.limoanywhere.com/docs/how-to-print-limo-anywhere-forms-to-pdf/
- Flow as documented:
  1. Toolbar → "Reports" icon → Reservation Manifest Report box (second option, right column).
  2. Choose "Detailed View" (includes trip notes and linked-trip info) or "Summary View."
  3. Choose "With Payment Data" or "Without Payment Data."
  4. Set "Date From" / "Date To."
  5. Optional filters: Driver, Car, Vehicle Type, Billing Contact, Company, Run Type, Occasion, Service Type, Group Name, Farm-out Affiliate. (Tip: type the first two letters of a Billing Contact to jump in the dropdown.)
  6. Exclude checkboxes: Cancelled reservations, Late Cancel entries, Billing/Driver/Affiliate info. Include checkboxes: "Airport Pick-up Instructions," "Routing Notes," "Linked trips."
  7. Output: "Web Page," "Send Email," "Excel-Standard," or "Excel-Inline" → click "GENERATE REPORT."
  8. Any Limo Anywhere form (Confirmation, Trip Sheet, Invoice) can be printed/saved to PDF via the print function.
- Decision points / guardrails: include/exclude toggles let one report serve drivers (no payment data) and accounting (with) — same source, different audiences.
- Problem solved: the day's run sheet/manifest with group-name filtering — directly our "export the day's transport plan per hub/group."
- Sad paths documented: none documented.

### F35 — Route summary download: Routific
- Source: https://academy.routific.com/en/articles/1317927-how-to-dispatch-routes
- Flow as documented:
  1. From the dispatch screen, "Download Summary" exports CSV files of delivery stops and driver workload summaries — an alternative to phone dispatch.
- Decision points / guardrails: none documented.
- Problem solved: offline/paper fallback of the dispatch plan.
- Sad paths documented: none documented.

---

## BONUS — Batch suggestion from attendee travel data (our core differentiator, documented in the events vertical)

### F36 — Manifest upload → flight validation → grouping: miMeetings
- Source: https://mimeetings.com/about (content recorded from search excerpt; direct fetch failed on SSL certificate — flagged) ; https://www.cvent.com/en/blog/insights/cvent-mimeetings
- Flow as documented:
  1. "Upload a formatted Excel attendee manifest, which is then instantly scanned and analyzed using FAA connectivity to validate flight details."
  2. The system "validates each flight, identifies duplicate or missing information, and maps all flights based on domestic/international, airline, code share and terminal mapping."
  3. A "patented grouping algorithm... delivers optimal grouping of attendees" for shared vehicles.
- Decision points / guardrails: validation pass (duplicates/missing data) precedes grouping — data quality gate before clustering.
- Problem solved: this is precisely our auto-SUGGEST batches job: travel records in → validated → clustered into vehicle groups.
- Sad paths documented: duplicate/missing flight data detection is the documented sad-path handling.

### F37 — Manifest import into a reservation system: Limo Anywhere Manifest Upload Tool
- Source: https://kb.limoanywhere.com/docs/manifest-upload-tool/ ; https://www.limoanywhere.com/2021/07/06/get-started-guide-uploading-reservation-manifest-with-limo-anywhere-add-ons-manifest-upload-tool/
- Flow as documented:
  1. The Manifest Upload add-on lets operators "upload a passenger manifest that includes vital information such as names, contact details, and trip specifics," creating trips in bulk and "reducing manual data entry."
- Decision points / guardrails: none documented in excerpts.
- Problem solved: bulk attendee-list → trips ingestion, the input side of our batch planner.
- Sad paths documented: none documented.

---

## FIRST-PRINCIPLES CANDIDATES (unsourced)

Flows that appear standard for our job but for which no step-documented public source was found this session. Do NOT attribute these to any product.

- **Roll-up arrival counts board** ("10 arriving 10:00 from BOM"): no vendor help doc found that documents a grouped-by-flight/time/origin count widget. miMeetings/Azavista assert grouping but don't document the counts UI.
- **Headcount reconciliation before departure** (expected vs. boarded with a "who's missing" list and a hold/depart decision): Moovs Shuttle documents expected/check-in/capacity per stop; the reconcile-then-depart decision flow itself is not step-documented anywhere found.
- **Human finalization of auto-suggested batches** (suggest → review diff → approve): no source documents a suggested-batch approval UI; nearest analogs are Routific's optimize-then-Publish gate (F22) and Bringg's reassignment summary review (F4).
- **"Resend pickup details" button** for a single passenger: notification setup is documented (F8–F10) but an explicit per-passenger resend action was not found documented.
- **No-show escalation call tree** (call passenger → call coordinator → start timer → mark no-show): HopSkipDrive marketing/blog implies contacting rider and listed contacts before canceling, but no fetchable official page steps it; only fee timers are documented (F15).
- **Flight-cancellation (not delay) handling** — passenger removed from inbound batch and auto-flagged for re-planning: only delay/ETA-change flows are documented (F11–F14); cancellation-specific re-planning is not.
- **Vehicle capacity hard-block at assignment time** (cannot over-assign passengers beyond seats): Bringg documents capacity checks for merged routes (F4); a per-vehicle seat-count block in passenger transport was not found step-documented.

---

## Coverage log

Queries run (in order), with outcomes:

1. `Onfleet help assign tasks to driver dispatch how to` → gold (F1 sources). Onfleet Zendesk articles 403 on direct fetch; recorded from search excerpts.
2. `Moovs help center assign driver to trip flight tracking` → found Moovs Intercom help center (fetchable).
3. Fetch Onfleet Task Assignment → **403 dead end** (Zendesk bot-block).
4. `Onfleet support "recipient notifications" SMS ETA pickup tracking link customize` → F9 sources via excerpts.
5. Fetch Moovs collection index → article inventory (drove F2, F6, F11, F31, F32, F33).
6. `Tookan help agent assignment workflow "how to assign" task driver jungleworks` → F3.
7. Fetches: Moovs assign-driver, flight-update text, driver-decline, Tookan task assignment → F2, F11, F31, F3.
8. `Routific support dispatch routes to drivers what driver sees mobile app` → F5, F7.
9. `Circuit for Teams help remove stop from route after dispatch re-optimize` → surfaced Spoke article + Routific undo article. help.spoke.com → **403 dead end** (recorded only the search excerpt: copy skipped/failed/completed stops between routes; re-optimize after grouping).
10. Fetches: Routific dispatch (F5 ✓), Spoke stops (**403**).
11. `TripShot help rider check-in scan boarding shuttle driver app` → F18 sources. TripShot's own support portal not publicly indexable; used deployment guides (128bc.org, ohio.edu) + app store descriptions.
12. `HopSkipDrive help "no-show" policy driver wait time mark rider` → F15. Note: a "canceled after 20 minutes if contacts unreachable" claim appeared only in an aggregator summary (gethuman) — **excluded as unverifiable** on an official page.
13. Fetch HopSkipDrive pricing terms → F15 ✓ (fees only; no operational no-show steps).
14. `Onfleet support driver app complete task failed task reason "task completion"` → custom success/failure completion reasons (admin-configurable; Scale/Enterprise) — folded into F16 context; Zendesk 403 so not given its own entry beyond excerpt confidence.
15. `Tookan recurring tasks schedule jungleworks how to create repeat tasks` → F25.
16. `Uber Central help arrange ride for guest text message link no app needed` → F8, F27 sources.
17. Fetch uberforbusinesshelp.com mirror → **ECONNREFUSED dead end**; help.uber.com fetched fine instead.
18. Fetch Tookan recurring tasks → F25 ✓.
19. Fetch help.uber.com text-messages article → F8 ✓ (full message ladder).
20. `Limo Anywhere knowledge base driver run sheet print trip sheet manifest` → F34, F37.
21. Fetches: LA reservation manifest (F34 ✓), DriverAnywhere 4.0 (F30 ✓), Moovs driver platform app (status flow ✓), Moovs availability conflicts (F33 ✓).
22. Fetch Moovs dispatch alerts → toggleable blue/grey alert icons on reservation/dispatch/driver app (supplementary; merged into context, no standalone entry since alert types aren't enumerated).
23. `Onfleet support driver app offline mode connectivity lost tasks` → F21 (excerpts).
24. Fetch Moovs vehicle availability view → F32 ✓. `chauffeur driver app "no show" status mark passenger limo "no-show" procedure help` → F16 sources.
25. Fetch LA universal driver status → SMS-link status updates for drivers without the app; status checkpoint mapping (supplementary to F16/F30); no full status list in doc.
26. `limo software flight tracking automatically adjusts pickup time delayed flight help article` → gold: LA real-time flight tracking KB.
27. `shuttle software duplicate route template copy schedule next week help center` → **dead end** (marketing pages only; no help-center doc on copy-forward templates).
28. Fetch LA real-time flight tracking → F12 ✓.
29. `Zum app help parent track student bus check in scan boarding` → F17, F19.
30. `Bringg help center reassign order to another driver after dispatch` → F4.
31. Fetches: Bringg reassign (F4 ✓), Zum parent FAQs (F19 ✓).
32. `OptimoRoute help recurring orders weekly schedule template` → F26 (Zendesk 403; excerpts only).
33. `Onfleet "Courier Client View" share dashboard visibility customer` → F28 (excerpts).
34. Fetch OptimoRoute recurring orders → **403 dead end**; redirect probe also landed on Zendesk → abandoned.
35. `event conference attendee transportation manifest arrivals grouped by flight software help` → gold: miMeetings, Azavista (F36, F14).
36. Fetch mimeetings.com/about → **SSL certificate error dead end** (both hosts); recorded from search excerpt with flag.
37. Fetch Azavista travel/flight page → F14 ✓.
38. `"ridewithvia" OR Via TransitTech operations center help documentation booking rider` → **nothing new** (marketing-level; Via Operations Center named but no public step docs; recurring-series booking mentioned without steps).
39. `delivery dispatch help center "delete task" assigned route what happens driver notification` → gold: Routific last-minute changes + Onfleet edit/delete + Dispatch (dispatchit) articles (F22, F24).
40. Fetch Routific last-minute changes → F22 ✓.
41. `Moovs shuttle app passenger check-in QR code manifest help` → F20 sources.
42. Fetch Moovs shuttle seat booking → F20 ✓ (booking half; check-in half from product page).
43. `Tookan agent declines task what happens dispatcher unassigned notification help` → refinement for F29 (restart-allocation-on-decline).
44. Fetch Tookan auto-allocation methods → F29 ✓ (timers, radius expansion, retry).
45. `limo anywhere trip status email text passenger automatic confirmation driver assigned notification setup` → F10 sources; LA freshdesk offered-states article → **404 dead end**.
46. Fetch LA email/SMS notifications setup → F10 ✓.
47. `"run sheet" OR "trip sheet" print driver daily schedule chauffeur software knowledge base` → **DRY #1** (generic templates only, nothing new).
48. `airport meet and greet pickup instructions sign passenger arrival help article chauffeur` → **DRY #2** (marketing/airport-permit pages; useful domain color — name signs restricted to passenger name only at many airports, ~14"x18" size caps — but no product flow docs).

Stopped per loop-until-dry rule: 2 consecutive searches (47, 48) surfaced no new documentable flows.

Flows with no documentable source found this session: roll-up counts board; headcount-reconcile-then-depart decision; suggested-batch approval UI; per-passenger resend; no-show escalation call tree; flight-cancellation re-planning; per-seat capacity hard block (all listed under FIRST-PRINCIPLES CANDIDATES).

Persistent dead-end hosts: support.onfleet.com (403), help.spoke.com (403), help.optimoroute.com (403), mimeetings.com (SSL), uberforbusinesshelp.com (conn refused), limoanywhere.freshdesk.com (404 on target article).
