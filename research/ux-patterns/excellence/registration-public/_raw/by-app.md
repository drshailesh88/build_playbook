# BY-APP Raw Harvest — Public Event Registration → Confirmation/Ticket/QR

Job-to-be-done: register as an attendee for an event via a public form, receive confirmation with ticket/QR.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## Luma (web)

### L1. Flow: "Registering for an event" (one-click RSVP → inline confirmation)
- Mobbin URL: https://mobbin.com/flows/eadb6cd5-cc36-4e9e-9c4f-70df3558da90
- Steps observed:
  1. Event detail panel (cover image, host avatar+name, date/time with timezone, venue + city) with a "Registration" card: greeting "Hello! To join the event, please register below.", the signed-in identity row (avatar, name, email) shown ABOVE the button, then a single full-width "Register" button.
  2. Card flips in place to "You're In" state: emoji avatar, "A confirmation email has been sent to jsmith.mobbin2@gmail.com.", live countdown row "Event starting in — 2d 6h", "Add to Calendar" buttons (Google/Apple icons), link "No longer able to attend? Notify the host by canceling your registration."
  3. Green toast bottom-center: "Thank you for registering!"
  4. Next-step teaser row: "Get Ready for the Event — Profile Complete · Reminder Off" (expandable).
- Problem solved: zero-friction RSVP — identity is pre-resolved, so registration is one click; confirmation replaces the CTA in place (no page navigation), and the page itself becomes the ticket/status surface.
- Sad paths observed: cancellation is offered as a calm text link inside the success state, not a destructive button. Event list shows "Sold Out" and "Near Capacity" status chips on cards before the user even clicks in.
- Microcopy worth stealing:
  - "You're In"
  - "A confirmation email has been sent to {email}."
  - "Event starting in 2d 6h"
  - "No longer able to attend? Notify the host by canceling your registration."
  - "Thank you for registering!"
  - "Get Ready for the Event"
- Mobile/a11y: confirmation state fits in the same side-panel card; countdown is text not canvas.

### L2. Flow: "Registering to event" (registration with custom questions modal)
- Mobbin URL: https://mobbin.com/flows/fea2a437-a576-4214-a44f-f1d34f54857d
- Steps observed:
  1. Event page with "Register" CTA in Registration card.
  2. Modal "Your Info": identity row (avatar, name, email) confirmed at top, then host's custom question as required field — "Is this your first time attending a RubySG meetup? *" (dropdown "Select an option"), single "Register" button.
  3. Confirmation: "You're In" card with "A confirmation email has been sent to {email}", "Add to Calendar", "Invite a Friend" button, "Starting in 1d 1h" chip, cancel-registration text link.
  4. Toast: "Thank you for registering!"
- Problem solved: host-defined questions are injected as a single light modal between click and confirmation — form is only as long as the host made it; identity fields never re-asked.
- Microcopy: modal title "Your Info"; "Invite a Friend" as the viral loop on the success state.

### L3. Flow: "Accepting an invitation (guest)" (invite variant)
- Mobbin URL: https://mobbin.com/flows/28703fea-9a9b-4a8c-aff3-f3946bd89f14
- Steps observed:
  1. Private event page ("Private Event" pill on header). Registration card states "You are Invited — We'd love to have you join us." + host welcome message + identity row + paired buttons: primary "Accept Invite" / secondary "Decline".
  2. "You're In" state: "A confirmation email has been sent to {email}", countdown "Event starting in 14h 23m", note "The join button will be shown when the event is about to start." (virtual/Zoom event), "Add to Calendar", cancel link, "Get Ready for the Event — Profile Complete · Reminder: Email".
- Problem solved: invitation acceptance reuses the exact same card chrome as open registration; decline is one click; for virtual events the ticket is a time-gated Join button with expectation-setting copy.
- Microcopy:
  - "You are Invited — We'd love to have you join us."
  - "The join button will be shown when the event is about to start."

### L4. Flow: "Event registration" (2-screen variant)
- Mobbin URL: https://mobbin.com/flows/e02a2851-bfcc-4a64-9e47-f9222b4f3b98
- 2 screens; same register → confirmation in-place pattern (event page CTA → confirmed state).

### L5. Host-side registration config (context for what guest sees)
- Observed within flow results (Luma admin "Registration" tab screens):
  - Tickets list with "Require Approval" toggle per ticket type.
  - "Registration Emails — Customize the emails sent when a guest registers, is approved or rejected": three email cards "Registration Received" / "Registration Approved" / "Registration Rejected".
  - "Registration Questions — We will ask guests the following questions when they register": Identity section (Name, Email Address marked Required, note "We always ask guests for their name and email."), optional verified-field sections, "Custom Questions — You are not asking guests additional questions." + "Add Questions" button.
- Problem solved: explains the guest-side trio of states (received → approved/rejected) and why guest forms stay short.

### L6. Listing-level capacity signals
- Observed in flow screens (Luma Singapore events listing within flow fea2a437...): event cards carry status chips "Sold Out" (red) and "Near Capacity" before click-through; attendee avatar stacks + "+50" counts as social proof.
- Problem solved: capacity expectation set at discovery level, before the user invests in the event page.

---

## Partiful (web)

### P1. Flow: "Attending an event" (emoji RSVP → modal → confirmation)
- Mobbin URL: https://mobbin.com/flows/746c6688-1714-4ca0-8e30-01311aaf2ec5 (13 screens)
- Steps observed:
  1. Event page: title, date/time, host, location, "10/10 spots left" capacity counter, description. RSVP = three large emoji buttons: 👍 "I'm Going" / 🤔 "Maybe" / 😢 "Can't Go". "Open Invite | All Hosts' Mutuals" toggle row visible.
  2. RSVP modal keeps the three emoji choices at top (selected one highlighted), then minimal fields: YOUR NAME, PHONE NUMBER (with country flag selector) + trust copy "Just for event updates. No spam.", ATTENDEE COUNT dropdown ("2 attendees" — +1s), optional "+Post a comment" with GIF picker. CANCEL / CONTINUE.
  3. Optional comment + GIF attached ("Wow!" + "I'M SO EXCITED" GIF) shown in modal before continue.
  4. Conditional gate modal: "COVID-19 Safety" rules card — "Please respect COVID-19 safety guidelines in your area..." + bolded requirement "Guests are required to bring and wear masks at the event." Single button "ACCEPT & CONTINUE".
  5. Back on event page: full-screen ambient confirmation (background animation), RSVP area now shows selected emoji with label "Going", capacity decremented to "8/10 spots left", "Going" count on side rail incremented to 2, send/share button next to status.
