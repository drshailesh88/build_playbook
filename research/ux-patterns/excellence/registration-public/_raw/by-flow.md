# BY-FLOW Mobbin Sweep — Public Event/Conference Registration + Post-Registration Lifecycle

Job-to-be-done: "register as an attendee for an event via a public form, and receive confirmation with a ticket/QR code"
Source: Mobbin MCP (search_flows primary, search_screens for zoom-ins). Only observed patterns recorded.
Date: 2026-06-11

---

## Q1: "register for a conference as an attendee fill out registration form" (web)

### Luma — "Registration" (organizer-side registration config; reveals attendee lifecycle states)
- Mobbin URL: https://mobbin.com/flows/826ad04c-98f6-4f68-ac83-76af66479d46
- Steps observed:
  1. Event workspace > Registration tab: cards for "Registration: Open", "Event Capacity: 1,000 · Waitlist On", "Group Registration: Off"
  2. Tickets section: ticket type "Standard — Free" with amber "Require Approval" badge; "+ New Ticket Type"; Stripe upsell ("Start Selling. Collect payments by creating a Stripe account... Set up in under 5 minutes.")
  3. Registration Emails: THREE lifecycle email templates side by side — "Pending Approval / Waitlist" (grey check), "Going" (green check), "Declined" (red X)
  4. Registration Questions builder: "Personal Information" (Name Required, Email Required, Phone Off), "Web3 Identity" (ETH/SOL Address Off), "Custom Questions" + Add Question
- Problem solved: one config surface that defines the entire attendee lifecycle — open/approval/waitlist/declined — with a dedicated email per state.
- Sad paths revealed (as states the attendee can land in): pending approval, waitlisted, declined.
- Microcopy: "Customize the emails sent when a guest registers for the event and for when you approve or decline their registration." / "We will ask guests the following questions when they register for the event."
- Variant (Morning Yoga / sessions event) shows email names "Registration Received / Registration Approved / Registration Rejected" and helper copy: "We always ask guests for their name and email." — name+email are non-negotiable baseline fields.
- Also seen on event Overview: registration card on public page preview shows "Approval Required — Your registration is subject to approval by the host." + "Welcome! To join the event, please register" + shareable short link (lu.ma/...) with COPY button.

### Sana AI — "Signing up for an event" (public conference/webinar registration, no account)
- Mobbin URL: https://mobbin.com/flows/fa611f11-295f-435d-aa78-9d6efdf24740
- Steps observed:
  1. Events listing page: city/format badge (Copenhagen / Webinar / London), date+time, title, venue address
  2. Event detail: date/time, big title, venue line, descriptive paragraphs, "Speakers:" list (name, role, company)
  3. Scroll to inline registration form ON the event page (no separate page): Email*, First name*, Last name*, Company name*, Job title*, "Food preferences or allergies" (free text), marketing-consent checkbox
  4. Form filled state
  5. Submit
  6. Confirmation: page is replaced by a single centered card — "Thank you. You'll receive a calendar invite shortly."
- Problem solved: zero-friction professional-event registration — no account, no password, single scroll; collects exactly the fields a B2B/professional event needs (company, job title, dietary).
- Sad paths: none observed in this flow.
- Microcopy worth stealing: "Food preferences or allergies" (one field covers dietary + allergy); "I agree to Sana sending me marketing communications, as described in the Privacy and Cookie policy"; "Thank you. You'll receive a calendar invite shortly." (confirmation sets the expectation of WHAT arrives next and WHEN).
- Notes: form floats over a photo of the actual venue — strong context cue. Required fields marked with asterisk only.

### Sana AI — "Event detail"
- Mobbin URL: https://mobbin.com/flows/8f9b6e8e-45ee-4e30-b107-06a6629753dc
- 3 screens: events index → detail → form. Same pattern as above; recorded for citation completeness.

### Luma — "Event registration"
- Mobbin URL: https://mobbin.com/flows/e02a2851-bfcc-4a64-9e47-f9222b4f3b98
- 2 screens (to zoom into via search_screens). Recorded; attendee-facing register modal expected.

---

## Q2: "RSVP to an event and get confirmation" (web)

### Circle — "RSVP for an event" (community event RSVP + confirmation modal)
- Mobbin URL: https://mobbin.com/flows/c82bbe5c-9d3d-44bd-959f-b76dece438cc
- Steps observed:
  1. Community feed → event post in space
  2. Event detail: sidebar card with "Going" status dropdown (options: "Going" / "Not going" radio), Date and time, "Add to calendar" link, Location block, Attendees avatars
  3. RSVP triggers confirmation MODAL: clap emoji, "Registration confirmed for Potato Palooza 2023", subtext "We'll send you a reminder before the event.", a date/time row with "Add to calendar" button inline, green "Done" button
  4. Back on detail: status pill shows green "Going" with dropdown to flip to "Not going" (= self-serve cancel)
