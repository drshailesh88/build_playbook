# Pattern: Forward-the-confirmation-email ingestion (parse, don't transcribe)
**Surface:** travel · **Observed in:** Wanderlog (refs: https://mobbin.com/flows/bdd480a1-a579-460a-aee5-c1575b46dbb6, https://mobbin.com/flows/b0272b56-fd66-4f39-b409-f79bd9cf95de), Tripsy (ref: https://mobbin.com/flows/f590cad8-0f0f-4490-950b-9a96ca0f5b3f), KAYAK Trips (ref: https://mobbin.com/screens/502ae32f-542e-48bd-a5a4-98e5243ab275); TripIt is the genre-defining app (not indexed on Mobbin)

## Flow
1. Offer: "Import your reservation details by forwarding your email. Or have it automatically synced by connecting your Gmail."
2. Per-account forwarding address shown with one-tap Copy ("trip+14243938@wanderlog.com" → button flips to "Copied").
3. A status page ("Check imported emails status") shows what arrived and what it became.
4. Provenance + change loop on imported items: "Booked on CarRentals.com — Forward any changes to trips@kayak.com" (KAYAK).
5. Variant for claiming an existing booking: enter purchase email → one-time code, "expires in 2 hours… a code can only be sent every 2 minutes" (GetYourGuide — https://mobbin.com/flows/406a46fc-ba75-4ad7-8abe-cae65041cca7).

## Use when
Users hold airline/hotel confirmation emails and currently re-type them; high-volume ingest where parse-then-review beats form entry.

## Avoid when
Parsing infra (inbound email + extraction) can't be operated reliably — a parser that silently drops mail destroys trust; CSV/manual paths must exist first.

## Sad paths observed
- Nothing-arrived-yet copy that releases the user: "We haven't received any emails yet. It can take up to 3 minutes… We'll automatically add it, **so you can close this dialog**. Check back if it still hasn't been added after a few minutes." (Wanderlog)
- Async by design — import never blocks the UI.

## Accessibility
Address is selectable text + Copy button; status page is a plain list.

## Default verdict for our stack
VIABLE (V2-shaped) — transformative for ops entering delegate flights from forwarded tickets, but it's new infra (inbound mail + parsing) with real failure modes; the oracle has nothing like it.
