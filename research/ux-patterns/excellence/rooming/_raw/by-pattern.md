# BY-PATTERN Raw Harvest — Rooming / Accommodation Ops
Job: A conference ops manager allocates hundreds of delegates into hotel rooms across multiple hotels — dates, room types, roommates, room-block inventory, changes/cancellations with notifications, confirmations, per-hotel rooming-list exports.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## P1 — Dual-month date-range picker with input-field anchor

**Apps observed:**
- Kiwi.com (web) — https://mobbin.com/screens/48e29624-8b1a-4273-b15c-7f809573f8a1
- Origin (web) — https://mobbin.com/screens/77f87b26-6d67-4706-89eb-25493b268102
- WRITER (web) — https://mobbin.com/screens/ecb7bf19-120e-4c03-a3af-19b046b44ef4
- Deputy (web) — https://mobbin.com/screens/8234a8ce-76f1-4715-a9ce-91c20a3cfa89
- Care.com (web) — https://mobbin.com/screens/3d6892d3-fd10-4c28-9ef1-ae1929ae0db4
- Melio (web) — https://mobbin.com/screens/3b9aac44-7d06-4927-a72b-e47347432cb5

**Anatomy as observed:**
- Kiwi.com "Find accommodation" bar: fields `Location` / `Check-in  Mar 05` / `Check-out  Mar 09` / `Guests  2 guests` / green `Search` button. Clicking check-in opens a two-month side-by-side calendar (February 2026 | March 2026); selected range Mar 05–09 rendered as a teal band across day cells. Footer summarizes "Thu, Mar 05 - Mon, Mar 09" with button **"Apply · 4 nights"** — the CTA itself carries the computed night count.
- Origin: filter drawer with `MM/DD/YYYY` Start field, "– End *" field, two-month calendar (March/April 2026), `Cancel` / `OK` in calendar, `Clear filters` / `Apply` at drawer footer.
- WRITER: Start Date / End Date text inputs above a dual-month calendar, plus Hours/Minutes/Seconds spinners under each month, `Done` button. Quick-range presets above: `Custom ▾ | 10 minutes | 1 hour | 6 hours | 1 days | 3 days | 7 days`.
- Deputy leave request: `From` row [checkbox "All Day"] [Wed 03/11/26], `To` row [checkbox "All Day"] [Thu 03/12/26], then `Leave Type` dropdown (Annual Leave (Vacation) / Unpaid Leave - Leave), `Notify Manager(s)` field, `Close` / `Add` buttons — date range + categorization + notify target in one form.
- Melio payment date: single-month calendar with a legend row below: "● Debit Dec 2, 2025 · ○ Due Dec 2, 2025" and a derived-info card **"Estimated payment delivery — Dec 5, 2025 / By 8 PM vendor's local time"** before `Continue`. Calendar that explains the downstream consequence of the picked date.
- Care.com "Book a tour" modal: stepper dots (1)(2)(3) at top, single month, unavailable days greyed, `Next` disabled until a date is picked.

**Problem solved:** Pick a check-in/check-out pair fast while seeing the consequence (nights, delivery, availability) before committing.

**Sad paths observed:** Care.com greys out unavailable days (disabled-state prevention rather than error). Origin marks End field required with `*`. No explicit invalid-range error states surfaced in these screens.

**Microcopy worth stealing:** "Apply · 4 nights" (computed consequence in the CTA); "Estimated payment delivery … By 8 PM vendor's local time" (derived effect of date choice); "All Day" checkbox simplification.

**A11y/notes:** Kiwi anchors the calendar to whichever field has focus — check-in vs check-out context preserved. For rooming: CTA should read "Assign · 3 nights" style. Deputy proves range + type + notify-recipient composes naturally into one small form — that is the change-request shape for rooming.

---

## P2 — Occupancy stepper sheet (rooms / adults / children)

**Apps observed:**
- Booking.com (ios) — https://mobbin.com/screens/c11fa0f8-efb7-4903-9ded-6e06cb928d0f
- Air NZ (ios) — https://mobbin.com/screens/ca583600-cbcc-4e6f-85c2-53431357fdea
- Viator (ios) — https://mobbin.com/screens/4cf12848-6540-4d13-8701-49f3839a2f8a
- Shopee train booking (ios) — https://mobbin.com/screens/14cc8120-aac9-4248-bc07-bf0ae993781d
- BlaBlaCar (ios) — https://mobbin.com/screens/2c5f10b6-da65-4ef6-9c22-92f09e8820ed
- Zomato (ios) — https://mobbin.com/screens/82b27403-26d4-4be0-b6e2-d347b293d478
- Eight Sleep (ios) — https://mobbin.com/screens/f41e8515-5a2d-474d-b9bb-3326eae68223

