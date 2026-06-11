# BY-APP Raw Harvest — Event Creation → Public Event Landing Page

Job-to-be-done: an organizer CREATES an event and gets a public event LANDING PAGE that converts visitors. Covers creation form/wizard, theming, draft→preview→publish→share lifecycle, post-publish management, organizer events list, and public landing anatomy incl. sad-path states.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Out of scope (harvested elsewhere): registration/RSVP form itself, checkout/payment, post-registration confirmation/QR.
Date: 2026-06-11

---

## Luma (web)

### LW1. Flow: "Creating an event" — current single-screen create with live theme preview
- Mobbin URL: https://mobbin.com/flows/70a3e849-a039-482e-a704-c59c6ae1bea2 (28 screens)
- Steps observed:
  1. Organizer Events list empty state: large illustration, "No Upcoming Events — You have no upcoming events. Why not host one?" + "+ Create Event" button. Upcoming/Past segmented toggle top right. Footer link "Host your event with Luma ↗".
  2. Create page is the event page itself, pre-filled with smart defaults: left column = cover image already populated with a generated "Meetup" poster + photo-swap button, and a "Theme: Minimal" card with pencil edit. Right column = calendar selector dropdown ("Personal Calendar"), visibility dropdown top-right ("Public" / "Private" pill with globe/lock icon), giant ghost-text "Event Name" title input, Start/End rows each with date chip ("Mon, Nov 11") + time chip ("14.00"), timezone block ("GMT+08:00 Singapore"), "Add Event Location — Offline location or virtual link" row, "Add Description" row.
  3. "Event Options" group below: Tickets ("Free" + edit pencil), "Require Approval" toggle, Capacity ("Unlimited" + edit pencil). Single full-width "Create Event" CTA.
  4. When a Zoom location is chosen, the location row becomes "Zoom Meeting — Auto-created by Luma" with an X to remove (meeting auto-provisioned, no URL pasting).
  5. After create → lands on manage page: breadcrumb "Personal >", title, "Event Page ↗" button, tabs Overview / Guests / Registration / Blasts / Insights / More. Top action cards: "Invite Guests", "Send a Blast", "Share Event". A mini live preview of the public page with the short URL "lu.ma/bffi7c7z ↗" + "COPY" overlay; social share icon row (Facebook, X, LinkedIn, SMS); "When & Where" card with full Zoom join URL, Meeting ID, Password; "Edit Event" / "Change Photo" buttons; "Invites — Invite subscribers, contacts and past guests via email or SMS." with empty state "No Invites Sent"; Hosts section + "Add Host".
- Problem solved: zero-step event creation — the form IS the page, every field has a default (cover art, theme, time, visibility, free tickets, unlimited capacity), so a valid event is one title away. The page becomes manageable the second it exists.
- Sad paths observed: none in-flow (defaults prevent invalid states; end time auto-set after start).
- Microcopy worth stealing:
  - "No Upcoming Events — You have no upcoming events. Why not host one?"
  - "Add Event Location — Offline location or virtual link"
  - "Zoom Meeting — Auto-created by Luma"
  - "Require Approval" / "Capacity: Unlimited"
- Mobile/a11y notes: one-column stack on the right rail; all options are rows with leading icons, not nested screens.

### LW2. Flow: "Creating an event" — older wizard variant (location/time/access blocks)
- Mobbin URL: https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b (14 screens)
- Steps observed:
  1. Title-first page ("Morning Yoga" as Event Name), then question-styled section headers: "Where is the event taking place?" with segmented control In Person / Zoom / Virtual.
  2. In Person: "Event Location" address autocomplete ("What's the address?"), then an "Instructions" field (example filled: "Knock the door") and inline Google Map preview with pin.
  3. Zoom tab: "Once you link your Zoom account, we can automatically generate Zoom meetings for you." + "Link Zoom Account" button, or manual fields Zoom Meeting URL / ID / Password. Virtual tab: single "Event URL" field.
  4. "When will it happen?" with Single Event / Event Series toggle. Single: date + start/end time + "GMT-07:00 Los Angeles" chip. Event Series: "Session Start Times" list rows (date + time + trash icon), "+ Add Session", "Add Recurring Sessions", "Timezone: Los Angeles — Change", "Set Session Duration".
  5. "Access" section: checkbox "Require Registration Approval — If selected, only approved guests will receive a ticket." (virtual variant says "...will receive a join link.").
  6. "Create Event" → manage page skeleton loads with green toast: "Event created successfully! Taking you to the manage page..."
- Problem solved: physical vs Zoom vs generic-virtual venues are one segmented control with mode-specific fields; recurring events are sessions inside one event (one landing page) instead of cloned events.
- Sad paths observed: none visible.
- Microcopy worth stealing:
  - "Where is the event taking place?" / "When will it happen?"
  - "Instructions" (arrival info field) — example "Knock the door"
  - "Require Registration Approval — If selected, only approved guests will receive a ticket."
  - "Event created successfully! Taking you to the manage page..."
- Related shorter flows: "Create an event series" https://mobbin.com/flows/6e029388-0089-4fa3-bfbf-babcfe629ded and "Create a virtual event" https://mobbin.com/flows/5bf99ab7-97b8-438a-a9e5-1e7a1b15b499 (subsets of the above screens).

### LW3. Flow: "Adding a theme" — live theme/style/font/display picker
- Mobbin URL: https://mobbin.com/flows/05561321-93a6-4d22-afb4-6b93137dac47 (11 screens)
- Steps observed:
  1. From the create page, clicking the "Theme: Minimal" card opens a bottom tray over the page: theme thumbnails in a row — Minimal, Quantum, Warp, Emoji, Confetti, Pattern, Seasonal (with red "NEW" badge).
  2. Below the tray, a control bar of four dropdown steppers: "Color" (e.g. Custom / a tint dot), "Style" (e.g. Halloween), "Font" (e.g. Pearl, Ivy Mode), "Display" (Dark / Light).
  3. Selecting "Seasonal" + Style "Halloween" instantly restyles the ENTIRE page live behind the tray (dark orange textured background, monospace title font). Style submenu shows seasonal options in a popover: Halloween, Autumn, Snow, Matrix (NEW badges) and Polaroid, Champagne, Foliage, Lantern.
  4. "Polaroid" style reframes the cover image as a stacked polaroid with paperclip; Display toggles light/dark variants of the same theme.
