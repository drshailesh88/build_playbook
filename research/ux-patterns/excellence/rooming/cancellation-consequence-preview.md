# Pattern: Cancellation with reason taxonomy + consequence preview + retained record
**Surface:** rooming · **Observed in:** Trip.com, Booking.com, Tripadvisor, Vrbo, Navan, Hopper, GetYourGuide, American Airlines
(refs: https://mobbin.com/flows/c923674b-0cb0-41c0-882f-3542c0f6e156 , https://mobbin.com/screens/124a1f9d-c2a9-4189-aa67-486896cf9864 , https://mobbin.com/flows/187c952e-572b-48d6-8ae7-08d9f14752ce , https://mobbin.com/flows/82a9f1e5-aadd-4c95-986d-1378516e931f ; raw: `_raw/by-flow.md` §F10–F14, `_raw/by-app.md` §A8, `_raw/by-pattern.md` §P23)

## Flow
1. Consequence first: "What happens if you cancel? — …we'll refund you $70.95… up to 7 working days" + itemized refund breakdown (Booking.com); "Estimated refund $18.49" before submit (Trip.com).
2. Structured reason capture with a non-punitive disclaimer: "This won't affect your refund. It's just to help us improve our service."; taxonomy: plans changed / wrong date / illness / transport delay / hotel agreed / issue with hotel / found lower price (Trip.com).
3. Cheaper alternative offered before the destructive act: "Instead of canceling, try asking if you can reschedule" (Vrbo); "Reschedule this booking" above "Cancel this booking" (GetYourGuide).
4. Refund method choice with speed tradeoff chips: "Instant — credit" vs "Up to 10 days — original payment method" (Hopper).
5. Terminal state + durable record: "SUCCESSFULLY CANCELED" stamped over the preserved record with all fields muted (Navan); cancelled card keeps its confirmation number in history (Tripadvisor).
6. Group scoping limitation stated: "If you don't want to cancel for all passengers, please call Reservations." (AA) — consumer apps punt partial-group cancel; ops tooling must solve it in-product.

## Use when
Delegate or ops cancels an assignment/booking; block nights are released; roommates are affected.

## Avoid when
Never — every cancellation path needs at least consequence-preview + retained record.

## Sad paths observed
Entire pattern is the sad path; plus "Processing Refund" intermediate status, irreversibility bolded ("Cancellations can't be reversed."), not-yet-charged variant handled.

## Accessibility
Consequences as plain sentences before the confirm button; destructive action never primary-styled.

## Default verdict for our stack
RECOMMENDED — old app has soft-cancel with free-text reason; the deltas to steal: reason taxonomy (feeds analytics), downstream-consequence preview ("Roommate Tanaka will be alone in a Twin — re-pair?", "Night returns to Hilton block"), and the preserved-record cancelled state it already has.
