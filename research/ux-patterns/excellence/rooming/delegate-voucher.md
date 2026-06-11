# Pattern: Check-in voucher (hotel-acceptable proof artifact with dual IDs, localization, wallet/PDF)
**Surface:** rooming · **Observed in:** Trip.com, Booking.com, Hopper, Airbnb, Wanderlog
(refs: https://mobbin.com/flows/3258b05e-c036-4184-8b99-637166dd19e1 , https://mobbin.com/flows/d3a2795e-74d3-49f8-b322-9a0e691eaa04 , https://mobbin.com/flows/fce87f24-b0c5-465a-8f73-dc82f04450dc ; raw: `_raw/by-flow.md` §F26/F27, `_raw/by-app.md` §A3/A6/A13)

## Flow
1. Printable voucher page distinct from the email: Confirmation no. + PIN, property address/phone, check-in/out, "Rooms 1 / Nights 1", guest names, occupancy note, cancellation fee table in hotel-local time; banner "ⓘ Use this or the main guest's name when checking in"; language tabs "English / Vietnamese"; Share / Email buttons (Trip.com).
2. Export menu on the booking: "Request invoice / Save as PDF / Add to Apple Wallet / Add to phone calendar / Save as image / Share this booking" (Booking.com).
3. Dual IDs side by side: "Hopper confirmation: C6V45XV9D4FW" AND "Reservation code: …" (Hopper) — platform ID vs hotel ID.
4. Reference numbers always one-tap copyable ("CONFIRMATION # A3F9K2" with copy icon, toast "Copied to clipboard").
5. Officialdom variant: "Get a PDF for visa purposes" (Airbnb) — medical/academic delegates need exactly this.

## Use when
Delegates need front-desk-acceptable proof; international events need localized vouchers; visa letters reference the stay.

## Avoid when
Treating the confirmation email AS the voucher — the artifact must be standalone, printable, and current after changes.

## Sad paths observed
PIN hidden in shared-PDF variant for security (Booking.com); fee table includes the non-refundable cliff row; guest-name mismatch warned ("hotel might validate the info during check-in").

## Accessibility
Voucher is a document: print-clean, language-switchable, screen-readable structure (label: value rows).

## Default verdict for our stack
RECOMMENDED — generate per delegate, per hotel, regenerated on every confirmed change; dual-ID display (EventState allocation ID + hotel confirmation number) and visa-letter PDF are direct steals for a medical-conference audience.
