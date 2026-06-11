# BY-FLOW Raw Harvest — Rooming / Accommodation Ops
Job: A conference ops manager allocates hundreds of delegates into hotel rooms across multiple hotels — dates, room types, shared rooms, room-block inventory, change/cancel with downstream notifications, delegate confirmations, per-hotel rooming-list exports.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## A. BOOKING A ROOM (delegate-facing analogs)

### F1 — Hotel booking, search to confirmation (Expedia, web)
- **Apps observed:** Expedia — https://mobbin.com/flows/0bc816fd-c964-40dc-95db-81486a00f0fc
- **Flow as observed:**
  1. Results list with left filter rail ("Filter by": "Breakfast included", "Kitchen", "Pet friendly"), sort "Price: low to high", per-card "Fully refundable" / "Reserve now, pay later" green text, strikethrough price + "20% off" pill, "includes taxes & fees".
  2. Property Rooms tab: room cards ("Room, 1 Queen Bed, Non Smoking", "Sleeps 2", "Free breakfast") each with a Cancellation policy radio group: "Non-Refundable +$0" vs "Fully refundable before Jun 30 +$4".
  3. "Your payment options" modal: two columns — "Pay now" vs "Pay when you stay" ("You will not be charged until your stay… Pay the property directly in their preferred currency (USD)"); buttons "Pay now" / "Pay at property".
  4. Checkout: "Reservation card details — Safe, secure transactions. Your personal information is protected." Note: "Reserve now, pay later — We only need your payment details to secure your reservation."
  5. "Protect your stay" insurance upsell with "Recommended" tag; "Important information" lists property cancellation fee rules; CTA "Complete Booking".
  6. Confirmation: check-in/check-out times, room summary, "You'll earn $1.57 in OneKeyCash after this trip. You're going places!", QR code "Take our app on your travels".
- **Problem solved:** End-to-end self-serve room booking with policy choice priced as a delta.
- **Sad paths observed:** Cancellation-fee disclosure before booking ("Cancellations or changes made after 3:00pm (property local time)… subject to a property fee equal to 100% of the total amount paid").
- **Microcopy worth stealing:** "Fully refundable before [date]"; "Reserve now, pay later"; "includes taxes & fees"; "We have 3 left" scarcity tag on room cards.
- **A11y/notes:** Cancellation policy as priced radio options (+$0 / +$4) is the cleanest model for refundable-vs-not tradeoffs. Expedia also surfaces dedicated "Accessible (Hearing)" / "Accessible, Bathtub, Roll-in Shower" room types as first-class room cards (see F2 sibling flow).

### F2 — Room-type chooser with accessibility variants (Expedia, web)
- **Apps observed:** Expedia — https://mobbin.com/flows/e87f6f40-6e2b-4f5a-8bba-26db2fb878cd
- **Flow as observed:**
  1. "Choose your room" header with Check-in / Check-out / Travelers fields inline.
  2. "Price is typical" indicator: "The nightly rate for the lowest priced room matching your search is within your typical $283–$346 range".
  3. Filter chips "All rooms / 1 bed / 2 beds"; "Showing 12 of 12 rooms"; cards include "Room, 1 King Bed, Accessible (Hearing)" and "Room, 1 King Bed, Accessible, Bathtub (Mobility & Hearing, Roll-in Shower)".
  4. Skeleton loading state shown when dates change.
  5. Payment options modal identical to F1.
- **Problem solved:** Pick a room type within a property, with accessibility needs as room-type variants, not buried settings.
- **Sad paths observed:** Skeleton/empty placeholders while re-querying rooms on date change.
- **Microcopy worth stealing:** "Price is typical"; "Often booked for long stays" card banner.
- **A11y/notes:** Accessible room variants named in plain language in the card title — directly reusable for rooming (e.g., "Accessible room" as a room-type attribute, not a note).

### F3 — Three-step checkout, booking for someone else (Booking.com, web)
- **Apps observed:** Booking.com — https://mobbin.com/flows/2cc6d54f-cb9a-43ef-9985-735fa38a6014
- **Flow as observed:**
  1. Property page with availability table: room types as rows ("Economy Class Pod in 6 Bed Mixed Room" / "…Female Room"), columns Sleeps / Price / Your Choices / Select Beds; choices column lists "Free cancellation before June 28" and "10% Genius discount applied".
  2. Hover summary card: "Total length of stay: 2 nights… Great choice! Just 2 minutes to finish your booking."
  3. Step 2 "Enter your details": "Almost done! Just fill in the * required info"; radio "Who are you booking for?" — "I'm the main guest" / "I'm booking for someone else"; field "Full Guest Name".
  4. Sidebar: "Your price summary" with Genius Discount line; "Your payment schedule — The property will charge you a prepayment at any time"; "How much will it cost to cancel? Free cancellation until 11:59 PM on Jun 27 / From 12:00 AM on Jun 28: $183.83".
  5. Red urgency box: "Limited supply for your dates: 4 one-star hostels like this are already unavailable on our site".
  6. "Special requests" free-text: "Special requests can't be guaranteed, but the property will do its best to meet your needs."
  7. Step 3 "Final Step" with progress indicator "Your Selection ✓ — Your Details ✓ — 3 Final Step"; "Yes, I want free paperless confirmation (recommended) — We'll text you a link to download our app"; "No address needed for this reservation".
- **Problem solved:** Booking on behalf of another guest with cancellation cost made explicit before payment.
- **Sad paths observed:** Sold-out pressure messaging; explicit cancel-cost table by date threshold; damage deposit line "(Fully refundable) $100".
- **Microcopy worth stealing:** "Who are you booking for? — I'm the main guest / I'm booking for someone else"; "How much will it cost to cancel?"; "Confirmation is immediate".
- **A11y/notes:** The "booking for someone else" radio is the atomic version of EventState's whole job — name on reservation decoupled from account holder.

### F4 — Hotel booking with hard sad paths (Klook, web)
- **Apps observed:** Klook — https://mobbin.com/flows/4bd78a36-4243-4649-965c-dfc478db5351
- **Flow as observed:**
  1. Room list: "Free cancellation until 01/29/2024, 00:00", "Flash sale: Ends in 07:31:49" countdown, "Only 2 room(s) left!" under Book button, "Book more nights, save more".
  2. Checkout banner: "We have less than 5 rooms left! Book now to save your reservation"; Special requests prefilled example "Please allocate a higher floor, thank you!".
  3. Confirm modal: "Check your info — This information can't be changed once submitted" with name fields, then "One moment while we submit your booking…".
  4. Payment page with "Pay within 00:14:23" countdown.
  5. SAD PATH modal: "We noticed some unusual activity on this booking. To protect your account, your transaction was declined and your account might be temporarily restricted from making new payments. Need some help? Please reach out to customer support. [4870290793]" with OK button.
- **Problem solved:** High-urgency consumer booking with inventory scarcity surfaced at every step.
- **Sad paths observed:** Payment declined modal with reference code; booking-hold countdown timer.
- **Microcopy worth stealing:** "This information can't be changed once submitted"; "Pay within 14:23"; error includes a support reference code in brackets.
- **A11y/notes:** Reference-code-in-error is a steal for ops: every failed delegate action should emit a quotable ID.

### F5 — Corporate stay search with policy context (TravelPerk, web)
- **Apps observed:** TravelPerk — https://mobbin.com/flows/1fcf6a11-c009-4158-99b8-ec567a61af85
- **Flow as observed:**
  1. Trip itinerary canvas ("Trip-ID: 27039972") with inline prompts "Add a place to stay in New York — Search stays" between flight segments; "Total price of trip $905.69"; "You won't be charged yet".
  2. Hotel detail: "Add as Company Favorite" button; Check-in "From: 15:00" / Check-out "Before: 11:00" badges.
  3. "Useful information" block: "Upon check-in photo identification and credit card is required… The name on the credit card used at check-in to pay for incidentals must be the primary name on the guest room reservation."
- **Problem solved:** Assemble a multi-segment business trip with stays attached to the trip object, not standalone.
- **Sad paths observed:** None in flow; policy text warns of check-in ID mismatch risk.
- **Microcopy worth stealing:** "Add as Company Favorite"; "You won't be charged yet".
- **A11y/notes:** Trip-scoped accommodation (stay belongs to trip/event) mirrors EventState's conference-scoped rooming.

---

## B. MODIFYING A RESERVATION

