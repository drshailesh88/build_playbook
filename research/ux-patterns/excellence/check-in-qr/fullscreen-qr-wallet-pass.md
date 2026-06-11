# Pattern: Attendee credential — full-screen high-contrast QR + wallet escape

**Surface:** check-in-qr / attendee credential · **Observed in:** Luma, StubHub, Live Nation, Eventbrite (refs: https://mobbin.com/flows/c186b93d-4002-48cc-a0d8-f0359f8e58ec, https://mobbin.com/flows/bd8bafeb-7a6d-4d9d-9ea3-7033b781f5fe, https://mobbin.com/flows/131e83a0-2f9c-42ee-a5d3-b5896eb5e0be, https://mobbin.com/flows/65b9eca1-dd2c-4ded-a473-ff594b5955c1)

## Flow
1. The ticket is one tap from the event page: "My Ticket" chip on the attendee's event view (Luma); ticket rows in a Tickets tab carry a QR-count badge "1 ⊞" (Eventbrite).
2. Credential view is FULL-SCREEN and high-contrast: white QR tile on a dark background (Luma) — built for a scan gun, not a thumbnail.
3. **Add to Apple Wallet** sits directly under the code on every app harvested — the wallet copy works with no app, no account, no signal, and surfaces on lock screen at the venue.
4. Ticket metadata rides along: ticket type + quantity ("1× Standard"), section/seat where relevant.
5. Recovery affordances: "Something missing? Find your tickets" (Eventbrite), Download ticket as a file (Eventbrite).

## Use when
Always, for any scannable credential. Full-screen + wallet are the two highest-leverage reliability features on the attendee side.

## Avoid when
Don't rely on wallet alone — Android/desktop attendees and printed-email users need the in-app/in-email QR as the universal baseline.

## Sad paths observed
- Lost ticket: "Find your tickets" recovery flow linked from the empty/short list.
- No signal at the door: solved by wallet copy (and see offline-credential-fallback-code card).

## Accessibility
QR needs a text alternative (the readable code — see sibling card); wallet button is the standard Apple asset with its own a11y; ensure brightness boost on open (not directly observed but implied by full-screen white-on-dark design).

## Default verdict for our stack
RECOMMENDED — legacy renders QR via RegistrationQrCode (census) inside pages/badges but has NO wallet pass, NO full-screen credential view, NO download-ticket artifact. Wallet is infra-heavy (pass signing); full-screen view is cheap.
