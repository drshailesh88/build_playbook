# BY-FLOW Raw Harvest — Event Creation → Public Event Landing Page

Job-to-be-done: an organizer CREATES an event and gets a public event LANDING PAGE that converts visitors.
Source: Mobbin MCP (search_flows + search_screens, BY-FLOW task-based sweep). Every entry cites a mobbin_url. Only observed patterns recorded.
Out of scope (not recorded): registration/RSVP form itself, checkout/payment, ticket purchase, confirmation/QR.
Date: 2026-06-11

---

## Task 1 — Creating a new event from scratch

### 1a. Posh (web) — "Creating an event" (single-page form + live flyer preview)
- Mobbin URL: https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9
- Steps observed:
  1. Marketing home "create & discover events" → CREATE EVENT.
  2. One dark single-page form. Top segmented toggle "Sell Tickets / RSVP" (monetization mode is the FIRST decision). Title is inline-editable display text, not a boxed field.
  3. Sections stacked: "Short Summary", "Dates" (Start/End rows each with a GMT+7 timezone chip and date+time chips), "Recurring Series" row with Yes/No pill, "Event Details" (Add Description, Location, Venue Name), "Tickets" (Default Ticket) with link "Join a Kickoff Session ›".
  4. Right rail is a permanently visible flyer preview: "Upload your flyer", "Add song from Spotify", "Title Font — Default", "Accent Color", and the single "Create Event" CTA lives in this rail.
  5. Below the fold: "Image Gallery" thumbnails; "Page Settings": toggle "Show on Explore", toggle "Password Protected Event" (with password input, e.g. "cookies4life"), "Enable Event Activity (NEW)" with radios: "Social feed — Organizers and attendees can post, reply, and react in the activity feed." / "Updates only — Only organizers can post updates. Attendees can't comment or react."
  6. After create: series dashboard grouped by month ("January (1)", "February (1)") with per-occurrence stats (0 Tickets Sold / $0.00 Revenue / 0 Page Visits) and buttons "Edit Event", "View Event Page", "Revert To Draft".
- Problem solved: zero-wizard creation — the whole event is one scrolling form with the public artifact (flyer) always visible; you style the page while you fill the data.
- Sad paths observed: "Revert To Draft" exists on a live event (un-publish escape hatch). Inconsistent date states visible mid-edit (End date earlier than Start in one frame) with no visible inline error — validation appears deferred.
- Microcopy worth stealing: "Show on Explore", "Password Protected Event", "Revert To Draft", "Updates only — Attendees can't comment or react."
- Mobile/a11y: form is one column; flyer preview collapses to top on narrow widths (inferred from layout, not verified).

### 1b. Eventbrite (web) — "Creating an event" (intent onboarding → checklist builder)
- Mobbin URL: https://mobbin.com/flows/3b85f96b-28c4-44eb-b4f6-658c1f971c23
- Steps observed:
  1. First-run interview "Let's get to know you first!" — "What type of events do you host? *" (chip select: Comedy, Food & Drink, Music, Community & Culture, Hobbies & Special Interest, Performing & Visual Arts, Parties, "More options +"), "How many events do you plan to organize in the next year? *" dropdown, checkbox "My events are part of a recurring series". Right rail social proof: "DID YOU KNOW... Eventbrite helped 39K hobbies & special interest organizers sell over 4M tickets in 2023".
  2. Fork screen "How would you like to get started?" — card "Create my first event — There's no time like the present - let's go!" (Build event) vs "Discover Eventbrite — Get to know the platform and features first" (Explore homepage).
  3. Builder: left rail shows event mini-card (title, date, "Draft" status pill dropdown) + "Steps" checklist: "Build event page — Add all of your event details and let attendees know what to expect" → "Add tickets" → "Publish".
  4. Page canvas is the actual landing page as editable sections: hero "Upload photos and video", "Event Title — A short and sweet sentence about your event.", "Date and time / Location" (Enter a location, "Hide map"), "Overview — Use this section to provide more details about your event. You can include things to know, venue information, accessibility options—anything that will help people know what to expect."
  5. "Good to know" section: Highlights chips "+ Add Age info / + Add Door Time / + Add Parking info"; "Frequently asked questions — Events with FAQs have 8% more organic traffic" + "+ Add question".
  6. "Add more sections to your event page" (badge "Recommended"): "Make your event stand out even more. These sections help attendees find information and answer their questions - which means more ticket sales and less time answering messages." → "Agenda" row with "See examples" + Add. CTA "Save and continue".
- Problem solved: converts a blank-page problem into a checklist; the editor IS the landing page (WYSIWYG), and every optional section is sold with a conversion stat.
- Sad paths observed: Draft state is explicit in the left rail; steps stay unchecked until done.
- Microcopy worth stealing: "Events with FAQs have 8% more organic traffic", "A short and sweet sentence about your event.", "anything that will help people know what to expect", "more ticket sales and less time answering messages".

### 1c. Microsoft Teams (web) — "Creating an event" (community calendar compose)
- Mobbin URL: https://mobbin.com/flows/86d7359b-1756-4a35-8c3d-ee7fe0a9ce58
- Steps observed: community empty state with quick actions ("Invite people / Create welcome message / Create new event") → "New event" compose: timezone dropdown at top, plan-limit banner "With your current Teams plan, you get up to 60 minutes per meeting with up to 100 participants. Learn more", cover image with edit button, title, date + start/end time + duration chip "1h" + "All day" toggle, "Does not repeat" dropdown, "Add location", "Online event" toggle, rich-text description toolbar → Send.
- After create: event lands in the community feed as a post "You created this meeting" with date block + "Join" button.
- Problem solved: event creation as message composition; the "landing page" is a feed card with a Join CTA.
- Sad paths: plan limits are surfaced at compose time, not at publish failure.

### 1d. Kajabi (web) — "Creating an event" (minimum viable event)
- Mobbin URL: https://mobbin.com/flows/76b2eb45-57b0-479a-b22e-88d594824c80
- Steps observed: Marketing → Events → "Create an event": only Title, "When does this event occur?", Time zone dropdown, "Repeat this event?" toggle → Save. Events list table (All/Upcoming tabs, Search, Date column with timezone "(MDT)", Actions: duplicate + delete icons), empty-state helper "Learn more about Events ↗".
- Problem solved: 3-field create for creators who attach events to funnels later; duplicate is a first-class row action.

### 1e. Locals (iOS) — "Create an event" (paywalled publish + fee transparency)
- Mobbin URL: https://mobbin.com/flows/c91ca78e-3961-43d4-8612-708a73604b9b
- Steps observed:
  1. Sheet "New event": cover with "Edit cover" / "Edit title" buttons, Description field.
  2. Detail rows: "Starts — Tomorrow, 7:00 PM", "Ends", "Price — $5", "Group capacity — 100 people", "Questionnaire — Ask anything when people join".
  3. "Price per participant" modal: preset chips Free / $5 / $10 / $25 / $50 / Other; fee disclosure rows "Stripe processing fee ~4% — Varies by country", "Locals platform fee 9%"; warning "Heads up! Since fees apply, keep them in mind when setting prices and estimating revenue."; "Paid event policy — By creating and publishing a Paid Activity, you confirm that you have read and agreed to be bound by the Creator Terms of Service."
  4. "Questionnaire" modal: "Ask anything when people join. Collect contacts, dietary restrictions, and more." — "Enable questionnaire" toggle, per-question type (Text field), Required, Public flags, "+ Add question".
  5. Privacy: "Who can see — Anyone"; Settings: "Requests approval — Guests request to join you. Only guests you approve can see event details and chat." (toggle ON).
  6. Persistent footer on the compose sheet: "Ready to publish event? — Upgrade to Locals Pro" with yellow "Upgrade" button (publish is the paywall moment).
