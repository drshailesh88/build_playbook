# TRANSPORT — Mobbin Re-Sweep (Screen-Level Visual Evidence)

Screen-level re-sweep closing the visual-evidence gap flagged by adversarial review, 2026-06-11. Every entry below describes only what is visible in the returned Mobbin screen image and cites its canonical mobbin_url. Adjacent-domain evidence is labeled ADJACENT.

---

## Family 1 — Passenger pickup notification / trip-details page

Verdict: **STRONG** (Grab, Uber, Bolt, Beat Passenger direct; GetYourGuide, Lugg, DoorDash web, Uber Eats web adjacent).

### 1.1 Grab — lock-screen Live Activity pickup states
- https://mobbin.com/screens/9a700872-7aee-4cde-9fc4-17603d866cde ("Driver has arrived")
- https://mobbin.com/screens/4363d57a-4659-41ec-8459-3bcbba502560 ("Driver is nearby")
- Anatomy: iOS lock-screen widget; one bold status line where only the state word is colored green ("Driver has **arrived**" / "Driver is **nearby**"); second line packs plate + vehicle: "B···TNV · Abu-abu BYD M6 Electric"; horizontal progress track with a car glyph that moves toward a blue endpoint dot.
- Problem solved: passenger gets state + vehicle identity without unlocking the phone.
- Microcopy verbatim: "Driver has arrived", "Driver is nearby".
- Mobile/a11y: state changes carried by both color AND wording — not color-only. Progress-bar metaphor gives at-a-glance distance.

### 1.2 Grab — "Driver has arrived" detail sheet with no-show deadline
- https://mobbin.com/screens/915e0c83-1168-4c7f-9dea-a7905123b483
- Anatomy: header "Driver has arrived" + subline "Meet your driver by 6:48 PM to avoid extra fees or cancellation." Driver block: photo, "Kng Hock Leong · 5.0 ★", "Joined Nov 2019", vehicle line "Silver Premier I30 · SHD1122J · Standard Taxi", chat (with unread dot) + phone buttons. Compliment cards ("Great Personality — Your driver is warm and engaging." with a count badge 23). Fare stack (SGD 8.01, "15% off Grab Ride", "Current total S$8.70-12.10" with struck-through S$10.30-14.30). Route block (origin "Maxx Coffee (JEM)" → "233 Bukit Batok East Ave 5"). Red text "Cancel Booking" at bottom.
- Problem solved: arrival state + a concrete grace deadline; sad path (no-show fee/cancellation) is stated up front with an exact clock time, not a vague countdown.
- Microcopy verbatim: "Meet your driver by 6:48 PM to avoid extra fees or cancellation."

### 1.3 Grab — arrived map with oversized plate chip
- https://mobbin.com/screens/f157d309-d94b-4750-96dd-74cc946b7cde
- Anatomy: full map with live traffic, header "Driver arrived"; bottom sheet: "Your driver has arrived." + plate rendered as a physical license-plate chip "SHB730X" above "Toyota prius"; driver row (photo, "Lim Chong Pin", 5 stars) with call + chat buttons.
- Detail worth stealing: the plate is the single largest text element on the sheet — vehicle identification is treated as the primary task at the arrived moment.

### 1.4 Uber — pickup point card with ride PIN
- https://mobbin.com/screens/d72a83f6-0ca5-4415-ad39-14f58c8bf092
- https://mobbin.com/screens/e9f932a7-f19a-4bf7-b459-dfbfc0239a95 (variant)
- Anatomy: "Meet at the pickup point for Eno Wine Bar" + black "0 min" timer box; row "PIN for this ride" with four large digit tiles (7 5 8 6); driver photo overlapping car photo; "Beige Toyota Camry"; "Ryusuke · 5.0★ · Top-rated driver"; inline input "Any pickup notes?"; phone + brightness/share buttons. Variant adds a blue "Share PIN" bar, toast "Sharing live location with your driver to help them find you", and a blue "I've arrived" pill CTA with dismiss X.
- Problem solved: wrong-car boarding (PIN verification) and pickup-point ambiguity; passenger can self-report presence ("I've arrived").
- Microcopy verbatim: "PIN for this ride", "Share PIN", "I've arrived", "Sharing live location with your driver to help you find you" [sic — as shown: "…to help them find you"].

### 1.5 Bolt — "Arriving in 1 min" card with plate badge
- https://mobbin.com/screens/ba45f249-6dba-4711-86e3-0c06c07af24c
- Anatomy: map with blue route polyline + green "1 min" pin at pickup; bottom card "Arriving in 1 min"; bordered plate badge "ILY 331"; "Toyota Yaris Cross, Grey"; "khaled G. · Top-rated driver" with photo; cut-out photo of the actual vehicle model; "Any pickup notes?" input + call button; floating "Safety" shield button on the map.
- A11y note: color named in words ("Grey") rather than relying on the car photo alone.

