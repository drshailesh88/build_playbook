# Transport Pattern Library — SCREEN-Level Visual Evidence Re-Sweep

**Date:** 2026-06-11
**Method:** Reviewer-mandated re-sweep (Codex adversarial review). Mobbin OAuth failed twice; evidence captured instead via (a) Playwright browser navigation directly to vendor product-image assets + viewport screenshots, and (b) curl-download of vendor-site and Apple App Store screenshot assets (iTunes Search API `screenshotUrls`) followed by visual inspection of each image. **Every finding below was visually inspected by the recording agent.** Evidence class: SCREEN. App Store screenshots are real app UI by Apple policy; vendor "product renders" are noted as such where stylized.
**Run history:** two prior subagent attempts were sandbox-blocked before capture (no findings fabricated); this file supersedes the blocker report from the second attempt.

---

## S1. Day-of boarding / check-in UI

### F1.1 TripShot Driver — Ridership as a first-class driver tab; shift Check-In; trip Complete — EVIDENCE: SCREEN
- Source: App Store screenshot, TripShot Driver (id 988698451), https://is1-ssl.mzstatic.com/image/thumb/Purple123/v4/f9/83/63/f9836399-e943-47f7-cfa1-bf6fd8cf4c23/pr_source.png/392x696bb.png
- Visible: "Schedule" screen; shift card "Coffee Shift — John Smith" with a "Check In" action top-right; trip row "11:45 PM - Coffee Tour — Status: Active" with inline actions "Map | Ridership | Complete"; bottom tab bar "Home | Ridership | Incidents | Settings".
- Supports: `day-of-boarding-checkin` (ridership counting is a top-level driver surface; trip completion is an explicit driver action), `status-integrity-guardrails` (shift check-in gate before driving), and an "Incidents" tab as a driver-side exception channel.
- Limit: the INSIDE of the Ridership screen (expected vs boarded vs capacity counts) was not captured — surface proven, internals still first-principles.

### F1.2 Onfleet Driver — day list with Today/All/Unassigned tabs, pickup/drop-off typed rows, time windows — EVIDENCE: SCREEN
- Source: App Store screenshot, Onfleet Driver (id 1084013403), https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/cc/eb/71/cceb71a1-06ef-65ce-bfb0-fa8d4836c7bd/6b29a3bf-1af5-463e-98b9-8b018270f0ac_Frame_1.png/392x696bb.png
- Visible: header toggle + map icon; segmented tabs "Today | All | Unassigned"; task rows each with address ("258 Brookdale Avenue"), typed direction + person ("↑ Pick-Up - Matthew Mitchell", "↓ Drop-Off - Alexis Hernandez"), and time window ("Tomorrow, 5:00 PM - 5:10 PM") or "No specific time window".
- Supports: `driver-run-sheet-day-of` (driver-held ordered task list with passenger names + windows), `dispatch-board-unassigned-queue` (Unassigned is a tab even on the driver side).

### F1.3 DriverAnywhere (Limo Anywhere driver app) — duty toggle + per-trip status controls — EVIDENCE: SCREEN
- Source: App Store screenshot, DriverAnywhere 4.0 (id 1457011954), https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/e8/51/d9/e851d9f9-d71d-4475-1759-487583be30cf/8a1dfa98-1d59-419b-9ccd-4746cf24b58c_Upcoming_Screen.png/392x696bb.png
- Visible: greeting "Hi, Jared Russum!" with "ON DUTY" toggle; tabs "PENDING | UPCOMING (2) | IN PROGRESS"; trip card: "02:30 PM, Aug 19 · #8085 · Jordan Matthews · PU Ross Ave, Dallas · DO Harry Hines Blvd, Dallas · SED2 (SED)" with requirement icon row (count badge, notes, luggage, child seat, wheelchair-accessibility) and buttons "CHANGE STATUS" / "START TRIP".
- Supports: `driver-run-sheet-day-of`, `status-integrity-guardrails` (status is an explicit control, trips staged pending→upcoming→in-progress), accessibility requirements rendered as first-class icons.