### F6 — Date change with per-night prices in calendar (IHG Hotels & Rewards, iOS)
- **Apps observed:** IHG — https://mobbin.com/flows/583021d8-d0d6-4ba2-a3c0-6b1ad63538f9
- **Flow as observed:**
  1. "Select a Room" with chips "1 bed / 2 beds / Suite / Accessible" and "View price in points" toggle.
  2. "Select new dates" calendar: every day shows its nightly price (287, 291, 368…); selected range highlighted; "Stay duration: − 2 Nights +" stepper; footer "Rooms from 329 USD/night Excludes Taxes & Fees" + Continue.
  3. Rate selection: "Book Now, Pay Later — Free cancellation 3 days prior to arrival" vs "Member Exclusive Best Flexible Rate".
- **Problem solved:** Change stay dates while seeing cost consequences per night before committing.
- **Sad paths observed:** None visible.
- **Microcopy worth stealing:** "Free cancellation 3 days prior to arrival"; stay-duration stepper as alternative to two date taps.
- **A11y/notes:** "Accessible" as a top-level room filter chip.

### F7 — Modify with explicit change diff (Marriott Bonvoy, iOS)
- **Apps observed:** Marriott Bonvoy — https://mobbin.com/flows/4d947b98-71d1-4030-97e6-dd5daf6d0d3e
- **Flow as observed:**
  1. Reservation Details lists "Not Guaranteed: Rollaway Bed, Foam Pillows"; section "Modifying Your Reservation — Any change in the length or dates of a reservation may result in a rate change."; actions "Cancel Reservation / Modify Reservation / Book Another Room".
  2. Date picker with "My dates are flexible" checkbox; CTA "Continue with 1 Night".
  3. "Confirm Changes" screen: stay info, then DATES block showing "Jul 16–17, 1 Night" and a flagged "⚠ DATE CHANGE — Jul 18–19, 1 Night" diff row; "Hotel Messages: Rollaway beds are only allowed in Deluxe Corner Pool View rooms at an additional charge."; cancellation policy restated with fee amount; CTA "Book Now 1,061,291 IDR".
- **Problem solved:** Date modification with an explicit old→new diff and re-stated cancellation terms before commit.
- **Sad paths observed:** Rate-change warning; preference "Not Guaranteed" list (honesty about what the hotel may not deliver).
- **Microcopy worth stealing:** "Any change in the length or dates of a reservation may result in a rate change."; "DATE CHANGE" labeled diff; "Not Guaranteed:" list.
- **A11y/notes:** The change-diff ("date change" row flagged with icon) is the canonical pattern for EventState's change-confirmation step before notifying hotel + delegate.

### F8 — Date change with success state (Booking.com, iOS)
- **Apps observed:** Booking.com — https://mobbin.com/flows/e67add4a-00b7-42fa-9598-ec93e0b4f721
- **Flow as observed:**
  1. Trip details card: hotel row "Confirmed" in green; actions "Track your requests", "Get a better room for just US$11.38", "Request invoice".
  2. "Change dates" calendar (current dates pre-highlighted, new range tappable) → "Check availability".
  3. Success screen: "Your booking has been successfully updated — We sent a confirmation email to alexsmith.mobbin@gmail.com – enjoy your stay!" + "View booking".
- **Problem solved:** Self-serve date change with availability check and email confirmation of the change.
- **Sad paths observed:** None shown (availability check step implies a failure branch).
- **Microcopy worth stealing:** "Your booking has been successfully updated. We sent a confirmation email to…"; "Track your requests".
- **A11y/notes:** Change → automatic downstream email is exactly EventState's "change with downstream notifications" requirement, delegate-side.

### F9 — Modify hub: contact / guests / dates / rooms (Trip.com, iOS)
- **Apps observed:** Trip.com — https://mobbin.com/flows/70684c67-9353-48bc-b9cf-0b734417e78f
- **Flow as observed:**
  1. Booking detail "Confirmed" → Options sheet: "Modify Booking / E-receipt / Confirmation Email / Book Again / Review to Earn Trip Coins".
  2. "Modify" sheet groups four modifiable facets, each with current value + Modify link: "Contact Info / Guests / Dates / Rooms".
  3. "Modify Room Type/Dates" screen: "ⓘ Modification requests need to be confirmed. The hotel adjusts room rates based on demand. The final prices after modification are displayed on this page." Room list re-shown ("Please recheck your selection") with updated prices.
- **Problem solved:** One hub for every mutable attribute of a booking, with async hotel confirmation made explicit.
- **Sad paths observed:** "Modification requests need to be confirmed" — change is a request, not an instant write.
- **Microcopy worth stealing:** "Modification requests need to be confirmed"; facet list Contact Info / Guests / Dates / Rooms.
- **A11y/notes:** Request-then-confirm model matches multi-hotel ops reality (hotel must ack changes). The four-facet modify hub maps 1:1 to a delegate booking record.

---

## C. CANCELLATION & REFUNDS (sad paths first-class)

### F10 — Cancel with reason + estimated refund (Trip.com, iOS)
- **Apps observed:** Trip.com — https://mobbin.com/flows/c923674b-0cb0-41c0-882f-3542c0f6e156
- **Flow as observed:**
  1. Booking detail: "Free Cancellation - Before 12:00, Mar 16, 2025 (Hotel's local time)"; buttons "Cancel Booking" / "Options (5)".
  2. Cancellation screen, blue banner: "This booking can be canceled for free"; required radio list "Reason for cancellation": "My travel plans have changed / Booked the wrong date or destination / Unable to travel due to illness / Unable to travel due to transport delays or cancellation / Hotel agreed to refund / Issue with hotel / Unable to check in at property / Found a lower price"; footer "Estimated refund $18.49 ⓘ" + Submit.
  3. Post-cancel state: header "Canceled", card "Processing Refund $18.49 — View Details", CTA flips to "Book Again".
- **Problem solved:** Cancellation with structured reason capture and refund expectation set before submit.
- **Sad paths observed:** Entire flow is the sad path; "Processing Refund" intermediate status.
- **Microcopy worth stealing:** "This booking can be canceled for free"; "Estimated refund $X"; reason taxonomy; "Processing Refund" as a status.
- **A11y/notes:** Reason taxonomy is reusable verbatim for delegate cancellations (illness, plans changed, found alternative) and feeds ops analytics.

### F11 — Cancel for Any Reason + refund timeline (Tripadvisor, iOS)
- **Apps observed:** Tripadvisor — https://mobbin.com/flows/71981c94-f439-4e95-b157-426d70863431
- **Flow as observed:**
  1. Booking details: "Cancel for Any Reason — Cancel your hotel up until the scheduled check-in time for any reason, and get a full refund of $61…"; links "Cancel For Any Reason / Change reservation / Contact support".
  2. Success modal: "✓ Cancellation successful — An email confirmation will be sent to alexsmith.mobbin@gmail.com. Your refund of $61.08 will be processed in 7-10 business days." Card shows "Cancelled" pill on hotel.
  3. Hotels list, "Past" tab: card with "Cancelled" pill + "Confirmation: PKZ6WVVXQRQC" still visible.
- **Problem solved:** Cancellation with concrete refund SLA and durable record of the cancelled stay.
- **Sad paths observed:** Cancelled state retained in history with confirmation code (not deleted).
- **Microcopy worth stealing:** "Your refund of $X will be processed in 7-10 business days."; "Cancelled" pill.
- **A11y/notes:** Keep cancelled bookings visible with their confirmation numbers — ops will need the paper trail.

### F12 — Cancellation policy as a timeline (Vrbo, iOS)
- **Apps observed:** Vrbo — https://mobbin.com/flows/b44f3218-ce6b-44ed-8df0-223e6e84485f
- **Flow as observed:**
  1. Unit options: cancellation policy radios "Non-Refundable +$0" / "Fully refundable before Oct 30 +$14"; "We have 4 left".
  2. "Cancellation policies" sheet, tabs "Non-refundable / Free cancellation"; vertical timeline: "Today — Full refund → Oct 30 — Partial refund → Check-in"; text blocks "Before Oct 30: Full refund — Cancel your reservation before Oct 30 at 06:00 PM, and you'll get a full refund. Times are based on the property's local time." / "After Oct 30: Partial refund — you'll be charged for the first night of your stay plus taxes and fees."
- **Problem solved:** Make refund cliffs legible as a timeline instead of legalese.
- **Sad paths observed:** "No refund" timeline variant for non-refundable tab.
- **Microcopy worth stealing:** Timeline labels "Today / Full refund / Partial refund / Check-in"; "Times are based on the property's local time."
- **A11y/notes:** The refund-cliff timeline is the best visualization for delegate-facing cancellation terms tied to a room block's cutoff date.