### 1.6 Uber — package pickup readiness prompt (ADJACENT, courier)
- https://mobbin.com/screens/00840ac8-6629-4ac9-9a1f-fa91a7122968
- Anatomy: black confirmation toast "Thanks for helping your driver find you by sharing your live location!"; card "Be ready at the door with your package" + "5 min" box; collapsible "Show pick-up instructions"; driver row with "Toyota Camry Hybrid", "JAHANGIR · Top-rated driver".
- Steal: imperative readiness instruction tied to the ETA ("Be ready at the door…") — same shape as a shuttle "be at the stop" nudge.

### 1.7 Uber — booking-a-ride flow, pickup-wait states (flow)
- https://mobbin.com/flows/c54d8dfb-8f67-4e82-afb6-7943d8886c5b (15 screens)
- Observed in previews: "Confirming your ride" skeleton state; "Pickup in 1 min / Pickup in 3 min" sheets with "Ride details — Meet at your pickup spot on [street]" and explainer "Driver will arrive on the same side of the street as your pickup spot"; map labels "Pickup spot", distance chips ("0.2 miles"); dismissible toast "Sharing live location with your driver to help them find you"; post-trip tip/rating sheet ("Add a tip for ___ — Your trip was $7.81", $1/$3/$5 chips, 5 stars, disabled Submit).
- Sad-path coverage: loading state (skeleton card) is an explicit designed state, not a spinner.

### 1.8 Uber — message-driver quick replies (flow)
- https://mobbin.com/flows/c447156b-3263-43fb-8801-cb44fdf3beac
- Anatomy: chat thread with driver auto-context messages ("Arriving now," / "Dark Gray Chevy Malibu"); one-tap quick-reply chips "I'm here", "Be right there", "I'm looking f…"; persistent safety banner "Keep your account safe - never share personal or account information in this chat"; call icon top-right.
- Steal for shuttle ops: canned replies for the three highest-frequency pickup messages.

### 1.9 Beat Passenger — "MEET THE DRIVER AT" full-map state
- https://mobbin.com/screens/e7852379-937b-4ef1-a03c-03abc2e9a33a
- Anatomy: all-caps map headline "MEET THE DRIVER AT"; stop card listing "Otrineon 17" (current, dot) and "Agias Marinas 1" (next, chevron); taxi icon with "5 min" chip moving along drawn route; pill "Sharing live location" with signal icon; bottom bar: photo of the actual yellow cab + green plate "TAA 1112" + "Skoda, Octavia 2012" + payment row "Personal ···· 8112".
- Steal: instructional headline phrased as a command on the map itself.

### 1.10 GetYourGuide — static meeting-point page (ADJACENT, tours)
- https://mobbin.com/screens/068c3193-5700-477c-a862-6dd863ee2238
- Anatomy: "Meeting point" page with icon rows: Address ("Plaça de Garriga i Bachs, 08002, Barcelona, Spain"), time ("Arrive by 15.45" + "Be on time to keep your slot."), and long-form "Instructions" prose: "…The tour guide will be standing right in front of the monument waving a white and red flag!" plus public-transport fallback directions and "IMPORTANT: If finally you cannot assist, please remember to cancel your reservation or get in touch with the guide."
- Problem solved: static (non-live) pickup instructions — exactly the shape of a conference shuttle "where to stand" page: address + deadline + human-recognizable landmark + cancellation sad path.

### 1.11 Lugg — scheduled pickup window card (ADJACENT, moving)
- https://mobbin.com/screens/72ce6e01-6ba8-4908-adc8-2727e2e68246
- Anatomy: header "Tomorrow, 10 - 11AM" + Edit; illustrated truck; "Pick up @ Menlo Park Inn, Menlo Park somewhere between 1AM - 2AM" (window phrasing); editable origin/destination rows with pencil icons; route map with directional arrow buttons.
- Steal: time-window phrasing ("somewhere between X–Y") for pre-day shuttle assignments where exact ETA doesn't exist yet.

