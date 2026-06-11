# RAW Sweep Notes — Travel / Itinerary Management (EXCELLENCE)

Job-to-be-done: enter/track a person's travel itinerary (flight/train/etc.) → keep it current as reality changes (delays, cancellations) → tell the traveler and downstream ops the moment something changes → give ops a who-lands-when picture at scale.

Source: Mobbin MCP (search_flows + search_screens), iOS + web. Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

## Sweep matrix executed

| Mode | Queries run | New patterns |
|---|---|---|
| by-app | TripIt itinerary (→ Wanderlog/Tripsy/Tripadvisor/Pangea/Weather Channel substituted); Flighty tracking+alerts; TripIt email forward (→ Wanderlog/GetYourGuide/Trip.com/Beli); Navan/TravelPerk corporate admin | yes (each) |
| by-flow | group travel create event / book on behalf (Navan, TravelPerk, KAYAK biz); airline disruption/cancel/rebook (AA, Singapore Airlines, Trip.com); share flight status live (Flighty, Qantas); trip chronological timeline (TravelPerk, KAYAK Trips, Pangea, Vrbo, Viator, Airbnb) | yes (each) |
| by-pattern | arrivals/departures travelers-landing-today manifest (web) → DRY: only Better Stack log-tool demos + Etsy/7shifts noise; boarding pass/document wallet (Qantas, Wanderlog); notification feed of trip changes (Air NZ, Expedia, Flighty, Tripsy, Turo) | manifest: NO; others: yes |

Stop condition: final round produced only peripheral additions; manifest query fully dry. Declared done.

## Coverage honesty
- **TripIt and App in the Air are NOT indexed on Mobbin.** Their pattern DNA (email-forward ingest, master itinerary timeline) was harvested via Wanderlog, Tripsy, KAYAK Trips — noted on each card.
- **Day-of arrivals/departures manifest for ops:** NO consumer/SaaS UI found on Mobbin (query returned log-tooling demos). Closest observed: Navan Safety "Traveler report" (filter + download list). FIRST-PRINCIPLES CANDIDATE flagged in INDEX + WOW-DELTA.
- **WhatsApp itinerary delivery UX:** not harvestable on Mobbin. First-principles candidate (EventState origin-doc binds the channel).
- **CSV import wizard:** deliberately NOT swept — EventState already binds the import-wizard contract (PATH-onboarding-import-007/008); travel rides that contract (PATH-travel-008).
- Hotel/accommodation booking UX out of scope (separate module).

## Raw flow/screen citations

