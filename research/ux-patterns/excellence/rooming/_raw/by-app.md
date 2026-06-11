# BY-APP Raw Harvest — Rooming / Accommodation Ops
Job: A conference ops manager allocates hundreds of delegates into hotel rooms across multiple hotels — dates, room types, roommates, block inventory, change/cancel handling with notifications, delegate confirmations, and rooming-list exports to hotels.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

## A1 — Trip timeline with lodging as check-in/check-out anchor events
**Apps observed:** Tripsy (iOS), Wanderlog (iOS), Pangea (iOS)
- Tripsy flow "Changing itinerary preferences": https://mobbin.com/flows/9b4c87a5-b7d1-4c3c-924f-5b36eb2e29da
- Wanderlog flow "Itinerary": https://mobbin.com/flows/88a3eab3-6cca-496f-a3cb-bca2011df206
- Pangea flow "Itinerary": https://mobbin.com/flows/e0ac31b9-b908-47ef-9242-d489cab802f6

**Anatomy as observed:**
- Tripsy "Japan Trip": sheet titled with trip name, horizontal week strip (WED 27 … TUE 2) with dot indicators per day, then a vertical day-grouped timeline. Each day header is "THU, AUGUST 28 in Narita, Newark" plus an ordinal day count ("1st", "3rd") right-aligned. Timeline rows have leading category icons: flight row "Newark to Tokyo (Narita) — EWR 11:45 AM ↘ NRT 2:30 PM", a system row "Time Zone Change +13 hr", a lodging row "Narita Tobu Hotel Airport / Check-in". Bottom bar: filter icon, "First day" jump link, "+" add button.
- Tripsy "Itinerary Preferences" sheet: toggle list under ITINERARY INFORMATION — "Display Current Lodging", "Display Day Count", "Expand Departures and Arrivals", "Display Time Zone Changes" (PRO badge); WEATHER section with "Weather Conditions — 10-day forecast during your trip" (PRO), "Display Temperature Unit", "Temperature Unit > Fahrenheit/Celsius".
- Wanderlog "Trip to New York": tabs Overview / Itinerary / Explore / $; horizontal day-chip row (Mon 12/1, Tue 12/2 …); per-day header "Mon 12/1 — Day 1" with "Auto-fill day · Optimize route (PRO)"; the lodging "Pod Times Square" appears as a card with a right-aligned "CHECK IN" chip on day 1 and the same hotel with "CHECK OUT" on the last day; numbered place stops (1, 2, 3) with walk-time connectors ("5 mins · 0.26 mi · Directions").
- Pangea trip hub: sections "Accommodations — 1 stay" (hotel card "Best Western Plus Hotel Hong K… / 12 Jan – 20 Jan / Free breakfast!"), "Trip Itinerary — 2 spots", "Wishlist"; bottom buttons "Private Trip Chat" / "+ Add". Itinerary tab filters: All / Wishlist / Stays / Events. The SAME stay renders twice on the timeline: under Monday 12 Jan with left-rail label "Check-in 01:00 pm" and under Tuesday 20 Jan with "Check-out 10:00 am", each card repeating hotel name, date range, note, and "Maps / Website" chips.

**Problem solved:** Makes a multi-day stay legible inside a chronological timeline by splitting it into two boundary events (check-in, check-out) instead of one opaque range.
**Sad paths observed:** none in this set.
**Microcopy worth stealing:** "Check-in 01:00 pm / Check-out 10:00 am" as left-rail timeline labels; "Display Current Lodging"; "First day" jump control; "CHECK IN"/"CHECK OUT" status chips on the hotel card itself.
**A11y/notes:** Day-of-trip ordinal ("Day 1", "1st") alongside calendar date helps ops staff reason in conference-day terms, not just dates — directly applicable to rooming night grids.

## A2 — Itinerary detail as editable stop/route record (booking-for-others adjacent)
**Apps observed:** BlaBlaCar (iOS)
- Flow "Itinerary detail": https://mobbin.com/flows/c1246cd1-6607-4065-acec-903d287d0fc7
- Flow "Itinerary details": https://mobbin.com/flows/ec6ad662-2415-40fa-9c33-73ffdf1a6808

**Anatomy as observed:** "Edit your publication" hub screen: chevron rows "Itinerary details", "Route", "Price — We'll transfer passenger contributions to you after the ride.", "Seats and options", "Boost booking requests"; below a divider, link-styled destructive/secondary actions: "Duplicate your publication", "Publish your return ride", "Cancel your ride". Drilling into "Itinerary details": Date row ("Fri, 13 March"), Time row ("17:30"), then a vertical stop list (London → Watford → Luton → Birmingham, each with full street address) connected by a rail, footer link "Manage stopovers".
**Problem solved:** One hub screen that decomposes a published reservation into independently editable facets, with duplicate/cancel kept visually separate from edits.
**Sad paths observed:** "Cancel your ride" entry point present (cancellation reachable from the edit hub, not buried).
**Microcopy worth stealing:** "Duplicate your publication" (clone a reservation setup — useful for cloning room blocks); "Manage stopovers".
**A11y/notes:** Edit-hub-of-facets is a strong shape for a room-block editor (dates / inventory / pricing / occupants as separate chevron rows).

## A3 — Trip hub: bookings grouped by type, with confirmation numbers and invite-collaborators
**Apps observed:** Wanderlog (iOS), Expedia (iOS), Tripsy (iOS), Skyscanner (iOS)
- Wanderlog Overview screen: https://mobbin.com/screens/1389b0e7-8090-4bf7-82fa-faf5372e5599
- Wanderlog Flights/attachments section: https://mobbin.com/screens/ad85f486-2813-4895-a746-5e10e7c215f4
- Wanderlog itinerary place detail: https://mobbin.com/screens/a500ad7b-6877-4a44-af5c-e201275c8fa2
- Expedia "Berlin 23" trip screen: https://mobbin.com/screens/7fedd758-be97-470a-99b0-c7603d871e3b
- Tripsy trip hub: https://mobbin.com/screens/57001b53-ced1-4865-b8ad-e5016906f7ff
- Tripsy trip hub (Automation/Invite cards): https://mobbin.com/screens/b1e8ff79-c094-41af-a995-6faa06659383
- Skyscanner "Trip Details": https://mobbin.com/screens/dcaf8bdc-fdd5-4776-8075-19347e11a8dc

**Anatomy as observed:**
- Wanderlog Overview tab: hero image + trip card ("Trip to New York", date chip "12/1 – 12/4", member avatars, "Share" button); "Reservations and attachments" icon row: Flight / Lodging / Rental car / Attachment / Other (Flight icon carries a count badge "1"); collapsible sections "Notes", "Flights", "Hotels and lodging", "Rental cars". Inside Flights: route card "LAX → JFK, Mon, 1 Dec · 7:00 AM – 3:29 PM, DELTA AIR LINES DL 979", green-dot status line "Starting live flight status on 29 Nov 2025.", "CONFIRMATION # A3F9K2" with copy icon, price tag "$797.00", NOTES field. "General attachments" holds "Invoice_7139908062.pdf — 0.2/0.2 MB" with a 100% upload progress ring and "+ Add another attachment".
- Expedia trip "Berlin 23 / May 17, 2023 – May 18, 2023": avatar stack + "Invite to your trip"; "Your bookings" list of cards each with photo thumbnail, green "Booked" chip, name ("TITANIC Comfort Berlin Mitte"), "Check in on Wed, May 17", "Itinerary: 72526022283097", overflow menu per card; dark toast "Changes saved" overlaying the list.
- Tripsy trip hub sheet: cards "Itinerary" ("Start organizing your itinerary", "View All Days"), "Documents +", "Expenses" (Flight $850.00, eye toggle), "Latest Added" (EWR → NRT, Narita Tobu Hotel Airport); dismissible promo cards: "Automation — Forward all your reservations to my@tripsy.app and let Tripsy organize everything for you." with "Manage" / "Copy" buttons; "Invite Guests — Add frequent guests. They can view, add, edit and remove items, but you're the admin." with "Share Trip" link; bottom "Customize" button.
- Skyscanner "Trip Details": outbound + return legs each as a card with date header, times "7:46 AM – 6:50 AM+2", "1 stop / 31h 4m", segment chips ("1h 41m — LAX 11h 28m — 17h 55m"), "See Details" links; "Passengers: 1 adult ▾ / Economy Class" beside "Price $744 via United"; "Good to know about this trip — This is one of the cheapest options"; sticky footer "1 offer from $744" + "Continue Booking".

**Problem solved:** One trip object aggregates heterogeneous reservations (flights, lodging, cars, files) with status chips, confirmation numbers, and shared access — the consumer mirror of an ops manager's per-delegate accommodation record.
**Sad paths observed:** none in this set (all happy-state).
**Microcopy worth stealing:** "Changes saved" (toast after booking edit); "CONFIRMATION #" with one-tap copy; "Invite to your trip"; "They can view, add, edit and remove items, but you're the admin." (permission explanation in one sentence); "Forward all your reservations to my@tripsy.app" (email-ingest for bookings — directly stealable for hotel rooming-list ingest).
**A11y/notes:** "+2" superscript on arrival time encodes a date overflow — rooming equivalents (late checkout past event end) need the same compact marker.

## A4 — Notification granularity tiers for someone else's travel (Flighty)
**Apps observed:** Flighty (iOS)
- Flow "Changing friends' flight alert settings": https://mobbin.com/flows/2f515440-2670-40a0-98e5-9b6ab0cc55a7
- Flow "Changing friends' flight alerts": https://mobbin.com/flows/8cc88f56-ec5b-42bf-b687-a86f8f5571ea
- Flow "My flight alerts": https://mobbin.com/flows/a7b48e7b-6c6f-49d0-a6c6-05013d0c6a54

**Anatomy as observed:**
- Settings sheet: ALERTS section with rows "My Flights" and "Friends' Flights"; AUTOMATIONS section: "Calendar Sync", "TripIt Sync", "Add Flights via Email".
- "Friends' Flight Alerts": header copy "Pick the default notifications you receive about friends' flights. Customize this per friend in Flighty Friends." Four mutually exclusive tier cards, each icon + name + one-line scope: "None — No alerts please. I'll just view their flights in the app." / "Just Landed — Only notify me when they land." / "Basics — Add alerts for major disruptions, takeoff, 1h until arrival, and on morning of travel." / "Everything — Every alert. Check-in, gate change, disruptions, landing, baggage, etc." Selected card gets a blue outline. Footer: "To adjust Live Activity preferences for Friends' Flights, visit Settings > Live Activities".
- "My Flight Alerts": toggle list instead of tiers — "Basics — The most critical alerts like gate changes, delays, & cancellations." / "Above & Beyond — Want more? Get alerts on inbound aircraft status, connection assistance, and aircraft changes." / "Flight Plans" / "Arrival Information".