- Problem solved: instant RSVP with explicit next-step expectation (reminder) and one-click calendar capture at the moment of highest intent.
- Sad paths: none visible; cancel path = status dropdown.
- Microcopy: "Registration confirmed for {event}" / "We'll send you a reminder before the event." / Location block for virtual events: "The link to join this live stream will be available 25 minutes before the start of this event." (anti-leak link gating, sets expectation).

### Posh — "Reserving a ticket" (free RSVP → QR ticket + wallet)
- Mobbin URL: https://mobbin.com/flows/3a20172c-7b9b-44c7-a2bd-ba3bf05e986a
- Steps observed:
  1. Event page (dark theme): title, venue, date, social proof "Terrence and 55 others going" with avatar row, "About this event", sticky red "RSVP" button
  2. Post-RSVP ticket modal: event recap (host org, venue, date) + QR code + "Add to Apple Wallet"; overlay prompt "Stay in the loop — Get event updates and promotional texts from {org}. You can unsubscribe anytime." with buttons "No, email me instead" / "Yes, text me updates →" (SMS opt-in AFTER the ticket is secured, not blocking)
  3. Final ticket modal: buttons "View Ticket" / "Add to Calendar" / "Add to Apple Wallet"; QR code with "Get the app"; app upsell panel "The app unlocks more: Instant ticket access, Easy ticket transfers, Curated For You"
  4. Background page button now disabled-state: "You have RSVP'd to this event" (already-registered state)
- Problem solved: QR ticket delivered instantly in-modal, wallet capture, and channel opt-in sequenced after success.
- Sad paths / states: already-RSVP'd state on the event page ("You have RSVP'd to this event" replaces CTA).
- Microcopy: "Stay in the loop" / "You can unsubscribe anytime." / "No, email me instead" (choice of channel rather than yes/no consent — clever).

### Partiful — "Attending an event" (RSVP with plus-ones, phone-first, safety gate)
- Mobbin URL: https://mobbin.com/flows/746c6688-1714-4ca0-8e30-01311aaf2ec5
- Steps observed (13 screens):
  1. Event page: title, date/time, host, location, "10/10 spots left", emoji RSVP buttons "I'm Going" / "Maybe" / "Can't Go"
  2. RSVP modal: selected status on top (3 emoji options re-shown), YOUR NAME, PHONE NUMBER with country code selector, helper "Just for event updates. No spam.", ATTENDEE COUNT dropdown ("2 attendees" = guest +1 capture inside the same modal), "+Post a comment" with GIF button
  3. Filled state incl. message "Wow!" + attached GIF ("I'M SO EXCITED") — RSVP doubles as social wall post
  4. COVID-19 Safety interstitial: "Please respect COVID-19 safety guidelines in your area..." + bolded requirement "Guests are required to bring and wear masks at the event." + "ACCEPT & CONTINUE" (host policy acknowledgement gate before confirm)
  5. Confirmed: page shows "2 Going" counter, "8/10 spots left" (live capacity decrement), user's status button shows "Going"
- Problem solved: ultra-low-friction RSVP (name+phone only), plus-one capture, host-policy consent, and capacity transparency in one flow.
- Sad paths: capacity counter implies a full/sold-out state exists; not shown here.
- Microcopy: "Just for event updates. No spam." / "X/10 spots left" / emoji status trio "I'm Going / Maybe / Can't Go".

### Aboard — "Confirming an attendance"
- Mobbin URL: https://mobbin.com/flows/4fa0df58-06ad-4449-8141-952065d330fe
- 2 screens: internal team event page, "Attend" button (top right) → flips to checked "Attending" pill; user avatar appears under "Attendees". Minimal toggle-RSVP pattern; no form.

---

## Q3: "buy a ticket for an event checkout and receive QR code ticket" (web)

### Eventbrite — "Purchasing a ticket" (paid checkout with countdown hold + order confirmation)
- Mobbin URL: https://mobbin.com/flows/2cd43d7d-47ab-4634-99a7-632733cc5a74
- Steps observed:
  1. Event page: hero image carousel, date, title, "ALL AGES" badge, price range card "$12 – $295" with orange "Get tickets"
  2. Checkout MODAL with inventory-hold countdown in header: "Checkout — Time left 19:53"
  3. Billing information: "Logged in as samlee.mobbin@gmail.com. Not you?" (identity escape hatch), First name*/Last name*/Email; "* Required" legend
  4. Two separate consent checkboxes: "Keep me updated on more events and news from this event organizer." (checked) and "Send me emails about the best events happening nearby or online." (unchecked) — organizer vs platform consent split
  5. Pay with: Credit or debit card / PayPal / Google Pay
  6. Right rail Order summary: ticket line "1 x VIRTUAL FEST on ZOOM $12.00", Subtotal, "Fees $2.64" (with info icon), Sales Tax, "Delivery: 1 x eTicket $0.00", Total $15.61 — full fee transparency before pay
  7. Legal line: "By selecting Place Order, I agree to the Eventbrite Terms of Service"
  8. Confirmation: green check "Thanks for your order!" + order number "#12019109083" + primary button "Take me to my tickets"
  9. Confirmation body: "YOU'RE GOING TO {event}", columns "1 TICKET SENT TO {email} (Change link)", DATE, LOCATION; organizer follow card ("Don't miss out on events from Mark Lapidos — Follow", follower count); social share icons; right rail cross-sell "Make more plans with these events"
