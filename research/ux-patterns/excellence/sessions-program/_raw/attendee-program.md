# Attendee Program / Personal Schedule — Raw Mobbin Harvest

Job: **an attendee BROWSES a conference program/agenda and builds their personal schedule** (agenda browsing, day pickers, track filters, session search, session detail, my schedule, reminders, add-to-calendar, speaker profiles, happening-now states).
Date: 2026-06-11. Source: Mobbin MCP (search_flows + search_screens, ios + web, deep mode). Every entry records only what is visible in returned screens. Sched and Whova are NOT in Mobbin's corpus — nearest-job substitutes harvested instead.

## WWDC (ios) — the canonical conference agenda

1. Sessions list with sticky time-group headers
   - Mobbin: https://mobbin.com/screens/ee3a8dc6-1947-4aaa-8992-c56123eaaad1 and https://mobbin.com/screens/4794ea69-0135-4544-b633-f626859328d8
   - Steps observed: (1) "Schedule" tab in bottom nav → Sessions list. (2) Rows grouped under sticky uppercase headers "TUESDAY, 1:00 AM SGT", "TUESDAY 5:30 AM". (3) Each row: session title, "1:00 – 3:00 AM – Hall 2" (time + venue on one grey line). (4) Star icon at row-right marks a favorite (Apple Design Awards row shows a filled star). (5) Nav-right "Filter" becomes "Filter (On)" when a filter is active; a search bar sits above the list in the filtered screen.
   - Problem solved: scanning a dense multi-day program by time without a separate day picker; visible "Filter (On)" prevents "where did my sessions go" confusion.
   - Sad paths observed: none on these screens.
   - Microcopy worth stealing: "Filter (On)" — filter state in the button label itself; timezone in the group header ("1:00 AM SGT").
   - Mobile/a11y notes: row-level star = one-tap save directly from list, no detail-page detour; timezone declared explicitly for remote attendees.

2. Schedule home with Favorites-first summary
   - Mobbin: https://mobbin.com/screens/bd3a46fa-7ae1-4f44-839a-c758faedf372
   - Steps observed: (1) Schedule landing page sectioned "Favorites" / "Sessions" / "Labs", each with "See All". (2) Favorites section is FIRST. (3) Empty favorites shows inline text instead of hiding the section.
   - Problem solved: my-schedule and full program coexist on one screen; saved items get top billing.
   - Sad paths observed: empty personal agenda — "You have no more favorites coming up today." (note: "no more ... coming up today", time-aware, not a generic "nothing here").
   - Microcopy worth stealing: "You have no more favorites coming up today."
   - Mobile/a11y notes: section-list with See All scales to phone width; no horizontal gestures required.

3. Session detail with venue map + related content
   - Mobbin: https://mobbin.com/screens/6032ac36-cdd9-4204-9e5d-0ab0b4bbbd97
   - Steps observed: (1) Session detail shows a floor-plan map snippet of "Hall 2". (2) Below: "Related Sessions" list (title + time + hall). (3) "Related Labs" list with a "Lab" badge per row distinguishing the session type. (4) Star + share icons in the nav bar.
   - Problem solved: dead-end avoidance — after reading one session, the attendee is routed to adjacent content; type badges disambiguate mixed program formats.
   - Sad paths observed: none.
   - Microcopy: section labels "Related Sessions" / "Related Labs".
   - Mobile/a11y notes: favorite action lives in the nav bar of the detail page too (save from list OR detail).

## Apple Store / Apple (ios + web) — session browsing & reservation summary

4. "Upcoming" sessions browser with day strip + filter summary line
   - Mobbin (ios): https://mobbin.com/screens/f793066c-c8d8-487c-b3ed-4ed2977f3522 ; (web): https://mobbin.com/screens/baa5b1f1-a8f4-4260-90d4-586e49f58afa
   - Steps observed: (1) Horizontal day strip (single-letter weekday + date, selected day = filled black circle; web shows two full weeks). (2) Under it, a plain-text filter summary: "All Formats, All Topics, All Types, Anytime" with "Filter" control. (3) Sessions grouped under "Today" with location chip "Apple The Grove >". (4) Web rows have a "Details" button per session.
   - Problem solved: the filter summary line makes current filter state legible at all times without opening the filter sheet.
   - Sad paths observed: see entry 5.
   - Microcopy worth stealing: "All Formats, All Topics, All Types, Anytime" (default-state summary reads as a sentence).
   - Mobile/a11y notes: day strip + text summary works at any width; selected-day state is high-contrast.

5. Empty day / no-matches state that keeps the day strip
   - Mobbin: https://mobbin.com/screens/66bc8e13-08ed-40f2-a6e2-e92b3cd47dea
   - Steps observed: (1) "Upcoming" with day strip and "Filter(9)" active. (2) "Today / Happening near you" header retained. (3) Body: apology + redirect copy instead of a blank list.
   - Problem solved: filtered-to-zero dead end; user keeps all controls to recover.
   - Sad paths observed: THIS IS the sad path. Empty result with 9 active filters.
   - Microcopy worth stealing: "Sorry, we couldn't find sessions matching your selection. But there's more to discover here." Also "Filter(9)" — active-filter count in the control.
   - Mobile/a11y notes: empty state does not remove navigation chrome — recovery affordances stay on screen.