### Flighty (iOS)
- My flight alerts — https://mobbin.com/flows/a7b48e7b-6c6f-49d0-a6c6-05013d0c6a54 — alert tiers: Basics (gate changes, delays, cancellations) / Above & Beyond (inbound aircraft status, connection assistance, aircraft changes) / Flight Plans / Arrival Information (landing, gate arrival, baggage claim). Separate "My Flights" vs "Friends' Flights" alert scopes. Automations: Calendar Sync, TripIt Sync, Add Flights via Email.
- Live Activities — https://mobbin.com/flows/7e5b1c0f-fe17-4f5f-ad94-dfd1fc802091 and https://mobbin.com/flows/8f54910b-ffab-4066-bafb-ea16f525f27c — lock-screen flight card: airline+number, big airport codes, times color-coded green (on time/early) / red (late) with "9m early"/"26m late" deltas at each endpoint, progress bar, banner row "Gate Departure in 1h 45m — Inbound aircraft has arrived", gate chip "↗14", arrived state "Arrived 33m Early — Terminal 4 · Gate 42A" + baggage chip "T4C1".
- My flights — https://mobbin.com/flows/822e5e87-5e54-4117-b556-362464cac7e1 — countdown-first list: left rail "2 DAYS / 6 DAYS / 8 HOURS / 5h 41 MINUTES", route in words "San Francisco to London", airline chip, dep/arr codes+times, right-aligned status ("Departs On Time", "Landing in 3h 29m", IN AIR), globe map with route arcs behind sheet.
- Adding a flight — https://mobbin.com/flows/e5a241ca-9ae9-4bee-baa4-bf56b4759fef — add by route: origin/destination airports + departure date → ALL flights that day listed (airline, duration, dep/arr), "SHOW CODESHARES — 22 RESULTS", "Filter by Airline". Empty state "Let's Fly Somewhere — Tap the search bar to add your next flight".
- Share a flight — https://mobbin.com/flows/e123bd20-9fed-4a4c-8090-e44ced4631b2 ; Sharing flights — https://mobbin.com/flows/cd1d29d6-8fa0-4d50-a9a1-8394400a4eae ; Sharing a flight — https://mobbin.com/flows/e1726cea-06c2-4f11-8eb5-b3eb4379d22c — "Live Flight Tracking — Share this link with others and they'll see your flight info and status in real-time" (live.flighty.app card) → Share Link; Route Map share ("Show your flight story. Including customizable boarding pass sticker."); Flight Status sticker ("Announce your arrival (or delay 😢) with a sticker" — split-flap departures-board aesthetic); multi-select flights → Continue → share sheet.
- Flight detail screens — https://mobbin.com/screens/aabd3462-222b-43ad-91c6-8c8364e515a1 and https://mobbin.com/screens/a2d54db3-312a-4a25-8a3c-6639bef55d7c — "My History on This Route"; **"Updates — 25 updates for this flight"** timestamped feed ("Predicted Gate Arrival 8:00 PM — Dec 02 at 3:03 PM", "Powered by FlightAware Foresight"); Notes field; Booking Code "Tap to Edit" + PASTE; Seat tile; "Good to Know": "Operated as KE 438 by Korean Air" (codeshare), "+2 Hours Timezone Change — 6:50AM arrival is 4:50AM Jakarta time".
- Detail header reassurance — https://mobbin.com/screens/0b1b9d14-b576-44ea-b93b-c40ba046fbfd — "Gate Departure in 5h 55m — Inbound aircraft is in air from Seoul, with enough time for 9:50PM departure"; contextual alert upsell "Worried about delays? Be first to know what's happening. Without lifting a finger. ACTIVATE ALERTS" with sample push ("⚠ Delayed 2h 30m — Now departing Gate 32A at 8:30pm").

### Navan (web)
- Group travel — https://mobbin.com/flows/1a36de0c-77a1-4014-8df7-e24330d95f22 ; Creating a group event — https://mobbin.com/flows/3817b51a-4d0f-44c1-a45d-81746206e3a3 — "Organize group travel for up to 500 participants. We'll send invites to your travelers, show you their booking progress, and keep you informed of estimated and actual booking costs." Create: event name, location autocomplete, start/end dates + time sliders. Event page: cover image, Draft badge, numbered checklist ① Configure event settings ② Add participants ③ Send invitations ("you can still edit event details and add new participants after"); "Send invites" disabled until steps done; tabs Event settings / Participants. List cards: status "In progress", location, dates, "In 56 days", "0/2 booked" progress bar, "$0 actual / $2,606 estimated". Empty state: "Once you create a group event, you'll be able to manage the details here."
- Safety → Traveler report (Dashboard flow) — https://mobbin.com/flows/bd74505f-dcf4-4549-9322-2ad49ad36901 — "Download here all the booking details of your current and future travelers by location, flights or hotels." Tabs Location/Flights/Hotels, date range, continent+location filters → "Show list". Approvals → Bookings: viewing Pending dropdown, empty state "There are no requests for approval. When a traveler requests approval it will show up here.", "Set temporary approver".
- Trip detail — https://mobbin.com/screens/51f3a7c8-4cc1-4ce5-94c1-8f8afe68ab37 — left "Trip itinerary" chronological rail + "Add to trip" dropdown; center segment detail; right rail: Cancel car / Download invoice / Expense · Manage trip: Share trip, **See PDF itinerary**, **Add to calendar**, View visa requirements · Get support.
- Flight details + booking summary — https://mobbin.com/screens/1150156b-0222-4b2d-9962-3e4c9e81cd5a — segment timeline with layover row "2h 16m layover at YUL", "Late booking" warning chip, hold timer "Time left to book — 24 min : 29 sec — Book before the timer runs out to secure this rate."