- Problem solved: paid registration with time-boxed inventory hold, fee transparency, post-purchase email correction ("Change"), and immediate path to tickets.
- Sad paths: countdown implies hold-expiry state (not shown). "Not you?" handles wrong-account.
- Microcopy: "Time left 19:53" / "Thanks for your order!" / "1 TICKET SENT TO ... Change" / "Take me to my tickets".

### Posh — "Checking out an event" (paid card checkout → instant QR ticket)
- Mobbin URL: https://mobbin.com/flows/8b4f1874-7d8e-48c9-aaf9-d1ca0f14f05b
- Steps observed:
  1. Event page (themed background), lineup copy, social proof "Julio and 12 others going", "Get tickets" CTA
  2. Payment modal: tabs "Card" / "Google Pay", "Use saved payment" dropdown with lock icon, card fields, Country select, legal "By providing your card information, you allow {org} to charge your card for future payments in accordance with their terms.", grey "Pay $25.00" button (amount on button), "Back" link
  3. Success = same ticket modal as free RSVP: poster + "View Ticket" / "Add to Calendar" / "Add to Apple Wallet" + QR code + "Get the app" + app-benefits panel
- Problem solved: one modal from pay to scannable QR; no email round-trip required to get the ticket.
- Microcopy: "Pay $25.00" (explicit amount on button) / "Use saved payment".

### Klook — "Booking tickets" (attraction ticket checkout; lifecycle copy for vouchers)
- Mobbin URL: https://mobbin.com/flows/591b29ab-c07a-498d-bd3b-299ce485a4d3
- Steps observed:
  1. Cart: line item with quantity stepper "Person (Saturday/Sunday) − 2 +", Manage/Remove links, right-rail "Book now", "Get 0 credits for this booking"
  2. Checkout with 3-step progress bar: "Choose booking ✓ → Enter info ✓ → Pay (active)"
  3. "Complete payment — Pay within 01:59:40" (payment-window countdown); trust banner "All card information is fully encrypted, secure, and protected"; local pay methods (PayNow, DBS PayLah!, GrabPay, Credit/debit card); inline validation "Required field" in red under empty card number
  4. Success page: big green "Payment successful!" + "Thanks for booking with Klook! Your order summary and voucher will be sent to jdo********@gmail.com" (MASKED email) + "Order number: 4870578951" with copy icon + "See bookings" button + QR to "Download the Klook app to access your e-vouchers" + "Explore more" cross-sell
- Problem solved: multi-step paid booking with explicit payment window and voucher-delivery expectation.
- Sad paths: inline "Required field" validation observed; payment window expiry implied.
- Microcopy: "Pay within 01:59:40" / "Your order summary and voucher will be sent to jdo********@gmail.com" (privacy-masked email on a possibly-shared screen).

### Luma — "Ticket" (post-registration "You're In" page + QR ticket modal)
- Mobbin URL: https://mobbin.com/flows/59e64944-d65d-4b96-b72a-36db0bac6546
- Steps observed:
  1. Event page post-registration state: smiley + "You're In" header; "A confirmation email has been sent to jsmith.mobbin2@gmail.com."; countdown row "Event starting in 17d 21h"; buttons "Add to Calendar" + calendar-provider icons; red link line "No longer able to attend? Notify the host by canceling your registration."; collapsed section "Get Ready for the Event — Profile Complete · Reminder Off"; right rail: Location map card, Hosts card with "Contact" and "Donate"
  2. QR ticket modal over the page: large QR code, event name, "Guest: Jane" — ticket bound to named guest
- Problem solved: the event page itself becomes the ticket + lifecycle hub after registering (countdown, calendar, cancel, prep checklist, host contact).
- Sad paths: explicit self-serve cancel affordance with host-notify framing.
- Microcopy: "You're In" / "A confirmation email has been sent to {email}." / "No longer able to attend? Notify the host by canceling your registration." / "Event starting in 17d 21h" / "Get Ready for the Event".

---

## Q4: "join the waitlist for a sold out full event" (web)