### 1.12 DoorDash web — ETA-change ("delay") modal + progress stepper (ADJACENT)
- https://mobbin.com/screens/9e3be4f0-fbc1-4a10-9cd8-608569a9d4a6 (modal)
- https://mobbin.com/screens/03555ab9-dd42-45cc-97b7-aa608e1e9c4e (stepper)
- Anatomy: modal "Order now arriving 7:54 PM – 8:09 PM" with a grey inset box "Original arrival time — 7:44 PM – 7:59 PM" and single "Got it" button. Tracking page: 4-node progress stepper (store → bag → car → home) under "Heading to Sam Lee — Arrives between 8:35 – 8:41 AM", courier row "Your Dasher — JOSHUA L" with call/chat; map flag "Completing another order nearby" explaining a detour.
- Sad paths: delay communicated with old-vs-new times side by side; detour explained in plain language on the map pin.
- Steal: the old/new time juxtaposition is the canonical delay-notice pattern for shuttle ETA slips.

### 1.13 Uber Eats web — arrival handoff with PIN confirm (ADJACENT)
- https://mobbin.com/screens/fbbc20da-52f8-4211-b0ea-a0bedf3fd0f6
- https://mobbin.com/screens/085c4e58-280f-4a6b-8039-0f81976873c6
- Anatomy: left rail "Almost here! — Arriving now — Time to meet Ian at the door" with segmented green progress bar; dismissible card "Keep your phone nearby in case Ian needs to reach you"; "Ian is in a Kia Sportage" + call; PIN chip "7390" and footer "Confirm delivery with PIN 7390"; chat panel shows scripted updates ("Hey Sam, I just need your pin to confirm!"); earlier state "Heading your way… — Estimated arrival 7:45 PM — Latest arrival by 8:15 PM ⓘ".
- Steal: "Estimated" vs "Latest arrival by" dual-time framing — honest ETA with a worst-case bound.

---

## Family 2 — Day-of boarding / check-in at a stop

Verdict: **PARTIAL** — rider-side QR boarding is direct (Transit, BlaBlaCar); staff-side check-in evidence is ADJACENT only (Luma, Partiful event check-in). The exact target — a per-stop/per-vehicle manifest showing expected vs checked-in vs capacity — was NOT found. School-bus apps (Zūm, HopSkipDrive), FlixBus/Omio/Busbud agent-side: absent from Mobbin.

### 2.1 Transit — live bus ticket with anti-screenshot validation
- https://mobbin.com/screens/c4e98f62-bb31-4627-826a-9f7e15de6d72
- Anatomy: "Scan your ticket" label over large QR; Big Blue Bus brand roundel; live ticking clock "2:08:14 AM" in huge digits; full-width orange band "Regular"; ticket metadata card "Regular Single Ride — Santa Monica, CA — Expires Nov 6, 2025 at 7:07 PM".
- Problem solved: visual inspection at boarding — the live clock + colored band let a driver validate at a glance without scanning; clock defeats screenshots.
- Mobile/a11y: enormous type for the clock and fare class; high-contrast band.

### 2.2 BlaBlaCar Bus — QR-first boarding confirmation
- https://mobbin.com/screens/0a14903d-3da6-4336-aad6-be549790e2c8
- Anatomy: success check illustration; "Thank you for your purchase"; email-fallback copy "We just sent a confirmation email with your ticket attached to samlee.mobbin@gmail.com. If you can't find the ticket please check your spam folder"; primary "Download the ticket", secondary "Add to Apple Wallet" with note "Apple Wallet tickets are being generated. Please wait a moment."; below: "For quick boarding, simply use the QR code below." + QR labeled "Ticket".
- Sad paths: spam-folder fallback, wallet-generation pending state — both written out.

### 2.3 Luma — organizer scan-to-check-in loop (ADJACENT, events)
- https://mobbin.com/screens/a779f7d7-ecb5-4080-8bcd-b05cc92b30d4 (scanning)
- https://mobbin.com/screens/a39d7cad-6e2f-4fed-8df5-02ceae0afee6 (guest card)
- https://mobbin.com/screens/fb4c1d40-7784-43eb-ab19-b73151e16e84 ("Check In Successful")
- https://mobbin.com/screens/dd6e918e-5554-4a02-ae99-a25668c82d5a (Check In button state)
- https://mobbin.com/screens/41bed30f-78ed-4b43-a5db-ac2dd783c584 (guest list + detail)
- Anatomy: camera viewfinder reads attendee's QR → bottom card resolves to person: avatar, "Jason Smith", email, "Status: Going" (green), "Registration Time: Today at 9:41 AM", "Ticket: Standard" → full-width black "Check In" → green toast "✓ Check In Successful" → button becomes "Undo Check In". Guest List screen: search "Search event guests…", tabs "Going / Invited / Not Going / Checked In", per-row right-aligned status ("Going" green, "Checked In" green next to name).
- Problem solved: staff check-in where scan resolves to an identity card BEFORE committing — prevents checking in the wrong person; undo is first-class.
- Steal for boarding: the scan → identity confirm → commit → undo loop is exactly the tap-to-board interaction; tabs are the manifest segmentation (expected vs checked-in) minus capacity counts.

