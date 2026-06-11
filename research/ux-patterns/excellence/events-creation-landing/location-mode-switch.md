# Pattern: Location mode switch (In Person / Virtual / TBA) with map + arrival instructions

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/cbdf2a94-e07d-4eed-bb2e-fdcf06f95d8c, https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b), Eventbrite web (https://mobbin.com/screens/7e4343bf-2df1-4693-97fc-2a7e1f5ef06c), Circle web (https://mobbin.com/flows/22b4af6c-43fa-4ce7-9df0-7b822a93961e), Square web (https://mobbin.com/screens/d554aeed-a3ae-43fc-8242-557f1f40be52), Partiful web (https://mobbin.com/flows/e2ff50a1-4c52-40aa-9d5e-7459df74393d)

## Flow
1. Mode is chosen BEFORE fields appear: segmented control "In Person / Zoom / Virtual" (Luma) or "📍 Venue / 🖥 Online event / 📅 To be announced" (Eventbrite) — virtual organizers never see address inputs.
2. In Person: address autocomplete ("What's the address?"); choosing a place instantly drops an embedded map with pin below the field.
3. "+ Add Further Instructions" reveals an operational "Instructions" field separate from the public address — placeholder: "Tell guests how to reach you: parking spots, building entry codes, elevator location, or nearby landmarks." (Luma iOS).
4. Zoom mode: "Once you link your Zoom account, we can automatically generate Zoom meetings for you." — meeting auto-provisioned, row reads "Zoom Meeting — Auto-created by Luma"; manual URL/ID/password fields as fallback. Generic Virtual: single "Event URL" field.
5. "To be announced" is a first-class option — the event can publish before the venue is locked (Eventbrite); Circle adds "Hide location from non-attendees" as a checkbox and models five fulfillment modes in one dropdown (In person / URL / native stream / live room / TBD).
6. Partiful collapses everything to one forgiving field: "Place name, address, or link".

## Use when
Events can be physical, virtual, or hybrid; whenever address privacy or arrival logistics matter (gated venues, campuses, hospitals).

## Avoid when
Product is single-mode by definition — then the switch is noise. Don't auto-provision meetings without a connected account (show the link-account path instead).

## Sad paths observed
- Venue not yet booked → "To be announced" prevents a fake address.
- Hidden venues render as "Location Unavailable" chips in public listings (Luma) or "RSVP to see location" (Partiful) — withholding is a designed state, not a blank.

## Accessibility
Modes are labeled segmented buttons with icons + text; map is supplementary to a full text address.

## Default verdict for our stack
RECOMMENDED — fixes the old app's create form that collected only venueName (address/city/map URL were settings-only, flagged UNFINISHED in the done-spec). Venue + address autocomplete + map + separate arrival-instructions field at create time; TBA mode is genuinely useful for conferences announced before venue contracts close. Zoom auto-provisioning is V2.