- Problem solved: price-setting anxiety handled with presets + full fee math before commit.
- Sad paths observed: publishing blocked behind subscription — the event can be fully composed first, paywall hits only at publish.
- Microcopy worth stealing: "Heads up! Since fees apply, keep them in mind when setting prices and estimating revenue.", "Guests request to join you. Only guests you approve can see event details and chat."

### 1f. Discord (iOS) — "Creating a new event" (stepper)
- Mobbin URL: https://mobbin.com/flows/6ac37872-977b-4435-a30e-3e6a7c2e4ee8
- Steps observed: server settings sheet → "Create Event" → "STEP 2 OF 3 — What's your event about? Fill out the details of your event." (Event Topic with clear-x, Start/End date + time fields, Description hint "Tell people a little more about your event. Markdown, new lines, and links are supported."), wheel date picker sheet with Cancel/Save.
- Problem solved: 3-step wizard with explicit progress label; markdown support advertised in the placeholder.

### 1g. Lex (iOS) — "Creating an event" (community event with char limits)
- Mobbin URL: https://mobbin.com/flows/5df825b8-d319-4ab5-a480-d724ba8ab6f6
- Steps observed: map "Explore Nearby" → New Event sheet: location chip "1226 University Dr", title with live char counter ("1"), description with counter ("148"), fields "When? (required)", "Select a Lex group to host with?", "Ticket link?" (external ticketing = link out); "When" picker has two slots (start, optional end with x) and a combined day+time wheel "Sun Aug 31 | 4 | 30 | PM"; Create → event page: full-bleed cover art, title, "Hosted by Sam", "1 queers are going", tear-off date block "Sun Aug 31", "Tomorrow, Aug 31 at 03:00PM - 4:30PM", address, description.
- Problem solved: event page renders instantly from 4 inputs; social proof line ("X are going") appears from the first RSVP.
- Microcopy: "When? (required)", "Ticket link?"

### 1h. Partiful (iOS) — "Creating an organization profile" (org as host container)
- Mobbin URL: https://mobbin.com/flows/cb584971-4dc5-45bd-941e-3abe09447aeb
- Steps observed: profile → "New Org Profile" (name "Party Planning", bio, Add Instagram/Twitter/Snapchat) → org page empty state: "Create your first event to post to your profile" + "+ Create an event"; toast "Switched to Party Planning".
- Problem solved: separates personal vs org hosting identity before the first event exists.

---

## Task 2 — Setting up an event page with cover image and theme

### 2a. Luma (web) — "Adding a theme" (live theming of the create form itself)
- Mobbin URL: https://mobbin.com/flows/05561321-93a6-4d22-afb4-6b93137dac47
- Steps observed:
  1. Create-event card: cover thumbnail, "Theme — Minimal" row with pencil edit.
  2. Bottom sheet theme dock slides up over the page: theme tiles "Minimal / Quantum / Warp / Emoji / Confetti / Pattern / Seasonal (NEW)" — selecting "Seasonal" instantly re-skins the ENTIRE create page (dark amber Halloween background) while the form stays put.
  3. Sub-controls row: "Color — Custom", "Style — Halloween ▾" (flyout grid: Halloween/Autumn/Snow/Matrix all "NEW", Polaroid/Champagne/Foliage/Lantern), "Font — Pearl ▾" (later "Ivy Mode"), "Display — Dark/Light ▾".
  4. Picking "Polaroid" style restyles the cover into a stacked polaroid w/ paperclip; Display flips page chrome light/dark.
- Problem solved: theme browsing is zero-risk and instant — you never leave the form, and the preview is the real page, not a thumbnail.
- Mobile/a11y: theme dock is a draggable bottom sheet (grab handle visible).

### 2b. Luma (web) — "Changing cover photo" (search-first art picker)
- Mobbin URL: https://mobbin.com/flows/199f089b-0833-48ca-8f85-33ae37046b61
- Steps observed: default cover is an auto-generated gradient; "Change Cover Photo" button overlaid bottom-left of the cover → right-side panel with a search field ("yoga"), "Upload" button to the right of search, masonry grid of stock photos → click → cover swaps in place. Form fields below ("Event Name" placeholder "Morning Yoga", section headers as questions: "Where is the event taking place?" with In Person / Zoom / Virtual segmented chips; "When will it happen?").
- Problem solved: nobody ships an ugly placeholder — gradient default is presentable, stock search beats upload friction.
- Microcopy: section headers phrased as questions ("Where is the event taking place?", "When will it happen?").

### 2c. Eventbrite (web) — "Uploading an image" (focus point + multi-crop preview)
- Mobbin URL: https://mobbin.com/flows/2bd6dc91-4972-4950-aae9-38aa4ab93cb7
- Steps observed: "Add images and video" section — "Pro tip: Use photos that set the mood, and avoid distracting text overlays. View examples →"; image strip with "Cover image" star badge on the chosen one, "+" tile to add; constraints printed inline: "Recommended image size: 2160 x 1080px · Maximum file size: 10MB · Supported image files: JPEG, PNG". "Focus Point" modal: draggable crosshair on the photo with coach-mark "Set a focus point — We'll adapt this image for different devices, centering on your focus point."; right column "Preview your image — See how your image looks on different screen sizes. Attendees can expand the image to see the whole thing." with live "Square (1:1)" and "Rectangle (2:1)" crops; Cancel/Save. Separate "Video — Add a video to show your event's vibe. The video will appear with your event images." upload area.
- Problem solved: one upload must serve many surfaces (cards, hero, social) — focus point replaces N manual crops.
- Microcopy worth stealing: "Use photos that set the mood, and avoid distracting text overlays.", "We'll adapt this image for different devices, centering on your focus point."

### 2d. Circle (web) — "Adding event details" (tabbed admin with autosave toasts)
- Mobbin URL: https://mobbin.com/flows/ee6120bf-4cf7-42da-bc1e-3f123208af79
- Steps observed: full-screen event editor with "Draft" pill next to title; tabs "Overview / People / Basic Info / Post Details / Notifications / Advanced"; top-right "Preview ↗" + "Publish". Basic Info: "What is the event?" (Title, "Custom URL (Optional)" auto-slugged "potato-palooza-2023", Space dropdown, Host), "When is the event?" (Date & time (GMT+8) from/to, "Repeats — Does not repeat"), "Where is the event?". Pill toast bottom-center "Event created." then "Changes saved." after each save. Post Details: "Cover (Optional)" image + "Describe your event" rich editor (attachment/video/image/emoji/link icons). People tab: Attendees/Co-hosts tabs, "0 Attendees", "Add attendees", "Download CSV".
- Problem solved: event = structured record + post body; custom URL exposed at creation; save feedback is constant and quiet.

### 2e. Partiful (iOS) — "Creating an event" (title-font + theme + effects as primary identity)
- Mobbin URL: https://mobbin.com/flows/732d3782-570a-47cc-9a84-cd991745c03c
- Steps observed: Home "Welcome to Partiful, Sam!" with "Need inspo? Ask the Party Genie", dashed "+ New event" card → New Event: huge title "Birthday Bash" with font style segmented row directly beneath ("Classic / Eclectic / Fancy / Simple" — each rendered in its own typeface), animated cover illustration with pencil edit, "Set a date...", link "Can't decide when? Poll your guests →" (NEW badge), bottom dock: "Theme (NEW) / Effect / Settings", host row "SL Sam Lee" + "+ Add cohosts". Saved event appears on home with date chip "Sat 8/30 · 9pm ET" and "HOSTING" badge; an event with no date shows chip "TBD".
- Problem solved: identity (name + typography + artwork) before logistics; date can stay TBD and the page still exists and is shareable.
- Microcopy worth stealing: "Can't decide when? Poll your guests →", "Need inspo? Ask the Party Genie".

