# Pattern: Date/time/timezone entry — compact card, searchable city timezone, multi-day binding

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/d0ccb229-b70a-472e-8daa-ea4622ef3774, https://mobbin.com/screens/20619bf3-a36a-42eb-b6de-3f578b8d8aac), Eventbrite web (https://mobbin.com/screens/16913830-b502-4c52-86dc-d01df6f290ae, https://mobbin.com/screens/a8321be6-f638-4ba8-92c6-68db041b82b8), Calendly web (https://mobbin.com/screens/25f41cac-87cc-4ca8-8dc0-a7c89ce6b1c0), Lex iOS (https://mobbin.com/flows/5df825b8-d319-4ab5-a480-d724ba8ab6f6), Partiful web (https://mobbin.com/flows/e2ff50a1-4c52-40aa-9d5e-7459df74393d)

## Flow
1. One compact card shows the whole answer: "Wed, 7 Jun · 11:00 AM > 12:00 PM" with footer "🌐 GMT-07:00 Los Angeles" (Luma). Clicking a time opens a 30-min-increment scroll dropdown with current value highlighted; end time auto-defaults one hour after start.
2. Timezone is a CITY-NAME typeahead ("new" → "Eastern Time - New York (GMT-04:00)…"), not an offset list — selection by how humans think. Calendly upgrade: the dropdown shows the CURRENT CLOCK TIME in each zone ("Indochina Time (2:32pm)"), eliminating offset math.
3. Multi-day events: one range field "10/18/2025 – 10/20/2025" with time fields CAPTIONED by their day ("Start time — October 18" / "End time — October 20") — kills the which-day-does-this-time-belong-to error (Eventbrite).
4. Display toggles separate truth from presentation: "Display start time. — The start time of your event will be displayed to attendees." / "Display end time." (Eventbrite).
5. Mobile: combined day+time wheel with relative day rows "Sun Aug 31 / Mon Sep 1…" (Lex); end time optional with an "x" to clear.
6. Partiful's picker keeps START/+END as tabs (end optional) and offers "Not sure yet? → TBD".

## Use when
Always — every event product. The dual-timezone display variant (event TZ + viewer TZ chips, seen on Partiful pages) matters whenever audiences are remote.

## Avoid when
Don't hide end time by default for multi-day conferences (attendees plan travel around it). Don't offer TBD if dates gate dependent modules without clear blocking behavior.

## Sad paths observed
- End-before-start: Luma iOS turns the conflicting end value red inline in the picker (non-blocking, fix-in-place).
- Impossible/unvalidated dates deferred to save time (Posh create) — observed anti-pattern; validate lexically at entry.
- Vimeo schedule modal disclosing irreversible consequence before commit: "After you go live, you won't be able to stream from this event again." (https://mobbin.com/screens/78b6cae3-15e7-45d0-b1ee-d4c01ae18d19)

## Accessibility
Full text dates alongside any icon/numeral rendering; time increments keyboard-navigable lists; timezone typeahead is a combobox.

## Default verdict for our stack
RECOMMENDED — multi-day range with day-captioned times is exactly the conference shape; searchable IANA city timezone picker replaces the old app's locked hidden Asia/Kolkata input (timezone immutability was flagged UNFINISHED/undocumented). Keep the old app's battle-tested lexical date validator behind this UI.