### TravelPerk (web)
- Trips — https://mobbin.com/flows/624b7510-8bb7-4516-b513-1631dba78ea9 — status tabs Now(0)/Upcoming(0)/Drafts(1)/Past(0)/Canceled(0) with counts; "Only my trips" checkbox; search "trips, travelers, or locations". Draft card: trip name, dates, price, route summary, traveler avatars + names, "Add a label", actions Share trip / Delete trip / Continue editing, trip ID. Empty: "Ready for your next trip? Nearly there. You're just a few clicks away."
- Events — https://mobbin.com/flows/2e2fe01b-2540-40d7-a35c-60bb6a4013e9 — "Create an event — Are you organizing a team gathering, or a group trip?" name/dates/location, Event privacy: Company event ("Everyone at X can see and attend") / Private ("Only invited people"). Events list grouped by month, cards with "Attending" badge + avatars. Group-size escape hatch: "Need 9 or more rooms for your group? Request a group booking — our dedicated in-house team of Meetings and Events experts will handle everything from start to finish."
- People — https://mobbin.com/flows/061b1903-4432-4932-8265-6d06d08af22d — admin table: search name/email, filters Role/Company/Cost center/+Add filter, tabs Active(2)/Invited(1)/Archived(0), columns Name, Role, Company, Cost Center, Approval Process; Export people; Invite people.
- Multi-segment trip builder — https://mobbin.com/screens/e45e030b-3194-49f5-9a55-9459d23b893f — day-grouped timeline (train card + flight card, each Edit/Share/Delete), **contextual gap suggestion: "Add a place to stay in Chicago, Illinois — Wed, May 28 - Thu, May 29 [Search stays]"**, total price panel "You won't be charged yet", trip ID in header.

### KAYAK / KAYAK for Business (web)
- Searching flights (book for traveler) — https://mobbin.com/flows/c90ce0c5-2eb0-4c3d-91ff-d7695b190c71 ; Book a flight for traveler — https://mobbin.com/flows/5da98a69-4aad-4be8-9f03-4e397efcb90a — toggle "Book for yourself / Book for traveler" → **persistent banner "You are searching on behalf of John Smith" + "Exit mode" button**; account chip becomes "Booking for John". Inline policy panel: "Your flight travel policy — Max allowed price: $500 · Max cabin class · When to book · Remember to request approval if the flight is out of policy"; "In policy" green check on fare cards; fare-tier comparison "What's included in each fare" with ✓/✗ rows.
- Your flight booking — https://mobbin.com/screens/b5afe65f-4575-4b4b-b40e-ae3415d11008 — header "Booking created: Tue Mar 4 2025 | Booking reference: PE24FB"; segment cards as vertical timelines; Options rail: Change booking / Cancel booking / View booking / Print receipt / **Resend confirmation email**.
- Trips itinerary — https://mobbin.com/screens/502ae32f-542e-48bd-a5a4-98e5243ab275 and https://mobbin.com/screens/0ff459ce-f3f3-407c-a8de-8328f65a809e — day-by-day with "Booked" badges; onboarding card "Welcome to Trips: All booking receipts in one place · Free alerts for check-in, flight status & more · Offline access · Share and collaborate with others · Forward booking emails to trips@kayak.com"; per-item provenance note "Booked on CarRentals.com — Forward any changes to trips@kayak.com"; empty day "No scheduled activities yet" with +.