## S2. Dispatch board with unassigned queue + exception/attention flags

### F2.1 Onfleet Command Center — alert counters + routes table + live map — EVIDENCE: SCREEN
- Source: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/screenshots/command-center.png (rendered on onfleet.com/visibility-and-tracking)
- Visible: "Today — December 18th, 2025" dashboard; "Current alerts" card with counters red "1 Failed tasks" and amber "4 Delayed tasks"; "Routes (Today)" donut (In progress – 3, Pending, Delayed – 1); "Completed tasks (Today)" totals (Succeeded 6 / Failed 1); routes table with checkboxes, route names ("EDiaz_12-18-2025_1…"), Assigned driver (Evan Diaz, Brooklyn Parker, Hailey Miller…), Team (SAN FRANCISCO), Start at / End at times (PST), "Filter" button, "Columns"/"Map" toggles; right half is a live map with color-coded routes.
- Supports: `attention-flags-exception-queue` (failed/delayed counters as the board's first element), `dispatch-board-unassigned-queue` (table+map split, filterable), `batch-as-named-container` (named routes with driver + window).

### F2.2 Onfleet dispatch map — unassigned queue + per-stop ETA/late flags — EVIDENCE: SCREEN
- Source: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/screenshots/predictive-etas-2026.png
- Visible: left icon rail; NYC map with per-route color-clustered pins; right rail: "Unassigned — 2 tasks" (45 Mott Street — Rio Martinez; 89 Point Sienna Rd — Jenny Wilson) at the TOP, then "Team NYC — 1 of 2 On Duty / Unassigned Tasks", driver "Tori Williams — In transit … Finish by 12:51 PM today" with an expanded route card "Route NYC AM - Sunday — In progress" listing numbered stops with mixed states: "45 Bayard Street — Andy Pham — Completed: Jun 21, 10:46 AM EDT", "527 Broome Street — Ted Mosby — 11:08 AM EST", and amber-flagged late-ETA stops; below, "Caleb Johnson — Offline, 0 tasks" and "Route NYC PM - Tuesday — Pending".
- Supports: `dispatch-board-unassigned-queue` (unassigned queue pinned above driver lanes), `attention-flags-exception-queue` (amber per-stop late flags inline), `status-integrity-guardrails` (per-stop completed timestamps).

### F2.3 Onfleet — named route containers with pending progress — EVIDENCE: SCREEN
- Source: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/screenshots/unified-delivery-tracking.png
- Visible: same board: "Unassigned — 4 routes, 2 tasks"; named pending routes ("Route NYC PM - Tuesday — Pending", "Route Queens AM - Tuesday — Pending", "Route Miles - Tuesday — Pending") each a collapsible container with progress fraction; per-driver duty status; expanded stop list with per-stop ETAs ("45 Bayard Street — Andy Pham — ETA 10:35 AM EDT").
- Supports: `batch-as-named-container` (named, stateful, progress-bearing containers), `dispatch-board-unassigned-queue`.

### F2.4 Onfleet — three assignment modes (stylized product render) — EVIDENCE: SCREEN (render with callouts, not raw app)
- Sources: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/assignment-and-dispatching/assignment-and-dispatching-hero.webp and .../automate-dispatch.webp (rendered on onfleet.com/assignment-and-dispatching)
- Visible: dark map with color-grouped task pins; callout cards "On-Demand Auto-Dispatch — Auto-dispatched to Clark Davis, Task 1034 14th St, Oakland", "Assign To Driver — [William Monroe ⌄]" (dropdown), "Send To Connected Courier — SERVICE: 2 hr ⌄ / COURIER: Courier 1 ⌄"; second image shows the same three as confirmation toasts.
- Supports: `dispatch-board-unassigned-queue` (assignment gestures: auto / manual / external courier), `bulk-reassign-vehicle-swap` (assignment as dropdown on the unit of work — directional, weaker).

## S3. Arrivals roll-up / transfer planning boards

No SCREEN findings. Tourplan/GlobalWare/Welcome Pickups expose no public product-UI imagery reachable this run (welcomepickups.com and track-pod.com returned no usable static img assets; Tourplan not attempted after budget triage). **Roll-up board remains first-principles** (the REPORT shape is doc-evidenced in the original harvest; the live-screen treatment is ours to design).

## S4. Driver run sheet / trip sheet / manifest

### F4.1 DriverAnywhere — Job Details as the digital run sheet — EVIDENCE: SCREEN
- Source: App Store screenshot, DriverAnywhere 4.0, https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/3d/41/61/3d416153-8d9f-d2a3-a554-545d4c2b43a2/469214fc-d157-459e-a94d-205697aa970f_Job_Details_Screen.png/392x696bb.png
- Visible: "JOB DETAILS" screen for "#8085 — 02:30 PM, Aug 19 2020": icon row (alerts, passengers with count badge, route, payment, notes); "REQUIREMENTS — Seats & Luggage: Toddler Seats : 1; Greeting Sign: [VIEW]"; "PASSENGER INFO — Jordan Matthews"; "ROUTING" section; sticky footer "Current Status: ON THE WAY ›".
- Supports: `driver-run-sheet-day-of` (per-job sheet: passenger, requirements, routing, contact), `manifest-export-audience-toggles` (driver-scoped view exists as its own surface; greeting-sign artifact for pickup identification — VIP-pickup adjacent).
- Plus F1.2/F1.3 above (driver day lists) — the run sheet's list form.

### F4.2 Limo Anywhere Mobile — booking/rate sheet (stylized collage) — EVIDENCE: SCREEN (weak — rotated marketing collage)
- Source: App Store screenshot, Limo Anywhere Mobile (id 1352498835), https://is1-ssl.mzstatic.com/image/thumb/PurpleSource115/v4/64/21/dd/6421ddf0-0339-7037-67b3-813de6bfe51e/7afcea27-6da5-4c5a-8ad4-952ac9e5b48d_5-55-ViewRes.png/392x696bb.png
- Visible (partially, collage is rotated): reservation view with "Capacity: 6 Passengers", vehicle type row, itemized rate lines (Flat Rate, Per Pax, Extras, Est. Drive Time/Total). Recorded for completeness; too stylized to carry interaction claims.

## S5. Passenger-facing notification / tracking page

### F5.1 Onfleet — the SMS notification ladder, verbatim — EVIDENCE: SCREEN
- Source: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/screenshots/automated-notifications.png (rendered on onfleet.com/visibility-and-tracking)
- Visible: three stacked SMS notifications from short-code "528-491": (1) 8:33 AM "Your order is out for delivery. See your package status here: https://onf.lt/0234294" (2) 11:18 AM "You're next to receive your package. More details here: https://onf.lt/0234294" (3) NOW "Package delivered. See more here: …" Behind them, the tokened tracking page on a phone: "Powered by Onfleet" header, driver identity row (photo, "Robert Willis — The Portioned Pot"), destination "929 Market Street, San Francisco, California 94103", progress timeline "3 stops — Before your delivery", "11:58 AM — Estimated arrival", vehicle row "Car — HJ32N" (plate shown).
- Supports: `passenger-notification-ladder` (staged out-for-delivery → you're-next → delivered messages, each carrying the same short tokened link) and `live-tracking-link-no-app` (app-less web page with driver name/photo, vehicle + plate, stops-ahead, ETA).

### F5.2 Onfleet — tracking-page privacy/visibility settings — EVIDENCE: SCREEN (small text partially legible)
- Source: https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/screenshots/tracking-page.png
- Visible: admin settings panel for the recipient tracking page with option rows including "Show number of stops ahead…" and an ETA-as-range option with buffer fields ("minutes before / minutes after"); beside it the resulting phone tracking page: map, driver row "Robert Willis", vehicle "Car" + plate, destination "222 Howard Street", call and message action buttons.
- Supports: `live-tracking-link-no-app` (organizer-configurable disclosure: stops-ahead visibility, ETA buffering) — the privacy/buffer knobs our card hypothesized exist on a real settings screen.

### F5.3 TripShot Rider — self-service notification subscription with delay threshold — EVIDENCE: SCREEN
- Source: App Store screenshot, TripShot (id 1007192056), https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/f7/4a/4e/f74a4e2f-8144-3577-296f-fabf5b3a96ef/9c133948-0e49-4245-a616-4726fa059df6_TripShot_Rider_App_Store_Graphics_090424_5_Apple_5.5_-_Notifications.png/392x696bb.png
- Visible: "Route Subscription" screen: Route "Green Route", Stop "1st Stop", Departure Time "6:30 PM"; rule rows "When vehicle is delayed — by 1 minute ›" and "When vehicle is approaching — Off ›"; scoping rows "On any date" / "Days of week — Mon, Tue, Wed, Thu, Fri"; "Use push notifications" toggle.
- Supports: `passenger-notification-ladder` (subscription model per stop/route) and `flight-alert-taxonomy`'s noise-threshold principle observed in a transit product ("delayed by ≥N minutes" as a user-set threshold).

### F5.4 TripShot Rider — True-Time live vehicle map with scheduled-vs-ETA honesty — EVIDENCE: SCREEN
- Source: App Store screenshot, TripShot, https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/e2/3a/91/e23a91b4-74f9-9ccc-efdd-db31094f26f0/1502afe5-efce-45a6-86c3-39ed6c1c31bd_TripShot_Rider_App_Store_Graphics_090424_4_Apple_5.5_-_True-Time.png/392x696bb.png
- Visible: map with route polyline and live vehicle position; itinerary card "1st Stop → 3rd Stop · Blue Route · 5min"; expanded steps "Take bus Blue Route — 1st Stop: Scheduled Departure: 1:45 PM / ETA: 1:45 PM" (alarm affordance per stop), "1 intermediate stop ⌄", "3rd Stop: Scheduled Arrival: 1:50 PM".
- Supports: `live-tracking-link-no-app` (V2 live-position variant) — note Scheduled and ETA rendered side by side, never conflated.

---

## Discarded as NON-evidence (honesty log)
- tripshot.com prismic images "5-Home-Driver/Operator/Rider" — stock photography / composite marketing photos, no readable UI.
- onfleet timeline-first.png — stock photo of a driver, not UI.
- zum Student Transportation App Store screenshot #7 — login splash only.
- moovsapp.com homepage images — Unsplash stock.

## COVERAGE NOTE
| Source | Result |
|---|---|
| onfleet.com/assignment-and-dispatching asset URLs (browser) | 2 product renders captured (F2.4) |
| onfleet.com/visibility-and-tracking (curl) → features/screenshots/* | 5 real dashboard/page screenshots captured (F2.1–F2.3, F5.1–F5.2) |
| iTunes Search API screenshotUrls: Onfleet Driver, TripShot, TripShot Driver, DriverAnywhere, Limo Anywhere, Track-POD, Zūm, Moovs | 6 app screenshots captured (F1.1–F1.3, F4.1–F4.2, F5.3–F5.4); Track-POD + Moovs downloaded but not inspected (budget); Zūm splash-only |
| track-pod.com, welcomepickups.com | no static img assets in HTML (JS-rendered) — no captures |
| tourplan.com, hoppa.com, bringg.com, routific.com, optimoroute.com, jungleworks.com/tookan, G2/Capterra | not attempted — budget triage after S1/S2/S4/S5 reached sufficiency |

**Gate verdicts (per surface):** S1 boarding — PARTIAL LIFT (driver-side boarding/ridership surfaces and status controls are screen-proven; per-stop expected/boarded/capacity internals remain first-principles). S2 dispatch board — LIFT (board anatomy, unassigned queue, alert counters, per-stop late flags all screen-proven). S3 arrivals roll-up — NO LIFT (first-principles stands). S4 run sheet — LIFT for the mobile-app form (tokened-link/print variant remains doc+first-principles). S5 passenger notification/tracking — LIFT (ladder, tokened page, privacy knobs, thresholds all screen-proven).