### 2.4 Partiful — manual check-in list with undo confirm (ADJACENT, events)
- https://mobbin.com/screens/ea985466-4b63-4131-a55d-7f43a9985882
- https://mobbin.com/screens/37969245-dc2d-4af9-9079-fb6547dbcad5 (Manage Guests with counts)
- Anatomy: "Check In Guests" list; search "Find a guest…"; rows show avatar, name, RSVP emoji-status ("🤙 Going", "🤔 Maybe"); per-row pill "Check in" that flips to a black checkmark; tapping a checked guest opens sheet "Uncheck them?" with avatar + name and buttons "Undo check-in" (black) / "Nevermind". Companion "Manage Guests" screen shows aggregate count chips "🤙 Going 1 · 🤔 Maybe 1 · 😢 Can't Go 0" — the closest thing found to expected-counts-at-a-glance.
- Steal: destructive-undo confirm sheet; aggregate status chips as a lightweight manifest header.

### 2.5 Apple Wallet airline boarding passes (ADJACENT, airline)
- https://mobbin.com/screens/7d0d0780-7c35-4620-ab73-1ec50487b450 (American Airlines)
- https://mobbin.com/screens/fe3800b2-59af-4229-9412-115dcb51c881 (Emirates)
- Anatomy: AA pass: GATE 7 / FLIGHT AA2819, JFK ✈ ORD, GROUP 9, SEAT 32D, STATUS "On Time", TERM 8, BOARDS 8:25 AM, QR + "Confirmation code". Emirates: SEAT/GATE B20, DXB ✈ SIN, DEPARTS / GROUP E / FLIGHT EK0352 / CLASS, SEQ 0057, "SMART GATE Eligible", QR.
- Steal: label-over-value grid for the boarding artifact; "BOARDS [time]" as distinct from departure time — direct analog for "shuttle boards 8:25, departs 8:40".

### NO MOBBIN EVIDENCE FOUND — staff-side per-stop manifest with capacity
- The core target (manifest: expected vs checked-in vs capacity per stop/vehicle, bus context) returned nothing direct. Queries listed in COVERAGE NOTE (F2 rows). School-bus apps and intercity-bus agent tools are not catalogued on Mobbin. Closest substitutes are 2.3/2.4 above.

---

## Family 3 — Driver run sheet / driver app stop list

Verdict: **STRONG** on anatomy (DoorDash Dasher deeply documented; Apple Maps + Google Maps multi-stop lists; Grab multi-stop) — but note only ONE true gig-driver app (DoorDash Dasher) is on Mobbin; Uber Driver, Lyft Driver, Amazon Flex, Bolt Driver are absent.

### 3.1 DoorDash Dasher — "Current dash" ordered task list
- https://mobbin.com/screens/5859ffb5-02a0-45ee-9065-2ea87eaf43fa
- Anatomy: title "Current dash"; map with route from store icon to home icon; task rows in sequence: "Pick up for [name] — by 3:31 PM" tagged "Current task" with chevron, then "Deliver to [name] — by 3:53 PM" with chevron; toggle row "⏸ Pause orders after delivery"; "Earnings — This dash $0.00"; "1 Live Promo" expander.
- Problem solved: driver sees only the ordered task list with per-task deadlines; exactly one task is marked current.
- Steal: "Current task" tag + per-stop deadline times = the run-sheet spine. "Pause orders after delivery" = driver-initiated availability control.

### 3.2 DoorDash Dasher — offer acceptance with constraint checklist and countdown
- https://mobbin.com/screens/61830cf9-fba8-4c86-a85f-5b84b20fcc54
- https://mobbin.com/screens/79689842-c73b-4981-a264-9eb392b39612 (tutorial variant)
- Anatomy: "$11.50 Guaranteed (incl. tips) — 2.8 mi — Deliver by 3:53 PM"; itinerary "Retail pickup: TotalWine – Harrison Ave (1 item) → Customer dropoff"; icon checklist of constraints: "⚠ Contains restricted items, including alcohol", "Must be 21+ to accept order", "Check recipient's ID", "May need returns"; red "Accept" with live countdown "36"; "Decline" pill on map. Tutorial variant: "Deliver by 10:45am — Chipotle — 3 items · 1.4 mi total — $8.00" with 30s ring and disclaimer "This is not a real order. You'll see an order with pay, distance and merchant information." (Step 2/6).
- Steal: constraints surfaced BEFORE accept; time-boxed decision with visible countdown.

