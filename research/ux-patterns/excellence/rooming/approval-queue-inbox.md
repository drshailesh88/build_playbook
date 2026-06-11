# Pattern: Approval queue / action-required inbox (inline decide, bulk approve, reason on reject)
**Surface:** rooming · **Observed in:** Workable, Deel, Airwallex, Miro, Sprout Social, Assembly, Figma, Teams
(refs: https://mobbin.com/screens/524dd62f-8f56-4977-947e-2935c3753356 , https://mobbin.com/screens/ebede796-0ca0-408a-bf05-630420732e1f , https://mobbin.com/flows/9afbce42-5ab9-4c7a-a574-2b6b83cde1fd , https://mobbin.com/screens/972bfe4f-61e5-485b-8538-9a90e646047e ; raw: `_raw/by-flow.md` §F35, `_raw/by-pattern.md` §P34)

## Flow
1. One queue with counts ("Action required (71)", "Inbox 8 / To-dos 4"); rows expand INLINE into a fact card with Approve/Reject right there — decide without leaving the queue (Workable).
2. Capacity context shown at the moment of approval: "You still have available licenses… You can add this 1 new member without extra costs." (Miro).
3. Bulk both ways: "Approve all your pending (71)" AND "Deny all your pending (71)"; floating selection bar on multi-select (Deel/Figma).
4. Rejection carries a reason back: "⊘ Message Rejected by Jane S. — 'be friendlier'" (Sprout).
5. Both directions modeled: "Awaiting your approval" vs "Approvals I've requested" with approver progress "0/1" (Assembly).
6. Deadline pressure surfaced: "ACTION NEEDED — You have 1 item due within 7 days." (Deel); request expiry ("Expires in 26d") (Miro).

## Use when
Delegate change requests, room-swap requests, and hotel-side disputes need ops decisions; ops requests to hotels need a mirrored "sent, awaiting their ack" view.

## Avoid when
Decisions are fully automatable by policy — auto-apply and log instead (see `change-request-async-confirm.md` tiers).

## Sad paths observed
"Resubmission required" status; deny-all path; expiring requests; rejected items retain the reviewer's reason as data.

## Accessibility
Inline expansion keeps focus context; status pills word+color; bulk bar reachable by keyboard.

## Default verdict for our stack
RECOMMENDED — the ops inbox where delegate requests land: "Tanaka asked to change check-out Oct 12 → Oct 14" expanding with block-impact facts ("Hilton Twin: 2 nights available ✓"), required reason on reject, bulk-approve for no-impact changes.