**Problem solved:** Lets a watcher of OTHER people's travel choose alert volume per relationship — exactly the ops-manager/delegate notification problem (who hears about which rooming changes, at what severity).
**Sad paths observed:** disruption/cancellation alerts are an explicit tier ingredient ("major disruptions", "cancellations").
**Microcopy worth stealing:** "No alerts please. I'll just view their flights in the app."; "Only notify me when they land."; "Every alert. Check-in, gate change, disruptions, landing, baggage, etc."; default-plus-per-person override: "Pick the default… Customize this per friend."
**A11y/notes:** Tier names + one-line scope sentences beat raw toggle matrices; severity-tiered defaults with per-entity override is the model to copy for rooming-change notifications.

## A5 — Live status card with delta-from-plan communication (Flighty)
**Apps observed:** Flighty (iOS)
- Flow "Live Activities" (12 screens): https://mobbin.com/flows/7e5b1c0f-fe17-4f5f-ad94-dfd1fc802091
- Flow "Live activities": https://mobbin.com/flows/7b2820c8-0792-4e78-975a-12fc58d60fa0

**Anatomy as observed:** Lock-screen card anatomy: header row "AA171 … FLIGHTY"; origin/destination row "JFK 6:00 AM ··✈·· 8:51 AM LAX" with sub-labels "T8 · On Time" and "1m early"; status banner row that changes color by state — yellow "Gate Departure in 1h 45m / Inbound aircraft has arrived" with gate chip "↗14"; green "Arrived 33m Early / Terminal 4 · Gate 42A" with baggage chip "T4C1"; late state renders times in red with "26m late" / "16m late" under each endpoint and a red progress bar, center caption "13 min, 42 sec PAST GATE ARRIVAL". Stacked notification view groups two flight cards under "Flighty / Show less".
**Problem solved:** Communicates plan vs. reality as a delta ("33m early", "26m late") rather than restating absolute times, with color encoding severity.
**Sad paths observed:** delay state (red, "26m late", "PAST GATE ARRIVAL" count-up) shown explicitly.
**Microcopy worth stealing:** "Arrived 33m Early"; "Inbound aircraft has arrived" (upstream-cause transparency); "Gate Departure in 1h 45m".
**A11y/notes:** Color is never the only channel — every state also has a text delta. Rooming analog: "Room ready 2h early", "Hotel confirmed late checkout".

## A6 — Hopper: hotel book→confirm→manage anatomy, guest-on-behalf picker, support triage
**Apps observed:** Hopper (iOS)
- Flow "Booking a room" (28 screens): https://mobbin.com/flows/c6e0d41a-4675-4019-b1c8-7b4c30b901c9
- Flow "Trip summary (hotel)": https://mobbin.com/flows/fce87f24-b0c5-465a-8f73-dc82f04450dc
- Flow "Manage booking": https://mobbin.com/flows/ebc6e7c9-3f45-4620-b74e-b7d1331aa3c4
- Flow "Contact hotel support": https://mobbin.com/flows/d5f9e07d-95f7-4701-bb80-8fcf8d553e80
- Flow "Tips information": https://mobbin.com/flows/7b995d1f-0ef4-433b-8401-c042fa84648c

**Anatomy as observed:**
- Trips hub: tabs Flights / Stays / Cars; "Watching" (Favorite Hotels, "0 saved hotel(s)"); "Your upcoming stays" card with photo, green "Confirmed" chip, "Moxy NYC Times Square / Mon, Nov 20 - Tue, Nov 21"; cross-sell "Complete your trip — Rent a car in New York".
- Hotel detail: date chip "Nov 20 – 21" in nav, banner "Lower the price of this hotel — LEARN HOW →", "11% off / Includes $25 from Wallet", struck price "$211 $186 / $217 total taxes & fees incl.", price-freeze card "Hold this price for $58" + "Freeze Price" button, primary CTA "View Rooms".
- "Who is booking?" screen: caption "This reservation will be under:", guest rows with avatar "Judy Smith / Adult - 28 y/o" + green check, "+ New Guest", footer CTA "Review & Pay" — explicit guest-record selection, the booking-for-others primitive.
- "Review Details": top checklist item "Free Cancellation until Nov 19 — Cancellations or changes made after Nov 19 2023 4:59 AM (+00:00) are subject to a fee equal to the first 1 night's rate plus taxes and fees."; "Need to Know — At check-in, the hotel may place a temporary hold on your credit card for incidentals."; "Check-in Instructions — Check-in starts at 4:00 PM. Check-out time is 12:00 PM."; "Instructions" bullets (extra-person charges, government-issued photo ID, "Special requests are subject to availability upon check-in and may incur additional charges"); "Selected Dates Nov 20 - Nov 21 (1 night)", "Selected Room: Refundable, Room - 2 Double"; "Trip Extras — Include $5.01 Hopper Tip? Hopper saved you $25.01!"; footer "Continue to payment / Next, you'll be able to choose pay now or pay later."
- Trip Summary (post-booking): hotel photo, "4 stars", name, green "Confirmed" chip + locator "C6V45XV9D4FW"; action cards "Get support / Manage booking" and "Rent a Car"; detail rows Address / "Check In Nov 20" / "Check Out Nov 21" / "Room Type: Room - 2 Double" / "Guest Information: Judy Smith" / "$260.53 with Mastercard 0627"; "More Info: View Property / View Property Info & Policies". Post-booking rating sheet "How did we do today?" with 5 stars + "Skip for now".
- Support triage ("Manage booking"): "Support Level: Basic — Upgrade and speak to an agent within 5 minutes via 24/7 Live Chat or phone" + "Upgrade to VIP Support"; "How can we help you today?" option cards: "Contact the hotel — Contact the front desk for check-in and room questions" / "I'm having trouble with my reservation — Unable to check in or something unexpected with your reservation?" / "I need a refund" / "Cancel or modify reservation — Need to cancel or request changes to your reservation?". Billing triage: "Unexpected charges — See a charge on your card you were not expecting?" / "Other fees, charges, and taxes" / "Hopper Wallet". Self-serve answer page: "Temporary holds will be reversed by your bank within 24-72 hours … If it's been more than 5 business days, we recommend contacting your bank…" with "Does this answer your question? — Yes, this answers my question / No, speak with an agent".
- "Contact your hotel" page: "Please have your primary guest information and reservation dates handy before calling the hotel"; "Hopper confirmation: C6V45XV9D4FW"; "Reservation code: C6V45XV9D4FW"; warning-iconed "Front desk: +1 212-967-6699"; "Need further assistance? … Chat with an agent".

**Problem solved:** Complete lifecycle of an ops-mediated hotel booking: pick guest record → review policy/fees → confirm with locator → triage changes/cancellations/refunds through structured intents instead of free-text support.
**Sad paths observed:** cancellation fee disclosure with exact cutoff timestamp; "Cancel or modify reservation" and "I need a refund" triage intents; "Unexpected charges" path; temporary-hold reversal explainer (failed booking attempt → pre-auth charge).
**Microcopy worth stealing:** "This reservation will be under:"; "Free Cancellation until Nov 19"; "fee equal to the first 1 night's rate plus taxes and fees"; "Special requests are subject to availability upon check-in"; "Does this answer your question? / No, speak with an agent"; "Please have your primary guest information and reservation dates handy".
**A11y/notes:** Two distinct codes ("Hopper confirmation" vs "Reservation code") surfaced side by side — EventState rooming needs the same dual-ID display (internal allocation ID vs hotel confirmation number). Intent-card support triage maps cleanly to delegate change-request intake.

## A7 — Booking.com: date+occupancy picker, room selection with scarcity/occupancy guards, upgrade-and-modify
**Apps observed:** Booking.com (iOS)
- Flow "Booking a property" (21 screens): https://mobbin.com/flows/4b416fa8-669a-410e-a2d5-f76b3e588874
- Flow "Selecting dates": https://mobbin.com/flows/cc8ff7c8-36ab-4176-86ed-11967e0179ae
- Flow "Upgrading a room": https://mobbin.com/flows/b90d6b61-8a82-4fe4-9d49-e7e6dad2d254
- Flow "Property detail": https://mobbin.com/flows/70cc02a9-d3e8-45d0-8b49-3f2481a25193
- Flow "Price information": https://mobbin.com/flows/327a69ce-e7a7-4c48-8e9c-38ae23e59fba

**Anatomy as observed:**
- Search box (Stays tab): three stacked fields — destination, date range "Sat, Mar 7 - Sun, Mar 8", occupancy "1 room · 2 adults · No children", then "Search". After flexible dates chosen the field renders "Tue, Mar 17 - Thu, Mar 19 (± 3)".
- "Select dates" sheet: tabs "Calendar | I'm flexible"; scrolling month grid with range highlight (17–19 filled, 18 mid-range gray); flexibility chips "Exact dates / ± 1 day / ± 2 days / ± 3 days"; summary line "Tue, Mar 17 – Thu, Mar 19 (2 nights)"; CTA "Select dates".
- Results list: header pill "Tokyo, Japan Mar 17 - Mar 19"; Sort / Filter / Map row; count chips "Hotels (1044) / Entire homes & apartments (1678)"; transparency note "Read more on how payments affect the order of listed properties"; property card with rating badge "8.3 Very Good · 76 reviews", distance "8.2 km from downtown", unit anatomy "Entire apartment – 32 m²: 3 beds · 1 bedroom · 1 bathroom", "2 nights: ~~$250~~ $133".
- Property detail: photo grid, "Property highlights" chips (Free Wifi, Wellness Sauna), "Check-in Mon, Mar 16 / Check-out Wed, Mar 18" as editable links, "You searched for: 1 room · 3 adults · No children", "Price for 2 nights (Mar 16 - Mar 18) $92", review-score breakdown bars (Cleanliness 9.0, Comfort 9.1, …) with AI chips "Do guests like staying here?", "Most Popular Facilities" icon grid (Non-smoking rooms, 24-hour front desk, Elevator, Baggage storage), sticky footer "You won't be charged yet" + "Select".
- Room selection ("新宿16 Shinjuku16"): banner "Recommended for 3 adults — 1 x Suite, Non-refundable, Total $287" + "Reserve your stay"; room card "Suite — Bedroom: 1 full bed, 1 sofa bed; Living room: 1 sofa bed; Size: 35 m²" + amenity icons; rate option box "Price for 3 adults / Non-refundable / Pay online / Genius 10% discount / $169 off / ~~$456~~ $287" + "Select"; red-dot scarcity line "We have 1 left"; a grayed sibling rate card overlaid with "These options won't accommodate your entire group".
- Booking overview: "Booking conditions — ✓ Free cancellation before Mar 18, 2026 / ✓ No prepayment needed – pay at the property / More details"; "Your selection — Economy Single Room - Non Smoking, 2 adults"; green check strip "You're booking with free cancellation"; "$44 Includes taxes and fees"; CTA "Next step".
- Payment info: "When do you want to pay? — Pay at the property (selected) / Pay now"; reassurance "Your card won't be charged – we only need your card details to guarantee your booking."; "At the property, you'll pay $44.36"; "How do you want to reserve?" card picker + "New card"; CTA "Book now". Card details sheet: CVC + Billing zip, "Use this card".
- Bookings/trip detail: trip card "Sandusky Mar 19–20, 2026"; booking row "Wolf Inn Hotel / Mar 19–20 · $44.36 / Confirmed" (green); rows "Track your requests >", "Get a better room for just US$11.38 >", "Request invoice >"; below, a "Canceled" (gray) tour booking row.
- "Upgrade room" carousel: "Select your upgrade — Upgrade option 3 of 3 — Double Room with Two Double Beds - Smoking, 9 m², 2 full beds, Terrace, ✓ Free cancellation, ✓ No prepayment needed, + $11.38, Total price of stay: $55.74" + "Confirm upgrade". Success screen: "Your booking has been successfully updated — We sent a confirmation email to alexsmith.mobbin@gmail.com – enjoy your stay!" with updated summary card (hotel, total, dates, new room type) and "View or update details" link.

