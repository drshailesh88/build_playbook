# Pattern: Logistics answered in-page (add-to-calendar, map + how-to-get-there, expectation chips, time-gated join)

**Surface:** events-creation-landing · **Observed in:** Eventbrite web (https://mobbin.com/screens/d9b43438-ab86-4c86-adf9-c3ed309f1651, https://mobbin.com/screens/50ebe5d6-11dc-48f3-b51d-d93c7281f4c2), Luma web (https://mobbin.com/screens/bb6dbae8-6030-4805-9ea2-51fab393a16f, https://mobbin.com/screens/b520e950-3a01-4bff-994c-dcf66672257b), Luma iOS (https://mobbin.com/flows/c3c2dcc7-b964-4cf1-b000-b4a9c780de92), Partiful web (https://mobbin.com/screens/ea80ec45-c112-44fe-812d-4e253153cbc1), Circle web (https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968)

## Flow
1. **Add to calendar** is a one-tap menu on the page: calendar icon under the date → "Google Calendar / Outlook Calendar / Apple Calendar" (Partiful); "Add to calendar" link on the event card (Circle).
2. **Map + transport:** "Location" card with embedded map, full address, and the host's arrival instructions text beneath ("Knock the door") (Luma); expandable "Show map ⌄" revealing "How to get there" with four transport-mode icons — drive / walk / transit / bike (Eventbrite).
3. **Expectation chips** answer pre-registration questions inline: duration "🕘 9 hours", format "📱 Mobile eTicket", "ALL AGES" (Eventbrite); "Good to know — View all ›" section aggregating age/door-time/parking info.
4. **Time-proximity surfaces:** countdown chips on registered states ("Starting in 3h 59m"); list urgency badges ("IN 28M", "IN 1D"); day-of weather forecast ("78°" + moon icon) and "Get Directions" quick action (Luma iOS).
5. **Virtual events:** join is time-gated with expectation-setting copy — "The join button will be shown when the event is about to start."; venue row reads "Zoom" (Luma).
6. **Dual timezone chips** on the date: event TZ + viewer TZ ("ET | ICT", viewer's selected) (Partiful).

## Use when
Any event whose attendees travel or plan. Every chip that answers a question is one less email to the organizer ("more ticket sales and less time answering messages" — Eventbrite's own framing).

## Avoid when
Don't fake precision (no transit icons without data; no weather more than ~7 days out). Don't time-gate join links for in-person events.

## Sad paths observed
- Address withheld (privacy): "Location Unavailable" chip in lists; "RSVP to see location" on page — withheld is designed, not blank.
- Old-app scar this fixes: venue map URL was a bare validated link; protocol-validated but unrendered.

## Accessibility
Transport icons paired with "How to get there" text label; countdown and timezone chips are text; calendar menu items are named targets.

## Default verdict for our stack
RECOMMENDED — for a conference, add-to-calendar (.ics with timezone) + embedded map + how-to-get-there + duration/format chips are table stakes the old landing page entirely lacks. Weather and dual-TZ chips are V2 delight.
