# Pattern: Structured special requests (checkbox prefs + bounded free text + tiered non-guarantee)
**Surface:** rooming · **Observed in:** World of Hyatt, Booking.com, Shangri-La, Trip.com, Klook, Vrbo, Expedia, HotelTonight
(refs: https://mobbin.com/screens/e48865a3-dc6c-47a3-a857-9fb658a18f5e , https://mobbin.com/screens/726e0325-0b74-4f26-b1e9-8e1813e6fbe0 , https://mobbin.com/screens/e12ea2c7-7914-4fa2-b20b-6a8aa33a0ab4 , https://mobbin.com/flows/e87f6f40-6e2b-4f5a-8bba-26db2fb878cd ; raw: `_raw/by-pattern.md` §P36, `_raw/by-flow.md` §F2, `_raw/by-app.md` §A14/A15)

## Flow
1. Structure the common 80%: "Accessibility Requests" checkboxes (Sight-Impaired Devices / Hearing-Impaired Devices / Near Elevator), smoking radios, "Bed type *" radio (Hyatt/Klook); accessible rooms as first-class room-type variants in the chooser ("Room, 1 King Bed, Accessible (Hearing)") (Expedia).
2. Bounded free text for the tail: "Other requests" textarea with counter ("0/300"), language constraint stated ("Please write your requests in English.").
3. Non-guarantee in escalating tiers: "Requests aren't guaranteed and are subject to availability" → "If you don't hear back from the property… contact them directly to confirm" → "The property may charge a fee for certain special requests." (Booking.com/Vrbo).
4. Impossible options disabled with the reason: smoking preference disabled — "This is a non-smoking hotel" (Shangri-La).
5. Honesty echo on the confirmation: "Not Guaranteed: Rollaway Bed, Foam Pillows" (Marriott §A11); "This room may not meet your accessibility needs. Accessibility requests… are subject to hotel approval and availability." (HotelTonight).

## Use when
Capturing delegate room preferences that the allocation step must filter on (accessible room, bed type, floor) and the hotel export must carry.

## Avoid when
Hiding hard requirements inside best-effort fields — an accessibility REQUIREMENT is an allocation constraint, not a request.

## Sad paths observed
Tiered disclaimers everywhere; option-disabled-with-reason; char/language limits up front.

## Accessibility
The point of the card: structured accessibility fields are filterable at allocation time and exportable — free text is neither.

## Default verdict for our stack
RECOMMENDED — sharper than consumer apps: mark which requests are guaranteed-by-block (bed type, if contracted) vs best-effort (high floor), and make "needs accessible room" a hard allocation filter.
