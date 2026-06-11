# Pattern: Post-registration card — countdown, calendar, polite exit, action stack

**Surface:** sessions-program / attendee-program · **Observed in:** Luma, Apple Store (refs: [Luma You're-In web](https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820), [Luma ios registered chip](https://mobbin.com/screens/8b8007a9-32f7-42bd-998e-6750e39df752), [Apple reservation summary flow](https://mobbin.com/flows/8e5181ae-f8f6-427d-945a-9cee14e267de))

## Flow
1. After registering, the CTA card flips in place to "You're In" + "A confirmation email has been sent to {email}." with a countdown pill ("Starting in 3h 59m").
2. Action row: "Add to Calendar" + "Invite a Friend"; below, the polite exit as a sentence: "No longer able to attend? Notify the host by canceling your registration."
3. Apple's summary stacks every post-registration question as text-link rows: "Add to calendar" · "Turn on session notifications" · "Attendees: You and 1 guest" · "Share details" · "Add to Apple Wallet" · "Cancel reservation" · "See other times and locations" · directions + accessibility note.
4. iOS: persistent "Registered ▾" chip doubles as the menu to change the state.

## Use when
Any session/event registration confirm — the page becomes the durable answer to "when/where/how do I remember/how do I bail/can I move it".

## Avoid when
Cancel styled as a destructive primary — every observed app keeps it as a calm sentence or a clearly-secondary action.

## Sad paths observed
- De-registration surfaced proactively, not buried.
- "Get Ready for the Event — Profile Complete · Reminder: Email" checklist nudges completion post-commit.

## Accessibility
Countdown is text; actions are labeled rows; state chip is a real control.

## Microcopy worth stealing
"You're In" · "Starting in {countdown}" · "Turn on session notifications" · "No longer able to attend? Notify the host by canceling your registration."

## Default verdict for our stack
RECOMMENDED — shared chassis with the faculty confirm page (speaker-tokened-invite-landing card); attendee-side it applies to session RSVPs/workshop seats if those ship.
