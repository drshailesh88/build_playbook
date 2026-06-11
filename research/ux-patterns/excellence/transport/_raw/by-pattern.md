# TRANSPORT — UX Pattern Harvest (BY-PATTERN sweep)

- Mode: by-pattern (pattern-name searches across the logistics industry, app-agnostic)
- Date: 2026-06-11
- Source method: WebSearch/WebFetch over vendor docs, help centers, KB articles, product pages, and release notes (Mobbin MCP unavailable this session)
- Sourcing discipline: every entry cites a URL where the behavior is documented; behaviors are recorded as documented, never inferred onto an app. Unsourced-but-plausible patterns are quarantined at the bottom.

---

### P1 — Dispatch board / dispatcher view (assignment grid, unassigned queue)
- Observed in: Onfleet, Samsara, Limo Anywhere · Sources:
  - https://support.onfleet.com/hc/en-us/articles/360023910111-Task-Assignment (behavior per search-result excerpt; page blocks direct fetch)
  - https://kb.samsara.com/hc/en-us/articles/360029240672-Driver-Selection-of-Unassigned-Routes
  - https://kb.limoanywhere.com/docs/new-dispatch-grid/
- Behavior as documented:
  1. Onfleet: dispatchers see an "Unassigned" section in the sidebar; assignment is drag-and-drop — drop a task on a driver's name to append to the end of their route, or drag into a specific position within the route. Tasks can also be assigned at creation via an "Assign" control. With team sections enabled, unassigned tasks can be moved from the main Unassigned section into a per-team section, hiding them from other teams.
  2. Samsara: routes can be created assigned to a vehicle/driver or left unassigned; unassigned routes are later assigned by editing the route, or (if "Self Dispatch" is enabled under Settings > Driver App > Routes) drivers pick unassigned routes themselves in the driver app and confirm with "Select route", which puts the route in their queue.
  3. Limo Anywhere New Dispatch Grid: two modes — "List View" (row-based grid of trips) and "Map View" (pickups plotted live). Selecting a trip shows the row alongside a map pin of the pickup. A "Details & Edit Panel" opens trip details for modification; drivers are assigned directly from the grid; "Filters" refine which trips display; "Batch Edit" updates multiple trips at once.
- Problem solved: gives ops one screen to see unplanned passengers/trips and place them onto vehicles — our "assign passengers to vehicles in a batch" core loop.
- Variants observed: Onfleet is task-centric drag-and-drop onto drivers; Samsara adds driver self-selection of unassigned routes; Limo Anywhere is reservation-grid-centric with a details side panel and batch edit.
- Sad paths documented: Samsara — unassigned routes only appear in the driver app if the org explicitly enables unassigned route selection; otherwise they sit unassigned.

### P2 — Driver manifest / run sheet / trip sheet (what the driver sees per trip)
- Observed in: Limo Anywhere DriverAnywhere 4.0, TripShot Driver App · Sources:
  - https://kb.limoanywhere.com/docs/how-to-go-through-workflow-of-trip-in-driveranywhere-4-0/
  - https://kb.limoanywhere.com/docs/how-to-use-driveranywhere-4-0/ (per search-result excerpt)
  - https://www.tripshot.com/ and https://www.tripshot.com/all-products/ (per search-result excerpts)
- Behavior as documented:
  1. DriverAnywhere dashboard groups trips into four sections: In Progress, Pending, Upcoming, Completed.
  2. Job cards show "important information about the trip at a glance"; tapping the card opens job details with Requirements, Passenger Info, Routing, Payment and Additional Info.
  3. A "phone icon (on center right, to contact passenger)" calls the primary passenger; a directional button sends routing to the device's map provider; drivers tap a flight icon to track the flight via FlightAware.
  4. TripShot: drivers see a rider manifest and "dynamic route modifications right in the TripShot Driver App" (replacing printed manifests and radio updates); badge/pass validation happens at boarding against a locally stored database.
- Problem solved: the per-vehicle, per-run packet a driver needs on day-of — passengers, pickup routing, flight, contact — without calling dispatch.
- Variants observed: chauffeur-style (one job card per trip with passenger info, Limo Anywhere) vs shuttle-style (stop manifest with boarding validation, TripShot).
- Sad paths documented: Limo Anywhere drivers can "REJECT" a pending trip (returns to dispatch for reassignment — see P14); TripShot drivers can deny boarding when a rider has no reservation.

### P3 — Passenger manifest with contact details
- Observed in: Booking Tool, Tourplan NX · Sources:
  - https://www.prweb.com/releases/booking-tool-introduces-new-automated-passenger-manifest-feature-302262171.html
  - https://www.bookingtool.com/articles/charter-bus-and-shuttle-passenger-manifest/ (403 on fetch; behavior from press release above)
  - https://usermanuals.tourplan.com/v2/Content/NX%20Reports/B-Operations%20Reports/F-Arrivel%20Depature.htm