### 2f. Apple Invites (iOS) — Onboarding (event page modules pitched pre-publish)
- Mobbin URL: https://mobbin.com/flows/01df0da0-994d-45f5-b940-ec632aef7015
- Steps observed: welcome "Received an invitation? Tap the link you were sent to see the event details. / Just got the app? Continue to explore or set up your first event."; event preview scroll shows page modules: "Shared Album — With Shared Albums, guests can view and add their photos to the event." and "Shared Playlist — Share a playlist with all your guests."; footer paywall "Ready to start inviting people? — A subscription is required. — Upgrade to iCloud+". Guest List screen groups: Going (with per-guest free-text notes like "Can't wait", "Happy birthday!"), "MAYBE (1)" ("I'll need to check my calendar, get back to you!"), "NOT GOING (1)" ("I'll make it up to you when I'm back in town!").
- Problem solved: the landing page is modular (album, playlist) and guest RSVPs carry human notes, not just statuses.
- Sad path: viewing/composing is free; the INVITE action is the paywall.

---

## Task 3 — Choosing event date, time and location

### 3a. Partiful (web) — "Adding a date" (TBD as a first-class date)
- Mobbin URL: https://mobbin.com/flows/e2ff50a1-4c52-40aa-9d5e-7459df74393d
- Steps observed: modal "Create an event — You can always edit this later!": title, poster with "Edit poster", "Set a date...", "Place name, address, or link", primary "SAVE DRAFT" (draft is the default verb, not Publish). Date popover: START / "+ END" tabs (end optional), timezone chips "BST GMT+6", month grid with heat-glow on hovered dates, right column scrolling start times (15-min steps, 6:30PM…), and bottom link "Not sure yet? → TBD". Picking renders human format "Saturday, Aug 10 — 7:15pm". Location is one free-text field accepting "Place name, address, or link".
- Problem solved: kills the blocked-on-logistics dropout — TBD date, link-as-location, and draft-first all let the page exist before decisions are made.
- Microcopy worth stealing: "You can always edit this later!", "Not sure yet? → TBD", "Place name, address, or link", "SAVE DRAFT".

### 3b. Luma (web) — "Setting event date & time" (single vs series + arrival instructions)
- Mobbin URL: https://mobbin.com/flows/a95fd9fc-1b56-4908-9d8a-c951aac88156
- Steps observed: location block has an "Instructions" field ("Knock the door") + embedded map with pin; "When will it happen?" with segmented "Single Event / Event Series"; date field opens mini calendar popover; time field opens a 30-min-increment dropdown (selected slot highlighted red); timezone row "GMT-07:00 Los Angeles"; below: "Access — Require Registration Approval — If selected, only approved guests will receive a ticket." checkbox; "» Create Event".
- Problem solved: separates address (public) from arrival instructions (operational); approval gating sits adjacent to schedule, i.e. all gatekeeping in one pass.
- Microcopy worth stealing: "Instructions — Knock the door" (field exists at all), "If selected, only approved guests will receive a ticket."

### 3c. Lex (iOS) — combined day+time wheel (see 1g)
- Mobbin URL: https://mobbin.com/flows/5df825b8-d319-4ab5-a480-d724ba8ab6f6
- Single wheel with rows "Sun Aug 31 / Mon Sep 1 / Tue Sep 2..." + hour/minute/AM-PM columns — relative dates and weekday names instead of a grid; end time optional with "x" to clear.

### 3d. Discord (iOS) — wheel pickers in stepper (see 1f)
- Mobbin URL: https://mobbin.com/flows/6ac37872-977b-4435-a30e-3e6a7c2e4ee8
- Start Date / Start Time / End Date / End Time as four separate fields, each opening a Cancel/Save wheel sheet.

---

## Task 4 — Publishing an event and sharing the link

### 4a. Luma (web) — "Sharing an event" (manage hub with share-first layout)
- Mobbin URL: https://mobbin.com/flows/d83ae620-2181-4e0b-9621-a6bce23ccf17 (also https://mobbin.com/flows/1d427766-01b1-457b-b810-e4e606f9362a)
- Steps observed:
  1. Manage page (breadcrumb "Personal › Tech Meetup", button "Event Page ↗", tabs Overview/Guests/Registration/Blasts/Insights/More). First content row = three equal action cards: "Invite Guests / Send a Blast / Share Event".
  2. "When & Where" card embeds a live miniature of the public event page with the short URL bar "lu.ma/bffi7c7z ↗" + "COPY" button burned into the preview footer; below preview: social icon row (Facebook, X, LinkedIn, chat) labeled "Share Event"; buttons "Edit Event" / "Change Photo".
  3. For the Zoom event, host-only block: "Zoom — https://us05web.zoom.us/j/83652879813?pwd… / Meeting ID 836 5287 9813 / Password z–7227".
  4. "Share This Event" modal: icon grid Share (FB) / Tweet / Post (LinkedIn) / Email / Share / Text + "Share the link:" input with "Copy" → button text flips to "Copied!".
  5. Invites empty state: "Invites — Invite subscribers, contacts and past guests via email or SMS." / "No Invites Sent — You can invite subscribers, contacts and past guests to the event." Later state shows funnel stats "1/2 Invites Accepted · 2 Emails Opened · 0 Declined".
- Problem solved: post-create screen is 100% distribution-oriented; the page preview doubles as the share asset.
- Microcopy worth stealing: "Send a Blast", "Invite subscribers, contacts and past guests via email or SMS.", "Copied!"

### 4b. Circle (web) — "Publishing an event" (publish from any tab + community card render)
- Mobbin URL: https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968
- Steps observed: persistent "Publish" button top-right across all editor tabs while "Draft" pill shows; published event renders in the space feed as "Next event" card: cover, title, date with timezone "Wednesday, Oct 11, 04:00 AM - 06:00 AM PDT", "Add to calendar" link, "Going ▾" dropdown button, truncated description, chips "Starts in 3 days" / "Live Stream" / host "Jane Smith". Full post view shows agenda-style rich description ("What's Cooking?" numbered list) + Like/Comment row.
- Problem solved: publishing = posting; the landing page is simultaneously a feed object with a countdown chip.

### 4c. Cal.com (web) — "Sharing an event" (per-event-type link copy + hidden state)
- Mobbin URL: https://mobbin.com/flows/cef86b70-66eb-4de7-a2c1-93a8f16d06b2
- Steps observed: "Event Types — Create events to share for people to book on your calendar." list; each row: name + slug "/alexsmbn/mbnvolunteer", duration chips (60m/75m/80m/90m + "Repeats up to 12 times"), an on/off toggle, external-open icon, copy-link icon, "…" menu; one row "Secret Meeting" shows a "Hidden" badge with its toggle off; copying fires toast "✓ Link copied! ×". Sidebar: "View public page" / "Copy public page link".
- Problem solved: link sharing without a share modal — copy icons at row level; hidden-but-existing event types visible only to owner.

### 4d. Posh (web) — live event header with link bar (post-publish)
- Mobbin URL: https://mobbin.com/flows/2dbf6d84-2c78-4923-9019-b6a43647a55d (dashboard screens; also seen in https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635)
- Observed: event dashboard header "● Live — event starts in 2 days (+0730)", full URL "https://posh.vip/e/cookie-meetup-taste-trade-chat-2026-1-28-12-30" with copy + QR icons, "View Event Page" button; KPI cards "Total Tickets Sold 5", "Page Visits 16 — From Explore Page: 0% (0)", "Conversions 25% — Page Visits to Orders".
- Problem solved: the share link sits beside its own conversion funnel — visits → orders measured on the landing page itself.