### 3.3 DoorDash Dasher — pickup detail with verification + waiting sad path
- https://mobbin.com/screens/5cb6f086-abb8-4751-874a-e2901cb238e3
- Anatomy: header "Pick up by 3:31 PM"; "Order for [name]" + call/chat; banner rows: "21+ ID required — You need to scan and check the recipient's ID and collect a signature before handing over any items"; "This is a delivery requested by the merchant. We don't know the exact items."; "Order number: ___ — Please use this ID instead of the customer name"; "Pickup Instructions — Do NOT park in curbside pickup spots. Go inside to the web order pickup area…"; "Waiting for your order? Your on-time rate includes a buffer for extra time spent waiting at the store."; full-width red "Confirm pickup".
- Sad paths: unknown manifest contents, waiting-at-stop, ID verification — each gets explicit copy. Steal the on-time-buffer reassurance for shuttle drivers held at a stop.

### 3.4 DoorDash Dasher — active delivery screen with recipient verification CTA
- https://mobbin.com/screens/8129d89c-6823-4706-b602-d76b35d72304
- Anatomy: header "Deliver by 3:53 PM" + help "?"; earnings chips on map "$11.50 this offer / $0.00 this dash"; "Delivery for [name]" with phone + message buttons; address row with home icon; "Directions" chip handing off to nav; primary red "Start Recipient Verification".
- Steal: name + call/text + navigate as the three per-stop actions; completion gated behind a verification CTA (analog: tap-to-board confirm).

### 3.5 Apple Maps — multi-stop Route Options panel (ADJACENT, nav)
- https://mobbin.com/screens/e699f8a1-ab48-42a3-8ed2-3b4e6ca43401
- Anatomy: dark nav mode, lane-guidance arrows up top; "Route Options" sheet: stop rows "7-Eleven — 4:27 PM arrival" and "Singapore Cha… — 4:59 PM arrival", each with a call button and a red remove (–) button; action rows "+ Add Stop", "Share ETA", "Report an Incident"; full-width red "End Route".
- Steal: per-stop projected arrival times in the list; call-from-stop-row; explicit "End Route" terminator.

### 3.6 Google Maps — ordered A/B/C/D stop editor (ADJACENT, nav)
- https://mobbin.com/screens/3d16a316-0986-42fe-a322-0b5a6672b12f
- Anatomy: lettered stops (A FairPrice…, B Shell, C Raffles Institution, D "Add stop") with drag handles and per-row X; summary "Total trip: 30 min"; "FINISHED" affordance; route on map.
- Steal: drag-to-reorder + letters for stop identity.

### 3.7 Grab — numbered multi-stop ride editor
- https://mobbin.com/screens/25a16dce-2e22-486c-9e11-34b7e04a376e
- Anatomy: origin dot "53 Park Villas Rise" then numbered red stops "1 Terminal 3 Departure - Changi Airport", "2 Terminal 2 Departure - Changi Airport", each removable via X; green "Done".

---

## Family 4 — Dispatcher attention/exception queue

Verdict: **PARTIAL (adjacent-only)**. As predicted, no fleet/dispatch consoles (Onfleet, Samsara, Motive, Bringg) exist on Mobbin — the dedicated fleet query returned only consumer tracking pages. Strong adjacent evidence from support/finance/marketplace ops queues.

### 4.1 Zendesk — "Tickets requiring your attention" queue (ADJACENT, support ops)
- https://mobbin.com/screens/9a6a8c5d-5d9c-449c-a352-cd63bbe1d49d
- Anatomy: dashboard header stats "Open Tickets (current): 25 YOU / 28 GROUPS" + "Ticket Statistics (this week): 0 GOOD / 0 BAD / 0 SOLVED"; table titled "Tickets requiring your attention (31)" with link "What is this?"; columns: checkbox, Ticket status (red "Open", yellow "New" pills), ID, Subject, Requester, Requester updated, Group, Assignee; rows grouped by "Priority: Low" / "Priority: -"; left rail of latest ticket comments; pagination.
- Steal: the queue IS the homepage; count-in-title; status pill + priority grouping + assignee column = the dispatcher exception table.

### 4.2 Navan Admin — "Flagged" transactions tab (ADJACENT, expense ops)
- https://mobbin.com/screens/06edd93a-1f54-496f-8632-20a56c50dba1
- Anatomy: "Transactions" page; filter bar (Merchant search, Date, Transaction type, More filters); tabs "All / **Flagged 0** / Info requested / Awaiting repayment / Export to payroll / Payroll reimbursements / Pending / Declines"; explainer line under tab: "Transactions that require additional attention from an admin."; Export button; skeleton rows (empty state).
- Steal: exception states as named tabs with counts; one-line definition of what "flagged" means right in the UI.

