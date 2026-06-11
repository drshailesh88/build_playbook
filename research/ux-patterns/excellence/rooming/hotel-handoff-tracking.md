# Pattern: External handoff with rights tiers + sent→viewed→acknowledged tracking
**Surface:** rooming · **Observed in:** Booking.com, Height, ClickUp, Attio, Docusign, Contractbook, Dropbox, HoneyBook, Navan
(refs: https://mobbin.com/flows/d3a2795e-74d3-49f8-b322-9a0e691eaa04 , https://mobbin.com/flows/bf10cd50-f146-4133-9e99-586c0db740cf , https://mobbin.com/screens/3b9577ec-b873-41e6-8a9b-82588f79da3b , https://mobbin.com/screens/01147852-b6d8-4b47-960b-1a5164644aed , https://mobbin.com/screens/d544c797-f87c-4b8b-91d6-229f29457fac ; raw: `_raw/by-flow.md` §F27/F34, `_raw/by-pattern.md` §P21, `_raw/by-app.md` §A17/A19)

## Flow
1. Two-tier share made explicit: "'Share as PDF' shares a copy… with confirmation number and PIN hidden for security. 'Share link to booking' grants modification and cancellation rights…" (Booking.com) — read-proof vs co-management.
2. Read-only live link for lists: "Anyone with the link can access this list — Read only" + Copy link (Height/ClickUp); paired with static "Export view as CSV / Excel" (Attio) for parties that demand files.
3. Recipient tracking after send: status pipeline "SENT → VIEWED → IN PROGRESS → COMPLETED" (HoneyBook); per-party state cards "Signed digitally · IP …" vs "Not opened" (Contractbook); declined as a terminal tracked state (Docusign).
4. Engagement detail per viewer: who, when, time-per-page, downloaded-the-file events (Dropbox Send & track).
5. Recurring delivery: "Save and schedule report" (Navan) — the weekly rooming list email to each hotel.
6. Revocable share: "Stop sharing trip" (Qantas §A19).

## Use when
Sending the rooming list to hotels; sharing a live roster with a co-organizer; proving the hotel saw version N before a dispute.

## Avoid when
The recipient should edit the source of truth — that's membership, not a share link.

## Sad paths observed
"Not opened" distinguishes silence from refusal; unpublished-draft drift warned ("changes… will not be visible to participants until published"); public-link exposure banner.

## Accessibility
Status pipeline as words; per-recipient states listed, not only color chips.

## Default verdict for our stack
RECOMMENDED — compose: read-only live rooming-list link per hotel + scheduled CSV/PDF + per-hotel "Sent / Opened / Acknowledged / Disputed" tracking. NOTE: structured per-line acknowledgment (hotel confirms rooms 401–412, disputes 413) exists NOWHERE on Mobbin — `first-principles-gaps.md` #3; this card is the donor kit.