**Problem solved:** The canonical date-range + occupancy + room-type + rate-condition selection anatomy, plus post-booking modification (upgrade) that ends in an explicit "updated + email sent" confirmation.
**Sad paths observed:** scarcity "We have 1 left"; occupancy mismatch guard "These options won't accommodate your entire group" (option disabled, not hidden); non-refundable vs free-cancellation rate split; a "Canceled" booking shown in-list with status color.
**Microcopy worth stealing:** "You won't be charged yet"; "Free cancellation before Mar 18, 2026"; "No prepayment needed – pay at the property"; "We have 1 left"; "These options won't accommodate your entire group"; "Your booking has been successfully updated — We sent a confirmation email to …"; "Track your requests"; "Request invoice"; "(± 3)" flexible-dates suffix.
**A11y/notes:** Disabled-but-visible rate options with an explanatory overlay beat silent filtering — delegates/ops should see WHY a room type can't take a party of 3. Status chips (Confirmed green / Canceled gray) carried on every booking row.

## A8 — Hopper: hotel cancellation flow with refund-method choice and email confirmation
**Apps observed:** Hopper (iOS)
- Flow "Cancelling a reservation (hotel)": https://mobbin.com/flows/82a9f1e5-aadd-4c95-986d-1378516e931f
- Flow "Cancelling a reservation (car)": https://mobbin.com/flows/ca0dab07-cfd9-4555-a695-e62faa0d5041
- Flow "Manage booking" (Get Help rows): https://mobbin.com/flows/ebc6e7c9-3f45-4620-b74e-b7d1331aa3c4

**Anatomy as observed:** Trip Summary bottom section "Get Help" with chevron rows "Change My Trip" / "Cancel My Trip" / "Contact Support" (change and cancel are separate verbs). Payment block also shows earned credits: "You saved $10.00 with Carrot Cash" / "Congrats, you earned $1.44 in Carrot Cash rewards from this booking!". Support intent list adds "Check-in early/late — Check-in is between 4:00 PM and 4:00 PM local time." "Refund options" screen: header "How would you like to be refunded?", two radio cards each with a timing chip — green "Instant / Get a refund in Carrot Cash" vs gray "Up to 10 days / Get a refund on your original payment method" — selected card outlined green; CTA "Continue". Terminal screen: mascot illustration + "Cancellation complete!" + "A confirmation email will be sent shortly to judy.mobbin@gmail.com" + "Done". Trips hub empty state after cancel: "You have no upcoming stays" + "Plan your next trip — Hotel deals recommended for you".
**Problem solved:** Cancellation as a first-class guided flow: refund method with explicit speed tradeoff, unambiguous terminal state, and email receipt promise.
**Sad paths observed:** the entire flow IS the sad path; plus empty-state recovery after cancellation.
**Microcopy worth stealing:** "How would you like to be refunded?"; timing chips "Instant" / "Up to 10 days"; "Cancellation complete!"; "A confirmation email will be sent shortly to {email}"; separate "Change My Trip" vs "Cancel My Trip" entry points.
**A11y/notes:** Refund-speed chips encode the cost/speed tradeoff visually + textually. For rooming: "Release night back to block (instant) vs request hotel refund (X days)" is the same shape.

## A9 — Navan: ops/admin travel dashboards, group-travel events with booking progress, guest travel
**Apps observed:** Navan (web)
- Flow "Dashboard" (Travel Admin): https://mobbin.com/flows/bd74505f-dcf4-4549-9322-2ad49ad36901
- Flow "Home" (traveler): https://mobbin.com/flows/6041b289-d548-45a6-9ee5-e845c48b3070
- Flow "Manager dashboard": https://mobbin.com/flows/ee7e9df9-9df1-43f2-b543-3d4f5bf20382
- Flow "Admin": https://mobbin.com/flows/6a2419dd-e729-4d17-b9eb-c415948da1ae
- Flow "Analysis": https://mobbin.com/flows/8cff44b7-5516-4eaf-851b-752c3df8637e

**Anatomy as observed:**
- Role switcher in product header: "Navan Admin / Travel Admin / Configuration" vs "Navan Business Travel" vs "Navan Travel Manager" — same product, distinct shells per role. Traveler nav dropdown: TRAVEL — "Book business travel / Book personal travel / Guest travel / Office guides / Manager"; EXPENSE — "Expense"; COMPANY — "Admin". ("Guest travel" = booking for a non-employee, the closest named analog to delegate booking.)
- Traveler Home: hero search "Where to?" with toggle "Business travel | Personal travel" + location field; quick cards "Group travel > Create an event" and "Navan Rewards"; trip card "Singapore Trip / Nov 11 - Nov 12 / Business" with "Manage" button; upsell "Add a hotel, earn rewards" listing 3 suggested hotels; invitation cards: "Vania Sutandi invited you / Expires in 30 days / Jul 1 - Jul 4 / New York Team Sync / [Book now]" and a "Team event" card "Singapore Training / You invited 2 participants. / View details".
- "Group travel (4)" list page: "+ Create group event" button; filters "Offsite dates ▾ / Status ▾"; each event row: photo, name ("SF Tech Summit"), green "In progress" chip, organizer avatar+name, location, date range with "In 98 days" countdown, booking progress "0/3 booked" with progress bar, right column "$0 actual / $3,714 estimated".
- Travel Manager Dashboard: scope filter "My events ▾", "0 Users | Jan 1, 2024 - Jun 3, 2024"; stat cards "Travel spend 0 / Bookings 0"; tab strip "Recent Bookings / Out-of-policy / Active Travelers / Upcoming Bookings"; empty states: "There are no Recent Bookings for this timeframe." and on Out-of-policy: "Nice, no policy offenders in this timeframe!"; footer "View all in Reports".
- Travel Admin Dashboard: date-range + "Point of sale" filters, "Compared to Jan 1, 2023 - Jun 6, 2023"; "Spend overview" chart with stats Travel spend / Savings / Trips / Cashback; "Adoption" card "Registered users 50% — 2 of 4 users have completed their profile and are ready to book." + link "Who's missing?"; "Active travelers 1"; "Satisfaction" card (NPS score, Average chat rating, Median response time); "Out-of-policy breakdown — Hotels 100% (1 bookings) / Rental cars 0%"; "Out-of-policy summary" table grouped by Department/Individual (Out-of-policy %, Bookings, Avg. spend per booking); "Leaderboard — Top savers and spenders" tables.
- Analysis menu: "Travel spend / Flights / Hotels / CO₂ emissions / Traveler Well-being". "Analysis > Hotels": metric cards "Hotels spend", "Price per night (Average)", "Hotel nights (Total)", "Booking lead time", "Savings", "Savings rate", each with info icon and "Include Navan Expense transactions" checkbox.

**Problem solved:** The ops-manager's side of travel: events with N invited participants tracked to booking completion ("0/3 booked"), policy-violation surfacing, and per-hotel spend analytics — the closest Mobbin gets to conference rooming ops.
**Sad paths observed:** "Out-of-policy" as a permanent dashboard tab; empty/zero states everywhere ("There are no Recent Bookings for this timeframe."); invitation expiry ("Expires in 30 days").
**Microcopy worth stealing:** "0/3 booked" progress fraction per event; "$0 actual / $3,714 estimated"; "Who's missing?" (one-click gap list — perfect for "which delegates haven't been roomed"); "Nice, no policy offenders in this timeframe!"; "Guest travel"; "You invited 2 participants."
**A11y/notes:** Booking-completion fraction + countdown ("In 98 days") on each event row is exactly the rooming-block summary row EventState needs (rooms picked up / block size, days to cutoff).

## A10 — TravelPerk: booking FOR a traveler, person records, approval processes with change-tiers, policy templates
**Apps observed:** TravelPerk (web)
- Flow "Adding a traveler": https://mobbin.com/flows/9a4a380d-8c5f-46a5-869c-402d31b57e2b
- Flow "Adding an approval process": https://mobbin.com/flows/64971d3f-f207-4b24-8588-9fb4e87eff98
- Flow "Book a trip": https://mobbin.com/flows/36d7dc8d-fb8f-49a9-beea-16a7a31f89c5
- Flow "Creating a travel policy": https://mobbin.com/flows/27377221-8ff8-49dd-b716-eaa7ae152f14