### 4.3 Fiverr — Manage Orders with PRIORITY/LATE tabs (ADJACENT, marketplace ops)
- https://mobbin.com/screens/461a5b79-0374-44cd-8d65-fd1043ec2e9f
- https://mobbin.com/screens/4dc62c04-bf02-4395-8fa0-a57321f8bca1 (note popover)
- Anatomy: "Manage Orders"; tab strip "PRIORITY (1) / ACTIVE (1) / LATE / DELIVERED / COMPLETED / CANCELLED / STARRED (1)"; table BUYER / GIG / DUE ON / TOTAL / NOTE / STATUS ("IN PROGRESS" purple pill); star toggle with "Unstar" tooltip; hover note popover with timestamped annotation "Nov 14, 2024, 9:03 AM — Finish before 15 Nov" with edit/delete.
- Steal: "LATE" as a first-class queue; per-row dispatcher notes with timestamps.

### 4.4 Stripe — "Action required" escalation banner (ADJACENT, payments ops)
- https://mobbin.com/screens/6d812512-d172-4e8d-8921-fe38ed18e434
- Anatomy: persistent red top-nav badge "Action required ⚠"; page-level red banner "Your business does not meet our Terms of Service — …therefore legally cannot use Stripe services. If you think this may be a mistake, please contact us."; Fraud & risk module with tabs "Overview / Reviews / Rules / Lists / Risk controls" and funnel columns "Authenticated → Screened By Radar → Disputed" with legend (Failed 3DS, Blocked by Radar, Sent to review, Fraudulent disputes…).
- Steal: severity escalates from a badge (ambient) to a banner (blocking) with a recovery path ("contact us"); "Sent to review" as an explicit exception state.

### 4.5 Programa / Etsy — overdue-first sorting (ADJACENT, ops lists)
- https://mobbin.com/screens/3140bd98-b2bb-4e2a-b4bf-b7a2caa807e3 (Programa)
- https://mobbin.com/screens/31306b17-7482-4522-b9b7-a61c7886e2bb (Etsy)
- Anatomy: Programa procurement list groups "Overdue" section ABOVE "This Week", overdue dates rendered in red ("Mon 16 Jun"), status pills per row, collapse per group; success toast "Procurement was successfully updated". Etsy "Orders & Delivery": sort control "Dispatch by date" with radio filters "All / Overdue / Today / Tomorrow / Within a week / No estimate" in the right rail.
- Steal: time-bucket grouping with Overdue pinned to top — the cheapest exception queue.

### NO MOBBIN EVIDENCE FOUND — true fleet dispatch consoles
- Onfleet, Samsara, Motive, Bringg, and any "live fleet map + exceptions" web console: absent. The targeted query (F4-Q2 in COVERAGE NOTE) returned only consumer order-tracking pages (DoorDash, Uber Eats, sweetgreen). Recommendation stands on the adjacent ops-queue patterns above.

---

## Family 5 — Capacity enforcement UI

Verdict: **STRONG** (Eventbrite, eBay, Airbnb, Viator, Ticketmaster, Booking.com, Grab, Shopee, Kakao T, Transit — 10 apps).

### 5.1 Eventbrite — tier list with SOLD OUT chip and capacity-rule-in-name
- https://mobbin.com/screens/da112b9a-44ec-4dc7-a91c-517565e308cb
- https://mobbin.com/screens/bd86173f-5c38-4171-a411-f7763f0da4c3 (zero-quantity state)
- Anatomy: ticket tiers as cards, each with "− 0 +" stepper; "GENERAL ADMISSION 21+ [TIER 1] — $12.51 incl. $2.51 fee — Sales end on May 3, 2025"; third tier "FREE WITH RSVP [FIRST 50 PEOPLE TO ARRIVE] 21+" with black "SOLD OUT" chip replacing its stepper; minus button rendered faint/disabled at 0; sticky footer recalculates total ("$0.00" when nothing selected) with Apple Pay CTA.
- Steal: capacity policy encoded in the tier name ("FIRST 50 PEOPLE TO ARRIVE"); sold-out removes the stepper entirely rather than disabling it.

### 5.2 Facebook Local (Eventbrite tickets) — unavailable tiers greyed inline
- https://mobbin.com/screens/fdc39e21-ed3f-408a-8bed-6dff0987d5d4
- Anatomy: "Select Tickets" sheet; available tier "DOOR - show @ 8pm — US$39.04 each — Sale Ends at 2 PM" with active "− 2 +" stepper; below, "ADVANCE - show @ 8pm" and "DINNER + ADMISSION" rows greyed with right-aligned "Not Available" replacing steppers; running "Total US$78.08 — Includes all service charges and tax".
- Steal: dead tiers stay visible (greyed) so the rider understands what existed and what's gone.

