# Pattern: Task-card detail completion with async fulfillment ("we have everything we need")
**Surface:** tokened-access-landing · **Observed in:** Kiwi.com (refs: https://mobbin.com/flows/163a4537-a793-4aa2-adb3-373c2e766f9d, https://mobbin.com/screens/2e0d6962-a3dc-4f48-aaaa-fb9720c6c3cc), Trip.com (refs: https://mobbin.com/screens/711354b6-cf92-4534-9e99-2c0ef69ffeb2, https://mobbin.com/screens/8d5b32ca-d2c9-442e-91c5-d5c158300ee5), American Airlines (ref: https://mobbin.com/screens/886d6a4b-8cb6-4b50-9a5b-8fa3473c4374), Scoot (ref: https://mobbin.com/screens/dcd845f3-4165-4315-aa33-ac94de244a85)

## Flow
1. The trip/booking page lists per-person outstanding tasks as cards: "Add details for check in" (dashed/empty-state card under the passenger's name).
2. Clicking opens a focused form scoped to that person: "Add your travel document details — We need these details to check you in with the airline" (purpose stated up front).
3. Field-level correctness warnings: "Please enter your name exactly as it appears on your travel documents… If the name is incorrect, you may not be able to board" (Trip.com); inline review-and-confirm of entered names before save.
4. On submit, terminal reassurance page: "Thanks, we have everything we need to check you in. We'll notify you as soon as your boarding passes are ready… no later than 6 hours before departure." + "Back to my trip".
5. Task card on the trip page flips to done/next state ("Check in directly with Frontier Airlines — You can now check in for your flight").

## Use when
- Delegate travel-details collection via personal link: multiple data clusters (passport, arrival, dietary) each as a task card with status, completable in any order across sessions.
- Anything where the document/output (boarding pass, certificate, badge) is produced LATER — promise the notification and the deadline explicitly.

## Avoid when
- Two or three short questions — a single questions-only form (see prefilled-identity card) is less ceremony.
- Don't show "we'll notify you" unless the notification is actually wired (email/WhatsApp).

## Sad paths observed
- Name-mismatch consequences warned BEFORE submission, with a read-back confirm step (Trip.com banner: "Passenger information has been saved. Please check the spelling and order of the entered names").
- Deadline framing ("no later than 6 hours before departure") pre-empts "where is it?" support tickets.

## Accessibility
- Dashed empty-state cards need accessible names ("Add details for check in for Alex Smith"), not just visual affordance.
- Read-back confirmation of names benefits everyone; keep it text, not toast-only.

## Default verdict for our stack
RECOMMENDED — for multi-section delegate/faculty data collection: per-section task cards on the personal hub, purpose-stated forms, read-back confirm for critical fields, async "ready" notification with a deadline.