### F13 — Corporate cancel with confirm summary (Navan, iOS)
- **Apps observed:** Navan — https://mobbin.com/flows/187c952e-572b-48d6-8ae7-08d9f14752ce
- **Flow as observed:**
  1. Trip detail ("Reserved for Jane Doe", Payment "Paid", "Business" badge): actions "Cancel hotel / Call hotel / Rideshare / Navigate / Receipt".
  2. "Change / cancel hotel" → "Confirm cancellation" modal: "Original total price $301.42 / Amount paid $301.42 / ✓ Fully refundable until Oct 21, 2024, 4:00 PM"; expandable "Change of plans"; CTA "Confirm cancellation".
  3. Result: reservation page overlaid with banner "SUCCESSFULLY CANCELED", all fields (RESERVATION, BOOKING ID, CHECK-IN/OUT, ROOM, RESERVED FOR) retained in muted state.
- **Problem solved:** Cancel a booking made for someone else with money-at-stake summary up front.
- **Sad paths observed:** Whole flow; canceled record retained with full detail.
- **Microcopy worth stealing:** "Fully refundable until [date, time]"; "SUCCESSFULLY CANCELED" stamp over a preserved record.
- **A11y/notes:** "RESERVED FOR Jane Doe" field shows arranger-vs-guest separation in a cancel context.

### F14 — Refund rules before cancel (American Airlines, iOS)
- **Apps observed:** American Airlines — https://mobbin.com/flows/339b5c1d-1fdf-446d-903a-2d62adffe299 (cancel), https://mobbin.com/flows/63e2f645-0315-4c35-bf51-9a07aa1aefda (manage trip)
- **Flow as observed:**
  1. Manage-trip sheet: "Change trip / Seats / Add bags / Manage trip / Request wheelchair / Add infant in lap / Share trip / Cancel trip".
  2. "Cancel trip for a refund?" page, info box: "You can cancel for all passengers within 48 hours 9 minutes for a refund."; "Refund rules" text ("You have up to 24 hours from the time of ticket purchase to receive a full refund if you booked at least 2 days before departure… If you don't want to cancel for all passengers, please call Reservations."); buttons "Cancel for a Refund" / "Go back".
- **Problem solved:** Set refund expectations and group-cancel constraints before the destructive action.
- **Sad paths observed:** Partial-group cancellation is an explicit limitation routed to support.
- **Microcopy worth stealing:** "You can cancel for all passengers within 48 hours 9 minutes for a refund."; "If you don't want to cancel for all passengers, please call Reservations."
- **A11y/notes:** Group-vs-individual cancellation scoping is a core rooming edge case (cancel one roommate vs the whole room).

---

## D. BOOKING ON BEHALF OF OTHERS (arranger mode)

### F15 — Arranger mode with persistent banner (KAYAK for Business, web)
- **Apps observed:** KAYAK — https://mobbin.com/flows/c90ce0c5-2eb0-4c3d-91ff-d7695b190c71 and https://mobbin.com/flows/5da98a69-4aad-4be8-9f03-4e397efcb90a
- **Flow as observed:**
  1. Search form toggle: "Book for yourself" / "Book for traveler".
  2. Entering traveler mode swaps the account chip to "Booking for John" and pins a full-width banner: "You are searching on behalf of John Smith" with an "Exit mode" button on every screen.
  3. Results show "Your flight travel policy" panel (Max allowed price: $500, max cabin class, when to book) with note "Remember to request approval if the flight is out of policy"; fare cells carry per-rule green-check policy badges.
  4. Cart drawer: "You are viewing John Smith's cart" + Exit mode; "Continue to checkout".