### Fresha — "Joining waitlist" (fully-booked sad path → waitlist with preferences → on-waitlist state)
- Mobbin URL: https://mobbin.com/flows/13c4d86b-b5dd-446d-8451-66c17cf96e32
- Steps observed (12 screens, booking context but pattern transfers directly):
  1. Time selection, fully-booked sad path: empty-state card "Denise is fully booked on this date — Available from Wed, 14 Aug" with recovery buttons "Go to next available date" / "Check all professionals" and tertiary link "You can join the waitlist instead."
  2. "Join the waitlist" page: "Select your preferred dates and time. We'll notify you if a time slot becomes available." — Date dropdown + Time-range dropdown + "+ Add another time" (multiple preference windows); escape hatch "Changed your mind? See available times to book"
  3. "Review and confirm to join the waitlist": Payment method section with copy "You won't be charged now, payment will be collected in store if your appointment is confirmed." + "Pay at venue" option; "Waitlist notes" free-text ("Include any comments or special requests"); CTA "Join the waitlist"
  4. Post-join account page: blue pill "Awaiting availability"; header "You're on the waitlist"; "We'll be in touch if a time becomes available."; actions "Venue details" and "Leave waitlist — Remove yourself from the waitlist"; "Preferred dates" recap; itemized services + total
- Problem solved: complete waitlist lifecycle — graceful sold-out recovery, preference capture, no-charge reassurance, self-serve leave.
- Sad paths: fully booked (primary); leaving waitlist handled.
- Microcopy: "We'll notify you if a time slot becomes available." / "You won't be charged now..." / "Awaiting availability" / "You're on the waitlist" / "Leave waitlist — Remove yourself from the waitlist".

### Luma — "Setting a capacity limit" (organizer capacity + over-capacity waitlist mechanics)
- Mobbin URL: https://mobbin.com/flows/f88b3402-2d20-44f2-9583-6ce9def614a3
- Steps observed:
  1. Event create screen: Event Options rows "Tickets: Free", "Require Approval" toggle, "Capacity: Unlimited"
  2. "Max Capacity" popover: explainer "Auto-close registration when the capacity is reached. Only approved guests count toward the cap." + Capacity number input (1000) + "Over-Capacity Waitlist" toggle + buttons "Set Limit" / "Remove Limit"
  3. After save: Capacity row reads "1,000" with sub-badge "Waitlist Enabled"
- Problem solved: defines exactly how full-event behavior works: auto-close at cap, approved-only counting, optional overflow waitlist.
- Microcopy: "Auto-close registration when the capacity is reached. Only approved guests count toward the cap." / "Over-Capacity Waitlist".

### Contra — "Joining a waitlist" (product waitlist; position + referral jump)
- Mobbin URL: https://mobbin.com/flows/99b355b2-26c9-4de4-865d-28c37e36d451
- Steps: 1) "Claim your spot — We are rolling out access to small groups at a time as we refine the experience." + live counter "56,460 PEOPLE ON THE WAITLIST" + "Join the waitlist" → 2) "You are on the waitlist: 56,452 — YOUR PLACE ON THE WAITLIST" + "Move up the waitlist by referring your friends — The more friends that join, the sooner you will get access." + copy-link + share icons.
- Problem solved: waitlist position transparency + referral-driven queue jumping. (Product waitlist, not event — pattern still applicable to high-demand conference seats.)

### Square Appointments — "Waitlist" (operator-side waitlist queue)
- Mobbin URL: https://mobbin.com/flows/87033d09-924f-4073-8a38-c2adfc2b271f
- Steps: Waitlist tab → banner "Introducing: Automated notifications — Automatically notify clients on the waitlist of new availability that matches their requested time slots." → queue table (Client, Service, Staff, Availability preference) + "Add request" (staff can add someone to waitlist manually).
- Problem solved: admin view of the waitlist queue + auto-notify on freed capacity.

---

## Q5: "cancel my event registration or booking refund" (web)

### Luma — "Canceling a registration" (free-event self-serve cancel, 3 states)
- Mobbin URL: https://mobbin.com/flows/d947278c-7299-4f93-a40d-2d6d8b03437a
- Steps observed:
  1. "You're In" page (virtual event variant): "Event starting in 14h 23m" + "The join button will be shown when the event is about to start." + cancel link "No longer able to attend? Notify the host by canceling your registration."
  2. "Cancel Registration" confirm modal (ticket icon): "Click on the confirm button below to cancel your registration. We'll let the host know that you can't make it." Buttons: red "Confirm" / "Dismiss"
  3. Post-cancel state replaces the hero card: "You're Not Going — We hope to see you next time!" + "Changed your mind? You can register again." + green toast bottom: "You've canceled your registration."
- Problem solved: guilt-free cancel with host notification framing and instant re-register path.
- Microcopy: "We'll let the host know that you can't make it." / "You're Not Going" / "We hope to see you next time!" / "Changed your mind? You can register again." / toast "You've canceled your registration."

