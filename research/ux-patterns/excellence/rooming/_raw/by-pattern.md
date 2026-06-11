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

---

## P5 — Status badges + status-tab segmentation in ops tables

**Apps observed:**
- Squarespace Orders (web) — https://mobbin.com/screens/f0391f62-aff1-49ba-91e9-cade37d045ea
- Aboard approvals (web) — https://mobbin.com/screens/d6a6ad47-6520-44f4-af42-41feb0a611de
- Airwallex ID verification (web) — https://mobbin.com/screens/49dd7426-2703-40e6-bea1-42819d9489bb
- ElevenLabs Batch Calling (web) — https://mobbin.com/screens/b8057d86-6869-4f86-a823-0aa3a2a75f01
- Kiwi.com My trips (web) — https://mobbin.com/screens/d251fde7-56a8-48ed-802a-23882a6c68d6
- Deel order detail (web) — https://mobbin.com/screens/64373e1d-d81e-4016-9f63-0593fea580ca
- Fireflies Meeting Status (web) — https://mobbin.com/screens/9f09cb91-41ed-4a33-86a8-4628763c3b29

**Anatomy as observed:**
- Squarespace "Orders": status tabs `All Statuses | Pending | Fulfilled | Canceled` above search ("Search by customer name, email, product, or order number"), `Filter` + `Sort by`, table columns ORDER / PRODUCT / FORM / NAME / TOTAL / PAYMENT / FULFILLMENT with yellow `Pending` pill; row checkboxes; "Showing 1-1 out of 1 records"; `EXPORT DATA ▾` button top-right.
- Aboard "Documents > Approvals": filter chips `Documents: All` `Status: All`, table Document / Employee / Type / Created / Status, orange `Pending` pills per row.
- Airwallex: per-person verification rows with green `Electronically verified` and purple `Verifying` badges; top banner "Verification in progress, you can continue to verify the others (if any)…".
- ElevenLabs: table Name / Agent / Status / Progress / Duration with black `In progress` pill and "100%" progress cell.
- Kiwi.com "My trips": trip card with corner badge `Processing`.
- Deel: page title "Order ORD-F9231DA0", sub-line "Requested on Dec 16th 2025 · Pending delivery"; segmented tabs `Approved (1) | Declined (0)`.
- Fireflies: rows with right-aligned status "✓ Completed" / "⊘ Not allowed in"; terminal empty marker pill "All caught up!".

**Problem solved:** Let an operator read record state at a glance and slice the worklist by state without building a filter.

**Sad paths observed:** Airwallex models the partial state (some verified, some still verifying) with a banner that explicitly unblocks parallel work; Fireflies has a failure status ("Not allowed in") inline with successes.

**Microcopy worth stealing:** "All caught up!"; "Verification in progress, you can continue to verify the others (if any)"; "Showing 1-1 out of 1 records"; count-in-tab "Approved (1) | Declined (0)".
 
**A11y/notes:** Color + word in every badge (never color alone). Status tabs with counts double as a progress readout for the whole block — directly reusable as `Unassigned (42) | Assigned (180) | Confirmed (160) | Cancelled (8)` for a rooming list.

---

## P6 — People-rows resource timeline (allocation grid with capacity + pending overlays)

**Apps observed:**
- Workable Work calendar (web) — https://mobbin.com/screens/e3ef1c9a-a0f1-40b4-90a6-e11722b779cd
- Asana Workload (web) — https://mobbin.com/screens/6959e583-bb0f-4cc5-a59e-addbb3bec6b6
- Deputy Schedule (web) — https://mobbin.com/screens/dcc6b94e-b619-4d43-9149-4e712eca95a3
- Aboard Time-off (web) — https://mobbin.com/screens/0773086c-2875-4071-a373-d1c07f44d554
- Deel Calendar (web) — https://mobbin.com/screens/1643ff13-8042-4925-a1b0-b50741557681
- Linear Projects timeline (web) — https://mobbin.com/screens/39048d90-578a-4eda-abe7-69427e17502b
- Zoho CRM All Users calendar (web) — https://mobbin.com/screens/02f2467d-9239-45da-8747-646d19989917

**Anatomy as observed:**
- Workable "Work calendar": left column = employees (avatar, name, title), columns = days of week; cells hold colored blocks ("09:00 AM - 05:00 PM / Remote", green "Paid time off · 1 day", "Unpaid leave · 0.5 days" with orange corner-flag on pending items); header sub-line "No employees out of office today"; success toast "Success! Time-off request has been processed."; filters `All time-off types / All departments / All entities & locations / View: All employees`; toggle "Show time-off only"; Week|Month switch.
- Asana "Workload": person rows against a date axis; hover card shows "Daily total 52h 51m / Remaining capacity -50h 27m (red) / Daily capacity 2h 24m" — over-allocation shown as a negative red number.
- Deputy "Schedule": left rail of areas/people with per-person totals ("4h 30m - $0.00"), day timeline; shift block "2pm – 7pm Sam Lee / Afternoon shift"; bottom status legend: "0 empty · 0 unpublished · 1 published · 0 require confirmation · 0 open shifts · 0 warnings · 0 leave approved · 0 leave pending"; `All shifts published` button.
- Aboard "Time-off": person rows × multi-month day axis; approved leave = solid orange bar, pending = dashed-border pink bar; header chip "⏳ Pending requests 2"; weekend columns shaded; today marked with a circled date and vertical line.
- Deel "Calendar": "Total 100 workers" matrix of workers × days with out-of-office counts per day across the top ("Out of office: 0 0 0 0 2 100 100 3 0 1 0 0 100 99…").
- Linear timeline: project bars on month axis; dependency popover "Blocking → [project] / ✕ Remove dependency" drawn as an arrow between bars.
- Zoho CRM: "All Users" day view, rows per user, "All-Day (3)" stacked block.

**Problem solved:** See every person/resource against time in one grid, with state (approved vs pending vs warning) and capacity overrun visible per cell.

**Sad paths observed:** Asana shows negative remaining capacity in red (over-allocation is data, not an error dialog); Deputy's legend enumerates exception classes (warnings, leave pending, require confirmation, open/empty shifts); Aboard renders pending requests as dashed bars distinct from approved solids.

**Microcopy worth stealing:** "Remaining capacity −50h 27m"; "Pending requests 2"; "All shifts published"; "No employees out of office today"; "Success! Time-off request has been processed."

**A11y/notes:** Dashed = pending / solid = committed is the cleanest visual grammar observed for tentative vs confirmed room assignments. Deputy's footer legend = checklist of sad-paths to surface for a rooming grid (empty, unpublished, requires confirmation, warnings, pending).

---

## P7 — Capacity / usage meter with threshold alerts (contracted vs consumed)

**Apps observed:**
- QuickBooks Usage limits (web) — https://mobbin.com/screens/4dfea91b-6902-4da1-8625-7306df994417
- Rox Billing & Usage (web) — https://mobbin.com/screens/d05a2f5e-1bfb-421f-8723-dd288e3c92dd
- OpenAI Platform Limits (web) — https://mobbin.com/screens/6f5add46-0508-4eb1-a5de-48011b40fc62
- ElevenLabs workspace notifications (web) — https://mobbin.com/screens/2820a39c-9241-4fd7-863b-ef008fec5f39
- Telescope (web) — https://mobbin.com/screens/df9f222f-adfb-48c8-b54a-2cd39a327899
- Workable AI search (web) — https://mobbin.com/screens/6e595a50-b038-4f65-90e7-0663719aaaa7
- Zoho CRM (web) — https://mobbin.com/screens/6483d5de-5a24-4d6b-89a1-d0a5d5c6d8b9

**Anatomy as observed:**
- QuickBooks "Usage limits": per-resource meter rows — "Chart of accounts — 2 OF 250" with thin progress bar and caption "The limit for your plan is 250."; "Billable Users — 1 OF 3"; preamble "Usage limits are going into effect starting on or after 2 September 2025… Learn how to lower your usage / Change your plan".
- Rox: stat strip Current Plan / Cost / Renewal Date / Usage Level with a RED-full progress bar "1,535 / 1,000 Actions Used" + `Upgrade` button; page-top amber banner: **"You have no Agent Actions remaining. To continue using Rox, upgrade here."** — overconsumption shown as >100% count, not clamped.
- OpenAI Platform "Limits": "Organization budget — $0.00 / $10…" bar, alert rows "80% usage…", "100% usage…", modal "Add budget alert": field "Alert when budget usage exceeds [50] %", "Also send alerts to — Add email addresses to receive alerts in addition to organization owners", `Cancel` / `Add alert`.
- ElevenLabs "Notifications": "Configure workspace-wide email alerts sent to admins when usage hits important thresholds." Threshold rows each with dropdown (By credits / By amount / By percentage) + value + toggle.
- Telescope: quota dialog "your recs — 10 / 500" with slim progress bar and plain-language explanation of the limit.
- Workable: hard-stop empty panel "Add AI Recruiter credits to find your next great hire — You've reached your search limit. Add more credits to keep going." `Add more credits`.
- Zoho CRM: precondition error banner "⚠ Insufficient data to create a Strategy Influencer — …must have minimum 5000 records in the last 1 year… and a minimum of 100 records per week for at least 30 weeks." `Ok, Got it!`.

**Problem solved:** Show consumed-vs-contracted quantity per resource and alert the right people before/at breach — the exact shape of room-block inventory (contracted vs assigned).

**Sad paths observed:** Rox over-limit state (1,535/1,000 + red bar + blocking banner); Workable hard stop with a single recovery CTA; Zoho states the unmet precondition with exact numbers.

**Microcopy worth stealing:** "X OF Y" meter label; "The limit for your plan is 250."; "Alert when budget usage exceeds __ %"; "Also send alerts to…"; "You have no Agent Actions remaining. To continue…, upgrade here."

**A11y/notes:** "N of M" text always accompanies the bar — never bar-only. For room blocks: per-hotel, per-room-type rows "Assigned 38 OF 50 contracted" with configurable threshold alerts (80%, 100%) emailed to the ops manager mirrors OpenAI/ElevenLabs exactly.

---

## P8 — Bulk-select table with selection-count toolbar

**Apps observed:**
- Squarespace Contacts (web) — https://mobbin.com/screens/3a41d26a-bb32-4595-94c0-511e4c959722
- AutoSend Contact List (web) — https://mobbin.com/screens/2f1674e6-46bb-489d-8e03-dbced0d01318
- Notion Team table (web) — https://mobbin.com/screens/f49ef73e-f5ea-4da3-b785-f9c768aaca1b
- ManyChat Contacts (web) — https://mobbin.com/screens/b520c005-7997-4426-841f-8ac7b715e851
- Whop column chooser (web) — https://mobbin.com/screens/71f41e02-2914-4a2c-af28-1a941435f274
- Zoho CRM report columns (web) — https://mobbin.com/screens/66ac6b6a-b4fa-4a06-978c-0f2e337214d6

**Anatomy as observed:**
- Squarespace "Contacts": stat cards (Total Contacts 6 / Subscribers 3 / Customers 2), then table; header checkbox in indeterminate state, "2 selected" label, contextual toolbar appears: `ADD TAG  REMOVE TAG  COPY TO  ···`; checked rows highlighted.
- AutoSend: "1 contact selected" bar above table with red `DELETE` button; selected row tinted blue; columns EMAIL / FIRST NAME / LAST NAME / ADDED ON / UPDATED ON.
- Notion database: "2 selected" pill in toolbar next to property filters (Role, Status, Person, Date Joined) + trash icon; row checkboxes on the left edge.
- ManyChat: idle state shows "0 selected of 3 total" with `Bulk Actions` button DISABLED until selection.
- Whop "Columns" popover: radio `All | Custom`, master checkbox "All 45/45", two-column checkbox list of every exportable field (ID, Created at, Status, Email, Subtotal, Refunded amount…).
- Zoho CRM report builder: left checkbox panel of columns ("Report Columns / Clear all"), live preview table with note "ⓘ Preview shown with limited number of rows. Run the report to see actual aggregate values."

**Problem solved:** Act on many records at once (tag, delete, move, export) with constant feedback on how many are in hand.

**Sad paths observed:** ManyChat disables Bulk Actions at zero selection (prevention); destructive DELETE isolated and red (AutoSend).

**Microcopy worth stealing:** "2 selected"; "0 selected of 3 total"; "Preview shown with limited number of rows…"; "Clear all".

**A11y/notes:** Selection count must live in a persistent toolbar, not only row highlights. Whop's column chooser + Zoho's live preview together are the anatomy of a rooming-list export builder (pick columns per hotel, preview, export).

---

## P9 — Ops data table: filter chips, filter builder, saved views, export

**Apps observed:**
- Squarespace Orders filtered (web) — https://mobbin.com/screens/4195611e-e085-4e07-ba90-63be4e614ad1
- Relevance AI Tasks (web) — https://mobbin.com/screens/11dc1da7-db6d-4887-8f2e-13916ca07ed8
- Whop Payments (web) — https://mobbin.com/screens/0ec7fd15-b0bd-4c4d-9a6d-c67cbef1c1f4
- QuickBooks Advanced search (web) — https://mobbin.com/screens/a87ea978-796d-43fb-b646-545a46aa0bbb
- ElevenLabs Users (web) — https://mobbin.com/screens/d07c9f1b-83c2-4e9a-ae24-268d7bf80749
- OpenAI Platform Projects (web) — https://mobbin.com/screens/33fe4ddf-be14-468f-8937-d19529a4a5ce
- Zoho CRM Manage Dashboards (web) — https://mobbin.com/screens/575b0b55-0a7b-482d-86cb-325ed5895c47
- Base44 FlowFin Transaction (web) — https://mobbin.com/screens/8e9a4c23-96f6-4aa8-bdd4-20aa85cd7022

**Anatomy as observed:**
- Squarespace: active filters rendered as removable chips under the search bar — `Payment • Failed ×` `Payment • Refunded ×` `Basic Service ×`; Filter icon carries a count badge; "Showing 1-2 out of 2 records".
- Relevance AI: view tabs across top `All tasks 17 | To review 4 | Escalated | Errored | ✓ Completed 17 | +`; toolbar `Filter 2`, `Export (17)`, `Clear`, blue **`Save view`**; filter builder popover: left rail of fields (Agent, Status, Tool usage, Errors, Metadata, Last updated, Date created, Email tracking, Created by), condition "Where status [Is not ▾] [● Completed ×]", `Clear all` / `Apply changes`.
- Whop Payments: column-header filter pills `+ Status + Method + Date + Reason + Product`; Status dropdown enumerates colored statuses: Succeeded ✓, Pending, Failed ✕, Past due, Canceled ✕, Price too low, Uncollectible, Refunded, Auto refunded, Partially refunded, Dispute warning ⚠, Dispute needs response, Inquiry needs response, Resolution needs response, Dispute under review; `Export` button.
- QuickBooks: labeled filter fields in a row (Date range / Transaction type / Reference number / Contact / Amount) producing applied chips "Date range: 01/01/2026-31/03/2…× / Transaction type: Bill ×"; results count "1 - 1 of 1 items".
- ElevenLabs: minimal filter pills `+ Date After` `+ Date Before` `+ Agent` `+ Branch` over the table.
- OpenAI Projects: search + filter pills (Geography, Data retention, `Active ×`), `Export` + `Create`, `Load more` pagination.
- Zoho: ownership dropdown on a list — `All ✓ / Favorites / Created by me / Shared with me / Public / Other Users' Dashboards`.
- Base44: "Filter By: Amount × Type × / Clear", Filters popover with per-field panels and footer "2 filters applied / Clear".

**Problem solved:** Slice a large operational dataset along any axis, keep the recipe (saved view), and get the slice out (export with count).

**Sad paths observed:** None visible as errors — pattern is preventive: filters always removable per-chip, counts always shown so an over-filtered empty result is explainable.

**Microcopy worth stealing:** "Save view"; "Export (17)" (count inside the button); "2 filters applied"; "Where status Is not Completed"; per-chip "Field • Value ×".

**A11y/notes:** Whop's exhaustive colored status taxonomy is a model for booking states (confirmed / pending / cancelled / no-show / changed / awaiting-hotel-ack). Relevance AI's view tabs + Save view = "My hotels", "Unassigned delegates", "Cancellations this week" for rooming ops.

---

## P10 — Notification feed (unread model, mark-all-read, categories)

**Apps observed:**
- Deel Notifications (web) — https://mobbin.com/screens/34b77080-b18f-47f9-863a-959f6d7d7821
- Jira Notifications panel (web) — https://mobbin.com/screens/f7eb5777-1125-4f47-bdcc-39931e19cfeb
- Digg (web) — https://mobbin.com/screens/056fcc1a-2ba1-40b1-a8c5-d3589fd38c6f
- Pinterest Engagement (web) — https://mobbin.com/screens/2d6812c7-5e05-408a-a628-35e21a7dceae
- Replit (web) — https://mobbin.com/screens/79efb4e6-6176-484b-85a7-984e79afb5e2
- Ditto (web) — https://mobbin.com/screens/a45e9a41-dedb-44d0-a28a-51eb323ef1fe
- Telescope (web) — https://mobbin.com/screens/a488f2e6-28b3-49e3-885a-779324cec42a
- Reddit (web) — https://mobbin.com/screens/1e7c06d7-86f3-452a-85e3-2a2bcd5af07b