### Wanderlog (iOS)
- Add flights via email — https://mobbin.com/flows/bdd480a1-a579-460a-aee5-c1575b46dbb6 + status — https://mobbin.com/flows/b0272b56-fd66-4f39-b409-f79bd9cf95de — "Import your reservation details to your plan by forwarding your email. Or have it automatically synced by connecting your Gmail." Personal forwarding address `trip+14243938@wanderlog.com` with Copy→Copied; "Check imported emails status" page; sad-path copy: "We haven't received any emails yet. It can take up to 3 minutes for emails to reach us. We'll automatically add it, **so you can close this dialog**. Check back if it still hasn't been added after a few minutes."
- Reservations & attachments — https://mobbin.com/flows/4156635d-9733-4154-8c28-f5bd0f561ec2 and https://mobbin.com/flows/714ae4b9-2321-4196-b0dd-ec793f61fefe — Overview rail "Reservations and attachments" icon row (Flight/Lodging/Rental car/Attachment/Other with count badges); flight block: route, date+times, carrier+number, "Starting live flight status on 29 Nov 2025" auto-note, CONFIRMATION # A3F9K2 (copy icon), price chip, NOTES "TSA PreCheck eligible"; attachment = actual airline receipt image viewable inline, actions Attach new / Open in / Link to place / Unlink; upload progress ring (47%).

### Tripsy (iOS)
- Trip overview — https://mobbin.com/flows/f590cad8-0f0f-4490-950b-9a96ca0f5b3f — card stack: "Latest Added" (flights, hotel), "Automation — Forward all your reservations to my@tripsy.app and let Tripsy organize everything for you" (Manage / Copy), "Invite Guests — They can view, add, edit and remove items, but you're the admin" (Share Trip), Customize. Map header with terminal pin; quick-add tiles New Activity / Flights / Lodgings; flight card "Newark EWR 11:45AM → Tokyo (Narita) NRT 2:30PM, Thu Aug 28".
- Notification preferences — https://mobbin.com/screens/58e54c48-d256-4a79-aa74-5510cabf7cd5 — General Trip Alerts: "1 month before start" / "7 days before start" / "Your trip starts today"; Flight Alerts: Basic ("Gate changes, time changes, baggage claim assignment, and cancellation") / Departure & Arrival; Collaboration: "New Activities Added".

### Qantas Airways (iOS)
- Share a trip — https://mobbin.com/flows/eb9c2a32-d7c4-4d52-b786-f3dc030cc89e — consent disclosure: "What will be shared" ✓ Your first name ✓ Flight details (number, status, dep/arr date+time, terminal and gate) vs "What won't be shared" ✗ Booking reference ✗ Ability to make changes ✗ Payment information ✗ Passenger details ✗ Hotels or car hire. "Make sure you have their consent before you send it to them." "You can unshare your trip later if required."
- Trip detail (following) — https://mobbin.com/flows/4f7870ec-d48d-4c67-9248-ca060f4eab3b — Trips tab "Upcoming | Following"; received shares grouped by date, "Shared from J" → read-only "(name)'s trip" detail, gate "–" placeholders, "Updated just now" footer.
- Boarding pass — https://mobbin.com/flows/246091ef-3596-4471-ba9b-9f7b0d59a130 + info — https://mobbin.com/flows/7904ecff-0be9-4163-be6f-770370ffb243 — "You're checked in" ✓ → pass: date/flight/seat, terminal/gate(–)/group/boarding time, Add to Apple Wallet, sequence number, "Using this boarding pass" help (bag tags at kiosk, QR at gate).

### American Airlines (iOS)
- Manage trip — https://mobbin.com/flows/63e2f645-0315-4c35-bf51-9a07aa1aefda — hub actions: Change trip / Seats / Add bags / Manage trip / Request wheelchair / Add infant in lap / Share trip / Cancel trip; record locator KUIKKN; "Updated 32 minutes ago"; gate/terminal/bag columns show "--" until known; "Incoming flight" link; aircraft type; check-in window note "Check in beginning 24 hours before departure — Time until check-in 6d".
- Cancel a trip — https://mobbin.com/flows/339b5c1d-1fdf-446d-903a-2d62adffe299 — "Cancel your trip for a refund? **You can cancel for all passengers within 48 hours 9 minutes for a refund.**" Refund rules in plain language (24h full refund if booked 2+ days out; change fee + fare difference after; partial-passenger → call) → buttons "Cancel for a Refund" / "Go back".

