# Pattern: Group-event travel hub (event → participants → booking progress)
**Surface:** travel · **Observed in:** Navan Group Travel (refs: https://mobbin.com/flows/3817b51a-4d0f-44c1-a45d-81746206e3a3, https://mobbin.com/flows/1a36de0c-77a1-4014-8df7-e24330d95f22), TravelPerk Events (ref: https://mobbin.com/flows/2e2fe01b-2540-40d7-a35c-60bb6a4013e9)

## Flow
1. Create event: name, location autocomplete, start/end dates (+ times). Framing copy sells the loop: "Organize group travel for up to 500 participants. We'll send invites to your travelers, show you their booking progress, and keep you informed of estimated and actual booking costs."
2. Event page is a numbered setup checklist: ① Configure event settings ② Add participants ③ Send invitations — primary CTA ("Send invites") disabled until prerequisites done; reassurance "(you can still edit event details and add new participants after)".
3. Tabs: Event settings / Participants.
4. Event list cards carry the ops vitals: status ("In progress"), location, dates, countdown ("In 56 days"), **booking progress "0/2 booked" with progress bar**, "$0 actual / $2,606 estimated".
5. TravelPerk adds event privacy (Company event = everyone can see and attend / Private = invite-only) and an escape hatch to humans: "Need 9 or more rooms? Request a group booking — our in-house team… will handle everything."

## Use when
Travel is organized around a dated gathering with a roster — the per-event travel dashboard: how many of N delegates have itineraries, status mix, cost roll-up.

## Avoid when
Travel records don't share an organizing event (pure personal trip tools); or progress is unmeasurable (no roster to count against).

## Sad paths observed
- Empty list teaches the model: "Once you create a group event, you'll be able to manage the details here."
- Cost shown as estimated vs actual pair — never one ambiguous number.

## Accessibility
Checklist is an ordered list with state; progress bar paired with "0/2 booked" text.

## Default verdict for our stack
RECOMMENDED (header strip, not new IA) — EventState IS the event hub already; the steal is the roster-coverage stat ("23/40 delegates have travel · 12 confirmed · 5 sent") on the travel list header. Counts exist in oracle data; the surfacing is new.
