# BY-APP Raw Harvest — Check-in / QR

Job-to-be-done: get a registered attendee through the door fast — verify identity + eligibility, record presence (event- and session-level), handle exceptions (duplicate, invalid, ineligible, no-signal), keep counts live, and on the attendee side present a scannable credential that always works.

Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.

Date: 2026-06-11

---

## Luma (ios) — the modern ceiling for organizer check-in

### L1 — Scan → identity sheet → confirm → undo ("Checking in a guest", Scanning, 8 screens)
- Flow: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f
- Steps as observed:
  1. Event page exposes "Check In" as a first-class action chip alongside Invite / Blast / More (also seen: "Check In Guests" chip variant next to Invite/Share on a second event page).
  2. Scanner: full-screen dark camera with a white rounded-square viewfinder. Bottom-left: settings/guest-list button. Bottom-right: camera-flip button. No chrome clutter.
  3. On decode, a bottom sheet rises OVER the live camera: avatar, name "Jason Smith", Email, Status: **Going** (green text), Registration Time "Today, 8.17 PM", Ticket "Standard", big black **Check In** button + "…" overflow.
  4. After tap: green pill toast top-center "✓ Check In Successful"; the sheet's button becomes **Undo Check In**.
  5. Post-check-in variant of the sheet shows three columns: Status: Going · Registered: Today at 9:41 AM · **Checked In: Today at 9:44 AM** (https://mobbin.com/screens/df1c4370-2edf-460b-b23e-8faf38531822).
  6. Sheet for a **Not Going** guest still offers the Check In button — status is information, not a hard block (https://mobbin.com/screens/41bed30f-78ed-4b43-a5db-ac2dd783c584).
- Problem solved: face-to-credential identity confirmation at the door, instant reversal of mistakes, full timestamps for audit.

### L2 — Guest list inside the scanner ("Checking in guests" 4 screens + "Guest list" 3 screens)
- Flows: https://mobbin.com/flows/26b0f3ea-2156-43d2-b580-f4774fbb7fc7 , https://mobbin.com/flows/eb552956-1906-43ed-93b8-d7907404f1a5
- Steps: scanner bottom-left button opens Guest List sheet → search field "Search event guests…" → tabs **Going / Invited / Not Going / Checked In** (variant: Pending) → rows: avatar, name, email, status chips (green "Going", "· Checked In" inline annotation) → sort button (top-right). Empty state: icon + "No Guests — There are no guests of this status."
- Problem solved: the manual path lives one tap from the camera — phone-dead delegates don't require leaving scan mode.

### L3 — Attendee credential ("View ticket", 2 screens)
- Flow: https://mobbin.com/flows/c186b93d-4002-48cc-a0d8-f0359f8e58ec
- Steps: event page shows "✓ You are going" + **My Ticket** chip → full-screen dark sheet: event name, giant high-contrast QR (white tile on black), "Ticket — 1× Standard", **Add to Apple Wallet** button.
- Problem solved: one-tap credential, max scan contrast, wallet escape for the conference-WiFi dead zone.

### L4 — Web: Guests tab at-a-glance + check-in entry cards
- Screens: https://mobbin.com/screens/77625847-95c6-46b2-b900-1b8647c84ed4 , https://mobbin.com/screens/edc52bcd-1312-42cf-a303-e8261234d70f
- Observed: "At a Glance — **1 guest** (green) / cap 1,000" horizontal progress bar with "● 1 Going · ● 1 Invited" legend; three action cards **Invite Guests / Check In Guests / Guest List (Hidden|Shown to guests)**; Guest List with search, "All Guests" filter, "Register Time" sort, status chips + relative time; CSV export with "Downloading CSV…" toast. Empty state: "No Guests Yet — Share the event or invite people to get started!"

### L5 — Web: browser scan station ("Scanning a ticket", 5 screens)
- Flow: https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4
- Steps: Events list shows **Check In** button directly on today's LIVE event card → scan page: header event name + "Guests" button, large camera viewport, camera-flip control, below it a live strip: "**0 Checked In** (green) ……… 3 Going" progress bar + "● 1 Invited", link "Manage Event Page ↗" → on scan: green toast "✓ Checked in."
- Sad path: camera permission screen — "Scan QR Codes Below / 📷 **Please Enable Camera Access** — Luma needs to access your camera to scan QR codes." (https://mobbin.com/screens/39fd9313-2e91-4105-bd17-de49d87b1407)

### L6 — Web: session-scoped check-in ("Checking in guests", 5 screens)
- Flow: https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198
- Steps: Overview has "Check In Guests" button + "Scan" button top-right → check-in page: **Session selector** ("Session: 🕐 8 Jun, 14:00 Thu ▾"), guest search "Search for a Guest…", row: avatar, name, email, chip "Pending Approval", green **Check In** button → after: row annotation "✓ Checked In in 13 hours" (relative to session start), button becomes "Update"; footer counters "0 Guests Approved · 0 Guests Checked In"; green toast "✓ Checked in guest."; footer: "We also have mobile apps you can download to check in guests. [ Get for iOS / Get for Android ]".
- Guest list variant has an "All Sessions" filter and per-row "Session" chips (https://mobbin.com/screens/04e7b28d-2411-461d-830d-dcde23206d83 background).

### L7 — Web: Max Capacity + over-capacity waitlist (adjacent, registration-side)
- Screen: https://mobbin.com/screens/04e7b28d-2411-461d-830d-dcde23206d83
- Observed: popover "Max Capacity — Auto-close registration when the capacity is reached. Only approved guests count toward the cap." Capacity input (50), toggle "Over-Capacity Waitlist", buttons "Set Limit" / "Remove Limit".

## Partiful (ios)

### P1 — One-tap list check-in + bulk actions ("Checking in a guest", Marking, 3 screens)
- Flow: https://mobbin.com/flows/615d6618-b41d-4b54-a012-d518ef0ad559
- Steps: Manage Guests: search "Find a guest…", Status sort, filter chips with counts "👍 Going 1 · 🤔 Maybe 1 · 😢 Can't Go 0", per-row status dropdowns → **Bulk actions** sheet: "⬇ Download CSV" / "✔ **Check in guests**" → dedicated "Check In Guests" screen: search + rows with **Check in** pill button per guest → tapped row flips to a filled black ✓.
- Problem solved: zero-QR door mode for casual events; check-in state is just a tap per row.

## Posh (web)

### PO1 — Private guestlist: walk-ins, plus-ones, un-check-in ("Marked as checked in", 3 screens)
- Flow: https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684
- Steps: "Private Guestlist — names added here will not receive a ticket and are not prompted to create an account." **+ Create Guest** button; table columns: Name (sortable) / **Additional Guests (+1)** / Description ("CPO of Mobbin Team") / Status chip (red "Not Checked In" → green "Checked In") / Actions: green ✓ (check in) ↔ green ✗ (un-check-in) + red 🗑 (delete); toast "Guest updated successfully"; "Last Updated 5:37pm ↻" refresh affordance; search + pagination.
- Problem solved: comp/VIP/walk-in admission without forcing ticket purchase; plus-one counting; reversible state from the same row.
- Also: org dashboard counters EVENTS / TOTAL ATTENDEES + per-event sales analytics (https://mobbin.com/screens/39e86b79-3f16-4e55-8ddd-a49906acdd8f) — sales-focused, not door-focused.

## Eventbrite (ios + web) — attendee side only on Mobbin

- "Tickets" flow: https://mobbin.com/flows/65b9eca1-dd2c-4ded-a473-ff594b5955c1 — ticket rows carry a **QR-count badge** ("1 ⊞"); Upcoming/Past tabs; "Something missing? **Find your tickets**" recovery link.
- "Ticket details" flow: https://mobbin.com/flows/6e056259-aa3f-4d73-9c75-fab0cf3707bf — actions: Event details / Order details / **Download ticket** / Ticket information / Report event; Refund policy inline.
- Web organizer dashboard (https://mobbin.com/screens/c02c6938-f9bf-4581-918f-d9bdaa104e66 et al.): "Tickets Sold 2/40" fraction tiles, Quick actions "Attendees report"; NO check-in/door surface observed on Mobbin.
- COVERAGE FLAG: the Eventbrite **Organizer** staff app (scan + door management) is not in Mobbin's library.

## Live Nation / Ticketmaster-family (ios)

### LN1 — Rotating anti-screenshot barcode ("View ticket", 2 screens)
- Flow: https://mobbin.com/flows/131e83a0-2f9c-42ee-a5d3-b5896eb5e0be
- Steps: My Tickets card ("SEC GA", event art, **View Ticket**, Ticket Details; Transfer / Sell buttons) → full-screen barcode view: section/admission header, animated barcode with moving blue scan bars, caption "**Screenshots won't get you in.**" + refresh ↻ icon, **Add to Apple Wallet**.
- Problem solved: defeats screenshot resale/sharing fraud; the credential is alive.

## StubHub (ios)

### SH1 — Offline-stated credential + readable fallback ("Ticket detail", 2 screens)
- Flow: https://mobbin.com/flows/bd8bafeb-7a6d-4d9d-9ea3-7033b781f5fe
- Steps: ticket card states "**Available offline** — QR / Barcode" with Order #, Section/Row; ticket view: QR + **human-readable code "8E92-GB9DASV7"** printed beneath, "A screenshot of your ticket will not be accepted", seat strip SECTION B139 / ROW 6 / SEAT 15, **"ENTER AT MARINA GATE"** gate instruction, "VIEW TICKET TERMS", "1 of 1" pager, Add to Apple Wallet.
- Problem solved: the credential carries its own plan B (typed code) and plan C (gate routing) — zero-signal-proof.

## Shangri-La Circle (ios)

### SG1 — Auto-refreshing wallet QR ("Adding card to wallet", 2 screens)
- Flow: https://mobbin.com/flows/ec56ffda-1174-4b44-849d-7ec42ac5afc6
- Steps: membership card with QR + "Refresh" button + caption "**Auto refresh every 60s(59s)**" (live countdown) → Apple Wallet add sheet with the same pass.
- Problem solved: time-boxed QR tokens with visible freshness — anti-replay without user effort.

## Nike Run Club (ios)

### N1 — Persistent member pass ("Pass", 2 screens)
- Flow: https://mobbin.com/flows/4f299f86-1d73-42ba-9e06-cced3b97aaa5
- Steps: profile menu tile "Pass" (⊞ icon) → full-screen card: "SAM LEE — Member Since September 2025", giant QR, caption "Check in easily and get personalized service at Nike stores and events."
- Problem solved: ONE durable identity QR usable across venues/events — not per-ticket.

## Tonal (ios)

### T1 — Scanner with purpose microcopy ("QR Code scanner", 2 screens)
- Flow: https://mobbin.com/flows/943aafd2-ee41-4442-a208-aa605dad7341
- Steps: settings row with ⊞ icon → full-screen dark scanner, thin corner brackets, caption "Scan '⊞' on your Tonal's Sign In screen to log in on your Tonal."
- Problem solved: the scanner names exactly WHAT to point at — kills wrong-code confusion.

## WWDC / Apple Developer (ios)

### W1 — Badge pickup logistics ("Venue" screen)
- Screen: https://mobbin.com/screens/87dc057a-e5e3-499c-8086-acf6d88ad754
- Observed: "Check-in" section: "Badges will be available to pick up starting Sunday, June 3 at McEnery Convention Center. Make sure to **bring your valid government-issued photo ID**." Per-day pickup hours (Sunday 9 a.m.–7 p.m., Monday 6:30 a.m.–5 p.m., …). "Wear your badge at all times and make sure it's visible. **We don't re-issue badges**, so please take care of yours and do not share it with anyone else." **Add to Apple Wallet** (badge as wallet pass).
- Problem solved: badge-desk expectations set in-app before arrival; conference badge living in the wallet.
