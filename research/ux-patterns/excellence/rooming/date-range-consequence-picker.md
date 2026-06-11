# Pattern: Date-range picker with computed consequence (nights in the CTA, per-night context, guards)
**Surface:** rooming · **Observed in:** Kiwi.com, Booking.com, IHG, Melio, Care.com, Deputy
(refs: https://mobbin.com/screens/48e29624-8b1a-4273-b15c-7f809573f8a1 , https://mobbin.com/flows/cc8ff7c8-36ab-4176-86ed-11967e0179ae , https://mobbin.com/flows/583021d8-d0d6-4ba2-a3c0-6b1ad63538f9 , https://mobbin.com/screens/3b9aac44-7d06-4927-a72b-e47347432cb5 ; raw: `_raw/by-pattern.md` §P1/P2, `_raw/by-app.md` §A7, `_raw/by-flow.md` §F6)

## Flow
1. Dual-month calendar anchored to the focused field (check-in vs check-out context preserved); selected range as a band; CTA carries the computed consequence: "Apply · 4 nights" (Kiwi.com).
2. Summary echoed back into the trigger field: "Tue, Mar 17 – Thu, Mar 19 (2 nights)", occupancy as "1 room · 2 adults · No children" (Booking.com).
3. Per-day context printed in the cells where it matters: nightly prices under each date; "Stay duration: − 2 Nights +" stepper as an alternative to two taps (IHG).
4. Downstream consequence of the picked date explained: "Estimated payment delivery — Dec 5… By 8 PM vendor's local time" (Melio).
5. Guards: unavailable days greyed (Care.com); next disabled until valid; range + type + notify-target compose into one small form (Deputy leave request).

## Use when
Setting/changing check-in/check-out against a block — cells should show block availability per night the way IHG shows prices.

## Avoid when
Free-text date entry without a calendar at all — the observed floor is a real range picker with computed nights.

## Sad paths observed
Disabled-day prevention over post-hoc errors; required end-date marked; no observed invalid-range error states (prevention-first family).

## Accessibility
Nights count as text in the CTA; focused-field anchoring announced; stepper alternative aids motor accessibility.

## Default verdict for our stack
RECOMMENDED — "Assign · 3 nights" CTAs, block-availability numerals in the calendar cells, and the old app's check-out>check-in validation upgraded to disabled-day prevention.
