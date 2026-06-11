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
