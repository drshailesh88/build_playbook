# BY-PATTERN Raw Harvest — Check-in / QR

Pattern-name searches: "QR scanner overlay", "offline banner pending sync", "scan error invalid", "live attendance count dashboard", "capacity occupancy", "conference badge".

Date: 2026-06-11

---

## Scanner error recovery & manual fallback (cross-domain evidence)

### PT1 — Walmart: inline non-blocking scan error + manual entry
- Screen: https://mobbin.com/screens/6dd5b013-585a-4a64-827b-2b1ee6972e25
- Observed: scanner stays LIVE; bottom card (not a modal): "**No matching items found** — Try scanning the item again, or enter the barcode number manually." + [Dismiss] + button "**Enter number manually**". Footer hint "Scan barcodes, QR codes, and more".
- Problem solved: failure does not interrupt throughput; recovery is one tap, camera never stops.

### PT2 — Lyft: unreadable code → manual entry modal
- Screen: https://mobbin.com/screens/3ce9f604-607c-4a09-9201-da5982e2c7a2
- Observed: "**Couldn't read barcode** — Try manually entering your driver's license info." [Manual entry / Cancel]. Scanner footer has keyboard icon + torch icon docked permanently.

### PT3 — Grab: invalid QR modal
- Screen: https://mobbin.com/screens/b4ba2d47-f27e-4f83-ad67-119461d5d989
- Observed: "**This QR code is invalid** — Please scan another one." [Try again / Cancel]. Torch toggle + "Show Code" (flip to MY code) on the scanner.

### PT4 — Lime: scanner with keyboard + torch dock; reasoned rejection
- Screen: https://mobbin.com/screens/3836a17e-0491-4b66-89ce-fa6172c3ea99
- Observed: viewfinder targets the code shape ("⊞ ABC1" ghost); bottom dock: keyboard button (manual code) + flashlight button. Error dialog explains WHY + next action: "Sorry, this vehicle is currently under maintenance. **Please find another nearby vehicle.**"

### PT5 — ZARA: multi-mode scanner + history
- Screen: https://mobbin.com/screens/67443377-41ac-456f-8c76-ad75fa660649
- Observed: mode tabs **CAMERA / NFC / KEYBOARD** across the top; corner-bracket viewfinder; error toast "The NFC tag couldn't be read"; bottom row "**SCAN HISTORY** >".
- Problem solved: input modality is a first-class switch; past scans are revisitable.

## Offline handling (evidence FOR queue-first, AGAINST block-and-retry at the door)

### PT6 — Block-and-retry offline pattern (consumer default, WRONG for door ops)
- Qantas: full-page "You're not connected — You're offline. Please check your connection. [IN01]" + "Try again" + toast "Unable to update…" (https://mobbin.com/screens/18f77caf-19d5-4199-98b4-a36f34096d23)
- Waymo: "Offline — Your network is unavailable. Check your data or WiFi connection. [Retry]" (https://mobbin.com/screens/66ee96c8-a0e3-401b-a8d2-d7c80dbdaae7)
- WeTransfer: "You're offline — Connect to the internet to send your transfer. 0% [Try again]" (https://mobbin.com/screens/21faac5b-faae-43de-a608-4631ee720deb)
- Expedia: "Looks like you're offline. Check your internet connection and try again. [Try Again]" (https://mobbin.com/screens/668fab58-397b-4204-9c4e-7061fcba85aa)
- Observation: every consumer app blocks the task until connectivity returns. NONE of the harvested event apps showed an offline SCAN queue on Mobbin. A door line cannot wait — queue-first (the G_I_C_A census mechanic) exceeds the observable ceiling here.

## Live counts & capacity

### PT7 — Luma web: at-a-glance capacity bar + live scanner counters
- Screens: https://mobbin.com/screens/77625847-95c6-46b2-b900-1b8647c84ed4 (Guests tab "1 guest / cap 1,000" progress bar + Going/Invited legend), scan station strip "0 Checked In … 3 Going" (flow https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4)

### PT8 — Luma web: Max Capacity + Over-Capacity Waitlist popover
- Screen: https://mobbin.com/screens/04e7b28d-2411-461d-830d-dcde23206d83
- "Auto-close registration when the capacity is reached. Only approved guests count toward the cap." + waitlist toggle + Set/Remove Limit.

### PT9 — Eventbrite web: fraction-framed tiles
- Screen: https://mobbin.com/screens/c02c6938-f9bf-4581-918f-d9bdaa104e66
- "Tickets Sold **2/40**", "Add-ons sold 0/40" — denominators always visible.

## Badge / pass

### PT10 — WWDC badge pickup + wallet badge (see by-app W1)
- Screen: https://mobbin.com/screens/87dc057a-e5e3-499c-8086-acf6d88ad754

### PT11 — Nike Run Club persistent pass (see by-app N1)
- Flow: https://mobbin.com/flows/4f299f86-1d73-42ba-9e06-cced3b97aaa5

## NOT FOUND on Mobbin (coverage honesty)
- Self-serve kiosk check-in (iPad at door) — no flows surfaced.
- Badge PRINTING at check-in (print-on-scan) — no flows surfaced.
- Scan-out / re-entry / occupancy in-out counting — no flows surfaced.
- Multi-device scanner coordination / device naming — not surfaced.
- Conference staff apps (Cvent OnArrival, Whova organizer, Bizzabo onsite) — not in Mobbin's library.
→ These are FIRST-PRINCIPLES candidates per the harvest convention.