### Tripadvisor — "Canceling a booking" (paid cancel with refund math + retention offer)
- Mobbin URL: https://mobbin.com/flows/ed016519-280d-45f0-8212-6ac3a8dff57a
- Steps observed:
  1. Booking detail: green "Confirmed" badge, Confirmation # and Booking Reference #, action stack "Get tickets / Email tickets / Cancel for free by Apr 26 / Change Date / Edit booking / Contact tour operator" — cancellation DEADLINE is printed on the button itself; "Free cancellation before 10:45 AM ... on Apr 26, 2025. Learn more"; "Before You Go" instructions panel; "Inclusions & Exclusions" lists
  2. Cancel Booking page: reason dropdown ("Why are you cancelling this booking?"), "Did the provider ask you to cancel?" Yes/No radios, "Amount you paid: $124.34" vs "Your total refund: $124.34", "Refunds will be processed to your credit card ending in 2412. It may take 3-5 business days to appear.", buttons "Cancel Booking" / "Keep booking"; sidebar retention nudge: "Would you like to change your date or time instead? — Edit booking" + "Amended" badge on booking recap
  3. Post-cancel: grey "Canceled" badge, total now $0.00 USD, only remaining action "Contact tour operator"
- Problem solved: transparent refund calculation BEFORE the destructive action + downgrade-to-reschedule retention path.
- Microcopy: "Cancel for free by Apr 26" / "Your total refund: ..." / "It may take 3-5 business days to appear." / "Keep booking".

### Peerspace — "Canceling booking" (reason + message to host + per-line refund breakdown)
- Mobbin URL: https://mobbin.com/flows/834ca9f4-c1b3-4544-b355-896a6243da17
- Steps observed:
  1. "Your booking is confirmed" page: referral promo, action row "Invite guests / Browse add-ons / Update booking / Cancel booking", message timeline with host, right rail Booking details (host, address, date/time, attendees, price incl. Processing fee, "View and Manage Payments", "View Receipt")
  2. Cancel Booking page: "Please review our Cancellation and Refund Policy for more information. If you have any questions about the cancellation process, get in touch."; required reason dropdown "Tell Peerspace why you are cancelling *" (e.g. "My event is cancelled"); required free-text "Write a message to Ashlee *"; "Booking Summary" table with per-line "Refund amount ... (100% refund)" and green "Refund amount $30.00" total; policy card "Very Flexible — If you cancel now, you will receive a full refund. Go to cancellation policy"; buttons Back / "Cancel booking"
  3. Post-cancel: timeline entry "Jane cancelled this booking. View the cancellation details for more information."; trust card "Protect your payments — Never pay for a booking outside of the Peerspace website..."
- Problem solved: cancellation as a dialogue (reason + message to host) with full refund transparency per line item.

### Eventbrite — "Canceling an order" (attendee order page + refund processing states)
- Mobbin URL: https://mobbin.com/flows/bf4a9dfc-8f3c-46c6-b44a-a1d8b2c88cfd
- Steps observed:
  1. Order detail "Order #12238537213" with top actions: "Print tickets / Resend confirmation / Cancel order" (resend-confirmation = recover lost email, a key support deflection); Order Details (Buyer name, Order total, Payment details "Free order", Purchase date, Ticket total); Attendees table with per-ticket BARCODE number + "Unscanned" status, name, ticket type, price
  2. (Organizer view) Order Management list: order line "Order #... - $0.00 - Refund processing, may take up to 4 minutes" + yellow chip "Refund issued. Check back in 4 minutes to view updated order."; ticket buyer row shows Paid status "Refunded"; "Issue Multiple Refunds" bulk action
- Problem solved: order-centric lifecycle (print, resend, cancel) + honest async refund-processing state with time estimate.
- Microcopy: "Resend confirmation" / "Refund processing, may take up to 4 minutes" / barcode status "Unscanned".

---

## Q6: "view my ticket before the event find my tickets" (iOS)

### Live Nation — "View ticket" (anti-fraud rotating barcode)
- Mobbin URL: https://mobbin.com/flows/131e83a0-2f9c-42ee-a5d3-b5896eb5e0be
- Steps observed:
  1. "My Tickets" screen: tabs "MY TICKETS 1 / ADD-ONS", ticket card styled as physical stub (SEC "GA", "General Admission", event art, name/date/venue), buttons "View Ticket" / "Ticket Details", below: "Transfer" / "Sell"
  2. Full-screen barcode: event header, "General Onsale / General Admission / GA", ANIMATED barcode with caption "Screenshots won't get you in." + refresh icon (rotating barcode defeats screenshot resale fraud), "Add to Apple Wallet"
- Problem solved: ticket wallet with transfer/resale and screenshot-proof entry credential.
- Microcopy: "Screenshots won't get you in." (best-in-class anti-fraud copy).