- Behavior as documented:
  1. Booking Tool auto-generates a digital passenger manifest per vehicle/trip with passenger names, contact details (email/phone), pickup/drop-off locations, payment info, and special requirements; up to 25 customizable fields.
  2. The manifest updates in real time as passengers check in via QR scan ("just scan, check, and go!" — vendor microcopy) and as cancellations/flight delays occur; updates propagate to all stakeholders.
  3. Manifests export as PDFs and are emailed to multiple recipients (operators, drivers, admins).
  4. Tourplan's Arrival/Departure report lists per-service passenger names plus total pax counts (adults, children, infants), pickup/flight info, and — with Resource Assignment enabled — "Driver, Guide and Vehicle assignments".
- Problem solved: one authoritative list of who is on each vehicle with a way to reach them — needed for boarding checks and day-of contact.
- Variants observed: live in-app manifest (Booking Tool) vs printable/report manifest grouped by service (Tourplan).
- Sad paths documented: Booking Tool — cancellations and flight delays propagate into the manifest in real time; none documented for unreachable passengers.

### P4 — Vehicle capacity indicator + over-capacity warning vs hard block
- Observed in: OptimoRoute, Track-POD · Sources:
  - https://help.optimoroute.com/hc/en-us/articles/27432474422804-Set-up-vehicle-load-capacities (403 on fetch; behavior per search-result excerpts from this article and https://help.optimoroute.com/hc/en-us/articles/27712119329172-Intro-to-optimized-route-planning)
  - https://www.track-pod.com/route-planning-software/ (per search-result excerpt)
- Behavior as documented:
  1. OptimoRoute: up to 4 named capacity constraints per vehicle; the optimizer never overfills — "orders on a given route will be limited by the capacity set for a particular vehicle." Orders that can't fit are not force-assigned; they land in an "Unscheduled orders" / "Not Scheduled" tab "which shows the specific reasons why each order was excluded" (soft block + explanation, not an override warning).
  2. Track-POD: route review shows vehicle load, weight, volume vs fleet capacity limits, with "overload notifications" surfaced to the dispatcher during planning.
- Problem solved: prevents assigning 15 attendees to a 12-seat van — and tells the planner why someone didn't fit instead of silently dropping them.
- Variants observed: optimizer-enforced (capacity is a constraint; overflow becomes unscheduled with reasons — OptimoRoute) vs notification-on-overload during review (Track-POD). No vendor doc found showing a manual-assignment hard block with override (see first-principles section).
- Sad paths documented: OptimoRoute — unscheduled orders can be manually dragged onto a route from the unscheduled pop-up (human override of the constraint outcome), per https://help.optimoroute.com/hc/en-us/articles/27804856390420-Manually-schedule-and-modify-orders-on-routes (search excerpt).

### P5 — Trip/ride status lifecycle shown to ops and to the passenger (timeline UI)
- Observed in: Limo Anywhere (+DriverAnywhere), Onfleet, Track-POD, Moovs · Sources:
  - https://kb.limoanywhere.com/docs/how-to-go-through-workflow-of-trip-in-driveranywhere-4-0/
  - https://kb.limoanywhere.com/docs/how-the-offered-states-and-status-works/
  - https://www.limoanywhere.com/2024/06/05/utilizing-custom-statuses-in-limo-anywhere/
  - https://support.onfleet.com/hc/en-us/articles/20509786766228-Task-Status (per search-result excerpt)
  - https://www.track-pod.com/blog/updated-delivery-tracking-order-status-timeline-and-delivery-instructions/
  - https://support.moovsapp.com/en/articles/9938857-trip-reminders-and-trip-status-update-notifications (per search-result excerpt)
- Behavior as documented:
  1. Limo Anywhere driver-side lifecycle, in order: Pending (REJECT or ACCEPT) → Upcoming ("start trip") → On The Way (auto on start) → Arrived (driver sets; can activate a wait timer) → Customer In Car → Passenger Dropped Off → Trip Complete/Close Out (checkmark finalizes).
  2. Limo Anywhere ops-side state machine: "Created" (unassigned) → "Offered to Driver" → "Assigned to Driver"/"Driver Is Assigned" on accept; farm-outs go "Offered to Affiliate" → "Affiliate Is Assigned"; plus "Cancelled", "Late Cancelled", "No Show". Operators add custom statuses (code, name, color) via My Office > Company Settings > System Settings > System Mapping > "+ Add Status"; colors show on calendar and dispatch screens.
  3. Onfleet: completed tasks are "Succeeded" (green pin) or "Failed" (red pin); the task Timeline records creation, start, arrival, departure, completion, plus photos/barcodes/signatures as the driver progresses; admins/dispatchers can edit completion status after the fact.
  4. Track-POD passenger/recipient-facing timeline (toggle "Display order status timeline" under Settings > Notifications > Live Track Page): "Created" → "Scheduled" → "Loaded" → "On the Way" → "Arrived" → "Completed".
  5. Moovs: passenger status texts fire on driver status changes — "The driver is on the way...", "The driver is on location for pick up...", "Thank you for riding with [company name]...".