6. Reserved-session summary sheet (the "my reservation" page)
   - Mobbin flow "Summary": https://mobbin.com/flows/8e5181ae-f8f6-427d-945a-9cee14e267de
   - Steps observed: (1) "For You" home shows card "You have an upcoming session." + session name, date, "Get Directions" link. (2) Summary page stacks text-link actions: "Add to calendar", "Turn on session notifications", "Attendees: You and 1 guest", "Share details", "Add to Apple Wallet" button. (3) Primary blue button "Cancel reservation". (4) "See other times and locations" link below. (5) Further down: accessibility note, full address + "Get directions ↗", "Spread the word" share, and a "Your Privacy" paragraph about registration data.
   - Problem solved: one screen answers every post-registration question (when/where/how do I remember/how do I bail/can I move it).
   - Sad paths observed: cancellation and rescheduling are first-class ("Cancel reservation", "See other times and locations").
   - Microcopy worth stealing: "Turn on session notifications"; "See other times and locations"; a11y line: "For sessions with amplified sound, hearing loop technology is available on request."
   - Mobile/a11y notes: explicit hearing-loop accessibility disclosure on a session page — directly transferable to medical conferences (CME rooms, hearing assistance).

## Eventbrite (web + ios)

7. Agenda module on event page with day pills
   - Mobbin: https://mobbin.com/screens/4e0310b8-22bf-46f6-b4a3-1a006417892f
   - Steps observed: (1) Event page has "Agenda" section. (2) Day pills "FRIDAY / SATURDAY / SUNDAY", selected = filled blue pill. (3) Time-slot row "5:00 PM - 12:00 AM (+1 day)" with slot title. (4) "Good to know" section with "View all >" below.
   - Problem solved: multi-day program embedded in a public event page (the "public program page" case).
   - Sad paths observed: cross-midnight slot rendered as "(+1 day)" — overnight-session edge case handled in copy.
   - Microcopy worth stealing: "(+1 day)" suffix for sessions crossing midnight.
   - Mobile/a11y notes: pills + stacked rows; nothing relies on hover.

8. Agenda builder onboarding ("How to use agendas")
   - Mobbin: https://mobbin.com/screens/845d5720-6f70-4f3f-acff-ec64ee7b7344 ; agenda editor: https://mobbin.com/screens/33f1830d-f4e4-4dd5-8a1c-3e926708f3d7
   - Steps observed: (1) Modal "How to use agendas" headline "Add days to your agenda for conferences, festivals, and more" with live preview: day tabs (Wednesday 08 / Thursday 09 / Friday 10), session cards with time range, speaker chip (avatar + name), description with "View more". (2) Editor shows agenda slots: "19:00 Check-in", "19:15 Welcome and introduction", "19:30 - 20:30 Flow yoga class..." each with speaker avatar-chips, "+ Add slot".
   - Problem solved: canonical anatomy of a session card — time range, title, speaker chips, truncated description with View more.
   - Sad paths observed: none.
   - Microcopy worth stealing: "Add days to your agenda for conferences, festivals, and more."
   - Mobile/a11y notes: speaker chips are avatar + full name — readable, not icon-only.