**Anatomy as observed:**
- Deel: full "Notifications" page; left rail `Activity Feed` + Settings (`Categories`, `Email Digest`); header chip "Activity Feed (20)", filters `Date ▾ Categories ▾`, `Mark all as read`. Cards each: icon, bold title, body, timestamp — e.g. "Deposit payment due — Your deposit is due for multiple contracts. Pay the outstanding deposit(s) promptly to avoid delays in contract activation and payments."; "'Greg Marks' contract has ended — …Please review the details."
- Jira popover: tabs `Direct | Watching`, toggle "Only show unread", entries "Alex Smith changed a subtask from To Do to Live", inline comment preview with reaction bar + `Reply` / `View thread`; blue unread dots.
- Digg: `Mark all as read` button, rows grouped by event, terminal line "You're all caught up! ✌" and confirmation toast "Marked all notifications as read".
- Pinterest: per-notification checkbox selection — "Mark as unread / Selected (1)".
- Replit: tabs `Unread | All`, row "jdoemobbin joined your App via email invite: NYC Coffee Explorer · 2 minutes ago", `Load more`.
- Ditto: panel groups "Assigned to You (168)" and "Discussion (4)" with per-row status chips (In Review 1, In Progress 56).
- Telescope: empty state "No notifications yet" with illustration.
- Reddit: "Mark all as read" + per-row checklists.

**Problem solved:** Surface changes that happened while the operator wasn't looking, with a clear unread/read lifecycle.

**Sad paths observed:** Empty state handled (Telescope "No notifications yet"); Deel notifications carry consequence language ("…to avoid delays in contract activation and payments") — change alerts state the downstream impact.

**Microcopy worth stealing:** "You're all caught up!"; "Only show unread"; "Mark all as read"; consequence-bearing bodies like "Pay the outstanding deposit(s) promptly to avoid delays…".

**A11y/notes:** Unread = dot + bold, never color alone. For rooming: the Jira "X changed Y from A to B" sentence form is the right grammar for "Delegate Tanaka changed check-out from Oct 12 to Oct 14 — Hilton list affected".

---

## P11 — Kanban / drag-and-drop assignment board (people-as-cards)

**Apps observed:**
- Wrangle recruiting pipeline (web) — https://mobbin.com/screens/0e9374d2-a696-47dd-8012-4519080cef28
- Notion board view (web) — https://mobbin.com/screens/22e09ab9-e9e1-4568-8b58-a8f583d2241e
- Linear board (web) — https://mobbin.com/screens/fc208a44-dbf9-4f79-b9b0-db57f9840964
- Zoho CRM Tasks by Status (web) — https://mobbin.com/screens/934c7c8b-eaf1-424c-84ac-fd60b8f263bc
- Todoist sections (web) — https://mobbin.com/screens/866c59ab-6ea2-4bee-bdea-ad3efdff8507
- Maze card sort (web) — https://mobbin.com/screens/6b91c5a6-a084-4b77-8649-e878d54ea784
- Workable pipeline stages editor (web) — https://mobbin.com/screens/538e4804-fd80-4128-8d77-91dcb0c80350
- Rox Create Board (web) — https://mobbin.com/screens/df642bfd-3262-4f85-8154-cec5de6fa955

**Anatomy as observed:**
- Wrangle: columns = pipeline stages with counts ("Contacted 187 / Sourced 0 / Replied 3 / Interviewing"); cards = people (avatar, name, title, company, email, location chips, "Added February 18th" + per-card icon actions). Empty column shows a drop target: **"No items yet — Drag items here."** Top toolbar `Attributes / View / Import People / Add filters / Export CSV`.
- Notion "Team" board: columns by status pill (`Not started 1 | Contract 1 | Full-time 2`), people cards with property rows (role tag, status, date, "Eligible for Insurance"), `+ New page` at column foot.
- Linear: columns "Todo 2/3 | In Progress 2 | Done 11"; right rail "Hidden columns: Backlog / Canceled / Duplicate"; footer "1 issue hidden by filters — Clear Filters ×"; drag ghost of a card visible mid-move.
- Zoho CRM: "Tasks by Status" lanes (Not Started 1 / Deferred 0 / In Progress 7 / Comp…); empty lane shows "No Tasks found."; left filter rail.
- Todoist: light sections "To Do 2 / This Week 3 / Review 1" with "Add section" affordance.
- Maze participant card-sort: instruction header "Drag and drop cards to create new categories", counter "7 cards remaining", target group panel showing "1 card".
- Workable: stage editor — groups (Phone Screen / Assessment / Interview / Offer / Hired) each with drag-handle rows and `+ Add stage`; `Save`/`Cancel`.
- Rox "Create Board": modal with `Board Details / Global Filters / Columns / Amount / Tabs`; Columns list with drag handles, pin and remove icons, `+ Add column`, "Add, remove, pin, and reorder columns".

**Problem solved:** Move people/items between named buckets by direct manipulation, with per-bucket counts as live inventory.

**Sad paths observed:** Empty-bucket drop target labeled ("Drag items here"); Linear discloses "1 issue hidden by filters" so cards never silently disappear; hidden/closed columns listed in a rail instead of vanishing.

**Microcopy worth stealing:** "No items yet — Drag items here"; "1 issue hidden by filters · Clear Filters"; "7 cards remaining"; "Add, remove, pin, and reorder columns".

**A11y/notes:** Column count chips = per-room occupancy counters if columns are rooms and cards are delegates (Wrangle is structurally identical to a roommate-assignment board). "Hidden by filters" disclosure is critical when an ops manager filters by hotel and wonders where delegates went.

---

## P12 — Sold-out / waitlist / notify-me states

**Apps observed:**
- Faire Wholesale (ios) — https://mobbin.com/screens/e708b7f9-65da-4239-8acd-44930386d594
- eBay (ios) — https://mobbin.com/screens/3a134cb7-ed59-4fd4-bdda-5ef3daca9e4f
- Acorns (ios) — https://mobbin.com/screens/92e2fcff-35ed-449e-9dd2-0673eeb9877d
- Shopee (ios) — https://mobbin.com/screens/51aacbac-f9c5-4570-b53e-7f7d841d59ad
- Digg (ios) — https://mobbin.com/screens/a4af3940-7946-45cc-9715-64c1258c45b3
- Mercari (ios) — https://mobbin.com/screens/61733dc8-e058-4099-9dc1-f32ffe14e514
- Poolsuite FM (ios) — https://mobbin.com/screens/712f2982-1ac6-4077-8a69-e6ecdc96e98f

**Anatomy as observed:**
- Faire: product page keeps full detail visible; some color swatches struck through (diagonal line = that variant unavailable); banner "This item is temporarily out of stock" + outline button **"Notify me when back in stock"**.
- eBay ended listing: headline "This item is no longer available." with `Sold` badge, sale price/date retained, "See original listing" link, then recovery paths: `Sell one like this` / `Seller's other items` / "More like this".
- Acorns: "Coming Soon" pill, explainer paragraph, single CTA `Join waitlist`.
- Shopee SPinjam: "Invitation Only" pill, "We will notify you if you have been invited.", DISABLED grey button reading **"In Waitlist"** (joined state), section "How to be eligible?".
- Digg: "Join the Digg Waitlist — Digg is currently invite-only. Enter your email address below and we'll be in touch!", email field, `Join waitlist` disabled until valid input.
- Mercari: modal offering notifications on a watched item — turn on alerts for price drops/new comments (Japanese: "通知をオンにすると…値下げ、新規コメントなどの情報をすぐにお届けします").
- Poolsuite FM: "coming soon" placeholder with `🔔 Notify Me` button.

**Problem solved:** Convert a dead end (no inventory / not yet open) into a captured intent with a promised follow-up.

**Sad paths observed:** This whole pattern IS the sad path: variant-level strikethrough (Faire), terminal "no longer available" with alternatives (eBay), already-joined disabled state "In Waitlist" (Shopee).

**Microcopy worth stealing:** "This item is temporarily out of stock"; "Notify me when back in stock"; "This item is no longer available."; "In Waitlist"; "We will notify you if you have been invited."

**A11y/notes:** For room blocks: when a room type is exhausted, keep the row visible, strike the variant, and offer "Notify me when a [Twin at Hilton] frees up" — cancellations restock; the waitlist converts. Joined-state button must flip label (Join waitlist → In Waitlist), not just disable.

---

## P13 — Setup/progress checklist with completion counter and dismiss

**Apps observed:**
- Circle (web) — https://mobbin.com/screens/509ed183-a8b9-4613-a2a4-0164192e5aba
- Circle paywall step (web) — https://mobbin.com/screens/9ec88deb-ad5c-4499-a72d-8c02be6f408e
- Oyster (web) — https://mobbin.com/screens/50fd50d0-ccb6-45f0-9779-6c5b8dcb1fe1
- Oyster step-1-done (web) — https://mobbin.com/screens/b36e49cb-4dce-41aa-a161-696caedaef44
- Vanta (web) — https://mobbin.com/screens/d6c8a960-3253-4ca4-b4aa-06e902fa0e4e
- Mailchimp (web) — https://mobbin.com/screens/7f54a57c-ee77-4413-8422-f55774568201
- Bonsai (web) — https://mobbin.com/screens/ccc8a376-05c7-4860-bac6-887410f0bf0f
- Hootsuite (web) — https://mobbin.com/screens/678aa914-5611-432d-ba41-f01049932d28
- Jasper (web) — https://mobbin.com/screens/22a607f7-8f33-43d7-b5df-2302c97f65d1
- Slite (web) — https://mobbin.com/screens/6747d7cc-44b3-4671-a2de-b0e60d0c8d8d
- Uxcel (web) — https://mobbin.com/screens/38804fe0-c387-4914-9294-9afbf9c87fca

**Anatomy as observed:**
- Circle "Setup checklist": left rail of steps (`Basics / Set up your spaces / Setup a paywall / Invite your first members / Kickstart engagement / Join the Circle community`) with radio/check marks; right pane expands the active step into sub-items with green checks ("Complete your profile", "Customize your branding", "Confirm community access") each with accordion chevrons and a `Continue` button inside the expanded sub-item.
- Oyster "Hello / Here's what we have for you today.": numbered rows 1–4 ("Complete onboarding", "Review your contract", "Add a payment method", "Sign the contract"), each with a status pill (`Draft`, `Pending`, `Completed`) and a per-row action button (`Start onboarding`, `Preview contract`, `Add payment info`) — blocked step 4 has only a `Pending` pill and no button; caption explains the dependency: "Your employer will share the contract with you to sign." After step 1 completes, its button becomes link `Edit details` and pill flips to `Completed`.
- Vanta "Finish Starter Guide": sidebar progress "15/20 tasks completed" with a bar; main pane = collapsible groups each carrying "N of M complete" ("Launch policies and procedures — 4 of 4 complete", "Prove your compliance — 0 of 3 complete"); inside an expanded group, sub-tasks show mixed states (info "Intro: what to expect from your auditor", unchecked, greyed/locked items).
- Mailchimp: circular "4/5" progress ring top-right; finished steps = black check circles; final step "Launch" expanded into headline "Share your campaign with the world" with embedded draft card (`Draft · Campaign · Edited Aug 1` + `Finish campaign`); footer escape hatch: "If you don't need to see this anymore, you can dismiss the checklist".
- Bonsai: vertical stepper with completed steps greyed + checked, current step "4 · Create a contact form" highlighted, right pane explains the step with `Create Form` + `Next Step →` buttons.
- Hootsuite "Getting Started": segmented progress bar (6 segments) + "4/6 Explored", card grid where done cards carry green `Done` pills; `✕` to dismiss the whole module.
- Jasper: step list where completed rows are struck through ("~~Create an account~~", "~~Generate a paragraph for your website~~") with per-step credit rewards (1,000 / 2,500…) and per-row CTAs `Try it →` / `Watch now →`; header "5,000 credits available".
- Slite "GET STARTED — Follow these steps to get the most out of Slite": checked list, last item expanded with caption + `Enable notifications` button; sidebar pill "Set up: 71% completed" with a thin bar.
- Uxcel "Onboarding checklist": "100% complete" ring; every item green-checked, with captions still stating the rule ("You need to invite at least 1 other member to your team.").

**Problem solved:** Drive a multi-step setup to completion by always showing how much is done, what is next, and what is blocked on someone else.

**Sad paths observed:** Oyster's blocked step ("Sign the contract — Pending — Your employer will share the contract with you to sign") models waiting-on-third-party explicitly; Vanta locks sub-tasks (greyed) until predecessors finish; Mailchimp offers an explicit dismiss escape ("If you don't need to see this anymore…").

**Microcopy worth stealing:** "15/20 tasks completed"; "0 of 3 complete"; "4/6 Explored"; "Your employer will share the contract with you to sign." (dependency stated as a sentence); "If you don't need to see this anymore, you can dismiss the checklist"; strikethrough-on-done.

**A11y/notes:** Progress is always count + bar/ring, never bar alone. For rooming: an event-level "Rooming setup" checklist (Add hotels → Load room blocks → Import delegates → Assign rooms → Send confirmations → Export rooming lists) with per-step "N of M complete" and blocked-on-hotel steps labeled like Oyster's pending contract is the exact shape.

---

## P14 — Stat summary cards / ops dashboard (occupancy, arrivals, exception counts)

**Apps observed:**
- Airbnb Insights (web) — https://mobbin.com/screens/726befb3-6d01-4565-aa27-315035e49a67
- Booking.com extranet home (web) — https://mobbin.com/screens/516f9969-3ce9-4286-b46e-5ceded4b9f1a
- Booking.com performance (web) — https://mobbin.com/screens/cccddc22-ca86-43bd-9cfe-14ef07ffe837
- Cal.com Insights (web) — https://mobbin.com/screens/321ec4a3-b0bd-4eb6-9a4d-8932bf11ba66
- Deputy Analytics (web) — https://mobbin.com/screens/a94b862d-1c9d-4cdf-b7a5-299fa1144bdd
- TravelPerk Reporting (web) — https://mobbin.com/screens/b5ab2f2b-f7ff-4a7c-bdbf-be35571b0087
- Deel Workforce Planning (web) — https://mobbin.com/screens/3cfb782e-f869-4746-9677-f2fd36f3e5e3
- Jira space Summary (web) — https://mobbin.com/screens/f057a7fd-32a3-4e7f-9502-76b7be4b2dee
- Deel People dashboard (web) — https://mobbin.com/screens/58055f61-1b70-4804-be29-d20e5140b91c

**Anatomy as observed:**
- Airbnb "Occupancy rate": filter chips (`All listings / May 19 → Jun 18 / Rooms and beds / Regions / Amenities`), metric strip of underlined-link stats: "Average occupancy rate − / Average nights booked 0 / Average nights blocked 0 / Average unbooked nights 0 / Average check-ins 0"; chart pane with Compare dropdown ("Over time"); pre-data explainer "Your average occupancy rate will show here within 48 hours of your first booking."; `Monthly report` download button; "Last updated: Jun 18".
- Booking.com extranet "Reservations": tabs with count badges — `Arrivals 0 | Departures 0 | Stay-overs 0 | Guest requests 0`, date scoper "Today ▾", link "View all reservations"; empty cards "No arrivals for selected date" / "You haven't received any bookings in the last 60 days"; companion panels "Unanswered messages" / "Recent reviews". The arrivals/departures/stay-overs trio is hotel-ops vocabulary verbatim.
- Booking.com "Your performance": stat rows each with an area benchmark beneath — "Average daily rate US$0 / Area avg. US$282.78", "Cancellation rate 0% / Area avg. 29.41%"; "Demand for Menlo Park" insight card in sentence form: "Demand for accommodations in Menlo Park went up by 2%", "Most travelers search 0–1 day before their stay", "The most popular stay period is of 1 night".
- Cal.com "Insights": card grid Events Created 19 / Events Completed 0 / Events Rescheduled 2 / Events Cancelled 15 / No-Show (Host) / No-Show (Guest) / CSAT — each with delta-vs-last-period arrow "↓ 0% from last period"; multi-series "Event Trends" chart with legend (Created/Completed/Rescheduled/Cancelled/No-Show); `Download` + date scoper "Last 7 Days".
- Deputy "Attendance & absence": three exception KPIs with share-of-total captions — "No shows 15 / 60.0% of all shifts", "Late arrivals 3 / 12.0%", "Early departures 4 / 16.0%"; weekly trend lines; `Export`.
- TravelPerk "Reporting > Travel summary": cards Total spend / Total trips / Total travelers / Total CO₂ emissions, each "0" with "No data for previous period"; "Travel insights" row (Total bookings 0, Average trip price N/A, Top destination N/A); `Download report`; "Last data update: April 21, 2025, 05:30 UTC".
- Deel Workforce Planning: paired status cards "Current pending requisitions 0 ● Pending" / "Current vacant positions 27 ● Vacant", each with a `View` drill-in button; filter row; scope sentence "Displaying results from January 1st, 2025 – December 31st, 2025".
- Deel People: "Job position vacancy" donut — "Total 19" center, legend "Filled positions 10 / Vacant positions 9" with 52.6%/47.4% split — filled-vs-vacant is exactly contracted-vs-assigned.
- Jira Summary: stat chips "3 completed / 10 updated / 10 created / 0 due soon" each captioned "in the last 7 days"; "Status overview" donut "30% Approved" with legend counts.