- Problem solved: shared truth between dispatcher, driver, and passenger about where a trip is in its life — our boarded/no-show/completed execution states.
- Variants observed: driver-set statuses with auto-transitions (Limo Anywhere) vs binary success/fail with rich event timeline (Onfleet) vs recipient-facing 6-step progress bar (Track-POD).
- Sad paths documented: Onfleet "Failed" completion with notes and optional recipient notification; Limo Anywhere "No Show", "Cancelled", "Late Cancelled" statuses; status edit-after-completion (Onfleet).

### P6 — Flight tracking tied to a pickup (auto-adjust pickup time, delay alerts)
- Observed in: Limo Anywhere, Hoppa (via SAS transfer page), Welcome Pickups · Sources:
  - https://kb.limoanywhere.com/docs/how-the-set-up-and-use-real-time-flight-tracking/
  - https://www.flysas.com/en/book/transfer/ (per search-result excerpt, documents Hoppa behavior)
  - https://blog.gettransfer.com/how-to-automate-your-guests-arrival-experience-with-welcome-pickups/ and https://support.welcomepickups.com/en/articles/5140529-why-did-i-receive-an-email-notification-asking-me-to-correct-a-detail-of-my-transfer (per search-result excerpts)
- Behavior as documented:
  1. Limo Anywhere: flight tracking (FlightStats) activates automatically once pickup date, time, airport, airline, and flight number are on the routing. Setting "Update Pick Up time based on the Arrival flight's ETA and flight offset" (My Office → Company Settings → Company Preferences → Reservations) continuously re-pins pickup = flight ETA + offset.
  2. Offset is chosen per routing from eight "Driver should Arrive" options: "When your flight arrives" (0 min), 15–120 min after gate arrival, or "Do not adjust based on flight arrival".
  3. Worked example in the doc: flight ETA 12:30 + "15 min after gate arrival" → pickup 12:50; flight slips to 12:50 → pickup auto-moves to 1:05.
  4. Dispatchers add FlightStats columns to the dispatch grid: scheduled time, actual time, terminal/gate, status; multi-flight trips expose per-flight data on hover over a notepad icon.
  5. Hoppa: "Your transfer booking is connected to your flight... your selected transfer will automatically rebook to match your new arrival time."
  6. Welcome Pickups validates booking inputs (phone, email, duplicates, address, airport, flight number, time) and emails the customer to correct detected errors.
- Problem solved: flight delay/early-arrival re-planning without a human recomputing every pickup — our "react to flight changes" red-flag loop.
- Variants observed: offset-based continuous re-pin (Limo Anywhere) vs full automatic rebooking of the transfer (Hoppa) vs pre-trip data validation nudges (Welcome Pickups).
- Sad paths documented: Hoppa — "If your flight is cancelled or Hoppa is unable to rebook your transfer, you will receive a full refund"; Limo Anywhere — explicit opt-out per routing ("Do not adjust based on flight arrival").

### P7 — No-show workflow (grace timer, attempted-contact, fee/record)
- Observed in: Uber, ADA paratransit practice (DREDF topic guide), Limo Anywhere, NEMT brokers · Sources:
  - https://help.uber.com/en/riders/article/wait-time-fees-and-refunds?nodeId=469f1786-1543-4c83-abbf-ddccb7826fc2 and https://help.uber.com/en/riders/article/cancellation-fees-explained?nodeId=069853a3-f014-40a3-ad58-88ef56b1b27f (per search-result excerpts)
  - https://dredf.org/ADAtg/noshow.shtml
  - https://kb.limoanywhere.com/docs/how-to-go-through-workflow-of-trip-in-driveranywhere-4-0/ (wait timer) and https://www.limoanywhere.com/2024/06/05/utilizing-custom-statuses-in-limo-anywhere/ ("No Show" status)
  - https://nemtplatform.com/blogs/addressing-the-no-show-problem-in-nemt-best-practices-and-software-solutions (per search-result excerpt)
- Behavior as documented:
  1. Uber: grace period starts at driver arrival — 2 minutes (UberX) / 5 minutes (Uber Black/SUV) before per-minute wait fees; after the grace window a no-show cancellation fee may apply; if charged a no-show fee, wait-time fees are not also charged. Riders dispute via the "Review my cancellation fee" form; the fee is waived "if we detect that your driver hasn't made progress to your pickup location or if your driver is 5 or more minutes late."
  2. ADA paratransit best practice (DREDF): driver waits the policy window (commonly 5 min within the pickup window); "dispatchers should attempt to contact the rider, using any telephone number(s) in the trip record"; drivers may go to the door before declaring; the no-show is then recorded against the rider.
  3. NEMT brokers operate progressive enforcement: 1st no-show = recorded warning + education notice; 2nd = formal warning, possible scheduling-priority reduction; 3rd = temporary restrictions (loss of standing orders, etc.) within a 30–60 day review window.
  4. Limo Anywhere: driver activates a wait timer at "Arrived"; "No Show" exists as a trip status visible on dispatch screens.