**Anatomy as observed:**
- Booker home "Hi Sam + Where to next?" with service tabs Flights / Stays / Trains / Cars / Concierge; traveler chips in the search bar ("Sam Lee ×" plus a typeahead "Alex smith" showing "No results found for 'Alex smith' — Can't find someone? Register a new traveler") — multi-traveler, search-by-person booking.
- "Add a Person" modal: Access radio — "No access: Won't be able to sign in to TravelPerk. Trip updates will be sent to the provided email" vs "Allow access: Will be able to sign into TravelPerk to manage their own trips and profile. User email must be unique"; checkbox "Send trip updates to a different email" revealing "Where should trip updates be sent to?"; Personal information: "Enter the following information exactly the same as it appears on the person's ID or passport" (First name, Last name, Sex); Role dropdown "Traveler — Manage own trips and profile"; Account settings: Company, "Travel policy (Premium) — Select a travel policy". Toast on completion: "Alex Smith was added to your account".
- "Approval processes": empty state "Set up approvals for trips — Control your travel spend by choosing the rules for how and when your team's trips are reviewed and approved." Builder: "Is approval needed when booking? Yes/No"; sentence-style rule "Request approval from [select approver] for [select setting] when [cost center] is [select cost center]", approver typeahead with APPROVER GROUPS ("Line manager") and USERS; "+ Add approval rule"; warning "If a user doesn't have an available approver according to this rule, approvals will go to an admin instead." Then "Approvals for changes to booked trips — Select your approval for the requests on trip changes:" three radio cards: "Executive travel — We make all changes when we get the request / We do not send an email notification to the approver / Can upgrade cabin class or add extras without approval"; "Simple reschedule (Recommended) — We make date or time changes and add extras when we get the request / We send an email notification to the approver about requested changes / Can not upgrade cabin class or change origin or destination without approval"; "Admin out-of-hours — All change requests will need approval / Exception if the trip is starting in the next 48h / Exception if the request is sent during the weekend". List page shows process card with "Approval setting: All trips / Trip changes", "Type: Require approval / Executive travel", "Reviewer: Line manager", toast "Approval process created successfully".
- "Travel Policy" templates: cards "Standard policy (Recommended) — The most popular policy with new users", "Strict policy — Tighter budgets and booking windows", "Build your own"; per-service rules visible: "Dynamic budget — Maximum cost 20% over median", "Maximum budget — All destinations $450", "Booking window — No / Anytime" vs "Yes / 7 days before", "Long haul exceptions — Flights over 7 hours $1,500". Wizard steps: ① Name ② Services (checkboxes Flights/Hotels/Cars/Trains) ③ Budget ④ Booking window ("How far in advance should travelers book?" + tip "Booking in advance often means finding better deals!"). Saving requires email verification modal: "Enter your verification code — We've sent an email with a code to samlee@content-mobbin.com. Check your junk or spam if you can't find it."
- "Trips" list: status tabs "Now (0) / Upcoming (0) / Drafts (1) / Past (0) / Canceled (0)"; checkbox "Only my trips"; trip card "Flight to New York / May 26 - May 29 / $905.69 / ID 27039972 / [Draft]", travelers line "Sam Lee, Alex Smith", "Add a label", actions "Share trip / Delete trip / Continue editing".
- Trip payment page: breadcrumb "Itinerary / Payment", "Trip-ID: 27039972", autosave indicator "Saved"; "Travelers" list (Sam Lee, Alex Smith · Male, each "View details"); per-item cards — hotel card "Hampton Inn Ridgefield Park ★★★ / 100 US Highway 46 East / 2x Standard Queen Room (Accessible) / Check-in Mon, May 26 15:00 / Check-out Tue, May 27 11:00 / Free cancellation before 23:59, May 25, 2025 (hotel's local time)"; "Notes on the booking — 'Please make sure the room is accessible'"; right rail: "Invoice to SLMobbin", "Pay with VISA Sam Lee x-2412 — This determines the payment method, currency, and when we send the invoice", Reporting (Cost center, "Label this trip", chip "Business trip ×"), "Price breakdown — Car rental $86.00 / Stay in Ridgefield Park $362.22", "Total $448.22 / Pay in advance $362.22 / Pay on arrival $86.00"; status line "This trip doesn't need approval — Confirm the payment to book the trip now."; checkbox "I understand that I need to use a card in my name and collect the receipt for pay on arrival bookings"; CTA "Confirm payment"; alert "Security verification needed — This card may require a secured verification."