### 5.3 eBay — stepper with remaining-stock caption
- https://mobbin.com/screens/4d496fe4-1184-44a9-bf00-91ed0cce301d
- Anatomy: "Choose quantity" bottom sheet; huge centered numeral "3" flanked by − / + circles; small caption directly beneath: "5 available".
- Steal: the remaining count lives inside the stepper component, not elsewhere on the page.

### 5.4 Airbnb — "(9 left)" inline remaining-slots stepper
- https://mobbin.com/screens/3c73932b-6170-4842-b034-68ec58896059
- Anatomy: "Add more guests" page; explainer "Add guests up to the maximum amount of spots the host allows. Guests you add get emailed the reservation details."; row "Add a guest (9 left)" with "− 0 +" (minus disabled at 0); footer "Review changes >" disabled until a change is made.
- Steal: remaining capacity in the row label + disabled commit button until valid — quiet enforcement, no error states needed.

### 5.5 Viator — hard max stated in the picker
- https://mobbin.com/screens/4cf12848-6540-4d13-8701-49f3839a2f8a
- Anatomy: "Travellers" sheet over availability results; first line: "This activity allows a maximum of 9 travelers."; row "Adult — Ages 14-99" with "− 2 +"; black "Save". Background card shows "Free cancellation until 11:00 AM on Feb 26" and computed "Total: $51.30 — 2 Adults x $25.65".
- Steal: state the ceiling as the first line of the capacity sheet.

### 5.6 Ticketmaster (in-app browser) — limit policy + blocked-search recovery
- https://mobbin.com/screens/5bb4eaea-2cef-44f4-8135-3372e9d19508
- Anatomy: event header "Important Event Info: *There is a strict 6 tick… more"; controls "2 Tickets ▾" + Filters; blue info panel "ⓘ Please Adjust Your Search — The seating options you selected aren't available due to the ticket quantity or filter you applied. Please try adjusting the number of tickets selected or use the seat map to search for available seats."
- Sad path: over-capacity/unavailable selection produces an instructional recovery message naming both causes and both fixes — the best "blocked at limit" copy found.

### 5.7 Grab Bus & Ferry — "159 of 159 seats left" trip card
- https://mobbin.com/screens/6fc5ce3e-0ea9-493c-8410-482fc59fb16a
- Anatomy: "Select departure — 1 adult"; date strip; "42 trips found"; trip card "Ferry · Batam Fast Ferry — 7:40 am — 1h 17min — Harbour Front → Batam Center"; capacity line "159 of 159 seats left" + chip "⚡ Instant Confirmation"; price "S$ 33.00 / person".
- Steal: X-of-Y seat meter on the trip card itself — direct shuttle-manifest capacity display, rider-facing.

### 5.8 Booking.com — red scarcity line under unit selector
- https://mobbin.com/screens/55b568c2-e539-4ea1-9ff4-18ad4343f5fa
- Anatomy: room card with "1 unit ▾" selector + delete; immediately below, red icon + red text "We have 5 left"; yellow strip "It only takes 2 minutes"; sticky "Reserve" footer "$39 · 1 unit".
- Steal: scarcity placed at the point of quantity choice, colored as warning.

### 5.9 Shopee (train booking) — per-carriage availability + hold countdown
- https://mobbin.com/screens/0549d09a-3473-42dd-b414-02fdbdb7b423
- Anatomy: "Select Departure Seat" with red "Time Remaining 2m54s" bar (seat hold); "Select Carriage" sheet listing "EKO-1 — 31 Seat(s) Available … EKO-7 — 71 Seat(s) Available" with radio check on current; orange "Confirm".
- Steal: per-vehicle-section availability counts + time-boxed hold — the closest found to per-vehicle capacity allocation.

### 5.10 Kakao T — sold-out / almost-sold-out badges on schedule rows
- https://mobbin.com/screens/8e3073a6-312c-4c38-9eec-aa061d6b28c0
- Anatomy: train results list; each row = depart→arrive times, duration, train code chip, price; unavailable departures greyed with badge "매진" (sold out); near-capacity ones badged "매진임박" (almost sold out) while still tappable.
- Steal: three-state row treatment (open / almost-full warning / full+disabled) on a schedule list — exactly the shuttle-departure picker states.

### 5.11 Transit — vehicle crowding warnings on trip options
- https://mobbin.com/screens/58193d5d-f4ab-43a2-b77b-8d074a670d81
- Anatomy: trip comparison rows; route badges (red "453", brown rail roundel "14") with small yellow ⚠ crowding indicators on segment glyphs and a passenger-count icon "6+" above one leg; per-row timing "Go in 2 min … 15min"; "Show more trips >".
- Steal: capacity/crowding as a per-leg warning glyph in a list, not a separate page.

