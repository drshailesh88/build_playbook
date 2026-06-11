# Pattern: Waitlist on exhausted capacity (captured intent + notify-on-release)
**Surface:** rooming · **Observed in:** Partiful, Clubhouse, Acorns, Faire, Shopee, eBay
(refs: https://mobbin.com/flows/1284a348-cf38-4cce-a120-76d542ca6703 , https://mobbin.com/flows/83524d0b-cdc6-4505-a688-c5e7ebd98115 , https://mobbin.com/screens/e708b7f9-65da-4239-8acd-44930386d594 , https://mobbin.com/screens/51aacbac-f9c5-4570-b53e-7f7d841d59ad ; raw: `_raw/by-flow.md` §F37, `_raw/by-pattern.md` §P12)

## Flow
1. Host-side: capacity field with a Waitlist toggle beside it — "25 total spots · Waitlist [on]" (Partiful).
2. Sold-out keeps the item visible: variant struck through, banner "This item is temporarily out of stock" + "Notify me when back in stock" (Faire); terminal unavailability offers alternatives, never a bare dead end (eBay).
3. Join → promised follow-up: "🎉 You're on the waitlist… We'll let you know once a spot opens up." (Clubhouse).
4. Joined state flips the label, not just disabled: "Join waitlist" → "In Waitlist" (Shopee).

## Use when
A room type/block sells out but cancellations will restock it (they always do at conference scale).

## Avoid when
Inventory can be expanded on demand — extend the block instead of queueing people.

## Sad paths observed
The pattern IS the sold-out sad path; already-joined state explicit; eligibility rules stated ("How to be eligible?").

## Accessibility
Joined/not-joined as label text; struck variants keep their names readable.

## Default verdict for our stack
VIABLE — "Notify me when a Twin at the Hilton frees up" converts cancellations into placements. The automatic chain (cancellation frees a bed → next waitlisted delegate offered, with expiry) is unobserved anywhere — `first-principles-gaps.md` #6.
