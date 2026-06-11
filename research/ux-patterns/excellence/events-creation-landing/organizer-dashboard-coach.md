# Pattern: Organizer dashboard as coach (countdown hero, planner timeline, phase meter, funnel beside the link)

**Surface:** events-creation-landing · **Observed in:** Eventbrite web (https://mobbin.com/flows/3ed7b77f-81f9-4d4e-8d4e-f49d8b70816a, https://mobbin.com/flows/e45fde58-390e-48e3-bdcd-d1b40e013c14), Posh web (https://mobbin.com/flows/2dbf6d84-2c78-4923-9019-b6a43647a55d), Partiful web (https://mobbin.com/flows/b6920b93-11a4-47a0-9136-ef3b81e576a0), Luma web (https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1), Circle web (https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968)

## Flow
1. **Hero answers "when & how am I doing":** "Your event is happening in about 1 month" card with status ("On Sale · Starts May 01…") and progress ("8/20 Tickets sold") (Eventbrite).
2. **Planner timeline prescribes today's action:** dated to-do entries — "FutureFest 2040 … is now live! Next, tell subscribers about your event by sending a 'Save the date' email." (Eventbrite).
3. **Phase meter names the campaign stage:** "Event phase: Early bird → Halfway there → Last call" progress bar (Eventbrite).
4. **Funnel beside the link:** event header shows "● Live — event starts in 2 days", the full URL with copy + QR icons, and KPI cards "Page Visits 16 → Conversions 25% — Page Visits to Orders" (Posh).
5. **List shapes observed:** poster wall with overlay date/TBD chips + "👑 HOSTING" badges + dashed "+ NEW EVENT" tile in-grid (Partiful); date-railed timeline interleaving hosted ("Manage Event →") and attended events (Luma); data table with Sold progress bars ("Sold 2/40") / Gross / Status columns, a status filter where Draft is first-class (Upcoming / Draft / Past / All), row kebab with Copy URL / Copy Event / Delete, List|Calendar toggle + CSV Export (Eventbrite, https://mobbin.com/screens/3a6af7e7-ca6e-4417-aa6f-4759cf97a361); per-occurrence funnel counters in the list itself ("3 RSVPs / 13 Page Visits", series grouped under a "● Live" parent — Posh, https://mobbin.com/screens/3fad44f7-7615-425b-accb-68cd6e60007b); "Upcoming / Past / Drafts" segments and a month-grid calendar view (Circle).
6. Empty state sells the action: "No Upcoming Events — You have no upcoming events. Why not host one?" + Create CTA (Luma).

## Use when
Organizers manage few, high-stakes events (a conference IS one) — coaching beats listing. The table shape wins at high event volume; the poster wall at low volume.

## Avoid when
Don't prescribe marketing actions you can't execute (planner entries must link to real working features). Skip phase meters when there's no ticket-sales arc.

## Sad paths observed
- Undated drafts coexist via TBD chips instead of hiding in a drafts folder (Partiful).
- Zero-state is an invitation, not a blank table (Luma).

## Accessibility
Progress bars carry text fractions ("8/20"); status dots paired with words ("● On Sale"); poster-wall badges are text chips.

## Default verdict for our stack
VIABLE — old app's upcoming/past split with status badges is a fine V1 skeleton; the steals worth taking early are the next-event countdown hero and per-event registration progress ("128/300 registered") on list cards. Planner timeline + phase meter are V2 (depend on communications module maturity).