---

## Task 5 — Previewing an event page before publishing

### 5a. Partiful (web) — "Preview an event" (edit chrome vs guest truth)
- Mobbin URL: https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53
- Steps observed:
  1. Host edit view: every block inline-editable ("Hosted by (optional) host nickname", "Unlimited spots", "+ Cost per person", "+ Add custom link or text", "Add a description of your event"), helper banner "Need help getting started? — Browse Templates", "Quick actions for hosts: Collect Info / Reminders / Require Guest Approval / ··· More", right rail "BACKGROUND / ANIMATION / SETTINGS / PREVIEW", bottom-right pill "✓ SAVED!" (autosave).
  2. PREVIEW: same page rendered as a guest — placeholder rows vanish, timezone chips "BST", and an RSVP-gate card appears: "🔒 Restricted Access — Only RSVP'd guests can view event activity & see who's going" + button "RSVP FOR ACCESS"; RSVP emoji row "I'm Going / Maybe / Can't Go".
- Problem solved: preview is the trust check — it reveals exactly what's hidden behind RSVP and which optional rows won't render.
- Sad path: empty optional fields simply don't exist in preview (no "TBD" junk leaks to guests).
- Microcopy worth stealing: "Only RSVP'd guests can view event activity & see who's going", "RSVP FOR ACCESS", "✓ SAVED!"