- Problem solved: page theming is a four-knob system (theme × color × font × light/dark) with full-page live preview — no separate "customize" screen, no save step shown; the event page restyles as you browse.
- Sad paths observed: none.
- Microcopy worth stealing: control labels "Color / Style / Font / Display"; "NEW" badges to merchandise fresh seasonal styles.
- Mobile/a11y: tray + bottom control bar pattern ports directly to mobile sheets.

### LW4. Flow: "Editing an event" — edit panel over manage page
- Mobbin URL: https://mobbin.com/flows/503f562f-e287-4127-99b0-a38cdaa5fd6c (8 screens)
- Steps observed (also seen inside theme-flow screens):
  1. Manage page Overview shows "Next Session" card ("Tomorrow", time with dual timezone "14:00 - 15:00 GMT-4 / 11:00 - 12:00 GMT-7"), location, and note "The address is shown publicly on the event page." + "Check In Guests" button; "Edit Event" and "Change Photo" buttons under the mini page preview.
  2. "Edit Event" opens a right-side panel (page stays visible behind): "Basic Info" — Name field, Description field with a "Suggest Description" link in its corner; "Page Tinting" — a row of color swatch dots (gray, reds, purples, blues, green, yellows, orange, pink); "Time and Location — Update the time and location of this event series on the Sessions tab."; bottom dark "Update Event" button.
- Problem solved: live event edits happen in a side panel against the real page; series time/location edits are deliberately routed to the Sessions tab so a single edit can't silently fork a series.
- Microcopy worth stealing:
  - "The address is shown publicly on the event page." (privacy expectation-setting)
  - "Suggest Description" (assistive content help inside the field)
  - "Page Tinting"