**Anatomy as observed:**
- Booking.com bottom sheet "Select rooms and guests": rows `Rooms  − 1 +`, `Adults  − 3 +`, `Children  0–17 years old  − 0 +`, toggle "Traveling with pets?" with caption "Assistance animals aren't considered pets. Read more about traveling with assistance animals", blue `Apply`. The search field above summarizes as "1 room · 2 adults · No children".
- Air NZ: steppers with age bands as captions — `Adults`, `Children  2-11 years old`, `Infants  0-23 months old`, plus checkbox "Book a child travelling alone".
- Viator "Travellers" sheet: constraint stated up front — **"This activity allows a maximum of 9 travelers."** then `Adult  Ages 14-99  − 2 +`, `Save`.
- Shopee "Select Passengers": `Adult (Age 3+)`, `Infant (Below Age 3)`, `Confirm`.
- BlaBlaCar: full-screen single stepper "Number of seats to book", giant `− 3 +`, `Confirm`.
- Zomato: number buttons `1 2 3 4 …` instead of a stepper, `Continue` disabled until pick.
- Eight Sleep "Add a guest": segmented `One guest | Two guests`, "Which side of the Pod will the guest sleep on?" `Left | Right | Both`, warning caption "[names] will be removed from Eight Sleep Pod", "What is the name of your guest?" text field, `Cancel`/`Save`.

**Problem solved:** Capture party composition with bounded, mis-type-proof increments and visible category definitions.

**Sad paths observed:** Viator pre-states the max before the user hits it; Eight Sleep warns about displacement ("X and Y will be removed…") — the closest observed analogue to roommate-conflict messaging; Zomato disables Continue until a count is chosen.

**Microcopy worth stealing:** "This activity allows a maximum of 9 travelers."; "1 room · 2 adults · No children" (compressed summary back in the trigger field); "[A] and [B] will be removed from [resource]" (displacement warning).

**A11y/notes:** All steppers pair − / + with a numeral between; minus disabled at floor value (greyed in Booking.com/Shopee at 0). Eight Sleep is the must-steal for rooming: assigning a person to a bed slot warns who gets displaced.

---

## P3 — Room-type / upgrade option cards with inventory + price delta

**Apps observed:**
- Booking.com (ios) — https://mobbin.com/screens/72f9347b-b5ed-4071-abd1-8f47f112b3a9
- Shopee hotel (ios) — https://mobbin.com/screens/3449164d-4bbe-4127-896d-2e73b9f4e8c1
- Qantas Airways (ios) — https://mobbin.com/screens/b5acc3d0-2ea5-4d8f-b85a-18e16d1a2108
- Wise (web, generic option card) — https://mobbin.com/screens/dbe73583-7c31-4b07-9273-bb9b2f686460

**Anatomy as observed:**
- Booking.com "Upgrade room / Select your upgrade": horizontally swipeable cards labeled "Upgrade option 3 of 3". Card: room name link "Double Room with Two Double Beds - Smoking", spec icons `9 m²` / `2 full beds` / `Terrace`, "View all details" link, green checkmarks "✓ Free cancellation / ✓ No prepayment needed – pay at the property", then "Price for 1 night, max. 4 adults and 3 children", delta price "+ $11.38", "Total price of stay: $55.74 / Includes taxes and fees", `Confirm upgrade`.
- Shopee "All Rooms" list: sticky filter bar (Check-in & Check-out "26 Sep - 27 Sep, 1 night" / "Rooms & Guests 1, 2"), filter chips `Free Cancellation` `Breakfast Included`. Room card: photo with photo-count badge "18+", name "Deluxe Family Room", `18m²` + "Max guests per room: 3", bed-config line "1 super king bed and 1 sofa bed or 2 single beds and 1 sofa bed", amenity chips (Free Cancellation / Breakfast / Parking / Beverages / Free Wifi / Late check-in), struck-through Rp720.060 → Rp548.542 "Per Room/Night with Taxes & Fees", scarcity line **"Only 4 rooms left"**, orange `Book`. "Show Less" collapse.
- Qantas "Request an upgrade": two selectable method cards (Use Points / Use Cash or Cash + Points), info banner explaining bid deadlines ("Requests close 10 hours before departure…"), and a "Request not available" section with warning icon: "Bid Now Upgrades are only available on selected Qantas flights." `CONTINUE` disabled.
- Wise (generic shape): two stacked option cards, selected card gets border + checkmark, fine-print caveat under cards, single `Continue`.

**Problem solved:** Compare room/option variants on capacity, amenities, and price delta, with remaining inventory visible at decision time.

