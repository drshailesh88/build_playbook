# Pattern: Plain-language change notifications with per-type action
**Surface:** travel · **Observed in:** Air NZ (ref: https://mobbin.com/screens/118195ff-27e2-4fab-8ec4-741446a6e310), Expedia (refs: https://mobbin.com/screens/f307400a-8095-443b-ace5-2dc906a05fab, https://mobbin.com/screens/77c5fd5c-50b6-4a57-99d2-8391046ac470)

## Flow
1. Notification entry anatomy: context chip ("AKL to SIN · NZ284") + relative timestamp + message + ONE action button matched to the type ("Check in", "Learn how to connect", "View your trip for details").
2. Change copy states the consequence in traveler terms, not the field diff: "Flight change. Your flight on Fri 31 Oct 2025 now leaves 10 minutes later at 11:20 AM." — direction of change ("10 minutes later") AND the new absolute value.
3. Inbox variant (Expedia): type icon per entity (flight/car/hotel/ticket), title is the verdict ("Booking confirmed" / "Booking canceled"), body names the thing + date, unread dot.

## Use when
Composing the delegate-facing email/WhatsApp/in-app copy for travel changed/cancelled cascades; any notification log UI.

## Avoid when
Ops-facing diff views — ops wants the precise field diff (old→new), travelers want the consequence. Don't collapse both into one template.

## Sad paths observed
- Cancellation includes the reason and the next step, not just the fact (Trip.com support inbox surfaces "When will I receive my refund?" FAQ directly under a canceled booking — https://mobbin.com/flows/b0e60342-a837-4b4a-819b-7d2ee8eee9f3).

## Accessibility
Action button labeled with the verb, not "View"; relative times also expose absolute datetime.

## Default verdict for our stack
RECOMMENDED — the oracle's change summary (D10) is a field diff; wrap it in this consequence-first sentence frame for the delegate channels, keep the raw diff for ops.
