# Pattern: Inline ticket QR with holder identity (no file download)
**Surface:** tokened-access-landing · **Observed in:** Luma (refs: https://mobbin.com/flows/36edf0e5-454d-45be-b7d7-439b982bd2bf, https://mobbin.com/flows/59e64944-d65d-4b96-b72a-36db0bac6546), Posh (refs: https://mobbin.com/flows/bd22ec75-3570-40b7-8cf3-95e7cd72b950, https://mobbin.com/screens/2bbf4ac2-6531-4cd9-9dab-c7bb2caafa01)

## Flow
1. From the confirmed event page (or My Orders grid), user taps the ticket icon.
2. A modal renders the QR code large, with the event name and the holder's identity printed beneath: "Name: Alex Smith · Email: alexsmith…" (Luma) / order number + date + venue (Posh).
3. Usage instruction under the code: "This QR code contains your order information. Show it at the event entrance for scanning." (Posh).
4. No PDF/file step — the tokened page IS the ticket; it remains reachable after sales close ("View your ticket" persists on Posh's closed-event page).

## Use when
- Delegate badge/entry credential on a personal link: render in-page QR + holder name, instantly re-accessible from the same URL on the phone at the door.
- You control check-in scanning (Luma's organizer check-in screens confirm the loop: scanner matches guest, shows approval status: https://mobbin.com/screens/544304a2-d9dc-415a-9b08-6c97773669c3).

## Avoid when
- Venue/partner requires PDF or Apple/Google Wallet artifacts — pair with a download/resend mechanism (see order-page-resend card); in-page-only QR fails offline or on printed itineraries.
- Don't put sensitive data in the QR payload itself; "contains your order information" should mean an opaque ID.

## Sad paths observed
- Event closed: page keeps the ticket accessible while disabling purchase ("Ticket sales are closed for this event" pill, Posh).
- Offline at the venue: not addressed by any observed example (gap — consider wallet pass or PDF fallback).

## Accessibility
- QR needs a text fallback (order number / name) for staff manual lookup — both apps print it under the code.
- High contrast white-on-card QR in dark UI (Posh) — keep quiet zone margins.

## Default verdict for our stack
RECOMMENDED — primary credential surface for delegates: in-page QR + holder name + manual-lookup number on the personal link; add an offline fallback our references don't show.