---

## COVERAGE NOTE

Every query run (family · tool · platform · query → result):

| # | Family | Tool | Platform | Query | Result |
|---|--------|------|----------|-------|--------|
| 1 | F1 | search_screens (deep, 8) | ios | "your driver is arriving pickup notification with driver name vehicle and license plate rider app" | HIT — Grab x4, Uber x3, Bolt |
| 2 | F1 | search_flows (3) | ios | "ride tracking trip details driver arriving Uber Lyft" | HIT — Uber "Booking a ride" (15 scr), "Message driver", "Activity" |
| 3 | F1 | search_screens (deep, 6) | ios | "airport shuttle transfer pickup instructions where to meet your driver trip details" | HIT — Beat Passenger, GetYourGuide, Lugg, Uber, Grab(dup) |
| 4 | F2 | search_screens (deep, 8) | ios | "bus boarding QR code ticket scan check-in FlixBus" | HIT — Transit, BlaBlaCar, American Airlines, Apple Wallet/Emirates, Eventbrite, Alipay (no FlixBus) |
| 5 | F2 | search_screens (deep, 7) | ios | "organizer check-in attendee list checked in count capacity scan tickets at door" | HIT — Luma x5, Partiful x2 (adjacent events) |
| 6 | F2 | search_screens (deep, 6) | ios | "school bus student roster pickup stop check in driver attendance" | DRY for target — no school-bus apps; returned Turo/Trainline/Trip.com passenger pickers |
| 7 | F3 | search_screens (deep, 8) | ios | "driver app delivery route ordered stop list navigate call customer mark delivered" | HIT — DoorDash Dasher, Apple Maps, Google Maps, Grab; (Bolt Food, Swiggy rider-side noise) |
| 8 | F3 | search_screens (deep, 7) | ios | "Dasher Uber Driver today schedule list of trips earnings active delivery accept" | HIT — DoorDash Dasher x4; no Uber Driver/Amazon Flex/Bolt Driver on Mobbin |
| 9 | F4 | search_screens (deep, 8) | web | "operations dashboard alerts queue flagged orders needs attention review resolve severity" | HIT (adjacent) — Zendesk, Navan, Fiverr x3, Stripe, Etsy, Programa |
| 10 | F4 | search_screens (deep, 6) | web | "fleet dispatch console live vehicle tracking delivery exceptions failed deliveries" | DRY for target — consumer tracking only (DoorDash x3, Uber Eats x2, sweetgreen); fleet consoles absent |
| 11 | F5 | search_screens (deep, 8) | ios | "ticket quantity selector seats left limit reached sold out warning stepper" | HIT — Eventbrite x2, Facebook Local, eBay, Airbnb, Viator, Ticketmaster(Snapchat), TickPick |
| 12 | F5 | search_screens (deep, 6) | ios | "few seats left urgency badge bus train trip card seats remaining" | HIT — Grab, Booking.com, Shopee, Kakao T, Transit, BlaBlaCar |

Loop-termination notes: F2 stopped after Q6 (second consecutive query with no new direct evidence for the stop-manifest target). F4 stopped after Q10 (dedicated fleet query dry; adjacent saturation reached in Q9). F1/F3/F5 stopped on saturation (new queries returned dominant repeats of already-captured apps).

Per-family verdicts:

| Family | Verdict | Basis |
|--------|---------|-------|
| 1. Passenger pickup notification / trip details | **STRONG** | Grab, Uber, Bolt, Beat Passenger direct (4+ apps), plus rich adjacent (GetYourGuide, Lugg, DoorDash web, Uber Eats web) |
| 2. Day-of boarding / check-in at a stop | **PARTIAL** | Rider QR boarding direct (Transit, BlaBlaCar); staff check-in adjacent-only (Luma, Partiful); per-stop capacity manifest ABSENT; school-bus & FlixBus agent-side absent |
| 3. Driver run sheet / stop list | **STRONG** | DoorDash Dasher deep coverage + Apple/Google Maps stop lists + Grab multi-stop; caveat: only one true gig-driver app on Mobbin |
| 4. Dispatcher attention/exception queue | **PARTIAL (adjacent-only)** | Zendesk, Navan, Fiverr, Stripe, Programa, Etsy ops queues; fleet consoles (Onfleet/Samsara/Motive/Bringg) confirmed absent |
| 5. Capacity enforcement UI | **STRONG** | 10 apps: Eventbrite, Facebook Local, eBay, Airbnb, Viator, Ticketmaster, Grab, Booking.com, Shopee, Kakao T, Transit |
