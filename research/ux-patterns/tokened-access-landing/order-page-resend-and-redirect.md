# Pattern: Order/ticket page with resend, print, and send-to-another-address
**Surface:** tokened-access-landing · **Observed in:** Eventbrite (refs: https://mobbin.com/screens/070e152b-a16e-47cd-be71-be00510c08a3, https://mobbin.com/screens/c97062fc-dda3-4d56-a2af-3520fc24f9de, https://mobbin.com/screens/a516fddb-46b4-4998-845d-a3962d7724b9, https://mobbin.com/screens/94bebb0b-114f-4a66-bf39-df7db6d9e6af), Tripadvisor (refs: https://mobbin.com/screens/41a994f7-f80a-4f0f-bb84-2372261389e4, https://mobbin.com/screens/2c9c6292-7e71-44ae-a9fb-b346d130bf2b)

## Flow
1. Order confirmation states delivery explicitly: "Thanks for your order! #12019109083 — 1 TICKET SENT TO samlee@gmail.com" with a "Change" / "Send to another email address" link right under the address.
2. Primary action "Take me to my tickets" / "View Tickets"; online events explain access: "You will receive the link to the event content in your order confirmation email, and in a reminder email before the event starts."
3. Persistent order page offers: Print tickets · Resend confirmation · Cancel order; success banner on resend: "Confirmation email successfully sent to jdoe@gmail.com."
4. Resend modal warns scope: "All attendee email addresses on this order will also receive the email." (Eventbrite).
5. Tripadvisor "Email Ticket": recipient field pre-filled, "Add recipient" for extra addresses, optional note, Send Ticket — alongside the booking summary showing Confirmation # and Booking Reference #.

## Use when
- Sub-area (e) delivery/recovery: every document (ticket, certificate, invoice, itinerary) page needs resend-to-self, redirect-to-another-address, and printed reference numbers for support calls.
- "Didn't get it?" recovery without support: resend button with success feedback.

## Avoid when
- Re-delivery to arbitrary new addresses on a public/guessable URL — Eventbrite/Tripadvisor do this behind a session; on a pure token link, resend should go to the address on file, and "send to another address" should require organizer approval or token-holder confirmation.
- Avoid silent multi-recipient resend; the scope warning (who else gets it) is essential.

## Sad paths observed
- Resend confirmation success banner closes the loop; scope warning prevents surprise emails to co-attendees.
- Reference numbers (Order #, Confirmation #, Booking Reference #) printed prominently — the manual recovery handle when all links are lost.

## Accessibility
- Banner feedback is text in a colored bar (not toast-only).
- Action row (Print / Resend / Cancel) uses icon + label pairs.

## Default verdict for our stack
RECOMMENDED — adopt resend + reference-number conventions for ticket/certificate delivery; gate "send to a different address" more strictly than the references do because our links are tokened, not session-backed.