### Luma (iOS) — "View ticket"
- Mobbin URL: https://mobbin.com/flows/c186b93d-4002-48cc-a0d8-f0359f8e58ec
- Steps: 1) Event page post-registration: poster, "Tomorrow, 6.00PM – 8.00PM", check pill "You are going", action row "My Ticket / Contact / Share / More", Location card with weather (22°C) and map → 2) Full-screen dark QR sheet: event name, giant QR, "Ticket: 1× Standard", "Add to Apple Wallet".
- Problem solved: one tap from event page to scannable QR; ticket type + quantity visible at gate.

### Nike Run Club — "Ticket" (community event ticket bound to member identity)
- Mobbin URL: https://mobbin.com/flows/ab3a2b03-1698-434d-99b4-48fd2772c0c4
- Steps: 1) Event page: hero, "Your Ticket" / "Get Directions" buttons, Starts/Ends columns (6:45 PM / 10:00 PM with dates), "Know Before You Go >" section, green check "You are going!" → 2) Ticket sheet: QR code, identity block "Sam Lee — Member Since 2025" with avatar, footer "Please show this ticket at the entrance of the event."
- Problem solved: ticket = QR + verified identity card; "Know Before You Go" = pre-event logistics pattern (directly relevant to conference joining instructions).
- Microcopy: "Know Before You Go" / "Please show this ticket at the entrance of the event."

### Eventbrite (iOS) — "Ticket details" (tickets hub + refund/self-service from ticket)
- Mobbin URL: https://mobbin.com/flows/6e056259-aa3f-4d73-9c75-fab0cf3707bf
- Steps observed:
  1. "Tickets" tab: segmented "Upcoming / Past"; "Coming up" list rows with date/time, thumbnail, title, venue, and a QR-count badge ("1 ⊞"); recovery link at bottom: "Something missing? Find your tickets" (lost-ticket rescue)
  2. Ticket detail self-service stack: "Refund policy — Refunds up to 7 days before the event" + "Request refund >"; rows "Event details / Order details / Download ticket / Ticket information / Report event"
  3. "Public notice" section (legal/safety text, shown in English AND Spanish "Anuncio público") and "Organized by" card: org avatar, "Followers 11.3k / Events 591 / Hosting 14 years", buttons "Follow" / "Contact"
- Problem solved: the ticket is the hub for the whole post-registration lifecycle: refund window stated in plain words, downloadable ticket, organizer contact, trust/credibility stats.
- Microcopy: "Refunds up to 7 days before the event" / "Something missing? Find your tickets".

---

## Q7: "check in to an event scan QR code at entrance" (iOS)

### Luma (iOS) — "Checking in a guest" (host scans attendee QR; full scan-result card)
- Mobbin URL: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f
- Steps observed:
  1. Host event page action row: "Invite / Check In / Blast / More"; location card shows "Door code: 0240" (gate logistics on the event page)
  2. Scanner: full-dark camera view with white rounded viewfinder square; bottom-left toggle (guest-list icon), bottom-right camera-flip
  3. On scan, bottom sheet rises with guest identity card: avatar, "Jason Smith", Email, Status "Going" (green), Registration Time "Today, 8.17PM", Ticket "Standard" + big "Check In" button + "..." overflow
  4. After tap: green toast top "✓ Check In Successful"; button flips to "Undo Check In" (mistake recovery); card now shows three columns: Status "Going" / Registered "Today at 9:41 AM" / Checked In "Today at 9:44 AM"
- Problem solved: gate staff verifies WHO the ticket belongs to (not just validity) before admitting; undo handles mis-scans; timestamps create an audit trail.
- Sad paths: undo check-in; (invalid/duplicate-scan states not shown in these screens).
- Microcopy: "Check In Successful" / "Undo Check In".

### Luma (iOS) — "Checking in guests" + "Guest list" (search-based check-in fallback)
- Mobbin URLs: https://mobbin.com/flows/26b0f3ea-2156-43d2-b580-f4774fbb7fc7 and https://mobbin.com/flows/eb552956-1906-43ed-93b8-d7907404f1a5
- Steps: host page "Check In Guests" button → Guest List sheet: search field "Search event guests...", status tabs "Going / Invited / Not Going / Pending" (variant: "Going / Invited / Not Going / Checked In"), rows show name+email with right-aligned status "Going" and inline "· Checked In" green annotation; empty state "No Guests — There are no guests of this status."
- Problem solved: manual fallback when attendee has no QR (dead phone, no email) — search by name and check in from the list. Admin counters "Going / Invited / Not Going" on event page.

### Handshake — "QR meetings" (career-fair attendee-side QR check-in)
- Mobbin URL: https://mobbin.com/flows/43637ac9-eba7-419b-9a68-f9bf0c2b7981
- Steps: profile menu row "QR code for events" → iOS camera permission dialog with purpose string "You can use your camera to participate in virtual events, scan QR codes for event check-in, and update your profile photo." → scan screen "WELCOME TO Your Event" with viewfinder + caption "Scan an employer QR Code to check in"
- Problem solved: reverse check-in — the ATTENDEE scans a venue/booth QR to mark presence (booth-level attendance, useful for session-level tracking at conferences).