### LW5. Flows: "Sharing an event" / "Copying event link" — the share moment
- Mobbin URLs: https://mobbin.com/flows/d83ae620-2181-4e0b-9621-a6bce23ccf17 (3 screens), https://mobbin.com/flows/1d427766-01b1-457b-b810-e4e606f9362a (4 screens), https://mobbin.com/flows/a6a8ada0-f39d-49cb-b0ec-5d0d98582612 (2 screens)
- Steps observed:
  1. Manage page "Share Event" card → "Share This Event" modal: icon grid Share (Facebook) / Tweet / Post (LinkedIn) / Email / Share (native) / Text, plus "Share the link:" readonly input with the short URL (https://lu.ma/bffi7c7z) and "Copy" button → button label flips to "Copied!".
  2. Same modal exists on the public event page (guest-side sharing), incl. on a registered guest's view with tracking param visible in the URL ("?tk=8u...") — share links are attributed.
  3. Manage page mini-preview "COPY" overlay → green toast "Event link copied to clipboard."
- Problem solved: one short memorable URL is the atom of distribution; copy is one click from both organizer and guest surfaces; guest shares carry attribution tokens.
- Microcopy worth stealing: "Share This Event"; "Share the link:"; "Copied!"; "Event link copied to clipboard."

### LW6. Screens: Public landing page anatomy
- Mobbin URLs:
  - Full page (registered state): https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820
  - About/Posts/Hosts/map lower half: https://mobbin.com/screens/bb6dbae8-6030-4805-9ea2-51fab393a16f
  - Manager-view banner: https://mobbin.com/screens/29b6c4c9-223c-4d42-a632-cbfdf78de2bb
  - Side-panel quick view from calendar listing: https://mobbin.com/screens/461cef36-f560-495b-af8d-fbdb123078cd, https://mobbin.com/screens/a05c31e8-1757-438c-b3f6-1b32ee56fd81, https://mobbin.com/screens/3e04d46c-2e9a-45c1-bd47-f978909ab7a6
  - Private virtual event page: https://mobbin.com/screens/b520e950-3a01-4bff-994c-dcf66672257b
- Anatomy observed (left rail / right content, two-column):
  - Left rail: square cover art; "Presented by {Calendar}" row with subscribe bell + blurb ("Home of the Ruby community in Singapore..."); "Hosted By" avatar+name list (multiple hosts); "37 Going" + avatar stack + "Elisha Tan, Ryan Teo and 35 others"; quiet footer links "Contact the Host", "Report Event".
  - Right column: "Featured in Singapore >" calendar pill above the H1; title; date row with mini calendar-page icon (month/day stacked) + "Wednesday, November 13" + "6:30 PM - 8:30 PM GMT+8"; venue row with pin icon + venue name + external-link arrow + city; registration card (out of scope); "About Event" rich text; "Location" card with map + address + arrival instructions text under it ("Knock the door").
  - "Posts" section: host posts with "Host" badge + like/comment — the landing page has a feed.
  - Registered state adds a countdown chip in the card header: "Starting in 3h 59m" / "Event starting in — 2d 6h".
  - Manager visiting own page sees inline banner: "You are a manager of this event." + "Manage Event" button (private variant: "You have manage access for this event." + "Manage").
  - Private events show a "Private Event" pill at top of content column.
  - Virtual event (Zoom) page shows "Zoom" as the venue row; join button is time-gated with copy "The join button will be shown when the event is about to start."
- Problem solved: the page sells with social proof (calendar brand, hosts, going-count avatars) above the fold, while logistics (map, instructions) and content (about, posts, agenda) stack below; one page serves guest, registrant, and manager via state swaps.
- Microcopy worth stealing:
  - "Featured in {City}" (borrowed credibility)
  - "{N} Going" + "{Name}, {Name} and {N} others"
  - "You are a manager of this event."
  - "The join button will be shown when the event is about to start."
  - "Contact the Host" / "Report Event"
- Mobile/a11y: two-column collapses naturally (left rail items are cards); countdown is text; date icon is decorative with full text date adjacent.

### LW7. Screens: Landing sad paths & scarcity states
- Mobbin URLs:
  - Limited spots + approval on page: https://mobbin.com/screens/b330d0a0-e5d2-4eb8-885b-8f48c83311e9
  - Sold Out chip on city listing + subscribe: https://mobbin.com/screens/7dbb0d17-e56b-4ed2-8e02-74caafbde1bc
  - "You're Not Going" page state: https://mobbin.com/screens/a5560ae7-54e4-4913-b0a6-38ad869bfb3d
  - Cancel Event (admin) + embed preview: https://mobbin.com/screens/b2ce2fef-2fe4-4210-9d31-bbd0a3c7727e
- Observed:
  1. Scarcity banner stack at top of the registration card on the landing page: "⏳ Limited Spots Remaining — Hurry up and register before the event fills up!" and "Approval Required — Your registration is subject to approval by the host." CTA becomes "Apply to Join" (gray) instead of "Register". Multi-session note: "This is a multi-session event. Please choose the sessions you would like to register for."
  2. Discovery listing cards carry status chips before click-through: red "Sold Out", "Near Capacity", "Going", "Not Going", "Location Unavailable"; city calendar sidebar: "Discover the hottest events in Singapore, and get notified of new events before they sell out." + Subscribe.
  3. Cancelled-registration page state: card flips to "You're Not Going — We hope to see you next time! Changed your mind? You can register again." + toast "You've canceled your registration." (page remains fully functional for re-registering).
  4. Organizer cancel (manage > More tab): "Cancel Event — Cancel and permanently delete this series and all its sessions. This operation cannot be undone. If there are any registered guests, we will notify them that the event has been canceled." + "To cancel specific sessions instead of the whole series, please go to the Sessions tab and remove them from the schedule." + red "Cancel Series" button. Same screen shows an embeddable event-card widget preview: "You can change the width and height attributes above to fit the size of your page. This is what you will see:"
- Problem solved: scarcity/approval are stacked banners on the SAME card (composable states, not separate pages); cancellation promises guest notification in the destructive copy itself; partial cancellation (one session) is offered as the less-destructive alternative inline.
- Microcopy worth stealing:
  - "Limited Spots Remaining — Hurry up and register before the event fills up!"
  - "Approval Required — Your registration is subject to approval by the host." / "Apply to Join"
  - "We hope to see you next time! Changed your mind? You can register again."
  - "If there are any registered guests, we will notify them that the event has been canceled."
  - "...get notified of new events before they sell out."

### LW8. Organizer events list
- Observed within LW1/LW5 flows (same screens): "Events" page with Upcoming | Past segmented toggle; empty state per LW1. Dark-mode variant exists (Settings > Display: System/Light/Dark cards) — flow: https://mobbin.com/flows/dcd30e60-960f-4123-afbd-e968a77351fc
- Problem solved: upcoming vs past is the only top-level split; everything else lives on each event's manage page.

---

## Luma (iOS)

### LI1. Flow: "Creating an event" — sheet-based create with generated covers
- Mobbin URL: https://mobbin.com/flows/08f11f1e-3068-45bd-9cb2-1c386f625901 (25 screens); shorter variant: https://mobbin.com/flows/b920b399-e72e-4699-bfc7-c52b71f34df9 (11 screens)
- Steps observed:
  1. Home: "Your Events" list — each card = cover thumb with role chip ON the artwork ("Going" green, "Invited" purple, "Hosting") + host avatar/name + relative time ("Today, 3.00 PM · 6.00 PM GMT-4") + venue. Another home variant shows relative-time badges in the left gutter: "IN 28M", "IN 21H", "IN 1D", and the next event expanded with inline quick actions: "Get Directions" / "My Ticket" / "Share" and a "YOU ARE INVITED" hero card with "Going" chip.
  2. "+" tab → Create Event sheet: cover auto-filled with abstract generated art (swap icon overlay), "Event Name" ghost field, Start/End rows (native wheel picker inline for date+time), "Choose Location", "Add Description", Options: "Visibility — Public ⌄" and "Capacity — Unlimited ⌄" steppers. Page background tints to match the cover art.
  3. Tapping the avatar/calendar chip at top → "Choose Calendar" sheet: "Choose the calendar of the event. Creating an event in a calendar will allow its admins to manage it." with Personal Calendar checked.
  4. Cover tap → "Add Cover Image" full-screen gallery: search bar ("Search Cover Image..."), themed sections (Crypto, Karaoke, Tech) of pre-made posters incl. "Generative AI Hackathon" art, + "Choose From Library" button.
  5. Location selected → card shows address + "Door code: 0240" line + Apple Maps preview. "Location Instructions" editor sheet placeholder: "Tell guests how to reach you: parking spots, building entry codes, elevator location, or nearby landmarks."
  6. End-time wheel shows the End value in red while it conflicts (11:00 PM red highlight during editing).
  7. "Create Event" → full-screen success: green check, "Event Created!" + event name, date/time with timezone, address, map. Buttons: "View Event Page" (primary) / "Invite Guests". Variant success screen: black check, "Your Event is Created 🎉 — Personalize the event page, spread the word, and start welcoming guests on board!" with "Invite Guests" + "Share Event" buttons and "View Event Page" link.
- Problem solved: mobile create = one sheet with three required taps (name, time, place); cover art is never blank (generated default + curated themed gallery); the success screen IS the share moment with explicit next actions.
- Sad paths observed: time-conflict shown as red value in the picker (inline, non-blocking).
- Microcopy worth stealing:
  - "Tell guests how to reach you: parking spots, building entry codes, elevator location, or nearby landmarks."
  - "Your Event is Created 🎉 — Personalize the event page, spread the word, and start welcoming guests on board!"
  - "Choose the calendar of the event. Creating an event in a calendar will allow its admins to manage it."
  - Role chips: "Hosting / Going / Invited"; time badges "IN 28M".
- Mobile/a11y: wheel pickers inline (no modal stack); role/status communicated by chip text not color alone.

---

## Partiful (web)

### PW1. Flow: "Creating an event" — draft-first modal, page-as-editor
- Mobbin URL: https://mobbin.com/flows/2055aff1-04b5-4ab3-8541-7b63e604fc54 (3 screens); description editing: https://mobbin.com/flows/8a40c526-eb36-4615-bcec-a16d5d32b125
- Steps observed:
  1. "Create an event" modal with subtitle "You can always edit this later!": Event name field; poster auto-set to a themed design (e.g. Olympics "WATCH PARTY" poster) with "✏ Edit poster" pill; "Set a date..." field; single "Place name, address, or link" field (physical OR virtual in one input); one CTA: "SAVE DRAFT". Date and location are NOT required to save.
  2. Landing in the editor = the event page itself, fully inline-editable over the animated themed background: helper bar "Need help getting started? [Browse Templates]"; title; date block; red-NEW row "Can't decide when? Poll your guests →"; "Hosted by (optional) host nickname"; location line; "Unlimited spots" (tap to edit); "+ Cost per person"; "+ Add custom link or text"; "Add a description of your event".
  3. Right rail of editor tools: BACKGROUND / ANIMATION / SETTINGS / PREVIEW (becomes DONE while editing). Right column: poster with "✏ EDIT", "Open Invite ... Turned Off" row, "RSVP Options" card with emoji-set dropdown ("Emojis ▼") previewing the three RSVP buttons I'm Going / Maybe / Can't Go.
  4. Bottom: "Quick actions for hosts" chip row: "Collect Info", "Reminders", "Require Guest Approval", "More".
  5. Autosave badge bottom-right: "✓ SAVED!" (no explicit publish button — the draft is live to link-holders when shared).
  6. Inline editing micro-patterns (seen in editing flow https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b): field hints "Press ENTER to skip ↵" / "Press ENTER to confirm ↵"; capacity field "(Optional) Max Capacity — 10 spots" with inline "Enable Waitlist" toggle popover; custom-field link input with ICON picker (link, info, music, dress code, food icons); "(Optional) Organizer" / "+ Add Cohosts" affordance next to host row.
- Problem solved: zero-commitment creation (name + auto poster = saved draft); every page element is its own inline editor so the organizer styles the real artifact; date can stay TBD and even be crowdsourced via guest poll.
- Sad paths observed: undated drafts are first-class ("TBD" badge on dashboard cards; "Set a date..." persists).
- Microcopy worth stealing:
  - "You can always edit this later!"
  - "Can't decide when? Poll your guests →"
  - "Need help getting started? Browse Templates"
  - "Hosted by (optional) host nickname"
  - "+ Cost per person" / "+ Add custom link or text"
  - "✓ SAVED!"
- Mobile/a11y: keyboard-first inline editing (ENTER to confirm/skip); all editor tools are labeled icon buttons.

### PW2. Flow: "Editing an event" — Event Settings panel (visibility, capacity, waitlist, RSVP machinery)
- Mobbin URL: https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b (13 screens)
- Steps observed:
  1. SETTINGS opens a right panel "Event Settings" with nav: Hosts / RSVPs / Questionnaire / Display + Privacy / Chip In / Auto-Reminders / COVID-19 Safety.
  2. RSVPs tab: "Require Guest Approval — Guests request to 'Get on the list'. Only guests you approve can see event details. ⓘ Not supported with Chip-in or Find a Time" (toggle). "Accept RSVPs — Control whether this event is accepting new RSVPs. ⓘ By default, RSVPs close 2 hours after the event starts" (toggle, on). "Open Invite — Hosts' Mutuals can RSVP to this event from their Partiful homepage" with "Event Audience" dropdown.
  3. Open Invite / Event Audience modal: "Post this event on the Partiful homepage of hosts' Mutuals, without directly inviting them. View your Mutuals ↗" — three radio cards: "All Hosts' Mutuals — Visible to all Mutuals of every host" / "Select Mutuals — Pick which Mutuals have access" / "Turned Off — Only people with the link have access".
  4. "Set Max Capacity — Limit the number of guests (and +1s) who can RSVP 'Going'. ⓘ Not supported with Guest Approval" (value 10 with pencil). Nested under it: "Enable Waitlist — Allow guests to join a waitlist once max capacity is reached & automatically update their RSVP and notify them if spots open" (toggle on).
  5. "Limit +1s — Set how many additional persons each guest may bring" ("Up to 1 ⌄"). "RSVP Button Style — Display emojis or icons on RSVP buttons. ⓘ Not supported with Guest Approval" ("Emojis ⌄"). "Allow Guests to Invite Mutuals — RSVP'd guests can invite Mutuals. Hosts will be able to view and modify statuses of invited guests. ⓘ Not supported when Guest List is hidden" (toggle). Footer: "Want to collect info from your guests? Add a questionnaire".
  6. Hosts tab: "Hosts can edit & manage this event, including adding/removing other cohosts." — creator row "Alex Smith (You) — CREATOR", "+ ADD COHOST" → "Add Cohosts" modal listing past guests with "Past Guest" label + the events shared ("Birthday Bash") + checkboxes → "CONFIRM (1)" → cohost shows as "PENDING".
- Problem solved: link-access vs network-broadcast ("Open Invite") is an explicit audience dial — public/private is replaced by WHO sees it (everyone with link / all mutuals / selected mutuals); incompatible feature combos are declared inline ("Not supported with X") instead of failing later.
- Sad paths observed: feature-conflict notes on almost every toggle; pending cohost state.
- Microcopy worth stealing:
  - "Guests request to 'Get on the list'."
  - "By default, RSVPs close 2 hours after the event starts"
  - "Turned Off — Only people with the link have access"
  - "Enable Waitlist — ...automatically update their RSVP and notify them if spots open"
  - "Not supported with Guest Approval" (inline constraint surfacing)

### PW3. Flow: "Preview an event" — guest-eye view with privacy teasers
- Mobbin URL: https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53 (2 screens); also https://mobbin.com/screens/c1eb313e-ddd8-491a-b820-d377f10d27da
- Steps observed:
  1. PREVIEW switches to exactly what a guest sees: title over animated background, date, dual timezone chips ("BST | BST"), "Hosted by" with crown icon, "🔒 RSVP to see location" (location withheld pre-RSVP), three emoji RSVP buttons.
  2. Bottom card: "🔒 Restricted Access — Only RSVP'd guests can view event activity & see who's going" + "RSVP FOR ACCESS" button — guest list and activity feed are gated teasers.
- Problem solved: preview is a true state-switch, not a screenshot; privacy gates double as conversion mechanics (RSVP to unlock location/guest list).
- Microcopy worth stealing:
  - "RSVP to see location"
  - "Restricted Access — Only RSVP'd guests can view event activity & see who's going" / "RSVP FOR ACCESS"

### PW4. Screens: Published page host rail, calendar, clone/cancel, "Finding a Time"
- Mobbin URLs:
  - Host rail + Going counter: https://mobbin.com/screens/f239caae-1113-4626-ae1f-435334bed2fa
  - Overflow menu (Clone/Cancel): https://mobbin.com/screens/3fee236a-dfe6-4fa7-aee9-50e90d3017af
  - Add-to-calendar menu: https://mobbin.com/screens/ea80ec45-c112-44fe-812d-4e253153cbc1
  - "Finding a Time..." date-poll state: https://mobbin.com/screens/54d65d1e-5de8-4ee7-99b1-d17893e1e90b
- Observed:
  1. Published page (host view) right rail: ✏ EDIT / 📣 TEXT BLAST / circular live counter "2 Going" (updates to 4) / 👤+ INVITE / "..." overflow.
  2. "..." overflow menu: Event Settings / Generate Flyer / Questionnaire / Clone Event / Contact Us / Cancel Event (red, destructive last).
  3. Guest-facing utility icons under the date: calendar icon → menu "Google Calendar / Outlook Calendar / Apple Calendar"; send icon; "..." more.
  4. Capacity as social proof on page: "8/10 spots left", "6/10 spots left", "10/10 spots left" line item with person icon.
  5. "Finding a Time..." page state (date poll live): subtitle "The host will pick one when they're ready!", two candidate date chips ("Friday August 11th" / "Friday August 25th"), RSVP area replaced by a single "RESPOND" button.
  6. Page chrome includes "COVID-19 SAFETY RULES" icon row when enabled; custom link rendered with its icon; description text below.
- Problem solved: post-publish management lives ON the page (host rail) — no separate dashboard required for the core loop (edit, blast, invite, watch count go up); date-polling produces a legitimate intermediate landing-page state instead of a broken "TBD" page.
- Sad paths observed: full event ("10/10 spots left"); destructive "Cancel Event" tucked behind overflow, styled red; "Generate Flyer" suggests offline distribution artifact.
- Microcopy worth stealing:
  - "Finding a Time... The host will pick one when they're ready!"
  - "{n}/{cap} spots left"
  - Menu verbs: "Generate Flyer", "Clone Event", "Text Blast"

### PW5. Screens: Guest List management + Activity feed
- Mobbin URLs: https://mobbin.com/screens/41856487-20b4-4361-b7b4-da8b90fe858c, https://mobbin.com/screens/1de2a000-73a6-444e-9f77-113c4b05e682
- Observed:
  1. "Guest List" panel: search "Find a guest", filter chips with live counts "👍 Going (4) / 🤔 Maybe (0) / 😢 Can't Go (2)", "SORT BY" dropdown (Name / Date Ascending / Date Descending / Status), "Bulk actions" button. Each row: avatar, name, "+1" annotation, editable status dropdown ("👍 Going ⌄"), relative timestamp ("29min ago").
  2. Behind it, the page's "Activity" feed: comment composer ("+ Add a comment" with GIF + image buttons), system entries "Sam (+1) updated their rsvp to Going 👍", "Alex Smith sent a Text Blast 🎉 — Don't forget to bring your own food!" with image, threaded replies.
- Problem solved: the guest list is a host CRM (host can flip a guest's RSVP, bulk-act) while the activity feed keeps the public page alive between publish and event day.
- Microcopy worth stealing: "{Name} (+1) updated their rsvp to Going 👍"; filter chips with counts.
- Related: Mutuals page (network graph behind Open Invite): "~everyone you've ever partied with~" with SHARED EVENTS counts — https://mobbin.com/screens/a04416fd-2ca4-48ad-9185-8fa0e1d2743f

### PW6. Flow: Organizer dashboard / events list
- Mobbin URL: https://mobbin.com/flows/b6920b93-11a4-47a0-9136-ef3b81e576a0 (4 screens)
- Observed:
  1. "Welcome back, Sam! You have 6 upcoming events." Filter tabs: Upcoming / Hosting / Open invite / Attended / All past events.
  2. Event cards = poster thumbnails with overlay badges: date chip top-left ("Today · 4am ET", "Today · 9:30pm CT", or "TBD" for undated drafts), "👑 HOSTING" bottom-right, "..." menu top-right; below: title + "Hosted by {name}" with avatars.
  3. Last tile in the row is a dashed-border "+ NEW EVENT" card (create is always one slot away).
  4. "Mutuals" section below with avatars, "{n} shared events", last event + recency.
- Problem solved: the events list is a poster wall (visual recall) not a table; drafts with no date display honestly as TBD; creation is embedded in the grid.
- Microcopy worth stealing: "Welcome back, {name}! You have {n} upcoming events."; "TBD" badge.

---

## Partiful (iOS)

### PI1. Flow: "Creating an event" — typography picker + Party Genie
- Mobbin URL: https://mobbin.com/flows/732d3782-570a-47cc-9a84-cd991745c03c (7 screens)
- Steps observed:
  1. Home: "Welcome to Partiful, Sam!" + "🧞 Need inspo? Ask the Party Genie" (AI ideation entry point); tabs "Upcoming 0 / Hosting 0 / Open in[vite]"; empty state = single dashed tile with disco-ball art + "+ New event" button.
  2. New Event screen (Cancel / Save top bar): title "Birthday Bash" with a FONT STYLE segmented control directly beneath it — "Classic / Eclectic / Fancy / Simple" (each rendered in its own typeface); illustrated poster; "Set a date..."; "Can't decide when? Poll your guests →"; bottom dock: "Theme (NEW)" / "Effect" / "Settings" round buttons; host row "SL Sam Lee" + "+ Add cohosts".
  3. After save, home card shows poster with date badge "Sat 8/30 · 9pm ET" + "👑 HOSTING".
- Problem solved: the two highest-impact style decisions (title typeface, background theme/effect) are zero-navigation controls on the create screen itself; AI inspiration is a named character ("Party Genie") not a buried feature.
- Microcopy worth stealing: "Need inspo? Ask the Party Genie"; font style names "Classic / Eclectic / Fancy / Simple".

### PI2. Flow: "Inviting a guest" — page pill dock + invite moment
- Mobbin URL: https://mobbin.com/flows/a35cf433-e4cb-487f-9f73-fba032b906e1 (7 screens)
- Steps observed:
  1. Event page (host): full-bleed animated theme (balloons + bubbles), title, poster, "Saturday, Aug 30 / 9:00pm – 12:00am", dual timezone chips "ET (selected) | ICT"; floating pill dock at bottom: Edit / Text Blast / "1 Going" (center counter) / Invite / More.
  2. Invite screen: search, "Phone contacts" + "Filter by event" chips, contact rows with checkbox, footer "1 Selected" + "Next" → returns to page with toast "❤️ Invite sent!" and the center counter now reading "1 Invited".
- Problem solved: invite is SMS-contact-native; the dock's center slot doubles as live scoreboard (Going/Invited), making distribution progress the focal point of the host's view.
- Microcopy worth stealing: "❤️ Invite sent!"; dual-timezone chip pattern (event TZ + viewer TZ).
- Mobile/a11y: dock buttons have text labels under icons; counter is text.

### PI3. Flow: "Enabling cohosts" — cohost via link
- Mobbin URL: https://mobbin.com/flows/db9bbfad-69aa-4fde-adac-abef352eb537 (4 screens)
- Steps observed:
  1. Event Settings (iOS list): General — Manage Hosts / RSVP Options / Questionnaire (On) / Display & Privacy / Photo Album / Chip In (On) / Auto-Reminders (Off) / COVID-19 Safety; Get help — Help Center / Send Feedback / Contact Support.
  2. "Add Cohost Via Link": header note "Anyone with the link can become a host", toggle → reveals URL (https://partiful.com/e/0lznUX...) + "Copy" button + warning "Do not share this link with guests".
- Problem solved: cohost onboarding without accounts/emails — a capability URL with an explicit blast-radius warning.
- Microcopy worth stealing: "Anyone with the link can become a host"; "Do not share this link with guests".

---

## Eventbrite (web)

### EB1. Flow: "Creating an event" — onboarding fork + scratch-vs-AI
- Mobbin URL: https://mobbin.com/flows/3b85f96b-28c4-44eb-b4f6-658c1f971c23 (11 screens); AI variant: https://mobbin.com/flows/f24e6aaf-d4d3-479f-94de-586fb488c4ee (11 screens)
- Steps observed:
  1. First-organizer onboarding: "Let's get to know you first! — Tell us what kind of events you want to host and we'll help make it happen." Chips: "What type of events do you host?" (Comedy, Food & Drink, Music, Community & Culture, Hobbies & Special Interest, Performing & Visual Arts, Parties, More options +); "How many events do you plan to organize in the next year?" dropdown; checkbox "My events are part of a recurring series". Right panel social proof: "DID YOU KNOW... Eventbrite helped 39K hobbies & special interest organizers sell over 4M tickets in 2023" (copy adapts to chip selected).
  2. "How would you like to get started?" two cards: "Create my first event — There's no time like the present - let's go! [Build event]" vs "Discover Eventbrite — Get to know the platform and features first [Explore homepage]".
  3. Returning entry: "Create an event" → modal "How do you want to build your event?" — "Start from scratch — Add all your event details, create new tickets, and set up recurring events" vs "✨ Create my event faster with AI — Answer a few quick questions to generate an event that's ready to publish almost instantly".
  4. AI wizard: "Where is it located?" segmented Venue / Online event / To be announced + location search + map; "How much do you want to charge for tickets? — Our tool can only generate one General Admission ticket for now. You can edit and add more ticket types later." + price input + "My tickets are free" toggle; "What's the capacity for your event? — Event capacity is the total number of tickets you're willing to sell."; "Create event" → loading screen "Thanks for giving us a spin! Give us a moment to build your event…"
  5. Builder ("Build event page" step): left rail = mini event card (title, "Sat, Oct 18, 2025, 10:00 AM", "Draft ⌄" status dropdown, "Preview ↗") + "Steps" checklist: "Build event page — Add all of your event details and let attendees know what to expect" → "Add tickets" → "Publish"; plus collapsed sections Dashboard / Order Options / Payments & tax / Marketing / Manage Attendees.
  6. Page sections in main pane: "Overview — Use this section to provide more details about your event. You can include things to know, venue information, accessibility options—anything that will help people know what to expect." (+); "Good to know" — "Highlights" chips "+ Add Age info / + Add Door Time / + Add Parking info"; "Frequently asked questions — 💡 Events with FAQs have 8% more organic traffic" + "+ Add question"; "Add more sections to your event page (Recommended) — Make your event stand out even more. These sections help attendees find information and answer their questions - which means more ticket sales and less time answering messages." e.g. "Agenda — See examples [Add]". Footer "Save and continue".
- Problem solved: heavyweight creation made legible via a 3-step checklist with persistent draft state; AI path collapses it to 3 questions; optional sections are merchandised with conversion stats ("8% more organic traffic") so organizers self-serve page quality.
- Sad paths observed: "To be announced" is a first-class venue option (TBA events supported at creation).
- Microcopy worth stealing:
  - "Create my event faster with AI — Answer a few quick questions to generate an event that's ready to publish almost instantly"
  - "Events with FAQs have 8% more organic traffic"
  - "...which means more ticket sales and less time answering messages."
  - "Thanks for giving us a spin! Give us a moment to build your event…"
  - "There's no time like the present - let's go!"

### EB2. Flow: "Publishing an event" — review gate + post-publish marketing handoff
- Mobbin URL: https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2 (9 screens)
- Steps observed:
  1. "Add tickets" step: Tickets page with tabs Admission / Add-ons / Promotions / Holds / Settings; ticket rows show status dot + lifecycle copy: "General Admission — ● On Sale · Ends Oct 18, 2025 at 10:00 AM — Sold: 0/5 — $1.00"; "Student — ● Scheduled · Starts after General Admission — Sold: 0/20 — Free" (tickets can chain); "Event capacity ⓘ — 0/25 — Edit capacity"; "Add more tickets ⌄" split button; "Next".
  2. Publish step: "Your event is almost ready to publish — Review your settings and let everyone find your event." Left: preview card (image, title, "October 18 · 10am - October 20 · 12pm EDT", address, "🎟 Free—$1.00", "👥 25", "Preview ↗"); "Organized by" input + note "Adding a name will create an organizer profile after publishing, and this event will appear on the organizer's profile page." Right: "Event type and category — Your type and category help your event appear in more searches." (Type / Category / Subcategory dropdowns); "Tags — Help people discover your event by adding tags related to your event's theme, topic, vibe, location, and more." with removable tag chips + "5/10 tags" counter. CTA "Publish now".
  3. Post-publish → redirected to Marketing section with celebratory banner: "You published an event 🎉 Now, let's sell your first ticket!" Page: "Your event is in 39 days!", event card + "Share ⤴" button, ad upsell "Get 14x more impressions with Eventbrite Ads ⓘ — Promote your Event →", section "Here's how you can sell out your event — Our marketing tools take the guesswork out of event promotion so you can sell more tickets, faster." Steps rail now shows Build ✓ / Add tickets ✓ / Publish ✓ and status dropdown reads "● On Sale".
- Problem solved: publish is a deliberate review gate that front-loads discoverability metadata (category, tags) at the exact moment of maximum motivation; the post-publish destination is distribution, not a dead-end success page.
- Sad paths observed: Draft vs On Sale status dropdown on the event card (lifecycle always visible); scheduled tickets dependent on other tickets selling out.
- Microcopy worth stealing:
  - "Your event is almost ready to publish — Review your settings and let everyone find your event."
  - "Your type and category help your event appear in more searches."
  - "You published an event 🎉 Now, let's sell your first ticket!"
  - "Your event is in 39 days!"
  - Ticket lifecycle: "On Sale · Ends {date}" / "Scheduled · Starts after General Admission"

### EB3. Flow: Organizer home + events list
- Mobbin URLs: within https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2 and https://mobbin.com/flows/e45fde58-390e-48e3-bdcd-d1b40e013c14
- Observed:
  1. Organizer home: "Hey there, Sam"; hero card "Your event is happening in about 1 month" with event row (thumb, "On Sale · Starts May 01, 2025 at 10:00 AM", "8/20 Tickets sold"); "Planner" vertical timeline of dated suggested tasks ("FutureFest 2040 ... is now live! Next, tell subscribers about your event by sending a 'Save the date' email.", "Start selling tickets... Send an email campaign to tell everyone that tickets are now on sale."); "Event phase ⓘ" progress bar with stages labeled "Early bird → Halfway there → Last call"; "Your checklist" below. Right rail: profile card with "Total events / Total followers" counts + "Copy Profile URL".
  2. Events list: search, "List | Calendar" view toggle, "Upcoming events ⌄" filter, "Create Event" button; table columns Event (thumb + date block + address + "Saturday, October 18, 2025 at 10:00 AM WIB") / Sold ("4 / 25" + progress bar) / Gross ("$0.00") / Status ("● On Sale") + kebab; "CSV Export" link; feature banner "Timed Entry is here! 🎉".
- Problem solved: the dashboard sells outcomes (tickets sold, time-to-event, phase) and prescribes the next marketing action on a timeline — an opinionated coach, not a passive list.
- Microcopy worth stealing: "Your event is happening in about 1 month"; phase labels "Early bird / Halfway there / Last call".

### EB4. Screens: Public event page anatomy
- Mobbin URLs:
  - Hero + sticky ticket card + urgency chip: https://mobbin.com/screens/1dde9727-11fc-4a1f-a20d-b238fad01a49, https://mobbin.com/screens/f300cc9d-d6e2-4c31-b243-552ce10df057
  - When/where + map + transport modes: https://mobbin.com/screens/d9b43438-ab86-4c86-adf9-c3ed309f1651
  - Agenda tabs + organizer trust badge: https://mobbin.com/screens/50ebe5d6-11dc-48f3-b51d-d93c7281f4c2, https://mobbin.com/screens/4e0310b8-22bf-46f6-b4a3-1a006417892f
  - Minimal hero ("Featured in collections"): https://mobbin.com/screens/058669b7-2a9e-469b-ae96-d35c6a64ac10
  - Organized-by card + rich overview: https://mobbin.com/screens/f04a0505-3233-4c7e-8439-a615340ef9c9
  - Organizer preview mode: https://mobbin.com/screens/2a7256f2-133e-49cf-8146-a2b9d91cda87
- Anatomy observed:
  1. Hero: cover image centered with soft blurred page background; below it date eyebrow ("Mar 03") then H1 title; heart (like) + share icons aligned right; badges "Just Added!", "ALL AGES", "Featured in 2 collections".
  2. Sticky right ticket card: price range ("$12 – $295") or "RSVP for Free Entry" with quantity stepper + "Free ⓘ"; CTA "Get tickets" / "Reserve a spot"; urgency chip floating above the card: "📣 Ticket sales end soon".
  3. Organizer row under summary: avatar, "By Monroe SF", "2.9k followers", blue "Follow" button; trust badge chip "Lots of repeat customers ✓"; separate "Organized by" card variant with "Follow" + "Contact".
  4. "When and where": two columns — "Date and time" ("Fri, Mar 3, 2023, 5:00 PM – Sat, Mar 4, 2023, 2:00 AM PST", "More options ⌄") and "Location" (venue name + full address, "Show map ⌄ / Hide map ⌃"); expanded map includes "How to get there" with four transport-mode icons (drive / walk / transit / bike).
  5. "About this event": duration chip ("🕘 9 hours") + "📱 Mobile eTicket" chip, then rich description (emoji-bulleted sections observed: Event Overview, Key Themes & Tracks).
  6. "Agenda" section with day tabs ("FRIDAY | SATURDAY | SUNDAY") and time-row entries ("5:00 PM - 12:00 AM (+1 day) — Friday 3/28"); "Good to know — View all >" section.
  7. Organizer "Event preview" mode: top bar "Event preview / Close preview", desktop/mobile toggle icons top-right, and the page rendered inside a phone frame with banner "Need to make some updates? Edit event".
- Problem solved: conversion page with sticky purchase card + urgency + organizer-level trust signals (followers, repeat-customer badge, Follow); logistics answered in-page (transport modes, duration, eTicket format) to remove pre-purchase questions; preview mode renders true mobile output before publish.
- Sad paths observed: "Ticket sales end soon" urgency state; "To be announced" venue supported upstream (EB1); no cancelled/postponed public state surfaced in results.
- Microcopy worth stealing:
  - "Ticket sales end soon"
  - "Lots of repeat customers ✓"
  - "How to get there"
  - "Mobile eTicket" / "9 hours" (expectation chips)
  - "Need to make some updates? Edit event"
- Mobile/a11y: dedicated mobile preview; transport icons paired with the "How to get there" label; date given in full text.

### EB5. Flow: "Creating an organization profile" — host identity behind the page
- Mobbin URL: https://mobbin.com/flows/44c56cc4-3423-49b8-ad0a-6f8addc5910d (10 screens)
- Observed: Organization Settings (Organizer Profile / Team Management / Ticket Fees / Plan Management / App Extensions tabs); "Organizer profiles — Each profile describes a unique organizer and shows all of their events on one page. Having a complete profile can encourage attendees to follow you."; "Add Organizer Profile" → "Organizer profile image — This is the first image attendees will see at the top of your profile. Use a high quality square image." + crop tool; "About the organizer — Let attendees know who is hosting events."; success banner "Organizer profile created successfully."
- Problem solved: organizer identity is a reusable entity feeding the public page's "Organized by" trust block and a follow-able profile page (directly relevant to multi-tenant host identity).
- Microcopy worth stealing: "Having a complete profile can encourage attendees to follow you."; "This is the first image attendees will see at the top of your profile."

---

## COVERAGE NOTE

Queries run (tool · app · query → result):
1. search_flows · web · "Luma creating an event" → HIT (2 creation flows + series + virtual variants)
2. search_flows · web · "Luma customizing event page theme colors" → HIT (Adding a theme; Editing an event; dark mode)
3. search_flows · web · "Luma sharing event page after publishing" → HIT (2 share flows + copy link)
4. search_screens · web · "Luma public event landing page hero date location hosts" → HIT (full anatomy, manager banner, You're-Not-Going state)
5. search_screens · web · "Luma event page sold out waitlist registration closed past event" → PARTIAL HIT (Sold Out listing chips, Limited Spots/Approval banners, admin Cancel Event + embed widget; no dedicated sold-out/past/cancelled PUBLIC page render)
6. search_flows · ios · "Luma creating an event with theme and publish" → HIT (2 iOS creation flows + choose calendar)
7. search_flows · web · "Partiful creating an event party page" → HIT (create modal, home, preview, description)
8. search_flows · web · "Partiful publishing event and sharing invite link with guests" → HIT (Event Settings/RSVPs/Open Invite, cohosts, editing)
9. search_screens · web · "Partiful event page guest list going social proof past event" → HIT (guest list, activity feed, host rail, Finding-a-Time, clone/cancel menu, calendar menu; no past-event recap page)
10. search_flows · ios · "Partiful creating event and sharing" → HIT (create with font styles, invite flow, cohost via link)
11. search_flows · web · "Eventbrite creating an event organizer" → HIT (onboarding, builder, org profile, events list)
12. search_flows · web · "Eventbrite publishing an event" → HIT (tickets step, publish review, AI creation, post-publish marketing)
13. search_screens · web · "Eventbrite public event detail page hero tickets organizer follow map" → HIT (full public anatomy + preview mode)

Could NOT find (not present in returned results — do not assume absent from products):
- A cancelled-event PUBLIC landing page render (any app). Closest: Luma's organizer-side cancel copy promising guest notification (LW7).
- A past-event landing page state / Partiful post-event recap ("memories"/photo album view of a finished event).
- A date-changed notice on the attendee-facing page after the organizer moves the date.
- Luma AI cover generation UI (covers appear auto-generated/curated; no explicit "generate with AI" control observed).
- Explicit "unlisted" visibility option (Luma showed Public/Private only; Partiful's equivalent is the Open Invite audience dial).
- A countdown module on the pre-registration landing page (countdowns observed only inside the registered "You're In" card).
- Duplicate/clone on Luma and Eventbrite (observed only Partiful "Clone Event").
- Other apps (Posh, Splash, Meetup, Dice, Zeffy) did not surface in any result set; no opportunistic harvest possible.

Method note: strict "2 consecutive dry queries per app" was not exhausted — the sweep was bounded by context budget after every planned query returned hits; the gaps above are the prioritized follow-up queries for a second pass (e.g. "Luma cancelled event page", "Partiful past event memories", "Eventbrite postponed event").