**Problem solved:** Give the ops manager a single glance at allocation health — how full, what's arriving today, and which exceptions (cancellations, no-shows, pending) need action.

**Sad paths observed:** Every dashboard shows the zero/no-data state with words, not blank charts ("No arrivals for selected date", "No data for previous period", "Your average occupancy rate will show here within 48 hours…"); Deputy elevates failure metrics (no-shows) to first-class KPIs with % of total.

**Microcopy worth stealing:** "Arrivals 0 | Departures 0 | Stay-overs 0 | Guest requests 0"; "Average nights blocked"; "% of all shifts"; "↓ 0% from last period"; "Area avg. 29.41%" (benchmark under own number); "Last data update: …UTC"; "Displaying results from … – …".
 
**A11y/notes:** Counts in tab badges + drill-in `View` buttons keep cards actionable, not decorative. Rooming home screen should be Booking.com extranet shape: Arrivals/Departures/Stay-overs for the selected date + exception KPIs (Unassigned, Pending confirmation, Cancellations) Deputy-style with share-of-total.

---

## P15 — Audit log / activity history with actor + from→to values

**Apps observed:**
- Customer.io Activity Logs expanded (web) — https://mobbin.com/screens/b38ebe97-02ca-4634-95ea-5b959fe8c9b5
- Customer.io activity-type filter (web) — https://mobbin.com/screens/f092f149-c6e2-4f93-9f46-c4ffef2d71a3
- 1Password Activity Log (web) — https://mobbin.com/screens/a5632ec1-f072-43e2-8f2b-ad047df4ca04
- Coda Activity log (web) — https://mobbin.com/screens/9992a223-1c84-45a1-9267-8094d8c2c70b
- Dropbox Admin Activity (web) — https://mobbin.com/screens/f21ce521-ba67-4806-96a2-ff13c0fdc9fa
- 15Five audit table (web) — https://mobbin.com/screens/0e4eaeeb-0fc4-419e-9c4b-90b61293b012
- Discord Audit Log (web) — https://mobbin.com/screens/335d4d28-4d0f-48b8-bdda-43386205bfb0
- PlanetScale Audit log (web) — https://mobbin.com/screens/8af442b9-2a21-43a6-a2b5-5b2ff3fbc79d
- Intercom Teammate activity logs (web) — https://mobbin.com/screens/90f46240-2d8d-4140-a3c5-35ab4328c98e
- Okta System Log (web) — https://mobbin.com/screens/94e9f3c1-da72-4dad-a186-083cf9480d58
- HubSpot list Activity (web) — https://mobbin.com/screens/96ceeb00-11c7-4544-a962-f38905fb52ed

**Anatomy as observed:**
- Customer.io "Activity Logs": tabs `Identified | Anonymous`, `Add Filter`, "Last updated today at 12:10:44 pm (+08)", toggle "Auto refresh On"; table PERSON/OBJECT · ACTIVITY TYPE · ACTIVITY NAME · TIMESTAMP · PROCESSED AT; expanded row shows literal from→to JSON: `created_at: { from: "", to: "1677038670" }`; provenance footer: **"Source: manual change in dashboard by jane.smith.mobbin@gmail.com, IP address: 103.252.201.6"**. Activity-type filter enumerates failure events too: "Attempted to Send Email", "Bounced Email".
- 1Password: columns Date and time / Event / Actor / Description / IP Address; sentence descriptions with linked objects ("An email invite was resent to jsmith8@…", "Administrators was granted access to Shared"); permission note up top: "You'll only be able to see events for areas of 1Password you have permission to access."; `Download` button; filter dropdowns Date / Actor / Events / All filters.
- Coda: day-grouped narrative lines — "john.mobbin@gmail.com's role was changed from a Doc Maker to an Editor by Jane Smith." (object, from-value, to-value, actor in one sentence).
- Dropbox Admin: rows carry "Previous value: invited · New value: active" sub-lines under "Changed member status (invited, joined, suspended, etc.)"; `Create report` button; Category column.
- 15Five: includes `Automated` as an actor value ("Automated — People attribute 'Birthday' created") alongside humans — system vs human attribution.
- Discord "Audit Log": "Filter by User All ▾ / Filter by Action All ▾", rows "alex_smith.mbn updated roles for json_mithe · Today at 2:59 PM" with expand chevrons.
- PlanetScale: each row pairs the sentence with a machine event code chip: "Deleted new-pass-readonly in content-mobbin" + `branch_password.deleted`, plus IP + UTC timestamp.
- Intercom: date-range + "All teammates ▾ / All activity ▾" filters; rows like "John Smith turned his away mode off and did not reassign their conversations."
- Okta "System Log": From/To datetime+timezone scopers, search "Sam lee", "Count of events over time" histogram above the table, `Download CSV`, result rows "Update user profile for Okta — SUCCESS" with Targets column.
- HubSpot list "Activity": "View all user activity taken on this list", columns EVENT / VERSION (v1) / MODIFIED BY / DATE OF CHANGE; buttons `View version history` / `Export report`.

**Problem solved:** Answer "who changed this delegate's room, when, from what to what, and was it a human or the system" — the dispute-resolution backbone of rooming changes.

**Sad paths observed:** Failure events logged as first-class rows (Customer.io "Attempted To Send Email", "Bounced Email"; Okta SUCCESS implies a failure variant); 1Password scopes visibility by permission and says so; 15Five distinguishes Automated actors.

**Microcopy worth stealing:** "from: ___ to: ___"; "Previous value: invited · New value: active"; "Source: manual change in dashboard by [email], IP address: …"; "[X]'s role was changed from a [A] to an [B] by [Y]."; "You'll only be able to see events for areas … you have permission to access."; "Auto refresh".

**A11y/notes:** Sentence + structured from/to beats either alone. For rooming: every assignment change row should read "Tanaka moved from Hilton Twin 412 to Marriott King 218 by [ops user] · notified hotel ✓ / delegate ✓" with an expandable from→to block and an Automated actor for system reallocations.

---

## P16 — Empty-state table with multi-path call to action

**Apps observed:**
- folk (web) — https://mobbin.com/screens/50bd214b-d94c-4a11-96fd-a4b800afb668
- Clay (web) — https://mobbin.com/screens/14ce11dc-44af-43a1-b688-ecea923fac0c
- Attio (web) — https://mobbin.com/screens/6c68cc0e-8793-4f1a-838a-ed127b31d1ac
- Whop (web) — https://mobbin.com/screens/74662629-4da6-4dc2-8ce8-47ee0a815625
- Midday (web) — https://mobbin.com/screens/ad307c0d-b4b0-4d08-b36e-d3972ea8a024
- Salesforce (web) — https://mobbin.com/screens/a3f0d671-1b61-445f-b125-817a54189882
- Supabase (web) — https://mobbin.com/screens/8bb604b4-bb21-4c3b-9b8a-b0dd8faeef41
- Amplitude (web) — https://mobbin.com/screens/e7f11578-5a9e-405b-91d7-df492d340b25
- Peerspace (web) — https://mobbin.com/screens/2d080552-07c3-4750-b6ef-2cdf1edcaf4d
- Rox (web) — https://mobbin.com/screens/966abd34-c9dd-4cd0-bf17-daa156e37591

**Anatomy as observed:**
- folk "Untitled group": column headers stay rendered (Person / First name / Last name / Emails / Phone numbers / Job title) over the empty body; centered "There's no one here – yet / Time to add some people. Here are the ways you can do so:" followed by a vertical menu of entry paths: `Add people` / `Start from a template` / `Import from a file` / `Connect an integration`; inline `+ Add person` row stub under the header.
- Clay: "This workbook does not contain any data" with a 2×3 button grid `Find companies / Find people / Find local businesses / Import from CSV / Import from CRM / Use a template` and "Or browse all options".
- Attio "Contacts": headers + per-column stat stubs ("0 count", "0 empty"); center "Add your first person — Kick-start your new list by importing people from a *.CSV or add your first person." + `+ Add Person`.
- Whop "Checkout Links": headers (Product/Plan/Active users/Stock) + center "No checkout links yet" + definition sub-line "Checkout links are direct links to specific pricing options that you can send to your users" + `+ Create checkout link` (also duplicated top-right).
- Midday: "No customers / You haven't created any customers yet. Go ahead and create your first one." + `Create customer`.
- Salesforce Contacts: persuasion-framed headline "Top sellers add their contacts first — It's the fastest way to win more deals." + `Add a Contact`; toolbar still offers `Import` as alternate path; meta line "0 items · Updated a few seconds ago".
- Supabase Table Editor: card "Select a table from the navigation panel on the left to view its data, or create a new one." + `Create a new table` — selection-empty (nothing chosen) vs data-empty distinguished.
- Amplitude: "Start your data table — Data tables enable multi-metric, multi-dimensional analyses in a single view" + `+ Add Event or Metric ▾` + secondary "Learn Data Tables".
- Peerspace: one-line strip "Add a space to get started" with `Add a space` button; green toast above "✓ Your space has been deleted" — post-deletion return-to-empty handled.
- Rox: "No opportunities found" + `+ New Opportunity` while the date scoper "This Month (2/1/26 - 2/28/26)" hints the cause may be the filter window.

**Problem solved:** A new event has zero hotels/blocks/delegates everywhere at once — every empty table must teach what the object is and offer every ingestion path (manual add, CSV import, template, integration).

**Sad paths observed:** Peerspace shows empty-after-delete with the confirming toast still visible; Rox's empty result is filter-induced (date window) — distinct from true-empty; Supabase distinguishes "nothing selected" from "no data".

**Microcopy worth stealing:** "There's no one here – yet"; "Time to add some people. Here are the ways you can do so:"; "Import from a *.CSV or add your first person"; "0 items · Updated a few seconds ago"; "Go ahead and create your first one."

**A11y/notes:** Keep column headers visible in empty tables (folk, Attio, Whop) so the user learns the schema before adding data. Rooming: empty Delegates table should offer `Import from registration` / `Upload CSV` / `Add delegate` exactly like folk's multi-path list; empty filtered views must say which filters caused it (cross-ref P11 Linear "hidden by filters").

---

## P17 — Conflict detection + pre-publish warning triage (with auto-fix)

**Apps observed:**
- Clockwise conflict panel (web) — https://mobbin.com/screens/671e0870-f520-4d92-bc16-8ee9b332bb3b
- Clockwise unfixable conflict (web) — https://mobbin.com/screens/289bc1dd-9d08-4569-8075-c48e0b0525ef
- Clockwise move-event dialog (web) — https://mobbin.com/screens/d0f17573-9dc2-41f5-9a9c-abe93e0449c2
- Clockwise event panel conflicts (web) — https://mobbin.com/screens/a75fe383-bdf3-4021-926d-99fddc446b13
- Clockwise share proposal (web) — https://mobbin.com/screens/d91d7384-97bf-415d-94e3-de3c3c57d4e6
- 7shifts warnings modal (web) — https://mobbin.com/screens/8796902e-18e6-4f82-98d8-2146b96be325
- 7shifts conflict toolbar (web) — https://mobbin.com/screens/e330f42b-1220-4c3d-8c87-64c6de3f001b
- 7shifts auto-fix progress (web) — https://mobbin.com/screens/9a2ae84a-767f-4380-8d5b-a80a2115fe31
- 7shifts post-fix review (web) — https://mobbin.com/screens/cfef4a25-e91d-42b6-9498-70694015e05a
- Fresha outside-working-hours (web) — https://mobbin.com/screens/ac5e971e-8cfb-47ca-9b36-bb6ae392b53f

**Anatomy as observed:**
- Clockwise scheduling assistant: sentence verdict at top — **"I can schedule this meeting, but there is a conflict for Sam."**; then severity-tiered lists: "Sam has conflicts that I can't fix:" (e.g. "Outside of working hours") vs "You have inconveniences:" ("1 hour of Focus Time lost"); actions `✓ Confirm / Share / Cancel`; footer reassurance "Nothing will change until explicitly confirmed."
- Clockwise "Move event" dialog: proposed change shown as new-vs-struck-original ("Tomorrow, 1pm - 2pm · New / ~~Tomorrow, 9am - 10am~~ · Original"), collapsible "Conflicts · 1 attendee → Outside of working hours" and "Inconveniences · 1 attendee", `Save`.
- Clockwise event panel: amber-bordered "Conflicts · 1 attendee" accordion inline between the date fields and "More settings"; share message variant writes the conflict into the invite text: "There are a few issues with that time, which Clockwise will fix if it can: • Busy - Conflict. Does that work?"
- 7shifts toolbar: persistent chips next to the date scoper — red `2 Conflicts`, amber `2 Overtime`, link `Fix warnings`, `Unpublished` state label, primary `Publish schedule`. Grid cells carry red/pink tint + "5h Overtime / TIME OFF" labels at the exact conflicting cells.
- 7shifts "We found some warnings. Let us fix them!" modal: taxonomy with counts and definitions — "⚠ 0 Exceptions … shift violations like Clopens, Split shifts, Right to rest or Last-minute schedule changes."; "0 Conflicts — Conflicts include shifts that already exist, or fall on a day when the employee has an approved time off or is unavailable."; "1 Overtime warnings…"; "0 Unassigned Shifts — Unassigned shifts are any shifts that are not assigned to an employee."; checkbox "Do not show me this again"; `No thanks` / **`Yes, fix them for me`**.
- 7shifts auto-fix progress: "Hang tight, we're building your perfect schedule." with live check-off lines ("Analyzing and fixing shifts with approved time off", "…with availability conflicts", "Finishing up").
- 7shifts post-fix: "Your schedule is almost ready — There were some warnings we couldn't fix so you may want to review your schedule before publishing." + `Review my schedule`.
- Fresha edit-service panel: non-blocking amber inline note **"Alex Smith is not working between 7:00am and 7:45am"** while `Apply` stays enabled — warn-but-allow.

**Problem solved:** Surface double-bookings and rule violations at assignment time, classify them by fixability, and offer machine repair with human review before anything is committed/published.

**Sad paths observed:** This pattern IS the sad path: unfixable vs fixable conflicts separated (Clockwise); auto-fix that admits partial failure ("warnings we couldn't fix") and routes to review (7shifts); warn-but-allow override (Fresha); "Nothing will change until explicitly confirmed."

**Microcopy worth stealing:** "I can schedule this, but there is a conflict for [name]."; "[Name] has conflicts that I can't fix:"; "Yes, fix them for me"; "There were some warnings we couldn't fix so you may want to review… before publishing."; "Nothing will change until explicitly confirmed."; "Conflicts include shifts that already exist, or fall on a day when the employee has an approved time off…".

**A11y/notes:** Conflict counts live in the toolbar as colored chips AND at the offending cells — two-level signposting. For rooming: "2 Conflicts · 1 Over capacity · Fix warnings" chips above the rooming grid, cell-level red tint where a delegate is double-roomed or dates overlap a room's other occupant, and a publish gate ("Send to hotels") that runs the 7shifts-style triage modal first. Distinguish hard conflicts (same bed, overlapping nights) from inconveniences (split stays, roommate-preference miss).

---

## P18 — Resend with cooldown timer (rate-limited re-notification)

**Apps observed:**
- Databricks (web) — https://mobbin.com/screens/d2bf25c5-982d-4a90-ac7e-1397d6e833d6
- OpenPhone (web) — https://mobbin.com/screens/ecb4c475-2f11-49c1-9228-a06bd4df5b8b
- Unity (web) — https://mobbin.com/screens/be37dd71-dc4a-4689-aa24-436b6ae87d3d
- ClassDojo (web) — https://mobbin.com/screens/3e5c39ac-f0ff-4990-a91f-43536ce06216
- Nextdoor (web) — https://mobbin.com/screens/5c7c3e25-76b5-4c4b-b18f-31cf578a34fc
- Coinbase (web) — https://mobbin.com/screens/cfdf8235-6a71-4857-ac58-5dace902f6d3
- Wave (web) — https://mobbin.com/screens/b1efdd50-e43f-4ab8-a95c-4156fc01c717
- Bonsai (web) — https://mobbin.com/screens/a95b3c9f-f5a3-4211-9986-f46616fff4d0
- Uvodo (web) — https://mobbin.com/screens/0d0a40b2-fbd7-4831-9a7a-dd5c56316899
- Profound (web) — https://mobbin.com/screens/875a67bb-89b0-40b8-8ed0-24d681c5873a

**Anatomy as observed:**
- Databricks: "Enter verification code" + "We sent an email with the code to alexsmith@content-mobbin.com" + disabled outline button **"Resend code in 29"** (countdown inside the disabled button).
- OpenPhone: greyed link-style "Resend code (9 sec)" under `Verify`.
- Unity: plain text "26s to Resend code" — timer first, action second.
- ClassDojo: "Resend code (29)" link greyed while counting.
- Nextdoor: refresh-icon link "Resend code" at left with the bare countdown "28s" right-aligned; escape hatches "Edit your number ✎" and "Try another method".
- Coinbase: wide disabled grey button "Resend code in 4" + secondary "Try another way" + "Cancel signing in".
- Wave: problem-framed line: **"Don't see it? Send a new code in 00:15"** — the resend is the answer to a stated user worry; "Change" link beside the destination number.
- Bonsai: destination + validity stated: "We sent a code to your email (jdoe.mobbin@gmail.com)… This code is valid for 10 minutes."; "Resend code in 01:00".
- Uvodo: imperative phrasing "Wait 1:16 seconds before requesting a new code."; loading spinner replaces button text while verifying.
- Profound: "Resend in 00:44" caption next to a disabled `Resend` button — separated label + control.

