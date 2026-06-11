# BY-PATTERN Sweep — Public Event Registration + Confirmation/Ticket/QR

Job: "register as an attendee for an event via a public form, and receive confirmation with a ticket/QR code"
Source: Mobbin MCP (search_screens deep mode, search_flows). Platform web primary, ios fallback.
Date: 2026-06-11

---

## Pattern: minimal-rsvp-modal-over-event-page
- Apps observed in: Luma, Partiful
- Mobbin URLs:
  - Luma "Your Info" register modal: https://mobbin.com/screens/285818cd-c1e8-4b63-9e8f-8e77a8471df5
  - Partiful RSVP modal (Going/Maybe/Can't Go): https://mobbin.com/screens/004cb122-650a-42e5-a6de-24a07082c969
- Anatomy as observed:
  - Modal opens OVER the event page (event branding stays visible behind, dimmed/blurred)
  - Luma: header "Your Info" → identity block (avatar + name + email, pre-filled if known) → one custom question dropdown ("Is this your first time attending a RubySG meetup? *") → single full-width dark "Register" button
  - Partiful: 3 emoji response chips at top (I'm Going / Maybe / Can't Go — selected one highlighted), then YOUR NAME field, PHONE NUMBER field with country-flag prefix, "1 attendee" count dropdown inline with phone, optional "+Post a comment" field, CANCEL / CONTINUE buttons
- Problem it solves: near-zero-friction registration; user never leaves event context; identity reuse when known
- Sad paths observed: none in these screens
- Microcopy worth stealing:
  - Partiful under phone field: "Just for event updates. No spam."
  - Partiful spots indicator on event page behind modal: "10/10 spots left"
- A11y/mobile notes: Luma form is extremely short (1 question) — single-column, large tap target button

## Pattern: organizer-custom-question-builder (context for what public forms render)
- Apps observed in: Luma
- Mobbin URLs:
  - https://mobbin.com/screens/f3e54997-7bc9-4347-a576-d369bf4dd693
  - https://mobbin.com/screens/deab29c9-0c4c-4e73-b0c0-fa053f48f96f
  - https://mobbin.com/screens/ba2d69b4-36b0-486e-b8ee-8f14c5edff54
- Anatomy: "Registration Questions" admin tab — grouped sections: Identity (Name, Email always Required, shown as locked chips), optional verified-field group (ETH/Solana with Optional/Off dropdowns), Custom Questions list (drag handles, per-question type dropdown Text/Checkbox, Required checkbox, delete icon, "+ Add Question"), "Update Questions" commit button + Cancel
- Microcopy: "We will ask guests the following questions when they register for the event." / "We always ask guests for their name and email."
- Problem: organizer-defined dynamic fields rendered into the public form; identity fields immutable

## Pattern: registration-form-with-consent-checkboxes
- Apps observed in: Nike (Run Club event registration)
- Mobbin URLs: https://mobbin.com/screens/bcc669b9-25dc-4132-b55e-56f74a3a3006
- Anatomy: two-column page — left: "Registration" heading, guardian notice, Emergency Contact group (Full Name*, Phone Number*), two unchecked consent checkboxes (Experience Terms; data-processing/privacy agreement), disabled greyed "Register" button until valid; right: event summary card (illustration, dates/time, title, venue address with pin icon), "Back To Event" link top-left
- Problem: legal consent + emergency contact for physical events; persistent event context during form fill
- Sad paths: register button disabled state until checkboxes ticked
- Microcopy: "If you are under the age of majority, your parent or legal guardian must register you for this Experience."

## Pattern: ticket-tier-picker-with-quantity-steppers
- Apps observed in: Posh, Eventbrite, Klook
- Mobbin URLs:
  - Posh tier list + live total: https://mobbin.com/screens/4e6455be-bc03-4071-a359-eb6919356bd5
  - Eventbrite tickets modal (free tiers + eligibility blurbs): https://mobbin.com/screens/f3b50610-4b0d-49e7-b259-03f170953f62
  - Eventbrite paid tiers + order summary: https://mobbin.com/screens/88dd0e07-4d2d-4407-b94f-f08301ca3942
  - Klook date + per-day quantity: https://mobbin.com/screens/cfb604cd-c03c-492c-b32e-34afb57a4120
- Anatomy as observed:
  - Modal/panel with event title + datetime header
  - Each tier = card: name, price "incl. $X.XX fees" or "+$X Fee / +$X Sales Tax", availability line ("Sales end in 2 days" / "Sales end on Mar 28, 2025"), eligibility/benefit description (truncated with "See more"/"View more"), − [count] + stepper
  - Selected tier card gets highlighted border; live total on the right ("$25.00 / 1x General Admission") or running Order summary panel (Subtotal, Fees ⓘ, Sales Tax, Total)
  - Sticky "Checkout"/"Check out" CTA
  - Klook variant: calendar date picker with per-date price under day numbers + quantity per person-type, "Currency: S$" note, "Sold out" legend
- Problem: multi-tier pricing with fee transparency before commitment
- Sad paths observed:
  - "Sold out" badge on a tier with stepper disabled (Eventbrite tubi screen)
  - urgency chip "🔥 Few tickets left" next to Check out button (Eventbrite)
- Microcopy worth stealing:
  - "Sales end in 2 days — Fees and taxes will be calculated before you place your order."
  - "$25.00 incl. $3.17 fees" (fee-inclusive price display)
  - "No cancellation · Instant confirmation · Valid on the selected date" (Klook policy chips)
- A11y/mobile: steppers are large +/− buttons; totals always visible without scrolling

## Pattern: promo-code-and-addons-in-ticket-modal
- Apps observed in: Eventbrite
- Mobbin URLs: https://mobbin.com/screens/73e40f3d-7f0b-4180-a7a3-c71ef3c37b4a
- Anatomy: Promo Code input with inline "Apply" at top of ticket modal → Tickets section (RSVP, Free) → "Add-ons" section (e.g., "Access to video recording £7.00") with own steppers → order summary right rail ("1 x RSVP £0.00 / Total £0.00") → Check out
- Problem: upsells + discounts inside the same ticket selection step; free RSVP treated as £0 order
- Microcopy: "Order summary", "Promo Code / Enter code / Apply"

## Pattern: donation-field-in-checkout
- Apps observed in: Eventbrite
- Mobbin URLs: https://mobbin.com/screens/e268136c-b5aa-42a2-a3bd-44a552b9fa70
- Anatomy: "Donations" section under sold-out GA tier — named donation line item with $ amount input, reflected in order summary, total updates
- Problem: free-event monetization / society fundraising at registration time (relevant to medical-association conferences)

## Pattern: seat-map-picker (adjacent, recorded for completeness)
- Apps observed in: SeatGeek
- Mobbin URLs: https://mobbin.com/screens/c85ec304-5f0b-4773-ab61-312e42c39afd
- Anatomy: left rail ticket list with price "incl. fees", deal-score badges; right interactive venue map; filter chips (Access code, Accessible, Best seats, Low prices, Include fees toggle)
- A11y note: dedicated "Accessible" seating filter chip — pattern worth copying for conference accessibility needs

## Pattern: youre-in-confirmation-with-qr-on-event-page
- Apps observed in: Luma
- Mobbin URLs: https://mobbin.com/screens/77b1ff06-4a3e-4cdb-a4d5-50f82c9ec9b8
- Anatomy as observed: event page transforms post-registration — "You're In" card replaces the register CTA: avatar, "You're In" heading, "A confirmation email has been sent to jsmith.mobbin2@gmail.com", countdown row "Event starting in — 17d 21h", "Add to Calendar" buttons (multiple calendar providers), cancellation line, "Get Ready for the Event / Profile Complete · Reminder Off" prep section. Tapping ticket opens a QR modal: large QR, event name, "Guest / Jane" label. Location card with embedded map stays visible.
- Problem it solves: confirmation + ticket + calendar + cancellation all live on the same canonical event URL — nothing to lose, re-visit page = re-see ticket
- Sad paths observed: cancellation affordance built into confirmation ("No longer able to attend? Notify the host by canceling your registration.")
- Microcopy worth stealing:
  - "You're In"
  - "A confirmation email has been sent to {email}"
  - "No longer able to attend? Notify the host by canceling your registration."
  - "Event starting in 17d 21h"

## Pattern: payment-success-page-with-email-echo-and-order-number
- Apps observed in: Klook, Expedia, Booking.com, KAYAK, Headspace
- Mobbin URLs:
  - Klook "Payment successful!": https://mobbin.com/screens/ba616449-5a25-4042-b185-2cc56d0f5104
  - Expedia "Thank You! Your trip has been confirmed.": https://mobbin.com/screens/8bc4921e-2b85-4baa-8723-798030b28c47
  - Booking.com confirmed + app handoff QR: https://mobbin.com/screens/53b5872e-cb6b-4bd8-ada2-6fd690c6797d
  - KAYAK "You're booked" modal: https://mobbin.com/screens/57309c1c-5d13-4c2f-b9e9-ea5c35f5d02f
  - Headspace "You're all set, Alex!" + next-steps QR: https://mobbin.com/screens/a3e730a6-ff92-412b-be2a-40ffb10721b4
- Anatomy as observed (composite of what each shows):
  - Green check + status headline ("Payment successful!" / "Your booking in New York is confirmed.")
  - Masked email echo: "Your order summary and voucher will be sent to jdo********@gmail.com" (Klook masks the address)
  - Order/confirmation/itinerary number prominently displayed with copy icon (Klook "Order number: 4870578951 ⧉", Expedia "itinerary number: 72847600794426", Booking.com "Confirmation number: 3272066352 ⧉" + PIN code)
  - Primary CTA to the persistent artifact ("See bookings" / "View My Itinerary" / "View your receipt")
  - Secondary: QR code to hand off to mobile app ("Scan QR code" / "No data, WiFi or printer needed with the FREE app")
  - Headspace variant: stepper across top (✓ Check In · ✓ Verify Insurance · ✓ Schedule appointment), personalized headline "You're all set, Alex! Your session is scheduled.", appointment-details card, numbered "Next Steps" checklist ending in QR
- Problem: proof of completion + durable reference number + path to the ticket artifact
- Microcopy worth stealing:
  - "Thanks for booking with Klook! Your order summary and voucher will be sent to jdo********@gmail.com"
  - "You will immediately receive an email at {email}" (Expedia)
  - "We're looking forward to seeing you. You'll receive an email with more information in a few minutes." (Headspace)
  - "Your confirmation is on its way to jdoe.mobbin@gmail.com. Edit" — inline EDIT-email link on Booking.com (sad-path recovery for typo'd email)
- Sad paths observed: Booking.com lets you edit the email right from the confirmation if it's wrong

## Pattern: qr-ticket-screen-with-wallet-button (ios)
- Apps observed in: Luma (iOS), Eventbrite (iOS), StubHub (iOS), Gametime (iOS)
- Mobbin URLs:
  - Luma full-screen QR ticket: https://mobbin.com/screens/aa52fbb3-9cc8-40e8-a47c-d50ccc906558
  - Eventbrite My Tickets stub: https://mobbin.com/screens/edd2e9b8-3fd4-4caf-9aaf-0b4eeb1df9fc
  - Eventbrite branded QR ticket: https://mobbin.com/screens/9aa88ec6-82a1-46e0-ae92-df1a9c9f7306
  - StubHub wallet pass style: https://mobbin.com/screens/1488a72e-daa5-4ae8-9013-36fdd4d944a7
  - Gametime web→Wallet pass prompt: https://mobbin.com/screens/73e8e918-32d6-48f4-9a9d-dbc224d8a1da
- Anatomy as observed:
  - Full-screen high-contrast QR (white tile on dark bg in Luma — screen-brightness friendly)
  - Identity line under QR: "Alex Smith · Ticket 1 of 1 / GENERAL ADMISSION 21+ [TIER 1]" (Eventbrite)
  - Ticket metadata stub below: Name, Event, Ticket/seat, Date + "Add to calendar", Venue + "View Map", Order number (Eventbrite — ticket designed like a physical stub with perforation)
  - "Ticket 1 of 1" pagination for multi-ticket orders
  - Standard black "Add to Apple Wallet" badge button beneath QR
  - StubHub anti-fraud line directly under QR: "A screenshot of your ticket will not be accepted"; orange pass shows SECTION/ROW/SEAT + "ENTER AT MARINA GATE" + "VIEW TICKET TERMS"
- Problem: offline-ready entry credential; wallet handoff; per-attendee identity on the QR
- Sad paths observed: anti-screenshot warning (StubHub); Gametime web disclaimer "THIS IS NOT A TICKET. Make sure to add the ticket(s) to your wallet by clicking the buttons above."
- Microcopy worth stealing:
  - "A screenshot of your ticket will not be accepted"
  - "{Name} · Ticket 1 of 1"
- A11y/mobile: QR sized near full width; Wallet badge is the system-standard asset

## Pattern: join-waitlist-flow
- Apps observed in: Fresha, Square (Appointments), Kit (ConvertKit)
- Mobbin URLs:
  - Fresha "Join the waitlist" preference picker: https://mobbin.com/screens/0e15b1eb-d751-4f4c-b7f8-5b754a3237a0 and https://mobbin.com/screens/46794065-f917-4903-ab54-9ceecdf0d81b
  - Fresha "Review and confirm to join the waitlist": https://mobbin.com/screens/6f56e9eb-eb46-4b0d-a7ab-f4d97ff4cb2f
  - Square waitlist availability modal: https://mobbin.com/screens/e1afa6ef-54e1-40ba-babe-631291d04d7a
  - Square waitlist contact form: https://mobbin.com/screens/5c58f44f-46b8-4960-8507-c666ff4aca1e
  - Kit "Join the waitlist" email-capture form: https://mobbin.com/screens/d69fb199-740d-4ad4-9629-8058b39bd6f5
- Anatomy as observed:
  - Fresha: breadcrumb stepper (Services › Professional › Time › Waitlist › Confirm) → date dropdown + time dropdown with quick chips (Any time / Morning / Afternoon / Evening) + "+ Add another time" → escape hatch link "Changed your mind? See available times to book" → review step states no charge now → "Join the waitlist" black CTA; right rail keeps order summary
  - Square: modal collects availability windows (Date range / Time range rows, "Add option") → then contact form: phone with +1 country selector, First/Last name, Email, optional "Waitlist note (Add)", "Sign in" link for returning users, legal fine print, "Join waitlist" CTA + "Request summary" right rail with Edit links
  - Kit: minimal landing form — headline "Join the waitlist", one Email field, CTA, trust line
- Problem: capture demand when inventory/slots are gone; collect preferences so the system can auto-match
- Sad paths observed: this IS the sad path (sold out / no availability); escape hatch back to bookable inventory ("See available times to book")
- Microcopy worth stealing:
  - "Select your preferred dates and time. We'll notify you if a time slot becomes available." (Fresha)
  - "You won't be charged now, payment will be collected in store if your appointment is confirmed." (Fresha)
  - "Changed your mind? See available times to book" (Fresha)
  - "Subscribe below and we'll notify you when the product is released." + "We respect your privacy. Unsubscribe at any time." (Kit)

## Pattern: registration-closed-state
- Apps observed in: Luma (admin side only)
- Mobbin URLs: https://mobbin.com/screens/54040cc9-2328-4060-8e58-e6b427a47142
- Anatomy as observed: admin Guests tab — "At a Glance" capacity bar "0 approved guests / cap 50", inline status line "ⓘ Registration is closed.", action cards (Invite Guests / Change Capacity / Open Registration), green toast "✓ Registration is now closed."
- NOTE: public-facing "registration closed / event ended" screens did NOT surface on web in this query — query returned mostly admin empty states (Kajabi "Looks like this event does not have any registrations yet.", Luma "No Upcoming Events", Spotify "No items found.", Product Hunt "There are no upcoming events."). Marked for retry with different phrasing.
- Microcopy: toast "Registration is now closed."; Kajabi empty state "Once your customers register for the event, they will appear here."

## Pattern: request-pending-approval-state
- Apps observed in: Airbnb (public side), Luma (system side)
- Mobbin URLs:
  - Airbnb "Your request is pending": https://mobbin.com/screens/e0a41354-15eb-4085-80fb-1488334b3b6a
  - Luma "Require Approval" ticket toggle + 3-state emails: https://mobbin.com/screens/9950aea6-4d37-4745-aad9-68b9d5200edb and https://mobbin.com/screens/4a872027-7b31-4eea-97bd-fa769a385af0
  - Luma New Ticket Type modal with Require Approval toggle: https://mobbin.com/screens/e6c81f54-e678-4bff-a409-9b8a7f6bc94a
  - Luma email triptych Pending Approval/Waitlist · Going · Declined: https://mobbin.com/screens/e9a15838-b7c1-4961-9806-d18fa4016e87
  - Luma check-in modal showing "Pending Approval" badge on a guest: https://mobbin.com/screens/544304a2-d9dc-415a-9b08-6c97773669c3
- Anatomy as observed:
  - Airbnb pending page: headline "Your request is pending" → bold caveat "This isn't a confirmed reservation—yet." → plain-language explanation of who approves, the 24h SLA, and that email will confirm → reassurance "In the meantime, no one else can make a reservation… for the dates you selected." → "Show pending request" button; right card shows summary + "Paid today $44.00" + "The rest will be charged on 6/30/2023." + Reservation code
  - Luma system model: per-ticket-type "Require Approval" toggle; registration emails come in exactly three customizable states — Registration Received / Registration Approved / Registration Rejected (a.k.a. Pending Approval-Waitlist / Going / Declined); guest list rows carry an orange "Pending Approval" status chip that persists into check-in
- Problem: gated/curated registration (extremely relevant for faculty/invited delegates at medical conferences)
- Sad paths observed: rejection is a designed state with its own email template ("Registration Rejected" / "Declined")
- Microcopy worth stealing:
  - "This isn't a confirmed reservation—yet."
  - "Once your ID gets approved, we'll pass along your request to {host}, who then has 24 hours to respond. We'll also send you an email when your reservation is officially confirmed."
  - "In the meantime, no one else can make a reservation at {host}'s place for the dates you selected." (hold reassurance)
  - Email-state names: "Registration Received / Registration Approved / Registration Rejected"

## Pattern: multi-step-checkout-progress
- Apps observed in: QuickBooks, Wise, Urban Outfitters, SuperHi, HubSpot, Uvodo
- Mobbin URLs:
  - QuickBooks numbered stepper with editable summaries: https://mobbin.com/screens/27c3f5d0-07e5-4b21-8b93-6ff713181fb5
  - Wise top-tab stepper (Card · Address · Payment · Verification) + "Things left for you to do" checklist: https://mobbin.com/screens/eed37374-00a7-4ff3-8af9-0f92c926b376
  - Urban Outfitters dot-rail stepper (Ship or Pick Up › Delivery › Payment): https://mobbin.com/screens/754c3dd8-311c-4477-bcf8-d1c9dc6207b7
  - SuperHi compact stepper (1 Details · 2 Payment · 3 Success): https://mobbin.com/screens/b145688c-18bc-4b5b-bd9a-ab1c73bd220a
  - HubSpot dot progress + COMPANY DETAILS label: https://mobbin.com/screens/1b8f1349-1258-4f70-9ecc-035709e39075
  - Uvodo vertical accordion checkout (1 Contact Information → 2 Shipping → 3 Method → 4 Payment): https://mobbin.com/screens/1566e820-483d-496f-8a52-450c0f3f060a
- Anatomy variants observed:
  - Horizontal numbered stepper where COMPLETED steps show their chosen value underneath with an edit pencil (QuickBooks: "1 Select plan / Simple Start ✎")
  - Vertical accordion: only current step expanded, email first, "Already have an account? Sign in now" inline (Uvodo)
  - "Success" as an explicit named third step (SuperHi: Details · Payment · Success)
  - Persistent right-rail order summary + trust badges ("Secure Checkout - SSL Encrypted", "Verified by VISA/Mastercard") (Uvodo)
- Problem: orientation + perceived progress in multi-page registration; edit-without-restart
- Sad paths observed: Urban Outfitters full-width red banner "Invalid promo code." at top of checkout (error placement note: banner at top, not inline at field)
- Microcopy worth stealing:
  - "Things left for you to do" (Wise remaining-steps checklist)
  - "You are logged in with this email address" under prefilled email (SuperHi)
  - SuperHi placeholder convention: every field has "e.g. …" examples (e.g. Wilson Smith, e.g. 129 West 81st St)

## Pattern: inline-field-validation-errors
- Apps observed in: Frame.io, Nike, Skiff, Mixpanel, Slite, Amie
- Mobbin URLs:
  - Frame.io empty-submit "Email is required": https://mobbin.com/screens/6deaeb2a-fcbc-4886-bc35-a350fa820b28
  - Frame.io format error "Please enter a valid email": https://mobbin.com/screens/4074a13e-68cf-4d6e-b73f-1806b215a0f1
  - Nike floating-label error "Invalid email address": https://mobbin.com/screens/cf46d64e-e080-43f5-a2cc-982eb917ed8f
  - Skiff rule-explaining error: https://mobbin.com/screens/6d63f84f-0756-4193-9759-d5d1eb3bd01a
  - Mixpanel valid-email error with warning icon inside field: https://mobbin.com/screens/dccb7e89-621e-490a-98c2-c99f4e9f2180
  - Slite OTP code invalid + recovery: https://mobbin.com/screens/2c04bc03-a586-49e5-862b-b9c6ed14d7e3
  - Amie playful labels + inline error: https://mobbin.com/screens/c77f0d08-cd5f-47bb-b489-c3e44311e3f7
- Anatomy as observed (consistent across all): red/orange border on the offending field + small error text in same color DIRECTLY below the field; field value preserved; submit button stays enabled
- Distinct messages for distinct failures: empty → "Email is required"; malformed → "Please enter a valid email" / "Invalid email address" (Frame.io shows both states on the same field)
- Skiff explains the RULE not just the failure: "Email address must begin and end with a letter or number."
- Slite OTP error pairs with recovery path: "This verification code is invalid. Try to type it again" + "Keep this window open while checking for your code. Click here to receive a new code."
- Mixpanel puts a ⚠ icon inside the input's right edge in addition to the message
- Problem: field-level recoverability without losing input
- Microcopy worth stealing: all of the above; also Amie field-help tone "tip: use your personal email so you never loose access… we also love nicknames!"
- A11y note: color + icon + text (Mixpanel) is the most robust combo observed; error adjacency to field aids screen-reader association

## Pattern: phone-input-with-country-code
- Apps observed in: Revolut, Revolut Business, Origin, OpenAI Platform, Pi, Zoom
- Mobbin URLs:
  - Revolut split flag+code box: https://mobbin.com/screens/13b89a7a-b54a-47f9-9d4d-3e8516265e27
  - Revolut Business searchable country dropdown: https://mobbin.com/screens/4b141508-40d8-4cd6-84b2-233ef0bed04f
  - Origin labeled Country select + phone: https://mobbin.com/screens/d1ece2a5-014d-4da1-8f59-572ced1a0c1b
  - OpenAI Platform flag dropdown + format placeholder: https://mobbin.com/screens/faac72d5-c0ec-406e-b079-249c93c860be
  - Pi stacked country select over number field + SMS consent text: https://mobbin.com/screens/6c1481a5-b453-4de4-b7bc-2c7460a9704f
  - Zoom country select + toast error: https://mobbin.com/screens/2a858826-3605-4617-81b5-244350d561ec
- Anatomy as observed:
  - Flag + dial code segment left of the number field (Revolut, OpenAI) OR full-width "United States (+1)" select stacked above the number (Pi, Zoom)
  - Country dropdown is SEARCHABLE with flag + dial code + country name rows (Revolut Business)
  - Format hint placeholder inside field: "+1 (415) 123-4567" (OpenAI)
  - Purpose explanation under label: "Enter your phone number. We will send you a confirmation code" (Revolut)
  - Constraint stated upfront: "Currently, Origin invest only supports US based phone numbers." (Origin)
- Sad paths observed: Zoom top-center red toast "The phone number is not in the correct format." (toast rather than inline — weaker pattern, error far from field)
- Microcopy worth stealing:
  - "We will send you a confirmation code"
  - Pi SMS consent block: "You agree to receive automated text messages from us… Message and data rates may apply. Text STOP to cancel."
- Mobile/a11y: stacked select+input (Pi/Zoom) is easier on narrow viewports than inline split

## Pattern: order-received-email-on-its-way
- Apps observed in: SeatGeek, Hims, Dollar Shave Club, The Leap, Shop (Shopify)
- Mobbin URLs:
  - SeatGeek "Order received for 1 ticket": https://mobbin.com/screens/cdec0ab9-6559-4aef-88c6-d905b9ab78aa
  - SeatGeek Order Status + Claim Tickets: https://mobbin.com/screens/08c50035-11a1-4730-a168-173dca505797
  - Hims "Order Complete" + spam-folder nudge: https://mobbin.com/screens/1c5b5333-5af3-43e8-8903-9eb9b0ddb830
  - Dollar Shave Club receipt-email echo: https://mobbin.com/screens/39099be5-2baa-4a65-ab9b-d2f62bf1d1a9
  - The Leap "Check your email" purchase: https://mobbin.com/screens/50a533ad-c376-4c2b-b9c9-d42dd1927c3f
  - Shop order confirmed + tracking: https://mobbin.com/screens/963ed1ba-6409-4b58-afe2-92bc14c93735
- Anatomy as observed:
  - Green check + "Order received for 1 ticket" → exact email echoed as a link ("We will send an email with the details to juliansmith.mobbin@gmail.com") → primary "Continue to order details" → "Questions? Check out our Help Center"
  - SeatGeek Order Status page: status pill "● Order fulfilled", explicit ticket-claim handoff copy, black "Claim Tickets" CTA, Order # row, left rail "Helpful Links" (Get Directions / Add to Calendar / Return Tickets / Contact Support), "History" timeline ("4 mins ago — You purchased 1 ticket", green "1 Ticket Confirmed" bar)
  - Right rail value-props at purchase: "Mobile tickets — Tickets will be transferred outside of SeatGeek to your contact email" / "Returnable until Jul 27" / "Buyer Guarantee protected — Every ticket is protected. If your event gets cancelled, we'll make it right."
- Problem: bridging the gap between web confirmation and the email artifact; deliverability sad-path coverage
- Sad paths observed:
  - Spam-folder guidance: "We emailed your order confirmation. Please double check your spam and promotions folders for emails from Hims" (Hims)
  - SeatGeek transfer-claim instructions: "Search your inbox, spam, and junk folders for emails with terms like 'Los Bukis', 'Accept tickets' or 'Sent you tickets'. See our FAQ below…"
- Microcopy worth stealing:
  - "Your ticket has been transferred to {email}."
  - "Thank you for purchasing! Check your email for a link to your recently purchased product." (The Leap)
  - "A receipt is being sent to {email}." (DSC)
  - Hims fun confirmation: "🎉 Order Complete — Your future self called, they want us to thank you!" + "Have Questions? support@forhims.com"

## Pattern: checkout-hold-countdown-timer
- Apps observed in: Navan, Klook
- Mobbin URLs:
  - Navan "Time left to book" rail timer: https://mobbin.com/screens/cfc068c4-80a2-4bf9-91e3-7a719ab697ee (also https://mobbin.com/screens/591a1ba2-cead-4bfe-b449-a335846b2f6b, https://mobbin.com/screens/2d8f94cf-45b7-4242-b2dd-c7bccdcc38c7, https://mobbin.com/screens/df149a99-536e-4d78-853a-e31f382fe033)
  - Navan abandon-intent modal: https://mobbin.com/screens/51566e80-c3eb-4942-967e-c2253386a25a
  - Klook "Awaiting payment 00:13:44": https://mobbin.com/screens/c7d634f7-7bd4-4067-a492-9db0de516196
- Anatomy as observed:
  - Navan: persistent purple block in booking-summary rail — "Time left to book — 17 min : 35 sec" + consequence copy "Book before the timer runs out to secure this rate. If the timer expires, you'll need to run your search again."; separate "Hold for 23h : 38m" option with release-policy footnote; "Not ready to book? … Save to trip" escape hatch
  - Navan exit-intent modal: "Are you sure? Book now to secure your current price. Prices may frequently increase due to availability and demand." + optional dropdown "Reason for not completing: Just checking prices will book later" + Yes / "Back to checkout"
  - Klook pending-payment state as page header: large orange "Awaiting payment 00:13:44" + amount + "Continue booking" / "Cancel booking" buttons + Booking reference ID; guest names partially masked ("John Smith ********")
- Problem: inventory hold honesty — tell the user exactly what expires and what happens after
- Sad paths observed: timer expiry consequence explicitly documented; cancel-booking path adjacent to continue
- Microcopy worth stealing:
  - "Time left to book — Book before the timer runs out to secure this rate. If the timer expires, you'll need to run your search again."
  - "Awaiting payment 00:13:44"
  - "Not ready to book? Save this flight to your trip and come back any time to book. Pricing and availability may change until you book."

## Pattern: duplicate-account-already-exists-recovery
- Apps observed in: Spotify, Pinterest, DoorDash, Blue Apron, Attio, Surfshark
- Mobbin URLs:
  - Spotify inline "already connected" + Log in link: https://mobbin.com/screens/16082076-0599-4645-9ec8-0a94e3d96f9a
  - Pinterest "Deja vu! That email's taken." + Log into existing account button: https://mobbin.com/screens/2bd9465b-b423-42a6-88ac-b14c8e6dddda
  - DoorDash yellow warning panel with both options: https://mobbin.com/screens/a29511c9-f6ec-49a1-8e2b-47ec2a9bc76c
  - Blue Apron phone-number duplicate modal with cross-brand login: https://mobbin.com/screens/fc668e1d-ced1-4347-9778-108c60511f7a
  - Attio rejected-domain variant with explanation rail: https://mobbin.com/screens/02006c9e-9674-4542-b569-ef78168102c2
  - Surfshark linked-account dialog: https://mobbin.com/screens/f2c3eabc-c7bf-4308-b59f-1a4c298f8016
- Anatomy as observed: duplicate detection happens AT the email/phone field, error always pairs the problem with the recovery action in the same breath:
  - Inline text + login link: "⚠ This email is already connected to an account. Log in." (Spotify)
  - Inline text + secondary button: error under field PLUS persistent "Log into existing account" button below the primary CTA (Pinterest)
  - Callout panel with both paths: "The email address you entered is already associated with an account. Sign in to your account or enter a different email to create a new account." (DoorDash)
  - Modal takeover for cross-product accounts: "An account with this phone number already exists" + "Login with Wonder account" (Blue Apron)
- Problem: dedupe registrations without dead-ending the user — duplicate is rerouted, never just refused
- Microcopy worth stealing:
  - "Deja vu! That email's taken." (Pinterest — friendly tone)
  - "This email is already connected to an account. Log in."
  - "Sign in to your account or enter a different email to create a new account."
- Note: a public-event "you have already registered for this event" screen specifically did not surface; account-exists is the closest observed analogue

## Pattern: saved-progress-resumable-application
- Apps observed in: Coinbase (institutional onboarding), Employment Hero, Contra, Remote
- Mobbin URLs:
  - Coinbase resumable application hub 25%: https://mobbin.com/screens/86bf2576-80c8-4204-bee8-98aaf3ec0498
  - Coinbase hub at 50% with COMPLETE badge: https://mobbin.com/screens/ad7ff92e-fa8a-45fb-a3bc-5770c85e7472
  - Employment Hero "Save As Draft" + "Save & Continue" dual buttons: https://mobbin.com/screens/8544a108-664e-4a12-909e-e9eae3014fcf
  - Contra "Save project as draft?" modal: https://mobbin.com/screens/bc3b2d29-7028-4378-8754-12bb8c49af2d
  - Remote profile wizard with completed-step chips: https://mobbin.com/screens/d8a30d6d-a843-4314-b063-f1b1652f0e77
- Anatomy as observed:
  - Coinbase: application dashboard, "25% complete" progress bar, sections as cards with NOT STARTED / COMPLETE status chips and "0 / 12 questions completed" counters, Start/Edit per card, passive "Saved" indicator chip
  - Employment Hero: long form ends with Back · "Save As Draft" (secondary) · "Save & Continue" (primary)
  - Remote: wizard header row of completed-step chips (✓ Job type ✓ Workplace … 8. Resume) acting as both progress and navigation; "Skip" available on optional steps
- Problem: long registrations (think abstract submission / multi-delegate forms) survive interruption
- Microcopy worth stealing:
  - "Your application is saved and you can return to this screen at any time." (Coinbase)
  - "A draft project is only visible to you. You can see it on your profile, but it is hidden from others." (Contra)
  - "0 / 12 questions completed" per-section counters
- File-upload microcopy (Employment Hero, bonus): "Click or Drag file(s) here to upload — Please use only the following file formats: .JPG, .JPEG, .PNG, .PDF, .DOC, .DOCX, maximum size of each file is 10 MB"

## Pattern: full-registration-flow-end-to-end (flow-level evidence)
- Apps observed in: Posh (3-screen RSVP flow), Eventbrite (12-screen free-event flow), Luma (2-screen ticket flow)
- Mobbin URLs (flows):
  - Posh "Reserving a ticket": https://mobbin.com/flows/3a20172c-7b9b-44c7-a2bd-ba3bf05e986a
  - Eventbrite "Registering for a free event": https://mobbin.com/flows/a94b807a-ad75-416f-978d-b30cce883861
  - Luma "Ticket": https://mobbin.com/flows/59e64944-d65d-4b96-b72a-36db0bac6546
- Step sequences as observed:
  - Posh: (1) dark event page — hero, venue, datetime, "Terrence and 55 others going" avatar row (social proof), red full-width RSVP → (2) confirmation card over page with "Stay in the loop" SMS opt-in toast: "Get event updates and promotional texts from {host}. You can unsubscribe anytime." buttons "No, email me instead" / "Yes, text me updates →" → (3) settled confirmation: View Ticket · Add to Calendar · Add to Apple Wallet buttons, QR "Get the app" panel, app value props (Instant ticket access / Easy ticket transfers / Curated For you); event-page CTA now disabled reading "You have RSVP'd to this event"
  - Eventbrite: event page ("$12 – $295" price range + "Get tickets" card) → ticket tier modal → Checkout step "Contact information" with HOLD TIMER in header ("Time left 29:54"), "Logged in as samlee.mobbin@gmail.com. Not you?", First/Last/Email fields, 2 pre-checked marketing checkboxes, "By selecting Register, I agree to the Eventbrite Terms of Service", orange Register → POST-ORDER survey page "Your organizer needs more details — To issue your ticket, your organizer needs some more information. Any personal details will remain private." with vertical progress (✓ Order successful → ✎ Answer questions → Get your tickets) and organizer questions (Year of Study, focus dropdowns, "How did you learn about this event?" radio list) → final "Thanks for your order! #12019198323" + blue "Take me to my tickets" + "1 TICKET SENT TO {email} / Change" + Follow-organizer card + cross-sell rail "Make more plans with these events" + social share icons
- Problems solved: complete job-level reference; Eventbrite splits PAYMENT-critical fields (before order) from organizer survey fields (after order is already secured) — registration completes fast, profiling happens post-commit
- Sad paths observed: checkout hold timer; "Not you?" identity escape; "Change" email correction after order
- Microcopy worth stealing:
  - "Your organizer needs more details — To issue your ticket, your organizer needs some more information. Any personal details will remain private."
  - "1 TICKET SENT TO {email} — Change"
  - "You have RSVP'd to this event" (disabled CTA as state memory)
  - "Get event updates and promotional texts from {host}. You can unsubscribe anytime." with "No, email me instead" as the refusal option (channel choice, not consent dead-end)

## Pattern: per-attendee-details-on-multi-ticket-order
- Apps observed in: Eventbrite (buyer side + organizer config), Luma (host-side direct add)
- Mobbin URLs:
  - Eventbrite "Ticket 1 · {tier}" per-attendee form with "Copy buyer information" checkbox: https://mobbin.com/screens/e6bf50dd-0150-4dd7-9595-95792f87a8f2
  - Eventbrite Order Form config "Collect information from: Buyer only / Each attendee": https://mobbin.com/screens/d2066a74-3096-472d-bd64-a1478eb56130
  - Luma "Add People Directly" host panel with "Specify names for guests" toggle + name/email rows + "+ Add Row": https://mobbin.com/screens/fee959aa-1fdf-4394-a337-65d3f81259e4 (also https://mobbin.com/screens/c63fb370-fe68-4d1d-a699-84e10f1b062e, https://mobbin.com/screens/4a7e4dd9-74e3-4af9-9db7-3fee4c06a0a8)
- Anatomy as observed:
  - Eventbrite: each ticket gets a titled section "Ticket 1 · Recent Graduate/Early-Career Professional"; first ticket offers "Copy buyer information" checkbox to prefill from buyer; per-ticket First/Last/Email + organizer custom fields (School Name*, Employer*, Occupation*…)
  - Organizer decides per ticket type whether info is "Buyer only" or "Each attendee" (toggle pills) with per-tier checkboxes
  - Luma host bulk-add: "Paste or enter emails here" OR toggle "Specify names for guests" to get name+email row pairs; target selector "Add Guest To: Full Series / Individual Sessions"; consent + behavior bullets
- Problem: delegate group registrations (e.g., department registering several doctors) where each badge/certificate needs its own identity
- Microcopy worth stealing:
  - "Copy buyer information"
  - "Collect information from: Buyer only | Each attendee"
  - Luma direct-add bullets: "We will let them know they have been added to the event. / They will not need to pay or register. / Please only add people who have consented to be added."

## Pattern: cancel-registration-flow
- Apps observed in: Luma, Nike, Eventbrite, Airbnb, SeatGeek, Peerspace
- Mobbin URLs:
  - Luma Cancel Registration confirm dialog: https://mobbin.com/screens/0169525d-afaf-4922-b48c-a75796efcbea
  - Nike Cancel Registration confirm: https://mobbin.com/screens/a456d5da-4c5d-4efa-9baf-3f5a450e98e0
  - Eventbrite "Cancel Free Order" confirm: https://mobbin.com/screens/52cef21e-0312-4e2f-8892-4a4db235b146
  - Airbnb 3-step cancellation with refund math: https://mobbin.com/screens/c87bbf1b-291c-4bc9-a3fd-739a48a84898
  - SeatGeek Returns page: https://mobbin.com/screens/a94a548f-f496-44bf-a39b-450a6131c56f
  - Peerspace "Withdraw booking" with reason radios: https://mobbin.com/screens/0b203a39-19fb-4d23-bcc3-4cb5dc54941c
- Anatomy as observed:
  - Free/simple events: single confirm dialog. Luma: "Cancel Registration — Click on the confirm button below to cancel your registration. We'll let the host know that you can't make it." Confirm / Dismiss. Nike: "Are you sure you want to cancel your spot in the {event}?" Confirm. Eventbrite: "Cancel Free Order — Are you sure you want to cancel this order?" with explicit "No, nevermind" / "Yes, cancel this order" buttons (both options labeled, no ambiguous OK/Cancel)
  - Paid: Airbnb stepper "1. Select reason › 2. Send message › 3. Confirm cancellation" with refund math in rail (Original total / Paid to date / Total refund) + "Cancellation policy: Full refund: Get back 100% of what you paid."; Peerspace collects reason radio ("I found another space / My event is cancelled / My dates are changing / This space is too expensive / Other") and notes "Once withdrawn, the temporary hold will be removed from your credit card."
  - SeatGeek Returns: per-order card with "Returnable Until Jul 27" + "Return Tickets" button — returns framed as credit ("Return your tickets for credit to use on a future purchase.")
- Problem: self-serve cancellation reduces ops load; reason capture feeds organizer analytics
- Microcopy worth stealing:
  - "We'll let the host know that you can't make it."
  - "No, nevermind" / "Yes, cancel this order"
  - "Returnable until {date}"

## Pattern: sold-out-and-sales-closed-public-states
- Apps observed in: Posh, SeatGeek, Eventbrite, Shopify (checkout), 
- Mobbin URLs:
  - Posh event page with disabled "Ticket sales are closed for this event" pill CTA: https://mobbin.com/screens/441f86dd-896d-42b7-8898-182998c7db42 and https://mobbin.com/screens/2bbf4ac2-6531-4cd9-9dab-c7bb2caafa01
  - SeatGeek "No tickets available" + Track Event: https://mobbin.com/screens/5d18cb93-f971-4892-a49d-eb4586ebc1c1
  - SeatGeek venue with no events: https://mobbin.com/screens/2b277b1f-4f26-4bca-bd29-c1e869ea94ce
  - Eventbrite per-tier "Sold out" chip while other tiers stay buyable: https://mobbin.com/screens/4d2e8663-1bbf-41a6-b8ad-d1f4edba35f1
  - Shopify mid-checkout "Inventory issues" dialog: https://mobbin.com/screens/547fb1a1-9a32-4735-9f0b-2cb868b137b2
- Anatomy as observed:
  - Posh: page stays fully informative (dates rail with future occurrences, "More Dates", attendee avatars) — only the CTA pill changes to disabled grey "Ticket sales are closed for this event"; existing registrants keep "View your ticket" button top-right
  - SeatGeek: sleeping-Zzz illustration, "No tickets available — Track this event and we'll tell you when we find some", "♡ Track Event" (notify-me alternative to a dead end)
  - Granularity matters: tier-level "Sold out" ≠ event-level closed; Eventbrite keeps the rest of the modal alive
  - Race-condition sad path (Shopify): inventory vanished during checkout — dialog "Inventory issues — Some items are no longer available." itemizing the SOLD OUT item with "Return to cart / Continue checkout"
- Problem: dead-end avoidance — every closed state offers an alternative action (track, other dates, view your existing ticket)
- Microcopy worth stealing:
  - "Ticket sales are closed for this event"
  - "No tickets available — Track this event and we'll tell you when we find some"
  - "Bummer! There aren't any events — Check back another time"
  - "Inventory issues — Some items are no longer available."

## Pattern: email-otp-verification-step
- Apps observed in: Coinbase, Hulu (MyDisney), Dub, Aboard, WorkOS, 1Password, Slite (from earlier query)
- Mobbin URLs:
  - Coinbase 6-box code: https://mobbin.com/screens/e302fcde-aa11-4cd1-aece-39704947227c
  - Hulu/MyDisney with expiry note: https://mobbin.com/screens/d1980564-5231-4b0c-8236-a1b3a51e5d43
  - Dub minimal: https://mobbin.com/screens/0ac1ff20-7f60-46bf-ac7c-f4429d054bbf
  - Aboard with spam hint: https://mobbin.com/screens/3c65e490-88a3-4538-bce1-8af2f5f3a5cb
  - WorkOS auto-advance boxes: https://mobbin.com/screens/9feab1e3-9190-41ef-abf5-c44c1014256d
  - 1Password single input + dual recovery links: https://mobbin.com/screens/9f5872a0-7456-48e8-a4b3-65861523d4ca
- Anatomy as observed: headline ("Verify your email address" / "Check your email inbox") → email echoed in bold → 6 individual digit boxes (or one 6-char field, 1Password) → Continue (disabled until complete; Dub) → recovery links: "Resend Code", "Didn't receive the email? Resend", and crucially 1Password's second path "Wrong email address? Go back."
- Sad paths observed: code expiry stated upfront ("a 6-digit code which expires in 15 minutes" — Hulu); spam-folder hint ("Can't find your code? Check your spam folder!" — Aboard); wrong-email recovery ("Wrong email address? Go back." — 1Password)
- Microcopy worth stealing:
  - "We've sent an email to {email} containing a 6-digit code which expires in 15 minutes. Please enter it below."
  - "This helps us keep your account secure by verifying that it's really you." (Coinbase)
  - "Wrong email address? Go back."
- A11y/mobile: digit boxes auto-advance; single-field variant (1Password) is more paste-friendly and screen-reader friendly

## Pattern: professional-details-section (adjacent — profile/research panels, not conference registration per se)
- Apps observed in: Fiverr, User Interviews, Grain
- Mobbin URLs:
  - Fiverr Professional Info step with skill checkboxes: https://mobbin.com/screens/348874c2-1110-43f5-9ab5-f01b8c7c16ab
  - User Interviews Professional details panel: https://mobbin.com/screens/dfa21e83-2819-41f0-8447-9d60aa0b82b0
  - Grain "Tell us about yourself" profiling: https://mobbin.com/screens/b89c7e9d-4d17-4999-afe9-d5eabf111c74
- Anatomy as observed: stepper with completion rate ("Completion Rate: 50%"); occupation dropdown + constrained multi-select ("Choose two to five of your best skills…"); User Interviews: left checklist nav (Contact information ✓ / Phone verification ✓ / Professional details / Demographic details / Technical details) + "PROFILE STRENGTH" meter + searchable skill tag input ("Type to search (requires >= 2 characters)"); required markers + "* Mandatory fields" legend
- Relevance: closest analogue to medical-registration fields (specialty, MCI number, institution, designation) — structure: own titled section, dropdowns over free text, searchable tag selects
- NOTE: no true conference-specific registration (specialty/license) screens surfaced — gap recorded in Coverage

## Pattern: payment-failed-recovery
- Apps observed in: Unity, Revolut, TikTok Ads, Wise, Pitch, Coinbase
- Mobbin URLs:
  - Unity full-page failure on Payment step: https://mobbin.com/screens/c598fa3d-6ac6-40fc-bebc-cddfc355bb81
  - Revolut failure modal with Retry / Try another method: https://mobbin.com/screens/082268c6-c6b1-42c6-8997-84561d5b9488
  - TikTok 3DS failure modal: https://mobbin.com/screens/da50f3b7-e5ad-46d1-95dd-a9448a018fd0
  - Wise detailed bank-decline callout above the card form: https://mobbin.com/screens/683f2cf9-9c88-4b4c-be24-3f0e5663b38e
  - Pitch red top banner "Your card was declined…": https://mobbin.com/screens/c3db6d97-b791-486b-b18e-483b37f65d14
  - Coinbase unsupported-card dialog: https://mobbin.com/screens/a584b34b-45e5-4c89-b737-12cf7e140ba8
- Anatomy as observed:
  - Failure shown WITHOUT losing checkout context: banner above form (Pitch, Wise) or modal over the payment step (Revolut, TikTok); stepper stays on Payment (Unity: Order ✓ → Your info ✓ → ✖ Payment → Confirmation)
  - Always ≥1 recovery action: "Return to Payment details" / "Retry" + "Try another method" / "Try again"
  - Wise's gold-standard message explains cause AND two ways out: "Your card payment attempt was unsuccessful as your bank did not authorize the payment. Please try again and if the problem persists, contact your bank's card payment department… Alternatively, you can fund this payment via another payment method or by using a different card."
- Problem: paid-registration failure must never eat the delegate's form data or strand them
- Microcopy worth stealing:
  - "We could not process your payment. Something went wrong with the payment. Please try again."
  - "Your card was declined. Check with your bank or try another payment method."
  - "This credit card is not supported. Try a different card."

## Pattern: add-to-calendar-provider-chooser
- Apps observed in: Udemy, MasterClass, Fresha, Luma
- Mobbin URLs:
  - Udemy "Create an event" modal with Google/Apple/Outlook buttons + .ics explanation: https://mobbin.com/screens/4e4bab0e-ffd9-4b99-8b83-5964a36ad66e (variants https://mobbin.com/screens/2831197b-5c8f-415a-bd01-e4243dea38c5, https://mobbin.com/screens/65aa89f6-1dcd-4757-b6e9-2e42c7f1358f)
  - MasterClass "Add this class to your calendar": https://mobbin.com/screens/e6d13da2-b508-42bb-970c-89ff3d27ded7
  - Fresha "Add to calendar" (Google calendar / Other calendar): https://mobbin.com/screens/a475936f-14fd-44e1-8997-f354763aa13e
  - Luma "Add iCal Subscription" (Google / Outlook / Apple / Copy URL to Clipboard): https://mobbin.com/screens/d935b132-7974-4611-b6e4-5b2aee8e205b
- Anatomy as observed: modal with event summary card (what/when/reminder) → provider buttons (Google with sign-in + live "Added to Google Calendar ✓" status, Apple, Outlook) → explanatory line "Apple and Outlook will download an ics file. Open this file to add it to your calendar." → Done; Fresha simplifies to Google + "Other calendar"; Luma's calendar-feed variant adds "Copy URL to Clipboard" and explains "Add the event feed to your calendar app to keep up with new events and updates."
- Problem: confirmation→calendar handoff across ecosystems; status feedback ("Added" vs "Not yet added to your calendar") prevents double-adds
- Microcopy worth stealing:
  - "Apple and Outlook will download an ics file. Open this file to add it to your calendar."
  - "Not yet added to your calendar" / "Added to Google Calendar"
  - validation nudge when skipped: "Choose your calendar to save your event." (Udemy, red)

## Pattern: multi-session-registration-choice (series vs individual sessions)
- Apps observed in: Luma; slot-picker analogues in Amie, Product Hunt/SavvyCal
- Mobbin URLs:
  - Luma multi-session registration panel: https://mobbin.com/screens/0f303915-1f69-4207-8575-af52b29b6823 and https://mobbin.com/screens/88d14085-8e20-4047-82e5-4549851b9f62
  - Luma Sessions admin "Registration Mode" (Series or Sessions / Series Only / Sessions Only): https://mobbin.com/screens/5f0acabe-c68a-480f-ba2c-fcf6cb869490
  - SavvyCal-embedded booking with "Confirm your details" popover: https://mobbin.com/screens/0a0b0f30-3e8c-4cf9-b7fe-5f10919ff638
  - Amie slot picker with timezone control: https://mobbin.com/screens/6e929d2d-122e-4ac9-95a0-355758ab6a12
- Anatomy as observed:
  - Luma: "Registration — This is a multi-session event. Please choose the sessions you would like to register for." → two price cards: "Full Series US$100.00 / Get access to all sessions" vs "Individual Sessions US$35.00 per session / Choose sessions to join" (radio-selected card gets border + check) → date chips row (Thu, 15 Jun 8:00 · Thu, 22 Jun 8:00 · Tue, 27 Jun 8:00 — selected chip outlined) → identity row (avatar + email) → "Get Ticket"
  - Admin side controls which modes are allowed (Series or Sessions / Series Only / Sessions Only)
  - Scheduling analogues: timezone selector adjacent to slot list ("Times shown in (GMT-07:00) Pacific Daylight Time" — Product Hunt/SavvyCal; "New York City" chip — Amie)
- Problem: conference equivalent = full-conference pass vs single-day/workshop passes with per-session selection in one panel
- Microcopy worth stealing:
  - "This is a multi-session event. Please choose the sessions you would like to register for."
  - "Get access to all sessions" vs "Choose sessions to join" / "per session"

## Pattern: get-ready-before-you-go-block
- Apps observed in: Luma, Tripadvisor (Viator), Cal.com, Square
- Mobbin URLs:
  - Luma "Get Ready for the Event" expanded (profile + reminder toggles): https://mobbin.com/screens/1bd28b3e-549a-4cf6-8e5f-d1fa22e5137a and https://mobbin.com/screens/f2623123-e4ac-43ad-a6fa-353c98f4adc3
  - Tripadvisor booking detail "Before You Go": https://mobbin.com/screens/625520da-f512-4100-a670-79434ae08380
  - Cal.com booking confirmation What/When/Who/Where: https://mobbin.com/screens/89fb725d-05c6-4acd-9091-66c50f16e4ec
  - Square online-event confirmation preview: https://mobbin.com/screens/7f88fc17-bdea-4f75-880e-6942e9900b62
- Anatomy as observed:
  - Luma post-registration prep block: "Get Ready for the Event" accordion → "Your Profile" card with Update Profile + "Configure Reminders" with per-channel Email / SMS toggles
  - Tripadvisor: Confirmation # + Booking Reference # at top; action stack (Get tickets / "Cancel for free by Apr 28" — deadline IN the button label / Edit reservation / Contact tour operator); "Before You Go" bullet list including accessibility notes ("Not wheelchair accessible", "Not recommended for people with difficulties walking on uneven surface") + operator contact; Inclusions & Exclusions; Departure Details; Cancellation Policy ("For a full refund, cancel at least 24 hours in advance of the start time")
  - Cal.com: definition-list confirmation (What / When — with explicit timezone "(Pacific Daylight Time)" / Who — host badge / Where / Additional notes + custom question echo "Which role did you apply for as a volunteer — Illustrator") + "Need to make a change? Cancel" + compact add-to-calendar icon row
  - Sad path (Cal.com): deliverability warning banner "Google's new spam policy could prevent you from receiving any email and calendar notifications about this booking. Resolve"
- Problem: post-confirmation preparation = where conference apps put venue directions, ID requirements, dress code, check-in instructions
- Microcopy worth stealing:
  - "Cancel for free by {date}" (deadline embedded in the button)
  - "Need to make a change? Cancel"
  - Echoing the registrant's own custom-question answers on the confirmation

## Pattern: edit-attendee-details-after-booking
- Apps observed in: Tripadvisor, Airbnb, Booking.com, Klook
- Mobbin URLs:
  - Tripadvisor "Update Travelers": https://mobbin.com/screens/ed4d72ea-0435-46b4-9e09-c46b036d9750
  - Airbnb "What do you want to change?" change-request flow: https://mobbin.com/screens/2b826174-7a6f-4dba-8a54-c382ab19751d
  - Booking.com "Other travelers" profile store: https://mobbin.com/screens/46d1d203-cfcf-472e-82ba-32d4f2bd4736
  - Klook "Participant details" saved-people manager: https://mobbin.com/screens/f103dee2-e1ca-4191-9da8-94b3fe1783f8
- Anatomy as observed:
  - Tripadvisor: per-traveler name/age fields, "Add Traveler" / "Remove", "Maximum: 15 travelers for this activity", primary "Update Information" + escape "Keep current information"; booking summary rail persists (Confirmation #, charge date, free-cancellation deadline)
  - Airbnb: changes become a REQUEST to the host ("After making your desired changes, you can send a request to your host, {name}, to confirm the alterations") — relevant where edits need organizer approval
  - Booking.com: stored co-traveler profiles with document-exact guidance: "Enter this person's name exactly as it's written on their passport or other official travel document." + DOB importance note + consent line "Get permission from your fellow travelers before entering their personal details."
  - Klook: account-level "Participant details — Save your info for faster booking", masked stored data ("**** Doe", "1-******904"), Edit/Remove per person, "Add up to 30 people including yourself", "No ID info entered" empty state
- Problem: post-booking corrections (name on certificate/badge!) without support tickets; identity-document-exact naming is directly applicable to medical certificates
- Microcopy worth stealing:
  - "Enter this person's name exactly as it's written on their passport or other official travel document."
  - "Keep current information" (explicit no-op exit)
  - "Save your info for faster booking"

## Pattern: receipt-invoice-self-service
- Apps observed in: Uber, Uber Eats, Peerspace, Surfshark
- Mobbin URLs:
  - Uber trip details action chips (View Receipt / Resend Receipt / Download Invoice): https://mobbin.com/screens/d1c2c012-755b-4a9a-a023-f0526a088d40 (toast variant https://mobbin.com/screens/29c689b0-44a8-442e-b5ab-09bbdbe2ddfa)
  - Uber receipt modal footer (Print / Download PDF / Resend by Email / Get Help): https://mobbin.com/screens/3befea92-90d8-4fd7-975d-3583f17d0d6f
  - Uber Eats receipt with fee ⓘ tooltips: https://mobbin.com/screens/dd08fe48-3536-432b-852c-0350d5bd518d
  - Peerspace "Your Receipt" page with Receipt # + Booking ID + Download Receipt: https://mobbin.com/screens/8f6a7697-5dc1-445a-a2ce-3c115b4769eb
  - Surfshark "Invoice downloaded" success state: https://mobbin.com/screens/e1a6b487-2a3d-44e2-940d-04c0601247d3
- Anatomy as observed: receipt is reachable from the order/booking detail forever; four standard verbs — View, Print, Download PDF/Invoice, Resend by Email; success toast "Your receipt has been successfully emailed."; itemized fee rows each with ⓘ explanations; receipt metadata (Receipt #, Booking ID, Last Updated)
- Problem: delegates claiming conference-fee reimbursement need a re-downloadable invoice — never make them email the organizer
- Microcopy worth stealing:
  - "Your receipt has been successfully emailed."
  - "Invoice downloaded — Your invoice has been generated and downloaded to your device!"

## Pattern: dietary-accessibility-special-needs-capture
- Apps observed in: Sana AI (event RSVP form), Navan (traveler profile), Klook (special requests), Airbnb (organizer-side accessibility checklist)
- Mobbin URLs:
  - Sana AI event registration with "Food preferences or allergies" field: https://mobbin.com/screens/8d33905f-cb89-432b-9c0e-6b32aef4a837
  - Navan profile "Special meal types" + "Special assistance" dropdowns: https://mobbin.com/screens/1ba5124e-123e-4d03-b07e-389e3200dca1
  - Klook "Special requests (optional)" modal: https://mobbin.com/screens/ff4c8b88-e893-416d-8520-e55052ecd8da
  - Airbnb Guest requirements accessibility checklists: https://mobbin.com/screens/ee21fd01-bfcc-4712-948e-42e360c63127 (variants https://mobbin.com/screens/044fcae9-1fa0-44e6-a1c8-0f792dcb125c, https://mobbin.com/screens/92331520-3aaf-441e-bb45-691b93f1b069)
- Anatomy as observed:
  - Sana AI in-person event RSVP: Email*, First/Last name*, Company*, Job title*, then OPTIONAL free-text "Food preferences or allergies" + unchecked marketing consent — the minimal conference-dinner pattern
  - Navan: structured dropdowns ("Special meal types: Vegetarian", "Special assistance: Wheelchair", "Seat preference") inside profile so they apply to every booking; sticky dark "You have unsaved changes — Revert / Save changes" bar
  - Klook: free-text modal with expectation-setting: "Special requests can't be guaranteed, but the property will do its best to meet your needs" + 42/200 char counter
- Problem: dietary + accessibility data for conference catering/venues, captured at registration
- Microcopy worth stealing:
  - "Special requests can't be guaranteed, but the property will do its best to meet your needs"
  - "Food preferences or allergies" (neutral phrasing, optional)

## Pattern: ticket-transfer-and-complimentary-tickets
- Apps observed in: Posh (organizer comp tickets), Tripadvisor (email ticket), SeatGeek (transfer claim — see order-received pattern)
- Mobbin URLs:
  - Posh "Send Complimentary Tickets" modal (ticket type + qty): https://mobbin.com/screens/da855650-781b-47ca-ac53-cd2a8d966061
  - Posh comp tickets recipient lookup (Email/Phone toggle, "No accounts found", "+ Send to a Non-Posh User"): https://mobbin.com/screens/5439c9c8-dae4-4150-95e1-c94b11a313d8
  - Tripadvisor "Email Ticket" with multiple recipients: https://mobbin.com/screens/41a994f7-f80a-4f0f-bb84-2372261389e4
  - SeatGeek transfer-fulfilled panel: https://mobbin.com/screens/faeb5782-13e0-4766-b16c-d8fa120d479d
- Anatomy as observed: organizer comp flow = pick Ticket Type + quantity → recipient by email or phone (graceful "No accounts found" → "+ Send to a Non-Posh User" fallback for non-members) → Send Ticket; Tripadvisor: "Email Ticket / Recipient 1" + "Add recipient" + Send Ticket with booking summary rail
- Relevance: faculty/VIP complimentary registrations at conferences; forwarding tickets to colleagues
- Microcopy: "+ Send to a Non-Posh User" (non-account recipients are first-class)

## Pattern: my-tickets-hub-with-recovery-link (ios)
- Apps observed in: Eventbrite (iOS), Live Nation (iOS), Meetup (iOS)
- Mobbin URLs:
  - Eventbrite Tickets tab Upcoming/Past with "Coming up" card + QR count badge "1 ⊞": https://mobbin.com/screens/a97455ae-ab04-478a-a251-16996ad7b4f0 and https://mobbin.com/screens/a42a454e-351c-4f15-af61-e87ba338576c
  - Eventbrite empty Past tab: https://mobbin.com/screens/eb62b185-9d31-40d9-bcfb-00d900b9be58
  - Live Nation My Tickets UPCOMING (0) / PAST (1) with account switcher: https://mobbin.com/screens/a8d5a66d-ffe0-4786-b097-97b7e59f04d0 and https://mobbin.com/screens/b63dcb4c-9305-4191-9f12-b433a3be3e7a
  - Meetup "Your calendar" ALL / GOING (3) / SAVED (1) / PAST: https://mobbin.com/screens/02399a61-21ea-413d-8b5b-2afdd837dda3
- Anatomy: tickets hub = Upcoming/Past segmented tabs; ticket card shows date/time, QR icon + count; persistent lost-ticket recovery link under list AND in empty states: "Something missing? Find your tickets" / "Not seeing your tickets? Learn more about how to find them. Find my tickets"; Live Nation empty state "You have not purchased or received any tickets yet" with the linked email account visible (explains WHICH account is being checked)
- Problem: ticket retrieval re-entry point + wrong-account diagnosis
- Microcopy worth stealing: "Something missing? Find your tickets"; "Not seeing your tickets?"

---

## Coverage

### Queries run (31 total; search_screens deep unless noted)
1. "event registration form attendee details" (web) — Luma, Eventbrite, Partiful, Nike
2. "ticket selection tier picker event checkout" (web) — Posh, Eventbrite, Klook, SeatGeek
3. "registration confirmation page QR code ticket" (web) — SeatGeek, Expedia, Klook, Luma, Headspace, Booking.com, KAYAK
4. "add ticket to apple wallet" (ios) — Gametime, Luma, Eventbrite, StubHub
5. "join waitlist sold out event tickets" (web) — Kit, Fresha, Square
6. "event ended registration closed empty state" (web) — PARTIALLY DRY for public-facing; mostly admin empty states (Kajabi, Luma, Homerun, Spotify, Product Hunt)
7. "approval required request to attend pending approval event" (web) — Airbnb, Luma
8. "multi step form progress indicator checkout steps" (web) — Uvodo, QuickBooks, HubSpot, Wise, Urban Outfitters, SuperHi
9. "inline form validation error message invalid email required field" (web) — Frame.io, Nike, Skiff, Mixpanel, Slite, Amie
10. "phone number input with country code selector form" (web) — Revolut, Origin, Revolut Business, OpenAI Platform, Pi, Zoom
11. "guest checkout email confirmation check your inbox" (web) — Shop, The Leap, SeatGeek, Hims, Dollar Shave Club
12. "countdown timer reservation hold tickets reserved checkout" (web) — Navan, Klook
13. "already registered account already exists error sign in instead" (web) — Blue Apron, Spotify, Pinterest, DoorDash, Attio, Surfshark
14. "save draft autosave resume application later" (web) — Coinbase, Remote, Employment Hero, Contra
15. search_flows "register for an event and get ticket confirmation" (web) — Posh 3-step, Luma 2-step, Eventbrite 12-step flows
16. "group registration buy tickets for multiple guests assign attendee names" (web) — Eventbrite, Luma
17. "cancel registration refund ticket cancellation" (web) — Eventbrite, Airbnb, SeatGeek, Luma, Peerspace, Nike
18. "sold out event page tickets unavailable sales ended" (web) — Eventbrite, SeatGeek, Posh, Shopify
19. "verify email enter six digit code sent to your inbox" (web) — Coinbase, Hulu, Dub, Aboard, WorkOS, 1Password
20. "conference registration professional details specialty organization job title" (web) — ADJACENT ONLY: Fiverr, User Interviews, Grain (no true conference forms)
21. "payment failed card declined error checkout retry" (web) — Unity, Revolut, TikTok, Wise, Pitch, Coinbase
22. "add to calendar google outlook apple options after booking" (web) — Udemy, MasterClass, Fresha, Luma
23. "invite friends share event after RSVP referral" (web) — DRY for this job (generic SaaS referral: Deel, Manus, Codecademy, Airbnb, Otter.ai, Preply)
24. "select sessions workshops agenda during event registration" (web) — Luma multi-session, Amie, Product Hunt/SavvyCal, Cal.com
25. "know before you go event entry instructions confirmation reminder" (web) — Luma, Tripadvisor, Cal.com, Square, Eventbrite
26. "edit my registration details change attendee information after booking" (web) — Tripadvisor, Airbnb, Booking.com, Klook, SavvyCal
27. "download receipt invoice after payment booking" (web) — Uber, Uber Eats, Peerspace, Surfshark
28. "dietary requirements accessibility needs special requests form" (web) — Sana AI, Navan, Klook, Airbnb
29. "early bird pricing deadline tickets price increases soon" (web) — DRY for this job (generic SaaS promos: Base44, Whop, Heidi, Docusign, Sketch); early-bird tier itself already evidenced in Posh screen (query 2)
30. "transfer ticket to another person send tickets" (web) — MARGINAL new: Posh comp tickets, Tripadvisor email ticket (SeatGeek already captured)
31. "my tickets list upcoming events past tickets" (ios) — MARGINAL new: recovery links + empty states (Eventbrite, Live Nation, Meetup)

### Apps observed across the sweep
Luma, Eventbrite, Partiful, Posh, Nike, Klook, SeatGeek, StubHub, Gametime, Expedia, Booking.com, KAYAK, Headspace, Fresha, Square, Kit, Kajabi, Homerun, Spotify, Product Hunt, Airbnb, Uvodo, QuickBooks, HubSpot, Wise, Urban Outfitters, SuperHi, Frame.io, Skiff, Mixpanel, Slite, Amie, Revolut, Revolut Business, Origin, OpenAI Platform, Pi, Zoom, Shop, The Leap, Hims, Dollar Shave Club, Navan, Blue Apron, Pinterest, DoorDash, Attio, Surfshark, Coinbase, Remote, Employment Hero, Contra, Peerspace, Shopify, Hulu, Dub, Aboard, WorkOS, 1Password, Fiverr, User Interviews, Grain, Unity, TikTok, Pitch, Udemy, MasterClass, Cal.com, Tripadvisor, Uber, Uber Eats, Sana AI, SavvyCal, Live Nation, Meetup, OpenSea, Deel, Manus, Codecademy, Otter.ai, Preply

### Could NOT find (gaps)
- A true PUBLIC-FACING "registration closed / event ended" page (only Posh's disabled "Ticket sales are closed for this event" CTA pill and Luma's admin-side closed state surfaced)
- A medical/academic conference registration form specifically (specialty, license/MCI number, member vs non-member fee categories, abstract submission) — closest analogues: Eventbrite organizer custom questions, Fiverr/User Interviews professional-details sections
- An explicit "you have already registered for THIS EVENT" duplicate-registration error (account-already-exists was the closest analogue)
- A waitlist-position / "you're #N in line" status screen on web
- An attendee-facing badge-pickup / on-site check-in instructions screen (Tripadvisor "Before You Go" is the nearest analogue)
- Form autosave indicator on a PUBLIC form (observed only in authenticated application contexts: Coinbase, Employment Hero)

### Dryness stopping point
Stopped after queries 29 (dry), 30 (marginal), 31 (marginal) — two consecutive sweeps yielding no substantially new patterns for the job. Seed list of 14 exhausted plus 17 follow-ups.