**Sad paths observed:** Shopee "Only 4 rooms left" scarcity/low-inventory warning inline on the card; Qantas shows ineligible option as a visible-but-explained "Request not available" block instead of hiding it; CONTINUE stays disabled.

**Microcopy worth stealing:** "Only 4 rooms left"; "Max guests per room: 3"; "Upgrade option 3 of 3"; "+ $11.38" delta framing with "Total price of stay" beneath; "Request not available" + reason sentence.

**A11y/notes:** Delta-plus-total dual pricing is the honest pattern for room-type changes mid-allocation. Bed-configuration as a plain sentence ("1 super king bed and 1 sofa bed or 2 single beds…") beats icon soup for rooming lists.

---

## P4 — Reservation detail page (booking reference, dates, manage actions)

**Apps observed:**
- Booking.com (ios) — https://mobbin.com/screens/55a408fc-b5a0-4f4a-a262-30b6c08df874
- Uber Eats restaurant reservation (ios) — https://mobbin.com/screens/61d2b40d-dbed-4707-8bc1-c296072674c2
- TheFork (ios) — https://mobbin.com/screens/093934b6-b9f4-4297-9722-304a5deb1bd9
- Viator (ios) — https://mobbin.com/screens/e52a4e93-981c-4f2b-a7ce-9b3c3c61e62b
- Air NZ (ios) — https://mobbin.com/screens/3f4a0309-3ff3-419d-8dae-f566a786ad0e
- Shopee (ios) — https://mobbin.com/screens/604542da-1551-40d6-ade8-9e1feaa3ca12
- Urban Company (ios) — https://mobbin.com/screens/fb6d3586-fbd8-436d-b2a4-fcb700b10f43

**Anatomy as observed:**
- Booking.com property detail: hotel name + star rating, date row "Thu, Mar 19, 2026 – Fri, Mar 20, 2026" with sub-lines "Check-in: 3:00 PM - 12:00 AM / Check-out: 5:00 AM - 11:00 AM", link `Change dates`; "Property address" with copy icon + `Get directions`; "Property policies → View all policies"; "Contact the property" section ("Discuss changes to your booking or ask about facilities and special requests.") with `Message property / Send a message` and `Other methods / Call +1 …`; full-width `Manage booking` button.
- Uber Eats "Your reservation at Stella": green pill "✓ Confirmed" directly under title, rows: date/time, "2 guests", "Standard seating", then pill action row `Modify` `Cancel` `Call`; "Getting There" (address with copy icon, Parking, Transit); "Your Details" (name, phone, email).
- TheFork "Manage my Booking": card with "✓ Confirmed" badge, "1 Feb 2026 · 11:45 AM · 2 p.", row "Show guest list >", action row `Call restaurant` / `Modify` / `Cancel` (cancel in red).
- Viator: "Booking confirmation #1741960269" row with copy icon and toast **"Copied to clipboard"**; "Cancellation policy — Free cancellation Up to 24 hours in advance"; Total cost; "Rewards earned — Available Feb 28, 2026".
- Air NZ web confirmation: "Booking Confirmation" page, "A copy of your e-ticket and receipt has been emailed to [email]", boxed "Booking reference:" with links "View your booking in the AirNZ app" / "Manage your booking", procedural next-steps copy ("If you have a bag to check, go to the bag drop no later than 30 minutes before departure.").
- Shopee "Booking Details" (pre-checkout): Check-in / Check-out split "Tue, 14 Oct / Wed, 15 Oct · 1 night", "Standard ×1 · 2 Adults", "✓ Free cancellation before 16 Oct 2024 ⓘ"; "Main Guest Information" form with warning banner: **"Please make sure the main guest info is correct, hotel might validate the info during check-in."**
- Urban Company: status headline "Booking scheduled" + sub "A professional will be assigned to this booking soon", "Booked for >" person row, booking details rows, "Get alerts on WhatsApp / Enable", section "Reschedule & cancel".

**Problem solved:** One canonical record per reservation: who, where, when, status, reference number, and every change action one tap away.

**Sad paths observed:** Urban Company models the "assigned later" interim state explicitly ("A professional will be assigned… soon") — direct analogue for delegate-awaiting-room-assignment; Shopee warns guest-name mismatch may fail hotel validation at check-in.

**Microcopy worth stealing:** "Copied to clipboard" toast on reference number; "Discuss changes to your booking or ask about facilities and special requests."; "A professional will be assigned to this booking soon"; "hotel might validate the info during check-in"; "Free cancellation before 16 Oct 2024".

**A11y/notes:** Copy-icon on reference numbers and addresses is universal. Status badge sits immediately under the title, not buried. Cancel rendered in red and never primary.