**Problem solved:** Let users re-trigger a send without spamming the channel — the control stays visible, states why it's disabled, and tells exactly when it reopens.

**Sad paths observed:** Whole pattern is the sad path (message didn't arrive): every app keeps the disabled control visible with a live countdown rather than hiding it; Nextdoor/Coinbase add channel-switch fallbacks ("Try another method/way"); Wave/Bonsai pre-empt panic ("Don't see it?", "valid for 10 minutes").

**Microcopy worth stealing:** "Resend code in 29"; "Don't see it? Send a new code in 00:15"; "This code is valid for 10 minutes."; "Wait 1:16 seconds before requesting a new code."; "Try another method"; "Edit your number".

**A11y/notes:** Countdown should live in the button's accessible label so screen readers hear the state change. For rooming: "Resend confirmation" per delegate and "Resend rooming list to hotel" need exactly this — disabled with "Resent — available again in 0:59", plus "Last sent Oct 3, 4:12 PM to reservations@hilton.com" and a channel fallback (email → phone) like Nextdoor's "Try another method".

---

## P19 — Review-changes diff before commit/publish (old vs new with approve gate)

**Apps observed:**
- ElevenLabs Review Changes (web) — https://mobbin.com/screens/ff16450b-9de9-4c60-8738-770be8df0a5c
- Neon Preview historic data (web) — https://mobbin.com/screens/9cb22cfd-3f04-4161-94b9-729266bc97b0
- PlanetScale deploy request (web) — https://mobbin.com/screens/45aae177-3a79-4e42-94fa-ac5ab6ec6456
- GitBook Changes view (web) — https://mobbin.com/screens/d8307789-31af-4bdd-b7cf-dab69a87dd95
- GitHub Files changed (web) — https://mobbin.com/screens/c37e959a-d959-4ffb-a004-13b1713fd13c
- GitLab side-by-side (web) — https://mobbin.com/screens/b3ce61fc-ac56-4519-a520-b6b3ad7c7e03
- Hex peer review (web) — https://mobbin.com/screens/b6d30984-785d-4ae1-a740-986428e63945
- Replit checkpoint diff (web) — https://mobbin.com/screens/0dae0a10-7c42-4e0e-8716-6f5fb0f1b54e

**Anatomy as observed:**
- ElevenLabs "Review Changes" modal: two columns headed "Published version `Main`" vs "Current changes `Main`"; unchanged bulk collapsed behind "Expand 77 lines ..." / "Expand 637 lines ..."; red/green token-level highlights; "Version description (optional) — Describe what changed in this version" field; `Cancel` / `Publish`. Diff-then-describe-then-publish in one gate.
- Neon "Preview historic data": environment + timestamp scoper ("production · 02/26/2026, 05:20 AM · Asia/Jakarta, GMT+07:00"), side-by-side red(removed)/green(added) panes, actions `Browse data / Query data / Compare schemas`, footer `Cancel` / **`⟳ Proceed to restore`** — diff as the confirmation step of a rollback.
- PlanetScale deploy request: green added-lines blocks per table; blue banner "This deploy request has not been approved yet"; radio choice **"Leave a comment — You are not approving or rejecting these changes"** vs **"Approve changes — You are approving the deployment of these changes."**; comment box ("Approved!"); `Approve changes` button.
- GitBook: rendered-document diff — strikethrough red on removed words, green on added, inline in the actual page ("Developer ~~platform template~~Platform"); toggle "Show only changed pages"; left rail marks changed pages; right rail "Version history" ("merged 7 changes from change request #1").
- GitHub PR "Files changed": per-file accordions with +/− counts ("+49 −1"), "0 / 2 files viewed" checkbox-tracking, `Review changes` dropdown.
- GitLab: `Inline | Side-by-side` toggle, "Hide whitespace changes", "Showing 1 changed file with 23 additions and 0 deletions"; inline comment thread anchored to a line ("This one is an error") with Reply box.
- Hex "Add your review": per-block `Added` chips on changed cells; review verdict radio: "Comment — Submit feedback without explicit approval / Approve — Provide approval to publish this version / Request changes — Recommend changes before publishing this version"; `Submit review`.
- Replit: "Showing 32 changed files" with per-file `Modified`/`Added` chips, "36 unchanged lines" collapsed, `Rollback here / Changes / Preview` on the checkpoint.

**Problem solved:** Before committing a bulk change (or restoring an old state), show exactly what will differ — old vs new, side by side — and force an explicit approve/describe step.

**Sad paths observed:** Unapproved state labeled loudly (PlanetScale banner); comment-without-approval and request-changes verdicts exist as first-class outcomes (Hex, PlanetScale); rollback framed as a previewable diff, not a blind restore (Neon, Replit).

**Microcopy worth stealing:** "This deploy request has not been approved yet"; "You are approving the deployment of these changes."; "Describe what changed in this version"; "Expand 77 lines ..."; "Showing 1 changed file with 23 additions and 0 deletions"; "Show only changed pages"; "Proceed to restore".

**A11y/notes:** Color-coded diffs always pair with +/− glyphs and counts — never color alone. For rooming: a re-import of the delegate list or a block re-negotiation should land as a GitBook-style rendered diff ("Tanaka: check-out ~~Oct 12~~ Oct 14", "Room 412: ~~Twin~~ King") with an ElevenLabs-style "Describe what changed" note that becomes the notification text to hotel/delegates, gated behind Approve.

---

## P20 — Batch import pipeline: per-item progress + added/updated/skipped/error summary

**Apps observed:**
- Customer.io Import CSV review (web) — https://mobbin.com/screens/36a46394-af7d-4eba-8987-8d94d5430896
- Customer.io Import summary (web) — https://mobbin.com/screens/14dd02c0-3150-411f-95cb-34e3f64732fa
- AWS S3 Upload status (web) — https://mobbin.com/screens/d0b2a1fa-99a9-4c29-ba83-f77a3f850d40
- PandaDoc bulk import (web) — https://mobbin.com/screens/6e7783c1-2ce2-4ba2-832d-bab89ec45f67 and https://mobbin.com/screens/f7443f66-5e59-433b-a611-deebd86db562
- Pipedrive Import history (web) — https://mobbin.com/screens/5ac63322-3aa1-4f5d-a878-6e976c6c0bee
- Remote CSV upload (web) — https://mobbin.com/screens/52383c77-770b-4735-9863-58292ca510fa
- ClickUp migration upload (web) — https://mobbin.com/screens/73fc4f76-58c0-4279-af72-2bbe75451f47
- Apollo Enriched CSVs (web) — https://mobbin.com/screens/01d12b3e-ede8-47ba-af57-faade2137152
- Intercom CSV import (web) — https://mobbin.com/screens/dc6e729a-d7df-4239-9d7b-bd4c8756d4e1
- Zoho CRM Data Migration (web) — https://mobbin.com/screens/b03fcca3-e1d1-45c9-a8d6-461e3e9062f7

**Anatomy as observed:**
- Customer.io "Import CSV" review step (stepper `1. Upload CSV ✓ · 2. Preview ✓ · 3. Review`): stat strip "0 EVENTS TOTAL / 2 UNIQUE EVENTS / 0 NEW PEOPLE (How was this calculated?) / 0 WARNINGS / **8 ERRORS**"; red detail "8 Errors — Some rows will not be imported · invalid email address · Export the error file for further information." with buttons **`Export error file`** / `Go back to upload`; `Complete import` disabled.
- Customer.io post-import summary: green banner "Success! Your CSV import is processing."; "Import summary — This import created 2 new profiles and updated 0 existing profiles. View people >"; fact card (FILENAME / CREATED VIA / IMPORT RULES "By email: new and existing people" / EMPTY VALUES "Were ignored" / SKIPPED WARNINGS 0); next-action cards (Create a broadcast / campaign / ad audience).
- AWS "Upload: status": top progress banner ("Total remaining: 2 files; 2.4 MB (54.74%) · Estimated time remaining: a few seconds · Transfer rate: 304.1 KB/s" + `Cancel`); warning "After you navigate away from this page, the following information is no longer available."; Summary split "Succeeded — 2 files, 4.5 MB (65.26%)" vs "Failed — 0 files, 0 B (0%)"; per-file table with Status (✓ Succeeded / In progress (58%) / Pending) and Error columns.
- PandaDoc: "Imported 0 of 4 files" → "Imported 1 of 4 files" with per-file spinner states (Uploading 51% → Processing. → Imported); warning "Keep this window open so your bulk import can continue uninterrupted."; `Cancel import`.
- Pipedrive "Import data": tabs `New import | Import history`; live row "IMPORTING… pipedrive_sample_data.csv" + `Cancel import`; "Past imports (last 30 days)" table (File name / Date and time / User / Type / Status) with note **"Imports can be reverted within 48 hours after their upload."**
- Remote: "Uploading time off records… This can take a few minutes… You can leave this page if you want. When the upload is done, you'll be able to find it on your time off history page." counter "0 / 2", "Estimated time remaining: calculating…", red `Cancel`; stepper `1. Upload · 2. Map fields · 3. Review · 4. Confirm`.
- ClickUp: "Upload completed — Data upload completed!" with found-entity counts (Documents found 1 / Databases found 1 / Tasks found 19 / Attachments found 4) before proceeding.
- Apollo "Enriched CSVs": per-file rows with Progress bar, `Success` badge, Total Records / Matched Records / Duplicates counts, `View report` + `Download` per row.
- Intercom: "Preparing your import… You can close this window and still track the progress of your import." + `Go to imports`; breadcrumb pills "Upload CSV ✓ · Map attributes ✓ · Tag ✓ · Import".
- Zoho "Data Migration": result table columns MODULE NAME / STATUS / **ADDED / UPDATED / SKIPPED / TOTAL**; "We will send an email notification to […] once it is complete."; footer actions `Discard Migration` / **`Edit Mapping and re-run Migration.`**

**Problem solved:** Ingest hundreds of records at once while making partial failure legible — what got in, what was updated, what was skipped and exactly why, with a recoverable artifact (error file) and an undo window.

**Sad paths observed:** Richest sad-path harvest of the sweep: error rows quantified with reason + exportable error file and a disabled Complete (Customer.io); revert window stated ("within 48 hours"); re-run with corrected mapping (Zoho); volatile progress warned about (AWS "no longer available after navigating away"); keep-window-open constraint (PandaDoc) vs safe-to-leave (Remote, Intercom) both stated explicitly.

**Microcopy worth stealing:** "Some rows will not be imported"; "Export the error file for further information."; "This import created 2 new profiles and updated 0 existing profiles."; "Empty values — Were ignored"; "Imports can be reverted within 48 hours after their upload."; "Edit Mapping and re-run Migration."; "ADDED / UPDATED / SKIPPED / TOTAL"; "You can close this window and still track the progress of your import."

**A11y/notes:** The Added/Updated/Skipped/Errors quad is the canonical receipt for any rooming bulk action: delegate CSV import, registration-system sync, and bulk room auto-assignment should all end on this screen, with `Export error file` (delegates that couldn't be assigned + reason) and a stated undo window before the rooming list goes to hotels.

---

## P21 — Sent-document recipient tracking (sent → viewed → signed acknowledgment loop)

**Apps observed:**
- Docusign Envelope History (web) — https://mobbin.com/screens/3b9577ec-b873-41e6-8a9b-82588f79da3b
- Docusign Deleted/declined list (web) — https://mobbin.com/screens/2af5249e-4342-4431-a075-0061490d3f69
- Dropbox Send and track (web) — https://mobbin.com/screens/406d1aca-5d35-45d2-b814-572303156782
- Dropbox Signatures (web) — https://mobbin.com/screens/a247933b-7a90-4413-a13d-4ac9ec815ced
- Contractbook signature status (web) — https://mobbin.com/screens/01147852-b6d8-4b47-960b-1a5164644aed
- Contractbook signed banner (web) — https://mobbin.com/screens/1960603e-d92c-4f7b-8aca-eb95c890fe04
- PandaDoc documents list (web) — https://mobbin.com/screens/dd1cd29d-d18b-4b78-a72e-307e9047c694
- PandaDoc team dashboard (web) — https://mobbin.com/screens/e4c9b779-c625-4675-8005-0dca143afce8
- HoneyBook File summary (web) — https://mobbin.com/screens/d544c797-f87c-4b8b-91d6-229f29457fac
- Workable e-signatures tab (web) — https://mobbin.com/screens/1aad6305-1ecf-4a72-b2f1-106168eec9ff

**Anatomy as observed:**
- Docusign "Envelope History": metadata block (Envelope ID, Date Sent, Status "Need to Sign", Status Date, Holder, Time Zone) + Activities table (Time / User / Action / Activity / Status) with rows like "Alex Smith sent an invitation to Sam Lee [email] — Sent"; `Print` / `Download Certificate`. Declined state appears in lists as "⊘ Sam Lee declined".
- Dropbox "Send and track > Views": per-viewer rows (who, file, total time "01:50", when) expanding to Link name / Location "Dublin, CA, US" / Device "Desktop, Windows", a "Time spent per page" bar chart per page 1–10, "Embedded link clicks" per page, and "Viewer downloaded the file" event.
- Dropbox "Signatures": status filter chips `Sender / Pending signature / Pending your signature / Signed (1) / Declined / Canceled`; table Name / Status pill / Sender / Sent.
- Contractbook right-rail "Signature status": per-party cards — "Sam Lee `You` … `Signed digitally` IP: 169.150.254.77" vs "Jon Smith … `Not opened`" / "Jane Doe … `Not opened`"; doc header pill `Pending`; signed doc gets green banner "✓ Signed on: 12 March 2025 at 20:54:56 GMT+7" and pill flips to `Signed`.
- PandaDoc list: Status column (`Completed` green / `Draft` grey "No recipients"); filters Date/Status/Owner/Recipient/Company; right-rail "Audit trail" ("Jane Doe completed this document manually · about 1 hour ago · Indonesia"). Team dashboard: status tabs "Declined 0 documents | Completed 2 documents | Suggested edits 0", Timeline cards "This document was completed by all recipients 1 minute ago".
- HoneyBook "File summary": status pipeline rendered as chips **`SENT → VIEWED → IN PROGRESS → COMPLETED`** with current state filled; "PAGES 1 of 1 viewed"; SHARED WITH rows (LAST VIEWED "18h ago", PAGES VIEWED "1 of 1"); ACTION SUMMARY "Contract (signed 2 of 2)"; draft-visibility warning: "You have an unpublished draft. All your changes have been saved but will not be visible to participants until published."
- Workable: e-signature rows on the employee profile with signer avatars + green check, toast "Success! Document signed".

**Problem solved:** After sending an artifact to an external party, prove delivery and engagement per recipient — opened or not, which pages, signed/declined — so silence is distinguishable from refusal.

**Sad paths observed:** "Not opened" as an explicit per-recipient state (Contractbook); "declined" as a terminal tracked status (Docusign, Dropbox); unpublished-draft divergence warned (HoneyBook); per-event audit trail with IP for disputes.

**Microcopy worth stealing:** "SENT → VIEWED → IN PROGRESS → COMPLETED"; "Not opened"; "Signed digitally"; "signed 2 of 2"; "This document was completed by all recipients"; "[X] sent an invitation to [Y]"; "Download Certificate"; "Last viewed 18h ago · Pages viewed 1 of 1".

**A11y/notes:** This is the closest Mobbin gets to the rooming-list handoff acknowledgment loop: send rooming list to hotel → track `Sent / Opened / Acknowledged / Disputed` per hotel contact, with Contractbook-style per-recipient state cards and a Docusign-style activity log. Delegate confirmations are the same pattern at 1:N scale (Dropbox Signatures status chips = confirmation pipeline). What Mobbin does NOT show: the recipient countersigning a structured list (room-by-room ack) — only whole-document ack.

---

## P22 — CSV column-to-field mapping step (with sample preview and unmapped warnings)

**Apps observed:**
- Customer.io Map fields (web) — https://mobbin.com/screens/3418d244-0554-47af-820d-c981807b49da and https://mobbin.com/screens/563c569d-970b-4ff7-a5fb-e07b6df3f2f9
- HubSpot import mapping (web) — https://mobbin.com/screens/0d38bdc3-8b30-40f8-90a9-630fb0404efd and https://mobbin.com/screens/a351d89b-0d95-477c-ba9c-ec9016adf148
- Wix Import Contacts (web) — https://mobbin.com/screens/2a9450b5-ade7-4f84-b805-404416f2d3f3
- Dovetail Map columns (web) — https://mobbin.com/screens/3e09c7e7-05ea-4893-b16d-458f6e205295 and https://mobbin.com/screens/c0baa7ca-cd82-4ad3-9d04-2de2997075df
- Employment Hero Import Leave Balances (web) — https://mobbin.com/screens/47b97a05-cbcb-4df8-adf3-31a77a6a1f50
- Square Assign field labels (web) — https://mobbin.com/screens/64a00261-0ecf-4c0f-9284-1242d4df58fe
- Podia Match Columns (web) — https://mobbin.com/screens/9f03fd17-65da-4a84-94ae-a9ee54972d55

**Anatomy as observed:**
- Customer.io "2. Map fields": one card per CSV column showing the header + first 3 sample values, each with checkbox (include/exclude) and "MAP TO ATTRIBUTE" dropdown carrying badges `Identifier`, `Reserved`, `Required` (email: "Identifier · Required").
- HubSpot: table COLUMN HEADER FROM FILE / PREVIEW INFORMATION (3 sample values) / MAPPED (green check or amber dot) / IMPORT AS / HUBSPOT PROPERTY dropdown; unmapped custom column gets "Choose or create a property"; footer gate: **"You have 1 unmapped column"** + checkbox "Don't import data in unmapped column" with `Next` disabled until resolved.
- Wix "3. Match" step: rows Your Field Titles / Preview / Wix Contact Fields dropdown; amber banner **"⚠ 1 unmatched field won't be imported."**; stepper `Prepare ✓ · Upload ✓ · Match · Label`.
- Dovetail "Map columns": the actual spreadsheet rendered with a mapping dropdown atop each column ("Find an option…" list: Answered, Contacted, Date, Email, Followers…); selected column highlighted; duplicates policy dropdown "If this data contains duplicates of existing data, what should we do?"; unique-identifier picker "…as a unique identifier. This is required to handle duplicates."; CTA carries the row count **"Import 303 rows"**; limit notice "🤠 Howdy, I'm the CSV cowboy! That's a lot of rows! We only support 500 rows per import".
- Employment Hero: two-column connector layout — "Your CSV Columns" (with sample values) wired by lines to "Employment Hero Fields" dropdowns; banner "Map Your Columns — Step 2 of 4".
- Square "Assign field labels": left = imported labels, right = profile-field dropdowns; rule stated: "One of the following must be set to begin an import: name, email, phone number. Any custom field must have a unique name."; status line "All field labels have been assigned".
- Podia: column-header dropdowns directly on the preview grid ("Entry ID — Choose column ▾").

**Problem solved:** Reconcile someone else's spreadsheet schema (registration export, hotel block sheet) with the system's fields before ingestion, surfacing required/identifier fields and unmapped leftovers.

**Sad paths observed:** Unmapped columns block or warn ("You have 1 unmapped column" + disabled Next; "1 unmatched field won't be imported"); duplicate-handling policy forced as an explicit choice (Dovetail); row-count limit stated with personality; required-identifier rules stated up front (Square).

**Microcopy worth stealing:** "You have 1 unmapped column"; "Don't import data in unmapped column"; "1 unmatched field won't be imported."; "If this data contains duplicates of existing data, what should we do?"; "Import 303 rows" (count in the CTA); "All field labels have been assigned"; badges `Identifier / Reserved / Required`.

**A11y/notes:** Sample values under every header are what prevent mis-mapping — never show header names alone. For rooming: delegate import needs Identifier = registration ID/email, Required = name + check-in/check-out, and a duplicates policy ("update existing delegate vs create new") exactly like Dovetail's; hotel block sheets need per-hotel mapping templates remembered between imports.

---

## P23 — Cancellation flow: reason capture + consequence preview + deadline timeline

**Apps observed:**
- Booking.com (ios) — https://mobbin.com/screens/124a1f9d-c2a9-4189-aa67-486896cf9864
- GetYourGuide (ios) — https://mobbin.com/screens/c414c61e-70c9-478f-826a-ee5da3aeb5ce
- Tripadvisor (ios) — https://mobbin.com/screens/03be5400-0183-4798-af32-25c9aabce61a and https://mobbin.com/screens/f70aa14a-7a43-4464-8d4c-b61f2d080d1c
- Trip.com (ios) — https://mobbin.com/screens/325dc0a4-7170-44d0-a5d9-673580b73902
- Vrbo (ios) — https://mobbin.com/screens/c8b30eb5-2755-4d35-be80-45c2a8aba753
- Viator (ios) — https://mobbin.com/screens/2abc66a2-4d44-4d03-8f17-bfa3554662b8
- Airbnb (ios) — https://mobbin.com/screens/155d1353-a9e7-41be-af05-9450a6208d57

**Anatomy as observed:**
- Booking.com: sectioned page — "What happens if you cancel? — If you cancel we'll refund you $70.95… can take your bank up to 7 working days"; "Why do you want to cancel?" with disclaimer **"This won't affect your refund. It's just to help us improve our service."** + reason dropdown ("The timing of my trip has changed"); "Refund breakdown" table (What you've paid / Subtotal / Fees / Cancellation fee $0.00).
- GetYourGuide: deadline stated on the detail page ("Cancel before 4:00 PM on November 29th for a full refund") with `Reschedule this booking` offered above `Cancel this booking`; cancel sheet: "You'll get a full refund of $2.15. How would you like it?" radio "As GetYourGuide credit — Available immediately" vs "To my original payment method — May take up to 7 days"; `Confirm cancellation` disabled until choice.
- Tripadvisor: "Why are you cancelling this booking?" dropdown + probe "Did the provider ask you to cancel? Yes/No"; "Amount you paid / Your total refund" pair; not-yet-charged state handled: "Reserve now pay later: You have not been charged for this booking… We will cancel the scheduled payment associated with your card ending in 2150." "Cancel for Any Reason" explainer ends with bolded irreversibility: **"Cancellations can't be reversed."** + `Confirm cancellation` / `Go back`.
- Trip.com: radio reason list ("My travel plans have changed / Booked the wrong date or destination / Unable to travel due to illness / …transport delays / Hotel agreed to refund / Issue with hotel"); "Refund Info" sheet itemizes destinations: "$18.49 will be refunded to your MasterCard debit card / Promo code: …returned to your Trip.com account".
- Vrbo "Change or cancel": refund tiers as prose ("100% refund… if you cancel by Dec 6 / 50% refund (minus the service fee) if you cancel by Dec 13 / No refund after Dec 13") AND as a vertical timeline with date nodes (Dec 6 → Dec 13 → Dec 20 Check-in) and badges (✓ 100% refund / 50% refund / No refund); precision rule "Cancel by 11:59pm (property's local time) on the date listed…"; de-escalation: "Flexible dates? Instead of canceling, try asking if you can reschedule… by clicking 'Request change'".
- Airbnb "Cancellations": same timeline grammar — "Free cancellation until 3:00 PM on 24 Jun", nodes "Reservation confirmed · Full refund" → "24 Jun, 3:00 PM · 24 hours before check-in · Full refund, minus the first night and service fee" → "25 Jun, 3:00 PM · Check-in" with house icon.
- Viator: reason + provider probe + refund total + "Refunds will be processed to your credit card ending in […]. It may take 3-5 business days to appear." + green `Cancel Booking`.

**Problem solved:** Make the cost of cancelling legible before the act — refund amount, fee, deadline tiers, destination of the money — while capturing the reason and offering a cheaper alternative (reschedule).

**Sad paths observed:** Entire pattern is sad-path engineering: deadline-tier timelines render the penalty schedule visually (Vrbo/Airbnb); irreversibility bolded (Tripadvisor); reason marked as non-punitive (Booking.com); reschedule offered before cancel (GetYourGuide, Vrbo).

**Microcopy worth stealing:** "What happens if you cancel?"; "This won't affect your refund. It's just to help us improve our service."; "Cancel before 4:00 PM on November 29th for a full refund"; "Cancel by 11:59pm (property's local time)…"; "Cancellations can't be reversed."; "Instead of canceling, try asking if you can reschedule"; "Full refund, minus the first night and service fee".

**A11y/notes:** The Vrbo/Airbnb deadline timeline is the closest observed UI to the room-block cutoff/attrition lifecycle: render contracted-block deadlines (release date, attrition date, cutoff) as the same vertical timeline with per-tier consequences ("Release 10 unsold rooms / Penalty applies / Hotel takes back inventory"). Delegate-cancel flow should preview downstream effects ("Roommate Tanaka will be alone in a Twin — re-pair or rebook?") the way refund breakdowns preview money.

---

## P24 — Recipient-side RSVP / accept-decline response capture

**Apps observed:**
- Partiful RSVP modal (web) — https://mobbin.com/screens/a29986cf-f78b-4fb9-a8a8-466acba9f71e and https://mobbin.com/screens/004cb122-650a-42e5-a6de-24a07082c969 and https://mobbin.com/screens/b69ae413-a48e-4bb6-97c2-b0a129bbdaaf
- Partiful Find a Time (web) — https://mobbin.com/screens/41d2fdb8-e71b-4622-b932-960f57b4eea7
- Partiful host options (web) — https://mobbin.com/screens/46d3a415-90b8-4ebf-b783-f4fc68cec5b7 and https://mobbin.com/screens/3022678d-6355-48e3-ad5d-74cd33ca2d78
- Eventbrite (web) — https://mobbin.com/screens/d9b43438-ab86-4c86-adf9-c3ed309f1651
- Posh (web) — https://mobbin.com/screens/c3ec4f78-0cba-4e4b-a4e3-0453b138b5ef
- GitHub org invite (web) — https://mobbin.com/screens/d9f1f83e-95dd-4f1d-9230-1b057f2162ea
- Sketch document invite (web) — https://mobbin.com/screens/63ebd23e-0196-400c-8bf7-0b9ee5338476

**Anatomy as observed:**
- Partiful RSVP modal: three big emoji choices "I'm Going / Maybe / Can't Go" (selected one ringed), then minimal identity capture — "Your Name", phone with caption **"Just for event updates. No spam."**, attendee-count dropdown "1 attendee / 2 attendees", optional "+Post a comment", `Cancel`/`Continue`. Event page shows scarcity "10/10 spots left" and live counts of who's in each bucket.
- Partiful "Find a Time": per-date RSVP matrix (August 9th: 👍/🤔/😢 with "Maybe" selected; August 10th "Will Go") + rule "When the host picks a time, your RSVP will auto-update."; host side shows "Finding a Time… The host will pick one when they're ready!" and a "Turn off Find a Time" option.
- Partiful host controls: "RSVP Options" panel with icon set chooser; quick actions `Collect Info` / `Reminders` / **`Require Guest Approval`**; "Open Invite" toggle; safety add-ons (+REQUIRE TESTING / +MUST BE VACCINATED…) as composable chips.
- Eventbrite: "RSVP for Free Entry" card with − 1 + stepper and `Reserve a spot` — RSVP as inventory claim.
- Posh: single red `RSVP` bar pinned at viewport bottom of the event page.
- GitHub: "You've been invited to the [org] organization! Invited by Jane Doe" + `Join Mobmobdesign` / `Decline`; transparency list "Owners … may be able to see: …Your IP address"; "Opt out of future invitations from this organization."
- Sketch: "Sam wants to share a document with you — Accept this invitation using [email] to get access to '…' and be notified of any updates." + `Accept Invitation` / **`Request access with a different email`** (wrong-identity escape hatch).

**Problem solved:** Capture a third party's yes/maybe/no with near-zero friction, tie it to an identity, and keep the response updatable — what a delegate does with a proposed room assignment.

**Sad paths observed:** Maybe/Can't-Go are first-class, not failures; wrong-account answered by "Request access with a different email"; capacity interlock ("10/10 spots left"); host-side gate "Require Guest Approval" inserts a review state between RSVP and confirmed.

**Microcopy worth stealing:** "I'm Going / Maybe / Can't Go"; "Just for event updates. No spam."; "When the host picks a time, your RSVP will auto-update."; "Require Guest Approval"; "Request access with a different email"; "10/10 spots left".

**A11y/notes:** Delegate room-confirmation page should be Partiful-shaped: one glance at the proposal (hotel, dates, roommate), three-button response (Confirm / Request change / Decline), no login wall — identity via tokenized link, with the GitHub-style transparency note about what the ops team sees. "RSVP will auto-update when the host picks" is exactly the contract for tentative assignments pending block confirmation.

---

## P25 — Duplicate detection + merge-records flow (pick primary, resolve field conflicts)

**Apps observed:**
- folk Duplicates (web) — https://mobbin.com/screens/75065e3c-d49c-43fc-8705-fc5d622b140c and https://mobbin.com/screens/a8ecbb79-eab1-4f16-b300-f68406497f98
- Salesforce Potential Duplicate Records (web) — https://mobbin.com/screens/eb7abb1d-f6fe-432c-b6f9-495dfdb360af
- ManyChat merge contacts (web) — https://mobbin.com/screens/e38f6439-f1c0-4d5e-b67b-9fda6f59dfb9 and https://mobbin.com/screens/7c5ba065-40ce-48ca-80a2-bcfac03d550d
- Front Review your merge (web) — https://mobbin.com/screens/7dd16e14-0899-4b53-9525-a5fef2def520 and https://mobbin.com/screens/27b4d4c0-2202-4a67-8c7f-c697af258cef
- Customer.io Merge people (web) — https://mobbin.com/screens/fc4ad682-589e-4f1e-a20e-48ddfba67d4f and https://mobbin.com/screens/61d6f67b-b699-48dd-bbe7-5a20a40ef4e7
- Kajabi merge contacts (web) — https://mobbin.com/screens/1923cdf0-453c-4552-9e2a-c8ce5e332b3b

**Anatomy as observed:**
- folk "Duplicates": dedicated sidebar section with count badge; "We've detected 1 possible duplicate contact. You can merge them into one contact."; two source cards side by side + a third merged-preview card with per-field checkboxes (2 Phones → both kept, star marks primary value); `Don't merge` / `Merge`. List-selection variant: "You're about to merge 2 people" with radio per conflicting field (Matt/Bayer vs Kurt/Gulgowski) and live merged preview.
- Salesforce "Compare leads": full field-by-field radio table — "PRINCIPAL RECORD ● Use as principal"; per-row choice between values (PHONE "(650) 123-7552" vs "(650) 213-7552"; NO. OF EMPLOYEES 50 vs 64; "[empty]" shown for missing values); rule stated: "When you merge, the principal record is updated with the values you choose, and relationships to other items are shifted to the principal record."
- ManyChat: "Primary Contact / Secondary Contact" pickers with swap arrow; rules box "Please note: 1. A contact from any channel can be the Primary. 2. … 3. The system won't merge two different Instagram, WhatsApp, or Telegram contacts. The merge will delete the Secondary Contact and its Inbox records."; `Preview` before commit.
- Front "Review your merge": explainer "How does merging work? — Fields that can have multiple values (like handles) are all preserved. If there are conflicting values for a unique value field (like the name), you'll get to pick the one to keep. **Merging cannot be undone.**"; amber "⚠ 1 conflict found for name" with a dropdown on the merged record to pick John vs Jordan.
- Customer.io "Merge people": "Select a primary person" panel (attributes listed with `Identifier`/`Reserved` badges, "(all attributes will be saved)") + "Select a person to merge into primary" search by email/id/filters; conflicting secondary values shown struck-through with red blocked icons ("All attributes already exist in primary"); stepper "Setup → Review and confirm".
- Kajabi: "Select a primary contact — Choosing a primary contact's info will overwrite all of the secondary contact's info including tags. All offers, purchase history… will be merged together."; consent checkbox **"I understand merging these contacts is instant and cannot be undone."** gating `Confirm merge`.

**Problem solved:** Two records for the same human (delegate registered twice, agency + self registration) must become one without losing data — pick survivor, resolve field conflicts, understand what gets deleted.

**Sad paths observed:** Irreversibility called out twice (Front, Kajabi) with an explicit consent checkbox; un-mergeable combinations stated (ManyChat channel rule); conflicts counted and forced to resolution ("1 conflict found for name"); empty values rendered as "[empty]" not blank.

**Microcopy worth stealing:** "We've detected 1 possible duplicate contact."; "Use as principal"; "1 conflict found for name"; "Merging cannot be undone."; "I understand merging these contacts is instant and cannot be undone."; "The merge will delete the Secondary Contact and its Inbox records."; "(all attributes will be saved)".

**A11y/notes:** Merged-preview third card (folk) is the strongest variant — the user sees the outcome, not just the inputs. For rooming: duplicate delegates carry bookings; the merge must state what happens to BOTH room assignments ("Keeps Hilton Twin Oct 10–14; releases Marriott King — hotel will be notified") with the Kajabi consent checkbox before commit.

---

## P26 — Assign-people-to-slot picker + cross-system person matching (closest analogues to roommate pairing — true pairing UI NOT found)

**Apps observed:**
- 7shifts Employee Assignment (web) — https://mobbin.com/screens/26a78e73-dfb3-4c34-b4ea-fa7e1fb7dc06
- 7shifts Integration Mapping (web) — https://mobbin.com/screens/840f2068-529e-4514-9cc1-b20f7f3fa9a6
- Okta Assign Applications (web) — https://mobbin.com/screens/28acbc6d-8d2e-4609-aed9-eab32e0a0b02
- Airbnb shared-place question (web) — https://mobbin.com/screens/26d9cdc7-ddb0-47af-b7d1-24eb7a5a9f4c
- Airbnb Bedroom config (web) — https://mobbin.com/screens/1709c5a2-c157-4d42-8d49-a3dbd456a7e4

**Anatomy as observed:**
- 7shifts "Employee Assignment" modal (scoped "SLMobbin - Back of House"): live count header "👤 1 employees assigned"; checkbox list of people (Sam Lee ✓ with "Assign roles ▾" dropdown appearing once checked; Samantha Lee, Leonard Kim unchecked); footer "View employees" / `Cancel` / `Save` — the people-into-a-bucket picker.
- 7shifts "Integration Mapping > Employees (5)": amber banner "You have 5 employees that require matching. Matching employees will ensure that your labor cost data is kept up to date…"; per-person rows each with warning icon + dropdown **"Find match in Square… ▾"**; filter "Unmapped ▾"; tab badges Employees `5` / Roles `2` — person-to-person reconciliation across systems.
- Okta "Assign Applications": two side-by-side checkbox tables (Applications | People with per-person Status "Active"/"Pending user action") under a 2-step wizard **"1. Assign Apps to People → 2. Confirm Assignments"** — many-to-many assignment with a confirm stage.
- Airbnb host setup: binary shared-occupancy question "Will guests have the place to themselves?" options "Yes, the place is all theirs" / "No, the place is shared"; CTA `Get matched` ("By selecting 'Get matched' you agree to the Program Terms").
- Airbnb "Bedroom" editor: per-room property panes — "Sleeping arrangements — 1 queen bed", "Privacy info — Lock on bedroom door", Amenities, Accessibility features; "Delete room or space".

**Problem solved:** Put selected people into a named slot with a capacity count and a confirm step; reconcile the same human across two systems via per-row match dropdowns.

**Sad paths observed:** Unmatched people flagged per-row with warning icon + count badge (7shifts mapping); "Pending user action" status per person (Okta).

**Microcopy worth stealing:** "1 employees assigned" (live count in modal header); "You have 5 employees that require matching."; "Find match in [system]…"; "Confirm Assignments" as an explicit wizard step; "No, the place is shared".

**A11y/notes:** A rooming "put delegates in Room 412" modal = 7shifts Employee Assignment with capacity ceiling ("2 of 2 beds filled" disabling further checks). Registration-system↔rooming reconciliation = 7shifts Integration Mapping verbatim. IMPORTANT NEGATIVE RESULT: no app on Mobbin shows preference-based roommate pairing (gender/snoring/seniority constraints, mutual requests, suggested pairs) — the only "matching" UIs found are dating swipe (Bumble) and entity reconciliation. Roommate pairing is confirmed FIRST-PRINCIPLES territory.

---

## P27 — Bulk-send composer: audience picker + pre-launch recipient confirmation

**Apps observed:**
- Mailchimp email checklist (web) — https://mobbin.com/screens/e39db09c-30c9-4ee0-93f9-edf0bc5f6cf5
- Kit broadcast send (web) — https://mobbin.com/screens/2f2f7a89-745b-463d-9e98-714819698d65 and https://mobbin.com/screens/f722d4bb-07d8-409a-9b9b-4c12cbcfaec9
- Outseta Newsletter (web) — https://mobbin.com/screens/bb464668-61b9-4621-ab2c-f0bf1cdb9faf, https://mobbin.com/screens/f2d4d9bb-c66e-4ce8-91b2-d160041caa91, https://mobbin.com/screens/516f6d74-ef1c-4b27-8bc4-19910972625c, https://mobbin.com/screens/a5a2d93c-daa5-4b11-ba6a-b0a84be8b4c3
- HubSpot New email Send-to (web) — https://mobbin.com/screens/cd9a7f5e-db1b-454a-9b0e-ced20342a9d6
- Eventbrite Campaign recipients (web) — https://mobbin.com/screens/20f1e793-61cc-4476-9ae7-fa2680b1d7c6 and https://mobbin.com/screens/99d10f0f-9204-4042-83c4-cb40b39ca35f

**Anatomy as observed:**
- Mailchimp: vertical checklist with per-section check circles and edit buttons — "To — Customer in the audience SLMobbin. 3 recipients ↗ — Your 'To' field is personalized with *|FNAME|*. `Edit recipients`" / From ("To ensure delivery, we'll change your from address to …mailchimpapp.net") / Subject (with Preview Text) / Send time ("When should we send this email?") / Content; `Send` top-right disabled until checks complete; live design preview at right.
- Kit: "Who would you like to send this to?" filter builder ("Matching all ▾ of the following: All Subscribers + Add Filter / Add Filter Group") with live count "6 subscribers" at right; "When would you like to send this? — Send now ✎"; "Publish to web" checkbox; `Preview` button in footer.
- Outseta: section checklist To/From/Subject/Content each with status circle and CTA (`Add recipients` → checkbox tables "Email lists | Subscribers 0" and "Segments | Members 0"); pre-send modal **"Prepare for Launch — You're about to send a broadcast to: Monthly Newsletter Subscribers (list with 0 subscribers) / Active Users in the Last 30 Days (segment with 0 people)"** + `Send Now` / `Cancel` — recipient recap with live counts at the moment of commitment (including the zero-recipient trap made visible).
- HubSpot: "Send to*" + **"Don't send to"** exclusion picker; "Don't send to unengaged contacts" advanced checkbox; right rail "Estimated recipients — 0 out of 0"; tabs Edit/Send to/Schedule; `Review and send` as the gate.
- Eventbrite: "Campaign recipients" checkbox list ("Purchasers — 1 active subscriber", "1 item selected"); "Schedule your campaign — Send Now / Schedule Send"; privacy interlock "ⓘ You've selected a private event(s) to be included in your campaign. Check the Privacy settings…"; legal line "By Continuing, I am aware that I am responsible for my own data privacy obligations…"; `Save draft` / `Send campaign`.

**Problem solved:** Compose one message to a computed audience without mis-sending — audience defined by filters with a live count, exclusions explicit, and a final "you're about to send to N" recap.

**Sad paths observed:** Zero-recipient sends surfaced in the launch recap (Outseta "0 subscribers"); exclusion list as a first-class field (HubSpot "Don't send to"); privacy/compliance warnings inline before send (Eventbrite); Send disabled until all checklist sections complete (Mailchimp).

**Microcopy worth stealing:** "You're about to send a broadcast to:"; "Estimated recipients"; "Don't send to"; "Who would you like to send this to?"; "Prepare for Launch"; "Your 'To' field is personalized with *|FNAME|*".

**A11y/notes:** For rooming, this is the cascade-notification composer: after a block change, "Notify affected delegates (42) and 2 hotels" should open a Mailchimp-style checklist (To = computed affected set with live count, message, send time) ending in the Outseta "Prepare for Launch" recap. The HubSpot exclusion field maps to "don't re-notify delegates already confirmed."

---

## P28 — Hotel-side availability calendar: rooms-to-sell per night, open/close, bulk date-range edit

**Apps observed:**
- Booking.com extranet Calendar list view (web) — https://mobbin.com/screens/07541cc9-c756-495e-936c-21a11a2cf768
- Booking.com bulk edit panel (web) — https://mobbin.com/screens/2b3af48a-084e-4dea-baf6-bf49f9eae22e
- Booking.com closed state (web) — https://mobbin.com/screens/aa79f8b8-0826-47fc-90d2-a7989a37c13a
- Booking.com saved confirmation (web) — https://mobbin.com/screens/4de14ed6-2bdf-4268-81eb-2e42f48c1a91
- Booking.com monthly view drag-select (web) — https://mobbin.com/screens/b0c9a9a3-9098-45d0-8cc8-702d2dcad669 and https://mobbin.com/screens/76364cf4-e3b9-4bf5-8989-a990d277521b
- Booking.com Advice rail (web) — https://mobbin.com/screens/cbc93024-8ce9-4532-904a-ada690fe916d
- Booking.com Pace report (web) — https://mobbin.com/screens/63d9e8ab-9d8e-4370-b8e4-f63f18bb8b9d
- Expedia group booking request (web) — https://mobbin.com/screens/e402101c-86bc-4441-90b8-635b11dc2fda

**Anatomy as observed:**
- Booking.com extranet "Calendar" (list view): per-room-type matrix with stub rows **"Room status / Rooms to Sell / Net Booked"** against a day axis; status band colored green "Bookable" vs red "Closed"/"Multiple blockers"; per-night Rooms-to-Sell numerals ("1 1 1 1…"); rate-plan rows beneath (Standard Rate US$200, Non-refundable US$180 with "× 3 Edit"); `Bulk edit` button + tooltip "Want to change prices, restrictions, or rooms to sell for a long date range all at once? Try the bulk edit tool".
- Bulk edit panel: date-range fields + **"Which days of the week do you want to apply changes to?"** weekday checkboxes (Mon–Sun); tabs "Two-Bedroom Apartment | Multiple room types"; accordions "Rooms to Sell — Update the number of rooms to sell for this room type" / "Prices" / "Room Status — Open or close this room" (radio `Open Room` / `Close Room`) / "Restrictions"; scope line "Changes will be made to the date range: Jun 11, 2023–Jul 11, 2023"; `Save changes` → green "✓ Your changes were successfully saved!".
- Monthly view: drag-select across weeks (selected days outlined, range handles visible), "7 dates selected" panel with Start/End date, "No end date" checkbox, weekday-filter checkboxes, "Open or close for bookings" radios, per-rate Open/Closed + price inputs with inline validation "Enter a price" on empty.
- Advice rail: contextual recovery card "Reopen your property to get bookings again — Your property is currently closed but ready to be reopened for guests. Open property".
- Pace report: "Room nights and average daily rate" chart, "Bookings within: Last 365 days", Daily/Weekly/Monthly toggle, legal disclaimer about peer comparisons.
- Expedia group request "My Details": Reservation ID, Status "Active", Event Name, Agent Assigned (named human + phone), itinerary "July 01, 2024 (Mon) - July 05, 2024 (Fri) (4 nights)", **"Rooms per night: 10"** with a per-night grid "Jul 01 9 / Jul 02 9 / Jul 03 7 / Jul 04 7" under "2 Double Beds (1-2 People)"; Star Rating Target, Budget Range, Space Requirements (banquet room specs); "Your custom event page (instant booking) — …specially negotiated group rates that you can send to your guests without setting up a group hotel block."; buttons `Stop Hotel Bidding` / `Modify Request`; "Showing 193 of 193 Hotels".

**Problem solved:** Manage sellable-room counts per room type per night across long ranges — the supply-side mirror of room-block consumption — including taking inventory offline and bulk-adjusting whole ranges.

**Sad paths observed:** Closed/blocked nights rendered as red bands with named blockers ("Multiple blockers"); closed-property recovery advice card; empty price blocks save ("Enter a price"); per-night group counts allowed to vary (9/9/7/7 — shoulder-night tapering is data, not an error).

**Microcopy worth stealing:** "Rooms to Sell"; "Net Booked"; "Which days of the week do you want to apply changes to?"; "Changes will be made to the date range: …"; "Rooms per night: 10" with per-date counts; "Your property is currently closed but ready to be reopened"; "Stop Hotel Bidding"; "(4 nights)".

**A11y/notes:** This IS the room-block grid grammar: EventState's block view per hotel should be the Booking.com matrix with rows Contracted / Assigned / Remaining per room type per night, a bulk-edit drawer scoped by date range + weekdays, and Expedia's varying per-night counts proving blocks need per-night granularity, not a single number. Mobbin still shows no UI for the contract lifecycle around the block (cutoff dates, attrition penalties, release schedule) — only the inventory math.

---

## P29 — Undo toast + trash/restore safety net

**Apps observed:**
- HubSpot (web) — https://mobbin.com/screens/65f6d6d1-d896-4862-bd1f-e57e70eef581
- Asana (web) — https://mobbin.com/screens/36cb9092-004d-4cfa-abc7-930e4a7ff931
- Todoist (web) — https://mobbin.com/screens/75c4093b-73e7-4344-b2e7-54e90d94e58c
- Slite (web) — https://mobbin.com/screens/63d93077-da51-481c-a94b-fc14851c0d76
- Pinterest (web) — https://mobbin.com/screens/70234394-ca14-4def-8aa4-e9784fdccae1
- mymind (web) — https://mobbin.com/screens/6977701b-5aaf-404b-bdfe-2bb0ec36044d
- GitBook Trash (web) — https://mobbin.com/screens/9e06cd74-e5a9-4913-b907-5fc7476065be
- Fibery Trash (web) — https://mobbin.com/screens/762eacbd-2fb7-452d-a5c5-f631a55cc564
- ManyChat (web) — https://mobbin.com/screens/aa087c84-34ee-4fef-a3f5-707e88c5d2c0
- Whop (web) — https://mobbin.com/screens/bbd4e248-ff4f-489f-8a57-4e2b5716d737

**Anatomy as observed:**
- HubSpot: banner toast "Success. 1 ticket has been moved to trash. `Undo` ✕"; the vacated view explains itself: "This conversation is no longer here — It was moved to Trash."
- Asana: bottom-left toast "Product Demo - A was deleted `Undo`" with a draining progress line (time-limited undo); the deleted project's page itself shows "Looks like project … was deleted." + `Restore Project` button — undo survives the toast.
- Todoist: toast states the new value: "Date updated to Tomorrow 17:00 `Undo` ✕" — undo for edits, not just deletes.
- Slite: "One doc was archived. `Undo`".
- Pinterest: micro-toast "Update removed! `Undo`".
- mymind: personality toast "Out of sight out of mind. — This item is now in your mind trash. To undo, you can search for Trash and restore it. Items in your trash are deleted after 30 days."
- GitBook "Trash": "Recently deleted spaces can be restored from here. Any space in Trash is permanently deleted after 7 days."; restore confirmation toast "Welcome back! This space has been restored and can now be accessed again."
- Fibery "Trash": full table Public ID / Entity / When ("21h ago") / Who (avatar) / per-row `Restore` button; toast "Form 'New form' was restored `View` ✕".
- ManyChat: paired feedback — modal "✓ You have requested subscription cancellation — We will process your request as soon as possible." AND matching green toast.
- Whop: full-page state "Refund requested — Refund requests get answered within 48 hours!" + `Go to resolution center` + toast "✓ Issue submitted".

**Problem solved:** Make destructive or consequential actions reversible in two layers — an immediate inline undo, then a browsable trash with a stated retention window.

**Sad paths observed:** The pattern is the recovery path itself: retention windows stated ("deleted after 30 days" / "after 7 days"); the emptied location explains where the thing went (HubSpot, Asana) instead of a bare empty state; restore confirmed with its own toast.

**Microcopy worth stealing:** "1 ticket has been moved to trash. Undo"; "Date updated to Tomorrow 17:00 · Undo"; "It was moved to Trash"; "Any space in Trash is permanently deleted after 7 days."; "Welcome back! This space has been restored…"; per-row "Restore" with When/Who columns.

**A11y/notes:** Undo toasts must persist long enough and be keyboard-reachable; Asana's belt-and-braces (toast + restorable page) is the model. For rooming: unassigning a delegate or deleting a room block needs "Tanaka unassigned from Hilton 412 · Undo", a Fibery-style Trash (Entity/When/Who/Restore) feeding the P15 audit log, and a stated window before the change is propagated to hotels — undo-before-notify is the cheap path; after notification it becomes a P27 cascade re-send.

---

## P30 — Async export/report generation ("we'll email you when it's ready" + past-exports ledger)

**Apps observed:**
- Slack Export Data (web) — https://mobbin.com/screens/85dd544d-465c-4062-9048-ae3111f7daea
- Mailchimp export (web) — https://mobbin.com/screens/40b9b8e1-5517-4d1e-8d5e-736e39c3045d
- Basecamp export (web) — https://mobbin.com/screens/4b3243df-ee07-4ae4-b495-51d5fe718aee
- Upwork Custom export (web) — https://mobbin.com/screens/0476220b-260e-4b1e-8d13-0e0e5e6737d8
- Revolut Statement (web) — https://mobbin.com/screens/f0cd003c-b3ce-409f-9b58-90676cbf3c2f
- Coinbase Download report (web) — https://mobbin.com/screens/69d2b814-eb28-49c1-b06f-470ac85d559f
- Deputy report Export (web) — https://mobbin.com/screens/0e289156-3c3f-4da8-8235-80b530b3a4e3
- Bonsai Download Expenses (web) — https://mobbin.com/screens/3065b709-ced5-41ef-bca5-5275e61bda32
- Adobe Express download (web) — https://mobbin.com/screens/070bbffc-7c8e-43f8-bfb3-d6285cec0191

**Anatomy as observed:**
- Slack "Export Data": green banner "✓ Your export is now being generated. You'll receive an email when the export is ready for download."; scope honesty in two columns — "Here's what's included:" vs **"What's not included:"** (private channels, DMs, edit/deletion logs); "Past Exports" table (Started on / Type "Public channels only (Set by Sam Lee)" / Date range / Status "⟳ Waiting…"); retention rule "Exports will be permanently removed 10 days after they are downloaded."
- Mailchimp: "We're generating your export — If you have a lot of data, it may take some time… When your export is ready, we'll send a notification email to samlee.mobbin@gmail.com."
- Basecamp: "We're bundling up that export for you — Exporting can take up to a few hours depending on the size… But don't worry, **we'll just email you when it's ready**—no need to wait around. You can close this, or maybe you'd like to see the latest activity…"
- Upwork "Custom export": form (Data to export "Timesheet (CSV)", Optional columns checkboxes, date Range) + `Export data`; modal "Generating…"; side panel "Recently created — Files are removed after 30 days."
- Revolut "Statement SGD": format toggle `PDF | Excel`, Starting/Ending month pickers, modal "Your statement is being generated — It should take less than 3-5 minutes."; data-availability caveat ("Transaction information is available here while your account is open…download it first").
- Coinbase "Download report": filters (All time / All assets / All transactions), format rows "CSV report `Generate report`" / "PDF report ⟳ Generating…" with per-format state; explainer "The CSV lets you import… The PDF acts as a printable statement… Both formats contain the same info."; top toast "Your reports are being generated."
- Deputy "Export" modal: Destination "↓ Download ▾", Attachments row (report name + `PDF ▾` + `Portrait ▾` + `Letter ▾`), "More options — Repeat header labels / Include metadata", `Cancel`/`Export`.
- Bonsai: modal "Download Expenses — Generating file, please wait…" with progress dots.
- Adobe Express: "Still working… 54% complete" with `Cancel download` and parallel-work suggestion ("While you are waiting, turn your file into one of these formats. Don't worry, this won't interrupt your download.").

**Problem solved:** Large file generation can't block the UI — promise an email, keep a history of past exports with status, and state format/scope/retention so the artifact is trusted.

**Sad paths observed:** Long-wait honesty ("may take some time", "up to a few hours", "less than 3-5 minutes" — always a time expectation); exclusions stated up front (Slack "What's not included"); export files expire ("removed 10 days after downloaded", "removed after 30 days"); per-format independent states (Coinbase PDF generating while CSV idle).

**Microcopy worth stealing:** "You'll receive an email when the export is ready for download."; "What's not included:"; "Exports will be permanently removed 10 days after they are downloaded."; "we'll just email you when it's ready—no need to wait around"; "It should take less than 3-5 minutes."; "Both formats contain the same info."

**A11y/notes:** Per-hotel rooming-list export is exactly this: format (PDF for hotel front desk / XLSX for their PMS), scope statement ("Includes: confirmed + pending assignments for Hilton. Not included: delegates without room assignments — 4"), a Past Exports ledger per hotel (who generated, when, which version the hotel last received — ties into P21 tracking), and email-when-ready for large events.

---

## P31 — Persistent countdown banner / auto-expiring state (marketing-flavored; ops cutoff version absent)

**Apps observed:**
- Codecademy (web) — https://mobbin.com/screens/2bba3ef1-5192-4d4a-bf1c-8dda00b1903d and https://mobbin.com/screens/671e6416-420b-4da7-86cb-b5898151d3ff
- Base44 (web) — https://mobbin.com/screens/84d40ed3-d365-4973-b535-7ee97b5bea93
- Whop creator dashboard (web) — https://mobbin.com/screens/1e954184-2703-47d5-b24f-7b47ba45a9f7
- Linktree Redirect expiry (web) — https://mobbin.com/screens/4a0d1672-10f2-40fd-b8fa-81b2fe877665
- Foundation (web) — https://mobbin.com/screens/d2485fee-0fa4-4a13-8930-d8fea5a33e7a
- Rarible (web) — https://mobbin.com/screens/45392523-6366-4d49-874e-93cda72d4680
- OpenSea (web) — https://mobbin.com/screens/c3fd1ffb-5d86-4bd3-a898-f2ea97b0ee68

**Anatomy as observed:**
- Codecademy: site-wide top banner with live boxed digits "03d:23h:18m:51s — ENDS SOON: 20% off… Last chance to save… Ends Oct 4." — both relative countdown AND absolute date; persists across pages (also seen at "00d:23h:13m:59s").
- Base44: banner "Limited time welcome offer … 47:58:53"; fine print repeats the rule "Offer valid for 47:58:53. Applies only to the first billing cycle… does not apply to renewals."
- Whop: sidebar widget "$500 IN 7 DAYS" with segmented digits "0 6 DAYS · 2 3 HRS · 5 9 MINS · 2 9 SECS" + `View Milestone` — countdown as goal tracker.
- Linktree "Redirect": "Set an end time for your Redirect. Your Linktree will automatically restore when the Redirect expires." with DAY/HOUR/MIN/SEC counter, "Active until" date-time + timezone picker — user-configured auto-expiry of a state.
- Foundation/Rarible/OpenSea auctions: "Ends in 4d 5h 14m 59s" under the CTA; "Time left 00:08:24:46" beside "Highest bid"; bid rows each carry their own expiry "Expires in 6 days".
- OpenSea Drops: pre-launch countdown "1 day 10 hrs 26 mins 44 secs" + 🔔 notify + tabs "Active & upcoming | Past".

**Problem solved:** Keep an approaching deadline visible everywhere it matters, with the consequence stated, and let states auto-revert at expiry.

**Sad paths observed:** Expiry handled by design, not error: Linktree auto-restores the prior state; OpenSea moves drops to "Past"; per-item expirations coexist with the page-level countdown (Rarible bids).

**Microcopy worth stealing:** "Ends Oct 4" paired with live countdown (absolute + relative together); "Active until [datetime] [timezone]"; "…will automatically restore when the Redirect expires"; "Expires in 6 days" per row.

**A11y/notes:** Live countdowns must not be the only signal (pair with absolute date — Codecademy does both). NOTE: every observed instance is marketing/auction; no ops-grade cutoff banner ("Hotel block releases unsold rooms in 5 days — 12 unassigned") exists on Mobbin. The grammar transfers, but the room-block cutoff/attrition application is FIRST-PRINCIPLES.

---

## P32 — Modify-reservation flow: change axes menu → re-price/re-check → confirm-changes diff → email receipt

**Apps observed (flows):**
- Trip.com "Modify booking" (ios) — https://mobbin.com/flows/70684c67-9353-48bc-b9cf-0b734417e78f
- Marriott Bonvoy "Modify reservation" (ios) — https://mobbin.com/flows/4d947b98-71d1-4030-97e6-dd5daf6d0d3e
- IHG "Selecting new dates" (ios) — https://mobbin.com/flows/583021d8-d0d6-4ba2-a3c0-6b1ad63538f9
- Airbnb "Manage a reservation" (ios) — https://mobbin.com/flows/df2b89af-bd44-4bd4-915e-ade37c5fdf05
- Booking.com "Updating dates" (ios) — https://mobbin.com/flows/e67add4a-00b7-42fa-9598-ec93e0b4f721

**Anatomy as observed:**
- Trip.com: Options sheet (`Modify Booking / E-receipt / Confirmation Email / Book Again`) → "Modify" menu listing the four change axes with current values: "Contact Info … / Guests — Sam Lee / Dates — Mon, Mar 17–Tue, Mar 18 | 1 Night / Rooms — Backview | 1 Room", each with `Modify >` → "Modify Room Type/Dates" with rules up top: **"ⓘ Modification requests need to be confirmed"** and "ⓘ The hotel adjusts room rates based on demand. The final prices after modification are displayed on this page." + "Please recheck your selection" room list with fresh prices.
- Marriott: detail page sections "Modifying Your Reservation — Any change in the length or dates of a reservation may result in a rate change." and "Cancellation Policy — …no charge before 11:59 PM local hotel time on Jul 15, 2023 (1 day[s] before arrival). …we will assess a fee of 1072610.0 IDR if you must cancel after this deadline."; actions `Cancel Reservation / Modify Reservation / Book Another Room`; date picker with "My dates are flexible" checkbox and CTA "Continue with 1 Night"; **"Confirm Changes"** screen showing "DATES Jul 16–17, 1 Night" against "⚠ DATE CHANGE Jul 18–19, 1 Night" plus "Hotel Messages — Rollaway beds are only allowed in Deluxe Corner Pool View rooms at an additional charge." and "Not Guaranteed: Rollaway Bed / Foam Pillows"; final CTA "Book Now 1,061,291 IDR".
- IHG: "Select new dates" calendar with per-day prices printed under each date (287, 291, 368…), "Stay duration: − 2 Nights +", footer "Rooms from 329 USD / night Excludes Taxes & Fees" → re-select room/rate ("Book Now, Pay Later — Free cancellation 3 days prior to arrival" vs "Member Exclusive Best Flexible Rate").
- Airbnb: "What would you like to change about your reservation?" menu — "Change the date or time / Add guests / Remove guests (greyed-disabled) / Cancel my reservation (red)".
- Booking.com: Trip details with "Track your requests >" row and upsell "Get a better room for just US$11.38"; "Change dates" calendar → end screen **"Your booking has been successfully updated — We sent a confirmation email to alexsmith.mobbin@gmail.com – enjoy your stay!"** + `View booking`.

**Problem solved:** Change one axis of an existing booking (dates, guests, room, contact) while re-validating price/availability and ending with an explicit old-vs-new confirmation and an emailed receipt.

**Sad paths observed:** Changes framed as requests needing hotel confirmation (Trip.com); rate-change consequence warned before entry (Marriott); un-actionable options disabled, not hidden (Airbnb "Remove guests"); preference items flagged "Not Guaranteed"; pending requests trackable ("Track your requests").

**Microcopy worth stealing:** "Modification requests need to be confirmed"; "The hotel adjusts room rates based on demand."; "Any change in the length or dates… may result in a rate change."; "⚠ DATE CHANGE [old] → [new]"; "Not Guaranteed:"; "Track your requests"; "Your booking has been successfully updated — We sent a confirmation email to…".

**A11y/notes:** This is the delegate-side change-request loop for rooming: axis menu (Dates / Roommate / Room type / Cancel), availability re-check against the block (not hotel demand), Marriott-style Confirm Changes diff (ties to P19), and a tracked request state while ops/hotel approve (ties to P21/P5). The "request needs confirmation" framing is exactly right when inventory is contracted.

---

## P33 — Trip/stay itinerary timeline (check-in and check-out as day-axis events)

**Apps observed:**
- Pangea Itinerary (ios) — https://mobbin.com/screens/be9c7323-d039-4171-8e8e-312b9f3216d5
- Vrbo trip Itinerary/Bookings (ios) — https://mobbin.com/screens/04ca4e80-4441-49b5-8333-fcf9a93e392c and https://mobbin.com/screens/b370ef23-bf17-4232-9a3a-09bccf944e60
- Wanderlog trip Overview/Itinerary (ios) — https://mobbin.com/screens/1389b0e7-8090-4bf7-82fa-faf5372e5599 and https://mobbin.com/screens/4210b20d-2570-406f-b3ba-bca27df46114 and https://mobbin.com/screens/6a2bf7c4-1452-458b-954c-24ffa92d3619
- Trip.com tour itinerary (ios) — https://mobbin.com/screens/9946e520-531f-4ce8-b7b0-7a3dc51b69d5

**Anatomy as observed:**
- Pangea: vertical day timeline with time-stamped nodes; the SAME hotel appears twice — "Monday, 12 January · Check-in 01:00 pm · Best Western Plu… 12 Jan – 20 Jan" and "Tuesday, 20 January · Check-out 10:00 am · [same card]" — arrival and departure as separate first-class events; filter tabs `All | Wishlist | Stays | Events`.
- Vrbo trip view: tabs `Itinerary | Bookings | Saves`; day sections "Wed, Oct 1 — Check in for your stay → 2:00pm [Booked card: 1 night · Bang Rak]" and "Thu, Oct 2 — Check out → 12:00pm"; booking card carries `Booked` pill + "Itinerary: HA-RV2JCJ" reference; "Extend your trip at another stay" suggestions row (the closest thing to split-stay: chaining a second property after checkout).
- Wanderlog Overview: collapsible sections "Reservations and attachments — Flight / Lodging / Rental car / Attachment"; lodging card with address, "Mon, 1st Dec — Thu, 4th Dec", CONFIRMATION # with copy icon, price chip, NOTES ("Luggage storage available after checkout"); Itinerary tab = per-day chips (Mon 12/1, Tue 12/2…) mixing flight, hotel "CHECK IN" row, and activities; "Optimize route" with savings toast "We saved you: 3 mins of travel time · $0.02 of gas money · See changes/Revert".
- Trip.com tour: "Overview | Day 1 | Day 2 | Day 3" tabs over a route map with day-pin clusters (Day 1 Florence / Day 2-3 Siena).

**Problem solved:** Render a multi-day stay as events on a personal timeline so arrival/departure obligations (and gaps between consecutive stays) are visible day by day.

**Sad paths observed:** Gap between bookings handled by suggestion ("Extend your trip at another stay") rather than warning; reverted optimization offered ("See changes/Revert").

**Microcopy worth stealing:** "Check in for your stay"; "Check out"; "Itinerary: HA-RV2JCJ"; "Extend your trip at another stay"; "Luggage storage available after checkout".

**A11y/notes:** For a delegate with a split stay (Hilton Oct 10–12 → Marriott Oct 12–14), the Pangea/Vrbo grammar — check-out node and check-in node on the SAME day — is the honest rendering; a same-day pair should auto-attach a transfer note ("Luggage storage available after checkout" is the seed). No app shows ops-side split-stay management (deliberately splitting one person across two hotels because of block exhaustion) — only traveler-side display. The splitting decision UI remains FIRST-PRINCIPLES.

---

## P34 — Approval queue / action-required inbox (approve-reject per row, bulk approve, rejection reason)

**Apps observed:**
- Workable Inbox (web) — https://mobbin.com/screens/524dd62f-8f56-4977-947e-2935c3753356 and https://mobbin.com/screens/206a61d4-bf58-4bca-b9b6-8226d88ffc66
- Deel Expenses Action required (web) — https://mobbin.com/screens/ebede796-0ca0-408a-bf05-630420732e1f
- Deel Review pending items (web) — https://mobbin.com/screens/c3ce92d8-4112-4fda-b4d7-595882028c86
- Sprout Social Reply Approvals (web) — https://mobbin.com/screens/972bfe4f-61e5-485b-8538-9a90e646047e and https://mobbin.com/screens/5204e795-ee19-46f5-bcb9-7080c3d9add9
- Figma Upgrade requests (web) — https://mobbin.com/screens/1a995d36-0778-4380-ae40-d0f64896028b
- Microsoft Teams Member requests (web) — https://mobbin.com/screens/5cf259ed-d5bf-4493-b027-9a81d27c58c5
- Assembly Approvals Inbox (web) — https://mobbin.com/screens/f77c7f8c-610d-4a08-8264-9ea2aaaf5f3f
- Lemni inbox approval (web) — https://mobbin.com/screens/31c9c03a-dff3-4ab4-9710-b2990d13adbe

**Anatomy as observed:**
- Workable Inbox: left counts `Inbox 8 / Important 5 / To-dos 4`; mixed request rows ("Samantha Lee asked you to approve time off") expanding INLINE into a fact card (Employee / Time-off type / Period "15 April 2026" / Amount "1 day") with `Approve` (green) / `Reject` (red) right in the row + "View details" — decide without leaving the queue.
- Deel "Action required (71)": full table of pending expenses, each row with inline ✕/✓ icon pair; Actions menu "✓ Approve all your pending (71) / ✕ Deny all your pending (71) / Export items on table"; status pills "Pending your approval".
- Deel "Review pending items": urgency banner "ACTION NEEDED — You have 1 item due within 7 days… Please review this item now to approve." + `View Items`; checkbox list with right-rail Summary ("Contracts 1/1 / Pending Items 1/1 / Total to approve $431.00") + `Approve All`.
- Sprout Social "Reply Approvals": filters Approval Status ("Rejected") / Authors / Approvers; queue cards "Pending Direct Message" with the draft content embedded; rejected variant shows **"⊘ Message Rejected by Jane S." with the reviewer's reason "be friendlier"** attached.
- Figma Admin: "Upgrade requests 1" table (Name / Request "Design seat" / Note) with `Approve all` and a floating selection bar "1 request selected `Decline` `Approve`".
- Teams "Member requests": "Requests (1)" with requester's own message ("Could you please grant me access?…") + `Approve` / ✕ + `Approve all`.
- Assembly "Approvals Inbox": two mirrored sections — **"Awaiting your approval"** vs **"Approvals I've requested"** — with APPROVERS progress column "0/1".
- Lemni: approval embedded in a support thread — draft reply shown with `Decline` / `Approve` and a status chip "Waiting for approval ▾"; right rail of structured details.

**Problem solved:** Funnel every pending decision into one queue where the approver has enough context inline to decide, can bulk-approve the routine, and rejections carry a reason back to the requester.

**Sad paths observed:** Rejection-with-reason as data ("Message Rejected by Jane S. — be friendlier"); deadline pressure surfaced ("1 item due within 7 days"); both directions modeled (awaiting-your-approval vs requested-by-you); bulk deny exists alongside bulk approve.

**Microcopy worth stealing:** "Awaiting your approval" / "Approvals I've requested"; "Pending your approval"; "Approve all your pending (71)"; "You have 1 item due within 7 days."; "Waiting for approval"; approver progress "0/1".

**A11y/notes:** This is the ops inbox for rooming change requests (P32 delegate requests land here): rows like "Tanaka asked to change check-out Oct 12 → Oct 14" expanding inline with block-impact facts ("Hilton Twin: 2 nights available ✓"), Approve/Reject with required reason on reject (Sprout), bulk-approve for no-impact changes, and a "Requests I've sent to hotels" mirror section (Assembly) for the hotel-acknowledgment direction.

---

## P35 — Seat-map unit picker (choose a specific physical unit per person, with per-person turn-taking)

**Apps observed:**
- Singapore Airlines (ios) — https://mobbin.com/screens/bdb3990f-c5a3-4d4d-9de9-d41d842e28e3
- American Airlines (ios) — https://mobbin.com/screens/ce7bacb5-e107-4a4f-815e-e18052e17917 and https://mobbin.com/screens/cd8ed935-4780-468a-a7ea-43b81557838b and https://mobbin.com/screens/a9a1426e-bd45-446a-97c1-1c84d5e17883
- Hopper (ios) — https://mobbin.com/screens/0c87bb29-29df-4168-b0a1-74ee2923b0d5 and https://mobbin.com/screens/9b531a95-c038-4927-93cd-50c9a8af252c
- Booking.com flights (ios) — https://mobbin.com/screens/4d2d1372-d17f-42f2-8b01-fc512ab70c99
- Expedia (ios) — https://mobbin.com/screens/c4c5deeb-c279-4ad1-8a10-b9ba1851e86a
- FocusFlight (ios) — https://mobbin.com/screens/0f3b46f4-c2fd-4d8d-842c-47a51b32c5a7

**Anatomy as observed:**
- Singapore Airlines: header context (route "NRT - SIN", cabin "Economy", aircraft "Boeing 777-300ER"), selected unit echoed "42C — SGD 25.50"; color legend with prices ("Extra Legroom SGD 76.50 / Forward Zone SGD 25.50 / Standard Seat SGD 12.80"); grid of row numbers × lettered columns; taken seats = ✕, tiers = colors; `DONE`.
- American Airlines: auto-assign fallback stated before the map — **"⚠ If you don't want to pay, we'll auto-assign seats at no charge after you check in. You have the option to change seats later, but a fee may apply."**; tapping a unit opens a bottom card "Seat: 31F · $11 — Available seat" + `Select seat`; cabin sections labeled (First Class / Main Cabin) with lavatory/galley icons as landmarks.
- Hopper: per-person turn-taking — header dropdowns "SIN → JFK Outbound" + **"Judy Smith — Selecting"**; selected unit card "SGD 0.00 · Judy S. · 35H — Standard Seat · Choose your favorite seat `Select`"; `Next flight` advances the loop; second screen shows the next traveler ("Mobbin Design — Selecting").
- Booking.com: progress caption **"Select seat 1 of 1 — Traveler 1 (adult)"**; legend "Available seat ($18.31 – $46.31) / Unavailable seat / Selected seat".
- Expedia: "Choose your seats — Flight 2 of 2" with seat-key link; FocusFlight: minimalist fuselage map + `Confirm`.

**Problem solved:** Let a person (or an agent acting for several people, in sequence) claim one specific physical unit from a labeled spatial inventory, with price tiers, unavailable units, and an auto-assign fallback.

**Sad paths observed:** Auto-assign as the explicit no-choice fallback (American); unavailable units kept visible as ✕ rather than hidden; per-person sequencing prevents two people claiming the same unit (Hopper turn-taking).

**Microcopy worth stealing:** "We'll auto-assign seats at no charge after you check in."; "Seat: 31F · $11 — Available seat"; "[Name] — Selecting"; "Select seat 1 of 1 — Traveler 1 (adult)"; legend-with-price-ranges.

**A11y/notes:** Grid + legend + echo-of-selection is screen-reader-friendly only if each unit carries a full label ("42C, Standard Seat, SGD 12.80, available"). For rooming: assigning a delegate to a SPECIFIC room number on a floor map is this pattern (room tiers = room types; ✕ = occupied; auto-assign fallback = "let ops place you"). Hopper's "[Name] — Selecting" turn loop is the grammar for assigning roommate pairs one bed at a time. No hotel floor-plan picker was found on Mobbin — airlines own this pattern; transferring it to rooms is FIRST-PRINCIPLES assembly, not invention.

---

## P36 — Special-requests capture (structured preference checkboxes + free text + non-guarantee disclaimer)

**Apps observed:**
- Booking.com (ios) — https://mobbin.com/screens/e12ea2c7-7914-4fa2-b20b-6a8aa33a0ab4
- World of Hyatt (ios) — https://mobbin.com/screens/e48865a3-dc6c-47a3-a857-9fb658a18f5e and https://mobbin.com/screens/418d849f-64ea-4423-9ea3-18ee275624cc
- Shangri-La Circle (ios) — https://mobbin.com/screens/726e0325-0b74-4f26-b1e9-8e1813e6fbe0 and https://mobbin.com/screens/013a2b55-d067-41ee-81c3-f9e3f63d64cb
- Trip.com (ios) — https://mobbin.com/screens/3cad32cf-b8f8-4a7b-aa1d-2cc2c10a9a95 and https://mobbin.com/screens/3e28d20b-7877-47ea-b35a-56aed2c832db
- Klook (ios) — https://mobbin.com/screens/c3a5ad88-25fa-4b35-9c55-8d16b89d211e
- Vrbo (ios) — https://mobbin.com/screens/f8b24c72-30e9-4bac-8f33-6e1a08f49d7c

**Anatomy as observed:**
- Booking.com "Special requests": free-text "Your request" ("Queen bed") with two ⓘ rules: "Please write your requests in English." and **"Requests aren't guaranteed and are subject to availability at the property."**
- World of Hyatt "Special Requests": STRUCTURED sections — "Accessibility Requests" checkboxes (Sight-Impaired Devices / Hearing-Impaired Devices / Near Elevator), "Smoking Preferences" radios (No Preference / Smoking / Non-Smoking), "Comments" textarea with placeholder "Please include your mobile number in case we need to reach you."
- Shangri-La "Other Requests": "Arrival and departure details" with flight-number fields + toggles "Arrange arrival transfer (Charges)" / "Arrange departure transfer (Charges)" and rule "The transfers will be arranged only when you have confirmed with the hotel."; "Room preferences" toggle "Physically Challenged"; smoking preference disabled with reason **"This is a non-smoking hotel"**; trip-purpose radios ("Business Travel / Weddings & Celebrations…"); booking form caption "Please let us know of any additional request to help us prepare your arrival." textarea "0/300", language constraint "Please enter in English or Chinese".
- Trip.com: "Special Requests (Optional)" with preamble "The property will do its best, but cannot guarantee to fulfill all requests."; structured radios "Elevator proximity — Away from elevator / Near elevator" + collapsible "Other requests"; adjacent "Fine Print" sheet ("How to check in — This property does not have a front desk and will send you a check-in guide…").
- Klook: "Special requests (optional) — Special requests can't be guaranteed, but the property will do its best…"; structured "Bed type *" radio ("2 single beds") + "Other requests" textarea "0/200".
- Vrbo: modal with scope examples and consequence: "Special requests (e.g. roll-away beds, late check-in, and accessible rooms) are not guaranteed. If you don't hear back from the property, you may want to contact them directly to confirm. The property may charge a fee for certain special requests." textarea "Limit 250 characters".

**Problem solved:** Capture per-guest preferences in a structured way (so they can be filtered/honored at allocation time) while keeping a bounded free-text channel, and set the expectation that requests are best-effort.

**Sad paths observed:** Non-guarantee stated everywhere, in three escalating forms (not guaranteed → contact to confirm → may incur fee); impossible options disabled with the reason ("This is a non-smoking hotel"); language and character limits stated up front.

**Microcopy worth stealing:** "Requests aren't guaranteed and are subject to availability at the property."; "The property will do its best, but cannot guarantee to fulfill all requests."; "If you don't hear back from the property, you may want to contact them directly to confirm."; "Near Elevator"; "Bed type *"; "0/300".

**A11y/notes:** Hyatt proves the rooming move: convert the common 80% of requests into STRUCTURED fields (accessibility, bed type, floor/elevator proximity, dietary for banquets) that the allocation grid can filter on ("show delegates needing accessible rooms"), and keep free text only for the tail. EventState delegate forms should mark which requests are guaranteed-by-block (bed type if contracted) vs best-effort (high floor) — sharper than the consumer apps' blanket disclaimer.

---

## P37 — Event guest manager: capacity glance, day-of check-in, per-guest comms ledger + status-change-sends-email warning

**Apps observed:**
- Luma Guests overview (web) — https://mobbin.com/screens/3e087d90-6cd2-4f6a-9f12-533ad7a5bae0 and https://mobbin.com/screens/d2dc824d-cf0a-422d-a390-6857f7fb78ef
- Luma check-in list + modal (web) — https://mobbin.com/screens/51bf2700-616b-461e-a7d1-d2f3a4cb07f2 and https://mobbin.com/screens/544304a2-d9dc-415a-9b08-6c97773669c3 and https://mobbin.com/screens/a68e7be6-6516-485e-9779-5dda7d08a8f1
- Luma guest detail rail (web) — https://mobbin.com/screens/1cccc0a9-6c99-4842-9f30-8ac575ab9a41 and https://mobbin.com/screens/33958ae6-dc90-4a00-9697-24366acbe5b0
- Luma guest table (web) — https://mobbin.com/screens/6590ea9f-440f-452a-8963-346c73911840

**Anatomy as observed:**
- "At a Glance": progress bar "0 guests — cap 1,000" with sub-legend "● 1 Pending Approval · ● 1 Invited"; action cards `Invite Guests / Check In Guests / Guest List (Hidden)`; variant shows `Change Capacity / Close Registration` cards and note "Approved guests are shown on the event page — Hide".
- Check-in surface: session scoper ("8 Jun, 14:00 Thu ▾"), guest search, row "Jane … `Pending Approval`" with green `Check In`; tallies "0 Guests Approved · 0 Guests Checked In"; `Scan` button (QR path); confirm modal recaps Registered time + Approval Status before `Check In`; companion nudge "We also have mobile apps you can download to check in guests."
- Guest list rows: status pills `Going / Invited / Pending Approval` with inline `✓ Approve ✕ Decline` on pending rows; filters "All Sessions ▾ / All Guests ▾ / Approval Status ▾"; download/export icons.
- Guest detail rail: identity + "Invited 8 Jun, 0:27"; "Batch Actions" panel — "➕ Add to Series — add to 9 remaining sessions / ⊖ Mark as Not Going — for all registered sessions / ✕ Reject — for the full series" with caption **"We will send an email to the guest when you change their status."**; per-session status dropdown (`Approved ▾` → menu "Approve — Mark guest as attending the event. / Mark as Not Attending — The guest will be able to rejoin."); rejected state sentence "The guest is rejected from all sessions of this series."; toggle "Automatically add guest to newly created sessions"; **"Emails" section — chronological delivery ledger: "Registration Confirmation ✓ Delivered … 8 June 2023 at 03:30 GMT-4 / Registration Removed / Event Invitation"** with per-item view icons.

**Problem solved:** One per-person record that unifies status across many sessions, day-of check-in, and the full history of what the system has emailed that person — with the side-effects of status changes declared before you click.

**Sad paths observed:** Status-change side-effect warned in advance ("We will send an email to the guest when you change their status."); rejection reversible and explained ("The guest will be able to rejoin."); pending-approval guests visibly blocked at check-in.

**Microcopy worth stealing:** "We will send an email to the guest when you change their status."; "0 Guests Approved · 0 Guests Checked In"; "cap 1,000"; "Add to Series — add to 9 remaining sessions"; "The guest is rejected from all sessions of this series."; delivery rows "Delivered … at 03:30 GMT-4".

**A11y/notes:** The Emails ledger on the person record is the missing piece P10/P21 only gestured at: every delegate record in rooming needs "Communications" (Assignment proposal — Delivered Oct 3 / Reminder — Delivered Oct 6 / Confirmation received Oct 7) so ops never re-sends blind (pairs with P18 cooldown). The declared side-effect line is the single most transferable sentence in this sweep — every rooming status change should state who gets notified BEFORE commit.

---

## COVERAGE NOTE

### Queries run — session 1 (inferred from recorded patterns P1–P12; exact strings lost with the original agent)
- date range picker check-in check-out calendar (web+ios) → P1
- guest occupancy stepper rooms adults children (ios) → P2
- room type cards upgrade price inventory (ios/web) → P3
- reservation booking detail manage actions (ios) → P4
- status badges tabs ops table orders (web) → P5
- resource timeline people schedule calendar workload (web) → P6
- usage limits capacity meter quota alerts (web) → P7
- bulk select table rows toolbar actions (web) → P8
- ops table filters saved views export (web) → P9
- notifications feed unread mark all read (web) → P10
- kanban drag drop board people pipeline (web) → P11
- sold out waitlist notify me out of stock (ios) → P12

### Queries run — session 2 (verbatim, search_screens deep unless noted)
1. "progress checklist setup steps dashboard" (web) → P13
2. "stat summary cards dashboard occupancy metrics" (web) → P14
3. "audit log activity history record changes" (web) → P15
4. "empty state table no records call to action" (web) → P16
5. "conflict warning double booking overlap schedule" (web) → P17
6. "resend cooldown button disabled timer verification code" (web) → P18
7. "inline diff old new value change review approve" (web) → P19
8. "batch import processing progress results summary errors skipped" (web) → P20
9. "document sent recipients status viewed signed tracking" (web) → P21
10. "map csv columns to fields import matching dropdown" (web) → P22
11. "cancel booking select reason confirmation penalty refund" (ios) → P23
12. "accept decline invitation RSVP respond guest attendance" (web) → P24
13. "merge duplicate records compare contacts side by side" (web) → P25
14. "roommate matching pair people together shared room assignment" (web) → P26 — NEGATIVE for pairing itself; only slot-picker/entity-matching fragments
15. "compose bulk email recipients preview send notification message" (web) → P27
16. "hotel room block allotment group reservation inventory management" (web) → P28 (strongest domain hit of the sweep)
17. "undo toast snackbar action completed revert" (web) → P29
18. "export generating file download ready report email when complete" (web) → P30
19. "deadline countdown banner expires soon book by date urgency" (web) → P31 — marketing/auction instances only
20. search_flows "modify hotel reservation change dates manage booking" (ios) → P32
21. "split stay multiple hotels one trip itinerary segments" (ios) → P33 — traveler-side display only
22. "approval queue pending requests approve reject inbox" (web) → P34
23. "select seat map choose specific spot layout" (ios) → P35
24. "special requests notes accessibility needs booking guest form" (ios) → P36
25. "version history list restore previous version document" (web) → NOTHING NEW (subsumed by P19/P29)
26. "front desk arrivals today check in guest list operations" (web) → P37 (Luma)
27. "colored tags labels organize records categories" (web, fast) → NOTHING NEW (subsumed by P5/P8/P9)
28. "drag to resize extend duration bar gantt timeline edit" (web) → NOTHING NEW (subsumed by P6/P29) — second consecutive dry; sweep stopped

### Empty / nothing-new queries
Queries 25, 27, 28 surfaced no pattern beyond existing entries. Queries 14, 19, 21, 23 returned screens but their core target (preference pairing, ops cutoff banner, structured-list acknowledgment, room floor-plan picker) was absent — partial-negative results recorded inside those entries.

### Pattern domains Mobbin lacks — FIRST-PRINCIPLES CANDIDATES
Confirmed from sibling sweeps:
1. **Ops rooming grid (delegate × room × night)** — CONFIRMED GAP. Nearest raw material: P6 people-timelines + P28 Booking.com extranet rooms-to-sell matrix. No app shows named people allocated into named rooms across nights.
2. **Roommate pairing / preference matching** — CONFIRMED GAP (P26 negative result). Only dating-swipe and entity-reconciliation "matching" exist; no constraint-based people-pairing (gender, snoring, seniority, mutual requests, suggested pairs).
3. **Rooming-list handoff to hotels with acknowledgment loop** — CONFIRMED GAP. P21 (e-sign recipient tracking) and P30 (export ledger) are the donor patterns; no structured per-line acknowledgment ("hotel confirms rooms 401–412, disputes 413") exists anywhere.
4. **Room-block cutoff / attrition lifecycle** — CONFIRMED GAP. P23 refund-tier timelines and P31 countdown banners give the grammar; no UI models contracted-block release dates, attrition thresholds, or penalty preview.
5. **Cascade reallocation notifications** — CONFIRMED GAP. P27 (computed-audience composer) + P37 ("we will send an email when you change their status") + P17 (conflict triage) are the parts; no app composes "this change affects 12 delegates + 2 hotels — preview and send" as one flow.
6. **Waitlist tied to inventory release** — CONFIRMED GAP. P12 captures join-waitlist UI; nothing connects a cancellation restocking a block to automatic waitlist promotion with notification.

New gaps surfaced by this session's sweep (extensions):
7. **Hotel floor-plan / room-number picker** — airlines own the spatial unit-picker (P35); no hotel-room equivalent exists. Transfer is assembly work.
8. **Ops-side split-stay decision UI** — P33 shows traveler-side rendering of consecutive stays only; deliberately splitting one delegate across two hotels (because a block is exhausted mid-range) with transfer logistics is unmodeled.
9. **Per-night-variable group inventory request** — Expedia's group form (P28) proves per-night counts (9/9/7/7) but the negotiation/award loop with hotels (bids → contract → block) is invisible on Mobbin.