### 5b. Posh (web) — "View event page" (guest view from organizer context)
- Mobbin URL: https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635
- Steps observed: public page: blurred-cover ambient background, serif title, venue "Orchard Central", "Sat, Jan 31 at 5:30 PM - 8:30 PM (+08)", short pitch, "Samantha and 5 others going" + avatar stack, horizontal series-date chips ("Jan 31 Sat / Feb 28 Sat / Mar 28 Sat / Apr 28 Tue" each with GMT+8 + time, "More Dates"), grey status pill "Ticket sales are closed for this event"; below: referral banner "Turn Invites Into Income — Invite friends, earn $8.00 per order", "About this event" with embedded YouTube video, image gallery; organizer keeps "View your ticket" top-right.
- Problem solved: a closed-sales event page stays informative (dates, who's going, content) instead of erroring.
- Sad path observed (first-class): "Ticket sales are closed for this event" replaces the CTA — page remains a landing page.
- Microcopy worth stealing: "Samantha and 5 others going", "Turn Invites Into Income — Invite friends, earn $8.00 per order".

### 5c. X (web) — "Preview an article" (unpublished-state banner pattern)
- Mobbin URL: https://mobbin.com/flows/2fea1547-ee84-47c4-a6b7-d16534721864
- Observed: editor with "Draft · Last saved just now" + "Preview" / "Publish" buttons; preview renders final layout with dismissible blue banner "Only you can view this unpublished Article." and a "Draft" pill remaining top-right.
- Problem solved (transferable): preview is labeled as private so screenshots can't be mistaken for live.

### 5d. Aboard (web) — draft gating before publish (also Task 6 sad path)
- Mobbin URL: https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c
- Observed: events sidebar section "Drafts"; full-width banner "This event is in draft mode. You need to add cover image, text and location before you can publish it."; "Publish" button rendered pale/disabled until requirements met; cover edit is inline (Cancel/Save on the image); "Last edited: never" → "Last edited: less than a minute ago"; page modules "Locations — No locations / + Add location", "Bookmarks", "Shared photos — Add an album so attendees can upload their own photos to this event."
- Problem solved: publish-readiness is a stated checklist, not a surprise validation error on click.
- Microcopy worth stealing: "You need to add cover image, text and location before you can publish it."

---

## Task 6 — Editing a live event after publishing

### 6a. Luma (web) — "Edit an event" (side-drawer edit over live manage view)
- Mobbin URL: https://mobbin.com/flows/319afbe7-1939-4ada-ae3c-61a3b4d61bf0
- Steps observed: "Edit Event" opens a right drawer over the manage page: "Basic Info" (Name; Description with link "Suggest Description"), "Appearance" (same theme tiles Minimal/Quantum/Warp/Emoji/Confetti + Color/Style/Font "Geist Mono"/Display "Auto" rows — re-theming a LIVE event), "Time" (start/end + "GMT-08:00 Los Angeles"), "Location" (segmented "In Person / Virtual ✓", fields "Join URL", "Zoom Meeting ID", "Zoom Meeting Password"), sticky CTA "↻ Update Event".
- Problem solved: full edit without leaving context; virtual credentials editable post-publish.

### 6b. Partiful (web) — "Editing an event" (inline edit on the live page itself)
- Mobbin URL: https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b
- Steps observed: the live page becomes the form: click "Hosted by" → inline field "(optional) host nickname" + "+ Add Cohosts", hint "Press ENTER to skip ↵"; "(Optional) Max Capacity — 10 spots" inline numeric with "Enable Waitlist" toggle directly under it, hint "Press ENTER to confirm ↵"; "(Optional) Custom Field" accepts a URL and opens an icon picker (link/info/music/food/drink/etc) for the row; right rail DONE. Guest-facing result: "10/10 spots left", clickable custom link row, "COVID-19 SAFETY RULES" chip with mask emoji, description "A birthday party of my daughter". Right rail on live page: "EDIT / TEXT BLAST / 0 Going / INVITE / ···".
- Problem solved: no separate editor — direct manipulation of the artifact guests see; keyboard hints make skip/confirm explicit.
- Microcopy worth stealing: "Press ENTER to skip ↵", "(Optional) Max Capacity", "Enable Waitlist".

### 6c. Posh (web) — "Updating a ticket" (price/qty edit on a live event)
- Mobbin URL: https://mobbin.com/flows/3bf9dab6-9eaf-4dd4-80d9-b134efa9bbe9
- Steps observed: Edit Ticket modal: name "Grab Your Seat!", "QTY 100", "Gross Price $25.00" vs "Display Price $28.49" side by side (fees shown as buyer-facing price), rich-text ticket description ("Secure your seat now! Limited for 100 seats!"), "Ticket Settings — More settings ⚙": toggles "Limit Sales Period", "Limit Ticket Validity" (ON, with date-time range Mon Jan 26 9:45pm – Tue Jan 27 11:45pm), "Limit Purchase Quantity"; "Save changes" / Cancel.
- Problem solved: organizer sees both their take and the buyer's price at edit time.

### 6d. Aboard (web) — "Editing an event" (see 5d; draft-mode editing with publish gate)
- Mobbin URL: https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c

---

## Task 7 — Duplicating a past event / setting up a recurring event

### 7a. Luma (web) — "Duplicating an event" (clone + bulk multi-date clone)
- Mobbin URL: https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb
- Steps observed:
  1. More tab → "Clone Event — Create a new event with the same information as this one. Everything except the guest list and event blasts will be copied over." → button "Clone Event".
  2. "Choose Times" modal: "Starting on — Mon, Dec 9 08.00", "Repeats — Weekly", "Days of the week" letter pills (M selected), "Until / For — 6 weeks" segmented, generated date chips preview (DEC 9 MON, DEC 16 MON, +2, JAN 6 MON, JAN 13 MON), constraint in amber "You can add up to 6 times at once.", CTA "Add 6 Times" (count is live in the button label).
  3. Success sheet "You've Cloned Tech Meetup — We've created 9 new events. You can open each of them below." with a row per new event (Nov 18 Monday 8:00 AM ↗ …).
- Problem solved: recurrence implemented as cloning — each occurrence is an independent event with its own page/guest list; exclusions (guest list, blasts) stated up front.
- Microcopy worth stealing: "Everything except the guest list and event blasts will be copied over.", "You can add up to 6 times at once.", "We've created 9 new events."

### 7b. Luma (web) — "Create an event series" (sessions model)
- Mobbin URL: https://mobbin.com/flows/6e029388-0089-4fa3-bfbf-babcfe629ded
- Observed: "When will it happen?" toggled to "Event Series" → "Session Start Times" editable list (Thu 8 June 11:00 AM, Fri 9 June 11:00 AM, trash per row), "+ Add Session", "⏱ Add Recurring Sessions", "Timezone: Los Angeles — Change", "Set Session Duration". One page serves all sessions.

### 7c. Posh (web) — "Setting up as recurring series" (cadence + inline validation)
- Mobbin URL: https://mobbin.com/flows/e0c4b2e2-d811-4457-8043-dfe07d025331
- Steps observed: "Recurring Series" row flips No→Yes → modal "Recurring Series — Choose the cadence and length of your event series.": "Repeats — Every [1][month]" "On [the 28th day]"; "Ends — ● On [February 4th, 2026] / ○ After [5] occurrences"; red inline error "The end date must be at least one month after the start date."; live plain-English summary below: "Repeats every 1 month on the 28th of the month until February 4th, 2026 (2 events)"; Save/Cancel. Saved state shows under the Dates section: "Repeats every 1 month on the 28th of the month until April 28th, 2026".
- Problem solved: recurrence rules are confirmed in natural language with computed event count BEFORE save; impossible ranges error inline.
- Sad path observed: explicit validation message on impossible end date (verbatim above).

### 7d. Amie (web) — "Duplicating an event" (context-menu duplicate)
- Mobbin URL: https://mobbin.com/flows/97ac1996-cdb7-4a47-900e-9480776ddf39
- Observed: right-click calendar event → menu (color dots row, Mark as done, Make private, Duplicate, Copy, Going/Maybe/Not Going, Delete) → duplicate appears beside original + toast "✓ Created: Schedule medical appointment — 6 Sept 2023, 09:45".

### 7e. Kajabi (web) — duplicate icon as row action (see 1d)
- Mobbin URL: https://mobbin.com/flows/76b2eb45-57b0-479a-b22e-88d594824c80

---

## Task 8 — Cancelling an event as a host / rescheduling

### 8a. Luma (web) — "Canceling an event" (cancel = delete + notify, with custom email)
- Mobbin URLs: https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1 and https://mobbin.com/flows/56954a40-0e2f-49b1-a87a-2a2d22eb69bc
- Steps observed:
  1. More tab bottom, red zone: "Cancel Event — Cancel and permanently delete this event. This operation cannot be undone. If there are any registered guests, we will notify them that the event has been canceled." → red "⊘ Cancel Event".
  2. Modal: ticket icon, "Cancel Event — If you aren't able to host your event, you can cancel and we'll notify your guests." Toggle "Customize Email" reveals Subject (placeholder "Tech Meetup was canceled") + Body ("Add your custom message here."); red CTA "Cancel Event"; red footnote "The event will be permanently deleted."
  3. Series variant: "Cancel and permanently delete this series and all its sessions. … To cancel specific sessions instead of the whole series, please go to the Sessions tab and remove them from the schedule." → "Cancel Series".
  4. After: events list with green toast "✓ Event canceled successfully!" — the event is gone from the list.
- Problem solved: guest notification is the default and customizable at the moment of cancelling; series vs session scoping is explained before the destructive act.
- Sad path: cancellation == permanent deletion (stated twice); no archived page remains (contrast 8b/8d).
- Microcopy worth stealing: "If you aren't able to host your event, you can cancel and we'll notify your guests.", "The event will be permanently deleted.", "To cancel specific sessions instead of the whole series…"

### 8b. WhatsApp (web) — "Canceling an event" (cancelled event stays visible)
- Mobbin URL: https://mobbin.com/flows/8c51c83a-4d16-4da1-8fc2-223785cbdc6d
- Steps observed: event details panel → dialog "Cancel "ASLMobbin Hangout Session" event? — Canceled events cannot be restored" (Close / Cancel event) → post-cancel state: red "Event canceled" tag above the event name, title struck through in the details panel; the chat bubble keeps the event card with footer "Event canceled" and a system line "You canceled ASLMobbin Hangout Session"; date/"Add to calendar"/"Copy link" still rendered.
- Problem solved: the cancelled event's "page" (chat card + detail panel) survives as a struck-through record — guests who open the old link see the cancellation, not a 404.
- Sad path: this IS the sad path made visible; "Canceled events cannot be restored" warns of irreversibility.

### 8c. Peerspace (web) — "Canceling booking" (reason + message + refund math)
- Mobbin URL: https://mobbin.com/flows/834ca9f4-c1b3-4544-b355-896a6243da17
- Steps observed: confirmed booking page (actions: Invite guests / Browse add-ons / Update booking / Cancel booking) → "Cancel Booking" page: "Please review our Cancellation and Refund Policy for more information…"; required dropdown "Tell Peerspace why you are cancelling *" (selected: "My event is cancelled"); required "Write a message to Ashlee *" (placeholder "Unfortunately I need to cancel my event"); "Booking Summary" table with per-line "Refund amount … (100% refund)" and green "Refund amount $30.00"; side card "Very Flexible — If you cancel now, you will receive a full refund."; after: thread message "Jane cancelled this booking. View the cancellation details for more information."
- Problem solved: cancellation cost is computed and shown before confirming; human apology to the counterparty is required, not optional.

### 8d. Cal.com (web) — cancel with reason shared to guests + cancelled page state (screens)
- Mobbin URLs: https://mobbin.com/screens/d7e41388-1eea-4ccd-a246-0a73dd6b3efe, https://mobbin.com/screens/ae2c874a-98e8-4b13-ad9c-9f474a308037, https://mobbin.com/screens/11eb77ba-42ff-4070-9e41-7144f3c2dd0c, https://mobbin.com/screens/24c5e95b-f6d9-45ac-b23f-934949cddb1c
- Observed: cancel form on the booking page: "Reason for cancellation" textarea + caption "ⓘ Cancellation reason will be shared with guests", buttons "Nevermind / Cancel event" ("Nevermind" as the safe verb). Cancelled state page: pink ⊗ icon, H1 "This event is canceled", then a fact sheet — "Reason: There's some technical issue! pls choose another available date.", What, "When" with the full date STRUCK THROUGH ("~~Monday, April 28, 2025 1:00 PM - 2:15 PM (Pacific Daylight Time)~~"), Who (Host badge), original Q&A answers preserved. Bookings list has a dedicated "Cancelled" tab; cancelled rows show struck-through titles; one row shows "Reschedule request sent" as an alternative outcome.
- Problem solved: the dead link problem — the URL keeps resolving to an honest tombstone with the reason; reschedule-request is offered as the non-destructive sibling of cancel.
- Microcopy worth stealing: "Cancellation reason will be shared with guests", "This event is canceled", "Nevermind".

### 8e. GetYourGuide (iOS) — "Rescheduling a booking" (change date keeps the record)
- Mobbin URL: https://mobbin.com/flows/c8c8171e-c986-4bcd-a5a8-18d0e9c36b01
- Steps observed: booking detail has inline "Change date" / "Change time" links under the current values; "Reschedule your booking" screen: month calendar (unavailable dates struck), time selection with pricing rule explained: "When rescheduling to a lower price, you'll get a partial refund. To reschedule to a higher price, cancel and rebook the activity." + "same price" tag on the slot; Confirm → success dialog "Your activity has been rescheduled — …(GYGZG2X6HZV9) has been rescheduled to Saturday, 30 November 2024, 16.00. We've sent you an email confirming the change. — OK, got it".
- Problem solved: reschedule as a single in-place mutation with explicit money rules and email confirmation.

### 8f. Calendly (web) — cancelled + reported state (screen)
- Mobbin URL: https://mobbin.com/screens/4528ab94-a70e-48e3-9964-6ca3dbba041a
- Observed: dialog "The event is canceled and reported — Thank you! Your report helps us learn more about how to prevent unwanted bookings."; the list row behind shows time struck through.
- Problem solved: cancel + abuse-report combined into one outcome message.

### 8g. Discord (web) — single occurrence cancelled inside a live series (screen)
- Mobbin URL: https://mobbin.com/screens/af86f40b-3343-4fb3-ad15-33f973aa151a
- Observed: event card "novel discussion — Repeats every other Saturday" with "Events in series" list: first row "Sat Apr 12th · 10:45 AM" tagged red "Canceled" while later dates remain normal; "View future events" link; Share / "✓ Interested" buttons stay active on the series.
- Problem solved: per-occurrence cancellation without killing the series page.

---

## Task 9 — Inviting people to view an event page (share step only)

### 9a. Apple Invites (iOS) — "Choosing guests" (public link vs one-off unique links)
- Mobbin URL: https://mobbin.com/flows/204698cc-e9f7-494e-9f04-a1455fec9b13
- Steps observed: share sheet on the event ticket preview: section "🔗 Invite with Public Link" (Messages / Mail / Share Link / Copy Link icons) with "Approve Guests" toggle + caption "Send a public link for guests to RSVP. When they accept, they will appear in your guest list."; section "👤 Invite Individuals — Choose a Guest ⊕" + caption "Send a one-off link to a single guest."; iOS contacts permission interstitial "Allow access to 3 contacts? — "Invites" will only have access to contact information for the contacts you selected…"; choosing a contact opens mini-sheet "Sam Lee — Send a unique invitation link." (Messages / Share Link); "Guest List" section below.
- Problem solved: cleanly separates broadcast distribution (public link, optionally approval-gated) from tracked personal invites (unique per-guest links).
- Microcopy worth stealing: "Send a public link for guests to RSVP. When they accept, they will appear in your guest list.", "Send a one-off link to a single guest."

### 9b. Partiful (iOS) — "Inviting a guest" (invite from the event page action dock)
- Mobbin URL: https://mobbin.com/flows/a35cf433-e4cb-487f-9f73-fba032b906e1
- Steps observed: event page bottom dock "Edit / Text Blast / [1 Going] / Invite / More" → Invite screen: search, "Phone contacts" + "Filter by event" chips (re-invite people from past events), checkbox list, "1 Selected" + "Next" → back on page, toast "❤️ Invite sent!" and the dock counter flips from "1 Going" to "1 Invited".
- Problem solved: invitations sourced from past-event attendance, not just the address book; counter reflects pipeline state (invited vs going).

### 9c. Peerspace (iOS) — "Inviting guests" (guest-facing copy decoupled from booking)
- Mobbin URL: https://mobbin.com/flows/04ab413c-0c9e-4d57-9455-02de7258008f
- Steps observed: booking card → "Invite Guests" → compose sheet: "Booking title" (rename for guests: "Alex's Event"), "Edit time shown to guests — Changing the time on your invite will not impact your booking, only what your guests will see." (separate guest-facing time window), "Personal Note" prefilled "Check out the space I booked on Peerspace. Let me know if you can make it!", partner upsell "Anyone traveling to your event? … save you and your guests 10% on hotels and rental cars when you share invites." badge "Just for you", links "I'll do this later" / CTA "Send and preview" → step 2 of 2 full-screen "Your invite is ready to send! — Share your invite or copy the link below. You can edit, access the invite link, and view the RSVP list on your booking details page." → native share sheet with "RSVP — peerspace.app.link" object.
- Problem solved: host buffer-time problem — show guests a different start time than the booking; invite is a separate object with its own title/note.
- Microcopy worth stealing: "Changing the time on your invite will not impact your booking, only what your guests will see.", "Your invite is ready to send!"

### 9d. Luma (web/iOS) — share modal & embed (see 4a; plus embed in More tab)
- Mobbin URLs: https://mobbin.com/flows/d83ae620-2181-4e0b-9621-a6bce23ccf17, https://mobbin.com/flows/c3c2dcc7-b964-4cf1-b000-b4a9c780de92, embed observed in https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb
- Embed Event section: "Have your own site? Embed the event to let visitors know about it." — options "Embed as Button ✓ / Embed Event Page", syntax-highlighted HTML snippet with "Copy", live demo "This gives you the following button. Click it to see it in action!" rendering a real "Register for Event" button, note "If you want to use your own styling for the button, simply remove the luma-checkout—button class from the snippet above."
- Problem solved: the landing page is distributable as a widget; the demo button is functional proof, not a screenshot.

---

## Task 10 — Viewing an event page as a guest (landing/discovery experience)

### 10a. Luma (web) — "Event page detail" (the conversion-page anatomy)
- Mobbin URL: https://mobbin.com/flows/48b7ea19-b9fb-4eee-a174-5d42ab1b67e8 (also https://mobbin.com/flows/a61a3787-8432-4211-be7a-1e63d612f421)
- Steps observed:
  1. From a city/feed list (rows show status chips on events before clicking: "Near Capacity", "Not Going"; entries with hidden venues show "Location Unavailable") a side-panel preview opens with "Copy Link" + "Open Event Page" buttons — the event is previewable without leaving the feed.
  2. Preview panel structure: poster art, globe+video emoji line "🌐🎥 VERCI SUMMER STUDIO", "Hosted by Ami Yoshimura" with avatar, date block "JUN 11 — Sunday, 11 June 12:00 to 19:00 GMT-4", location "SoHo — New York, New York", "Registration" card ("Hello! To join the event, please register below." + identity row + Register button), "About Event" long-form below.
  3. Full page right rail: "Location" card with map + "View larger map", neighborhood "SoHo — New York, NY, USA"; "Hosts" card with avatar + "Contact" and "Donate" buttons.
  4. Post-RSVP, the same page swaps the registration card for status + "Get Ready for the Event" expandable: "Your Profile — Update Profile" and "Configure Reminders — Email / SMS" toggles.
  5. About Event supports rich content: links, blackletter styled text, separators, "Learn more here: …substack…", contact line "If you have any questions, email us at club@verci.com."
- Problem solved: a guest can evaluate (date, venue, host credibility, who's going) within a hover-panel before committing a click, and the page itself transforms state after registration instead of redirecting.
- Sad path observed: events with restricted location show "Location Unavailable" chip in lists.
- Microcopy worth stealing: "Hello! To join the event, please register below.", host-card "Contact" / "Donate".

### 10b. Luma (iOS) — guest home + event page (countdowns and weather)
- Mobbin URL: https://mobbin.com/flows/c3c2dcc7-b964-4cf1-b000-b4a9c780de92
- Observed: "Your Events" list: each card has an urgency chip "IN 11M" / "IN 21H" / "IN 1D", a "✓ Going" badge on the poster, then quick actions "Get Directions / My Ticket / Share". Event page: poster hero, "Registered ▾" dropdown (status is a control, not a label), "My Ticket", "Share"; date card shows "Today — 10:00 AM to 2:45 PM" with a weather forecast "78°" + moon icon; address card with embedded Apple Map; "Hosts" and "Guests" sections below.
- Problem solved: time-proximity (countdown chips) and day-of info (weather, directions) surface exactly when relevant.

### 10c. Partiful (web) — guest list & guest profiles from the landing page
- Mobbin URL: https://mobbin.com/flows/a77ba687-facd-4f2d-a111-edee4c8ebcc3
- Observed: "Guest List" overlay (sortable by Status) rows "Going / Can't Go" with timestamps; clicking a guest opens a profile card: avatar, name, "View profile" link, status control "👍 Going ▾ +0 ▾", "Updated to Going on 8/06 - 1:14pm", their RSVP note ""Yay" — 3 minutes ago", and tabs "Questionnaire / RSVP History" (answer shown: "How old are you? * — 54"); full profile page shows "Shared Events" history between you and that guest ("Birthday Bash — In 4 days").
- Problem solved: who's-going is a social browsing surface — RSVP history and shared-event overlap build trust for strangers' parties.

### 10d. Posh (web) — public landing page with social proof + closed state (see 5b)
- Mobbin URL: https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635

---

## Task 11 — Browsing my events as an organizer

### 11a. Eventbrite (web) — "Organizer home" (next-event countdown + planner timeline)
- Mobbin URLs: https://mobbin.com/flows/3ed7b77f-81f9-4d4e-8d4e-f49d8b70816a and https://mobbin.com/flows/e45fde58-390e-48e3-bdcd-d1b40e013c14
- Steps observed:
  1. Home "Hey there, Sam" → hero card "Your event is happening in about 1 month" with event row (date block MAY 01, thumbnail, "On Sale · Starts May 01, 2025 at 10:00 AM", "8/20 Tickets sold", expand chevron).
  2. "Planner" — a dated to-do timeline: "Sunday Mar 16 — FutureFest 2040… is now live! Next, tell subscribers about your event by sending a "Save the date" email." / "Monday Mar 17 — Start selling tickets… Send an email campaign to tell everyone that tickets are now on sale."
  3. "Event phase" meter with stops "Early bird → Halfway there → Last call"; below "Your checklist".
  4. Right rail profile card: "1 Total events / 1 Total followers", "View · Edit · Copy Profile URL".
  5. Events workspace: tabs Events/Collections, search, "List / Calendar" view toggle, "Upcoming events ▾" filter, feature banner ("Timed Entry is here! 🎉 …"), table columns Event (date block + address + datetime) / Sold ("4 / 25" with progress bar) / Gross ("$0.00") / Status ("● On Sale") / "⋮"; "CSV Export" bottom-left. Educational modules below: "Level up your skills at Eventbrite Academy" course cards, "Community spotlight", "How can we help?" hub.
- Problem solved: dashboard answers "what do I do TODAY for my event" (planner + phase meter), not just "what exists".
- Microcopy worth stealing: "Your event is happening in about 1 month", "Event phase: Early bird / Halfway there / Last call".

### 11b. Posh (web) — "Organization dashboard" (revenue-first, series-grouped)
- Mobbin URL: https://mobbin.com/flows/2dbf6d84-2c78-4923-9019-b6a43647a55d
- Observed: top nav Overview/Marketing/Team/Finance/Profile/Settings. Overview: tickets-this-week area chart (1W/1M/ALL), recent orders list (avatar, "Order #22267021 … $0.00"); "Events" block groups by "Event series:" with "● Live" status + edit/eye icons, each occurrence row shows RSVPs + Page Visits counters; "View All Events". Marketing → "Attendees" CRM table (Name / Tickets / Total Spend / Contact icons (SMS, call) / Tags "+" / Last Purchase / info), note "Marketing SMS blasts are limited within a rolling 30-day period…", "View SMS Campaigns". Settings → Organization: "Contact Email — Your email will be displayed to attendees.", "Contact Phone — This number is for event-related support. This phone number will not be shown to attendees unless they dispute a charge, in which case it will be shared (full digits) to help resolve the issue."
- Problem solved: organizer's home is a business console — attendees become a reusable CRM across events.
- Microcopy worth stealing: the contact-phone disclosure (verbatim above).

### 11c. Partiful (web) — "Welcome back" host dashboard (see 6b flow context)
- Mobbin URL: https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b (screens 1–2)
- Observed: "Welcome back, Sam! — You have 6 upcoming events." Filter tabs "Upcoming / Hosting / Open invite / Attended / All past events"; poster-card grid where each card carries a status chip ("Today · 4am ET", "Today · 9:30pm CT", or "TBD" for date-less events) + "HOSTING" badge + "Hosted by" attribution; "Mutuals" section below.
- Problem solved: events as a poster wall; date-less drafts (TBD) coexist with scheduled ones instead of hiding in a drafts folder.

### 11d. Circle (web) — Upcoming / Past / Drafts tabs in event space
- Mobbin URL: https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968 (also seen in preview flow https://mobbin.com/flows/1b5ce510-e710-4deb-a776-5b0cc6a59524)
- Observed: events space header with "New Event" button; segmented "Upcoming / Past / Drafts"; empty state "No upcoming events" grey bar.

### 11e. Luma (web) — Events timeline with Manage entry points (see 8a step 4)
- Mobbin URL: https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1 (final screen)
- Observed: "Events" page "Upcoming / Past" pills; rows grouped by date rail ("Today Wednesday", "Nov 18 Monday"); attended events show poster + "Going" chip + attendee avatars "+32"; hosted events show "Zoom / No guests" meta + "Manage Event →" button — host vs guest events interleaved in one timeline.

---

## Task 12 — Managing event visibility or unlisting an event

### 12a. Posh (web) — "Show on Explore" + password gate (at create time; see 1a)
- Mobbin URL: https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9
- Observed: Page Settings toggles: "Show on Explore ⓘ" (discovery listing opt-in/out = unlisted-but-linkable when off) and "Password Protected Event ⓘ" with inline password field — two independent layers: discoverability and access.

### 12b. Circle (web) — Advanced tab visibility toggles (see 4b/5 context)
- Mobbin URL: https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968 (Advanced screen)
- Observed: "Permissions": "Hide meta info ⓘ", "Disable comments ⓘ" (ON), "Disable likes ⓘ"; "Attendees": "Hide from featured areas ⓘ", "Disable RSVP ⓘ", "Hide attendees ⓘ"; "SEO": "Meta title" field. Granular unlisting: from featured surfaces, from attendee visibility, from engagement — each independent.

### 12c. Luma (web) — visibility artifacts across flows
- Mobbin URLs: https://mobbin.com/flows/05561321-93a6-4d22-afb4-6b93137dac47 (create card), https://mobbin.com/flows/c189749d-19a1-4fbd-a368-cd2a1262ad6e (guest list), https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb (More tab)
- Observed: create card has a "Public ▾" dropdown in the header (visibility chosen at birth); private events render a "Private Event" pill on the page header. Guests tab: "Guest list hidden from the event page — Show Who's Coming" inline control with guest-status filter (Approved / Pending Approval / Invited / Removed / Not Going / Waitlist / Joined). Overview states "The address is shown publicly on the event page." (address visibility is called out as a fact). More tab: changing the public URL warns "When you choose a new URL, the current one will no longer work. Do not change your URL if you have already shared the event." (link-rot warning = soft-unlist hazard).
- Sad path: URL change silently kills the old share link — Luma warns instead of redirecting.

### 12d. Cal.com (web) — "Hidden" event types (see 4c)
- Mobbin URL: https://mobbin.com/flows/cef86b70-66eb-4de7-a2c1-93a8f16d06b2
- Observed: per-event toggle off ⇒ grey "Hidden" badge; row remains manageable, link copyable — hidden from the public page but not deleted.

### 12e. Vimeo (web) — "Managing event privacy" (virtual event link privacy)
- Mobbin URL: https://mobbin.com/flows/9e8dfb58-472c-417b-a1e2-783588a5612a
- Observed: event Settings drawer → "Privacy" accordion: "Link privacy — Private ▾"; "Embed privacy ⓘ — Specific domains" + domain input ("https://www.mobbin.com" ⊕); info note "When link privacy is set to Private, the embedded event won't be visible to everyone."; "Select content rating — Content ratings are required. They help keep Vimeo safe and ensure your intended audience can view your video." + checkbox "This video contains an advertisement".
- Problem solved: privacy controls warn about their interaction effects (private link breaks public embeds) at the moment of change.

### 12f. Partiful (web) — RSVP-gated page content (see 5a)
- Mobbin URL: https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53
- Observed: "🔒 Restricted Access — Only RSVP'd guests can view event activity & see who's going" — partial-visibility landing page: basics public, social layer gated. "Open Invite" toggle on host page shown "Turned Off".

---

## Cross-task sad-path inventory (observed only)

| Sad path | App | What the UI does | Citation |
|---|---|---|---|
| Cancelled event's page | Cal.com | URL resolves to "This event is canceled" tombstone with reason + struck-through date | https://mobbin.com/screens/ae2c874a-98e8-4b13-ad9c-9f474a308037 |
| Cancelled event in chat/community | WhatsApp | Card persists with "Event canceled" tag + strikethrough; cannot be restored (warned) | https://mobbin.com/flows/8c51c83a-4d16-4da1-8fc2-223785cbdc6d |
| Cancel deletes the page entirely | Luma | "The event will be permanently deleted." + guests auto-notified, customizable email | https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1 |
| One occurrence cancelled in a series | Discord | Red "Canceled" tag on that date only; series page lives on | https://mobbin.com/screens/af86f40b-3343-4fb3-ad15-33f973aa151a |
| Ticket sales closed | Posh | CTA replaced by pill "Ticket sales are closed for this event"; page content intact | https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635 |
| Publish blocked — missing required content | Aboard | Banner "You need to add cover image, text and location before you can publish it."; Publish disabled | https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c |
| Publish blocked — paywall | Locals | "Ready to publish event? Upgrade to Locals Pro" persistent footer | https://mobbin.com/flows/c91ca78e-3961-43d4-8612-708a73604b9b |
| Invalid recurrence range | Posh | Inline red "The end date must be at least one month after the start date." | https://mobbin.com/flows/e0c4b2e2-d811-4457-8043-dfe07d025331 |
| Half-done creation | Partiful | "SAVE DRAFT" primary CTA; "✓ SAVED!" autosave pill; TBD date chip on dashboard cards | https://mobbin.com/flows/e2ff50a1-4c52-40aa-9d5e-7459df74393d, https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53 |
| Draft parked in list | Circle / Eventbrite / Aboard | "Drafts" tab / "Draft" status pill / Drafts sidebar section | https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968, https://mobbin.com/flows/3b85f96b-28c4-44eb-b4f6-658c1f971c23, https://mobbin.com/flows/04a5053f-7a2e-4640-b423-0aa8114b292c |
| Share link killed by URL change | Luma | Warning: "the current one will no longer work. Do not change your URL if you have already shared the event." | https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb |
| Unlisted-but-linkable | Cal.com / Posh | "Hidden" badge with live link / "Show on Explore" off + optional password | https://mobbin.com/flows/cef86b70-66eb-4de7-a2c1-93a8f16d06b2, https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9 |
| Hidden location pre-RSVP | Partiful / Luma | "RSVP to see location" link / "Location Unavailable" chip in feed | https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53, https://mobbin.com/flows/48b7ea19-b9fb-4eee-a174-5d42ab1b67e8 |
| Capacity exhausted | Partiful | "10/10 spots left" counter + "Enable Waitlist" toggle at edit time | https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b |
| Reschedule with price delta | GetYourGuide | "When rescheduling to a lower price, you'll get a partial refund. To reschedule to a higher price, cancel and rebook…" | https://mobbin.com/flows/c8c8171e-c986-4bcd-a5a8-18d0e9c36b01 |
| Cancellation refund anxiety | Peerspace | Refund math table (100% lines) + "If you cancel now, you will receive a full refund." shown before confirm | https://mobbin.com/flows/834ca9f4-c1b3-4544-b355-896a6243da17 |

---

## COVERAGE NOTE

Queries run (tool · query · platform · result):
1. search_flows · "creating a new event from scratch as an organizer" · web · HIT (Posh, Eventbrite, Microsoft Teams, Kajabi)
2. search_flows · "creating a new event from scratch as an organizer" · ios · HIT (Locals, Discord, Lex, Partiful org)
3. search_flows · "setting up an event page with cover image and theme customization" · web · HIT (Luma ×2, Eventbrite, Circle)
4. search_flows · "host sets up a new party invitation page" · ios · HIT (Partiful, Apple Invites; 1 dup Partiful home)
5. search_flows · "choosing event date time and location while creating an event" · web · HIT (Partiful, Luma; Kajabi dup)
6. search_flows · "publishing an event and sharing the event link" · web · HIT (Luma ×2, Circle, Cal.com)
7. search_flows · "previewing an event page draft before publishing it" · web · HIT (Partiful, Circle, X, Posh)
8. search_flows · "editing event details after the event is live" · web · HIT (Luma, Partiful, Posh, Aboard)
9. search_flows · "duplicating a past event or setting up a recurring event series" · web · HIT (Luma ×2, Posh, Amie)
10. search_flows · "cancelling an event as a host" · web · HIT (WhatsApp, Luma ×2, Peerspace)
11. search_flows · "inviting guests to an event by sharing invite link" · ios · HIT (Partiful, Peerspace, Apple Invites, Luma)
12. search_flows · "viewing an event page as a guest checking date venue and who is going" · web · HIT (Partiful, Luma ×3)
13. search_flows · "organizer dashboard browsing my upcoming and past events" · web · HIT (Eventbrite ×2, Posh)
14. search_flows · "changing event visibility to private or unlisted" · web · PARTIAL (Vimeo relevant; Superlist + Todoist results were calendar-app noise — dry for this JTBD; Posh result was user-profile privacy, recorded as adjacent only)
15. search_flows · "rescheduling an event and changing the date" · ios · HIT (GetYourGuide; Canopi + Outlook were calendar-edit noise, not recorded as organizer-event flows)
16. search_screens (deep) · "event page showing cancelled or postponed state to guests" · web · HIT (Cal.com ×4, Luma, Calendly, Discord, Eventbrite)

Honesty about the "loop until dry" rule: the strict 2-consecutive-dry-queries stop condition was NOT executed per task. Each task got 1–2 query phrasings (16 queries total) because every query returned image-heavy result sets and the harvest had to fit one session's context budget. No task is silently truncated — the per-task depth is exactly what the queries above produced.

Tasks with STRONG evidence: 1 (7 apps), 2 (6 apps), 3 (4 apps), 4 (4 apps), 6 (4 apps), 7 (5 apps), 8 (7 apps incl. cancelled-state screens), 9 (4 apps), 10 (4 apps), 11 (5 apps).
Tasks that came up THINNER:
- Task 5 (preview before publish): only Partiful and Circle have true event-preview flows; X article preview used as a transferable pattern; no Luma/Eventbrite dedicated preview flow surfaced.
- Task 12 (visibility/unlisting): no app returned a dedicated "unlist a live event" flow; coverage assembled from cross-finds (Posh Show on Explore, Circle Advanced toggles, Luma Public dropdown/guest-list hiding/URL warning, Cal.com Hidden badge, Vimeo link privacy). A purpose-built unlist flow remains unobserved.
- Reschedule (task 8 second half) for social/event organizers specifically: only booking-style reschedules (GetYourGuide) surfaced; no Partiful/Luma "postponed" page state was found in the queries run.
Not searched (would be next): "event page templates gallery", "postponed event announcement", "transfer event to another host", ios variants of tasks 4–7 and 11–12.