### Singapore Airlines (iOS)
- Manage booking — https://mobbin.com/flows/1f645645-2708-487f-9288-094ad3b133f3 — My Trips "Next Trip / Trip List"; booking status Confirmed; "Online check-in opens 48 hours before departure"; per-direction segment cards each with Confirmed chip; actions Upgrade flights / Change flights / Cancel flights.

### Air NZ (iOS)
- Notifications feed — https://mobbin.com/screens/118195ff-27e2-4fab-8ec4-741446a6e310 — cards: context chip "AKL to SIN · NZ284" + relative time + message + per-type action button ("Check in", "Learn how to connect"); change copy: "**Flight change. Your flight on Fri 31 Oct 2025 now leaves 10 minutes later at 11:20 AM.**" →detail chevron.

### Expedia (iOS)
- Notifications inbox — https://mobbin.com/screens/f307400a-8095-443b-ace5-2dc906a05fab and https://mobbin.com/screens/77c5fd5c-50b6-4a57-99d2-8391046ac470 — "Booking confirmed / Booking canceled" entries, type icon (flight/car/hotel/ticket), body names the thing + date + "View your trip for details", unread dot, relative time.

### Turo (iOS) — adjacent (state-change feed)
- Trips activity — https://mobbin.com/screens/9c1b81a8-4c43-425a-ad8c-b6ec2b90a1ec — tabs ACTIVITY/BOOKED/HISTORY; entries "Trip cancelled / Request cancelled / **Change request pending — Bryan has until 10:00 AM on Friday, August 6 to confirm the changes**" — pending-state with deadline.

### GetYourGuide (iOS)
- Import booking — https://mobbin.com/flows/406a46fc-ba75-4ad7-8abe-cae65041cca7 — claim booking by email: enter purchase email → "Send code" → "We've sent a code to … The code expires in 2 hours." / "A code can only be sent every 2 minutes."

### The Weather Channel (iOS)
- Adding a trip — https://mobbin.com/flows/2ebd073f-9620-4242-9f2f-7f0a06e06f74 — "Tell us about flights you've already booked. We'll monitor weather at your departure and arrival airports, as well as any layovers." Outbound/Return cards, add layover, name trip; trips list row shows risk badge "MODERATE ⚠ LAX".

### Booking.com (web)
- Flights checkout — https://mobbin.com/screens/bf92a9c1-cbb9-4e71-a728-774bbc16bdec — stepper "Ticket type → Who's flying? → Baggage and extras → Check and pay"; Contact details / Traveler details blocks; "No hidden fees — here's what you'll pay".

### Kiwi.com (web)
- Booking detail — https://mobbin.com/screens/916e5287-a538-48d7-a5af-dbaa17da0048 and https://mobbin.com/screens/8997532f-572a-48ba-8143-9431217e86f1 — hero: city photo, SFO→LAS big codes, dep/arr times, "**Departs in 37 days**", booking ref F94156, "View itinerary"; passenger row with outstanding-task chip "**Add details for check in**" / status row "Check in directly with Frontier Airlines"; baggage entitlement rows (1× personal item with dimensions, 0× cabin, 0× checked).

### Trip.com (iOS)
- Customer support — https://mobbin.com/flows/b0e60342-a837-4b4a-819b-7d2ee8eee9f3 — support inbox keyed to bookings: each booking card with status chip + contextual FAQ ("When will I receive my refund?" under a canceled item); Emergency Assistance entry.

### Noise / dry results
- Better Stack (flight-log demo dashboards), Etsy orders, 7shifts scheduler — returned for "arrivals departures travelers landing today" → no real manifest pattern on Mobbin.
- Tripadvisor/Pangea/Vrbo/Viator/Airbnb itineraries: leisure-planning oriented; only Pangea timeline + Vrbo day headers noted, no new mechanics beyond TravelPerk/KAYAK versions.
