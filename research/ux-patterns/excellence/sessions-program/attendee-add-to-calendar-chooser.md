# Pattern: Add-to-calendar destination chooser with event restatement

**Surface:** sessions-program / attendee-program · **Observed in:** Fresha, Open, Luma, Meetup, GroupMe, Eventbrite (refs: [Fresha chooser flow](https://mobbin.com/flows/7d56e102-d257-4b1a-a378-27954306f803), [Open permission flow](https://mobbin.com/flows/586efb2c-a941-4d2f-9b22-03c2d1185ecb), [Luma long-press menu](https://mobbin.com/screens/e230802c-4e4e-4480-b8ff-cf996e0c4845), [Meetup inline link](https://mobbin.com/screens/b438104a-4a98-49bf-ae6c-752da7f52cee), [Eventbrite ticket](https://mobbin.com/screens/67349385-9b73-48fa-a15c-5bbc3542459a))

## Flow
1. "Add to calendar" action row with intent subtitle: "Set yourself a reminder" (Fresha).
2. Tap → sheet RESTATES the event (date, time, address, thumbnail) before asking where: "Google calendar" / "Other calendar" (the ICS catch-all) — confirm WHAT before WHERE.
3. The action appears wherever the session does: inline next to the time (GroupMe, Meetup), on the ticket (Eventbrite), in a long-press context menu (Luma).
4. iOS permission moment surfaced only at the moment of use, with purpose copy: "Authorize your calendar to add class event." — Don't Allow path exists (Open).

## Use when
Any confirmed commitment — sessions in my-schedule, faculty assignments, registrations.

## Avoid when
Hiding "Other calendar"/ICS behind Google-only — medical faculty live on Outlook/institutional calendars; the catch-all option is mandatory.

## Sad paths observed
- OS calendar-permission denial ("Don't Allow") is a real branch.
- Whole-agenda export ("export my full schedule as ICS") was observed NOWHERE — first-principles candidate.

## Accessibility
Destination buttons are full-width labeled rows; restatement is text.

## Microcopy worth stealing
"Add to calendar — Set yourself a reminder" · "Other calendar" · "Authorize your calendar to add class event."

## Default verdict for our stack
RECOMMENDED — the old app has NO calendar export anywhere in this module (ICS was spec'd for faculty emails and never attempted, blocked by deferred H5). Per-session ICS + Google link is table stakes in every app observed.