- Problem solved: a fair, auditable way to release a vehicle from a missing attendee and record it — instead of a bus idling for one person.
- Variants observed: consumer fee model (Uber) vs record-and-escalate model with mandatory attempted contact (paratransit/NEMT) vs simple status + wait timer (Limo Anywhere).
- Sad paths documented: Uber fee dispute flow and auto-waiver conditions; DREDF guidance that no-shows outside rider control should not count against the rider.

### P8 — Live tracking link sent to passenger (web link, no app install)
- Observed in: Limo Anywhere Passenger Link, Onfleet, Moovs · Sources:
  - https://kb.limoanywhere.com/docs/passenger-link/
  - https://support.onfleet.com/hc/en-us/articles/41314013074068-Notifications-and-Tracking-Page (per search-result excerpt)
  - https://www.moovsapp.com/solutions/driver-apps (per search-result excerpt)
- Behavior as documented:
  1. Limo Anywhere Passenger Link: passenger gets an SMS or email with a tracking link, triggered either when the trip hits a chosen status (e.g., "On the Way") or N minutes before pickup. The link opens a mobile website — no app — showing real-time driver location (customizable car icon), trip status/progress, and optional company branding. Admins set "the desired time frame for your passenger to access trip information" (link activation/expiry). Messages must contain the placeholder `%URL-TRIP-CUST%` (customers) or `%URL-TRIP-AFF%` (affiliates) "or recipients won't receive clickable links."
  2. Onfleet: the `{trakLink}` placeholder inserts a recipient tracking link into SMS notifications; the tracking page shows driver location in real time with one-tap call/SMS to the driver; page is brandable (logo, colors, which driver/order details to show).
  3. Moovs: "lightweight browser links" give customers and affiliates live trip status; live tracking activates when the driver starts the trip; customers see driver location and stop-by-stop ETA.
- Problem solved: attendees see exactly where their shuttle is without installing anything — kills "where is my pickup?" calls to the ops desk.
- Variants observed: status-triggered vs time-before-pickup triggers (Limo Anywhere); affiliate gets a separate link variant (Limo Anywhere); tracking page doubles as a communication channel (Onfleet).
- Sad paths documented: Limo Anywhere — missing URL placeholder silently breaks the link in the message; link access is time-boxed and expires.

### P9 — SMS/WhatsApp pickup notification (driver name, plate, ETA)
- Observed in: Uber, Welcome Pickups, Blacklane, SAS/Hoppa transfers, Moovs · Sources:
  - https://help.uber.com/en/business/article/text-messages-riders-receive?nodeId=1d773c1e-db7c-4a9a-bb98-7c8a8f89eb23 and https://help.uber.com/en/riders/article/how-to-identify-a-driver-and-their-vehicle?nodeId=02746faf-1bc6-4d3f-8ba2-ab35f36d7191 (per search-result excerpts)
  - https://support.welcomepickups.com/en/articles/4698595-will-i-know-my-driver-s-details-before-my-pickup
  - https://help.blacklane.com/en/articles/2689412-how-can-i-contact-my-chauffeur (per search-result excerpt)
  - https://www.flysas.com/en/book/transfer/ (per search-result excerpt)