---

## Q8: "complete attendee details information for each ticket after purchase" (web)

(Attendee-facing per-ticket details form did NOT surface; what surfaced is the organizer side that produces those questions, plus repeats of Q1 Luma flows.)

### Posh — "Adding custom checkout fields" (organizer builds the attendee-details questionnaire)
- Mobbin URL: https://mobbin.com/flows/475f92f5-0e60-47f9-b438-df5cb80c0585
- Steps observed:
  1. Event Settings hub: cards "Checkout — Checkout Flow, Custom Fees, Buttons", "Policies — Terms of Service & Refund Policy", "Custom Checkout Fields", "Embed — Embed checkout for this event on another website"; status chips "Live — event starts in 2 days", greyed "Refund Request Pending"
  2. Custom Checkout Fields builder: explainer "Custom checkout fields allow you to gather additional info from attendees during the checkout process. They appear at the beginning of checkout." — note placement: questions BEFORE payment
  3. Field types available: "Text Input / Checkboxes / Dropdown / File Upload" (+ buttons); per-field: question text, "Limit to specific tickets..." selector (yellow ticket chip "Grab Your Seat!"), delete icon, "Required" toggle; checkbox question shows option list + "Add option" + constraint in label "(Select up to 2)"
  4. Unsaved-changes bar "Would you like to save your changes? DISCARD / SAVE CHANGES" + green toast "Your changes have been saved."
- Problem solved: per-ticket-type custom questions incl. FILE UPLOAD (e.g. medical license / abstract upload for conferences) collected at checkout start.
- Microcopy: "They appear at the beginning of checkout." / "Limit to specific tickets...".

### Posh — "Searching attendees" (organizer attendee CRM)
- Mobbin URL: https://mobbin.com/flows/f92c9af7-2e34-4d32-9b4e-5c8a7ae842e8
- Steps: Marketing > Attendees table (Name, Tickets, Total Spend, Contact icons SMS/call, Tags, Last Purchase) → live search "sam" filters rows; "View SMS Campaigns"; note "Marketing SMS blasts are limited within a rolling 30-day period."
- Problem solved: post-registration attendee lookup + contact/tagging.