**Problem solved:** Full ops-managed booking pipeline: person records with notification routing, multi-traveler trips, draft states, policy budgets per service, and change-request approval tiers — the closest functional match to conference rooming workflow on Mobbin.
**Sad paths observed:** traveler-not-found typeahead with inline "Register a new traveler" recovery; fallback approver rule ("approvals will go to an admin instead"); out-of-hours/weekend exception logic; "Security verification needed" payment warning; Canceled tab in trips list.
**Microcopy worth stealing:** "Trip updates will be sent to the provided email" (no-login participant — exactly EventState's delegate model); "Send trip updates to a different email"; "Enter the following information exactly the same as it appears on the person's ID or passport"; "We send an email notification to the approver about requested changes"; "Free cancellation before 23:59, May 25, 2025 (hotel's local time)"; "2x Standard Queen Room (Accessible)"; "Pay in advance / Pay on arrival" split; "This trip doesn't need approval".
**A11y/notes:** Accessibility is a first-class room attribute ("(Accessible)" suffix + free-text booking note "Please make sure the room is accessible") — rooming tools must carry accessibility requests through to the hotel export. Sentence-form rule builders read better than form grids.

## A11 — Marriott Bonvoy: reservation detail anatomy, modify-with-diff, preference toggles with non-guarantee disclaimers
**Apps observed:** Marriott Bonvoy (iOS)
- Flow "Reservation details": https://mobbin.com/flows/7331df17-3aa0-48ea-811d-05cd8f8355ae
- Flow "Modify reservation": https://mobbin.com/flows/4d947b98-71d1-4030-97e6-dd5daf6d0d3e
- Flow "Changing preferences": https://mobbin.com/flows/0fd00544-501f-4381-95ce-dbf9ad61d64d
- Flow "Trip detail" (Fairfield Bali): https://mobbin.com/flows/5ae31218-93d9-4b16-9cfb-33cbce703480
- Flow "Trip detail" (Four Points Flex): https://mobbin.com/flows/ca1064bd-bda1-4d3c-b925-e08002d27851

**Anatomy as observed:**
- Trips list: tabs "Current / Past / Cancelled"; stay card with brand photo, "JUL 16–17", hotel name, "Confirmation: 90453112"; footer "Missing a Trip? Look It Up →" (also seen as "Missing an upcoming stay? ⓘ").
- Trip detail (Fairfield): ADDRESS block with tap-to-call phone; "Reservation Details >" summary "Confirmation Number 90453112 / Jul 16–17, 1 Night / 1 Room, 1 Guest / Member Flexible Rate"; "What to Expect" section; ROOM DETAILS card "2 Twin/Single Beds, City View, Guest Room"; Explore rows (Fitness/Spa/Attractions); "Things to Try Nearby"; promotions.
- Trip detail (Four Points Flex): hero "We look forward to welcoming you." with three-column date strip "Wed, Jul 9 3:00 PM | Thu, Jul 10 11:00 AM | 1 Night"; circular action row "Add to Calendar / Get Directions / Share / Modify Reservation"; "Your Reservation — View Details" card "Double 13 sqm Smoking, Guest room, 1 Double / 1 Guest, 1 Night"; row "Modify or Cancel Reservation >".
- Reservation Details deep page: "RATE DETAILS — Member Flexible Rate >"; "SUMMARY OF CHARGES — Sun, Jul 16 975,100 IDR / Service Charge 97,510 IDR / Taxes & Fees 107,261 IDR / Total Stay 1,179,871 IDR"; "Additional Charges — Complimentary on-site parking; Changes in taxes or fees implemented after booking will affect the total room price."; preferences caveat "Please note that not all preferences are guaranteed. Not Guaranteed: Rollaway Bed, Foam Pillows"; "Modifying Your Reservation — Any change in the length or dates of a reservation may result in a rate change."; "Cancellation Policy — You may cancel your reservation for no charge before 11:59 PM local hotel time on Jul 15, 2023 (1 day[s] before arrival). Please note that we will assess a fee of 1072610.0 IDR if you must cancel after this deadline."; bottom rows "Cancel Reservation > / Modify Reservation > / Book Another Room >".
- Modify flow: dark date-picker header "DATES — Tue, Jul 18 / Wed, Jul 19 / Cancel", month grid with filled circles on selected dates, checkbox "My dates are flexible", CTA "Continue with 1 Night". "Confirm Changes" review: hotel name; STAY INFORMATION rows "1 Room, 1 Guest / 2 Twin/Single Beds, City View, Guest Room / Member Flexible Rate"; DATES "Jul 16–17, 1 Night" followed by an orange-flagged "⚠ DATE CHANGE — Jul 18–19, 1 Night" diff row; "Hotel Messages — Rollaway beds are only allowed in Deluxe Corner Pool View rooms at an additional charge."; re-stated Cancellation Policy with NEW deadline/fee; CTA "Book Now 1,061,291 IDR".
- "Edit Preferences": BEDDING PREFERENCES header note "We will do our best to honor bedding preferences but they are not guaranteed."; toggles "Feather free room / Extra feather pillows / Extra foam pillows / Foam pillows / Rollaway bed / Crib or pack and play"; CTA "Save Preferences". Review Reservation echoes "Preferences & Accessibility — Not Guaranteed: Feather Free Room".

**Problem solved:** Reservation modification as a diffed re-confirmation: old vs new dates shown together, with policy and price re-stated at the new terms before commit.
**Sad paths observed:** cancellation fee after deadline (exact local-time deadline + fee amount); rate-change warning on any modification; preferences explicitly flagged "Not Guaranteed"; "Cancelled" trips tab.
**Microcopy worth stealing:** "DATE CHANGE" diff label in Confirm Changes; "Any change in the length or dates of a reservation may result in a rate change."; "before 11:59 PM local hotel time on Jul 15, 2023 (1 day[s] before arrival)"; "We will do our best to honor bedding preferences but they are not guaranteed."; "Missing a Trip? Look It Up"; "Modify or Cancel Reservation".
**A11y/notes:** The change-diff row (old dates struck/normal, new dates orange-flagged) is the single most stealable element for rooming change-handling: every delegate room change should render as before/after with downstream cost. Preference toggles with honesty disclaimers map to roommate/bed-type requests.

## A12 — Seat-map assignment: per-person slot allocation on a spatial grid (rooming-grid analog)
**Apps observed:** Expedia (iOS), Hopper (iOS), Booking.com (iOS), American Airlines (iOS), Trip.com (iOS)
- Expedia flow "Choosing seats": https://mobbin.com/flows/afc57c01-ca26-4030-aa6a-c8eaef2c82ae
- Hopper flow "Selecting flight seats": https://mobbin.com/flows/bb3a8fc0-90c4-4dba-a6a8-70fb9b09c178
- Booking.com flow "Selecting seats": https://mobbin.com/flows/72cb6bf2-bf63-476e-b11d-ea8353685c64
- American Airlines flow "Choosing a seat": https://mobbin.com/flows/2fff83f0-ddc8-4919-9803-d010fd726ac2
- Trip.com flow "Select a seat": https://mobbin.com/flows/64fad1e7-63bb-4283-bfe3-c8de326b5e14

**Anatomy as observed:**
- Expedia: "Review your trip" lists Seat section per leg ("Seat choice included ✓", "Traveler 1: Adult — SFO to JFK: Seat 1A", links "Show more / Change seat", button "Choose your seat"). Seat sheet: leg dropdown "Flight 2 of 2 — New York (JFK) to San Francisco (SFO)", column letters A–F with aisle gap, row numbers, X = unavailable, outlined = available; toast "Seat 1A has been saved. Choose a seat for your next flight."; footer "+$0 / Seats: 1 of 2 selected / Continue".
- Hopper: interstitial "Seat Selection — Your flight comes with free seat selection!… If you decide to skip this step, seats will be assigned at check-in." with per-leg "Choose" buttons and escape hatch "Continue without Seats"; sticky countdown bar "14:53 left to finish your booking!"; seat map with header dropdowns "SIN → JFK Outbound" + person "Judy Smith / 35H", green available + selected "P1" marker, "Seat Legend" overlay ("Standard Seat SGD 0.00 — Choose your favorite seat" / "Unavailable"), footer "SGD 0.00 Total Price / Next flight"; completion state per leg "✓ 35H / Edit" + "Continue to Payment".
- Booking.com: stepper "Select your seats (step 3 of 5)"; per-leg row "San Francisco → Los Angeles / 1h 40m · Frontier Airlines / No seats selected / Select seats from $18.31 >"; map legend "Available seat ($18.31 – $46.31) / Unavailable seat / Selected seat"; bottom sheet on tap: "Seat 3C / $36.31 / Assign seat to: Traveler 1 (adult) / [Assign]"; completion sheet "All set! — All passengers have a seat for this flight. / Next".
- American Airlines: trip-management list "Choose seats / Cancel trip — Review before you cancel / Add bags / Additional services — Wheelchair, infant, service animal, pet and special assistance / Cost summary"; reminder "Check in beginning 24 hours before departure — Time until check-in 6d"; seat map "JFK to ORD" with $ badges on paid seats, passenger slot card "① Seat: --", bottom bar "Seat: 31F · $11 / Available seat / [Select seat]"; "Review and pay — Total: $10.87 Includes all taxes".
- Trip.com: ancillary upsell "Choose your ideal seat and fly in comfort — Seat Selection ✓ Enjoy extra legroom and prime views ✓ Secure your preferred seats in advance — From $12.60 /person [Add]"; payment countdown "Go to Payment 29:57"; price-band chips "$14.40 / $23.80 / $76.80"; passenger slot bar "① LEE/SAM — Seat not selected"; seat tooltip "24F | $23.8 — Aisle seat - easy in and out — 79 cm"; "Check and Confirm" sheet with red warnings "• Cannot be canceled • Invalid after flight tickets have been changed.", "Seat Information — LEE/SAM 24F $23.8", consent radio "I have read and agree to the Seat Selection Policies", CTA "$23.80 Confirm".

**Problem solved:** Assigning named people to constrained spatial inventory: pick-a-person-then-pick-a-slot, with price/availability legend, per-person progress ("Seats: 1 of 2 selected"), and explicit done-state ("All passengers have a seat").
**Sad paths observed:** unavailable-slot X states; paid vs free slots; skip path with consequence ("seats will be assigned at check-in"); booking-session countdown timers; Trip.com non-refundable warnings ("Cannot be canceled", "Invalid after flight tickets have been changed").
**Microcopy worth stealing:** "Assign seat to: Traveler 1"; "All set! All passengers have a seat for this flight."; "Seats: 1 of 2 selected"; "Seat 1A has been saved. Choose a seat for your next flight."; "If you decide to skip this step, seats will be assigned at check-in."; "Review before you cancel".
**A11y/notes:** This is the closest interaction analog to a rooming grid (delegates × rooms): person-slot pairing with a persistent per-person progress tray, legend for slot states, and auto-advance to the next unassigned person. AA's "Additional services — Wheelchair, infant, service animal…" row models special-needs capture.

## A13 — Airbnb: structured reservation-change menu, change-with-payment-delta, full refund breakdown, support intents
**Apps observed:** Airbnb (iOS)
- Flow "Manage a reservation": https://mobbin.com/flows/df2b89af-bd44-4bd4-915e-ade37c5fdf05
- Flow "Changing reservation date": https://mobbin.com/flows/65e58724-9c1e-418c-ac1f-66741fd89c0a
- Flow "Cancelling a reservation": https://mobbin.com/flows/1fc3307f-6975-43c7-a067-5b35865f3dbd
- Flow "Contacting support": https://mobbin.com/flows/d43011f2-abe1-45da-be7b-d2ebd1ac5ff2
- Flow "Editing date pricing" (host side): https://mobbin.com/flows/5984f3df-d889-400f-bbe2-989a44c4434f

**Anatomy as observed:**
- "Reservation details" sheet: "Your group" avatars; "Confirmation code TA9W2N2X"; "Experiences cancellation policy — Get a full refund if you cancel by Aug 2, 9:00 AM (CEST). View"; rows "Manage guests / Manage reservation / Get receipt"; footnote "Info from Hosts has been automatically translated. Show original language".
- Change menu: title "What would you like to change about your reservation?"; rows "Change the date or time / Add guests / Remove guests (grayed-out disabled) / Cancel my reservation (red icon)"; top-right escape "Show reservation".
- Change review: "Here's your new reservation" with new card (date/time, listing, guest count); "Payment details — Original reservation $50.74 USD / New reservation $50.74 USD / Total refund $0.00 USD — Your payment method in 5–7 days"; CTA "Change reservation".
- Cancellation review: "You've paid $201.54 / Your refund $201.54"; "Refund details" itemized "Accommodation — Full refund — $161.00 of $161.00 paid / Service fee — Full refund — $22.73 of $22.73 paid / Taxes — $17.81…"; "Total refund $201.54"; explainer "Your reservation will be cancelled immediately and you will receive your refund to your original payment method within 10 business days."; CTA "Cancel Reservation".
- Stay detail page rows: "Change reservation / Cancel reservation / Get a PDF for visa purposes / Get receipt"; "Getting there" map + "Directions from your host"; "Cancellation policy — Free cancellation before 7:00 PM on Sep 4. After that, the reservation is non-refundable."; "Get support anytime — If you need help, we're available 24/7 from anywhere in the world."
- Support chat (bot): "Hi Sam, let's get you help…" quick replies "I want to cancel my reservation / I want to change my reservation / I want to report a safety or discrimination issue / I'd rather type out my issue"; after choosing change: "Okay, it seems like you want to make a change to your trip. Do any of these look right? — Change dates or number of guests / Change the name on the reservation / Switch to a different listing / Host isn't responding / I need help with something else".
- Host calendar (inventory-owner side): month grid with per-night price under each date ("$303"); day sheet "Fri, Jun 30 — Available ✓/✗ toggle; Pricing: Nightly price $264; 'Guests pay $304 after taxes and fees. You'll earn $255. Preview what guests pay'; Private note — Add"; toast "Nightly price updated"; "Preview what guests pay" sheet itemizing "$264 x 1 night / Guest service fee $40 / Total $304 / Your earnings $255".

**Problem solved:** Reservation change as a constrained menu of intents, each ending in an explicit before/after money delta and refund-timing promise — never a free-form edit.
**Sad paths observed:** disabled change option (Remove guests) shown grayed rather than hidden; immediate-cancel + 10-business-day refund window; non-refundable-after-deadline policy; "Host isn't responding" as a named support intent.
**Microcopy worth stealing:** "What would you like to change about your reservation?"; "Here's your new reservation"; "Original reservation / New reservation / Total refund" triplet; "Get a full refund if you cancel by Aug 2, 9:00 AM (CEST)"; "Get a PDF for visa purposes" (document export for officialdom — same family as rooming-list export); "Your payment method in 5–7 days".
**A11y/notes:** Host calendar = room-block inventory calendar: per-date availability toggle + per-date price + private note is exactly a block-night editor. Intent-chip bot triage mirrors A6's Hopper cards in conversational form.

## A14 — HotelTonight: scarcity-driven inventory feed and policy-dense "Need to Know" pre-purchase block
**Apps observed:** HotelTonight (iOS)
- Flow "Booking a hotel" (20 screens): https://mobbin.com/flows/400a4c75-277b-4360-a686-681be560d3b2
- Flow "Hotel detail": https://mobbin.com/flows/2d16f031-5f51-401c-b791-f28954ddef9e
- Flow "Checking availability by dates": https://mobbin.com/flows/9413c2db-2440-4c9a-a50c-8f28d014d70a
- Flow "Home": https://mobbin.com/flows/88f8fccb-ba3a-4ca6-a26e-2fc09a24c295

**Anatomy as observed:**
- Home feed: header "Where: New York City / When: Tonight / 1 Room · Top Deals"; map with price pins; gamified "Slide to unlock your deal — Today's Daily Drop · 1 unlock per day · 15 mins to book"; hotel cards with tier badges (BASIC / SOLID / HIP / LUXE / HIGHROLLER), live-pressure overlays "29 people viewing this hotel", "2 rooms left", "1 room left", price anchoring "$166 / was on HT $293"; footer "Why these hotels?".
- "Choose Dates" sheet: Check-In / Check-Out columns ("Tue, 18 Oct / Wed, 19 Oct"), month grid, "Continue"; header then shows "When: 18 Oct - 19".
- Hotel detail "Need to Know" block (verbatim bullets): "Rate displayed is per night, per room. Each room is guaranteed to fit 2 people. Extra guests are at the hotel's discretion and may be subject to additional fees." / "Check-in 15:00. Check-out 12:00." / "21+ to book." / "Photo ID and credit card required at check-in." / "100% non-smoking rooms." / "Service fee of $35 per night per room collected by hotel." / "This room may not meet your accessibility needs. Accessibility requests can be made directly to the hotel, and are subject to hotel approval and availability." / "This hotel has smoking and non-smoking rooms. In rare cases, the hotel may not have both options available." / "We do not verify reviews." Amenities list is honest about absences: "No fitness center. / No pets. / No minibar. / No bar onsite. / No breakfast available."
- Checkout: "Promotions — Redeem a code" with modal error "Sorry, this booking does not meet the minimum spend required to use this coupon."; "Add payment method" with inline "Adding" spinner and "Scan Your Card"; final confirm "One More Thing! — Need to know: Your purchase is non-refundable. / This room has 1 bed, and will fit 2 adults. / The hotel may require a credit card or deposit for incidentals." then signature gesture "Trace the Logo to complete your booking and agree to our Terms of Use…".
- Bookings tab: "HT Perks Level 1 — You're $311 away from Level 2"; "Current Bookings" card with photo, hotel, city, date range.

**Problem solved:** Compresses hotel-room purchase into a fast feed while front-loading every policy/fee/occupancy caveat into one scannable "Need to Know" block before payment.
**Sad paths observed:** non-refundable purchase warning at final step; promo-code minimum-spend rejection modal; room-capacity limit ("will fit 2 adults"); accessibility-not-guaranteed disclaimer; scarcity states ("1 room left").
**Microcopy worth stealing:** "Each room is guaranteed to fit 2 people. Extra guests are at the hotel's discretion…"; "This room may not meet your accessibility needs. Accessibility requests can be made directly to the hotel, and are subject to hotel approval and availability."; "One More Thing!"; deliberate-friction confirm ("Trace the Logo to complete your booking…") for irreversible purchases.
**A11y/notes:** Trace-to-confirm is a strong consent ritual for irreversible ops actions (e.g., sending the final rooming list to a hotel). "Need to Know" as a single block beats scattering policies across steps.

## A15 — Hotel loyalty apps: per-stay vs per-profile room/bed preferences, stay card with modify, paid upgrade review
**Apps observed:** IHG Hotels & Rewards (iOS), Marriott Bonvoy (iOS), World of Hyatt (iOS)
- IHG flow "Adding room and bed preferences": https://mobbin.com/flows/5a5a0869-0268-488d-a07e-ed834ff48eda
- IHG flow "Manage stay preferences": https://mobbin.com/flows/1aefdcb9-f1f5-4608-9a25-cab09629e548
- Marriott flow "Changing room and stay preferences": https://mobbin.com/flows/aeb8737b-3746-49ec-afdf-cc1f2075e64a
- Hyatt flow "View a room upgrade": https://mobbin.com/flows/939752f0-99cd-4541-a5d0-e6ee251d1e07

**Anatomy as observed:**
- IHG stay card: hero photo, "Your stay at Kimpton in Miami / 17–18 Jun 2025 / Confirmation #48763666"; rows "Reservation details — 1 night · 2 Double City View — View or modify", "Location", "Manage stay preferences — See preferences for this stay", "Your Club Member benefits". "Set stay preferences" page is scoped to ONE stay (hotel, dates, confirmation number repeated): "Help us to personalise your upcoming visit. Share your preferences and we'll do our best to customise your stay."
- IHG profile-level "Stay Preferences": intro "Let us know what makes you happy, and we'll do our best to personalise your stay."; sections "Room and Bed Preferences — Set elevator proximity, floor location, and more" and "Additional Preferences". Detail page: ELEVATOR PROXIMITY radio "No Preference / Near Elevator ✓ / Away from Elevator"; SMOKING PREFERENCE "No Preference ✓ / Smoking / Non-smoking"; "Save"; success toast "Your updates were saved — We successfully saved your updates."
- Marriott "Preferences" hub: rows "Interests & Passions / Food & Beverage / Room & Stay / Earning & Rewards / Communication / Folio Delivery". "Room and Stay Preferences": "Tell us about your room and stay preferences so that we can help deliver personalized experiences, when available, during your stay…"; rows "Accessibility >", "Room Options — King Bed, Non-smoking, Extra foam pillows", "Room Amenities — Feather free Room, Refrigerator"; "Bed Type" picker "2 Double beds / King Bed / No preference ✓".
- Hyatt Stays tab: "Upcoming | Past"; stay card with "Upgrade" star button, dates "Thu, Nov 28 - Fri, Nov 29", hotel + address, "Check-in 03:00 PM / Check-out 12:00 PM", "Stay Details". "Review Your Upgrade": room photo, "Panoramic King" sell bullets, "Room Type: Panoramic King", "Price/Night US$23* USD x 1 Night / Upgrade Total US$23* USD", footnotes "*Subject to Taxes & Fees" and "An additional US$23 will be included on your hotel bill.", CTAs "Confirm Upgrade / Cancel".

**Problem solved:** Separates durable guest preferences (profile) from stay-scoped requests (this reservation), with chosen values summarized inline on the hub rows.
**Sad paths observed:** none beyond "when available" hedging — preferences consistently framed as best-effort.
**Microcopy worth stealing:** "See preferences for this stay" (stay-scoped override); "we'll do our best to personalise your stay"; "when available, during your stay"; summary-on-row pattern ("Room Options — King Bed, Non-smoking, Extra foam pillows"); "An additional US$23 will be included on your hotel bill."
**A11y/notes:** "Accessibility" as its own top-level preference row (Marriott) — EventState delegate profiles should mirror profile-level defaults + per-stay overrides, both flowing into the hotel export. Note: Hilton Honors did not surface for this query; IHG/Hyatt covered the same ground.

## A16 — Airlines: change/cancel with explicit refund rules, alternative-option price deltas, fare breakdown per person
**Apps observed:** American Airlines (iOS), Trip.com (iOS), Scoot (iOS)
- AA flow "Cancel a trip": https://mobbin.com/flows/339b5c1d-1fdf-446d-903a-2d62adffe299
- AA flow "Basic Economy rules": https://mobbin.com/flows/c5b83f2a-477e-47dd-b891-8413a5b50c0d
- AA flow "Bag and optional fees": https://mobbin.com/flows/ec451756-a6de-43df-b43f-43ca0bfe5e38
- Trip.com flow "Changing flights": https://mobbin.com/flows/a4143fb2-6633-4a14-ae28-086ebaa748e0
- Scoot flow "Fare details": https://mobbin.com/flows/494a8536-6f73-42da-9f5e-7fc31808621a

**Anatomy as observed:**
- AA "Your trip summary": leg card with date, times, "Nonstop", fare class "Basic Economy", buttons "Details | Change"; "Total amount due $110.48 (All passengers)"; expandable "Cost details" (Fare $88.54 / Taxes and fees $21.94); link "Bag and optional fees" → fee matrix table (rows = regions, columns = Basic Economy / Main Cabin / Premium Economy / Business, values "$40* / $0").
- AA "Cancel your trip for a refund?": info banner "You can cancel for all passengers within 48 hours 9 minutes for a refund." (live countdown of the free-cancel window); "Refund rules" prose: "You have up to 24 hours from the time of ticket purchase to receive a full refund if you booked at least 2 days before departure. / If you make a change after 24 hours, a change fee and any difference in fare may apply. / If you don't want to cancel for all passengers, please call Reservations. / Certain charges, like Mileage Multiplier, are not eligible for a refund."; buttons "Cancel for a Refund / Go back".
- AA booked confirmation: green banner "Your trip is booked"; "Important information about your Basic Economy fare — View Basic Economy rules"; "We'll email your confirmation shortly."; "£87.40"; "Record Locator: KUIKKN / Trip name: JFK/ORD"; Passengers section "Ticket number… Status: Ticketed" (green). Basic Economy rules page: "Within 24 hours… changes and refunds to the original form of payment are not allowed [after]"; "Same-day travel — …same-day confirmed changes on select flights for a fee".
- Trip.com flight+hotel bundle: numbered sections "① Flight — Change Flight" / "② Hotel"; flight change picker: current "Selected" option pinned at top "+$0", alternatives listed with per-person price DELTAS ("-$2", "+$4", "-$5") instead of absolute prices, tag "Cheapest nonstop", red-eye marker "05:50+1"; detail sheet "Departure Flight … Round-trip Price -$2/person Incl. taxes & fees / Continue"; hotel cards carry "Free hotel cancellation before 12:00, March 14" and "Children Stay for Free" chips.
- Scoot "RETURNING FLIGHT": date strip with cheapest-per-day prices ("Sat, Jul 27 $101.94 / Sun, Jul 28 $147.55 / Mon, Jul 29 $85.93"); option cards with times, aircraft, flight number, price, scarcity chip "10 seat(s) left"; legal line "Flights are subjected to regulatory approval. Fares are not guaranteed until Scoot confirms your booking and payment is made in full."; "Fare details" sheet: "Breakdown per adult / per child / per infant" (base fare + baggage per segment), "Fees & Taxes" itemized by authority, "Total Amount USD1,105.80".

**Problem solved:** Change/cancel decisions made with full price-consequence transparency: countdown to free cancellation, per-alternative deltas relative to the current choice, and per-person fare decomposition.
**Sad paths observed:** change fee + fare difference disclosure; refund-ineligible items called out; partial-party cancellation handled by phone only ("If you don't want to cancel for all passengers, please call Reservations." — a sad path consumer UIs punt on, which ops tooling must solve in-product); "+1" overnight arrival marker; regulatory-approval fare caveat.
**Microcopy worth stealing:** "You can cancel for all passengers within 48 hours 9 minutes for a refund."; delta pricing "+$0 / -$2 / +$4" on alternatives; "Review before you cancel"; "Record Locator"; "10 seat(s) left"; "Fares are not guaranteed until … payment is made in full."
**A11y/notes:** Delta-priced alternatives are the right model for room-move proposals ("Move Dr. Chen to Hilton: +$40/night"). Live countdown on the free-change window maps to block cutoff dates.

## A17 — Navan/KAYAK web: guest-invite roster table with per-service permissions, exportable bookings report, admin hub
**Apps observed:** Navan (web), KAYAK for Business (web)
- Navan "Guest travel" roster: https://mobbin.com/screens/878d11cb-1955-424d-b832-1e0c66cbb85a
- Navan "Guest travel" roster (bulk-select state): https://mobbin.com/screens/48f104b2-7d41-4a5e-ab99-d67325ee7cab
- Navan "Reports > Bookings": https://mobbin.com/screens/8e7e53ea-087b-4c54-8ccb-3a9823b4ac2c
- Navan "Reports > Bookings" (saved reports empty state): https://mobbin.com/screens/e0233e02-3bd6-4bbe-92df-fd10f2377bb5
- Navan "Group travel (2)" with organizer-update toast: https://mobbin.com/screens/896cdeda-685c-41b5-83df-d5e070f64d07
- Navan Reports > Cashback menu: https://mobbin.com/screens/e83130ff-92e3-43b3-8f53-9f5d360d4336
- KAYAK for Business "Admin hub": https://mobbin.com/screens/61f4c50b-7a41-41fd-9663-8f9fd08b4340

**Anatomy as observed:**
- Navan "Guest travel" page: title + "Invite guest" primary button; search "Invite name"; filter dropdowns "Inviters / Guests / Invite status"; "Download" link; table columns: checkbox | Invite name ("Training Workshop") | Inviter | Guest name | Flight | Hotel | Car | Train | "Booking status and actions" — service columns hold per-guest permission values "Allowed / Not allowed", status cell "• Invited" plus per-row icon actions (link, edit, email, duplicate, delete). Selecting rows reveals a bottom bulk bar: "Invites selected (1) — [Send a reminder] [Revoke invites]". Success toast top-right: "Successfully resent invite email."
- Navan "Reports > Bookings": description "The booking report contains all booking costs paid through the Navan Travel platform. Download a transaction report to view an itemized list of charges, including ancillaries, voids, and refunds."; "Saved reports — Select ▾" (empty state "Nothing saved yet — Save a report and it will appear here."); filter row "Booking date / Travel date / Booking status / Department / Purpose / Traveler / Type / More"; links "Save and schedule report | Download Invoices Overview"; Summary strip per category ("Rental Cars SGD89 · 1 Bookings · 0% Out-of-policy | Hotels SGD512 · 1 Bookings · 100% Out-of-policy"); table controls "Rows per page / Columns / Download (purple primary)"; columns include Invoice, Booking date, Point of sale, Type, Booking ID, Confirmation number, Vendor, Preferred vendor.
- Navan Group travel list (organizer change): toast "The event organizer has been updated." — event ownership is mutable.
- Navan Reports menu: "Bookings / Carrier share / Reconcile / Rewards / Cashback / Unused airline credits"; cashback ledger row "Earned from hotel booking IWXRBX — Pending — $5.87".
- KAYAK for Business "Admin hub": card grid "Company information / Flight rules & policies — Set spend limits for flights / Hotel rules & policies — Set spend limits for hotels / Car rules & policies / User management — Manage users' accounts, roles and groups / Approvals — Configure approval settings / Payment methods — Decide how travelers pay / Trip reporting fields — Customize required booking information / Integrations — Configure SSO, Expensify, and Slack / Homepage messages — Display messages for your travelers / Account permissions"; sidebar mirrors cards plus "Traveler tracker" and "Trips to approve"; link "Relaunch quick-start guide".

**Problem solved:** The roster-of-invitees-with-statuses table and the exportable bookings report — the two ops artifacts a rooming module must produce (delegate rooming roster; rooming-list export to hotels).
**Sad paths observed:** revoke invites (bulk); reminder nudges for non-responders; "Out-of-policy 100%" surfaced in the export summary; "Pending" money states.
**Microcopy worth stealing:** "Booking status and actions" column header; "Send a reminder / Revoke invites" bulk bar; "Successfully resent invite email."; "Save and schedule report"; "Download a transaction report to view an itemized list of charges, including ancillaries, voids, and refunds."; "Trip reporting fields — Customize required booking information".
**A11y/notes:** Per-service Allowed/Not-allowed columns = per-delegate entitlement matrix (room type, nights, plus-one). "Save and schedule report" is the recurring rooming-list-to-hotel email pattern. Status dot + verb-noun action icons per row keep wide tables scannable.

## A18 — Actual room-block ops: Expedia Groups portal, Booking.com extranet inventory, TravelPerk event accommodation CSV, Navan recommended hotels
**Apps observed:** Expedia (web), Booking.com (web, extranet), TravelPerk (web), Navan (web)
- Expedia group-rates landing + RFP form: https://mobbin.com/screens/aed0c5ef-1789-44a9-a942-e56e7c2e1c49 and https://mobbin.com/screens/bed141d2-94fd-4d21-9980-0a66e0a0da19
- Expedia group request "My Details" dashboard: https://mobbin.com/screens/e402101c-86bc-4441-90b8-635b11dc2fda
- Booking.com property-extranet calendar (Rooms to Sell / Room Status): https://mobbin.com/screens/2b3af48a-084e-4dea-baf6-bf49f9eae22e
- Booking.com hostel availability table (web booking side): https://mobbin.com/screens/62a4e3c6-22eb-425e-a710-46796944c22a
- TravelPerk Events > Accommodation tab: https://mobbin.com/screens/ea97d85e-684c-4dc7-afa1-1fea0c1c5165
- Navan group-event edit, "Recommended hotels": https://mobbin.com/screens/3cb2ef70-ef08-48fd-83a9-e903d936215b and https://mobbin.com/screens/4540d0f6-a1de-4b6e-b916-24edbd1c112f

**Anatomy as observed:**
- Expedia Groups landing: headline "Get group hotel rates for Sports Teams, Weddings, Meetings or Any Event! It's completely FREE!"; subhead "Get competing quotes fast as hotels bid for your group business."; RFP form "Success!" panel: "WHAT IS THE NAME OF YOUR EVENT/GROUP?", "WHO WOULD YOU LIKE TO SEE OFFERS FROM? — All hotels matching my request (recommended)", "ROOM TYPE(S) — 2 Double Beds (1-2 People) + Edit details", "MEETING/BANQUET SPACE REQUIRED? YES + Add More"; "Add Meeting Space" sub-form (Type "Banquet - 5'", No. of People 30, Min. Room Size 361 sq. ft., Day "First day", Time "9:00AM for 3 hours", amenity checkboxes Coffee/Tea Setup, Food/Beverage, Projection Equipment, WiFi…) with example-layout diagram.
- Expedia group request "My Details" page: left buttons "Stop Hotel Bidding / Low Price Guarantee / Modify Request"; fields "Reservation ID 7835367 / Status: Active / Event Name: SLMobbin / Agent Assigned: Liz Grantham … 1-888-316-5686 x324 / Type: Business Meeting / Itinerary: San Francisco, CA — July 01, 2024 (Mon) - July 05, 2024 (Fri) (4 nights) / Rooms per night: 10"; nightly room-count grid by room type: "2 Double Beds (1-2 People) — Jul 01: 9, Jul 02: 9, Jul 03: 7, Jul 04: 7"; "Star Rating Target 3-5 Star / Budget Range (per night) $250.00 - $339.00 / Space Requirements (Banquet - 5', 30 People, 361 square feet, First day: 9:00AM 3 hours…)"; tax hint "Paying as a Group? You may be tax exempt."; "Your custom event page (instant booking) — Below is an event page for you with specially negotiated group rates that you can send to your guests WITHOUT setting up a group hotel block… https://Groups.Expedia.com/EventPage7835367 — Customize This Page / Invite Attendees"; results bar "List View / Map View / Grid View — Showing 193 of 193 Hotels".
- Booking.com extranet (hotel-owner side): "Calendar" with date-range pickers, weekday checkboxes "Which days of the week do you want to apply changes to? Mon…Sun"; per-room-type tabs ("Two-Bedroom Apartment | Multiple room types"); month strip showing per-day "Room status" (green "Bookable", red blocked), "Rooms to Sell" counts, "Net Booked", per-rate-plan prices (Standard Rate US$200, Non-refundable US$180); right panel accordions: "Rooms to Sell — Update the number of rooms to sell for this room type" / "Prices — Edit the prices of any rate plans for this room" / "Room Status — Open or close this room: ◯ Open Room ● Close Room — Changes will be made to the date range: Jun 11, 2023–Jul 11, 2023 [Save changes / Cancel]" / "Restrictions — Edit, add or remove restrictions for any rate plan for this room".
- Booking.com hostel "Availability" table (dorm beds): columns "Accommodation Type / Sleeps / Price for 2 nights / Your Choices / Select Beds"; rows "Economy Class Pod in 6 Bed Mixed Room — 1 bunk bed" vs "…6 Bed Female Room"; per-row attribute chips ("Entire unit wheelchair accessible", "Upper floors accessible by elevator"); choices column "✓ Free cancellation before June 28, 2023 / Flexible to change / Non-refundable"; bed-count stepper "1 ▾"; tooltip card "Nap York Central Park Sleep Station — Economy Class Pod in 6 Bed Mixed Room — Total length of stay: 2 nights — Check-in: Monday, July 3, 2023 / Check-out: Wednesday, July 5, 2023 — Great choice! Just 2 minutes to finish your booking." (shared-room/dorm inventory = roommate-pool analog).
- TravelPerk "Events": event header "SLMobbin Company Party / May 26 – May 28 / New York, NY, USA / Everyone at SLMobbin can see and attend this event / [Edit event]"; tabs "Overview / Transport / Accommodation / Settings"; Accommodation tab = "Summary" table (columns Hotel / Check-In ⇅ / Check-Out ⇅ / Travelers) with row "Hampton Inn Ridgefield Park, 100 US Highway 46 East — Mon, May 26 — Tue, May 27 — [avatar chips S, A] >" and button "Download csv" — a literal rooming-list export.
- Navan group-event edit: "Recommended hotels (optional) — Participants will see your recommended hotels when booking." with hotel cards (star tier, Lodging Collection badge, review score, distance, "$61 nightly rate per room", removable ×), search "Search to add a recommended hotel", counter "2/6 recommendations added"; "Participant notes" feeding the event invitation page; "Delete draft — Event drafts can't be recovered after they're deleted."; sticky unsaved-changes bar "You have unsaved changes — [Revert] [Save changes]"; toast "Event has been saved."

**Problem solved:** The genuine room-block lifecycle: request N rooms/night across dates and room types → hotels bid → shareable event booking page for attendees → per-night inventory management (open/close, counts, restrictions) → per-event accommodation roster exported as CSV.
**Sad paths observed:** "Stop Hotel Bidding" (kill an RFP); declining nightly counts mid-stay (10→9→7 grid models partial-stay inventory); "Close Room" state; non-refundable rate restrictions; unrecoverable draft deletion warning; unsaved-changes guard bar.
**Microcopy worth stealing:** "Rooms per night: 10" + per-date-per-room-type count grid; "Get competing quotes fast as hotels bid for your group business."; "…group rates that you can send to your guests without setting up a group hotel block"; "Invite Attendees"; "Rooms to Sell"; "Open or close this room"; "Which days of the week do you want to apply changes to?"; "Participants will see your recommended hotels when booking."; "2/6 recommendations added"; "Download csv"; "Paying as a Group? You may be tax exempt."
**A11y/notes:** Expedia's nightly grid (room type × date → count) is the exact data shape of an EventState room block; Booking.com's extranet shows the hotel-side mirror (counts, open/close, restrictions, bulk apply by weekday). TravelPerk's Accommodation tab proves the export artifact is a sortable hotel/check-in/check-out/travelers table.

## A19 — Change-notification feeds and shared live trip status (Air NZ, Qantas)
**Apps observed:** Air NZ (iOS), Qantas Airways (iOS)
- Air NZ "Notifications" feed: https://mobbin.com/screens/118195ff-27e2-4fab-8ec4-741446a6e310
- Qantas shared trip status: https://mobbin.com/screens/55098d36-9332-44c2-908a-3831055432c1

**Anatomy as observed:**
- Air NZ Notifications: stacked cards, each with a context chip ("AKL to SIN · NZ284" or "Airpoints"), relative timestamp ("• 6 hours ago", "2 months ago", unread dot), body sentence, and an inline action button per type ("Check in", "Learn how to connect"). Change item verbatim: "Flight change. Your flight on Fri 31 Oct 2025 now leaves 10 minutes later at 11:20 AM." with chevron to detail.
- Qantas shared-trip screen: hero "Sydney to Dallas Fort Worth / Sat, 27 Dec · 15h 25min"; pill button "⊘ Stop sharing trip"; "Check-in opens Fri, 26 Dec at 14:05" row; status card: big times "14:05 → 12:30" each tagged "Scheduled", terminals, "Gate –", "Boarding 13:20", "Baggage Carousel –" (dashes for not-yet-known values); "Operated by Qantas Airways"; freshness stamp "Updated just now".

**Problem solved:** Communicating a change as old-vs-new in one sentence, inside a per-booking feed where every notification carries its booking context chip and a one-tap next action; plus a revocable shared live view of someone's trip.
**Sad paths observed:** schedule-change notification; unknown-yet fields rendered as "–" rather than hidden.
**Microcopy worth stealing:** "Your flight on Fri 31 Oct 2025 now leaves 10 minutes later at 11:20 AM." (delta + new absolute value in one line); "Stop sharing trip"; "Updated just now"; "Check-in opens Fri, 26 Dec at 14:05".
**A11y/notes:** The change sentence formula (what changed, by how much, new value) is the template for delegate-facing rooming-change emails. Share-with-revoke maps to giving a hotel a live rooming-list link.

## A20 — No-availability / sold-out / can't-quote states across hotel apps
**Apps observed:** SIX (iOS), Shangri-La Circle (iOS), Marriott Bonvoy (iOS), IHG Hotels & Rewards (iOS), Vrbo (iOS), Hopper (iOS), Lyft (iOS, rental analog)
- SIX room detail, unavailable: https://mobbin.com/screens/44a50144-a889-475e-8284-2a5e02944f25 and https://mobbin.com/screens/4b862ec9-655f-4d54-b9ab-6a2b2cf006ff
- Shangri-La no-rooms message: https://mobbin.com/screens/c3fa2b2c-7a34-48a9-b53d-ad3843788b19
- Marriott offer-unavailable toast: https://mobbin.com/screens/f597101d-4b00-4819-85e3-b19b7ad32746
- IHG points-shortfall sheet: https://mobbin.com/screens/a208fffa-5d70-419d-a1a8-7aaa041b1a48
- Vrbo quote failure: https://mobbin.com/screens/9ed3acc2-a741-41b5-a9c1-a99c031e70ca
- Hopper zero-results modal: https://mobbin.com/screens/303cff79-5239-4e44-a4c7-cb8b8a93bfc0
- Lyft rental sold-out banner: https://mobbin.com/screens/fe4be35c-fb32-4c18-b9ab-8e4db272b144

**Anatomy as observed:**
- SIX room page keeps the full room sell-page intact but: date row "Dec 3 - 4 [+]", warning lines "No availability for the selected dates ⚠ / There's high demand for this hotel ⓘ", and the CTA replaced by a disabled "⚡ ROOM NOT AVAILABLE" button — dates remain editable in place.
- Shangri-La: inline under the room card — "We're sorry, there are no rooms available for the dates you selected. Please try our other dates." plus persistent "Email Us / Call Us" escape hatches and reservations phone/email above.
- Marriott: black toast over the room list — "The offer you selected is not available for the dates you selected." (rate-level, not hotel-level failure).
- IHG points list (rates as "17,000 PTS + 299 USD / night" with filter chips "1 bed / 2 beds / Suite / Accessible"): bottom sheet "YOU NEED MORE POINTS TO BOOK THIS STAY — This room rate is priced at 17,000 PTS + 299 USD per night. You need more points to book this room for your length of stay." + "Got it".
- Vrbo: red-icon inline alert in the Availability section "Oops… Unfortunately a quote cannot be c[ompleted]" with Check-in/Check-out/Guests fields right below for correction, footer CTA flips to "Check availability".
- Hopper: modal with sad mascot "Hmm. We Can't Find Any Hotels. — These may be very popular travel dates, or we're having some technical issues. Check back in a bit." + "Close".
- Lyft (rental): top banner "Sold out for 5/27-5-28 — Please change rental dates or times", calendar still interactive, totals row reads "Est. total — Sold Out", CTA becomes "Change car" (redirect to alternative inventory).

**Problem solved:** Communicating zero availability without dead-ending: state the cause, keep the date controls live, and offer a concrete next action (other dates, other inventory, or human contact).
**Sad paths observed:** entire entry is sad-path: hotel-level, rate-level, currency/points-shortfall, quote-engine failure, and sold-out-with-alternative variants.
**Microcopy worth stealing:** "There's high demand for this hotel"; "The offer you selected is not available for the dates you selected."; "You need more points to book this room for your length of stay."; "Please change rental dates or times"; "These may be very popular travel dates, or we're having some technical issues."
**A11y/notes:** Best versions keep the form editable in situ and disable only the CTA, labeling it with the reason ("ROOM NOT AVAILABLE") instead of a generic "Continue" that errors later. Rooming analog: block-full states should name the constraint and offer the next hotel.

## A21 — Airbnb: shared-room privacy taxonomy (room-sharing language)
**Apps observed:** Airbnb (iOS)
- Listing-type step: https://mobbin.com/screens/f44f2d94-0764-493e-8a8b-a3d42f2acd99
- Room-type detail step: https://mobbin.com/screens/7c9145ed-90f0-4c17-b248-f3adb64acee5
- Matching variant ("Will guests have the place to themselves?"): https://mobbin.com/screens/101c77f1-69ea-4c4c-a582-a092ed55fee9

**Anatomy as observed:** Host onboarding card-radio: "What type of place will guests have? — An entire place: Guests have the whole place to themselves. / A room: Guests have their own room in a home, plus access to shared spaces. / A shared room: Guests sleep in a room or common area that may be shared with you or others." Follow-up: "Private room — Guests have their own private room for sleeping. Other areas could be shared." vs "Shared room — Guests sleep in a bedroom or a common area that could be shared with others." plus "Is this set up as a dedicated guest space? — Yes, it's primarily set up for guests / No, I keep my personal belongings here". Matching variant: "Will guests have the place to themselves? — Yes, the place is all theirs / No, the place is shared / [Get matched]".
**Problem solved:** Plain-language taxonomy for degrees of room sharing — the vocabulary a rooming module needs for single/twin/shared allocations and roommate disclosure.
**Sad paths observed:** none (definitional screens).
**Microcopy worth stealing:** "Guests have their own room in a home, plus access to shared spaces."; "may be shared with you or others"; "Will guests have the place to themselves?"
**A11y/notes:** Each option = name + one-sentence consequence; delegates being placed in shared twins deserve the same explicit disclosure language. (Note: dedicated roommate-matching apps did not surface on Mobbin — this query otherwise returned off-domain social apps.)

## A22 — TravelPerk Events: event object with participants roster, RSVP states, updates feed, group-booking escalation
**Apps observed:** TravelPerk (web)
- Flow "Creating an event": https://mobbin.com/flows/b7261e82-af4d-4416-9923-0c68c78aace1
- Flow "Events": https://mobbin.com/flows/2e2fe01b-2540-40d7-a35c-60bb6a4013e9
- Flow "Inviting a teammate": https://mobbin.com/flows/eb294206-5e1c-4834-81eb-a2ac17766329
- Flow "Adding an update": https://mobbin.com/flows/619726aa-f3e7-4aaf-813b-67e0d656d0bf

**Anatomy as observed:**
- Events list: "Create event" button; info banner "Need 9 or more rooms for your group? Request a group booking — To request group travel, contact us and our dedicated in-house team of Meetings and Events experts will handle everything from start to finish. We negotiate and secure the best rates for you using our relationships and buying power." (the 9+ rooms threshold where self-serve hands off to humans); tabs "Upcoming / Past"; month-grouped event cards with green "Attending" chip, dates, name, location, participant avatars + names.
- "Create an event" form: header "Are you organizing a team gathering, or a group trip? Start your event in just a few clicks!"; fields Event name* (placeholder "e.g. Quarterly team building"), Dates (Start – End), Location ("Search cities, hotels or points of interest"); "Event privacy" radio: "Company event — Everyone at SLMobbin can see and attend this event" / "Private — Only invited people can see and attend this event"; CTA "Create event".
- Event page: header (dates, name, location, privacy line, "Edit event"); tabs "Overview / Transport / Accommodation / Settings"; Overview "About" rich-text editor with Save/Cancel; "Book or add a trip" card with service buttons Flights/Stays/Trains/Cars and "Have you booked something already but you can't see it on this page? — Add existing trip"; "Participants" panel: "Download csv" + "Invite" buttons, search, RSVP tabs "Attending 2 / Invited 0 / Not attending 0", "Send message ▷", participant rows with avatar, name, "DRAFTS" status label + per-service icons (bed, car), right chip "Organizer"; "Updates" panel: "+ New update" → modal "Add an update — Let participants know the latest details with updates." textarea (char counter "28/2500"), checkbox "Pin this update to the top", posted update shows author, timestamp, body "Stays and car rental booked!", "Edit / Delete".
- "People" admin table: search by name/email; filters Role / Company / Cost center / "+ Add filter"; links "Export people | Invite people"; tabs "Active (2) / Invited (1) / Archived (0)"; columns Name (avatar+email) / Role (Traveler, Admin) / Company / Cost Center / Approval Process; invited external user row carries gray "External" badge; modal on inviting external email: "External email — We recommend assigning an approval process to people using external emails to avoid spend risks. You can do this at any time from their profile." + "Don't show this message again / Return / Confirm".

**Problem solved:** A conference-shaped event object: who's invited, who's attending, what each person has booked (per-service status on the roster row), broadcast updates to participants, and CSV export of the roster — with a human-desk escalation once a group needs 9+ rooms.
**Sad paths observed:** "Not attending" RSVP bucket; "DRAFTS" (booked-nothing-yet) participant status; external-email spend-risk warning; group size exceeding self-serve threshold routed to a managed service.
**Microcopy worth stealing:** "Need 9 or more rooms for your group? Request a group booking"; "Have you booked something already but you can't see it on this page? Add existing trip"; "Let participants know the latest details with updates."; "Pin this update to the top"; "Only invited people can see and attend this event"; "Download csv".
**A11y/notes:** Roster row = avatar + RSVP + per-service booking icons + role chip: a compact rooming-status row (delegate + room booked? + nights + role). The Updates feed is the missing broadcast channel most rooming spreadsheets lack.

---

## COVERAGE NOTE

**Honesty caveat:** the harvesting agent stalled (stream watchdog, no recovery) after recording A22, BEFORE running its two final dryness probes and before writing this note. This note was reconstructed by the orchestrator from the recorded entries; queries are INFERRED from the patterns captured, not verbatim logs. Treat the sweep as one-dryness-probe short of the loop-until-dry standard.

### Apps covered (verifiable from entries)
- Trip management: Tripsy, Wanderlog, Pangea, Skyscanner (A1, A3) — TripIt itself NEVER surfaced in results; trip-timeline coverage came from substitutes. Flag: TripIt absent from Mobbin or not returned.
- Flighty: A4 (notification tiers for others' travel), A5 (live delta-status cards) — both target flows captured.
- Hopper: A6 (full book→confirm→manage→support anatomy), A8 (cancellation w/ refund-method choice), A12 (seat maps).
- Booking.com: A7 (date+occupancy+room selection+upgrade), A12 (seat assign), A18 (extranet inventory + dorm-bed availability table).
- Expedia: A3, A12, A18 (Groups RFP/bidding portal — strongest block-ops find).
- Navan: A9 (role-shelled ops dashboards, group events "0/3 booked"), A17 (guest-invite roster, exportable bookings report), A18 (recommended hotels).
- TravelPerk: A10 (book-for-traveler, person records, change-tier approvals, policy templates), A18 (Events Accommodation CSV), A22 (Events object: roster, RSVP, updates feed, 9+ rooms escalation).
- Marriott Bonvoy: A11 (modify-with-diff), A15 (preferences), A20. IHG + Hyatt: A15. Hilton Honors NEVER surfaced (noted in A15) — IHG/Hyatt covered equivalent ground.
- HotelTonight: A14. Airbnb: A13 (change menu, refunds, host calendar), A21 (shared-room taxonomy). Airlines (AA, Trip.com, Scoot, Air NZ, Qantas, SIX/Shangri-La/Vrbo/Lyft for sold-out states): A16, A19, A20.

### Known gaps / not swept
- TripIt: not returned by any query — its trip-timeline job covered via Tripsy/Wanderlog/Pangea proxies.
- Hilton Honors: absent; IHG/Marriott/Hyatt are the loyalty-app evidence.
- Dedicated roommate-matching apps: none on Mobbin (A21 note) — FIRST-PRINCIPLES CANDIDATE, consistent with by-flow note.
- Final 2 dryness probes not run (agent stall) — residual risk of a missed late-tail pattern is nonzero but low: A20–A22 probes were already returning mostly repeats per the agent's last status.
