# Pattern: Document wallet on the record (tickets, receipts, passes inline)
**Surface:** travel · **Observed in:** Wanderlog (refs: https://mobbin.com/flows/4156635d-9733-4154-8c28-f5bd0f561ec2, https://mobbin.com/flows/714ae4b9-2321-4196-b0dd-ec793f61fefe), Qantas boarding pass (refs: https://mobbin.com/flows/246091ef-3596-4471-ba9b-9f7b0d59a130, https://mobbin.com/flows/7904ecff-0be9-4163-be6f-770370ffb243)

## Flow
1. Trip overview carries a "Reservations and attachments" rail: type icons (Flight/Lodging/Rental car/Attachment/Other) with count badges.
2. Reservation block shows the structured facts — CONFIRMATION # A3F9K2 with copy icon, price chip, notes ("TSA PreCheck eligible") — and an auto-tracking note ("Starting live flight status on 29 Nov 2025").
3. The attached document (airline receipt/ticket) renders INLINE as an image/PDF preview — actions: Attach new / Open in / Link to place / Unlink; upload shows a progress ring.
4. Boarding-pass variant (Qantas): wallet-grade pass (date/flight/seat/terminal/gate/group/boarding time), "Add to Apple Wallet", contextual help ("How do I use this boarding pass? Have your digital boarding pass ready to scan the QR code at the gate.").

## Use when
Travel records reference real documents (e-tickets, visas, receipts) that ops or the delegate must produce at a counter — preview-in-place beats a bare URL.

## Avoid when
Documents carry data the viewer must not see (other passengers' PNRs) — scope attachments to the record's person; don't build a generic file dump.

## Sad paths observed
- Upload progress is visible and cancelable; failed/incomplete upload never silently passes as attached.
- Unlink (detach) is distinct from delete.

## Accessibility
Attachment actions are labeled buttons; preview has an "Open in" fallback for reader apps.

## Default verdict for our stack
RECOMMENDED (upgrade) — oracle stores ONE `attachmentUrl` string (B13/G15), no preview, no multiplicity; real uploads with inline preview is what "attach the ticket" (origin-doc 3-step flow) actually meant.
