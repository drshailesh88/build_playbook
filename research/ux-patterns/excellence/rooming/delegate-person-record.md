# Pattern: No-login person record with notification routing + profile-vs-stay preferences
**Surface:** rooming · **Observed in:** TravelPerk, Navan, IHG, Marriott Bonvoy
(refs: https://mobbin.com/flows/9a4a380d-8c5f-46a5-869c-402d31b57e2b , https://mobbin.com/flows/74dfa8ee-978c-4b5a-bff5-2ba7987c2538 , https://mobbin.com/flows/5a5a0869-0268-488d-a07e-ed834ff48eda , https://mobbin.com/flows/aeb8737b-3746-49ec-afdf-cc1f2075e64a ; raw: `_raw/by-app.md` §A10/A15, `_raw/by-flow.md` §F17)

## Flow
1. Access model declared at creation: "No access: Won't be able to sign in. Trip updates will be sent to the provided email" vs "Allow access: Will be able to sign in to manage their own trips" (TravelPerk) — participation without accounts.
2. Notification routing decoupled from identity: checkbox "Send trip updates to a different email" → "Where should trip updates be sent to?" (TravelPerk).
3. Identity-exactness rule stated: "Enter the following information exactly the same as it appears on the person's ID or passport" (TravelPerk/Navan).
4. Optional self-service invite per person: toggle "Send traveler an invite — Email this traveler an invite so they can access… their travel details." (Navan).
5. Preferences split durable-vs-stay: profile-level "Stay Preferences" (elevator proximity, bed type, accessibility) AND "Set stay preferences — See preferences for this stay" scoped to one reservation (IHG); chosen values summarized inline on hub rows ("Room Options — King Bed, Non-smoking, Extra foam pillows") (Marriott).

## Use when
Delegates are managed people, not account holders; assistants/agencies receive the delegate's notifications; preferences should persist across events with per-stay overrides.

## Avoid when
Forcing structure on a one-off walk-in record — minimal fields beat a full person model.

## Sad paths observed
Traveler-not-found typeahead recovers inline ("Can't find someone? Register a new traveler"); external-email risk warning before invite (TravelPerk §A22).

## Accessibility
Accessibility needs live as a first-class profile section (Marriott), not free text — they must survive into the hotel export.

## Default verdict for our stack
RECOMMENDED — this is EventState's delegate model verbatim: no-login people + routed notifications + ID-exact names (hotels validate at check-in) + durable preferences with per-event overrides.
