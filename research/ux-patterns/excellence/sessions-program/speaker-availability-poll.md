# Pattern: Availability voting on proposed slots

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Calendly, SavvyCal, Zoom (refs: [Calendly meeting poll](https://mobbin.com/screens/c2e9b6cc-5fc6-49e0-8b9b-8850e2f061d2), [Calendly poll voting](https://mobbin.com/screens/8b81ac40-561d-4f97-8a65-1a720f5f1835), [SavvyCal poll creator](https://mobbin.com/screens/11935b82-cccc-47e2-b8b9-6b689a390794), [SavvyCal options](https://mobbin.com/screens/56e3f1d5-4a18-43b7-8ab0-d3cd3fae6cc6), [Zoom availability poll](https://mobbin.com/screens/d4aaf42b-3dde-4291-8208-8ad29786b7c1))

## Flow
1. Organizer proposes slots by clicking a week calendar ("Click the time slots you'd like to propose"), with "Overlay my calendar" to avoid self-conflicts (SavvyCal).
2. Public voting page: "Select all the times you're available to meet"; slot chips show time + vote count ("2:00 PM 👍 2"); timezone selector with live clock ("Eastern Time - US & Canada (11:25pm)").
3. Privacy controls: "Allow others to see who has voted" toggle; "Anyone with this link can vote!" warning (SavvyCal).

## Use when
Scheduling a session around multiple busy faculty BEFORE fixing the slot — panel sessions, committee meetings.

## Avoid when
Confidential faculty availability with an open link — scope the token per person instead of one shared URL.

## Sad paths observed
- Timezone mistakes pre-empted by the live-clock timezone selector.

## Accessibility
Vote counts as text next to slots; selected slots get filled state + count.

## Microcopy worth stealing
"Select all the times you're available to meet" · "Anyone with this link can vote!" · "Allow others to see who has voted"

## Default verdict for our stack
V2-VIABLE — genuinely useful for panel scheduling but a separate sub-feature; nothing in the old app anticipates it. Note for the founder grill: per-person tokened voting, never an open link, for medical faculty.
