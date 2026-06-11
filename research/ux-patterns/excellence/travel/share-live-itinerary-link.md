# Pattern: Shareable live itinerary link with consent disclosure
**Surface:** travel · **Observed in:** Flighty (refs: https://mobbin.com/flows/e123bd20-9fed-4a4c-8090-e44ced4631b2, https://mobbin.com/flows/cd1d29d6-8fa0-4d50-a9a1-8394400a4eae, https://mobbin.com/flows/e1726cea-06c2-4f11-8eb5-b3eb4379d22c), Qantas (refs: https://mobbin.com/flows/eb9c2a32-d7c4-4d52-b786-f3dc030cc89e, https://mobbin.com/flows/4f7870ec-d48d-4c67-9248-ca060f4eab3b)

## Flow
1. Share generates a tokened web link (live.flighty.app): "Share this link with others and they'll see your flight info and status in real-time" — no account needed to view.
2. Consent disclosure BEFORE sharing (Qantas): "What will be shared" ✓ first name ✓ flight details (number, status, dep/arr date+time, terminal, gate) vs "What won't be shared" ✗ booking reference ✗ ability to make changes ✗ payment information ✗ passenger details. Plus revocation promise: "You can unshare your trip later if required."
3. Receiver side is a first-class surface: "Following" tab listing shared trips, read-only detail "(name)'s trip" with live updates.
4. Social variants: route-map image and status sticker exports for messaging (Flighty).

## Use when
The traveler (delegate) or a third party (driver, family, co-organizer) needs current itinerary state without an account — the WhatsApp/email "view my itinerary" link target.

## Avoid when
Data sensitivity uncontrolled: never include PNR or modification powers in a bearer link; if revocation can't be implemented, don't ship tokened links.

## Sad paths observed
- Unshare is explicit and promised up front.
- Read-only view shows "Updated just now" freshness and "–" placeholders — same honesty grammar as the owner view.

## Accessibility
Link share via system sheet; disclosure is two plain checklists.

## Default verdict for our stack
RECOMMENDED — EventState already has tokened-access precedent (tokened-access-landing card, org-teams harvest); the travel send (PATH-travel-006) becomes vastly better if the email/WA message carries a live itinerary link instead of only a frozen snapshot. PNR exclusion rule from Qantas binds.
