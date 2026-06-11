# BY-PATTERN Raw Harvest — Event Creation → Public Event Landing Page

Job-to-be-done: an organizer CREATES an event and gets a public event LANDING PAGE that converts visitors.
Mode: BY-PATTERN (pattern-name searches across ALL apps). Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## 1. Event creation form / create event wizard / smart defaults

### 1a. Single-page "form is the event page" creation (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b
- What it looks like / steps: The create screen IS a draft of the landing page. Giant placeholder cover (gradient art) with "Change Cover Photo" button bottom-left; "Event Name" as a huge ghost-text inline title field ("Morning Yoga"). Sections styled like the public page: "Where is the event taking place?" with segmented tabs In Person / Zoom / Virtual; "When will it happen?" with Single Event / Event Series toggle and a compact card "Wed, 7 Jun · 11:00 AM > 12:00 PM" plus footer "GMT-07:00 Los Angeles"; "Access" section with a single checkbox "Require Registration Approval — If selected, only approved guests will receive a ticket." One black CTA "» Create Event". After create: toast "Event created successfully! Taking you to the manage page..." and the manage view (Overview / Guests / Registration / Emails / Insights / More tabs + "Event Page ↗" button) loads with skeleton placeholders.
- Problem solved: zero-wizard creation — every field has a smart default (date, time, timezone, cover art), so a publishable event exists in ~4 inputs; WYSIWYG framing means the organizer never wonders what guests will see.
- Sad paths: none visible in flow (fields prefilled, so empty-required-field errors are designed away).
- Microcopy worth stealing: "Where is the event taking place?" / "When will it happen?" / "Require Registration Approval — If selected, only approved guests will receive a ticket." / "Event created successfully! Taking you to the manage page..."
- Notes: questions-as-section-headers reads like a conversation, not a form.

### 1b. Tabbed draft workspace with Publish gate (Circle)
- Apps observed in: Circle (web)
- Mobbin URLs: https://mobbin.com/flows/ee6120bf-4cf7-42da-bc1e-3f123208af79 , https://mobbin.com/flows/22b4af6c-43fa-4ce7-9df0-7b822a93961e , https://mobbin.com/flows/65e99791-e5f8-45d4-b00f-dffad43b8874
- What it looks like / steps: "Create event" modal asks only Title, Space, Host, Date & time (GMT offset shown in label, e.g. "Date & time (GMT+8)"), Repeats — then "Save draft". Saved event opens a full-page workspace: header shows event name + grey "Draft" pill, tabs Overview / People / Basic Info / Post Details / Notifications / Advanced, top-right "Preview ↗" and black "Publish" button. Basic Info regroups the same question headers ("What is the event?", "When is the event?", "Where is the event?", "Is this a paid event?") and adds "Custom URL (Optional)" with the slug auto-generated from the title (potato-palooza-2023). Topics tag input "Choose up to 5 topics". Toasts: "Event created." and "Changes saved."
- Problem solved: separates fast capture (small modal) from full configuration (tabbed workspace); Draft pill + explicit Publish makes state unambiguous.
- Sad paths: Draft state is a first-class visible state; People tab shows "0 Attendees" empty state with "Add attendees" button.
- Microcopy worth stealing: "Save draft" / "Custom URL (Optional)" / "Choose up to 5 topics" / "Is this a paid event?"
- Notes: auto-slug from title is the smart-default version of custom URLs.

### 1c. AI-assisted event creation wizard (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/b61d5937-ec5d-4ff3-9341-bdbce3bb6a7a (also https://mobbin.com/screens/7e4343bf-2df1-4693-97fc-2a7e1f5ef06c)
- What it looks like / steps: Page titled "Create an event with AI — Answer a few questions about your event and our AI creation tool will use internal data to build an event page. You can still create an event without AI." Q&A-styled single page: "What's the name of your event?" with helper "This will be your event's title. Your title will be used to help create your event's summary, description, category, and tags – so be specific!"; "When does your event start and end?" (Date + Start time + End time); "Where is it located?" (Venue / Online event / To be announced segmented buttons + location search + map); "How much do you want to charge for tickets?" (price field + "My tickets are free" toggle, note "Our tool can only generate one General Admission ticket for now."); "What's the capacity for your event?" with helper "Event capacity is the total number of tickets you're willing to sell." Footer: "Exit" link + orange "Create event".
- Problem solved: AI drafts the heavy content (summary, description, category, tags) from 5 structured answers; opt-out link preserves control.
- Sad paths: capability limits stated honestly inline ("can only generate one General Admission ticket for now").
- Microcopy worth stealing: "Answer a few questions about your event and our AI creation tool will use internal data to build an event page." / "You can still create an event without AI." / "…so be specific!"
- Notes: AI is framed as filling in downstream fields, not as a chatbot.

### 1d. Steps-sidebar event builder (Eventbrite classic)
- Apps observed in: Eventbrite (web)
- Mobbin URLs: https://mobbin.com/screens/a8321be6-f638-4ba8-92c6-68db041b82b8 , https://mobbin.com/screens/98453d05-a567-4c42-8a42-53ec825e37f6 , https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2
- What it looks like / steps: Left rail shows an event summary card (title, date, "Draft ▾" dropdown, "Preview ↗") above a numbered checklist "Steps": Build event page → Add tickets → Publish, each with one-line descriptions ("Add all of your event details and let attendees know what to expect", "Use our suggestions to help sell more tickets or manually create your own", "Review your event page and settings, then publish your event"). Main pane sections: "Type of event" radio cards Single event ("For events that happen once") vs Recurring event with NEW badge ("For timed entry and multiple days"); Date and time; Location. "Save and continue" persistent bottom-right.
- Problem solved: long builder decomposed into 3 promises; progress is always visible; Draft dropdown doubles as status control.
- Sad paths: collapsed "More options" hides advanced timezone/language settings until needed (progressive disclosure).
- Microcopy worth stealing: "Build event page" / "Use our suggestions to help sell more tickets or manually create your own" / "Single event happens once and can last multiple days"
- Notes: the left-rail mini event card is a constant draft-preview anchor.

### 1e. Vibe-first playful creation (Partiful)
- Apps observed in: Partiful (iOS)
- Mobbin URLs: https://mobbin.com/flows/732d3782-570a-47cc-9a84-cd991745c03c , https://mobbin.com/screens/67c55efb-921c-456e-a7a9-ca9c7c075b89
- What it looks like / steps: Home greets "Welcome to Partiful, Sam!" with "🪄 Need inspo? Ask the Party Genie" and a dashed-border placeholder event card with "+ New event". Optional inspiration screen "What's your party vibe?" with chips (🔥 trending, 🎂 birthday, 🍪 chaos, 🍳 chill, 👯 besties), a sample flyer card, "Randomize" button, and "✨ Or create from scratch" link. New Event screen: giant editable title "Birthday Bash" with live font-style tabs (Classic / Eclectic / Fancy / Simple), full-bleed illustrated default cover with pencil edit button, "Set a date... ▾" row, and link "Can't decide when? Poll your guests →". Bottom dock: Theme (NEW badge) / Effect / Settings; host avatar row "+ Add cohosts"; Save top-right.
- Problem solved: makes the invite feel like a designed artifact in <30 seconds; date can be deferred to a guest poll — removes the biggest blocker to creating at all.
- Sad paths: date intentionally allowed to be unset ("Set a date..." stays a placeholder).
- Microcopy worth stealing: "Need inspo? Ask the Party Genie" / "What's your party vibe?" / "Randomize" / "Or create from scratch" / "Can't decide when? Poll your guests →"
- Notes: the entire creation surface is the live themed invite — even stronger WYSIWYG than Luma.