- Problem solved: RSVP status is a first-class tri-state (going/maybe/can't go) not a binary register; phone number captured with explicit anti-spam reassurance; +1s handled at RSVP time; host policy acknowledgment inserted as a blocking gate before confirmation.
- Sad paths observed: "Can't Go" is an equal first-class option (decline captured, not just absence); capacity counter "x/10 spots left" visibly decrements.
- Microcopy worth stealing:
  - "Just for event updates. No spam."
  - "I'm Going / Maybe / Can't Go"
  - "8/10 spots left"
  - "ACCEPT & CONTINUE" (policy gate)
- Mobile/a11y: emoji buttons are huge tap targets with text labels under each.

### P2. Flow: "Responding to a poll" (find-a-time + restricted access + profile upsell)
- Mobbin URL: https://mobbin.com/flows/0b4e9a1d-e80f-4613-a6ce-70064e4536a9 (9 screens)
- Steps observed:
  1. Event page in "Finding a Time..." mode: date option cards (August 9th / August 10th), "Respond to help find a time", location masked with "Respond to see location" link, "Restricted Access — Respond to see what everyone else picked" card. Primary CTA "RESPOND".
  2. Respond modal: "Responding" state with avatar, "RSVPING AS Alex Smith" + editable, "1 attendee" dropdown, "+Post a comment" + GIF. CANCEL/CONTINUE.
  3. Post-response profile upsell modal: "Here to make friends? Drop those socials" — avatar with photo upload, chips "+Instagram +Twitter +Snapchat", "+ Add bio", quiet exit "RETURN TO EVENT".
- Problem solved: content-gating (location, others' answers) creates an incentive to respond; profile enrichment is asked AFTER commitment, never before; exit is always available.
- Microcopy:
  - "Respond to see location" / "Restricted Access — Respond to see what everyone else picked"
  - "Here to make friends? Drop those socials"
  - "RETURN TO EVENT"

### P3. Flow: "Editing RSVP"
- Mobbin URL: https://mobbin.com/flows/40407146-d3b4-4d07-b94a-fd4734bc1072
- RSVP is editable after submission via the same modal (change status, +1 count, comment). Guest-detail view (host side) shows "Going +0" dropdown with +N stepper (+1...+9), "Updated to Going on 8/06 - 1:14pm" audit line, Questionnaire tab showing the guest's answer to required question "How old are you? *", and "RSVP History" tab.
- Problem solved: RSVP is a living record with edit history, not a one-shot form submit; hosts see questionnaire answers and status-change audit trail per guest.

### P4. Host-side RSVP settings (context)
- Observed within flow results (Event Settings → RSVPs panel): "Require Guest Approval — Guests request to 'Get on the list'. Only guests you approve can see event details"; "Accept RSVPs" toggle with note "By default, RSVPs close 2 hours after the event starts"; "Set Max Capacity — Limit the number of guests (and +1s) who can RSVP 'Going'"; "Enable Waitlist — Allow guests to join a waitlist once max capacity is reached & automatically update their RSVP and notify them if spots open"; "Limit +1s"; "RSVP Button Style (Emojis)"; "Allow Guests to Invite Mutuals". Open Invite audience modal: All Hosts' Mutuals / Select Mutuals / Turned Off ("Only people with the link have access").
- Problem solved: documents the waitlist auto-promotion pattern ("automatically update their RSVP and notify them if spots open") and approval-required pattern ("Get on the list") as guest-facing behaviors.
- Microcopy: "Get on the list" (approval-required CTA), "RSVPs close 2 hours after the event starts".

---

## Eventbrite (web)

### E1. Flow: "Registering for a free event" (checkout-style registration + post-purchase questions)
- Mobbin URL: https://mobbin.com/flows/a94b807a-ad75-416f-978d-b30cce883861 (12 screens)
- Steps observed:
  1. Event page: hero image carousel, date headline, title, price range card "$12 – $295" with single CTA "Get tickets"; "ALL AGES" restriction label; save/share icons.
  2. Checkout modal, step "Contact information": header shows "Checkout" + countdown "Time left 29:54" (cart hold timer). "Logged in as samlee.mobbin@gmail.com. Not you?" link. Fields: First name*, Last name*, Email (prefilled, edit icon). Marketing consent checkboxes: "Keep me updated on more events and news from this event organizer." / "Send me emails about the best events happening nearby or online." Legal line: "By selecting Register, I agree to the Eventbrite Terms of Service." CTA "Register". Right rail: order summary (event date/time, "1 x Recent Graduate/Early-Career Professional $0.00", "Delivery — 1 x eTicket $0.00", Total $0.00).
  3. Post-order organizer questions step: right rail explains with a 3-step progress ladder — "Your organizer needs more details — To issue your ticket, your organizer needs some more information. Any personal details will remain private." Ladder: "Order successful ✓ → Answer questions → Get your tickets". Left side: required dropdowns ("Year of Study *", "Focus of study/area of interest *"), radio list "How did you learn about this event? *" (newsletter, Eventbrite, Instructor/mentor, Friend/colleague, Instagram, TikTok, LinkedIn, Facebook, Twitter/X, Threads...), "Recent Grad Graduation Year *".
  4. Confirmation: green check + "Thanks for your order!" + order number "#12019198323", primary button "Take me to my tickets". "YOU'RE GOING TO {Event title}", grid: "1 TICKET SENT TO {email} (Change link)" / DATE / LOCATION. Organizer follow card: "Don't miss out on events from {Organizer} — 2592 followers — Follow". Share icons (FB, Messenger, Twitter, email). Right rail: "Make more plans with these events" cross-sell carousel.
- Problem solved: ORDER FIRST, QUESTIONS AFTER — the order is committed before the long organizer questionnaire, so question abandonment can't kill the registration; progress ladder makes the extra step legible; privacy reassurance ("Any personal details will remain private") at the moment of asking; ticket delivery email is changeable from the confirmation itself.
- Sad paths observed: cart hold countdown ("Time left 29:54") implies expiry path; email "Change" link on confirmation handles wrong-email recovery.
- Microcopy worth stealing:
  - "Your organizer needs more details — To issue your ticket, your organizer needs some more information. Any personal details will remain private."
  - "Order successful → Answer questions → Get your tickets"
  - "Thanks for your order!" + visible order number
  - "YOU'RE GOING TO"
  - "1 TICKET SENT TO {email} — Change"
  - "Logged in as {email}. Not you?"

### E2. Flow: "Purchasing a ticket" (paid variant)
- Mobbin URL: https://mobbin.com/flows/2cd43d7d-47ab-4634-99a7-632733cc5a74 (9 screens)
- Steps observed:
  1. Ticket selection modal: event title + dates in header, Promo Code field at top, ticket types as cards with quantity steppers (− 0 +): "VIRTUAL FEST on ZOOM — $12.00 +$2.64 Fee / +$0.97 Sales Tax — Sales end on Mar 30, 2025 — Watch all the magic on the MAIN STAGE from anywhere in the world!" and "All Together Now Weekend Pass — $295.00 +$21.63 Fee / +$20.96 Sales Tax — Sales end on Mar 28, 2025" with inclusion details. Empty-cart icon in right rail until selection. CTA "Check out".
  2. "Billing information" step: same identity block, marketing checkboxes, "Pay with" list: Credit or debit card / PayPal / Google Pay (radio cards). Legal: "By selecting Place Order, I agree to the Eventbrite Terms of Service." Right rail order summary itemizes Subtotal / Fees ⓘ / Sales Tax / "Delivery — 1 x eTicket $0.00" / Total ($15.61). Countdown "Time left 19:53".
  3. Confirmation identical chrome to free flow ("Thanks for your order! #...", "Take me to my tickets").
- Problem solved: fees and taxes disclosed per ticket type BEFORE selection (no surprise at total); sales-end dates per ticket; quantity steppers per type; one confirmation pattern for free and paid.
- Microcopy: "Sales end on Mar 30, 2025", fee transparency inline "+$2.64 Fee / +$0.97 Sales Tax".

### E3. Flow: "Apply a promo code" (with error sad path)
- Mobbin URL: https://mobbin.com/flows/b6c5b114-eeb8-4815-b4f3-3990ccb295d1 (3 screens)
- Steps observed: Promo Code field at top of ticket modal → typed "BEATL123" + Apply → error state: red border, red exclamation icon, message below field: "Sorry, we don't recognize that code."
- Problem solved: invalid promo handled inline without losing ticket selections.
- Microcopy: "Sorry, we don't recognize that code."

### E4. Flow: "Creating tickets" (host-side, context)
- Mobbin URL: https://mobbin.com/flows/037dfb3c-8304-4e5b-9468-434827c47246 (7 screens)
- Observed: ticket types Paid / Free / Donation ("Let people pay any amount for their ticket"); per-ticket: name, available quantity, price, "Absorb fees" checkbox, sales start/end date+time; Tickets dashboard with per-type status dots ("On Sale · Ends Oct 18...", "Scheduled · Starts after General Admission"), sold counts "0/5", "0/20", and "Event capacity 0/25" with tooltip "This is the maximum number of tickets that can be sold at your event, including all ticket types."
- Problem solved: explains guest-side scheduled-ticket behavior (a type can start selling only after another ends) and the event-level vs ticket-level capacity distinction.

---

## Luma — approval / waitlist state machine (screens)

### L7. Screen: Registration tab with approval-mode email states
- Mobbin URL: https://mobbin.com/screens/1f1b14d3-e759-43f3-9a8f-9c67d8f680af
- Observed: Tickets row "Standard — Free — [Require Approval] tag — 0 registered". Status cards: "Registration: Open", "Event Capacity: 1,000 · Waitlist On", "Group Registration: Off". Registration Emails section: "Customize the emails sent when a guest registers for the event and for when you approve or decline their registration" with three cards: "Pending Approval / Waitlist" (grey check) / "Going" (green check) / "Declined" (red x).
- Problem solved: names the canonical guest registration state machine: Pending Approval / Waitlist → Going | Declined, each with its own email. Waitlist and pending-approval share one communication slot.

### L8. Screen: Guests tab — approving a pending guest
- Mobbin URL: https://mobbin.com/screens/68dc9ea7-e6ed-41eb-a36f-0c43a2e416c3
- Observed: "At a Glance — 0 guests / cap 1,000" progress bar with legend "1 Pending Approval · 1 Invited"; guest list rows with status chips (Going green, Invited blue) and ticket type "Standard"; green toast "Guest approved."
- Problem solved: capacity bar + status-chip legend make the pending/invited/going funnel visible at a glance.

### L9. Screen: Registration Questions config (required levels)
- Mobbin URL: https://mobbin.com/screens/9afcce75-ecb8-478a-8145-fb88660d98c0
- Observed: per-field requirement dropdown Off / Optional / Required; identity fields Name + Email always Required ("We always ask guests for their name and email.").

### Adjacent analog (same query): Airbnb pending-request pattern
- "Your request is pending" page — https://mobbin.com/screens/e0a41354-15eb-4085-80fb-1488334b3b6a — copy: "This isn't a confirmed reservation—yet." + explicit timeline ("...who then has 24 hours to respond. We'll also send you an email when your reservation is officially confirmed.") + "Show pending request" button.
- "Request sent" modal — https://mobbin.com/screens/a31f99b7-228e-46d4-897b-6156152baa7c — "Chiara & Nonna will respond after your request has been reviewed." Close / Show request.
- "Your reservation is pending — Your Host has 24 hours to confirm." card with "Pending" badge — https://mobbin.com/screens/da39f676-9e3b-4338-a622-454ba8b19973
- Worth stealing for approval-pending registrations: state the SLA ("within 24 hours"), state the notification channel ("we'll email you"), and give a persistent place to view the pending request.

### L10. Screen: Ticket QR modal over event page (guest ticket)
- Mobbin URLs:
  - https://mobbin.com/screens/77b1ff06-4a3e-4cdb-a4d5-50f82c9ec9b8 (VERCI SUMMER STUDIO)
  - https://mobbin.com/screens/46e06266-500a-471c-812c-18cbecdd98f5 (Ruby SG November Meetup)
- Observed: clicking the ticket affordance on a registered event opens a centered modal: large QR code on white card, event title beneath, then identity fields ("Guest: Jane" in one variant; "Name: Alex Smith / Email: alexsmith.mobbi..." in the other). The dimmed background still shows the "You're In" card, countdown, Add to Calendar, cancel link.
- Problem solved: the QR is the check-in credential, accessible from the event page itself (no separate wallet/app needed); name+email printed under the QR lets staff verify identity manually if scan fails.
- Mobile/a11y: QR rendered at large size with high contrast on white; identity in plain text below as fallback.

### E5. Screen: Eventbrite "Order form" host config (Order Options)
- Mobbin URL: https://mobbin.com/screens/a4f25a38-9646-4373-b688-b28c74fc3b58
- Observed: "Order form — Personalize your checkout experience. We collect first name, last name and email by default. Customize the information you collect from your attendees. Change the time limit for checking out." Plus "Save time by copying an order form from another event" with search + empty state "Nothing matched your search — Try searching for something else — or — Create new form from scratch". Sidebar reveals dedicated Order Options sections: Order Form / Order Confirmation / Registration Transfers / Waitlist.
- Problem solved: confirms Eventbrite's feature set around the job: configurable checkout time limit, per-event order form reuse, registration TRANSFER as a first-class feature, and waitlist as a standalone module.
- Note: dedicated guest-facing waitlist/sold-out screens did not surface for Eventbrite web in this query.

---

## Adjacent analogs — waitlist mechanics (surfaced while hunting ticketing waitlists)

### A1. Fresha — Flow: "Joining waitlist" (fully-booked → waitlist with preferences)
- Mobbin URL: https://mobbin.com/flows/13c4d86b-b5dd-446d-8451-66c17cf96e32 (12 screens)
- Steps observed:
  1. Fully-booked state inside booking: "Denise is fully booked on this date — Available from Wed, 14 Aug" with recovery actions "Go to next available date" / "Check all professionals" and a quiet link "You can join the waitlist instead."
  2. "Join the waitlist" page: "Select your preferred dates and time. We'll notify you if a time slot becomes available." Date + Time dropdowns, "+ Add another time", escape hatch "Changed your mind? See available times to book".
  3. "Review and confirm to join the waitlist": payment method "Pay at venue" with reassurance "You won't be charged now, payment will be collected in store if your appointment is confirmed."; free-text "Waitlist notes — Include any comments or special requests". CTA "Join the waitlist".
  4. Account view: "Awaiting availability" chip, "You're on the waitlist — We'll be in touch if a time becomes available.", "Leave waitlist — Remove yourself from the waitlist" action, preferred dates + services recap.
- Problem solved: full waitlist lifecycle — entry from a dead-end with alternatives first, preference capture, no-charge reassurance, persistent status page, self-serve exit.
- Microcopy: "We'll notify you if a time slot becomes available." / "You won't be charged now..." / "You're on the waitlist" / "Awaiting availability" / "Leave waitlist".

### A2. Contra — Flow: "Joining a waitlist" (position + referral)
- Mobbin URL: https://mobbin.com/flows/99b355b2-26c9-4de4-865d-28c37e36d451
- Observed: "Claim your spot — We are rolling out access to small groups at a time as we refine the experience." + live counter "56,460 PEOPLE ON THE WAITLIST" + "Join the waitlist" → "You are on the waitlist: 56,452 — YOUR PLACE ON THE WAITLIST" + "Move up the waitlist by referring your friends — The more friends that join, the sooner you will get access." with copy-link + share buttons.
- Worth stealing: showing your numeric place on the waitlist; referral as queue-jump (product waitlist, not event — use with care).

### A3. Square Appointments — host-side waitlist module
- Mobbin URL: https://mobbin.com/flows/87033d09-924f-4073-8a38-c2adfc2b271f
- Observed: Waitlist tab with "Introducing: Automated notifications — Automatically notify clients on the waitlist of new availability that matches their requested time slots."; empty state "No waitlist requests — Clients can join your waitlist through your online booking site."; table columns Client / Service / Staff / Availability preference.
- Worth stealing: waitlist entries carry availability PREFERENCES, and matching triggers automated notification.

---

## Luma — paid / multi-session / approval-required (second pass)

### L11. Flow: "Registering for a session" (multi-session event with ticket-tier picker)
- Mobbin URL: https://mobbin.com/flows/86faf8f5-5790-482e-8f8a-9b74f01658b8 (6 screens)
- Steps observed:
  1. Registration card on event page: "This is a multi-session event. Please choose the sessions you would like to register for." Two selectable tiers as radio cards: "Full Series — US$100.00 — Get access to all sessions" vs "Individual Sessions — US$35.00 per session — Choose sessions to join", then session-date chips (Thu, 15 Jun 8:00 / Thu, 22 Jun / Tue, 27 Jun) to multi-select. Identity row, CTA "Get Ticket" (disabled until valid selection — shown greyed).
  2. Checkout overlay: left "Your Info" (identity) + "Payment — Credit or Debit Card *" single card field, CTA "Pay with Card". Right: order summary card — event thumbnail+title+date, "Registering For: 1 Session", "Coupon — Redeem" link, "Total US$35.00".
  3. Listing cards show price chips (US$100.00, US$50.00) and "N Sessions" count before click-in.
- Problem solved: bundle-vs-single pricing decision made inline on the event page, not a separate pricing page; payment is one field + one button; coupon hidden behind a "Redeem" link so it doesn't distract.
- Microcopy: "This is a multi-session event. Please choose the sessions you would like to register for." / "Get access to all sessions" / "Choose sessions to join" / "Registering For — 1 Session".

### L12. Guest-facing approval-required microcopy (seen on event-page preview)
- Mobbin URL: https://mobbin.com/flows/a448a49a-8f63-4b14-99ee-8f37a8c899bb (screen 1 region) and admin Overview screen within flow 826ad04c-98f6-4f68-ac83-76af66479d46
- Observed: event page registration card variant labeled "Approval Required — Your registration is subject to approval by the host." above the register CTA; admin Registration tab confirms states (L7). Also "Donate" button next to "Contact" under Hosts; "Support the Host" modal: identity row, Amount field (US$ 10), "Credit or Debit Card *" inline card field, CTA "Pay with Card".
- Problem solved: expectation set BEFORE submission that registering creates a request, not a confirmed seat.
- Microcopy: "Approval Required — Your registration is subject to approval by the host."

### L13. Flow: "Registration" (host config 3-screen)
- Mobbin URL: https://mobbin.com/flows/826ad04c-98f6-4f68-ac83-76af66479d46
- Observed: Registration tab — status tiles "Registration: Open / Event Capacity: 1,000 · Waitlist On / Group Registration: Off"; per-field requirement pickers Name (Required) / Email (Required) / Phone (Off) / ETH Address (Off) / SOL Address (Off); "+ Add Question"; Registration Emails trio "Pending Approval / Waitlist", "Going", "Declined".

---

## Sold-out / closed / urgency states (cross-app screen sweep)

### E6. Eventbrite — Screen: sold-out tier + scarcity badge + donation fallback
- Mobbin URL: https://mobbin.com/screens/4d2e8663-1bbf-41a6-b8ad-d1f4edba35f1
- Observed: in ticket-selection modal, "General Admission — Free" row has its stepper zeroed/disabled and a grey "Sold out" pill; below, a "Donations" section ("Donation to the Center for Communication" with $ amount field, "Sales end in 2 days - Fees and taxes will be calculated before you place your order."); bottom bar shows orange urgency chip "🔥 Few tickets left" beside "Check out".
- Problem solved: per-tier sold-out (other tiers/donations still purchasable); scarcity badge drives urgency without blocking; sold-out is a pill on the row, not a dead page.
- Microcopy: "Sold out" (pill), "🔥 Few tickets left", "Sales end in 2 days".

### T1. Posh — Screen: ticket sales closed event page
- Mobbin URL: https://mobbin.com/screens/441f86dd-896d-42b7-8898-182998c7db42
- Observed: dark-theme event page (Cookie Meet-Up) with venue, date, description, social proof ("Samantha and 5 others going" + avatar circles), multi-date selector cards (Jan 31 / Feb 28 / Mar 28 / Apr 28 + "More Dates"), and the CTA replaced by a disabled grey pill: "Ticket sales are closed for this event". Top-right nav keeps "View your ticket" for existing holders.
- Problem solved: closed state keeps the page alive — other dates remain selectable and existing ticket holders still reach their ticket; the disabled CTA states WHY it's disabled.
- Microcopy: "Ticket sales are closed for this event".

### L14. Luma — Screen: "Pending Approval / Waitlist Email" editor
- Mobbin URL: https://mobbin.com/screens/dbeeee6e-82a0-4514-9570-aa5c4667be9d
- Observed: email editor panel: "Pending Approval / Waitlist Email — This email is sent when a guest registers for the event, notifying them that their registration is pending approval or that they are on the waitlist." Subject auto-set "Registration pending approval for Tech Meetup"; "You can insert variables by typing {"; "Update Email" / "Send a Preview".
- Problem solved: confirms pending-approval and waitlist share one immediate acknowledgment email; default subject line is a steal-able template.

### A4. Square (public booking site) — Screen: waitlist confirmation page
- Mobbin URL: https://mobbin.com/screens/e9eea825-1468-4313-b187-1e442ddd873f
- Observed: "You're on the waitlist! — We'll let you know if a spot opens up!" with recap card (Services, Availability window "Jan 1 – Jan 23, 2025 — Any time") and full-width "Cancel request" button.
- Microcopy: "You're on the waitlist! We'll let you know if a spot opens up!"
- Also observed (Square SMS, https://mobbin.com/screens/b40b8cab-aeb8-4b51-b610-fe4a03c80c0d): automated text "Hi Alex, you have been successfully added to the waitlist for SLMobbin. Manage your request: {link}" — waitlist confirmation delivered over SMS with self-service manage link.

### A5. User Interviews — Screen: added-to-waitlist apology framing
- Mobbin URL: https://mobbin.com/screens/3f094651-edef-4ced-a00e-3f39011b1ba6
- Observed: centered card: "You've been added to the waitlist — We're sorry, but this project, {name}, is currently full. We've added you to the waitlist and will be in touch with you if a spot opens up."
- Problem solved: full-capacity submission converts automatically to a waitlist entry (no dead end), with apology + what-happens-next in two sentences.

---

## Luma (iOS) — ticket + check-in

### L15. Flow: "View ticket" (iOS)
- Mobbin URL: https://mobbin.com/flows/c186b93d-4002-48cc-a0d8-f0359f8e58ec
- Steps observed:
  1. Event page with confirmed status line "✓ You are going" directly under the date; action row: "My Ticket" (first position, highlighted) / Contact / Share / More.
  2. Full-screen ticket: event title at top, giant QR on white rounded card against dark background, "Ticket — 1x Standard" (quantity x type), full-width "Add to Apple Wallet" button.
- Problem solved: the ticket is one tap from the event page; QR maximized for scan distance/contrast; wallet export for offline access.
- Microcopy: "You are going", "My Ticket", "1× Standard", "Add to Apple Wallet".

### L16. Flows: "Checking in a guest" / "Checking in guests" (host scanner — the other side of the QR)
- Mobbin URLs: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f (8 screens), https://mobbin.com/flows/26b0f3ea-2156-43d2-b580-f4774fbb7fc7 (4 screens)
- Observed: host event page has "Check In Guests" action; camera scan view; on scan, bottom sheet with guest avatar, name, email, fields "Status: Going (green)", "Registration Time: Today, 8.17 PM", "Ticket: Standard", big "Check In" button; after check-in: green toast "Check In Successful", sheet now shows "Checked In: Today at 9:44 AM" and "Undo Check In". Guest List screen has status tabs: Going / Invited / Not Going / Pending, with per-status empty state "No Guests — There are no guests of this status."
- Problem solved: scan result shows identity + registration status BEFORE committing the check-in; undo is immediate; attendance timestamp pair (registered at / checked in at) is the audit trail.
- Microcopy: "Check In Successful", "Undo Check In", tabs "Going / Invited / Not Going / Pending".

---

## Partiful (iOS) — approval + waitlist mechanics

### P5. Flow: "Turning on guest approval" (how the CTA mutates)
- Mobbin URL: https://mobbin.com/flows/0c7f8f27-c727-4d91-b55b-2a1897ec0c87
- Observed: enabling approval shows an explainer sheet: "Guest Approval — Guests will request to 'Get on the list' instead of RSVPing Going/Maybe/Can't Go. Current guests will be marked as: 👍 Going (1) → 🪙 Approved, 🤔 Maybe (1) → 🪙 Approved." CTA "Turn on Guest Approval". After enabling, the event page's RSVP Options area shows a single "Get on the list" button replacing the tri-state emoji row.
- Problem solved: mode switch explicitly migrates existing RSVPs' states and changes the guest-facing verb from commitment ("Going") to request ("Get on the list").
- Microcopy: "Get on the list" / "Guests will request to 'Get on the list' instead of RSVPing Going/Maybe/Can't Go".

### P6. Flow: "Enabling a waitlist" (capacity + waitlist toggle)
- Mobbin URL: https://mobbin.com/flows/1284a348-cf38-4cce-a120-76d542ca6703
- Observed: event spots field defaults "Unlimited spots"; entering "25 total spots" reveals a "Waitlist" toggle on the same row; after enabling, field renders as "25/25 spots left — Waitlist [on]". RSVP button style selectable (e.g. "Hearts": ❤️ Going / Maybe / Can't Go). Also "RSVP Deadline" field and "Guests can invite friends" toggle.
- Problem solved: waitlist only exists relative to a finite capacity; live "x/y spots left" copy is generated from the same setting the guest sees.

### P7. Flow: "Manage guests" (status chips + host-only visibility)
- Mobbin URL: https://mobbin.com/flows/aab8ef96-56f4-4af3-96a5-b2792a0a1810
- Observed: Manage Guests list with status filter chips "👍 Going 1 / 🤔 Maybe 0 / ❤️ Invited 1", per-guest status dropdowns, divider "Only visible to hosts" separating invited-but-unresponded guests.

---

## Posh (web) — nightlife ticketing

### T2. Flow: "Checking out an event" (event page → pay → ticket with QR)
- Mobbin URL: https://mobbin.com/flows/8b4f1874-7d8e-48c9-aaf9-d1ca0f14f05b (9 screens)
- Steps observed:
  1. Event page: themed background derived from artwork, venue + datetime, description, social proof "Julio and 12 others going" with avatar row, sticky pill CTA "Get tickets".
  2. Payment modal: event recap (poster, venue, date) on left; right: payment method tabs "Card / Google Pay", "🔒 Use saved payment" dropdown, card number / expiration / CVC / country fields, fine print "By providing your card information, you allow {organizer} to charge your card for future payments in accordance with their terms.", CTA shows the amount: "Pay $25.00", quiet "Back" link.
  3. Confirmation/ticket sheet: event poster + title + venue/date; action row "View Ticket" (primary) / "Add to Calendar" / "Add to Apple Wallet"; QR code displayed with "Get the app" framing and app upsell panel: "The app unlocks more — Instant ticket access · Easy ticket transfers · Curated For You".
- Problem solved: pay button carries the exact amount; saved-payment reuse; confirmation surface IS the ticket (QR + wallet + calendar in one card); ticket transfer advertised as a capability.
- Microcopy: "Pay $25.00", "The app unlocks more — Instant ticket access / Easy ticket transfers", "Julio and 12 others going".
- Sad path (see T1): same event chrome later shows "Ticket sales are closed for this event" disabled pill; nav retains "View your ticket" for holders. Referral hook on closed page: "Turn Invites Into Income — Invite friends, earn $8.00 per order."

---

## Adjacent analogs — payment failure (no event-app payment-failure screens surfaced; nearest checkout patterns)

### A6. Navan — "Payment not completed" modal
- Mobbin URL: https://mobbin.com/screens/3802a618-6a29-4e76-b71f-c3088b71e9a1
- Observed: modal with card illustration: "Payment not completed — Your payment could not be processed with the card selected. To complete your booking, please choose a different payment method." Single recovery CTA "Change payment". Booking held with visible countdown "Time left to book 7 min : 33 sec".
- Also https://mobbin.com/screens/2931d92d-1799-496d-be62-7043c18bb14d: "Oh no! There was an issue with your booking — Your payment could not be processed at this time. Contact your card's issuing bank to resolve." with "Chat with support" + "See Hotels".

### A7. Wise — inline card-declined banner
- Mobbin URL: https://mobbin.com/screens/683f2cf9-9c88-4b4c-be24-3f0e5663b38e
- Observed: error banner above the card form: "Your card payment attempt was unsuccessful as your bank did not authorize the payment. Please try again and if the problem persists, contact your bank's card payment department... Alternatively, you can fund this payment via another payment method or by using a different card." Form stays filled; "Pay another way" back link.
- Worth stealing: failure explains WHO declined (the bank, not the platform) and offers two recovery routes without losing form state.

### A8. HoneyBook / Klook / Wayyy — decline toasts/modals
- HoneyBook https://mobbin.com/screens/4527351d-aba0-476e-9472-b3d92f08a8dd: corner toast "Something went wrong — Your payment method was declined. Please try again, or contact your bank for assistance. Any further questions? Please contact concierge@honeybook.com".
- Klook https://mobbin.com/screens/657da509-9e42-4aea-9a17-8f8214845a7c: fraud-hold message "We noticed some unusual activity on this booking. To protect your account, your transaction was declined... Please reach out to customer support. [reference id]" — includes a support reference number.
- Wayyy https://mobbin.com/screens/e905f1a7-8219-47d6-ba0b-c9d0c30cef58: "Payment Unsuccessful — Please reach out to the team at hello@wayyy.co if the error continues." + Continue.

---

## Professional/conference-style registration forms

### S1. Sana AI — Flow: "Event detail" (B2B/professional event registration — closest analog to conference delegate form)
- Mobbin URL: https://mobbin.com/flows/8f9b6e8e-45ee-4e30-b107-06a6629753dc
- Steps observed:
  1. Events listing: city tag chips (Copenhagen / Helsinki / Berlin), date + time, title, venue address per card.
  2. Event page: centered editorial layout — date/time line, big title, venue line, descriptive paragraphs, "Speakers:" list (name, title, company).
  3. Registration form card floated over a venue photo: Email* / First name* / Last name* / Company name* / Job title* / "Food preferences or allergies" (optional, free text) / consent checkbox "I agree to Sana sending me marketing communications, as described in the Privacy and Cookie policy" / full-width "Submit".
- Problem solved: minimal professional registration — six fields, only one optional; dietary/allergy capture inline (directly relevant to medical-conference delegate forms); explicit unticked marketing consent separate from registration.
- Mobile/a11y: single-column form, asterisks on labels, generous field height.

### T3. Posh — Flow: "Adding custom checkout fields" (host side; what guests see at checkout start)
- Mobbin URL: https://mobbin.com/flows/475f92f5-0e60-47f9-b438-df5cb80c0585 (8 screens)
- Observed: "Custom checkout fields allow you to gather additional info from attendees during the checkout process. They appear at the beginning of checkout." Field types: Text Input / Checkboxes / Dropdown / File Upload. Per-field: Required toggle, "Limit to specific tickets..." selector (question shown only for chosen ticket tiers, e.g. "Grab Your Seat!" tag), checkbox builder with "Select up to 2" constraint in the question text. Settings hub also shows "Checkout — Checkout Flow, Custom Fees, Buttons", "Policies — Terms of Service & Refund Policy", "Custom Checkout Fields", and a "Refund Request Pending" pill on the event report bar.
- Problem solved: per-ticket-type questions (ask only the people it applies to) and file upload as a checkout field type (useful for student-ID/abstract-proof style uploads); questions positioned BEFORE payment, contrast with Eventbrite's after-payment approach (E1).

### L17. Luma — Screen: scarcity + approval banners stacked above the CTA, "Apply to Join" verb
- Mobbin URL: https://mobbin.com/screens/b330d0a0-e5d2-4eb8-885b-8f48c83311e9
- Observed: guest-facing registration card opens with two stacked notice rows: "⏳ Limited Spots Remaining — Hurry up and register before the event fills up!" and "👤 Approval Required — Your registration is subject to approval by the host." Then multi-session chooser, identity row, and the CTA verb changed to "Apply to Join" (rendered disabled until a session is selected).
- Problem solved: when approval mode is on, the button verb itself changes from "Register" to "Apply to Join" — the strongest expectation-setting device observed; scarcity and approval status are disclosed BEFORE any input.
- Microcopy: "Limited Spots Remaining — Hurry up and register before the event fills up!" / "Apply to Join".

---

## DICE (iOS) — music ticketing

### D1. Flow: "Tickets" (ticket page with delayed QR activation + waiting list affordances)
- Mobbin URL: https://mobbin.com/flows/48a42616-6d54-4b83-9599-ca7a37f08769
- Observed: ticket sheet for a purchased event: "Your ticket — 1 x General Admission"; row "Send ticket to a friend — Not available for this event - why?" (disabled with an explanation link); row "Add to the Waiting List — Unavailable for this event"; education block "How tickets work — They have QR codes that you'll be able to activate in the 2 hours before the event. At the venue, show your QR codes to be..."; large disabled CTA "ACTIVATE WED, MAY 22".
- Problem solved: anti-scalping pattern — QR exists but only activates near event start, and the UI teaches this up front; disabled capabilities (transfer, waitlist) are shown with reasons rather than hidden.
- Microcopy: "How tickets work — They have QR codes that you'll be able to activate in the 2 hours before the event." / "Not available for this event - why?" / "ACTIVATE WED, MAY 22".

### D2. Flow: "Buying a ticket" / event pages
- Mobbin URLs: https://mobbin.com/flows/a58042a3-984d-4b45-a6c0-d8ffea540f66 (6 screens), https://mobbin.com/flows/c36e7d8b-88bf-4e61-a190-f3429581cf4b
- Observed: event page bottom bar pairs the all-in price with the CTA: "$65.92 — BUY NOW"; discovery cards show "From $55.16" and "Free" price chips and an "RSVP" tag for free events; quantity badge on saved-event cards; "Invite friends" row on event page.
- Problem solved: price (with fees) attached to the buy button; free events use RSVP vocabulary while paid use BUY — verb matches commitment.

### D3. Screen: already-registered + ticket-limit state (within "Following an artist" flow results)
- Mobbin URL: https://mobbin.com/flows/ee44724c-466f-43e1-b57d-e2f815d13a2c (screen 1)
- Observed: event-info sheet for an event the user holds a ticket to: persistent footer "You're going — 1 x General Admission" with ticket icon; "BUY NOW" rendered disabled with caption "Ticket limit reached". Event info includes refund policy inline: "ⓘ You can get a refund if: • This event is rescheduled or cancelled". "Doors open at 8:00 pm" under Venue.
- Problem solved: the already-registered state converts the buy bar into a status bar and explains WHY repurchase is blocked ("Ticket limit reached"); refund conditions disclosed on the event page, not buried in TOS.
- Microcopy: "You're going — 1 x General Admission" / "Ticket limit reached" / "You can get a refund if: this event is rescheduled or cancelled".

---

## Adjacent analogs — expired / used / already-accepted links (no event-app screens surfaced)

- Clay invite link: "Not Found — We could not find this invite. Maybe it has already been used?" — https://mobbin.com/screens/4e84282b-5e3d-4cb9-b8b6-6defdc7e8e89
- NordVPN: "400 error — This link has expired. If you've requested a password reset, please use the most recent link we sent you. To request a new link, go back to login and select Forgot your password?" + Attempt ID for support — https://mobbin.com/screens/dfa9ee24-160c-445b-b605-623b2f588d2b
- Linear: "Invitation already accepted — If you think this is a mistake or if you have trouble logging into the workspace, please contact the workspace admins or Linear support." + "Go back" — https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e
- Worth stealing: expired/used links should diagnose the likely cause, point to the freshest artifact ("use the most recent link we sent you"), and carry a support reference ID.

---

## Cancellation / refund flows

### L18. Luma — Flow: "Canceling a registration" (guest self-serve cancel)
- Mobbin URL: https://mobbin.com/flows/d947278c-7299-4f93-a40d-2d6d8b03437a
- Steps observed:
  1. From the "You're In" card, link "canceling your registration" opens modal: "Cancel Registration — Click on the confirm button below to cancel your registration. We'll let the host know that you can't make it." Buttons: "Confirm" (red) / "Dismiss".
  2. Card flips to "You're Not Going — We hope to see you next time! Changed your mind? You can register again." (register-again link inline). Green toast: "You've canceled your registration."
- Problem solved: cancel keeps the relationship warm — explicit "we'll tell the host" transparency, graceful copy, and an immediate one-click path to re-register.
- Microcopy: "We'll let the host know that you can't make it." / "You're Not Going — We hope to see you next time!" / "Changed your mind? You can register again." / "You've canceled your registration."

### E7. Eventbrite — Flow: "Canceling an order" (order page + refund status)
- Mobbin URL: https://mobbin.com/flows/bf4a9dfc-8f3c-46c6-b44a-a1d8b2c88cfd
- Observed: Order detail page "Order #12238537213" with actions "Print tickets / Resend confirmation / Cancel order"; Order Details grid (buyer, purchase date, order total, ticket total, payment details "Free order"); Attendees table with per-attendee BARCODE number + "Unscanned" status, name, ticket type, price. Order management list shows refund lifecycle: "Order #... — $0.00 — Refund processing, may take up to 4 minutes" + yellow chip "Refund issued. Check back in 4 minutes to view updated order." then "Refunded/Canceled on Apr 15, 2025 at 5:25 PM" timestamp; ticket buyer row marked "Refunded".
- Problem solved: "Resend confirmation" as a first-class recovery action; refund is shown as an async process with an expected duration instead of an instant lie; per-attendee barcode + scan status ties registration to check-in.
- Microcopy: "Resend confirmation" / "Refund processing, may take up to 4 minutes".

### L19. Luma — Flow: "Canceling an event session" (host cancels; guests notified)
- Mobbin URL: https://mobbin.com/flows/e2f05678-9d94-4e84-9689-8a7db00d5ad0
- Observed: Sessions tab with "Registration Mode — Choose what guests are allowed to register for the series": Series or Sessions / Series Only / Sessions Only. Cancel Session modal: "This will cancel the session and send an email to guests notifying them of your cancelation." with "Customize Email" toggle (Subject prefilled "Morning Yoga was canceled", Body "Add your custom message here."), destructive CTA "Cancel Session"; toast "Session canceled successfully!"
- Problem solved: host-side cancellation is inseparable from guest notification — the email is composed inside the cancel confirmation, so guests can't silently lose a session.

### E8. Eventbrite — Flow: "Resending a confirmation email"
- Mobbin URL: https://mobbin.com/flows/cbc204a5-1f54-4d42-a46a-c4a7d23d2577
- Observed: from order page, "Resend confirmation" opens modal "Resend confirmation email — Order #12238537213" with an EDITABLE email field and note "All attendee email addresses on this order will also receive the email." Send → green banner "Confirmation email successfully sent to jdoe.mobbin@gmail.com."
- Problem solved: the #1 support ticket ("I never got my ticket email") solved self-serve, including fixing a typo'd email at resend time.
- Note: a guest-facing ticket-transfer flow did not surface for Eventbrite web (host config sidebar lists "Registration Transfers" — see E5; DICE advertises "Easy ticket transfers" — see T2/D1).

### P8. Partiful — Flow: "Creating an account" (phone OTP woven into event context)
- Mobbin URL: https://mobbin.com/flows/f4ead72b-008d-4baf-8347-f4ea61c0dac1 (and login variant https://mobbin.com/flows/d9fd0a8c-7a82-4f17-8926-e0522fa7ee87)
- Observed: modal over the event canvas: "Sign up to save your event — Your number is only used for verification & event updates. We won't call you or give it to anyone." Fields: Name, Phone (flag selector). On submit: inline "We've just sent a 6-digit verification code. It may take a moment to arrive." + VERIFICATION CODE field; consent fine print: "By clicking I AGREE, you agree to our Terms and Privacy Policy and consent to receive text messages from us and hosts. Message and data rates apply. Text HELP for help and STOP to cancel." Button literally labeled "I AGREE". Login page adds playful "😮‍💨 Tired of getting logged out? Use the app ↗".
- Problem solved: account creation is an overlay on the task, not a redirect; OTP expectation-setting ("may take a moment"); SMS consent made explicit at the moment the phone number is captured.
- Microcopy: "Your number is only used for verification & event updates. We won't call you or give it to anyone." / "We've just sent a 6-digit verification code. It may take a moment to arrive."

### T4. Posh — Screen: "My Orders" ticket wallet with QR overlay
- Mobbin URL: https://mobbin.com/screens/4f9ed845-d8ca-40d6-a805-e76c67392649
- Observed: "My Orders" grid — one card per event with poster art, order number, ticket type ("RSVP $0.00", "General Admission $21.83 + Processing Fee", "Grab Your Seat!", "Default Ticket"), total, and per-card icon row (QR, info, receipt, calendar, open). Clicking expands a ticket overlay: event title, order #, date/time, venue, ticket line, big QR with caption "This QR code contains your order information. Show it at the event entrance for scanning."
- Problem solved: all tickets in one wallet page; QR instruction copy tells the guest exactly what to do with it; fees itemized on the wallet card.
- Microcopy: "This QR code contains your order information. Show it at the event entrance for scanning."
- Related analog: SeatGeek marketing screen (https://mobbin.com/screens/625b88bf-2193-4aa9-9d97-62b99c133bd2) shows mobile ticket with QR, seat metadata ("Seat 12 — Section 101 · Row 4"), "View & Print PDF", and Info / Send / Sell actions on the ticket.

### L20. Luma — listing chips: "Waitlist" and "Register to See Location"
- Mobbin URL: https://mobbin.com/screens/f5165cbc-9e48-4c3e-8f9c-422d62007598
- Observed: city-calendar event cards carry state chips beyond Sold Out/Near Capacity: yellow "Waitlist" chip (event full, waitlist open) and location line replaced by "Register to See Location" for address-gated events. Calendar page also offers "Subscribe" (email digest: "New events, straight to your inbox, every week.") and "Add iCal Subscription — Add the event feed to your calendar app to keep up with new events and updates" (Google / Outlook / Apple Calendar buttons + Copy URL).
- Problem solved: full-event state advertises the waitlist as the action at discovery level; address privacy gated behind registration; calendar/email subscription as the fallback CTA when a specific event is unavailable.
- Microcopy: "Register to See Location" / "Waitlist" chip.

### L21. Luma — Flow: "Editing guest status" + "Inviting by tag" (host-side state machine + per-guest email audit)
- Mobbin URLs: https://mobbin.com/flows/b657a072-2a81-4f90-ac7f-7ba069b3fae1 (7 screens), https://mobbin.com/flows/25710501-2b46-431c-a02d-d9fad349a951
- Observed: per-guest detail panel: Sessions list with per-session status dropdown (Approved / Removed; menu options "Approve — Mark guest as attending the event." / "Mark as Not Attending — The guest will be able to rejoin."), Batch Actions ("Add to Series", "Mark as Not Going", red "Reject — for the full series") with note "We will send an email to the guest when you change their status."; "Automatically add guest to newly created sessions" toggle; "Emails" timeline per guest listing every delivered message with timestamps ("Registration Confirmation — Delivered ...", "Event Invitation", "Registration Removed"). Invite Guests panel (Email / Events / CSV / Tags sources) carries two guest-truth notes: "Invited guests still need to register or pay for the event." and "They will be approved when they register if registration approval is enabled."
- Problem solved: every status change notifies the guest automatically; per-guest delivered-email audit trail answers "did they get the confirmation?"; invited ≠ registered is made explicit.
- Microcopy: "We will send an email to the guest when you change their status." / "Invited guests still need to register or pay for the event."

### P9. Partiful — Screen: "New Text Blast" segmented by RSVP status (incl. Waitlist)
- Mobbin URL: https://mobbin.com/screens/1e22c2f6-4747-4a5f-a577-dcfc3e97a267
- Observed: host broadcast composer targets recipients by status chips: "Going (2) / Maybe (0) / Can't Go (0) / Waitlist (0)" + "Select all"; message prefixed "The host of Birthday Bash sent a Text Blast -"; "Reply at [link]"; optional photo; "Also show in activity feed" checkbox.
- Problem solved: confirms Waitlist is a first-class audience segment for host communications (e.g., "spots opened" blasts go only to waitlisted guests).

### E9. Eventbrite — micro-observation: "Tickets missing?" help affordance
- Mobbin URL: within flow https://mobbin.com/flows/853605a3-7ba2-4548-8cfc-cd19513be8fb (profile screen)
- Observed: profile page footer card: "ⓘ Tickets missing? — Find my tickets" link. Lost-ticket recovery surfaced where users go looking.

---

## Coverage

### Queries run (26 total, in order)
| # | Tool | Platform | Query | Yield |
|---|------|----------|-------|-------|
| 1 | search_flows | web | Luma event registration RSVP flow | L1–L6 |
| 2 | search_flows | web | Partiful RSVP to a party flow | P1–P4 |
| 3 | search_flows | web | Eventbrite ticket checkout registration flow | E1–E4 |
| 4 | search_screens | web | Luma event approval required request to join pending approval | L7–L9 + Airbnb analogs |
| 5 | search_screens | web | event ticket QR code confirmation my tickets Luma Eventbrite | L10 |
| 6 | search_screens | web | Eventbrite sold out event waitlist join waiting list tickets unavailable | E5 only (thin) |
| 7 | search_flows | web | Dice Ticketmaster buy ticket waiting list sold out show | A1–A3 (Fresha/Contra/Square analogs; no Dice/TM on web) |
| 8 | search_flows | web | Luma buy paid ticket for event checkout payment | L11–L13 |
| 9 | search_screens | web | event registration closed sold out you're on the waitlist event full | E6, T1, L14, A4, A5 |
| 10 | search_flows | ios | Luma event ticket QR code check in | L15–L16 |
| 11 | search_flows | ios | Partiful approval required request to join waitlist full party | P5–P7 |
| 12 | search_flows | web | Posh buy event ticket checkout | T2 |
| 13 | search_screens | web | ticket purchase payment failed declined error message | A6–A8 (no event apps) |
| 14 | search_flows | web | conference registration form attendee details badge multiple tickets | S1, T3 |
| 15 | search_screens | web | Luma event full join waitlist button guest event page | L17 |
| 16 | search_flows | ios | Resident Advisor Dice buy ticket gig event | D1–D2 (no Resident Advisor) |
| 17 | search_flows | ios | DICE join waiting list sold out show get notified returns | D3 (mostly repeats) |
| 18 | search_screens | web | invitation link expired event no longer available page not found | expired-link analogs (no event apps) |
| 19 | search_flows | web | cancel event registration refund my ticket Eventbrite Luma | L18, E7, L19 |
| 20 | search_flows | web | Eventbrite transfer ticket to another person change attendee | E8 (transfer itself not found) |
| 21 | search_flows | web | Partiful phone number verification code sign up RSVP | P8 |
| 22 | search_screens | web | registration confirmation email ticket QR code order receipt event | T4 + SeatGeek analog |
| 23 | search_screens | web | Luma sold out event page get notified subscribe calendar | L20 |
| 24 | search_flows | web | group registration register multiple guests plus ones together | L21 (host-side only) |
| 25 | search_flows | web | Eventbrite waitlist join when tickets become available notify me | near-dry (E9 micro only) |
| 26 | search_screens | web | Partiful waitlist you're on the list spot opened up notification | near-dry (P9 micro only) |

### Apps actually observed
- Target apps: Luma (web + iOS), Partiful (web + iOS), Eventbrite (web), Posh (web), DICE (iOS), Sana AI (web, professional-event analog).
- Adjacent analogs recorded with caution labels: Airbnb (pending request), Fresha / Square / Contra / User Interviews (waitlists), Navan / Wise / HoneyBook / Klook / Wayyy (payment failure), Clay / NordVPN / Linear (expired or used links), SeatGeek (ticket UI).

### What I could NOT find on Mobbin
- Eventbrite GUEST-facing waitlist signup and a fully sold-out event page (only host-side Waitlist module in Order Options sidebar, per-tier "Sold out" pill).
- Ticketmaster and Resident Advisor: no results surfaced on either platform.
- A guest-facing ticket TRANSFER flow (Eventbrite "Registration Transfers" exists host-side; DICE "Send ticket to a friend" observed only in disabled state).
- Payment failure inside an event-ticketing app (only travel/fintech/booking analogs).
- Expired/cancelled registration LINK states inside event apps (only SaaS-invite analogs).
- True group/multi-attendee registration (one buyer entering per-attendee details for several tickets) — Luma exposes "Group Registration: Off" host tile only; Eventbrite free-flow showed a single attendee; Partiful handles +1s as a count, not named guests.
- Partiful guest-facing "you're on the waitlist" confirmation screen (waitlist confirmed as a status segment + auto-promotion copy in host settings only).

### Where I stopped (dryness rule)
Queries 25 and 26 were two consecutive sweeps that surfaced no new target-app patterns beyond micro-observations (E9, P9) — every flow/screen returned was already recorded. Stopped per the 2-consecutive-dry rule after 26 queries.