- **Problem solved:** Prevents the #1 arranger error — booking under the wrong identity — via an unmissable mode.
- **Sad paths observed:** "Not available for this result" disabled fare cells; out-of-policy approval reminder.
- **Microcopy worth stealing:** "You are searching on behalf of John Smith"; "Exit mode"; "Remember to request approval if the flight is out of policy".
- **A11y/notes:** Mode-banner + chip swap is THE pattern for EventState ops acting as a delegate (e.g., editing a delegate's room).

### F16 — Delegated booking permissions (Airbnb, web)
- **Apps observed:** Airbnb — https://mobbin.com/flows/0a92f2db-ffa7-4de7-8ac2-bbb77581c9d4
- **Flow as observed:**
  1. Account settings "Travel for work": work email on file; "Booking permissions — Add someone who can book work trips on your behalf. Manage".
  2. "Booking permissions" page: verification checklist with mixed states ("Your phone number — Verified ✓", "Your account email — Verify account email ⚠", "Active work email — Verified", "Your profile photo — Verified") and banner "You need to complete 1 more step to verify your profile… Once your profile is verified, you can allow people to book and manage trips on your behalf."
- **Problem solved:** Consent + identity verification before delegation rights are granted.
- **Sad paths observed:** Blocked state until verification completes.
- **Microcopy worth stealing:** "Add someone who can book work trips on your behalf."; "You need to complete 1 more step to verify your profile."
- **A11y/notes:** Checklist-gated permission is reusable for delegate self-service unlock (e.g., confirm email before room self-selection).

### F17 — Traveler roster managed by an arranger (Navan, web)
- **Apps observed:** Navan — https://mobbin.com/flows/74dfa8ee-978c-4b5a-bff5-2ba7987c2538, https://mobbin.com/flows/284cd68f-0984-4831-b4ad-27135e729875
- **Flow as observed:**
  1. "Travel planner": left rail "Trips by traveler" (you + people you book for), per-traveler tabs "Upcoming / Past / Canceled"; empty state "No travelers added — Add traveler".
  2. Modal "Add traveler you book for": tabs "Add new traveler" / "Add existing traveler"; fields First/Middle/Last, Email "Used for booking-related notifications"; toggle "Send traveler an invite — Email this traveler an invite so they can access their Navan account and travel details."
  3. Alternate add-new-traveler modal: "These details must match your government-issued ID for ticketing purposes"; DOB, gender, "Add passport, preferences, and loyalty programs".
  4. Success toast: "Traveler added — To save booking time, you can add more details to [name]'s profile (like loyalty programs or passport information) or start booking now." Search bar then shows "Traveler: John Smith Jr + Jane Doe".
- **Problem solved:** Maintain a roster of people you book for, with optional self-service invite per person.
- **Sad paths observed:** None visible.
- **Microcopy worth stealing:** "Add traveler you book for"; "Used for booking-related notifications"; "Send traveler an invite"; "These details must match your government-issued ID".
- **A11y/notes:** Trips-by-traveler sidebar = delegate-centric ops view; the invite toggle = EventState's "delegate confirmation" hook.

---

## E. ASSIGNING PEOPLE TO SLOTS (closest rooming-grid analogs)

### F18 — Shift grid: assign person × day (Deputy, web)
- **Apps observed:** Deputy — https://mobbin.com/flows/857e1417-10e1-4a5b-9b4b-8a4a8a6fa6a5, https://mobbin.com/flows/6a3f27e2-9c1c-4dbd-a527-d26366020606
- **Flow as observed:**
  1. Schedule grid: rows = areas/roles ("Manager", "Admin", "Support", "Cleaner", "Sales"), columns = days; left rail lists people with running totals ("Alex Smith 0h · $0.00"); every empty cell is a "+" target; legend across footer: "0 empty / 0 unpublished / 0 published / 0 require confirmation / 0 open shifts / 0 warnings / 0 leave approved / 0 leave pending / 0 unavailable".
  2. Click cell → shift popover: person picker, date, time range "09:00 AM — 05:00 PM", area "Manager", "30 mins of Meal Break (unpaid)", "Add shift note", running "Total 7h 30m · $150.00", Save.
  3. Overflow menu on a shift: "Repeat for tomorrow / Repeat for rest of the week / Repeat for specific days / Repeat for set pattern / Split shift / Find replacement / View Alex's profile / View shift history / Delete shift".
  4. Drafts render as outlined cards; top-right "Publish 4 shifts" → cards turn green "published"; one shows an "OPEN" badge (unassigned).
  5. Header chip changes "Publish 12 shifts" → "All shifts published".
- **Problem solved:** Allocate people into slots on a 2-D grid with draft→publish lifecycle and per-cell repeat/copy tooling.
- **Sad paths observed:** "require confirmation", "warnings", "leave pending", "unavailable" as first-class grid states; OPEN (unfilled) shift badge.
- **Microcopy worth stealing:** "Publish N shifts"; "Find replacement"; "Repeat for rest of the week"; status legend vocabulary.
- **A11y/notes:** Swap rows for room/room-type and columns for nights and this IS the rooming grid: draft allocations, publish (notify), open slots = unassigned beds, "find replacement" = roommate swap.

### F19 — Assign existing person to a slot + conflict warnings (7shifts, web)
- **Apps observed:** 7shifts — https://mobbin.com/flows/0598f4b9-3db5-4fae-96bb-c6f73711fe61, https://mobbin.com/flows/877b412b-2c6a-4acc-930e-1ade19f9f69f
- **Flow as observed:**
  1. Week grid grouped by department ("Back of House / Cook / Owner / Finance / Cashier") each with an "Open Shifts" row and "+ Add employee" rows; "Add employees" menu: "Create new employees / Assign existing employees".
  2. "Employee Assignment" modal: checkbox list of people with "Assign roles" dropdown per person; "1 employees assigned"; Save.
  3. Grid shows warnings inline: header chips "2 Conflicts / 2 Overtime / Fix warnings"; cells show "TIME OFF" and "5h Overtime" flags; person rows show red badge totals ("45.00 Hrs · $950.00 / 5h Total OT").
  4. Dragging a person row/shift shows ghost placement; "Publish schedule" button gated until ready; "Import first schedule" offered at empty state.
- **Problem solved:** Assign named people into role slots while surfacing conflicts (double-booking, overtime, time off) at assignment time.
- **Sad paths observed:** Conflict and overtime chips with "Fix warnings" link; unassignable (time-off) cells visibly blocked.
- **Microcopy worth stealing:** "2 Conflicts · 1 Overtime · Fix warnings"; "Assign existing employees" vs "Create new employees".
- **A11y/notes:** Conflict chips at the grid header = the model for rooming clashes (delegate double-assigned, dates outside block, gender-mix rule violations).

### F20 — Seat map assignment per passenger (Booking.com flights, iOS)
- **Apps observed:** Booking.com — https://mobbin.com/flows/72cb6bf2-bf63-476e-b11d-ea8353685c64
- **Flow as observed:**
  1. Stepper "Select your seats" (step 3 of 5); segment card "No seats selected — Select seats from $18.31".
  2. Seat map with legend "Available seat ($18.31 – $46.31) / Unavailable seat / Selected seat"; tapping a seat opens bottom sheet "Seat 3C — $36.31 — Assign seat to: Traveler 1 (adult)" with "Assign" button.
  3. Completion sheet: "All set! All passengers have a seat for this flight." → Next.
- **Problem solved:** Map a named traveler onto a physical slot with price, and confirm group completeness.
- **Sad paths observed:** Unavailable seats visually crossed; group incompleteness blocks progress.
- **Microcopy worth stealing:** "Assign seat to: Traveler 1 (adult)"; "All set! All passengers have a seat for this flight."
- **A11y/notes:** "All N people have a slot" completeness check transfers directly to "every delegate has a bed" validation.

### F21 — Per-person, per-segment seat picker with skip path (Hopper, iOS; American Airlines, iOS; Shopee trains, iOS)
- **Apps observed:** Hopper — https://mobbin.com/flows/bb3a8fc0-90c4-4dba-a6a8-70fb9b09c178; American Airlines — https://mobbin.com/flows/2fff83f0-ddc8-4919-9803-d010fd726ac2; Shopee — https://mobbin.com/flows/4b244753-0033-45b5-9e5f-3272646fc4a2
- **Flow as observed:**
  1. Hopper: countdown header "14:53 left to finish your booking!"; intro "Your flight comes with free seat selection!… If you decide to skip this step, seats will be assigned at check-in."; per-segment "Choose" buttons; CTA "Continue without Seats"; seat map header has two dropdowns: segment ("SIN → JFK Outbound") and person ("Judy Smith — 35H"); "Seat Legend" (Standard Seat SGD 0.00 / Unavailable); per-segment "Next flight"; completed list shows green checks with chosen seats "35H"/"36B" and "Edit"; CTA becomes "Continue to Payment".
  2. American Airlines: trip hub lists "Choose seats / Cancel trip / Add bags / Additional services (Wheelchair, infant, service animal, pet and special assistance) / Cost summary"; seat map with $ seats and "Seat: 31F · $11 — Available seat — Select seat" footer; "Review and pay — Total: $10.87".
  3. Shopee (train): "Select Departure Seat" with "Time Remaining 2m59s"; passenger chip "Sam Lee / EKO-18B"; legend "Active / Selected / Available / Unavailable"; "NEXT TRAIN" advances segments.
- **Problem solved:** Optional, per-person slot choice with a graceful default ("assigned at check-in") and a time-boxed hold.
- **Sad paths observed:** Booking-hold countdown; skip path keeps the booking alive without seats.
- **Microcopy worth stealing:** "If you decide to skip this step, seats will be assigned at check-in."; "Continue without Seats"; "14:53 left to finish your booking!"
- **A11y/notes:** The skip-with-default is the model for delegate room preference: choose your roommate/bed or be auto-assigned by ops.

---

## F. GROUP / EVENT TRAVEL OPS (nearest whole-job analogs)

### F22 — Group travel events with participant roster (Navan, web)
- **Apps observed:** Navan — https://mobbin.com/flows/1a36de0c-77a1-4014-8df7-e24330d95f22, https://mobbin.com/flows/9dab22ea-f046-4318-a9c1-c367bd4da77a, https://mobbin.com/flows/ee7e9df9-9df1-43f2-b543-3d4f5bf20382
- **Flow as observed:**
  1. "Group travel" list: event cards "JSMobbin Jakarta — In progress — Jakarta, Indonesia — Jul 29–31, 2024 — In 56 days — 0/2 booked [progress bar] — $0 actual / $2,606 estimated"; filters "Offsite dates / Status"; "+ Create group event".
  2. Event page with 3-step checklist: "1 Configure event settings → 2 Add participants → 3 Send invitations (you can still edit event details and add new participants after)"; tabs "Event settings / Participants"; Event details form (name, location, start/end date-times).
  3. "Add participants" modal: paste emails free-form ("0 / 500 added"); guest chips "(guest)"; checkbox row "Newly added participants allowed to book: ☑ Flight ☑ Hotel ☐ Car ☐ Trains — Allowed booking types can be changed for individuals in the participants list."; status "Adding participants, it might take a minute or two".
  4. Participants tab table: Participant / Departing from (location input) / Allowed bookings (icons) / Status ("Not invited yet") / Estimated cost ($334 each, "Total estimated cost $668"); buttons "Download travel manifest" and "Add participants"; "Send invites".
  5. "Manager dashboard" (Travel Manager app): KPIs "Travel spend / Bookings", tabs "Recent Bookings / Out-of-policy / Active Travelers / Upcoming Bookings"; empty-state "Nice, no policy offenders in this timeframe!"
- **Problem solved:** An ops manager creates a travel event, bulk-adds hundreds of participants, controls what each may book, invites them to self-book, and tracks booked-vs-total and spend.
- **Sad paths observed:** "Not invited yet" status; 500-participant cap; out-of-policy tab.
- **Microcopy worth stealing:** "0/2 booked"; "Download travel manifest"; "Not invited yet"; "Newly added participants allowed to book…"; "Nice, no policy offenders in this timeframe!"
- **A11y/notes:** This is the closest end-to-end analog to EventState rooming ops: event → roster → permissions → invite → booked-progress tracking. "Travel manifest" download ≈ rooming-list export.

### F23 — Group hotel quotes & room-block bidding (Expedia Groups, web)
- **Apps observed:** Expedia — https://mobbin.com/flows/8c7e207c-f722-4c64-9190-d2591cf1eb2c, https://mobbin.com/flows/556d44a2-58b4-43f4-af98-5ed45ac0dc03
- **Flow as observed:**
  1. Landing: "Get group hotel rates for Sports Teams, Weddings, Meetings or Any Event!"; quote form: Destination, Check-in/out, "GROUP TYPE" (Business Meeting), "# ROOMS PER NIGHT" (10), "IDEAL STAR RATING" (3-5 Star), "IDEAL NIGHTLY BUDGET" slider ($250–$339), "WHERE SHOULD WE SEND QUOTES?" name/email → Continue.
  2. "Success!" follow-up: event/group name, "WHO WOULD YOU LIKE TO SEE OFFERS FROM?" (All hotels matching my request), "ROOM TYPE(S): 2 Double Beds (1-2 People) + Edit details", "MEETING/BANQUET SPACE REQUIRED? YES" with "Add Meeting Space" sub-form (type Banquet, No. of People, Min. Room Size, day/time, checkboxes Coffee/Tea Setup, Projection Equipment, WiFi…).
  3. Request dashboard ("My Details"): Reservation ID, Status: Active, Event Name, Agent Assigned (name, email, phone), itinerary, "Rooms per night" table per date (Jul 01: 9, Jul 02: 9, Jul 03: 7, Jul 04: 7), Star Rating Target, Budget Range, Space Requirements diagram; green box "Your custom event page (instant booking) — specially negotiated group rates that you can send to your guests without setting up a group hotel block" with link Groups.Expedia.com/EventPage… + "Customize This Page / Invite Attendees"; side buttons "Stop Hotel Bidding / Low Price Guarantee / Modify Request".
  4. "Hotel Offers" list: filter rail "Status: New (1) / No Action Yet / Contacted Hotels / Declined Bids / Unavailable Hotels / No Bid Yet (192) / Requested (32)"; bid cards show direct hotel bids ("Direct bid from the Holiday Inn Express… Offered: 06/03/2024 10:59:40 PM — Weekends $129 / Weekdays $179 USD per night + 12.75% taxes — Rate includes breakfast. Each room bed type can be arranged individually later…") with "Contact Hotel $179 / Decline Bid / Instant Book $108"; instructions strip "Request hotels to quote / Contact the hotels / Don't love the offer? Use the Decline Bid button…".
  5. "Stop Hotel Bidding" modal: required reason radios "YES, WE SELECTED THE [hotel name] / YES, WE DO NOT NEED THE ROOMS ANYMORE / YES, WE ARE SUBMITTING A NEW REQUEST / YES, [other reason]" → "Stop Hotel Bidding" / "No, nevermind". Closed request page: "Closed Requests" with "Re-Activate / Copy Request" and bid tally "Hotel Bids: 4 (0 Booked, No Availability: 0, Contacted: 0, Declined: 0)".
- **Problem solved:** Source room blocks across many hotels via RFP/bidding, with per-night room counts and a shareable attendee booking page.
- **Sad paths observed:** Decline-bid action; "No Availability" hotel status; structured stop-bidding reasons; closed/reactivate lifecycle.
- **Microcopy worth stealing:** "Rooms per night"; "Each room bed type can be arranged individually later"; "Get competing quotes fast as hotels bid to get your group business."; "Invite Attendees"; "Stop Hotel Bidding".
- **A11y/notes:** The ONLY observed flow that treats room-block per-night inventory as a first-class table. Steal the per-date rooms row and the attendee event page concept for delegate self-booking against a block.

### F24 — Property-side inventory calendar with bulk edit (Booking.com extranet, web)
- **Apps observed:** Booking.com — https://mobbin.com/flows/44ee9c12-3cbc-468c-97e5-304d93d332df, https://mobbin.com/flows/e272c36a-cb45-49fb-8562-7f7c341a77e1
- **Flow as observed:**
  1. "Calendar" for a room type ("Two-Bedroom Apartment, Room ID: 1022082401"): rows "Room status (Bookable [green] / Multiple blockers [red])", "Rooms to Sell" (count per date), "Net Booked", rate rows (Standard/Non-refundable per date); tooltip "Want to change prices, restrictions, or rooms to sell for a long date range all at once? Try the bulk edit tool".
  2. Bulk edit panel: date range, "Which days of the week do you want to apply changes to?" (Mon–Sun checkboxes), tabs per room type, accordions "Rooms to Sell — Update the number of rooms to sell for this room type / Prices / Room Status — Open or close this room (radio Open Room / Close Room) / Restrictions" → "Save changes".
  3. After close: row turns red "Closed" across range.
  4. Analytics ("Demand for accommodation"): charts "Length of stay", "Traveler type", "Cancellation policy" mix (Free cancellation vs Non-refundable vs Partially refundable bars).
- **Problem solved:** Manage sellable room inventory per room type per night, in bulk, with open/close states.
- **Sad paths observed:** "Multiple blockers" red status; warning banners ("Non-refundable rates are still unavailable…").
- **Microcopy worth stealing:** "Rooms to Sell"; "Open or close this room"; "Which days of the week do you want to apply changes to?"
- **A11y/notes:** Rooms-to-sell-per-night grid is the hotel-side mirror of an EventState room block; bulk edit by weekday is a strong tool for block shoulder-night management.

### F25 — Event ticket inventory + team + export (Posh, web)
- **Apps observed:** Posh — https://mobbin.com/flows/c5785edd-2da5-4b84-8df3-54ba118c4d07
- **Flow as observed:**
  1. Event overview: tickets-per-week chart, recent orders feed.
  2. Tickets tab: "Ticket Types" table — Ticket Name / Status ("On Sale") / Gross Price / Display Price / "Sold 3 / 100" / Start Sale / End Sale; "+ Add Ticket Type"; "Ticket Groups".
  3. Team tab: members table with Access Level pills (Owner / Admin), Last Login.
  4. Settings: "Export Event Report" and "Request Full Event Refund" buttons; "Custom Checkout Fields — Add customized fields to collect additional data from attendees".
- **Problem solved:** Capacity-capped inventory ("Sold 3/100") with sale windows and report export, run by a permissioned team.
- **Sad paths observed:** None visible.
- **Microcopy worth stealing:** "Sold 3 / 100"; "Export Event Report"; "Custom Checkout Fields".
- **A11y/notes:** Sold/cap counter is the same primitive as rooms-consumed/block-size.

---

## G. CONFIRMATIONS, ITINERARIES, SHARING

### F26 — Check-in voucher confirmation (Trip.com, iOS)
- **Apps observed:** Trip.com — https://mobbin.com/flows/3258b05e-c036-4184-8b99-637166dd19e1, https://mobbin.com/flows/f7fc0531-eb0c-4d06-b71e-f1c591ca46c0
- **Flow as observed:**
  1. My Trips card → booking "Confirmed — Booking No. 1367831456315310 / PIN 3196"; "View your booking confirmation email"; badges "We Price Match / Hotel Stay Guarantee"; "Free Cancellation - Before 12:00…"; actions "Message Property / Call Property"; feedback strip "How was your booking experience? Bad / Average / Good".
  2. "Booking confirmation" voucher page: banner "ⓘ Use this or the main guest's name when checking in"; language tabs "English / Vietnamese"; printable card with Confirmation no., PIN, Booking No., property address+phone, Check-in/Check-out, "Rooms 1 / Nights 1", Guest Names, occupancy note ("This room type can accommodate up to 2 guests with a max. of 2 adults"), room amenities, cancellation fee table by local time; footer buttons "Share" / "Email".
- **Problem solved:** A delegate-facing, hotel-acceptable proof-of-booking artifact, localized and shareable.
- **Sad paths observed:** Cancellation fee table includes the non-refundable cliff row.
- **Microcopy worth stealing:** "Use this or the main guest's name when checking in"; PIN alongside booking number; bilingual voucher tabs.
- **A11y/notes:** The voucher (not the email) is the unit delegates show at the front desk — EventState should generate exactly this per delegate, per hotel, with local language toggle.

### F27 — Booking actions sheet incl. PDF/share-with-rights (Booking.com, iOS)
- **Apps observed:** Booking.com — https://mobbin.com/flows/d3a2795e-74d3-49f8-b322-9a0e691eaa04
- **Flow as observed:**
  1. Booking "Actions" list: "Request invoice / Save as PDF / Add to Apple Wallet / Add to phone calendar / Save as image / Share this booking / Share this property"; "Travel safely: Safety Resource Center / Local emergency services".
  2. "Share this booking" sheet: "'Share as PDF' shares a copy of your booking confirmation details with confirmation number and PIN hidden for security. 'Share link to booking' grants modification and cancellation rights to your active booking. Your booking will also be added to their Booking.com account." Buttons "Share as PDF" / "Share link to booking".
- **Problem solved:** Distinguish read-only proof sharing from rights-granting co-management.
- **Sad paths observed:** Security note: PIN hidden in PDF variant.
- **Microcopy worth stealing:** "grants modification and cancellation rights to your active booking"; "with confirmation number and PIN hidden for security".
- **A11y/notes:** Two-tier share (view vs manage) is the exact split between sending a rooming list to a hotel (read) and delegating change rights to a co-organizer.

### F28 — Trip itinerary hubs (Qantas, Tripsy, Expedia, iOS)
- **Apps observed:** Qantas — https://mobbin.com/flows/15868133-041a-45e3-9c61-d211fb6309c8; Tripsy — https://mobbin.com/flows/f590cad8-0f0f-4490-950b-9a96ca0f5b3f, https://mobbin.com/flows/309a90e2-6a51-4fc9-b02e-1e62c0f165b4; Expedia — https://mobbin.com/flows/54b23081-11b3-43a4-a3b7-098297d7e2a9
- **Flow as observed:**
  1. Qantas Trips: "Upcoming / Following" tabs; empty state "No upcoming trips — To check in and manage your booked flights, hotels, and car hire, log in or add your trip manually. Add trip"; per-segment cards with "Consider for your trip: Book a hotel / Hire a car / Get foreign currency".
  2. Tripsy trip: countdown "Starts in 13 days · 3-day trip"; quick actions "New Activity / Flights / Lodgings"; "Automation — Forward all your reservations to my@tripsy.app and let Tripsy organize everything for you"; "Invite Guests — Add frequent guests. They can view, add, edit and remove items, but you're the admin. Share Trip"; day-by-day "Itinerary" rail; map view of lodging + airport.
  3. Expedia Trips: trip card "Current" pill + "Invite" button; trip page sections "Find a place to stay / Get around by car / Find things to do" scoped to trip dates.
- **Problem solved:** One object per trip aggregating stays/flights with collaboration and countdown.
- **Sad paths observed:** Empty-state guidance (add manually / forward emails).
- **Microcopy worth stealing:** "Starts in 13 days"; "They can view, add, edit and remove items, but you're the admin."
- **A11y/notes:** Tripsy's email-forwarding automation is a neat low-friction ingestion idea for delegates' self-booked hotels (book-outside-block capture).

### F29 — Guests on a reservation: add, price diff, roles (Airbnb + Tripsy, iOS)
- **Apps observed:** Airbnb — https://mobbin.com/flows/a95589c8-1b86-4e01-888d-39f611f2505b, https://mobbin.com/flows/a7d2ac7d-8a44-435b-9fe5-bf0628fdc59d; Tripsy — https://mobbin.com/flows/f429033e-3835-4301-a895-430c1a12ed5a
- **Flow as observed:**
  1. Airbnb "What would you like to change about your reservation?": "Change the date or time / Add guests / Remove guests (disabled) / Cancel my reservation".
  2. "Add a guest to the reservation" form: age bracket dropdown ("Adult (age 13+)"), first/last name, email; helper "We'll email your guest the experience's plan and details."; link "Use your contacts list".
  3. "Add more guests" counter variant: "Add guests up to the maximum amount of spots the host allows. Guests you add get emailed the reservation details." — "Add a guest (9 left) − 0 +"; disabled "Review changes" until >0.
  4. "Here's the change to the guests" review: card flips to "2 guests"; "Payment details: Original reservation $50.74 / New reservation $101.47 / Total to pay $50.73 to your original payment method in 5–7 days"; CTA "Change reservation".
  5. Reservation detail: "Your group", "Confirmation code TARADPDT", "Copy invite link / Manage guests / Manage reservation / Get receipt".
  6. Tripsy "Guests" sheet: owner row + "+ Invite Guests"; guest detail with toggle "Traveling Together — Guests that are not traveling together will see the trip on the Friend's list instead of My Trips…".
- **Problem solved:** Add named companions to an existing booking with capacity limits, automatic notification, and price delta review.
- **Sad paths observed:** "Remove guests" disabled when not applicable; capacity ceiling "(9 left)".
- **Microcopy worth stealing:** "Guests you add get emailed the reservation details."; "Here's the change to the guests"; "Traveling Together" toggle.
- **A11y/notes:** This is the roommate-add pattern: capacity-capped, each added person notified, price delta shown. NOTE: no mainstream flow lets a guest *pick* a roommate from a pool — gap (see coverage note).

---

## H. OPS TOOLING: IMPORT, EXPORT, APPROVE, NOTIFY, WAITLIST

### F30 — CSV import wizard with column mapping (Attio, web)
- **Apps observed:** Attio — https://mobbin.com/flows/2c5ec636-6d46-416e-b798-ae09d51881c3
- **Flow as observed:**
  1. Table view "Import / Export" menu: "Export view as CSV / Export view as Excel / Import CSV / Learn about imports and exports".
  2. Wizard steps "1 Upload file → 2 Map columns → 3 Review values → 4 Preview import"; map screen: rows = file columns (First Name, Last Name, Email, Cost Center, Department) with "Select attribute" dropdowns; matched row shows "Team › Email addresses" with a warning glyph; right panel "Data preview… This preview shows only a portion of the column values."
  3. "Generating import preview — Your preview will be ready shortly. If you're ready, you can start the import immediately."
  4. Preview tabs "Companies 3 / People 3" with "+3 will be created / 0 will be updated"; confirm modal "Start import — Are you sure that you want to start running this import?"; rows land in the People table.
- **Problem solved:** Spreadsheet → structured records with mapping, create-vs-update counts, and a final confirm.
- **Sad paths observed:** Unmapped-attribute warning state; preview-before-commit.
- **Microcopy worth stealing:** "3 will be created, 0 will be updated"; step names "Upload file / Map columns / Review values / Preview import".
- **A11y/notes:** Created-vs-updated dry-run count is essential for delegate-list re-imports (idempotent updates).

### F31 — Field mapping with reserved/required attributes (Customer.io, web)
- **Apps observed:** Customer.io — https://mobbin.com/flows/246ac8d9-3fc6-42e1-a04c-aede744f7879
- **Flow as observed:**
  1. "Import CSV" steps "1. Upload CSV ✓ → 2. Map fields → 3. Review"; "Uploading… We're processing your upload. It shouldn't take too much longer…"; "Cancel import" always visible.
  2. Map fields: each column card shows 2 sample rows + checkbox to include + "MAP TO ATTRIBUTE" dropdown with badges "Identifier", "Reserved", "Required"; unchecked column says "This column will be skipped".
  3. Review: green banner "Success! We found 2 new people to add from your CSV. Learn more about data validation."; stat tiles "2 NEW PEOPLE / 0 EXISTING PEOPLE / 2 ID CHANGES / 0 WARNINGS / 0 ERRORS" (errors styled red); optional "Add 2 people to a segment — Create a new manual segment [name prefilled from filename] / Update an existing manual segment"; "Complete import".
- **Problem solved:** Same as F30 plus typed attribute constraints and an error/warning ledger.
- **Sad paths observed:** WARNINGS / ERRORS counters as first-class review tiles.
- **Microcopy worth stealing:** "This column will be skipped"; "0 WARNINGS / 0 ERRORS"; auto-segment named after the file.
- **A11y/notes:** Auto-grouping imported rows (segment per file) ≈ "this import = this hotel's allocation batch".

### F32 — Map columns with inline new-field creation + row cap (Dovetail, web)
- **Apps observed:** Dovetail — https://mobbin.com/flows/53e90827-7a72-4ac8-ad0d-e2b7545d5c68
- **Flow as observed:**
  1. People database table ("Person / Created / Phone…", "Import" + "New person").
  2. "Map columns — Choose how you would like each column to be imported into Dovetail": header dropdowns per column ("Select…"), option "+ New field" creates a typed field (Date/Text) inline; duplicates prompt "If this data contains duplicates of existing data, what should we do? Select…"; unique-identifier note "…as a unique identifer. This is required to handle duplicates."
  3. Mis-typed column preview shows "Invalid date" per cell and "NaN" — visible pre-import.
  4. Button "Import 303 rows"; easter-egg footer "🤠 Howdy, I'm the CSV cowboy! That's a lot of rows! We only support 500 rows per import"; imported rows fill table with "Empty" placeholders for unmapped fields.
- **Problem solved:** Forgiving column mapping that exposes bad values before commit and handles duplicates by declared key.
- **Sad paths observed:** "Invalid date"/"NaN" cell previews; 500-row cap message; duplicate-strategy prompt.
- **Microcopy worth stealing:** "If this data contains duplicates of existing data, what should we do?"; "Import 303 rows" (count in the button).
- **A11y/notes:** Row count in the CTA and visible invalid-value cells = trust builders for big delegate uploads.

### F33 — Import into existing database with field type pickers (Fibery, web)
- **Apps observed:** Fibery — https://mobbin.com/flows/9d7f8560-a1ab-4821-b123-7ff4db328f9d
- **Flow as observed:**
  1. Space overflow menu "Import data"; modal "Import data to: New Database ⇄ Existing Database"; "DATABASE TO IMPORT" picker; mapping table FIELD (checkbox per column) / "FIELD FROM PROBLEM" (type pickers "# Integer Number", "T Text", "≡ Multi Select") / DATA PREVIEW bars; "Import 5 items".
  2. Rows appear merged into the existing database view.
- **Problem solved:** Merge external rows into an existing structured table with explicit type coercion.
- **Sad paths observed:** None visible.
- **Microcopy worth stealing:** "Import data to: New Database / Existing Database" toggle.
- **A11y/notes:** New-vs-existing destination toggle matters when re-importing updated rooming spreadsheets mid-cycle.

### F34 — Export / share a live list externally (Attio, ClickUp, Height, Superlist, web)
- **Apps observed:** Attio — https://mobbin.com/flows/9eb16b88-8777-4937-a628-a6118a71e77a (plus "Export view as CSV/Excel" in F30); ClickUp — https://mobbin.com/flows/81d2c9f7-82cd-425d-ad86-5c52a3de7c12; Height — https://mobbin.com/flows/bf10cd50-f146-4133-9e99-586c0db740cf; Superlist — https://mobbin.com/flows/abd56857-46e8-4a64-bafb-ccd3b5cef403
- **Flow as observed:**
  1. Attio list "Share" popover: "List Access — Workspace access: No access"; invite person with per-person "Full access / Read and write" dropdowns; "Learn about list access".
  2. ClickUp "Sharing list" modal: "Share this List (all views) — Invite by name or email"; "Share this view… Share link with anyone (toggle) / Private link — Copy link / Protect view / Private view"; banner after enabling: "This view is shared publicly with a link."
  3. Height share popover: "Invite someone to this list by name or email…"; rows "All members — Full access" and "Web — Anyone with the link can access this list" toggle with "Read only" badge; "Copy list link / Copied".
  4. Superlist share: search people/teams/emails; member rows "Creator / Collaborator — Remove"; "Copy link".
- **Problem solved:** Hand a list to an external party with explicit read-only vs edit rights, or as a static CSV/Excel export.
- **Sad paths observed:** Public-link banner warns of exposure.
- **Microcopy worth stealing:** "Anyone with the link can access this list — Read only"; "Export view as CSV / Export view as Excel".
- **A11y/notes:** For hotel handoff, the read-only live link (Height/ClickUp) beats email attachments: the rooming list a hotel sees is always current. Pair with CSV export for hotels that demand files.

### F35 — Approve/deny pending requests (Airwallex, Miro, Deel, web)
- **Apps observed:** Airwallex — https://mobbin.com/flows/9afbce42-5ab9-4c7a-a574-2b6b83cde1fd; Miro — https://mobbin.com/flows/f7a593a4-2783-4a90-8049-55021a9ad282, https://mobbin.com/flows/e8153f2d-14c3-4428-8dc4-a0614000d440; Deel — https://mobbin.com/flows/660b306b-5ba2-400e-bbb8-86f4e4c75690
- **Flow as observed:**
  1. Airwallex "Spend requests": summary tiles "Pending approval — Pending your approval: 1 / All requests in approval: 0"; table with Status pills "Pending your approval / Resubmission required"; detail drawer with Comments + Attachments; actions "Reject ▾ / Create card"; toast "Spend request approved — The request will now be forwarded to the finance admin for card creation".
  2. Miro "Access requests": table Name/Team/Requester/Date ("Expires in 26d") with ✓/✗ row actions; confirm modal "Approve iamleonardkim's request for Design SLMobbin?" + note "You still have available licenses in your subscription. You can add this 1 new member without extra costs."; toast "[user] has been added to…"; empty state "No requests to review — New license requests will show here…".
  3. Deel "Review pending items": banner "ACTION NEEDED — You have 1 item due within 7 days."; per-person drawer with tabs "Pending (1) / Approved (1) / Denied (0)", line items ("Plane Tickets — $431.00 — EXPENSE — DUE IN 7 DAYS — Deny"), bulk "Deny All / Confirm Selection", page-level "Approve All"; toast "All pending items have been denied for Abigail"; summary card "Total to approve".
- **Problem solved:** Queue-based review of requests with per-item and bulk approve/deny, cost context, and deadline pressure.
- **Sad paths observed:** "Resubmission required" status; deny-all path; request expiry ("Expires in 26d").
- **Microcopy worth stealing:** "Pending your approval"; "Resubmission required"; "You have 1 item due within 7 days."; capacity note before approve ("You still have available licenses…").
- **A11y/notes:** Approve-with-capacity-note maps to "approve room change — 2 rooms left in block". Request expiry maps to block cutoff dates.

### F36 — Publish + notify affected people (7shifts, Skiff, Linear, web)
- **Apps observed:** 7shifts — https://mobbin.com/flows/a188ab96-5d5c-4917-bb42-e27d16942411, https://mobbin.com/flows/e0cb1343-eed1-40ef-b90f-e90c4b895355; Skiff — https://mobbin.com/flows/51792742-3b11-4828-a750-a0c2b14c2a85; Linear — https://mobbin.com/flows/cc84956a-f171-498f-81b4-95e7c2be46fe
- **Flow as observed:**
  1. 7shifts: "Publish schedule" button (disabled until changes exist) → "Publishing…" → header note "Multiple last published dates"; notifications panel entries: "Schedule published — The SLMobbin - Back of House schedule has been published for March 31 - April 6." / "Time off approved — Your time off request for Fri, Apr 4… has been approved" / "Time off request added — Cindy Jung has submitted a time off request…".
  2. Skiff calendar: editing an event with participants surfaces a "Send update" button; participant rows show RSVP "Yes / No / Maybe"; Update saves + notifies.
  3. Linear "Project updates": "Update schedule — Configure how often updates are expected on projects. Project leads will receive reminders to post updates." (frequency picker "Every week / Every 2 weeks…"); "Slack notifications — Send project updates to a Slack channel".
- **Problem solved:** Make "publish" the moment downstream people get notified, and make change-notifications explicit and auditable.
- **Sad paths observed:** Unpublished-changes state ("Multiple last published dates") flags drift between draft and what people saw.
- **Microcopy worth stealing:** "Send update"; "Schedule published … for [range]"; "Project leads will receive reminders".
- **A11y/notes:** Draft → publish → notification feed is the rooming-change broadcast model (delegate + hotel both subscribe).

### F37 — Waitlist when capacity is gone (Acorns, Clubhouse, Partiful, iOS)
- **Apps observed:** Acorns — https://mobbin.com/flows/026830bb-f098-45d1-817d-93038f6a05c1; Clubhouse — https://mobbin.com/flows/83524d0b-cdc6-4505-a688-c5e7ebd98115; Partiful — https://mobbin.com/flows/1284a348-cf38-4cce-a120-76d542ca6703
- **Flow as observed:**
  1. Acorns: "Coming Soon" feature page → survey sheet "What do you think?… Select all that apply" → CTA "Submit & join the waitlist" → state flips to "You're in! — We'll notify you when it's ready."
  2. Clubhouse: house page CTA "join the waitlist — only approved members can join this house" → banner "🎉 You're on the waitlist for Beta Testers! We'll let you know once a spot opens up." + button state "✓ you're on the waitlist!".
  3. Partiful (host side): event spots field "25 total spots" with numeric pad + "Waitlist" toggle; after save shows "25/25 spots left · Waitlist [on]".
- **Problem solved:** Convert sold-out demand into an ordered queue with a notify-on-opening promise.
- **Sad paths observed:** Whole pattern is the sold-out sad path.
- **Microcopy worth stealing:** "We'll let you know once a spot opens up."; "Submit & join the waitlist"; host-side "Waitlist" toggle next to capacity.
- **A11y/notes:** Room-block sell-out → delegate waitlist with auto-notify on cancellation is a direct composite of F37 + F10 (cancellations release inventory).

### F38 — Price/change watch alerts (Expedia, Hopper, Skyscanner, iOS)
- **Apps observed:** Expedia — https://mobbin.com/flows/44db9087-0957-444a-8349-730c0117e121; Hopper — https://mobbin.com/flows/68cdee10-4c8a-475d-a697-b78ee53bce02; Skyscanner — https://mobbin.com/flows/313c2fa7-ce88-4b8e-a4b9-c53d52c770f8, https://mobbin.com/flows/188cd517-8893-4366-af35-38f9e3f35b60
- **Flow as observed:**
  1. Expedia "Price Tracking" card with sparkline + toggle "Watch prices — Get push notifications if prices go up or down"; toast "You'll get push notifications when prices change for this search."
  2. Hopper: "You should book now. This is the lowest prices are likely to go… Otherwise Hopper will notify you when deals are available or prices start to rise."; buttons "Watch This Trip" → "Watching"; callout "You are watching your first trip! The bunny will notify you when prices drop & before they rise."; "Hold this fare starting at $38 — Book later when you're ready" (Price Freeze).
  3. Skyscanner: heart-save → modal "Stay on top of prices — We'll send you email and push notifications for this flight to keep you up to date with fares. Got it"; snackbar "Saved – we'll notify you if prices change. View"; "Drops" tab: deal cards "$85 drop" with strikethrough prices.
- **Problem solved:** Subscribe to change events on a watched item instead of polling it.
- **Sad paths observed:** None; pattern exists to pre-empt the price-rise sad path ("before they rise").
- **Microcopy worth stealing:** "Saved – we'll notify you if prices change."; "Watch prices"; "Hold this fare… Book later when you're ready".
- **A11y/notes:** "Watch" semantics fit ops watching block pickup pace; "price freeze/hold" maps to holding rooms without naming delegates yet.

### F39 — Disruption rebooking & manage-booking hubs (Trip.com, Singapore Airlines, iOS)
- **Apps observed:** Trip.com — https://mobbin.com/flows/a4143fb2-6633-4a14-ae28-086ebaa748e0; Singapore Airlines — https://mobbin.com/flows/1f645645-2708-487f-9288-094ad3b133f3
- **Flow as observed:**
  1. Trip.com "Changing flights": bundle view "1 Flight — Change Flight / Baggage / Flight Change & Cancellation Policies"; pick new departure list with price deltas per option ("+$0", "−$2", "+$4") relative to current; detail sheet "Round-trip Price −$2/person Incl. taxes & fees — Continue".
  2. Singapore Airlines "Manage booking": trip card "Online check-in opens 48 hours before departure" + "MANAGE BOOKING"; web view "Your flights — Upgrade flights / Change flights / Cancel flights" with per-segment "Confirmed" status; cross-sell "Complement your trip: Hotels in Brussels…".
- **Problem solved:** Replace one leg of an existing itinerary, with delta pricing instead of full repricing.
- **Sad paths observed:** Policy links surfaced at the start of the change flow.
- **Microcopy worth stealing:** Delta pricing chips ("+$4 / −$5") on alternatives; "Review before you cancel" subtitle on Cancel trip.
- **A11y/notes:** Delta-priced alternatives = the pattern for offering delegates alternate hotels/room types when their original is cut from the block.

### F40 — Split costs with companions (Wise, Splitwise, iOS)
- **Apps observed:** Wise — https://mobbin.com/flows/b482eb3b-5f10-494f-a4ef-18d1e629f91a; Splitwise — https://mobbin.com/flows/bf5fa9c0-1639-4c23-8f3d-cabcd681ca04, https://mobbin.com/flows/1a29c121-9292-4933-b14f-dd64aecfcf00
- **Flow as observed:**
  1. Wise "Bill splits": Active/Inactive tabs; "SPLIT WITH ANYONE — Enter names or Wisetags to find them on Wise. If they're not on Wise, we'll create a payment link"; "Split bill" editor with per-person amount fields ("Paid" / "Owes you"); progress bar "1 SGD received / 1 SGD requested".
  2. Splitwise: friends list with balances "You owe John D. $200.00 in 'Winter Trip'"; "Add friend" by name+email, note "Don't worry, nothing sends just yet. You will have another chance to review before sending."
- **Problem solved:** Track who owes what on a shared cost with non-member fallbacks (payment link).
- **Sad paths observed:** Pending/partial-payment progress state.
- **Microcopy worth stealing:** "If they're not on Wise, we'll create a payment link"; "nothing sends just yet".
- **A11y/notes:** Relevant only if EventState ever does shared-room cost splits between roommates; thin otherwise.

---

## COVERAGE NOTE

### Queries run (verbatim, with platform)
1. "booking a hotel room from search to confirmation" — web → F1, F2, F3, F4, F5 (Expedia, Booking.com, Klook, TravelPerk).
2. "modifying an existing hotel reservation dates" — ios → F6, F7, F8, F9 (IHG, Marriott Bonvoy, Booking.com, Trip.com).
3. "cancelling a hotel booking and getting a refund" — ios → F10, F11, F12, F13 (Trip.com, Tripadvisor, Vrbo, Navan).
4. "booking travel on behalf of someone else corporate travel" — web → F15, F16, F17 (KAYAK for Business, Airbnb, Navan).
5. "selecting a seat during flight check-in" — ios → F20, F21 (American Airlines, Hopper, Booking.com, Shopee).
6. "rebooking after a flight is cancelled or changed" — ios → F14, F39 (American Airlines, Trip.com, Singapore Airlines).
7. "adding guests or roommates to a booking" — ios → F27, F29 (Booking.com share, Airbnb add-guests, Tripsy).
8. "importing a spreadsheet of data and mapping columns" — web → F30, F31, F32, F33 (Attio, Customer.io, Dovetail, Fibery).
9. "reviewing and approving a pending request" — web → F35 (Airwallex, Miro, Deel).
10. "assigning a person to a shift in a staff schedule" — web → F18, F19 (Deputy, 7shifts).
11. "joining a waitlist when something is sold out" — ios → F37 (Acorns, Clubhouse, Partiful; Greg shop waitlist FAQ also returned, not recorded — marketing page, no flow mechanics).
12. "exporting or sharing a list with an external party" — web → F34 (Height, ClickUp, Attio, Superlist).
13. "viewing an upcoming trip itinerary" — ios → F28 (Qantas, Tripsy, Expedia).
14. "getting notified about a price drop or change to a trip" — ios → F38 (Expedia, Hopper, Skyscanner).
15. "receiving and viewing a booking confirmation" — ios → F26 + reinforced F10/F29 (Trip.com voucher, Airbnb, Viator).
16. "splitting a trip or stay with friends" — ios → F40 (Wise, Splitwise; Hopper referral noise).
17. FOLLOW-UP "group travel booking for multiple people at once" — web → F22 (Navan group events; KAYAK repeats).
18. FOLLOW-UP "managing hotel room block inventory for an event" — web → F23, F24, F25 (Expedia Groups bidding, Booking.com extranet bulk edit, Posh) — best query of the sweep.
19. FOLLOW-UP "finding or matching a roommate to share accommodation" — ios → NOTHING NEW on-topic (returned Booking.com generic search, Yubo social friend-matching, Airbnb co-host). Dry signal 1.
20. FOLLOW-UP "notifying affected people after a schedule change" — web → F36 (7shifts publish/notifications, Skiff send-update, Linear update schedule).
21. FOLLOW-UP "conference attendee accommodation management dashboard" — web → repeats only (Posh F25, Navan F22 again; Airbnb host dashboard and Booking.com demand analytics, marginal). Dry signal 2 — stopped per protocol.

### Queries that returned nothing new
- Query 19 (roommate matching) — zero on-topic results.
- Query 21 (conference accommodation dashboard) — only repeats of F22/F24/F25.

### Flow domains Mobbin LACKS — FIRST-PRINCIPLES CANDIDATES
1. **Ops-side rooming grid (delegate × room × night assignment).** No app shows assigning named people into hotel rooms. Closest scaffolding: Deputy/7shifts shift grids (F18/F19) + Booking.com seat-assign sheet (F20). Build from these: rows=rooms, columns=nights, cells=delegates, conflict chips, draft→publish.
2. **Roommate pairing/matching.** No flow lets a guest choose or be matched with a roommate from a pool. Airbnb add-guest (F29) covers "add a known companion" only. Pairing rules (gender, seniority, opt-in), mutual-consent requests, and auto-matching are first-principles.
3. **Rooming-list handoff to hotels.** No observed "send rooming list to hotel" flow anywhere. Compose from F34 (read-only live link + CSV/Excel export), F26 (per-guest voucher), F27 (rights-tiered share), F36 (publish-notify). The hotel-facing acknowledgment loop ("hotel confirms receipt/changes") is wholly unobserved — first-principles.
4. **Room-block lifecycle for a buyer (attrition, cutoff dates, release-back).** Expedia Groups (F23) covers sourcing/bidding and Booking.com extranet (F24) covers seller-side inventory, but block cutoff countdowns, attrition penalty tracking, and releasing unsold rooms back to the hotel are unobserved — first-principles, borrowing Vrbo's deadline-timeline visualization (F12) for cutoffs.
5. **Cascade notifications on reallocation.** Single-booking change notifications exist (F8, F36), but "ops moves 12 delegates across hotels → batched, per-audience (delegate vs hotel) notifications with diff" is unobserved. Compose Marriott's change-diff (F7) + 7shifts publish feed (F36) + Deel bulk review (F35).
6. **Waitlist tied to inventory release.** Waitlist join exists (F37) and cancellation exists (F10–F13), but the automatic "cancellation frees a bed → next waitlisted delegate offered with expiry" chain is unobserved — first-principles composite.