### 1f. Add-a-section content model (Partiful edit)
- Apps observed in: Partiful (iOS)
- Mobbin URL: https://mobbin.com/flows/9b50876d-84ad-4498-a39b-df06ce40006f
- What it looks like / steps: Edit Event shows chip row "+ Link · + Playlist · + Registry · + Food situation" above the description, then "More to say? + New section". Below: "🥂 Open Invite" dropdown, "⚙️ RSVP Options" (Emojis: Going / Maybe / Can't Go), and "Quick actions for hosts": Add Questionnaire / Reminders / Require Guest Approval / ··· More.
- Problem solved: optional landing-page blocks are offered as named one-tap chips instead of a blank rich-text field.
- Microcopy worth stealing: "More to say? + New section" / "Food situation" / "Quick actions for hosts"

### 1g. Commerce-first event link creation (Square)
- Apps observed in: Square (web)
- Mobbin URL: https://mobbin.com/screens/d554aeed-a3ae-43fc-8242-557f1f40be52
- What it looks like / steps: "Create link" page, Purpose dropdown "Sell an event or class". Details: In-person / Online toggle, "Event link" URL field, Start/End date+time, Time zone, "Event capacity 30". Right pane: live phone-frame preview of the checkout landing card (cover, title "Design System 101", $20.00, "Saturday, January 4, 2025 at 9:00 AM - 10:30 AM EST", "Online" badge) with Details / Checkout / Confirmation preview tabs and mobile/desktop toggles.
- Problem solved: side-by-side form + rendered landing preview eliminates publish anxiety for sellers.
- Notes: preview tabs covering Checkout/Confirmation are out of scope, but the Details preview pattern applies.

### (Context) iOS generic "Add Event" forms
- Apps observed in: Amazon Alexa (iOS) https://mobbin.com/flows/bfce9ab1-ce28-4db6-8509-056779de6dfd ; KakaoTalk (iOS) https://mobbin.com/flows/266f3926-d732-464a-a64a-7302b1affcb4 ; Canopi (iOS) https://mobbin.com/flows/e5ba82ea-518a-493d-8145-dddcaa664cdc
- What it looks like: calendar-style stacked rows ("What's happening?" placeholder title, All day toggle, Start/End Date+Time, Location with autocomplete results, Notes). Canopi is notable: event as a stack of playful cards (big date numeral, map card, "Who Brings What?" checklist card, Invite button, sticker decoration, recurring "Every Sunday" circled on a dot grid).
- Notes: recorded as context only — these are personal-calendar events, not public landing pages.

---

## 2. Cover image picker / AI generated cover / image gallery

### 2a. Multi-image cover manager with social-proof nudge (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URLs: https://mobbin.com/screens/be1399ca-37cd-477d-ac5f-e63e0193677d , https://mobbin.com/screens/cfb4a50a-c291-489f-9be4-9200f74fa163 , https://mobbin.com/screens/8b1a86dd-fd80-436d-8d49-47b938668303
- What it looks like / steps: "Main Event Image — Add photos to show what your event will be about. You can upload up to 10 images." Drag-and-drop zone with two buttons: "Upload image" and "Design with Canva". Spec line: "Recommended image size: 2160 x 1080px · Maximum file size: 10MB · Supported image files: JPEG or PNG". Thumbnail strip with "+" tile; selected thumbnail gets a "★ Cover image" badge on the hero. Inline AI-sparkle tip card: "82% of attendees prefer main event images that show an event's vibe and atmosphere." with "See examples" link.
- Problem solved: converts the cover image from an upload chore into a guided conversion lever (stat + examples + Canva escape hatch for non-designers).
- Sad paths: none visible (constraints stated up-front to prevent failed uploads).
- Microcopy worth stealing: "82% of attendees prefer main event images that show an event's vibe and atmosphere." / "Design with Canva"

### 2b. Good/bad example teaching modal (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/b4a68a09-d3d5-4fe1-ba34-321c1f35389b
- What it looks like / steps: Modal "Main event image examples" headed "Try to avoid using a lot of text on your image". Side-by-side: ✗ text-heavy Oktoberfest poster ("Lots of text can be jarring and doesn't show what your event is about") vs ✓ photo with minimal overlay ("Some text on an image that includes important details is okay"). Carousel dots + orange CTA "OK, I'm ready!".
- Problem solved: teaches image quality with a contrastive pair instead of rules text.
- Microcopy worth stealing: "Try to avoid using a lot of text on your image" / "OK, I'm ready!"

### 2c. Flyer upload + stock/GIF search in one modal (Posh)
- Apps observed in: Posh (web)
- Mobbin URLs: https://mobbin.com/screens/3f2fbf25-7619-4ff8-a28f-d9670205dc34 , https://mobbin.com/screens/750bfd6e-a317-4830-a40c-dc37ef81f3d1
- What it looks like / steps: "Upload Event Flyer" modal: drag-and-drop zone "Drag & drop or click here to upload a 4:5 flyer — 4:5 aspect ratio (e.g. 1080 x 1350 px). Other sizes will be cropped."; tabs Images / GIFs; "Search for images..." field over a grid of dark nightlife stock photos. Behind it the event builder shows an "Image Gallery" strip (numbered placeholder tiles) and a live flyer preview on the right.
- Problem solved: organizers without a designed flyer can ship a credible dark-themed page from stock/GIF search; hard 4:5 ratio keeps every Posh page composition consistent.
- Sad paths: crop warning stated before upload ("Other sizes will be cropped").
- Microcopy worth stealing: "Drag & drop or click here to upload a 4:5 flyer"

### 2d. Unsplash / Upload / Embed-link tabs (Circle)
- Apps observed in: Circle (web)
- Mobbin URL: https://mobbin.com/screens/b618fee6-e741-47cd-8078-039f5f23215b
- What it looks like / steps: "Choose cover image" modal with three tabs: Unsplash (default, search field "potato" over credited photo grid "by Lars Blankers…"), Upload, Embed link.
- Problem solved: legal, attributed stock images one search away; no asset required to look finished.

### 2e. AI cover generation with style modes (Notion — analogous)
- Apps observed in: Notion (web)
- Mobbin URL: https://mobbin.com/screens/c562f7e8-d22a-45ac-b255-b73d72b34d34
- What it looks like / steps: Cover "Change" popover with tabs Gallery / Upload / Link / Unsplash / Notion AI (Beta). AI tab: prompt textarea ("generate a cover image to visualize the concept of brand creative strategy"), style dropdown General / Photo / Pattern, helper "Generate a custom image using AI based on your description", Generate/Change/Reposition controls on the cover itself.
- Problem solved: text-to-cover for users with no imagery; style presets constrain output quality.
- Notes: not an events product, but this is the cleanest observed AI-cover anatomy; no event-native AI cover generator surfaced in queries this sweep (Luma's AI generate tab did not appear in returned screens — recorded as a gap, see coverage note).

### 2f. Default art + one-button swap (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/screens/3d836166-0c6c-4e7d-be27-242a20749625
- What it looks like / steps: New events get a generated abstract gradient cover automatically; a single overlay button "Change Cover Photo" sits on the image.
- Problem solved: the page never looks broken pre-upload; editing is discoverable exactly where the result lives.

---

## 3. Event page theme customization / color theme picker / font style picker

### 3a. Live font-personality tabs on the title (Partiful)
- Apps observed in: Partiful (iOS)
- Mobbin URLs: https://mobbin.com/screens/881a2632-2dbe-465f-8668-bfe1f1009bcd , https://mobbin.com/screens/4917b52b-b292-4c53-8230-2060009cebad
- What it looks like / steps: Directly under the event title, four named style tabs — Classic / Eclectic / Fancy / Simple — each rendered IN its own typeface; tapping restyles the live title instantly (e.g. "Fancy" switches "Birthday Bash" to script).
- Problem solved: typography choice without a font list; names sell a vibe, samples show it, zero preview step.
- Microcopy worth stealing: the tab names themselves: "Classic · Eclectic · Fancy · Simple"

### 3b. Theme + Effect swatch trays over the live page (Partiful)
- Apps observed in: Partiful (iOS)
- Mobbin URLs: https://mobbin.com/screens/3717646b-48a9-43ab-ba27-6a7f020c308c (Effect), https://mobbin.com/screens/4917b52b-b292-4c53-8230-2060009cebad (Theme)
- What it looks like / steps: Bottom dock Theme / Effect / Settings opens a horizontal tray of circular swatches over the still-visible event page; Theme swatches are textured background previews; Effect tray adds animated overlays (bubbles, confetti, fireworks circles) plus an upload tile for custom; selected swatch gets a ring. Edits apply live behind the tray.
- Problem solved: full-page theming reduced to two one-row choices; animation becomes a brand asset for a party page.
- Sad paths: none visible.
- Notes: "Effect" as a separate axis from "Theme" is the differentiator — motion sold separately from color.

### 3c. Title font + accent color on a dark flyer page (Posh)
- Apps observed in: Posh (web)
- Mobbin URL: https://mobbin.com/screens/750bfd6e-a317-4830-a40c-dc37ef81f3d1
- What it looks like / steps: Right rail of the event builder: "Aa Title Font — Default ▾" dropdown and "Accent Color — #dc9c5c" swatch row with hex value; "Add song from Spotify" row above; "Create Event" CTA below. Changes reflect on the live flyer preview.
- Problem solved: two knobs (font + accent) give per-event branding without a theme system.

### 3d. Light/Dark/Custom theme with per-role color tokens (Later — analogous page builder)
- Apps observed in: Later (web)
- Mobbin URL: https://mobbin.com/screens/b7e5ca04-adf4-4d1c-90cd-5b7c941d1602
- What it looks like / steps: Design tab: "Themes" tiles Light / Dark / Custom; "Customize Colours" rows Background #0F1020, Text and Icon #FAA6FF, Accent #7353BA, Button Text #EFC3F5, each with swatch + hex; live page preview right; "Save Changes" / "Discard"; toast "Media Kit Page Design Saved — Your media kit page has been updated."
- Problem solved: named color roles (not raw palette) keep custom themes coherent.
- Notes: analogous (creator landing page, not event) — recorded because no event app surfaced full token-level theming.

### 3e. Branding modal with contrast-aware fields (SavvyCal, Gamma, Linktree — analogous)
- Apps observed in: SavvyCal https://mobbin.com/screens/33df18e6-c18e-4294-9c67-291eed7619f3 ; Gamma https://mobbin.com/screens/d5cb7477-bb1c-4fb0-b818-9221545de6cc ; Linktree https://mobbin.com/screens/71e1d21b-1c93-4745-8b63-e4827a0fff8d
- What it looks like / steps: SavvyCal "Branding settings": Primary Color ("For buttons and active day indicators."), Accent Color ("For highlights and accent elements."), Theme dropdown ("Match user preferences" / "Always show in dark mode"), Banner Image dropzone ("No banner image set", "Recommended 1500px × 500px in size."), "Hide SavvyCal branding on scheduling links" toggle, "Reset to default colors". Gamma theme editor: Fonts (Headings/Body dropdowns + weight + color) with live "This is a theme preview" pane and note "Note: text colors may be lightened or darkened for contrast and accessibility." Linktree Design: Font row, Page text color, Button style tiles Solid/Glass/Outline, Corners slider Square↔Round, plus a Tint row showing an inline contrast warning icon (⚠) when the chosen tint risks readability.
- Problem solved: scoped color roles + automatic contrast guardrails prevent organizers from shipping unreadable pages.
- Sad paths: Linktree's ⚠ on the Tint row and Gamma's auto-adjust note are the only observed contrast sad-path handling in this family.
- Microcopy worth stealing: "Match user preferences" / "Note: text colors may be lightened or darkened for contrast and accessibility."
- Notes: all analogous (scheduling/slides/link-in-bio); event-native equivalents beyond Partiful/Posh did not surface.

---

## 4. Date & time picker with timezone / multi-day range

### 4a. Compact in-card time range + searchable timezone (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/screens/d0ccb229-b70a-472e-8daa-ea4622ef3774 , https://mobbin.com/screens/20619bf3-a36a-42eb-b6de-3f578b8d8aac
- What it looks like / steps: One card shows "Wed, 7 Jun · 11:00 AM > 12:00 PM" with footer "🌐 GMT-07:00 Los Angeles". Clicking a time opens a scrollable dropdown of 30-minute increments with the current value highlighted. The timezone field is a typeahead: typing "new" lists "Eastern Time - New York (GMT-04:00), Central Time - New Salem… , Newfoundland Time - St Johns (GMT-02:30), Papua New Guinea Time…, New Caledonia…, New Zealand Time - Auckland (GMT+12:00)" — city names with GMT offsets right-aligned.
- Problem solved: timezone selection by city name (how humans think) instead of offset lists; end time auto-defaults an hour after start.
- Sad paths: none visible.
- Notes: same card also hosts the session list for series (see 9a).

### 4b. Explicit start/end rows + display toggles (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/16913830-b502-4c52-86dc-d01df6f290ae
- What it looks like / steps: "Date and time — Tell event-goers when your event starts and ends so they can make plans to attend." Tabs Single Event / Recurring Event with caption "Single event happens once and can last multiple days". Four fields: Event Starts* (04/01/2023), Start Time (7:00 PM), Event Ends*, End Time with a 30-min dropdown. Checkboxes: "Display start time. — The start time of your event will be displayed to attendees." and "Display end time." Time Zone dropdown "(GMT-0800) United States (Los Angeles)…" + "Event Page Language — English (US)".
- Problem solved: organizers can hide imprecise end times from the public page without lying about them internally.
- Microcopy worth stealing: "Tell event-goers when your event starts and ends so they can make plans to attend."

### 4c. Multi-day date range in one field (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/a8321be6-f638-4ba8-92c6-68db041b82b8
- What it looks like / steps: Date field rendered as a range "10/18/2025 – 10/20/2025" with Start time (caption "October 18") and End time (caption "October 20") — the captions bind each time to its day. "More options" collapsed link reveals "EDT, Display start time and end time, English (US)" summary.
- Problem solved: multi-day events without a second date row; captions prevent the classic which-day-does-this-time-belong-to error.

### 4d. Schedule modal gating a dependent feature (Vimeo)
- Apps observed in: Vimeo (web)
- Mobbin URL: https://mobbin.com/screens/78b6cae3-15e7-45d0-b1ee-d4c01ae18d19
- What it looks like / steps: Modal "Schedule your event to turn on registration — Attendees will need to register for event access. The form will be displayed on the event page and anywhere your event is embedded." Blue info banner: "This action will end the recurring schedule for this event. After you go live, you won't be able to stream from this event again." Start date+time (dropdown), End date "mm/dd/yyyy" + greyed "Choose time", Time zone "New York City, United States (GMT - 04:00)". Buttons Cancel / "Turn on".
- Problem solved: forces a concrete schedule before enabling registration; irreversible consequence disclosed in-modal before commit.
- Sad paths: consequence warning is the sad-path prevention.

### 4e. Bookable date-range settings (Calendly — analogous)
- Apps observed in: Calendly (web)
- Mobbin URLs: https://mobbin.com/screens/25f41cac-87cc-4ca8-8dc0-a7c89ce6b1c0 , https://mobbin.com/screens/9c094217-a8dc-46d8-8cea-d306627b742f
- What it looks like / steps: "Scheduling settings → Date range — Invitees can schedule…" radio: "60 calendar days into the future" / "Within a date range Sep 2 – Sep 6, 2024" / "Indefinitely into the future". Right pane is a labeled live preview: "This is a preview. To book an event, share the link with your invitees." with the public calendar and "Time zone — Indochina Time (2:32pm) ▾" showing the invitee's current clock time.
- Problem solved: timezone dropdown displaying the *current time* in that zone removes offset math.
- Notes: analogous (scheduling product), recorded for the live-clock timezone trick.

---

## 5. Location picker with map autocomplete / virtual event link field

### 5a. In Person / Zoom / Virtual mode switch with auto-map (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/screens/3d836166-0c6c-4e7d-be27-242a20749625 , https://mobbin.com/screens/cbdf2a94-e07d-4eed-bb2e-fdcf06f95d8c , https://mobbin.com/screens/4e6caa7d-f010-48d9-8ee6-0380b682a7dc
- What it looks like / steps: Segmented tabs In Person / Zoom / Virtual. In Person: "Event Location" autocomplete placeholder "What's the address?"; choosing a place instantly drops a Google map with pin below; "+ Add Further Instructions" reveals an "Instructions" field (example content: "Knock the door").
- Problem solved: location mode chosen before fields appear, so virtual organizers never see address inputs; arrival instructions live with the address instead of buried in description.
- Microcopy worth stealing: "What's the address?" / "+ Add Further Instructions"

### 5b. Venue / Online event / To be announced (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URLs: https://mobbin.com/screens/7e4343bf-2df1-4693-97fc-2a7e1f5ef06c , https://mobbin.com/screens/98453d05-a567-4c42-8a42-53ec825e37f6
- What it looks like / steps: Three segmented options: "📍 Venue", "🖥 Online event", "📅 To be announced". Venue mode: "Location*" search field + "Add location details" link + map preview. Caption elsewhere: "Online events have unique event pages where you can add links to livestreams and more".
- Problem solved: "To be announced" legitimizes publishing before the venue is locked — removes a real-world blocker to going live.
- Microcopy worth stealing: "To be announced" / "Online events have unique event pages where you can add links to livestreams and more"

### 5c. Location-type dropdown incl. native streaming + privacy toggle (Circle)
- Apps observed in: Circle (web)
- Mobbin URLs: https://mobbin.com/flows/22b4af6c-43fa-4ce7-9df0-7b822a93961e (screens with Location dropdown and Live options)
- What it looks like / steps: "Where is the event? → Location" dropdown: In person / URL (Zoom, YouTube Live) / Circle Live Stream / Circle Live Room / TBD. Choosing Circle Live Stream reveals View (Speaker ▾), Visibility (Community ▾), toggles "Record this live", "Automatically post recording to event", "Hide location from non-attendees".
- Problem solved: one field models five fulfillment modes; "Hide location from non-attendees" is address-privacy as a checkbox.
- Microcopy worth stealing: "Hide location from non-attendees" / "TBD"

### 5d. Online event link field with capacity (Square)
- Apps observed in: Square (web)
- Mobbin URL: https://mobbin.com/screens/d554aeed-a3ae-43fc-8242-557f1f40be52
- What it looks like / steps: In-person / Online toggle; Online mode shows "Event link — https://mobbin.com" plain URL field; "Online" badge appears on the live preview card.
- Problem solved: virtual link captured at creation and rendered as a trust badge on the landing card.

### 5e. Address autocomplete on mobile (Amazon Alexa — context)
- Apps observed in: Amazon Alexa (iOS)
- Mobbin URL: https://mobbin.com/flows/bfce9ab1-ce28-4db6-8509-056779de6dfd
- What it looks like / steps: "Add Location" screen: search field with typed address, single suggestion row "1226 University Dr — Menlo Park, CA 94025", Save.
- Notes: context-grade only (calendar app).

---

## 6. Visibility settings (public/private/unlisted) / publish / draft preview

### 6a. Open Invite audience dropdown with plain-language scopes (Partiful)
- Apps observed in: Partiful (iOS)
- Mobbin URL: https://mobbin.com/flows/9b50876d-84ad-4498-a39b-df06ce40006f
- What it looks like / steps: "🥂 Open Invite" row opens a sheet: "Post this event on the Partiful homepage of hosts' Mutuals, without directly inviting them" with three options, each with a one-line consequence: "All Hosts' Mutuals — Visible to all Mutuals of every host" / "Select Mutuals — Pick which Mutuals have access >" / "Turned Off — Only people with the link have access". Selection reflects back on the row ("Turned Off" → "All Hosts' Mutuals").
- Problem solved: visibility expressed as who-sees-it sentences, not public/unlisted jargon; "Turned Off" = link-only unlisted state.
- Microcopy worth stealing: "Only people with the link have access" / "Post this event on the Partiful homepage of hosts' Mutuals, without directly inviting them"

### 6b. Pre-publish review checkpoint (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2
- What it looks like / steps: Publish step: "Your event is almost ready to publish — Review your settings and let everyone find your event." Left: rendered event card (cover, title, "October 18 - 10am - October 20 - 12pm EDT", address, "🎟 Free—$1.00 · 👤 25", "Preview ↗"). Right: "Event type and category" (Type / Category / Subcategory dropdowns — "Your type and category help your event appear in more searches."), "Tags — Help people discover your event by adding tags related to your event's theme, topic, vibe, location, and more." with chip input and "5/10 tags" counter. "Organized by" field with note "Adding a name will create an organizer profile after publishing, and this event will appear on the organizer's profile page." Orange "Publish now".
- Problem solved: last screen converts publishing into a discoverability checklist (category, tags, organizer profile) with the real card as proof.
- Microcopy worth stealing: "Your event is almost ready to publish" / "Help people discover your event by adding tags related to your event's theme, topic, vibe, location, and more."

### 6c. Draft mode banner → Publish → Attend (Aboard)
- Apps observed in: Aboard (web)
- Mobbin URL: https://mobbin.com/flows/026b50dc-3dae-430a-a786-bce90b58de12
- What it looks like / steps: Draft event page shows a full-width blue banner "This event is in draft mode." with blue "Publish" button top-right; sidebar groups events under "Drafts". After publish: banner gone, button becomes "✓ Attend", sidebar regroups under "All events", "Share" appears in header, Attendees section shows "No attendees" empty state.
- Problem solved: state machine made visible — the page itself announces draft status; publish swaps organizer controls for visitor CTAs.
- Sad paths: "No attendees" empty state on a just-published page.

### 6d. Per-page anti-discovery toggles (Circle Advanced)
- Apps observed in: Circle (web)
- Mobbin URL: https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968
- What it looks like / steps: Advanced tab: Permissions (Hide meta info / Disable comments / Disable likes), Attendees (Hide from featured areas / Disable RSVP / Hide attendees), SEO (Meta title…). Header keeps Draft pill + Preview ↗ + Publish.
- Problem solved: granular un-listing (hide from featured, hide attendee list) without a single public/private switch.

### 6e. Link privacy + embed domain allowlist (Vimeo)
- Apps observed in: Vimeo (web)
- Mobbin URL: https://mobbin.com/flows/9e8dfb58-472c-417b-a1e2-783588a5612a
- What it looks like / steps: Settings → Privacy: "Link privacy — Private ▾"; "Embed privacy — Specific domains" with domain.com + add field; info banner "When link privacy is set to Private, the embedded event won't be visible to everyone"; content rating selector ("Content ratings are required. They help keep Vimeo safe and ensure your intended audience can view your video.", "All audiences").
- Problem solved: privacy interactions between link and embed surfaced as an inline warning instead of a surprise.

### 6f. Password-protected page + Explore listing toggle (Posh)
- Apps observed in: Posh (web)
- Mobbin URL: https://mobbin.com/screens/750bfd6e-a317-4830-a40c-dc37ef81f3d1
- What it looks like / steps: Page Settings: "Show on Explore ⓘ" toggle (public discovery), "Password Protected Event ⓘ" toggle revealing inline password field ("cookies4life"), "Enable Event Activity ⓘ NEW" with radio "Social feed — Organizers and attendees can post, reply, and react in the activity feed." vs "Updates only — Only organizers can post updates. Attendees can't comment or react."
- Problem solved: three distinct privacy axes (discovery, access, interaction) as three labeled toggles.
- Microcopy worth stealing: "Show on Explore" / "Updates only — Only organizers can post updates."

---

## 7. Share after publishing / copy event link / social share card

### 7a. Share This Event modal with channel icons + copy state (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/flows/1d427766-01b1-457b-b810-e4e606f9362a , https://mobbin.com/flows/d83ae620-2181-4e0b-9621-a6bce23ccf17
- What it looks like / steps: "Share This Event" popover: icon row Share (FB) / Tweet / Post (LinkedIn) / Email / Text (+ native Share on the manage variant); "Share the link:" with the short URL (https://lu.ma/bffi7c7z) and a "Copy" button that flips to "Copied!". Organizer manage page shows action-card trio "Invite Guests / Send a Blast / Share Event", a mini render of the public event card with the short link + COPY overlay, and invite stats ("1/2 Invites Accepted · 2 Emails Opened · 0 Declined").
- Problem solved: one modal covers all channels; copy feedback is instant; share lives next to evidence it works (invite stats).
- Microcopy worth stealing: "Share the link:" / "Copied!" / "Send a Blast"

### 7b. AI-captioned social post composer with platform preview (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/flows/595fc812-4448-484b-aee7-4cf12a7760c0
- What it looks like / steps: Marketing → "Share on social" landing (bullets: "Sell more tickets by tapping into your followers on TikTok and LinkedIn", "Use AI to create compelling content that speaks to your audience", "Easily create posts in just a few clicks and share across multiple social platforms at once"; CTA "Start sharing"). Composer: "Choose what to promote" (Event/Collection), "Share to" social-account dropdown, "Create your post → Your caption" prefilled with AI text + hashtags, disclosure banner "This caption was generated by Chat GPT and is subject to Open AI's Terms of Use. Remember to review and edit your content for accuracy before sharing.", "Generate another caption" link, char counter "320 / 2000", "Add images and videos" (event image preselected, drag-drop tile, "Design with Canva" tile), warning "Select a social account first to add or edit media to your post." Right pane: "Preview your post — This preview will update once you've selected the social account…" rendered as an Instagram-style card.
- Problem solved: turns the landing-page URL into ready-to-ship platform posts; AI caption with explicit review disclaimer.
- Sad paths: inline gating message when no social account is connected.
- Microcopy worth stealing: "Generate another caption" / "Remember to review and edit your content for accuracy before sharing."

### 7c. Share Flyer sheet with QR + flyer carousel (Partiful)
- Apps observed in: Partiful (iOS)
- Mobbin URL: https://mobbin.com/flows/fa2023d7-38ef-4094-a6c6-dbe5518addf6
- What it looks like / steps: Bottom sheet "Share Flyer — Post to socials or send with the link": swipeable flyer card carousel (auto-generated flyer variants with date "Saturday Aug 30" + title baked in), QR code peeking at right edge, action row Save / Messages / More, footer promo "Get featured on Party Genie — Submit this event design [Submit]". Separate Invite screen: contact list with search + "Filter by event" (re-invite past guests), bottom dock Copy Link / Messages / Email Invite / More. Email compose: "Message 0/480" with template "Hey [Name], Sam Lee invited you to Birthday Bash" + "(Optional) Add a custom note" + "RSVP at [link]", Invitees list, "Send emails".
- Problem solved: share artifact is a designed flyer (image-first for IG stories), not a bare URL; QR included for print/IRL; past-guest filter makes re-inviting a one-tap audience.
- Microcopy worth stealing: "Post to socials or send with the link" / "Hey [Name], Sam Lee invited you to Birthday Bash … RSVP at [link]"

### 7d. Copy-link with expiry disclosure (Later — analogous)
- Apps observed in: Later (web)
- Mobbin URL: https://mobbin.com/flows/cc5918f7-ca55-4c5a-8023-39a9daf0b38b
- What it looks like / steps: "Create link for 1 posts" modal: "Send via Link" URL + "Copy Link" button, note "This link will be valid for 7 days and will expire on Apr 28 at 10:35 AM."; "Share via Email" field + Invite; toast "Link copied to clipboard".
- Problem solved: expiring share links with the expiry stated at copy time.
- Notes: analogous product; recorded for the expiry-disclosure microcopy.

---

## 8. Event capacity and waitlist settings (organizer settings UI)

### 8a. Max Capacity popover with auto-close rule (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/screens/05ebc46b-2f97-443b-8cd9-71ede5503bdf
- What it looks like / steps: Clicking "Capacity — Unlimited" on the create/manage form opens a small popover "Max Capacity — Auto-close registration when the capacity is reached. Only approved guests count toward the cap." Capacity number field (1000), "Over-Capacity Waitlist" toggle, paired buttons "Set Limit" (black) / "Remove Limit" (grey).
- Problem solved: capacity is a behavior ("auto-close registration"), not just a number; the approved-guests-only rule is stated where it matters.
- Sad paths: "Remove Limit" is a first-class escape, not buried.
- Microcopy worth stealing: "Auto-close registration when the capacity is reached. Only approved guests count toward the cap." / "Over-Capacity Waitlist"

### 8b. Registration hub with capacity/waitlist status cards (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/screens/1f1b14d3-e759-43f3-9a8f-9c67d8f680af , https://mobbin.com/screens/e9a15838-b7c1-4961-9806-d18fa4016e87
- What it looks like / steps: Registration tab opens with three status cards: "Registration — Open", "Event Capacity — 1,000 · Waitlist On", "Group Registration — Off". Below: Tickets list ("Standard · Free" with orange "Require Approval" chip, "0 registered", "+ New Ticket Type"), "Registration Emails — Customize the emails sent when a guest registers for the event and for when you approve or decline their registration." with three preview cards "Pending Approval / Waitlist" (grey check) / "Going" (green check) / "Declined" (red x), then "Registration Questions — We will ask guests the following questions when they register for the event."
- Problem solved: capacity + waitlist state is readable at a glance as cards; email consequences of approval/waitlist are co-located with the settings that trigger them.

### 8c. At-a-glance capacity bar + Close/Open Registration (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/screens/905febf2-3c69-4661-91c5-2e5fb338ecef , https://mobbin.com/screens/54040cc9-2328-4060-8e58-e6b427a47142
- What it looks like / steps: Guests tab "At a Glance": "0 approved guests" against "cap 50" with a progress bar, action cards "Invite Guests / Change Capacity / Close Registration". After closing: note "Registration is closed.", the third card flips to "Open Registration", green toast "Registration is now closed." Guest List header shows "Approved guests are shown on the event page — Hide" (or when hidden: "Guest list hidden from the event page — Show Who's Coming").
- Problem solved: capacity, registration state, and guest-list visibility are one surface; closing registration is reversible and its state is restated in three places.
- Sad paths: closed-registration state is fully designed (note + inverted action + toast).
- Microcopy worth stealing: "Registration is now closed." / "Guest list hidden from the event page — Show Who's Coming"

### 8d. Full waitlist policy page (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/e2123250-ae9b-4714-90ab-6b28daaaf7d6
- What it looks like / steps: "Waitlist Settings — Let people join a waitlist if tickets sell out or your event reaches capacity". Enable/Disable radio. "Waitlist Trigger:" radio — When "General Admission" sells out / When "Workshop Admission" sells out / When total event capacity is reached. "Maximum Waitlist Size:" number field with helper "Zero for unlimited". "Attendee Information To Collect:" checkboxes Full Name (Required) / Email Address (Required) / Phone Number. "Time To Respond:" Day(s)/Hour(s)/Minute(s) fields with helper "Time allowed for attendees to claim their ticket". "Auto-Response Message:" rich-text editor. Event header shows green "On Sale" status pill.
- Problem solved: the waitlist is modeled as a policy machine — trigger, size, data collected, claim window, auto-reply — every release rule made explicit.
- Microcopy worth stealing: "Let people join a waitlist if tickets sell out or your event reaches capacity" / "Zero for unlimited" / "Time allowed for attendees to claim their ticket"

### 8e. Capacity + waitlist + plus-ones in one settings panel (Partiful)
- Apps observed in: Partiful (web)
- Mobbin URL: https://mobbin.com/screens/6a0ac189-ab1e-4613-896d-5e7f91992216
- What it looks like / steps: "Event Settings → RSVPs": "Require Guest Approval", "Accept RSVPs" toggle (note: "By default, RSVPs close 3 hours after the event starts"), "Set Max Capacity — 10" with constraint note "Not supported with Guest Approval", "Enable Waitlist" toggle ("Allow guests to join a waitlist once max capacity is reached… automatically update their RSVP and notify them if spots open"), "Limit +1s — Up to 1" (how many extras each guest may bring), "RSVP Button Style — Emojis ▾" ("Not supported with Guest Approval"), "Allow Guests to Invite Mutuals" toggle ("Not supported when Guest List is hidden"). Event page behind shows a "10 spots" line item.
- Problem solved: feature-interaction conflicts ("Not supported with Guest Approval") are declared inline at the toggle instead of failing later; waitlist promises auto-promotion + notification.
- Sad paths: incompatibility notes are the sad-path design — settings that can't combine say so.
- Microcopy worth stealing: "By default, RSVPs close 3 hours after the event starts" / "Limit +1s" / "Not supported with Guest Approval"

### 8f. Manual override: add people directly past the gate (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/screens/c63fb370-fe68-4d1d-a699-84e10f1b062e
- What it looks like / steps: "Add People Directly" side panel: "They will be marked as approved immediately, without needing to pay or register." Toggle "Specify names for guests", "Guests to Add — Paste or enter emails here", "Add Guest To — Full Series ▾", consequence checklist: "We will let them know they have been added to the event." / "They will not need to pay or register." / "⚠ Please only add people who have consented to be added.", link "I want to invite guests to the event ↗", button "+ Add Directly".
- Problem solved: organizer bypass of capacity/approval is explicit about its side effects and consent; distinguishes "add directly" from "invite".
- Microcopy worth stealing: "Please only add people who have consented to be added."

### 8g. Capacity row inside ticket table (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2 (tickets step)
- What it looks like / steps: Tickets table (Admission / Add-ons / Promotions / Holds / Settings tabs) ends with a summary row "Event capacity ⓘ — 0 / 25 — Edit capacity" beneath per-ticket rows ("General Admission · On Sale · Ends Oct 18… · Sold 0/5 · $1.00"; "Student · Scheduled · Starts after General Admission · 0/20 · Free").
- Problem solved: event-level cap and per-ticket caps live in one table so oversell math is visible; ticket states ("Scheduled · Starts after General Admission") encode staged release.

---

## 9. Duplicate event / recurring event setup / event series

### 9a. Clone Event with explicit copy scope (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb ; same More-tab anatomy also visible in https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1
- What it looks like / steps: More tab section "Clone Event — Create a new event with the same information as this one. Everything except the guest list and event blasts will be copied over." + "Clone Event" button. Same page also holds "Event Page → Public URL lu.ma/ bffi7c7z [Update]" with warning "When you choose a new URL, the current one will no longer work. Do not change your URL if you have already shared the event." and upsell "Upgrade to Luma Plus to set a custom URL for this event.", plus "Embed Event" (Embed as Button / Embed Event Page) with copyable HTML snippet and a live "Register for Event" demo button ("This gives you the following button. Click it to see it in action!").
- Problem solved: clone scope (what copies, what doesn't) is stated before the click — no guest-list contamination surprises.
- Sad paths: the URL-change warning is a pre-emptive broken-link sad path.
- Microcopy worth stealing: "Everything except the guest list and event blasts will be copied over." / "Do not change your URL if you have already shared the event."

### 9b. Clone into N future dates ("Choose Times") (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb
- What it looks like / steps: Clone opens "Choose Times" modal: "Starting on — Mon, Dec 9 · 08.00", "Repeats — Weekly ▾", "Days of the week" pills (M highlighted), Until/For toggle set to "For > 6 weeks", a preview strip of generated date chips (DEC 9 MON, DEC 16 MON, +2, JAN 6 MON, JAN 13 MON), amber constraint note "You can add up to 6 times at once.", CTA "Add 6 Times" (count updates live). Confirmation sheet: "You've Cloned Tech Meetup — We've created 9 new events. You can open each of them below." with the event card and a tappable list of every new date ("Nov 18 Monday 8:00 AM ↗" …).
- Problem solved: recurrence implemented as bulk-clone of independent events — each date gets its own page; the receipt screen lists every artifact created.
- Sad paths: hard limit surfaced inline ("up to 6 times at once") before submission.
- Microcopy worth stealing: "You've Cloned {event} — We've created 9 new events. You can open each of them below." / "Add 6 Times"

### 9c. Event Series as a session list (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/flows/6e029388-0089-4fa3-bfbf-babcfe629ded , https://mobbin.com/screens/d0ccb229-b70a-472e-8daa-ea4622ef3774
- What it looks like / steps: In creation, toggling "Single Event | Event Series" swaps the date card for "Session Start Times": editable rows ("Thu, 8 June · 11:00 AM" with trash icon), "+ Add Session" and "🕐 Add Recurring Sessions" buttons, "Timezone: Los Angeles — Change", "Set Session Duration" button. Manage side shows a long session list with per-row delete (see 4a screen).
- Problem solved: a series is literally a list of sessions you can edit row-by-row, mixing manual dates with generated recurrences in one model.
- Microcopy worth stealing: "Session Start Times" / "Add Recurring Sessions" / "Set Session Duration"

### 9d. Recurring Series modal with cadence sentence + inline validation (Posh)
- Apps observed in: Posh (web)
- Mobbin URL: https://mobbin.com/flows/e0c4b2e2-d811-4457-8043-dfe07d025331
- What it looks like / steps: "Recurring Series" row on the Dates section (No/Yes). Modal: "Choose the cadence and length of your event series." Repeats "Every [1] [month ▾]" / On "[the 28th day ▾]"; "Ends" radio "On February 4th, 2026" vs "After [5] occurrences". Red inline error observed: "The end date must be at least one month after the start date." Below it a plain-language summary: "Repeats every 1 month on the 28th of the month until February 4th, 2026 (2 events)". After Save, the Dates row reads "Recurring Series — Yes / Repeats every 1 month on the 28th of the month until April 28th, 2026" with an edit pencil.
- Problem solved: recurrence rules are echoed back as a sentence with the computed event count, so RRULE mistakes are caught by reading.
- Sad paths: real validation error rendered inline in the modal (the only creation-form validation error observed in this sweep).
- Microcopy worth stealing: "Repeats every 1 month on the 28th of the month until February 4th, 2026 (2 events)" / "The end date must be at least one month after the start date."

### 9e. Repeats with end-condition fields (Circle)
- Apps observed in: Circle (web)
- Mobbin URL: https://mobbin.com/flows/22b4af6c-43fa-4ce7-9df0-7b822a93961e
- What it looks like / steps: "Repeats — Every Friday ▾" dropdown on the create form; when set, two extra fields appear: "Event ends — After ▾" and "Occurrences — 8". Published event page shows "Repeats every Friday — Show all events" link in the sidebar.
- Problem solved: minimal three-field recurrence; the public page links the series together.

### 9f. Single vs Recurring as a type decision (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/a8321be6-f638-4ba8-92c6-68db041b82b8
- What it looks like / steps: "Type of event" radio cards: "Single event — For events that happen once" vs "Recurring event [NEW] — For timed entry and multiple days".
- Problem solved: recurrence chosen as the event's identity up-front (it changes the ticketing model), not as a date option.

### 9g. Duplicate via context menu + toast (Amie, Skiff — context)
- Apps observed in: Amie (web) https://mobbin.com/flows/97ac1996-cdb7-4a47-900e-9480776ddf39 ; Skiff (web) https://mobbin.com/flows/256c3597-bc67-490f-ac21-a32a6a7acb4e
- What it looks like / steps: Amie: right-click event block → menu with color swatches + "Duplicate" / "Copy" / "Delete" → cloned block appears beside the original, toast "Created: …". Skiff: duplicated event appears adjacent with toast "Event duplicated — Copy of event added to your calendar."
- Notes: calendar-grade duplicate; recorded as context for interaction shape (instant clone + confirming toast).

---

## 10. Cancel event flow (organizer) / reschedule event notice

### 10a. Danger-zone cancel with customizable guest email (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1 , https://mobbin.com/flows/56954a40-0e2f-49b1-a87a-2a2d22eb69bc
- What it looks like / steps: More tab bottom section "Cancel Event — Cancel and permanently delete this event. This operation cannot be undone. If there are any registered guests, we will notify them that the event has been canceled." Red outline "Cancel Event" button → modal: "Cancel Event — If you aren't able to host your event, you can cancel and we'll notify your guests." with "Customize Email" toggle revealing Subject (prefilled "Tech Meetup was canceled") and Body ("Add your custom message here."), full-width red "Cancel Event", fine print under the button "The event will be permanently deleted." After confirm: back on the events list with green toast "Event canceled successfully!"
- Problem solved: cancellation = deletion + guest notification in one transaction; the organizer can shape the apology email at the moment of cancelling; consequence repeated at section, modal, and button level.
- Sad paths: this whole pattern is the sad path; permanence stated twice before commit.
- Microcopy worth stealing: "If you aren't able to host your event, you can cancel and we'll notify your guests." / "{Event} was canceled" (prefilled subject) / "The event will be permanently deleted."

### 10b. Series-aware cancel ("Cancel Series" vs per-session) (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/flows/56954a40-0e2f-49b1-a87a-2a2d22eb69bc
- What it looks like / steps: For a series, the danger zone reads "Cancel and permanently delete this series and all its sessions. This operation cannot be undone…" plus an escape hatch: "To cancel specific sessions instead of the whole series, please go to the Sessions tab and remove them from the schedule." Button label changes to "Cancel Series". Modal adds bold "This will permanently delete your event. It cannot be undone."
- Problem solved: prevents whole-series destruction when the organizer only meant one date.
- Microcopy worth stealing: "To cancel specific sessions instead of the whole series, please go to the Sessions tab and remove them from the schedule."

### 10c. Cancel with shared reason + canceled tombstone page (Cal.com)
- Apps observed in: Cal.com (web)
- Mobbin URL: https://mobbin.com/flows/f2adf995-c18d-4c0e-8f8c-969a16ca517e
- What it looks like / steps: Bookings list rows have inline "✕ Cancel event" + "Edit" buttons. Cancel page restates What/When/Who/Where + booking answers, then "Reason for cancellation" textarea with note "ⓘ Cancellation reason will be shared with guests", buttons "Nevermind" / "Cancel event". Result page: pink ✕ icon, "This event is canceled" (also seen as "This event is cancelled" dark variant), Reason shown first, date struck through ("Monday, April 28, 2025 / 1:00 PM - 2:15 PM (Pacific Daylight Time)" with strikethrough), all other facts preserved.
- Problem solved: the canceled event keeps a permanent, shareable tombstone page — anyone following a stale link sees what was canceled and why.
- Sad paths: strikethrough date = the canceled landing state.
- Microcopy worth stealing: "Cancellation reason will be shared with guests" / "This event is canceled" / "Nevermind"

### 10d. Cancel + reschedule pair with audit trail (Calendly)
- Apps observed in: Calendly (web)
- Mobbin URLs: https://mobbin.com/flows/b585ee1f-1669-49b5-a8d2-99c3d1f63e63 , https://mobbin.com/flows/7869f96f-d291-4c8d-b153-186a237641fc
- What it looks like / steps: Each scheduled event's Details exposes paired buttons "Reschedule" / "Cancel". Cancel modal: "Please confirm that you would like to cancel this event. A cancellation email will also go out to the invitee." + optional message textarea (e.g. "Apologies for this inconvenience, will update with a later time.") + "No, don't cancel" / "Yes, cancel". List afterwards shows the slot struck through with red note "Canceled by Samantha Lee: 'Apologies for this inconvenience…'". Reschedule path: booking-style picker; left panel shows the new time and "Former Time (John)" struck through beneath it; "Reason for change" textarea ("Mental health day of the week, my apologies - let's reschedule."), "Update Event" → green banner "Event rescheduled. A notification has been sent." and the list line "Rescheduled by Samantha Lee: '…'" in green.
- Problem solved: cancel and reschedule are symmetric verbs; both leave a who-did-it-and-why line in the list; reschedule shows old vs new time side by side before commit.
- Sad paths: cancel confirm leads with the safe option ("No, don't cancel").
- Microcopy worth stealing: "A cancellation email will also go out to the invitee." / "Former Time" / "Event rescheduled. A notification has been sent." / "Rescheduled by {name}: '{reason}'"

### 10e. Date-change update prompt to participants (Skiff — context)
- Apps observed in: Skiff (web)
- Mobbin URL: https://mobbin.com/flows/51792742-3b11-4828-a750-a0c2b14c2a85
- What it looks like / steps: After editing an event's date/time and hitting Update, modal: "Do you want to send an update to other participants? — An email will be sent to these participants of 'Potato Festival'." listing each participant with a red "NEW" badge, buttons "Back" / "Send".
- Problem solved: every date edit funnels through an explicit notify-or-not decision — the reschedule notice is impossible to forget, optional to send.
- Notes: calendar product, but this is the cleanest observed "reschedule notice" gate.

---

## 11. Event landing page anatomy + sold-out/past/cancelled states

### 11a. Dark flyer-led landing with avatar social proof (Posh)
- Apps observed in: Posh (web)
- Mobbin URLs: https://mobbin.com/screens/7840765d-4ad6-4a20-b3ac-f3b0076c2302 , https://mobbin.com/screens/441f86dd-896d-42b7-8898-182998c7db42 , https://mobbin.com/screens/2bbf4ac2-6531-4cd9-9dab-c7bb2caafa01
- What it looks like / steps: Full-bleed dark page; the 4:5 flyer floats top-right; left column stacks: org breadcrumb ("Monsta House Universe") with bookmark/share icons, all-caps display title, venue line ("87 George St"), "Sat, Jan 31 at 1:00 PM - 6:30 PM (EST)", one-line tagline, social-proof row "Terrence and 55 others going" with ~10 overlapping avatar circles, "About this event" rich text (with embedded YouTube video and photos), sticky full-width red "RSVP" pill at viewport bottom. Series variant shows a horizontal strip of date chips ("Jan 31 Sat · GMT+8 · 5:30-8:30PM" …) + "More Dates".
- Problem solved: page converts on vibe + social proof above the fold; sticky RSVP keeps the action available at any scroll depth.
- Sad paths: closed state swaps the sticky CTA for a disabled grey pill "Ticket sales are closed for this event" (page content intact; "View your ticket" stays top-right for holders). Referral block "Turn Invites Into Income — Invite friends, earn $8.00 per order" persists.
- Microcopy worth stealing: "{Name} and 55 others going" / "Ticket sales are closed for this event" / "Turn Invites Into Income — Invite friends, earn $8.00 per order"

### 11b. Two-column card landing: identity left, action right (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/screens/b520e950-3a01-4bff-994c-dcf66672257b , https://mobbin.com/screens/568e23ac-9a15-45a8-81f2-4c9612a2aca0 , https://mobbin.com/screens/fb172cac-fa93-407d-bb68-1dc4a27db64d , https://mobbin.com/screens/243fda9c-56e1-4ce4-bb3a-aedc92ddb7ef
- What it looks like / steps: Left column: square cover art, "Presented by {calendar} ›" row, "Hosted By" avatar list, "Contact the Host" link (one event also showed a "Donate" button under Hosts). Right column: status pill ("🔒 Private Event"), large title, date block with mini calendar tile ("Tuesday, November 12 · 5:00 AM - Nov 13, 6:30 AM GMT+7"), location/Zoom row, then the Registration card, then "About Event" rich text. Sidebar "Location" card: Google map embed + neighborhood ("SoHo — New York, NY, USA"). Organizer-view banner: "You have manage access for this event. [Manage]".
- Problem solved: a fixed grammar for every event page — visitors always find date/host/action in the same place; manage access surfaces in-context for hosts.
- States observed (sad paths first-class): countdown chips "Event starting in — 14h 23m / 17d 21h / Starting in 1d 1h"; virtual gate note "The join button will be shown when the event is about to start."; post-registration card replaces CTA ("You're In … Add to Calendar [Google/Apple icons] … Invite a Friend"); cancelled-registration state "You're Not Going — We hope to see you next time! Changed your mind? You can register again."; invite state "You are Invited — We'd love to have you join us." with Accept Invite / Decline.
- Microcopy worth stealing: "The join button will be shown when the event is about to start." / "Changed your mind? You can register again." / "Hosted By" / "Contact the Host"

### 11c. Scarcity + approval signal chips above the CTA (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b (event page screen)
- What it looks like / steps: Registration card stacks status chips before the button: "⏳ Limited Spots Remaining — Hurry up and register before the event fills up!" and "👤 Approval Required — Your registration is subject to approval by the host." For multi-session events: "This is a multi-session event. Please choose the sessions you would like to register for." with session date chips, then identity row + "Apply to Join" button.
- Problem solved: scarcity, approval friction, and session choice are disclosed before the click — urgency without surprise rejections.
- Microcopy worth stealing: "Limited Spots Remaining — Hurry up and register before the event fills up!" / "Your registration is subject to approval by the host." / "Apply to Join"

### 11d. Map embed with transport modes + RSVP stepper (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URLs: https://mobbin.com/screens/d9b43438-ab86-4c86-adf9-c3ed309f1651 , https://mobbin.com/screens/ff40256c-f77a-4002-9fbb-9d39ceaf641b
- What it looks like / steps: "When and where" section: two columns — "Date and time — Fri, Mar 3, 2023, 5:00 PM - Sat, Mar 4, 2023, 2:00 AM PST · More options ▾" and "Location — Monroe 473 Broadway San Francisco… · Hide map ^"; full-width Google map below with "How to get there" + four transport-mode icons (car / walk / transit / bike). Right rail: boxed RSVP card "RSVP for Free Entry [- 1 +] · Free ⓘ" + orange "Reserve a spot". "About this event" leads with chips "🕐 9 hours" and "🎫 Mobile eTicket". Hero variant: top-of-page cover image, "Mar 08" date kicker, H1, heart + share icons, price "Free", CTA "Reserve a spot".
- Problem solved: logistics anxiety (how do I get there, how long is it, what's my ticket format) answered as scannable chips; map is collapsible.
- Microcopy worth stealing: "How to get there" / "Mobile eTicket" / "Reserve a spot"

### 11e. Community event sidebar: Going + Add to calendar + time-gated link (Circle)
- Apps observed in: Circle (web)
- Mobbin URLs: https://mobbin.com/screens/34d3379d-4c2a-4cd9-9be2-745632a44eec , https://mobbin.com/screens/9d618768-5b49-4b8c-a933-44c951470207
- What it looks like / steps: Event post layout: cover with green "Starts in 3 days" chip, title + "Hosted by {avatar} {name}" (ADMIN badge), Details body, comment box. Right rail card: big date tile ("4 OCT"), "Friday, Oct 4 · 07:00 AM - 08:00 AM EDT", "Join virtual event" link, "Repeats every Friday — Show all events", "✓ Going ▾" status dropdown, blue "Add to calendar" button, Attendees avatar row, and for live streams: "The link to join this live stream will be available 25 minutes before the start of this event."
- Problem solved: RSVP state, calendar capture, and recurrence live in one persistent card; join-link gating sets expectations.
- Microcopy worth stealing: "The link to join this live stream will be available 25 minutes before the start of this event." / "Starts in 3 days"

### 11f. Minimal editorial hero + inline form (Sana AI)
- Apps observed in: Sana AI (web)
- Mobbin URLs: https://mobbin.com/screens/4e796609-f9f2-4f20-8cb0-70f794fe89ec , https://mobbin.com/screens/2e1f125d-238c-4770-94d0-bdff616ff172
- What it looks like / steps: Variant 1: full-viewport photo of a packed hall, centered title "Sana AI Summit 2024", single small pill "Register interest". Variant 2: typographic hero — date kicker "April 23, 8:30-10:30 AM", giant H1 "Building and scaling L&D", venue line "Lunar office, Bredgade 43, Copenhagen", two short editorial paragraphs, "Speakers:" list (name, title, company per line), then a registration form card (Email*, First name*) embedded directly in the page flow.
- Problem solved: conference-brand landing where the speaker list IS the social proof; inline form removes a click.
- Notes: speakers-list is the closest observed "agenda on landing page" — see coverage note.

### 11g. Virtual-event badge + share row (Product Hunt)
- Apps observed in: Product Hunt (web)
- Mobbin URL: https://mobbin.com/screens/5bd2c427-aae9-4dc9-bd0b-a798bd9618d8
- What it looks like / steps: Gradient hero with emoji art; H1; "US Product Hunt Chapter" link; "Wed, Apr 20, 6:00 PM (EDT)"; round share-icon row (Facebook/Twitter/LinkedIn/Pinterest/Email) directly under the date; outlined pill badge "Virtual event"; body sections "About this event" → "Nocode?" → "The deets".
- Problem solved: share buttons on the public page itself turn every visitor into distribution; "Virtual event" badge answers where-is-it instantly.

### 11h. Community/meetup page with anchor nav incl. Past events (Twitch)
- Apps observed in: Twitch (web)
- Mobbin URL: https://mobbin.com/screens/9a60ca6e-8d81-46c1-a870-a7ebb6404ed8
- What it looks like / steps: Photo hero ("United States of America / New York City"), social icon row, purple "Join Community" CTA, anchor nav "About · Upcoming events · Past events · Organizers · Photos", and a black notice banner "Meetups are now digital! Many of our MeetUps are meeting digitally… check out the Virtual MeetUps directory…"
- Problem solved: the landing page doubles as an archive (past events, photos) — proof-of-life for recurring communities; banner pattern for global schedule disruptions.

### 11i. Ended/past landing states (Eventbrite, X)
- Apps observed in: Eventbrite (web) https://mobbin.com/screens/6870b925-45a9-4663-9e42-2c272c403580 ; X (web) https://mobbin.com/screens/c3fbe3a2-bb2b-43ca-95b0-00e273dca849
- What it looks like / steps: Eventbrite past event: hero card retained with "View event details ↗"; the event card below carries a grey "ENDED" pill next to the title with the original date; "Organised by LEVEL" block keeps "Follow" and "Contact" CTAs. X live event modal: "ENDED" label above the title, Community + Host + Speaker rows, and the CTA becomes "▶ Play recording".
- Problem solved: a dead event page still converts — into a follow (Eventbrite) or a replay (X).
- Sad paths: this is the designed afterlife of the landing page; nothing 404s.
- Microcopy worth stealing: "ENDED" / "Play recording"

### 11j. Rejection notice (registration not accepted) (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/screens/35336890-aaec-4ec9-afba-6fb4ec33fd44
- What it looks like / steps: Email preview "Registration not approved for {event}": header "{Event} — Registration Not Accepted", body "Unfortunately, your registration for Morning Yoga was not accepted." + "Have questions? You can contact the host directly by replying to this email." Organizer side shows the guest's per-person email timeline (Event Invitation → Registration Confirmation → Registration Removed Notification) and a "Removed ▾" status with "rejected from all sessions of this series".
- Problem solved: the decline is soft, reply-able, and auditable per guest.
- Microcopy worth stealing: "Have questions? You can contact the host directly by replying to this email."

---

## 12. Events dashboard (upcoming vs past) / status badges / organizer home empty state

### 12a. First-run empty state that sells hosting (Luma)
- Apps observed in: Luma (web)
- Mobbin URL: https://mobbin.com/flows/675ec9d2-c295-497b-b519-447ade3fd56b (first screen)
- What it looks like / steps: "Events" page with Upcoming | Past pill toggle; empty illustration of a ghost event card with a "0" badge; "No Upcoming Events — You have no upcoming events. Why not host one?" + "+ Create Event" button (Create Event also persistent in the top nav).
- Problem solved: the empty dashboard is a conversion surface for the create flow.
- Microcopy worth stealing: "No Upcoming Events — You have no upcoming events. Why not host one?"

### 12b. Date-grouped timeline list with per-card status chips (Luma)
- Apps observed in: Luma (web)
- Mobbin URLs: https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1 (list screens), https://mobbin.com/screens/f129ba6f-f166-46f4-84c0-dfaaa3155024 (Past tab), https://mobbin.com/screens/c4314a68-0d09-41f7-9634-85996207d536 (discovery list)
- What it looks like / steps: Events on a vertical date spine ("Today Wednesday / Nov 18 Monday / …"), each card: time + timezone in amber ("5:30 PM · 6:30 PM GMT+8"), title, host line with avatars ("By Ted Johansson & Onur Ozer"), venue/Zoom row, guest state ("No guests" or avatar stack "+12"), grey "Manage Event →" button on owned events, green "Going" chip on attended ones. Discovery list cards carry scarcity chips: red "Sold Out" (card greyed/muted), amber "Near Capacity"; also observed "Not Going" and "Location Unavailable" chips. Past tab: same spine in reverse chronology with covers. Toasts land on this surface ("Event canceled successfully!", "Thank you for registering!", "Thank you for submitting your event!").
- Problem solved: one chronological spine serves organizer + attendee roles, with role-appropriate affordances per card; status chips do triage at a glance.
- Sad paths: "Sold Out" cards stay visible but visually muted rather than disappearing.
- Microcopy worth stealing: "Manage Event →" / "Sold Out" / "Near Capacity"

### 12c. Revenue-grade events table with filter + row actions (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URLs: https://mobbin.com/screens/3a6af7e7-ca6e-4417-aa6f-4759cf97a361 , https://mobbin.com/screens/839e9d79-bec7-4c55-9d58-6641950fc6d4 , https://mobbin.com/screens/a9414278-465d-47fe-91e8-d25723fed2f1 , https://mobbin.com/screens/3663e4a2-5630-483e-a16f-55a459e45775 , https://mobbin.com/screens/dcfe723d-2213-4592-84f1-ba76bb4712bb
- What it looks like / steps: "Events" page: search field, List | Calendar view toggle, status filter dropdown (Upcoming events / Draft / Past events / All events), orange "Create Event". Table columns Event / Sold / Gross / Status: each row shows date tile (APR 1), thumbnail, title, "Online event", datetime, "🔒 Private" badge; "Sold 2/40" with mini progress bar; "$0.00" gross; status dot + "On Sale". Kebab menu per row: Promote on Eventbrite / View / Edit / Copy URL / Copy Event / Delete. Footer "CSV Export". Promo banners slot above the table ("Advertise your event across Eventbrite…", "Timed Entry is here! 🎉").
- Problem solved: portfolio management — sales progress, status, and money per event in one scan; Draft is a filterable first-class status; duplicate ("Copy Event") lives in the row menu.
- Microcopy worth stealing: "Copy Event" / "On Sale" / "Sold 2/40"

### 12d. Organizer home with countdown, planner timeline, and phase meter (Eventbrite)
- Apps observed in: Eventbrite (web)
- Mobbin URL: https://mobbin.com/screens/944144ab-7283-47b6-be15-bee973984035
- What it looks like / steps: "Hey there, Sam" home. Hero card "Your event is happening in about 1 month" with the event row (MAY 01 date tile, "On Sale · Starts May 01… ", "8/20 Tickets sold"). "Planner" — a dated vertical timeline of suggested marketing actions ("{Event} is now live! Next, tell subscribers about your event by sending a 'Save the date' email.", "Start selling tickets… Send an email campaign to tell everyone that tickets are now on sale."). Below: "Event phase ⓘ" segmented progress bar "Early bird → Halfway there → Last call", then "Your checklist". Right rail: profile card "1 Total events · 1 Total followers", View / Edit / Copy Profile URL.
- Problem solved: the dashboard tells the organizer what to do next and where they are in the sales arc, not just what exists.
- Microcopy worth stealing: "Your event is happening in about 1 month" / "Early bird · Halfway there · Last call" / "Your checklist"

### 12e. Nightlife organizer dashboard: revenue chart + per-date RSVP/visit counters (Posh)
- Apps observed in: Posh (web)
- Mobbin URLs: https://mobbin.com/screens/7d7f34b7-8502-440b-bc06-015b5ff09da6 , https://mobbin.com/screens/3fad44f7-7615-425b-accb-68cd6e60007b
- What it looks like / steps: Overview: org header with gamified revenue ladder ("Apprentice ⓘ · $0 / $100,000" progress bar), stat tiles "EVENTS 4 / TOTAL ATTENDEES 3", "+ Create New Event", ticket-sales area chart (1W/1M/ALL toggles, hover tooltip "Jan 27 · 3"), "Orders" feed (buyer avatar, timestamp, event name, order #, amount, "View More"). Events section groups occurrences under "Event series:" parents with green "● Live" badges; each occurrence row: thumbnail, date ("January 31st 2026, 5:30 pm"), counters "3 RSVPs" / "13 Page Visits", icon actions (edit / view / duplicate / delete; a 🔥 icon on some rows). "View All Events" button below.
- Problem solved: per-occurrence funnel metrics (page visits → RSVPs) visible in the list itself; series grouped under one parent with shared Live status.
- Microcopy worth stealing: "Page Visits" as a list-level metric / "● Live"

### 12f. Hosting vs attending segmentation (Partiful, Cal.com, Calendly, Product Hunt)
- Apps observed in: Partiful (iOS) https://mobbin.com/flows/732d3782-570a-47cc-9a84-cd991745c03c ; Cal.com (web) https://mobbin.com/flows/f2adf995-c18d-4c0e-8f8c-969a16ca517e ; Calendly (web) https://mobbin.com/flows/b585ee1f-1669-49b5-a8d2-99c3d1f63e63 ; Product Hunt (web) https://mobbin.com/screens/cbe1206d-cf0e-4863-9c13-9e799f28919f
- What it looks like / steps: Partiful home: greeting "Welcome to Partiful, Sam!", filter chips "Upcoming 1 · Hosting 1 · Open in…", event card with date overlay chip "Sat 8/30 · 9pm ET" + gold "👑 HOSTING" badge; the empty slot is a dashed-border "+ New event" placeholder card (empty state = the create button itself). Cal.com Bookings tabs: "Upcoming / Unconfirmed / Recurring / Past / Canceled" with per-row Cancel/Edit. Calendly Scheduled events tabs: "Upcoming / Pending / Past / Date Range" + filter bar (Teams, Host, Event Types, Status, Invitee Emails) and end-of-list line "You've reached the end of the list". Product Hunt events index empty state: "Upcoming Events" + city search + "There are no upcoming events."
- Problem solved: role (hosting vs going) and lifecycle (upcoming/past/canceled/unconfirmed) are first-class filters everywhere; empty states stay honest.
- Microcopy worth stealing: "HOSTING" badge / "You've reached the end of the list" / "There are no upcoming events."

### 12g. Calendar-view dashboard variant (Circle)
- Apps observed in: Circle (web)
- Mobbin URL: https://mobbin.com/flows/22b4af6c-43fa-4ce7-9df0-7b822a93961e (calendar + space screens)
- What it looks like / steps: Events area with grid/list/calendar view-toggle icons + "Public" filter + "New event" button; month grid (September 2024) with today highlighted. Space-level events tab shows "Upcoming | Past" pills and a "Next event" featured card ("Starts in 3 days" chip, "Live Stream" chip, host chip, "Going ▾" dropdown, "Add to calendar" link, "···" menu); empty state is a plain grey bar "No upcoming events".
- Problem solved: same data as 12b/12c reprojected as a calendar for cadence-minded communities; the next event is promoted as a hero card instead of a row.

---

# COVERAGE NOTE — every query run

Method: mcp__mobbin__search_flows (limit 3-4) + mcp__mobbin__search_screens (limit 8-10, mode deep). Stop rule per family: stop when further queries returned only already-seen apps/patterns or the family was saturated across 3+ apps. A connection reset occurred after family 7 was written; families 1–7 queries were reconstructed from the first pass (entries themselves all carry mobbin_urls).

Queries — families 1–7 (first pass):
1. flows web "creating an event as an organizer with event details form" — HIT (Circle ×3, Luma)
2. flows ios "create event flow with title date location on mobile" — WEAK (Amazon Alexa, Canopi, KakaoTalk — calendar apps, recorded as context only)
3. flows ios "host creates a party event and publishes invite page Partiful" — HIT (Partiful ×3 flows)
4. screens web "choose cover image for event from gallery or AI generated artwork" — HIT (Eventbrite ×4, Posh ×2, Circle, Notion)
5. screens web "Luma event create page generate AI cover image and theme picker" — TIMED OUT, not retried (Luma AI-cover therefore unobserved — gap)
6. screens web "event page theme customization color and font picker for organizer" — ANALOGOUS HIT only (Later, SavvyCal ×2, Linktree ×2, Gamma, Frame.io, HoneyBook; zero event-native results)
7. screens ios "party event theme picker with animated backgrounds and effects" — HIT (Partiful ×5; Telegram/Kahoot noise)
8. screens web "event start end date time picker with timezone selection" — HIT (Luma ×2, Eventbrite, Vimeo, Calendly ×2, Teachable, Proton)
9. screens web "event location field with address autocomplete map or online event link" — HIT (Eventbrite ×4 incl. AI wizard, Luma ×3, Square)
10. flows web "publishing an event choosing public or private visibility" — HIT (Vimeo, Circle, Eventbrite, Aboard)
11. flows web "sharing event link after publish with social share options" — HIT (Eventbrite, Luma ×2, Later)

Queries — families 8–12 (second pass):
12. screens web "organizer settings for event capacity limit and waitlist toggle" — HIT (Partiful, Eventbrite, Luma ×6)
13. flows web "organizer cancels an event with confirmation and notifying guests" — HIT (Luma ×2, Cal.com, Calendly)
14. flows web "duplicate an existing event or set up recurring event series" — HIT (Luma ×2, Posh, Amie)
15. screens web "public event landing page hero with cover date register button guest avatars" — HIT (Posh ×2, Eventbrite, Sana AI ×2, Product Hunt ×2, Luma ×2, Twitch)
16. screens web "event page sold out past event ended or registration closed state" — HIT (Posh ×2, Eventbrite, X, Luma ×4, Cal.com, Calendly)
17. screens web "event page with add to calendar button countdown schedule agenda hosted by section" — HIT (Luma ×7, Circle ×2, Eventbrite)
18. screens web "organizer dashboard list of my events with draft live past status badges and empty state" — HIT (Eventbrite ×6, Posh ×2)
19. flows web "reschedule event new date notify attendees date changed notice" — HIT (Calendly reschedule flow, Skiff ×2)

Families THIN or with gaps (no silent truncation):
- Family 2 — AI cover generation: no event-native AI cover generator observed; the Luma-targeted query (Q5) timed out and was not retried. Notion AI (analogous) is the only AI-cover anatomy recorded. GAP.
- Family 3 — theme/color/font: event-native evidence limited to Partiful (font tabs, theme/effect trays) and Posh (Title Font + Accent Color). Token-level theming evidence is all from analogous products (Later/Linktree/SavvyCal/Gamma/Frame.io/HoneyBook). THIN for event platforms.
- Family 1 iOS: only Partiful surfaced as an event-product creation flow on iOS; generic queries returned calendar apps. THIN on iOS.
- Family 11 — schedule/agenda block on landing page: no hour-by-hour agenda module observed; closest are Sana AI's speakers list and Luma's multi-session chooser. GAP.
- Family 11 — countdown: observed only as relative-time chips ("Starts in 3 days", "Event starting in 14h 23m"), never as a big-numeral countdown timer module. THIN.
- Family 10 — public-facing reschedule notice (a "new date" banner on the landing page itself): not observed; evidence is organizer/invitee email + audit-trail lines (Calendly) and a notify-participants modal (Skiff). GAP.
- Families 4, 5, 6, 7, 8, 9, 12 — SATURATED (3+ apps each, multiple variants, sad paths recorded).
- Out of scope per brief (seen in returned flows but deliberately not recorded as patterns): attendee registration/RSVP form internals, checkout/payment, post-registration confirmation/QR — referenced only where they define landing-page states.