9. Event page urgency + ticket states
   - Mobbin: https://mobbin.com/screens/541607d7-9eb4-4c68-98a6-40136b884128 (Few tickets left), https://mobbin.com/screens/db221985-9d0b-484e-95e6-60324f3650a2 and https://mobbin.com/screens/984e7056-200d-44b3-a4f9-8f17ea8db595 (When and where / Reserve a spot)
   - Steps observed: (1) "🔥 Few tickets left" badge above the title. (2) Sticky right card: price ("Free") + "Get tickets" / "Reserve a spot" CTA. (3) "When and where" block: Date-and-time and Location as two labeled columns. (4) Long description embeds "SPEAKER – JULIE BONZON" header + bio paragraph inline.
   - Problem solved: scarcity signal pre-registration; persistent CTA while reading a long program description.
   - Sad paths observed: scarcity ("Few tickets left") as a soft sold-out precursor.
   - Microcopy worth stealing: "Few tickets left"; "Reserve a spot".
   - Mobile/a11y notes: ios ticket screen (https://mobbin.com/screens/67349385-9b73-48fa-a15c-5bbc3542459a) shows "Add to calendar" link directly under date on the ticket + "Save ticket as image" — offline fallback.

## Luma (ios + web)

10. Registered-state event page ("You're In")
    - Mobbin (web): https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820 ; (ios registered): https://mobbin.com/screens/8b8007a9-32f7-42bd-998e-6750e39df752
    - Steps observed (web): (1) After registering, top card flips to "You're In" + "A confirmation email has been sent to <email>." (2) Countdown pill top-right of card: "Starting in 3h 59m". (3) Actions row: "Add to Calendar" + "Invite a Friend". (4) Below: "No longer able to attend? Notify the host by canceling your registration." (5) "Get Ready for the Event — Profile Complete · Reminder: Email" checklist row. (6) Hosts list with avatars; "37 Going" with avatar stack "Elisha Tan, Ryan Teo and 35 others". iOS: header chip "Registered ▾" + "My Ticket" + "Share"; sections "Hosts", "Guests".
    - Problem solved: post-registration page restates state, countdown, calendar export, and the polite exit path in one card.
    - Sad paths observed: de-registration is surfaced as a sentence, not buried ("No longer able to attend? ...").
    - Microcopy worth stealing: "You're In"; "Starting in 3h 59m"; "No longer able to attend? Notify the host by canceling your registration."; "Get Ready for the Event".
    - Mobile/a11y notes: registration state lives in a persistent chip ("Registered ▾") that doubles as the menu to change it.

11. Gated location + long-press calendar shortcut
    - Mobbin: https://mobbin.com/screens/d9ac5220-95a9-4005-8d61-06b08c344e0a and https://mobbin.com/screens/efb73ae4-ea18-4733-a50d-08c2846731f5 (Register to See Address/Location), https://mobbin.com/screens/e230802c-4e4e-4480-b8ff-cf996e0c4845 (context menu)
    - Steps observed: (1) Unregistered event page shows "Register to See Address" / "Register to See Location" where the venue would be, with blurred map. (2) Long-press on an event card opens context menu: "Add to Calendar / Open in Safari / Report Event". (3) Invited state shows host attribution "Jason Smith invited you" and a "Decline Invite" long-press action.
    - Problem solved: registration incentive via info-gating; calendar export reachable without opening the event.
    - Sad paths observed: decline-invite path; report-event escape hatch.
    - Microcopy worth stealing: "Register to See Address".
    - Mobile/a11y notes: context menu duplicates actions that exist on the page — gesture is a shortcut, not the only path.

## Meetup (ios)

12. Full-event state with waitlist
    - Mobbin: https://mobbin.com/screens/b438104a-4a98-49bf-ae6c-752da7f52cee
    - Steps observed: (1) Grey banner across top of event page: "Event is full." (2) Event content remains fully browsable (date, time, venue, group). (3) Under the date: "Times are displayed in your local time zone." + "Add to calendar" link. (4) Sticky bottom bar: left label "Event full", right teal CTA "Join Waitlist".
    - Problem solved: capacity sad path converts to a waitlist signup instead of a dead end; banner + bottom bar repeat the state so it can't be missed.
    - Sad paths observed: THIS IS the sold-out/full pattern. Banner + disabled-feel label + alternate CTA.
    - Microcopy worth stealing: "Event is full." / "Event full" / "Join Waitlist" / "Times are displayed in your local time zone."
    - Mobile/a11y notes: state is announced in two fixed locations (top banner, bottom bar) — survives any scroll position.

## SeatGeek (ios)

13. No-availability empty state with recovery actions
    - Mobbin: https://mobbin.com/screens/714058e6-324f-423a-951a-8719e8dc95e2
    - Steps observed: (1) Event page shows sleeping "zzz" icon. (2) Headline "No Tickets Available on SeatGeek". (3) Subline "Track the event to be notified or give the box office a try." (4) Two buttons: "Track Event" (heart icon) and "Box Office".
    - Problem solved: sold-out terminal state still offers two forward actions (notify-me + offline alternative).
    - Sad paths observed: this is the hard sold-out case.
    - Microcopy worth stealing: "Track the event to be notified or give the box office a try."
    - Mobile/a11y notes: equal-weight side-by-side recovery buttons.

14. Cancellation guarantee education
    - Mobbin: https://mobbin.com/screens/84219d2e-2d00-439f-9970-af7689c72bb7
    - Steps observed: modal "If your event gets canceled, we'll make it right" with checklist (Canceled events protected / Delivered in time / Dedicated customer support / Same seats you ordered or better value) + "Learn more".
    - Problem solved: pre-empts cancellation anxiety at browse time.
    - Microcopy worth stealing: "If your event gets canceled, we'll make it right."

## Clubhouse (ios)

15. Remind-me pill → confirmed state → add-to-cal
    - Mobbin flow: https://mobbin.com/flows/70694b16-0292-4af3-bd5c-692cefacefd7
    - Steps observed: (1) "upcoming events" cards each carry a "🔔 remind me" pill. (2) Tap → pill flips to green "you got it! ✓". (3) The neighbor card now shows the follow-up action "add to cal" — reminder and calendar export are separate, sequential micro-actions.
    - Problem solved: one-tap reminder from the list with visible confirmation; calendar export offered as the escalation.
    - Sad paths observed: none.
    - Microcopy worth stealing: "remind me" → "you got it! ✓"; "add to cal".
    - Mobile/a11y notes: state change happens in place — no toast needed; color + label + icon all change (not color-only).

16. Upcoming-for-you feed with per-row bell + detail sheet share row
    - Mobbin: https://mobbin.com/screens/52ac5188-5a83-42e0-8c0b-49553835f0cd
    - Steps observed: (1) "UPCOMING FOR YOU ▾" feed grouped TODAY / TOMORROW. (2) Each session row: time, title, host avatars row, long description, bell icon right. (3) Bottom sheet for one event: "TOMORROW 6:00 PM" + "Edit" + actions "Share / Tweet / Copy Link / Add to Cal".
    - Problem solved: personal upcoming feed distinct from the full program; share row standardizes distribution.
    - Microcopy: "UPCOMING FOR YOU".

## Insight Timer (ios) — live & countdown badges

17. Live Events hub with LIVE vs countdown badges
    - Mobbin: https://mobbin.com/screens/db3e14f8-31d0-4a36-9387-0fc218f20aac and https://mobbin.com/screens/587ee5e6-a0de-472a-9a7b-68992bbf0894
    - Steps observed: (1) "Live Events" header + "Engage with your favorite teachers for free in real-time, any time." (2) Card thumbnails carry corner badges: red-dot "LIVE" when live, "IN 1 HR 9 MIN" countdown when imminent, "TODAY - 8:00 PM" when later today. (3) Under each card: title, teacher name, "61 attending". (4) Top-right pill "● 1 LIVE NOW"; controls "Date" and "Filters · 20"; CTA "Browse 1.3k Events".
    - Problem solved: one badge slot communicates three temporal states (live / imminent / scheduled) — the happening-now pattern.
    - Sad paths observed: none.
    - Microcopy worth stealing: "IN 1 HR 9 MIN"; "1 LIVE NOW"; "61 attending"; "Filters · 20" (result count inside the filter control).
    - Mobile/a11y notes: badge text carries the state (not color alone); attendee count = social proof for session choice.

## Peanut (ios)

18. LIVE NOW / UPCOMING tabs + SET REMINDER → REMINDER SET
    - Mobbin flow: https://mobbin.com/flows/a52b7377-d8b2-4a0e-a0d0-0597c22e39d9 ; tabs screen: https://mobbin.com/screens/1c6b86fc-8b0d-4599-a575-f74f1a791150
    - Steps observed: (1) Top-level tabs "LIVE NOW ●" (red dot) / "UPCOMING". (2) "Coming soon" cards with bell icons; live cards labeled "Live" with "Preview" and "Join" buttons. (3) Event detail sheet: "Live in 1 day, 4 hours, 53 minutes" under the date; host bio; actions Share / Copy link / Add to cal. (4) Outline CTA "🔔 SET REMINDER" → filled "🔔 REMINDER SET" on same sheet.
    - Problem solved: reminder as the primary CTA for future sessions, with join reserved for live ones; button is its own state indicator.
    - Microcopy worth stealing: "Live in 1 day, 4 hours, 53 minutes"; "SET REMINDER" → "REMINDER SET".
    - Mobile/a11y notes: outline→filled toggle reads as set/unset without relying on color alone (label changes too).

## Peloton / ESPN / Peacock (ios) — schedule chrome worth stealing

19. Peloton schedule: track chips + day strip + LIVE rows + tap-circle to save
    - Mobbin: https://mobbin.com/screens/dea205e1-85f7-4a27-89bf-b0ea6af81816
    - Steps observed: (1) Category chips row (All / Strength / Meditation …) above. (2) Day strip "M 30, T 31, W 1 …" selected day = dark circle. (3) Rows: "3:00 PM  LIVE / 30 min HIIT & Hills Ride / LEANNE HAINSBY · CYCLING" with an empty circle at row-right (tap-to-add affordance). (4) Floating "⚙ FILTER" pill bottom-center.
    - Problem solved: track filter + day picker + live state + one-tap add in a single compact list — the closest analog to "browse program, build my schedule".
    - Microcopy: "LIVE" / "INTERMEDIATE" inline level badge.
    - Mobile/a11y notes: row-right circle is a large tap target; instructor·track line doubles as the track label.

20. ESPN schedule: Live Now / Upcoming / Replay segmented control + filter empty state
    - Mobbin: https://mobbin.com/screens/1b763dfd-ff20-4011-a97c-8cdcc9f26413 ; empty: https://mobbin.com/screens/086a98b1-833b-45a1-8dc0-5b7d099fda1f
    - Steps observed: (1) Segments "Live Now / Upcoming / Replay". (2) Stacked dropdown filters "All Sports", "All Networks", league sub-dropdowns; time + matchup rows grouped by league. (3) Empty filtered state keeps date strip and prints recovery copy.
    - Problem solved: temporal segmentation (now/future/past) as the top-level switch; faceted filtering below.
    - Sad paths observed: "There are currently no upcoming events for this selection. Please check live now or replay or clear all filters."
    - Microcopy worth stealing: that empty-state recovery sentence (points to 3 exits).

21. Peacock Olympics schedule: date tabs + sport filter chip + Replay badges
    - Mobbin: https://mobbin.com/screens/f015d9ed-304e-4a96-91c2-879af3cb3f4c
    - Steps observed: (1) Date tab strip "WED 18/02 … MON 23/02" with underline on selected. (2) "Filter by sport" input shown as a chip with ✕ clear ("Hockey"). (3) Past sessions carry "Replay" corner badges.
    - Problem solved: filter-as-removable-chip keeps the active query visible; replay badge marks past content as still valuable.
    - Microcopy: "Filter by sport"; "Replay".

## Unity (web) — webinar/program hub

22. Sessions hub: registration-state tabs, list/grid toggle, faceted filters, expandable rows
    - Mobbin: https://mobbin.com/screens/0d59fbdc-b2d3-4530-bced-188f1d5a4881 and https://mobbin.com/screens/feacd322-bdc8-4a73-b81b-d141fdb4f4f3
    - Steps observed: (1) Tabs "Open for registration" / "Previously recorded". (2) Toolbar: list/grid view toggle, Search field, dropdown facets "Industry / Topic / Time of day". (3) List rows: date block (MAR 27), time + timezone "11:00 pm - 12:00 am (1 Day Later) WIB", track tags ("UI & Localization"), title, collapsed description with chevron expand. (4) Expanded row reveals full description incl. "Who should attend:" bullet list and "Associated tutorial:" link. (5) Card view shows "Learn More" + "Register" per card; a one-card grid (sparse state) is shown as-is.
    - Problem solved: the public web program page — search + facets + temporal tabs + in-place expansion (no detail-page round trip).
    - Sad paths observed: sparse content (single card) rendered without filler; "(1 Day Later)" cross-midnight notation.
    - Microcopy worth stealing: "Open for registration" / "Previously recorded"; "Who should attend:".
    - Mobile/a11y notes: expand-in-place keeps list position; explicit local timezone label (WIB).

## Front Academy (web)

23. Recurring session detail with "More Sessions" rail
    - Mobbin: https://mobbin.com/screens/9c36ddbe-c23d-40e5-914f-f6f79d04358c
    - Steps observed: (1) Session page "Front Office Hours" with date block (3 APRIL 2024), time + tz "1:00 PM - 2:00 PM PDT", join URL, "Register" button, "About This Event" text. (2) Right rail "More Sessions": list of future dates (April 10 / 17 / 24 / May 1) each a clickable row. (3) Type label top-right: "ZOOM WEBINAR EVENT".
    - Problem solved: recurring-session navigation — pick another occurrence without leaving the page (cf. Apple's "See other times and locations").
    - Microcopy: "More Sessions".

## DICE (ios) — lineup browsing & save

24. Save-heart on every listing + time-scoped browse + artist dates
    - Mobbin: https://mobbin.com/screens/3e633d5d-94b6-41ff-a7c3-b78ebe88fa64 (This week), https://mobbin.com/screens/c891468a-a9d6-4596-98aa-7d3e2825dfbf (artist page), https://mobbin.com/screens/05371e1c-7b9e-4c88-af7f-107b666f73d8 (home), https://mobbin.com/screens/37b671fd-dc10-42c6-9db0-4e1d0d2ecf6d (event detail)
    - Steps observed: (1) "This week" list, subtitle "Happening in the next 7 days.", rows = thumbnail, title, "Fri, May 17" (date in yellow), venue + city, price, heart icon right; "DATE ⇅" sort toggle top-right. (2) Artist page lists that artist's upcoming dates each with its own heart + "Similar events" grid below. (3) Home: "New Shows Thursday — Just announced. Updated every Thursday." module. (4) Event detail: lineup poster, "Fri, May 17 at 5:00 PM EDT" (accent color), venue, tags "DJ / New York", "Invite friends" row, sticky bottom bar "Free | BUY NOW".
    - Problem solved: save-from-anywhere (list, artist page, detail) with one consistent heart; time-scoped shelves ("This week") replace a calendar UI for casual browsing.
    - Sad paths observed: none on these screens.
    - Microcopy worth stealing: "Happening in the next 7 days."; "Just announced. Updated every Thursday."
    - Mobile/a11y notes: date rendered in accent color = fastest-scanned token on the row.

25. Group "Want to go?" social schedule
    - Mobbin: https://mobbin.com/screens/75815b84-395c-494b-9b3e-274b855109e1
    - Steps observed: saved event card inside a 2-member group: "Added by You", member avatar with count, outline pill "✓ WANT TO GO?", helper text "Use the ❤️ button on an event page to add it to a group", "FIND MORE" button.
    - Problem solved: shared schedule-building between attendees (transferable to colleague groups at a conference).
    - Microcopy: "WANT TO GO?"; "Added by You".

## Zomato (ios)

26. Artist schedule with day pills
    - Mobbin: https://mobbin.com/screens/8e8818d3-fead-4e24-b0ae-0fce398d6af2 and https://mobbin.com/screens/627664c4-3f7a-4bfd-b95c-ad9ac18eeef0
    - Steps observed: (1) "Artist schedule" page, day pills "Sat, 4th Nov" / "Sun, 5th Nov" (selected = black). (2) Rows: photo, artist name, "01:00 PM - 04:00 PM IST". (3) Switching pill swaps the roster.
    - Problem solved: minimal two-day program switcher; timezone suffix on every time.
    - Sad paths observed: none.
    - Mobile/a11y notes: pill day-switcher with full date text (not bare numbers).

## Fixtured (ios)

27. Timeline with now-line and Postponed card state
    - Mobbin: https://mobbin.com/screens/77c4d66a-e281-4a89-aba0-c117599f7768 (now-line), https://mobbin.com/screens/87d6e07a-eb58-4156-8b5f-3fcbeeab48fb (Postponed)
    - Steps observed: (1) Vertical day-grouped card timeline; a horizontal blue line with a dot sits between "Final" (past, muted cards) and upcoming (vivid cards) — current-time indicator. (2) Past cards labeled "Final"; future cards show start time. (3) A postponed fixture renders as a GREYED card with DASHED border labeled "Postponed", kept in place in the timeline. (4) Overlapping items collapse with a "2 of 2" stack badge.
    - Problem solved: happening-now position marker in a scrolling schedule; postponed/cancelled items stay visible (history is not rewritten) but visually demoted.
    - Sad paths observed: "Postponed" state; overlap stacking ("2 of 2").
    - Microcopy worth stealing: "Postponed" on a dashed ghost card.
    - Mobile/a11y notes: dashed border + grey + label = three redundant cues for the degraded state.

## Uber / GetYourGuide (ios) — cancelled-booking display

28. Cancelled reservation in "My Calendar" + refund sheet
    - Mobbin (Uber): https://mobbin.com/screens/92266535-6b41-4e75-a079-d856bc00b57b ; (GetYourGuide): https://mobbin.com/screens/7b85ebf5-62ed-4a66-9ea9-37ce25ea7047
    - Steps observed (Uber): (1) "My Calendar > Upcoming" still lists the experience with a "Canceled" pill on the thumbnail. (2) Bottom sheet "Reservation cancelled": "Your reservation for <bold name> has been cancelled. Please allow 5-7 days to process your refund in the amount of $38.00." + "Got it". GetYourGuide: confirmation sheet "Your activity has been canceled — You should receive your refund within 7 days." + "OK, got it"; page also shows "Need to make a change?" → "This booking can no longer be canceled or rescheduled."
    - Problem solved: cancelled items remain visible where the user expects them, with badge + explicit consequence copy (refund amount/time).
    - Sad paths observed: cancellation display + the locked state "can no longer be canceled or rescheduled".
    - Microcopy worth stealing: "Please allow 5-7 days to process your refund in the amount of $38.00."; "This booking can no longer be canceled or rescheduled."
    - Mobile/a11y notes: badge on the card AND a sheet — state is announced, not just styled.

## Calendly / TimeTree (ios) — conflict warnings

29. Hard conflict block (Calendly)
    - Mobbin: https://mobbin.com/screens/7a62e2bb-29d4-4817-bf9a-7462a842f68c
    - Steps observed: (1) While placing a one-off meeting over an existing event, a red full-width banner appears: "Sorry, you cannot schedule over a Calendly event." (2) The conflicting block stays visible in the day column behind the attempted slot.
    - Problem solved: conflict surfaced at the moment of action, in context, with the colliding item visible.
    - Microcopy worth stealing: "Sorry, you cannot schedule over a Calendly event."

30. Soft conflict warning (TimeTree)
    - Mobbin: https://mobbin.com/screens/4eadd1df-a0c0-4415-bdec-25d9b3b89dda
    - Steps observed: (1) Creating an event with members: red text "There is a member who is attending another event" above the member list. (2) The conflicted member row carries a green tag "Attending another event" but can still be kept checked — warning, not block.
    - Problem solved: per-person conflict annotation that informs without forbidding — the right model for "this overlaps a session already in your schedule".
    - Microcopy worth stealing: "Attending another event" (per-row tag).

## GroupMe / BFF (ios) — RSVP states & attendee lists

31. RSVP tri-state + attendee tabs with cheerful empty tab
    - Mobbin (GroupMe flow): https://mobbin.com/flows/f58eea04-a2aa-4f15-abca-fd2cf13dabd0 ; (BFF flow): https://mobbin.com/flows/7b0f25fc-4943-469c-9e67-6a3d42de9408 and https://mobbin.com/flows/513884ca-0fca-44f1-b7c8-c5e922b5d084
    - Steps observed: (1) GroupMe event detail: "Add to calendar" link inline next to the time; sticky RSVP bar "👍 I'm in" / "😢 Can't go"; "Attendees" tabs "Going (1) / Not Going (0) / Pending (1)" with counts. (2) Empty "Not Going" tab prints: "Good news! No one has said they aren't going to this event yet." (3) BFF: three RSVP pills "Next time 😢 / Interested 🤚 / I'm going 👍"; choosing one fills it and the count updates live ("7 people are going" → "8 people are going"); "RSVP's" list segmented by the same three states; an "Event chat" section appears after RSVP.
    - Problem solved: RSVP state as segmented attendee lists with counts; positive framing for an empty negative-list.
    - Sad paths observed: empty attendee segment handled with celebratory copy.
    - Microcopy worth stealing: "Good news! No one has said they aren't going to this event yet."; tri-state labels "Next time / Interested / I'm going".

## Fresha (ios) — add-to-calendar destination chooser

32. "Add to calendar — Set yourself a reminder" + provider sheet
    - Mobbin flow: https://mobbin.com/flows/7d56e102-d257-4b1a-a378-27954306f803
    - Steps observed: (1) Confirmed-appointment page lists action rows, first: "Add to calendar / Set yourself a reminder". (2) Tap → sheet "Add to calendar" restating event (date, time, address with thumbnail) + two buttons: "Google calendar" / "Other calendar".
    - Problem solved: calendar export with destination choice (Google vs device/ICS) and a restatement of what's being exported.
    - Microcopy worth stealing: subtitle "Set yourself a reminder" under "Add to calendar"; "Other calendar" as the ICS catch-all.
    - Mobile/a11y notes: sheet repeats event details — user confirms WHAT before WHERE.

33. Open (ios) — session detail + calendar permission + attended state
    - Mobbin flow: https://mobbin.com/flows/586efb2c-a941-4d2f-9b22-03c2d1185ecb
    - Steps observed: (1) Home shows "LIVE, TODAY 8/2" module with countdown "06:12:05" on the live card + "FULL SCHEDULE →" link; past card labeled "Replay - aired on 08/02/2023". (2) Class detail: title, teacher, "Thursday, Aug 3 / 10:00 - 10:20 pm", ghost button "Add to cal", "PRACTICING WITH (19) SEE ALL" avatar row, "WHAT TO BRING" icon row (Yoga Mat / Headphones / Blanket), description "See more +", primary CTA "Attend". (3) Tapping Add to cal triggers iOS dialog: "“Open” Would Like to Access Your Calendar — Authorize your calendar to add class event." Don't Allow / OK. (4) After attending: checkmark in nav, CTA becomes "Invite friends".
    - Problem solved: full session-detail anatomy incl. what-to-bring and co-attendee social proof; OS calendar-permission moment captured.
    - Sad paths observed: calendar permission prompt (deny path exists: "Don't Allow").
    - Microcopy worth stealing: "Authorize your calendar to add class event."; "PRACTICING WITH (19)".
    - Mobile/a11y notes: countdown timer on the live card; permission requested only at the moment of use.

## Speaker profiles (nearest-job: teacher/instructor profiles)

34. Ten Percent Happier — teacher bio + their sessions
    - Mobbin: https://mobbin.com/screens/94804c57-b0ed-435d-99c1-1f25a9608bcb and https://mobbin.com/screens/9d6c2c60-fc38-4bdb-8d2c-46fbfd3f1b96
    - Steps observed: (1) Teacher page: name in nav, long bio text, then "Courses" list — thumbnail + title + "with Joseph Goldstein". (2) Inverse link: course page has "Guided by" block (avatar, name, one-line credential "World-renowned meditation teacher") above the numbered "Sessions" list ("1. Get Started — 5 min · Video & Meditation").
    - Problem solved: bidirectional speaker↔sessions linking; one-line credential under the name.
    - Mobile/a11y notes: numbered session list communicates order/coverage at a glance.

35. Open — speaker profile with Follow + "MORE WITH <name>"
    - Mobbin: https://mobbin.com/screens/79766f0c-63a2-4544-90a9-588095fe8757
    - Steps observed: name, @handle, city, avatar, "Follow +" button, "FOLLOWERS 4821", bio paragraph, "MORE WITH MANOJ / SEE ALL →" list of their sessions with heart-save per row.
    - Problem solved: speaker page doubles as a discovery surface for their other sessions; follow = subscribe to a speaker.
    - Microcopy: "MORE WITH MANOJ".

36. Polywork — speaker/professional profile with content sections
    - Mobbin: https://mobbin.com/screens/3cbc700b-3a54-4e1b-bfce-d8aed99a0a4c
    - Steps observed: bio with "Read more" truncation, stacked section buttons "My Writing / My Media Appearances / My Presentations / My Mentorship Program", availability line "I'm open to advising companies, mentoring, and more.", social icon row.
    - Problem solved: speaker page sections beyond talks (publications, media) — relevant for medical faculty profiles.
    - Microcopy: "I'm open to …" availability statement.

## Bloom (ios) — saved sessions library

37. Bookmarked Sessions list with completion ticks
    - Mobbin flows: https://mobbin.com/flows/ea66ab38-1f51-421f-a70e-e670ba355369 and https://mobbin.com/flows/d50046c2-8284-43f6-930f-a1a1b4e144d0
    - Steps observed: (1) Entry points "Session History" and "Bookmarked Sessions" as two cards. (2) Bookmarked list rows: color thumbnail, title, one-line description, duration "10 min"; completed items show a ✓ instead of the play glyph. (3) Save flow: bookmark icon next to the speaker chips on the session sheet (Watch Session / Audio Mode CTAs).
    - Problem solved: saved vs attended distinction inside the personal library.
    - Mobile/a11y notes: completion ✓ replaces the play icon — single slot, two meanings, both glyph-based.

## Klook / Turo / Swarm / Google Maps (ios) — generic empty-result patterns (supporting evidence)

38. Filter-recovery empty states
    - Mobbin: Klook https://mobbin.com/screens/417304ca-b877-42a3-b628-1e871434c7f9 ; Turo https://mobbin.com/screens/be0bd0df-8337-4721-bbfc-d099c25935aa ; Swarm https://mobbin.com/screens/da0fab26-7010-45c6-b271-5aacdc917b23 ; Google Maps https://mobbin.com/screens/aec57cb0-8e96-4e2d-8981-29f9c7a0120a
    - Steps observed: all four keep the filter/date controls on screen and print headline + recovery hint: "No results found / Try clearing your filters and searching again" (Klook); "No cars found / Try changing your filters, adjusting your dates, or exploring the map" (Turo); "No check-ins found / Try adjusting your date range or search criteria" (Swarm); "No results / To see more results, try adjusting your filters." (Maps).
    - Problem solved: the verb-specific recovery sentence pattern (name the exact controls to change).

## Coverage

Queries run (16 total):
- by-flow (ios, limit 3-4): (1) "browsing a conference event schedule and adding a session to my personal agenda" → Timepage/Open/Clubhouse/Otter; (2) "viewing conference session details with speaker info and bookmarking it" → Apple Store/Waking Up/Bloom; (3) "setting a reminder and adding an upcoming event to calendar" → Fresha/Peanut/Outlook; (4) "RSVP to a meetup event and view attendees" → BFF/GroupMe.
- by-pattern screens (ios, limit 5-6, deep): (5) "conference agenda schedule with day tabs and track filters" → WWDC/Peacock/Peloton/Apple Store/ESPN; (6) "speaker profile page with bio and list of their conference sessions" → Polywork/Insight Timer/Ten Percent Happier/Headspace/Open; (7) "sold out event session full join waitlist state" → Meetup/SeatGeek (+fintech noise); (8) "music festival lineup schedule timeline by stage and day" → Zomato/Fixtured (+WWDC repeats); (9) "happening now live session badge in event schedule list" → Behance/Insight Timer/Peanut/Stadium Live/Tiimo; (10) "no events found empty state for selected day or search filter" → Swarm/Turo/Klook/Apple Store/ESPN/Google Maps; (11) "schedule conflict warning overlapping events in calendar agenda" → Calendly/TimeTree/Cron/Amie; (12) "event cancelled or postponed notice on event detail page" → Teams/Uber/GetYourGuide/SeatGeek/Eventbrite.
- by-app screens: (13) "Whova or Sched conference event app agenda session list" ios → returned WWDC/Clubhouse/Behance — Whova and Sched NOT in Mobbin corpus; (14) "Luma event page with schedule, registration and add to calendar" ios → 6 Luma screens; (15) "conference program schedule web page with day tabs, tracks and session cards" web → Unity/Eventbrite/Apple; (16) "webinar or talk detail page with speaker bios, date and add to calendar button" web → Front/Eventbrite/Luma; (17) "DICE or Songkick concert listing save event get reminded lineup" ios → 5 DICE screens (Songkick absent).

Dry areas / FIRST-PRINCIPLES CANDIDATES:
1. **Sched / Whova themselves**: absent from Mobbin. WWDC + Apple Store sessions are the best in-corpus stand-ins.
2. **Multi-track grid (time × room matrix)**: no true parallel-track grid surfaced on either platform — everything is a single-column list with track chips/filters. A room-by-time grid for the medical program is a first-principles design.
3. **Schedule-conflict warning inside a personal CONFERENCE agenda**: only calendar-app analogs found (Calendly hard block, TimeTree soft tag). Applying the TimeTree-style soft tag to "add to my schedule" is first-principles assembly.
4. **Speaker DIRECTORY (browsable grid of all conference speakers)**: only individual profile pages surfaced; no directory/index screen. First-principles candidate.
5. **ICS-file specifics**: "Add to cal / Google calendar / Other calendar" choosers observed (Fresha, Clubhouse, Luma, Meetup, Eventbrite ticket), but no explicit "export full personal schedule as ICS" pattern anywhere. First-principles candidate.
6. **Live-session indicator inside a conference agenda specifically**: harvested from fitness/streaming (Insight Timer, Peloton, Peanut, Tiimo "Ends in 1:27:30", Fixtured now-line) — transfer, not direct observation.

Exclusions: Timepage/Otter/Outlook/Cron/Amie (generic calendar tools — only the now-line and conflict evidence kept), Klarna/GoPay/Digg waitlists (non-event), Stadium Live (gamified streams, only "Line Up" CTA noted), Headspace teacher screen (duplicative of Ten Percent Happier), Microsoft Teams cancel-event dialog (organizer-side, out of job), Waking Up course tabs (Sessions/Summary/Teacher/Artwork tab anatomy noted in passing — content course, not conference), Behance schedule (visual reference only).