Dead angle: no attendee-facing "fill details for each ticket" flow surfaced on web in this query (Eventbrite's checkout collected buyer-level info only in observed screens).

---

## Q9: "register a guest bring a plus one to an event" (web)

(Attendee-side plus-one already captured in Q2 — Partiful "ATTENDEE COUNT" dropdown inside RSVP modal. This query surfaced the organizer-side guest mechanics.)

### Luma — "Adding guests directly" (organizer bypasses registration; sessions targeting)
- Mobbin URL: https://mobbin.com/flows/70153c2d-d2a0-4b00-a02d-340dc69c1777
- Steps observed:
  1. "Add People Directly" panel: "They will be marked as approved immediately, without needing to pay or register."; toggle "Specify names for guests"; rows Name + Email + "+ Add Row"
  2. "Add Guest To" selector: "Full Series" OR "Individual Sessions" → "Add to Sessions" multi-select of dated sessions (8 June at 14:00 GMT-4, etc.)
  3. Disclosure bullets: "We will let them know they have been added to the event." / "They will not need to pay or register." / warning "Please only add people who have consented to be added."
  4. Green toast: "The guests were added to your event."
- Problem solved: VIP/speaker/comp registration path that skips form+payment but still notifies the person; session-level granularity (direct fit for conference session targeting).
- Microcopy: "They will be marked as approved immediately, without needing to pay or register." / "Please only add people who have consented to be added."

### Luma — "Invite guests" (email/CSV/tag invitations with clear contract)
- Mobbin URL: https://mobbin.com/flows/38052e96-ce66-4768-bb28-5cf441f25aa7
- Steps: Invite Guests panel with source tabs "Email / Events / CSV / Tags"; paste emails + optional personal message; "Include guests who didn't accept previous invites" checkbox (re-invite); contract bullets: "Invited guests still need to register or pay for the event." and "They will be approved when they register if registration approval is enabled."; "Send a Preview" link; escape link "I want to add people directly to the event".
- Problem solved: invitation ≠ registration — copy makes the distinction explicit.

### Posh — "Adding a private guestlist" (+1 allowance and comp tickets)
- Mobbin URL: https://mobbin.com/flows/86a6b963-0036-42f2-b61b-4a5fa90f89d0
- Steps observed:
  1. "Complimentary Tickets" section: "+ Send Complimentary Tickets"; explainer "Complimentary orders are tickets sent to the user. If they have an account, the tickets will be added to their account and they will be notified. If they do not have an account, the tickets will be sent to their email/phone number and are accessible without an account." Table: Name, Email, Date Created, Ticket Type chip, Qty
  2. "Private Guestlist": "This is a private guestlist. Names added here will not receive a ticket and are not prompted to create an account." → "Create Guest" panel: Name, Description ("Additional notes (optional)"), "Additional Guests" count field (the +1/+N allowance) → list row "John Doe | +1 | CPO of Mobbin Team | Not Checked In" with check-in / delete actions
- Problem solved: door-list guests with plus-N allowances and no-account comp tickets — covers VIP/faculty/door-list edge of registration.
- Microcopy: "...accessible without an account." / status chip "Not Checked In".

---

## Q10: "edit my registration answers or update RSVP after registering" (web)

### Partiful — "Editing RSVP" (guest card with questionnaire answers + RSVP history)
- Mobbin URL: https://mobbin.com/flows/40407146-d3b4-4d07-b94a-fd4734bc1072
- Steps observed (host-side guest detail, reveals editable RSVP model):
  1. Guest List → guest card "John": status dropdown "Going" + separate plus-one dropdown "+0" (expandable to +1...+9), timestamp line "Updated to Going on 8/06 - 1:14pm", guest's comment ("Yay" 3 minutes ago)
  2. Tabs on the card: "Questionnaire" (shows answers, e.g. "How old are you? * — 54") and "RSVP History" (full audit trail of status changes)
  3. Plus-one count changed 0 → +1 via dropdown
- Problem solved: RSVP is mutable post-registration (status, party size) with an audit history and per-guest questionnaire answers — exactly the "edit my answers" data model.
- Microcopy: "Updated to Going on {date} - {time}" / tab "RSVP History".

### Luma — "Editing registration questions" (per-question Off / Optional / Required)
- Mobbin URL: https://mobbin.com/flows/4c11bf10-7e9f-4b8d-adc5-c283b63fff8d
- Steps: Registration Questions section → per-question dropdown with states "Off / Optional / Required" (red highlight on current) → green toast "Event updated successfully!"
- Problem solved: question requiredness as a 3-state enum, editable live after event creation.

### Luma — "Customizing an email" (lifecycle email editor with variables)
- Mobbin URL: https://mobbin.com/flows/1d3a1cec-8477-43da-84b1-8292d5586212
- Steps: Registration Emails → "Pending Approval / Waitlist Email" editor panel: explainer "This email is sent when a guest registers for the event, notifying them that their registration is pending approval or that they are on the waitlist."; subject "Registration pending approval for {event}"; body editor with hint "You can insert variables by typing {"; buttons "Update Email" / "Send a Preview"; toast "Email updated successfully."
- Problem solved: per-lifecycle-state transactional email customization with template variables and preview-send.

---

## Q11: "request to join event registration pending approval" (web)

### Luma — "Accepting an invitation (guest)" (invited ≠ registered; accept/decline)
- Mobbin URL: https://mobbin.com/flows/28703fea-9a9b-4a8c-aff3-f3946bd89f14
- Steps: Event page in "invited" state: Registration card reads "You are Invited — We'd love to have you join us." + "Welcome! To join the event, please register below." + identity row (avatar, name, email of logged-in user) + primary "Accept Invite" / secondary "Decline" → on accept: "You're In" card (confirmation email note, countdown, Add to Calendar, cancel link, "Get Ready for the Event").
- Problem solved: invitation acceptance as one-click registration with pre-filled identity; decline is equally easy.
- Microcopy: "You are Invited — We'd love to have you join us." / "Accept Invite" / "Decline".

### Luma — "Registering for an event" (one-click register from calendar feed; capacity badges)
- Mobbin URL: https://mobbin.com/flows/eadb6cd5-cc36-4e9e-9c4f-70df3558da90
- Steps: Calendar feed list (events grouped Today/Tomorrow/dates) with per-event status chips: "Not Going" (grey), "Near Capacity" (amber badge on a different event — scarcity signal in list view), → event side panel: "Registration — Hello! To join the event, please register below." + identity row "Jane jsmith.mobbin2@gmail.com" + red "Register" button → instant "You're In" state ("A confirmation email has been sent to...", "Event starting in 2d 6h", Add to Calendar icons, cancel link, "Get Ready for the Event — Profile Complete · Reminder Off") + green toast "Thank you for registering!" → feed chip flips to green "Going".
- Problem solved: logged-in one-click registration — identity pre-filled, zero form; list-level status chips for every event.
- Microcopy: "Hello! To join the event, please register below." / "Thank you for registering!" / chips "Going / Not Going / Near Capacity".

(Note: attendee-side "pending approval" SCREEN still not directly observed — only the organizer email config and "Approval Required — Your registration is subject to approval by the host." card from Q1.)
