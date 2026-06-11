# BY-FLOW Raw Harvest — People/Registration Tables

Source: Mobbin MCP. Date: 2026-06-11.

---

## Flow hunt: event host manages guest list / approvals / check-in (Luma, web)

### F1. "Guests" tab — status-segmented at-a-glance + inline approve/decline
- Mobbin URLs: https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d , https://mobbin.com/flows/e688bd8e-2edf-4fc4-9984-f8795837cc85
- Event admin nav tabs: Overview / Guests / Registration / Blasts / Insights / More.
- "At a Glance": big count vs capacity ("1 guest · cap 1,000") with progress bar, status breakdown chips with colored dots beneath ("1 Going · 1 Invited", or "1 Pending Approval · 1 Invited") — the bar itself segments by status.
- Three action cards: "Invite Guests" / "Check In Guests" / "Guest List" — the Guest List card carries its visibility state as sublabel ("Shown to guests" / "Hidden").
- Guest List table: search box, filter "All Guests ▾", sort "Register Time ▾"; row = avatar, name, email (grey), ticket-type chip ("Standard"), status chip (Going green / Invited blue / Pending Approval amber), relative register time.
- Pending rows expose inline "✓ Approve" / "✗ Decline" on hover — no detail-page detour. Approve → green toast "Guest approved." and chip flips to Going.
- Export: download icon at Guest List header (guest list → file), plus open-in-new icon.
- Empty state: people icon, "No Guests Yet — Share the event or invite people to get started!"

### F2. "Checking in guests" — dedicated check-in surface
- Mobbin URL: https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198
- Minimal dedicated page (host-facing): event name + "Starting in tomorrow", session selector ("Session · 8 Jun, 14:00 ▾"), big guest search ("Search for a Guest…"), "Scan" button top-right (QR scan mode).
- Guest row: avatar, name, email, status chips ("Pending Approval" amber, "✓ Checked In in 13 hours" green) + primary "Check In" button → flips to "Update".
- Footer counters: "0 Guests Approved · 0 Guests Checked In"; "Manage Event Page ↗" link; mobile-app download promos (iOS/Android) for door staff.
- Toast: "✓ Checked in guest." Check-in BEFORE event start is allowed and labeled honestly ("Checked In in 13 hours" — i.e., 13h early).
- Overview tab also carries a persistent "Check In Guests" button near venue details once sessions exist.

## Flow hunt: quick-create contact

### Front — "Creating a contact" / "Adding a private contact" (side-panel create)
- Mobbin URLs: https://mobbin.com/flows/707ab494-e532-423f-b5bf-6e13bade31c7 , https://mobbin.com/flows/e76b7a05-efe7-4ff3-8e92-613f135cf6cf
- Contacts list header: Export / Create / Import (Import is the PRIMARY filled button). Empty state repeats the same two CTAs ("No shared contacts… Create / Import") — import treated as the main acquisition path.
- "New contact" right side panel: avatar uploader, name; "Access *" (Shared/Private select); Account link; "Contact Information * (at least one required)" — email, phone, X handle rows (SAME email-or-phone rule as GEM); Description; "Lists — Add to list ▾" multi-select with search; "Show more" for long tail; Cancel / Create (disabled until valid).
- Private contacts get an explainer info card ("Contacts that you add to this list will be kept private…").

### Pipedrive — "Adding a person" (modal with multi-value fields + labels)
- Mobbin URL: https://mobbin.com/flows/522ec9f2-8047-47a9-8c9b-2c32d13431da
- Green "+ Person" button → "Add person" modal: Name, Organization (autocomplete), Phone with type select (Work ▾) + "+ Add phone", Email + "+ Add email" (multi-value contact fields), Labels multi-select of colored chips (CUSTOMER / HOT LEAD / WARM LEAD / COLD LEAD / MANAGER) + "+ Add label" inline creation.
- Sidebar nav includes a permanent "Merge duplicates" item under Contacts.
- New row appears in table immediately; count updates ("2 people → 3 people").

### HubSpot — "Creating a contact" (create-and-add-another, go-to-record)
- Mobbin URL: https://mobbin.com/flows/1f3ac445-7779-4d76-92a0-a494cea4d38c
- "Create Contact" right slide-over: Email FIRST field, First/Last name, Contact owner, Job title, Phone, Lifecycle stage + Lead status (searchable selects); "Edit this form ↗" link to customize the quick-create form itself.
- Footer: Create / **Create and add another** / Cancel.
- Success banner top-center: "Success — A new contact was created. Go to record ↗" — batch-entry loop + escape hatch to the record.