- Behavior as documented:
  1. Uber (Uber for Business / Central guest rides): rider receives a text with the driver's first name, vehicle description, license plate, and estimated arrival time, plus a link to track the driver in real time; riders are told to verify the plate against the vehicle before boarding.
  2. Welcome Pickups: three-touch sequence — booking confirmation email immediately; "once a driver is assigned to your transfer we send another email with your driver's details!"; a text message when the driver is at the pickup ("driver is waiting"). Disclaimer: "your designated driver may change based on the companies scheduling needs, in which case a new driver confirmation email will be sent." Travelers can also chat with the driver via in-product Driver/Traveler chat (https://support.welcomepickups.com/en/articles/5015686-how-can-i-reach-out-to-my-driver-via-the-driver-traveler-chat).
  3. SAS airport transfer (operated with partners): "Contact details for your driver may have been sent to you via WhatsApp or SMS 1 hour prior to your pick up time."
  4. Blacklane: SMS notifications as the ride approaches; chauffeur contact and vehicle details in the app; phone masking covers calls/SMS but explicitly "not... other messaging services like WhatsApp."
- Problem solved: passengers can find and verify their vehicle at a chaotic airport curb — driver name + plate + ETA pushed to them, not pulled.
- Variants observed: T-minus-time trigger (SAS/WhatsApp 1h before) vs event triggers (assignment, arrival — Welcome Pickups, Uber); WhatsApp as channel documented only for SAS partner transfers; driver-change re-notification (Welcome Pickups).
- Sad paths documented: driver reassignment triggers a fresh confirmation email (Welcome Pickups); phone masking incompatible with WhatsApp (Blacklane).

### P10 — Route/batch auto-suggestion reviewed by a human before dispatch
- Observed in: Routific, OptimoRoute, RideCo · Sources:
  - https://academy.routific.com/en/articles/1317935-how-to-make-changes-to-your-routes
  - https://help.optimoroute.com/hc/en-us/articles/27712119329172-Intro-to-optimized-route-planning and https://optimoroute.com/sending-planned-routes-to-the-optimoroute-mobile-app-or-via-email/ (per search-result excerpts)
  - https://rideco.com/paratransit/dispatching
- Behavior as documented:
  1. Routific: the optimizer proposes routes; before dispatch the planner has full edit rights — add/edit/delete stops (plus/pencil/trash icons in the 'Stops' tab), drag-and-drop reorder, drag a stop onto a driver's name to let the system place it optimally, Shift-select to move multiple stops, unschedule stops, "Reoptimize" after manual changes, and "lock routes" to shield finished routes from reoptimization. "After dispatching, you can only make changes to your routes if you have Live Tracking in your subscription."
  2. OptimoRoute: planner reviews planning settings, clicks "Plan routes"; the proposal renders on a map (colored routes, numbered stop sequence) and in an orders table (driver/vehicle, stop number, planned arrival); orders that didn't fit appear in the "Not Scheduled" tab with per-order exclusion reasons; only after review does the planner send routes to the driver app/email.
  3. RideCo: the patented solver "distributes all impacted trips across the available fleet and reoptimizes manifests" continuously, while "supporting dispatcher-initiated manifest adjustments" — automation with explicit human override; all changes sync to driver/passenger apps via push, SMS, or IVR.
- Problem solved: exactly our DEC-constraint — system clusters/suggests, human reviews and finalizes before anything reaches drivers or passengers.
- Variants observed: one-shot optimize-then-edit-then-dispatch (Routific, OptimoRoute) vs continuous reoptimization with override (RideCo); route locking as a mid-ground (Routific).
- Sad paths documented: post-dispatch edits gated behind a feature tier (Routific); unschedulable items surfaced with reasons rather than dropped (OptimoRoute).

### P11 — Day-of boarding / check-in (scan or tap, headcounts)
- Observed in: Booking Tool, TripShot, ETA Transit · Sources:
  - https://www.prweb.com/releases/booking-tool-introduces-new-automated-passenger-manifest-feature-302262171.html
  - https://www.tripshot.com/ and https://www.tripshot.com/resources/blog/use-reservation-to-streamline-operations/ (per search-result excerpts)
  - https://etatransit.com/industries/airport/ (per search-result excerpt)
- Behavior as documented:
  1. Booking Tool: operator scans the passenger's encrypted eTicket QR with the iOS/Android app; reservation verifies instantly and the manifest updates passenger status in real time — "No more manual check-ins... just scan, check, and go!"
  2. TripShot: drivers validate badges/passes as riders board against a locally stored database; reservations integrate natively so the driver can "determine if a rider has a reservation and whether or not they should be allowed to board"; the app "shows boarded passenger count when viewing On Demand stops"; passenger counts are stored at stop level and "can be rolled up by route, shift, and more"; APC (automatic passenger counting) vendor integrations supported.
  3. ETA Transit: automatic passenger counting shows when/where riders board while managing bus capacity.
- Problem solved: live headcount per vehicle at boarding — our boarded/no-show day-of execution with roll-ups for the ops room.
- Variants observed: QR eTicket scan (Booking Tool) vs badge validation + APC hardware (TripShot/ETA Transit).
- Sad paths documented: TripShot — boarding denial when no valid reservation/pass.

### P12 — Exception/alert center for dispatchers (what needs attention now)
- Observed in: Limo Anywhere, Onfleet Command Center, Samsara, RideCo · Sources:
  - https://kb.limoanywhere.com/docs/new-dispatch-grid/ and https://www.limoanywhere.com/2026/02/20/making-the-most-of-the-new-dispatch-grid-optimizing-your-workflow/ (per search-result excerpt)
  - https://support.onfleet.com/hc/en-us/articles/35183133144980-Command-Center (per search-result excerpt)
  - https://kb.samsara.com/hc/en-us/articles/4408735637005-Manage-Alerts and https://kb.samsara.com/hc/en-us/articles/360056644432-Out-of-Sequence-Arrival-Notifications (per search-result excerpts)
  - https://rideco.com/paratransit/dispatching
- Behavior as documented:
  1. Limo Anywhere "Attention Flags": trips meeting flagged conditions (Meet & Greet, child seat, missing flight number, not paid in full, etc.) show a red exclamation mark in the Attention column of the dispatch grid; an Attention tab in the right panel shows full reasons and a count of currently flagged trips; clicking it filters the grid to only flagged trips.
  2. Onfleet Command Center (Scale/Enterprise): real-time monitor of today's route plans/tasks/drivers; "Quick Stats" header with key route/task-status metrics + a sortable Routes Table "to help surface routes that may need your attention."
  3. Samsara: configurable alert types with an Alerts Inbox in the Fleet App for "time-sensitive alert incidents"; route tracking marks stops skipped on out-of-order arrival; route progress alerts anticipate arrivals/delays; "Route Timeliness" column uses color indicators for late/skipped stops.
  4. RideCo Driver Alerts dashboard flags "late pick-ups and drop-offs, missed waypoints, or deviation from expected steps"; the Operations Center is a single dashboard to "see and adjust manifests, track dedicated and non-dedicated vehicles in real time."
- Problem solved: the red-flag queue — flight changes, missing data, late vehicles — ranked in one place so ops react instead of scanning every trip.
- Variants observed: data-completeness flags on the grid itself (Limo Anywhere) vs execution-delay alerting (Samsara, RideCo) vs roll-up command dashboard (Onfleet).
- Sad paths documented: Samsara — stops not completed by end of the route tracking window are auto-marked skipped.

### P13 — Recurring shuttle schedule templates
- Observed in: Route4Me, Routific · Sources:
  - https://support.route4me.com/repeating-route-templates-for-recurring-schedule-delivery-routes/ and https://support.route4me.com/recurring-route-template-with-route-schedule-for-repeat-orders/ (per search-result excerpts)
  - https://help.routific.com/en/articles/9-what-are-route-templates
- Behavior as documented:
  1. Route4Me: a "Master Route" is a reusable template; attach a Recurring Schedule (daily/weekly/monthly/annual/custom rules) and the system auto-generates routes on schedule and auto-dispatches them to drivers and vehicles.
  2. Routific templates store "Regular shift times," "Standard start and end locations," and constraints like "vehicle load capacity" or "the number of orders per route"; the "Routes column" sets how many routes to spawn (or blank = system decides). Day-of, the planner clicks the "blue plus (+) sign button" → "Add route from template" → quantity → "Add routes". "Editing templates will not adjust any current scheduled routes. It will, however, affect any new routes to be scheduled."
- Problem solved: conference hotel-loop shuttles that repeat each day get stamped out from a template instead of rebuilt nightly.
- Variants observed: fully automated generation + dispatch on a cron-like schedule (Route4Me) vs manual instantiation from template at plan time (Routific).
- Sad paths documented: Routific — template edits deliberately don't retro-apply to already-scheduled routes.

### P14 — Bulk reassignment when a vehicle/driver becomes unavailable
- Observed in: Motive, Route4Me, Routific, Turns, Limo Anywhere · Sources:
  - https://helpcenter.gomotive.com/hc/en-us/articles/30896048036253-Creating-Managing-Routes (per search-result excerpt)
  - https://support.route4me.com/dispatch-routes-to-drivers-on-the-route4me-web-platform/ (per search-result excerpt)
  - https://academy.routific.com/en/articles/4128126-how-to-swap-routes-between-drivers
  - https://help.turnsapp.com/en/articles/8442938-how-to-change-the-driver-for-a-live-route-in-route-manager (per search-result excerpt)
  - https://kb.limoanywhere.com/docs/new-dispatch-grid/ ("Batch Edit") and https://kb.limoanywhere.com/docs/how-the-offered-states-and-status-works/ (stalled-offer reassignment)
- Behavior as documented:
  1. Motive: in the Plan tab, multi-select routes → "Reassign" → enter driver, vehicle, asset, dispatcher → "Send to driver".
  2. Route4Me: check multiple routes → "Bulk Actions" → "Assign User" applies one driver/user to all selected routes.
  3. Routific route swap: click the swap icon by the driver's name ("two little people and circular arrows"), a popup lists all drivers with a blue checkmark on the route being reassigned, pick the destination driver — "the entire route transfers to the new driver."
  4. Turns: driver can be changed on a live, in-progress route from Route Manager.
  5. Limo Anywhere: if a trip lingers in "Offered to Driver" (driver never accepted), dispatch contacts the driver or reassigns to another; "Batch Edit" updates many trips at once from the grid.
- Problem solved: a driver calls in sick or a bus breaks — move the whole run (or many runs) in a couple of clicks rather than re-keying passengers.
- Variants observed: bulk multi-route reassignment (Motive, Route4Me) vs whole-route swap between two drivers (Routific) vs live-route driver change (Turns) vs offer-timeout manual reassignment (Limo Anywhere).
- Sad paths documented: Limo Anywhere — un-accepted offers are detectable by status and recoverable; RideCo (P10 source) lists driver call-outs and vehicle breakdowns as solver-handled exception triggers.

### P15 — Arrivals board grouped by time window / origin (roll-up counts)
- Observed in: Tourplan NX, Travelport GlobalWare · Sources:
  - https://usermanuals.tourplan.com/v2/Content/NX%20Reports/B-Operations%20Reports/F-Arrivel%20Depature.htm
  - https://support.travelport.com/webhelp/GlobalWare/Content/14-Groups/Arrival_Departure_Manifest.htm
- Behavior as documented:
  1. Tourplan Arrival/Departure Report: lists all arrivals/departures for transfer or flight services with "Service Date," "Pick up/Flight Information," "Arrival (Time)," "Drop off/Flight Information," "Drop off (Time)", passenger names, and total pax counts (adults/children/infants). "Order By" regroups the board by General, Pickup, Dropoff, Agent, Supplier, Driver, Vehicle, or Guide; "Consolidate Bookings" merges multiple bookings into one line; with Resource Assignment on, driver/guide/vehicle assignments display inline. Filterable by travel dates, agent, supplier, service status, location.
  2. Travelport GlobalWare Arrival/Departure Manifest: arrival manifest shows "Arrival date and time," "Airline," "Flight," "Origin city of the flight," passenger name/title, connections, home city; provides "the total number of passengers arriving or departing at a particular time and the total number of passengers on the report"; options to "Start each date on a new page" / "Start each group on a new page", filter connections ("All Connections" / "Same Day Only"), and include/exclude canceled passengers.
- Problem solved: this is literally "10 arriving 10:00 from BOM" — pax totals rolled up per arrival time and origin flight, regroupable by vehicle/driver for batch planning.
- Variants observed: operations-resource grouping (Tourplan: by driver/vehicle/pickup) vs pure flight-time manifest with per-time totals (GlobalWare); cancellation handling differs (GlobalWare can include or exclude canceled pax).
- Sad paths documented: GlobalWare — canceled passengers are an explicit include/exclude toggle so counts stay honest.

---

## FIRST-PRINCIPLES CANDIDATES (unsourced)

Flagged as industry-plausible but not found documented in any vendor source this sweep — do NOT attribute to any app:

1. **Hard block with manager override on manual over-capacity assignment.** Optimizers refuse to overfill (OptimoRoute) and planners get overload notifications (Track-POD), but no doc was found showing a manual drag-assign being hard-blocked with an "override anyway" confirmation. Ground Alliance marketing mentions "warning indicators" on conflicting drag-drops but without concrete documented behavior.
2. **Attendee-batch auto-clustering from travel records with explicit "approve batch" step.** RideCo auto-builds manifests with dispatcher override and Routific/OptimoRoute propose routes for review, but no source documents clustering *attendee flight arrivals* into suggested pickup batches that a human then finalizes — the DMC world does this manually from spreadsheets (Connect DMC / KD Elite describe manual grouping of passengers arriving "within a close time frame").
3. **Grace-timer countdown UI visible to dispatch with auto-escalation to "attempted contact" checklist.** Policies (Uber 2/5-min, paratransit 5-min + contact attempt per DREDF) are documented, and Limo Anywhere has a driver wait timer — but no source shows a dispatcher-side countdown + structured attempted-contact log UI.
4. **Per-batch WhatsApp template messages for group/conference pickups.** WhatsApp delivery of driver details is documented only as a channel mention (SAS transfers, 1h before); no source documents batch/group WhatsApp pickup workflows in a dispatch product.
5. **Arrivals board as a live (not report) screen with auto-refreshing roll-up tiles per time window.** Tourplan/GlobalWare implement this as generated reports/manifests; a live, continuously-updating arrivals wallboard for ground transport ops was not found documented.

---

## Coverage log

Searches run (in order):
1. `dispatch board unassigned queue assign driver documentation Onfleet dispatcher view` → Onfleet Task Assignment, dispatcher docs (P1).
2. `driver manifest "run sheet" trip sheet driver app limo software documentation` → Limo Anywhere driver app, LimoFlow, Speed (P2 leads).
3. `flight tracking pickup time auto-adjust delay limo dispatch software documentation` → Limo Anywhere flight-tracking KB (P6 core source).
4. `Samsara dispatch "unassigned" routes assign driver help documentation` → Samsara unassigned-route selection (P1).
5. `vehicle capacity exceeded warning route planning OptimoRoute Routific documentation` → OptimoRoute capacities + unscheduled orders (P4).
6. `Onfleet driver tracking link SMS passenger "no app" recipient tracking documentation` → trackLink, tracking page (P8).
7. `no-show policy grace period wait time driver app attempted contact NEMT transportation software documentation` → NEMT Platform, RouteGenie, Missouri NEMT (P7).
8. `Uber "your driver" notification license plate driver name SMS pickup details help` → Uber for Business rider texts (P9).
9. `"review" routes before dispatch edit suggested routes Routific "review and edit" documentation` → Routific academy articles (P10).
10. `shuttle bus passenger check-in boarding scan headcount manifest software documentation` → Booking Tool, TripShot, ETA Transit (P3/P11).
11. `Onfleet task states "in progress" "completed" "failed" task lifecycle documentation` → Task Status, Timeline (P5).
12. `dispatcher alerts panel "needs attention" exceptions late routes Samsara Onfleet alert documentation` → Samsara Alerts Inbox, out-of-sequence (P12).
13. `recurring route template schedule shuttle "route templates" help center` → Route4Me Master Routes, Routific templates (P13).
14. `reassign all stops driver unavailable bulk reassign route another driver help documentation` → Motive, Route4Me, Routific swap, Turns (P14).
15. `airport meet and greet arrivals manifest grouped by flight transfers DMC group transportation software` → DMC practice (manual grouping; context for P15).
16. `Onfleet "Command Center" dashboard at-risk tasks attention dispatcher` → Command Center (P12).
17. `hotel airport shuttle software arrivals grouped by time window flight number roll-up count TripShot ETA Transit` → no grouped-arrivals UI documented (partial dead end → led to Tourplan search).
18. `Limo Anywhere trip status "on the way" "arrived" "passenger on board" "done" dispatch grid` → dispatch grid + custom statuses (P1/P5).
19. `Tourplan arrival departure transfer list report grouped flight documentation DMC` → Tourplan + Travelport manifests (P15 core sources).
20. `Uber rider no-show cancellation fee wait time "2 minutes" driver arrived help` → grace periods, dispute flow (P7).
21. `"exceeds" vehicle capacity warning route help center delivery "overloaded" Circuit Track-POD` → Track-POD overload notifications (P4).
22. `kb.limoanywhere.com driver anywhere app trip status flight information passenger` → DriverAnywhere 4.0 workflow, Universal Driver Status, Passenger Link, Crew Link (P2/P5/P8).
23. `Welcome Pickups driver details notification email SMS transfer guest experience how it works` → notification sequence (P9).
24. `RouteGenie NEMT auto-scheduling algorithm dispatcher review adjust trips documentation` → algorithm claims, dispatcher adjust (P10 context; mostly marketing).
25. `WhatsApp ride pickup notification driver details transfer booking documentation Blacklane Hoppa` → SAS WhatsApp mention, Hoppa auto-rebook, Blacklane masking limits (P6/P9).
26. `event transportation software guest "boarded" status headcount shuttle event Sciensio Riderly motorcoach` → DEAD END for Sciensio/Riderly; generic vendor pages only.
27. `OptimoRoute send routes to drivers review plan before dispatch "unscheduled orders" help` → Not Scheduled tab with reasons, send-to-app flow (P4/P10).
28. `dispatch software "attention flags" OR "needs review" flight cancelled reservation flag limo` → Attention Flags detail: red ❗, count, filter (P12).
29. `driver app "mark no show" attempt contact passenger paratransit help center` → DREDF topic guide, LIFT 5-min wait, TripSpark MDTs (P7).
30. `conference attendee shuttle arrival batching cluster flights into vehicles software` → Mobisoft playbook (vendor blog), InEvent; no batching UI documented (feeds first-principles #2).
31. `"farm out" reassign trip another affiliate driver cancel reassign limo dispatch knowledge base` → Offered states KB, Auto Farm (P5/P14).
32. `passenger trip timeline status "driver en route" "arrived" tracking page recipient view delivery` → Track-POD Order Status Timeline (P5).
33. `Moovs operator trip status driver tracking link customer text help docs` → Moovs status-text microcopy, browser tracking links (P5/P8/P9).
34. `Samsara route "scheduled vs actual" stop ETA late indicator dispatcher route progress` → ETA recalc, geofence arrive/depart, Route Timeliness colors (P12).
35. `TripShot driver app manifest passenger pass validation boarding count documentation` → boarded counts rolled up by route/shift (P11) — marginal new.
36. `limo dispatch grid drag and drop assign vehicle capacity passenger count exceeded warning` → Ground Alliance marketing only, nothing concretely documented — NOTHING NEW. Sweep declared dry (last substantive search plus this one yielded no new documentable behavior).

Fetches that failed (403, content unavailable to WebFetch):
- support.onfleet.com (all article pages) — relied on search-result excerpts citing those articles.
- kb.samsara.com article pages — relied on search-result excerpts.
- help.optimoroute.com capacity article — relied on search-result excerpts.
- bookingtool.com manifest article — replaced by PRWeb press release (fetched successfully).

Patterns with no fully documentable source: see FIRST-PRINCIPLES CANDIDATES — notably the manual over-capacity hard-block (#1) and attendee-arrival batch auto-suggestion with approval step (#2), which is the closest analog to EventState's core differentiator and appears genuinely undocumented as a product behavior.
