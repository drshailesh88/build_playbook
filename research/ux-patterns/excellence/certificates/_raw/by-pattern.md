# BY-PATTERN Raw Harvest — Certificates / Credentials

Job: design a certificate/credential template → issue at scale to recipients → recipient receives/downloads/shares → anyone verifies authenticity → admin manages lifecycle (revoke/reissue/expire).
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## P1 — Field-palette document editor with merge fields / data fields

**Apps observed:** Contractbook, Workable, Docusign, Square, Ditto, Employment Hero, Kit, Customer.io
**URLs:**
- Contractbook "Adding fields" flow: https://mobbin.com/flows/6f5d8a4e-f906-4da1-98be-22fd44b6ff9a
- Workable "Adding profile fields" flow: https://mobbin.com/flows/7dcc4698-2ff3-41e1-8efb-65f69e18361e
- Docusign "Adding fields" flow: https://mobbin.com/flows/568bf51e-01d3-4a2f-aaf2-d9703ec6a243
- Square "Adding a custom field" flow: https://mobbin.com/flows/43ccd475-8e2a-404a-a058-110b943e034b
- Workable field-placement screen: https://mobbin.com/screens/caa42353-b2ee-4519-99d7-47e0f75fcc34
- Docusign field-palette screen: https://mobbin.com/screens/005bf6b6-465e-4d45-8e40-484511839088
- Ditto "Add variable" modals: https://mobbin.com/screens/2b141851-1e98-431e-975b-ea0b09f391bf , https://mobbin.com/screens/3b29c84f-77bb-4062-bca5-616d83a9a1f5 , https://mobbin.com/screens/0c1a0b2b-110c-4cf6-be62-c2bf92d66f12 , https://mobbin.com/screens/5c45f5d6-2094-4258-b801-0754833abfa1 , https://mobbin.com/screens/fed13aaf-c990-4408-937b-19db6f222e6e
- Employment Hero template editor with Variables panel: https://mobbin.com/screens/527b14ef-fd1f-4b0c-9145-726550a744b5
- Kit snippet "+ Personalization": https://mobbin.com/screens/5276c581-b0d9-4bc6-9776-5e119d9e0f86
- Customer.io merge-tags toolbar: https://mobbin.com/screens/2f8eb1e5-ec79-4a97-acab-dc2c16ad64b5

**Anatomy as observed:**
1. Contractbook: rich-text document in center; right rail "Data fields" panel; bracket placeholders in body text (`[Disclosing Party Name]`, `[Date]`); inserted fields render as colored inline chips ("Principal address", "Agent address"); empty panel state → "Add fields" button.
2. Docusign: left sidebar field palette with search ("Search Fields") grouped Standard Fields (Signature, Initial, Stamp, Date Signed / Name, Email, Company, Title / Text, Number, Checkbox, Dropdown, Radio / Drawing, Formula, Attachment, Note); recipient selector dropdown at top ("Alex Smith"); fields drag onto PDF canvas as teal boxes; right rail per-field properties (Required Field checkbox, Formatting, Data Label, Tooltip, Location; "SAVE AS CUSTOM FIELD" / "DELETE" buttons); footer Back / Send; coach mark "Assign fields — Assign specific fields for each recipient." [Hide All / Continue].
3. Workable: 4-step wizard with left checklist — Edit template details → Select signers → Select profile fields (searchable checkbox tree: Personal, Job, Compensation & benefits, Legal documents > ID documents, Citizenship, Passport, Work visa, Driver license…) → Place profile fields (left palette with Signer dropdown, signature fields, auto-fill fields; fields placed as cyan boxes on doc; right rail "Assigned to" + Required + Field name); ends with success screen.
4. Square: contract built from clause library — checkbox cards per clause with "Clone & edit"; "Add new clause" / "Add new custom fields" buttons; custom field editor with right rail type config (Dropdown: Question, Options, Required toggle); "Not selected" library section below.
5. Ditto: "Add variable" modal — Folder picker, Name combobox ("Create: 'company'" inline-create), Type (String), Example, **Fallback (Optional, "Enter fallback…")**; primary button "Create and add variable".
6. Employment Hero: WYSIWYG letter template with variables as blue highlighted tokens inline (Organisation name, Recipient's Name, Employment Start Date…); right "Variables" panel = searchable table (Name / Type: String, Date / Actions: "Use"); "+ Add" custom variable; "Save and Preview" CTA; "Walkthrough" pill in breadcrumb.

**Problem solved:** lets an admin lay out a reusable document and bind per-recipient data without code.
**Sad paths observed:** none surfaced in-editor beyond required-field config; Ditto's Fallback field is the explicit blank-data safety net.
**Microcopy worth stealing:**
- "You haven't added data fields in this document. Choose fields to add or use the recommended ones." (Contractbook)
- "Assign fields — Assign specific fields for each recipient." (Docusign)
- "Success! Your template setup is all done. The template will be ready for use after you close this window." (Workable)
- "Choose or create a variable to insert into this text item." + "Fallback (Optional)" (Ditto)
**A11y/notes:** all use persistent side panels rather than floating toolbars; field chips are color-coded per signer/recipient.

---

## P2 — Form-driven certificate editor with live sample-data preview

**Apps observed:** Teachable, Deel, Kajabi
**URLs:**
- Teachable certificate editor (Content tab): https://mobbin.com/screens/141ab4d3-0b79-4666-ba71-a0c493b06a60 , https://mobbin.com/screens/f26835b4-1101-493a-acb5-97e0a862012a , https://mobbin.com/screens/6a6a7cc8-670d-46b2-bae1-309560e497aa , https://mobbin.com/screens/182eef8d-d250-4e2d-bbed-fc01021ec8f5
- Teachable Design tab: https://mobbin.com/screens/40728ba3-3120-44e0-9b59-7abc250a0d8d , https://mobbin.com/screens/476bee55-483d-4e65-9e52-276453c6c9be
- Deel "Creating a certificate" flow (3-step wizard): https://mobbin.com/flows/e75e5b29-6ae8-4424-ab8f-8c525fdde012
- Deel certificate template detail: https://mobbin.com/screens/a0d68988-e0a5-4b6a-9b9f-2f4c9249347c
- Kajabi certificate with placeholder name: https://mobbin.com/screens/62689075-08ba-4c91-b529-be65b01865c5

**Anatomy as observed:**
1. Teachable: left rail with two tabs — **Content** (Logo upload "Size: 300x300px (PNG, SVG)", Title "Certificate Of Graduation", Subtitle "Awarded To", Graduating From, Date Label, Signature upload "Optional. Size: 300x300px (PNG, SVG)", Serial Number Title "Serial No.") and **Design** (Background Color / Primary Text Color / Secondary Text Color hex inputs with swatches). Center canvas renders the live certificate with sample data ("Sam Lee", "Date: 2025-01-07", "Serial No. cert_123456789"). Top bar: "• Saved" indicator, "Preview", green "Finish".
2. Deel: wizard steps Certificate details → Design & review → Certificate settings (right step-tracker card, "COMPLETED" check on done steps, footer "Step 2 of 3 / Next: Certificate settings"). Design step = radio groups Orientation (Landscape/Portrait), Layout (Left aligned/Centered/Right aligned), Colors (Text #000000, Background #ffffff), Logo upload ("Supported file formats: PNG, JPG; Maximum file size: 10MB"), then Preview card rendering sample recipient "John Doe".
3. Deel template detail page: big preview, Title, Description, metadata row — Status "Draft" badge, Created by, Last edited on, **Validity "∞ Unlimited"**, Issuing Authority, Endorsed by; tabs "Awarded certificates (0)" / "Resources (0)"; Edit button.
4. Kajabi: rendered certificate uses literal placeholder "[Name of Student]" + "Certificate no. 706f42c2" footer.

**Problem solved:** non-designers produce an on-brand certificate by filling fields, with instant WYSIWYG proof using sample data.
**Sad paths observed:** upload constraints stated inline (file format/size); none beyond.
**Microcopy:** "Certificates are personalized documents awarded to learners upon the successful completion of learning resources." (Deel); "Awarded To"; "Serial No."
**Notes:** both Teachable and Deel constrain design to a parametric template (colors/layout/logo) rather than free canvas — strong scope precedent for v1.

---

## P3 — Template gallery / "start from template"

**Apps observed:** Lovable, Adobe Express, Postman, Coda, Frame
**URLs:**
- Lovable Templates flow: https://mobbin.com/flows/affcadd6-8405-4a2e-91de-550f5530b608
- Adobe Express Templates flow: https://mobbin.com/flows/e96ed881-58f4-4e52-a792-715f2dc890c6
- Postman "Choosing a template" flow: https://mobbin.com/flows/53bb52bb-53e5-4d94-b267-74396f69e271
- Coda "Choose a starting template" bar: https://mobbin.com/screens/d6beb6c7-5eb2-4f38-aeea-24a661aca652 , https://mobbin.com/screens/eede8ffc-8610-481a-a7db-c12c70eb4614
- Frame empty-folder template entry: https://mobbin.com/screens/d554032b-7553-4911-a891-9250d970deee

**Anatomy as observed:**
1. Lovable: Templates page — header "Start from a template to build your next project"; card grid, each = large thumbnail + name + one-line descriptor ("Event platform — Find, register, create events").
2. Adobe Express: Explore page with left filter rail (Price, Output, Size, Type, Style, Mood, Region), quick-filter chips (resume, business card, logo, invoice…), curated rows "Popular templates", "Layouts", "Seasonal moments"; category tabs (Templates, Photos, Backgrounds, Text layouts, Webpage templates); webpage templates grouped by Business / Education / Event.
3. Postman: template browser modal — left categories (Roles, Use cases), template detail pane with Overview, screenshot, Tags, "Recommended for", orange "Use Template" CTA.
4. Coda: new doc opens with bottom bar "Choose a starting template" + chips (Tasks, Meeting notes, Two-way writeup, Team sentiment) + "More templates".
**Problem solved:** removes blank-canvas paralysis; sets quality floor at start.
**Microcopy:** "Start from a template to build your next project" (Lovable); "Use Template" (Postman).

---

## P4 — Brand kit: store logo/colors/fonts once, apply everywhere

**Apps observed:** Canva, VEED, HubSpot, GoDaddy, Square
**URLs:**
- Canva Brand Kit empty: https://mobbin.com/screens/886a741b-5211-4dc3-9b41-b33f3c6418dc
- Canva auto-extracted palette from uploaded logo: https://mobbin.com/screens/82e4f1bb-6b61-4ce6-a7a8-d7e5084bd524
- Canva populated kit: https://mobbin.com/screens/b132e8d2-0f87-46a1-8ea3-91f9142f4aa2
- VEED Brand Kit (gated/upsell): https://mobbin.com/screens/ea4c7ce0-6191-4360-ba95-315783f64e69
- HubSpot "My brand kit" settings (Logo/Colors/Themes tabs): https://mobbin.com/screens/d2fd4fc9-0621-4b11-b4ce-2cc1cf28ab49 , https://mobbin.com/screens/acfd614b-c681-452f-b5e1-5ea157902d2c
- GoDaddy editor with Brand Kit rail applied: https://mobbin.com/screens/f5fc9dd5-718e-42b4-83f2-af176b2ad73a
- Square onboarding "Add branding": https://mobbin.com/screens/9685742d-e93c-4296-a33c-e11265f13002

**Anatomy as observed:**
1. Canva: sections Logos ("Add a logo or just drag and drop one"), Colors ("Color palette", + Add new; uploading a logo auto-creates "Colors from 1.png" #000000/#ffffff; "Add palette" popover with search "Try 'Blue' or 'Pastel'" + preset palettes), Fonts (Title / Subtitle / Heading slots).
2. HubSpot: form-style — Logo name*, Logo alt text, Logo URL, Width/Height (lock ratio), Favicons section ("You haven't added any favicons yet."); footer Save/Cancel + "You've changed 1 setting."
3. Square: wizard step "Add branding — Edit logo and color": Full logo ("A large format version of your logo."), Small logo ("A smaller, thumbnail version of your logo."), Color #546476 ("A primary color, used for buttons and headers."); Skip / Next. Copy: "Your logo and color will be reflected across Square, including on your receipts, Invoices, loyalty campaigns… and anywhere else your customers interact with Square."
4. GoDaddy: in-editor left rail "Brand Kit" tab shows Logos / Colors / Fonts (Heading, Subheading, Paragraph) that restyle the canvas.
**Problem solved:** one-time brand setup propagates to every issued artifact (certificate, email, page).
**Sad paths:** VEED gates the whole feature behind upgrade ("Upgrade to Build Your Brand Kit").
**Microcopy:** "Keep your videos on brand with Brand Kit. … Set your brand's fonts, color schemes, and logo, and apply them to all your videos." (VEED); Square's "anywhere else your customers interact with" framing.

---

## P5 — CSV import wizard: upload → map columns → review values → import

**Apps observed:** Attio, Height, Customer.io, Rox, Cloaked
**URLs:**
- Attio "Resolving issues (import)" flow: https://mobbin.com/flows/535a7828-5915-47a2-b782-c6bfd708adc0
- Height "Mapping attributes" flow: https://mobbin.com/flows/71d21f5c-123c-4071-9879-6cd7bd270d71
- Customer.io "Mapping fields" flow: https://mobbin.com/flows/246ac8d9-3fc6-42e1-a04c-aede744f7879
- Rox "Adding contacts with CSV" flow: https://mobbin.com/flows/e88d71cc-ca76-4aec-848f-01c78fc7b29c
- Cloaked "Review & import identities": https://mobbin.com/screens/ccc17b58-9bad-4469-8b4c-04211c519f0b

**Anatomy as observed:**
1. Attio (gold standard): stepper "1 Upload file → 2 Map columns → 3 Review values → 4 Preview import". Review step: left column list (each CSV column → mapped attribute, orange dot = needs attention); right table Raw data → Mapped value, grouped "Automatically mapped 3" / "Needs review 3"; inline cell fix UI ("Invalid domain" red chip; "+ Add domain"); select-type columns offer "+ Create 3 missing select options" and per-value mapping pickers.
2. Customer.io: steps "1. Upload CSV → 2. Map fields → 3. Review". Upload state "Uploading… We're processing your upload. It shouldn't take too much longer…"; Map fields = card per column with 2 sample rows + "MAP TO ATTRIBUTE" dropdown (badges: Identifier, Reserved, Required); unchecked column → "This column will be skipped"; Review = green "Success! We found 2 new people to add from your CSV. Learn more about data validation." + stat tiles NEW PEOPLE / EXISTING PEOPLE / ID CHANGES / WARNINGS / ERRORS (errors in red) + "How was this calculated?" links + optional "Add 2 people to a segment" + "Complete import".
3. Height: modal "Attributes — CSV → Height"; warning "⚠ Unmapped attributes will not be imported."; per-attribute dropdown incl. "+ Create new attribute…"; value-level mapping (Workload by Status: 10→Done, 2→In progress, 1→New requests); blocking dialog "Missing attribute mappings. To continue, please make sure Tasks attribute is mapped to the task name." [Okay].
4. Rox: "Get started" panel — Contact search / Manual account + contact search / **Upload contacts CSV** ("Use an existing CSV file or upload a new one"); after upload, toast "CSV Uploaded — We are parsing the CSV and adding contacts to the campaign. This may take a few minutes…"; contacts table with status tabs All / Not Started / Active / Completed / Bounced / Verification Failed / Needs Attention, rows flagged "Enrichment failed".
5. Cloaked: review table with per-row status chips "Needs review" / "No issue", tabs All / Needs review / Duplicates / No issue, CTA "Import 3 identities".
**Problem solved:** bulk recipient onboarding with per-row validation before anything is sent.
**Sad paths observed:** invalid domain per-cell error (Attio); unmapped → skipped warning (Height, Customer.io); missing required mapping blocks continue (Height); post-import row failures ("Enrichment failed", "Verification Failed" tab in Rox); duplicate detection tab (Cloaked).
**Microcopy:** "Unmapped attributes will not be imported."; "Success! We found 2 new people to add from your CSV."; "This column will be skipped."; "We are parsing the CSV… This may take a few minutes…"

---

## P6 — Bulk/background job progress with per-item status

**Apps observed:** AWS (S3), PandaDoc, Jira, mymind, Profound
**URLs:**
- AWS upload status (in progress): https://mobbin.com/screens/d0b2a1fa-99a9-4c29-ba83-f77a3f850d40
- AWS upload status (done): https://mobbin.com/screens/0dc7a3c3-26ec-45a8-8a79-69bb9fce85e8
- PandaDoc bulk import "Imported 1 of 4 files": https://mobbin.com/screens/f7443f66-5e59-433b-a611-deebd86db562
- Jira "Export progress": https://mobbin.com/screens/ac622c55-a317-42ef-8bc2-9440231108a6
- mymind transfer modal: https://mobbin.com/screens/c137a287-7fa4-44db-9dda-00dabceafd00
- Profound workflow progress rail: https://mobbin.com/screens/4817b93e-bb57-4ae1-8948-9f60aca1e116

**Anatomy as observed:**
1. AWS: top blue progress banner (65%, "Total remaining: 2 files, 2.4 MB", est. time, transfer rate, Cancel); Summary card with **Succeeded (2 files, 65.26%) / Failed (0 files, 0%)**; per-file table with Status column (Succeeded / In progress (58%) / Pending) + Error column; info banner "After you navigate away from this page, the following information is no longer available."; green completion banner "Upload succeeded".
2. PandaDoc: list of files each with spinner + state line (Imported / Processing. / Uploading 90%); "Imported 1 of 4 files" header; "Keep this window open so your bulk import can continue uninterrupted."; Cancel import.
3. Jira: "Export progress — 1 out of 1 rules completed." + "This shouldnt take long! You can navigate away and come back once the task has completed." (navigate-away allowed variant).
4. mymind: blocking modal "Mind transfer in progress… Do not close this window otherwise your mind transfer will be interrupted." + "69% completed."
5. Profound: right rail "Workflow Progress 0/3 completed", step checklist with running spinner ("Running: Starting workflow"), explainer "Track the real-time progress of your workflow steps here. Completed steps are marked in green."
**Problem solved:** trust during long-running batch issuance — show aggregate %, per-item state, and failure isolation.
**Sad paths:** Failed counter + per-row Error column (AWS); explicit ephemeral-status warning (AWS); both "don't close" and "safe to navigate away" conventions exist — pick one and say it.

---

## P7 — Per-recipient delivery log with status + resend

**Apps observed:** Customer.io, Klaviyo, Luma, Outseta, AutoSend, Docusign
**URLs:**
- Customer.io campaign Sent log: https://mobbin.com/screens/dc4b82d5-e361-499f-8bde-c52fd44308b2
- Customer.io Deliveries & Drafts: https://mobbin.com/screens/118bd6e2-4d84-4125-a435-6d378761f8f2 , https://mobbin.com/screens/cabbec59-52b8-4c0b-b2e3-698963d032f3
- Luma Email Stats popover: https://mobbin.com/screens/50740c5b-cfba-47d6-8f87-3114eecced4d , https://mobbin.com/screens/68e726c3-fdf2-49b4-a01c-6b0e5f3e7b14
- Outseta Email Broadcasts table: https://mobbin.com/screens/804d7517-45f2-4592-b486-b73f3c919817
- Klaviyo Recipient activity: https://mobbin.com/screens/9d192110-19db-4ba9-81df-dadbbca83cb1
- AutoSend Email Activity: https://mobbin.com/screens/a4d2df4a-8bb7-4a9d-951b-74bf171e8b8f
- Docusign All Agreements (Resend per row): https://mobbin.com/screens/95095b2b-c994-4362-8ba1-0decd846c413

**Anatomy as observed:**
1. Customer.io: table Date / Action / Recipient / Status (Bounced, Clicked, Delivered, Opened chips); row expands to event timeline ("Created today at 11:11:53 am → Sent 2 minutes later → Bounced 2 minutes later — Reason: No MX for topmailers.net") with **Resend** button; filters (channel, status, date range), "Auto refresh On", "Export to CSV".
2. Klaviyo: left status facets with counts (Sent 3 / Opened 1 / Clicked 0 / Bounced 0 / Unsubscribed 0 / Marked as Spam 0 / Skipped 1) + recipients table (Opens, Clicks, Conversions) + Export CSV.
3. AutoSend: stat tiles across top (REQUESTS, SUPPRESSED, SENT, DELIVERED 100%, BOUNCED 0%, SPAM REPORTS) + activity feed rows STATUS + email + subject + timestamp.
4. Luma: "Email Stats" popover — Open Rate bar, "2 Opened • 4 Delivered", recipient list with per-person Delivered/Opened chips, "See Email" button.
5. Docusign: agreements list with per-row mini progress line + status text ("Need to sign", "Waiting for Alex Smith") and per-row **Resend** button.
**Problem solved:** the admin's "did everyone get their certificate?" answer in one table, with per-recipient remediation.
**Sad paths:** Bounced with human-readable reason; Suppressed/Skipped states; resend as the universal fix.
**Microcopy:** "Reason: No MX for topmailers.net"; status vocabulary worth copying: Sent / Delivered / Opened / Clicked / Bounced / Suppressed / Skipped.

---

## P8 — Public certificate page (recipient-shareable, verifier-readable)

**Apps observed:** Uxcel, Udemy, Codecademy, Deel
**URLs:**
- Uxcel public certificate page: https://mobbin.com/screens/246e28d8-6e0a-4eb6-bf07-a5ebd26df292 , https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7
- Udemy certificate page: https://mobbin.com/screens/012847af-953b-4b6b-b9ca-b8fb4692e0aa ; share popover: https://mobbin.com/screens/6f26edde-fdbb-4cbd-aace-e3161e09fe04 ; flow: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d
- Codecademy certificate modal: https://mobbin.com/screens/93071642-c4dc-42ec-bd64-ff93afb7646e

**Anatomy as observed:**
1. Uxcel: full-bleed certificate render (with QR code + "ID: 9S4VANBUF1U" + issue date printed on the artifact); under it buttons "Share on LinkedIn" (primary, repeated in page header), "Download Certificate", "Add to LinkedIn", overflow "…"; right rail: "Issued to — Jane Doe ✅ Credentials Verified", "This course certificate of completion was issued on May 7, 2024. **Does not expire.**", "Course completed" card, "Issued on" date, plus "Rate this course" block.
2. Udemy: certificate render carries "Certificate no: UC-9582e423-…", "Certificate url: ude.my/UC-…", "Reference Number: 0004" in its corner; right rail "Certificate Recipient" + "About the Course" cards; buttons Download / Share (popover: Facebook, Twitter, LinkedIn); footer verification sentence: "This certificate above verifies that Jane Doe successfully completed the course … on 06/25/2023 as taught by Duncan Koerber on Udemy. The certificate indicates the entire course was completed as validated by the student."; link "Update your certificate with your correct name or preferred language."
3. Codecademy: modal certificate (QR + serial + signature blocks) with "Save as PDF", "Add to Profile" (LinkedIn), and "Edit Name" link.
**Problem solved:** one canonical URL that is simultaneously the recipient's trophy and the third-party verifier's proof.
**Sad paths:** name-correction escape hatch (Udemy "Update your certificate", Codecademy "Edit Name") — reissue-lite.
**Microcopy:** "Credentials Verified"; "issued on May 7, 2024. Does not expire."; Udemy's full verification sentence; on-artifact "Certificate no / Certificate url / Reference Number" trio.

---

## P9 — Recipient claim/unlock ceremony (confirm name → generate)

**Apps observed:** Uxcel, Udemy
**URLs:**
- Uxcel "Unlocking a certificate" flow: https://mobbin.com/flows/a2e3dcaf-c6ed-4bbc-af0a-818f566e1c33
- Udemy "Get certificate" entry point: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d (screen 1)

**Anatomy as observed:**
1. Uxcel: full-screen takeover with locked-certificate illustration ("Ready to unlock") → headline "Unlock your certificate — Your certificate demonstrates that you learned new design skills, so share this achievement with the world." → [Unlock] → modal "Add your full name — Please add or review your name and then we'll generate your shareable certificate." with Full Name input and disabled "Generating…" button → toast "Generating certificate, please be patient." → lands on public certificate page (P8).
2. Udemy: in-course dropdown "43 of 43 complete. → Get certificate" button.
**Problem solved:** guarantees the name on the artifact is right *before* generation, and turns issuance into a reward moment.
**Sad paths:** name review is the explicit guard against the #1 certificate defect (misspelled name).
**Microcopy:** "Please add or review your name and then we'll generate your shareable certificate."; "Generating certificate, please be patient."

---

## P10 — Share to LinkedIn: post celebration + Licenses & Certifications entry

**Apps observed:** LinkedIn, Uxcel, Udemy, Codecademy
**URLs:**
- LinkedIn "Creating a post (Celebrate an occasion)" flow: https://mobbin.com/flows/fa7ca86e-d394-4fab-b81f-4f0f4cd72ce6
- LinkedIn "Adding a profile section" flow (Add license or certification modal): https://mobbin.com/flows/d97a84bf-7296-41d6-847b-34a7b5c016b2
- LinkedIn public profile settings (Licenses & Certifications visibility + "Public Profile badge — Create a badge"): https://mobbin.com/flows/f54be105-7a32-47b5-bd9f-a8aebba7bb43

**Anatomy as observed:**
1. Celebrate post: Create a post modal → occasion template gallery (illustrated cards) → composed post with illustration + autotext → success toast "Post successful. View Post".
2. **Add license or certification modal** (the integration target for any "Add to LinkedIn" button): fields Name*, Issuing organization* (typeahead with org logos), checkbox "This credential does not expire", Issue date (Month/Year), Expiration date (Month/Year), **Credential ID**, **Credential URL**, Save. Profile then renders "Licenses & Certifications — Certified Associate in Project Management (CAPM), Project Management Institute, Issued Jan 2021 · Expires Jan 2026".
3. "Add to profile" sheet groups Core / Recommended ("Add licenses & certifications") / Additional.
**Problem solved:** defines exactly which fields EventState must mint per credential (ID, URL, issue/expiry) for frictionless LinkedIn add.
**Microcopy:** "This credential does not expire."
**Notes:** Uxcel/Udemy/Codecademy buttons (P8) deep-link into this — "Add to LinkedIn" vs "Share on LinkedIn" are distinct actions (profile entry vs feed post).

---

## P11 — Achievement share card (mobile share sheet, pre-composed brag)

**Apps observed:** Marriott Bonvoy, Reddit, stoic., Coinbase, Bloom, Ladder (iOS)
**URLs:**
- Marriott "Share Your Achievements": https://mobbin.com/screens/145c73c3-669c-4b43-ace5-e617c6efb76f ; with share sheet open: https://mobbin.com/screens/2d444eb2-7070-48a9-a55c-80fbc43b1bd8
- Reddit achievement share preview: https://mobbin.com/screens/6b775721-e6cc-47e5-9bab-1b29894d94a4 ; detail: https://mobbin.com/screens/7947cb5d-888e-4f4d-a14d-2b98c8f8207e
- stoic. badge sheet: https://mobbin.com/screens/8816d533-77bb-4c09-9e13-d9a5896251d0
- Coinbase share card: https://mobbin.com/screens/fb1c7c35-78d0-4679-8de5-09d5fccb96a5
- Bloom prefilled share: https://mobbin.com/screens/1c1941c5-e9ce-41d8-ad7c-f5b2886d4700
- Ladder reward share: https://mobbin.com/screens/454367e2-8656-4492-9b41-914c26d5b0fd

**Anatomy as observed:**
1. Marriott: sheet "Share Your Achievements — Feel free to brag a little! Show off your … journey with this quick-view card that highlights all your achievements to date." → branded stat card → [Share] → native iOS share sheet (AirDrop/Messages/Mail/Copy/Save Image/Print).
2. Reddit: achievement detail (rarity "Rare", "Unlocked 1 time. Last unlocked on 29/10/24") → Share → **Preview of the generated social card** ("I unlocked the rare That's Me achievement on Reddit") + privacy toggle "**Include username and avatar**" → Continue.
3. Coinbase/Bloom: pre-written first-person share text ("I earned $2 in crypto by finishing 1 lesson…").
**Problem solved:** turns a credential into a designed, share-ready image with prefilled copy — recipient does zero work.
**A11y/privacy note:** Reddit's include-identity toggle is the privacy-respecting variant to copy.

---

## P12 — QR ticket + Add to Apple Wallet (credential in pocket)

**Apps observed:** Luma, Eventbrite, Gametime, StubHub, American Airlines, Nike, Neo Financial, BlaBlaCar, GetYourGuide (iOS)
**URLs:**
- Luma ticket QR + wallet: https://mobbin.com/screens/aa52fbb3-9cc8-40e8-a47c-d50ccc906558
- Eventbrite ticket modal: https://mobbin.com/screens/edd2e9b8-3fd4-4caf-9aaf-0b4eeb1df9fc , https://mobbin.com/screens/9aa88ec6-82a1-46e0-ae92-df1a9c9f7306 , https://mobbin.com/screens/03db285e-f7ab-4012-98ef-e916e896f26b , cancelled-state: https://mobbin.com/screens/7dedb891-b93a-48ad-9e3f-3463ae4064c6
- Gametime Safari wallet-pass permission: https://mobbin.com/screens/73e8e918-32d6-48f4-9a9d-dbc224d8a1da
- StubHub pass: https://mobbin.com/screens/1488a72e-daa5-4ae8-9013-36fdd4d944a7
- AA pass add sheet: https://mobbin.com/screens/7f69a89e-33ce-45cb-982b-14d165c9f773 ; Nike: https://mobbin.com/screens/f5a4981a-b972-4940-b0de-8a7223e9bd39 ; Neo: https://mobbin.com/screens/ad5553d1-e423-4e67-879d-a504bf6bccd9
- BlaBlaCar purchase confirmation with ticket delivery: https://mobbin.com/screens/0a14903d-3da6-4336-aad6-be549790e2c8
- GetYourGuide offline ticket: https://mobbin.com/screens/4f677b75-1423-427d-bb62-eba32b6b0c2c

**Anatomy as observed:**
1. Ticket card = event name, holder name, "Ticket 1 of 1", big QR, metadata (date/venue), "Add to calendar", black "Add to Apple Wallet" pill (official asset).
2. Native add-pass sheet: Cancel / pass preview / Add (AA, Nike); optional dismissal "Maybe later" (Neo).
3. Web→Wallet permission interstitial: "This website is trying to show you a Wallet pass. Do you want to allow this?" Ignore/Allow (Gametime).
4. Delivery email pattern: "Thank you for your purchase — We just sent a confirmation email with your ticket attached to samlee…@gmail.com. **If you can't find the ticket please check your spam folder**" + [Download the ticket] + "Add to Apple Wallet" with state "Apple Wallet tickets are being generated. Please wait a moment." (BlaBlaCar).
5. Trust marks: "A screenshot of your ticket will not be accepted" + serial under QR (StubHub); "Accessible Offline" badge (GetYourGuide); "Succesfully cancelled order" banner atop a now-void ticket (Eventbrite) — revoked-state precedent.
**Problem solved:** credential that survives offline and presents a scannable proof.
**Sad paths:** cancelled order over ticket; wallet generation latency state; spam-folder warning.

---

## P13 — Verifier-side scan result (valid / already-used / undo)

**Apps observed:** Luma (iOS)
**URLs:**
- Luma check-in scan result: https://mobbin.com/screens/d3777ec9-8cb9-412f-a4a6-cb5046285df8

**Anatomy as observed:** camera view over QR → green pill toast "✓ Check In Successful" → bottom card: avatar, name, email, three-column meta **Status: Going / Registered: Today at 9:41 AM / Checked In: Today at 9:44 AM** → full-width "Undo Check In".
**Problem solved:** instant, glanceable verdict for the person scanning, with reversible action.
**Notes:** the closest observed analog to "scan certificate QR → see verdict + metadata"; copy the verdict-toast + record-card + undo anatomy.

---

## P14 — Issue wizard: per-recipient certificate generation with notify toggle

**Apps observed:** Cake Equity, Deel
**URLs:**
- Cake Equity "Issuing a share certificate" flow: https://mobbin.com/flows/3017c449-6337-48b0-849e-a99b30e8bdda
- Cake "Issue certificate" screen: https://mobbin.com/screens/6732b18a-4465-4399-b887-0684ef7d082c , preview: https://mobbin.com/screens/e1db91cf-a892-4959-a30f-db9df8a7e111 , signatures: https://mobbin.com/screens/2fc6a841-363b-411a-9e35-a90ed3c3dfc8 , completion toasts: https://mobbin.com/screens/11ade5df-fb4a-4586-b18f-c2f4c07111f5
- Deel LMS "Create new → Create certificate" menu: https://mobbin.com/flows/e75e5b29-6ae8-4424-ab8f-8c525fdde012 (screen 1)

**Anatomy as observed (Cake Equity):**
1. "Issue certificate — You're about to issue a certificate. Cake will aggregate all the shareholder holdings from the cap table to issue." Fields: Certificate number (ⓘ), Issue date (date picker), checkbox "**Notify shareholders of new certificate**" ⓘ → Next.
2. "Add signatures — These signatures are only used in share certificates." (signer card with drawn signature) → Next.
3. "Certificate preview — **We are generating a certificate preview, so you can double check everything before sending the certificate to your stakeholder. Please be patient, this may take a while.**" Rendered legal certificate → [Issue certificate].
4. Return to list with stacked green toasts: "Issuing certificate" → "Share certificates have been issued. You can access the certificate in the documents section or in the corresponding shareholder details." → "Share certificate issuing complete!"
**Problem solved:** deliberate, auditable issuance: number + date + notify decision + signature + final preview before commit.
**Microcopy:** all four strings above; "Notify shareholders of new certificate".

---

## P15 — Revoke / deactivate / expire lifecycle states

**Apps observed:** Salesforce, Air, Zoho CRM, Productboard (deactivation); Slite (verification lifecycle); Klook, Vanta, Coinbase, PandaDoc, Origin (expired/needs-action states)
**URLs:**
- Salesforce "Deactivating a user" flow: https://mobbin.com/flows/ff0fcdb1-6f77-4fa2-b1e8-261395518b2a
- Air flow (impact-stating confirm): https://mobbin.com/flows/92289b0d-b1eb-4e80-a4bd-287af7e45ece
- Zoho CRM flow: https://mobbin.com/flows/b5528a45-0f44-4f60-a587-f8a77c979899
- Productboard flow (Deactivated tab): https://mobbin.com/flows/8b9db0d5-62a0-4070-977e-07a82736587d
- Slite Knowledge Management verification states: https://mobbin.com/screens/784fd37d-3429-4f47-b58c-0b6fc0ffed07
- Klook "Booking expired": https://mobbin.com/screens/70adc503-1474-4036-90b6-4748494e5611
- Vanta status badges (Overdue/Due soon): https://mobbin.com/screens/eb1d71b4-2b3c-4a83-8435-bdc0e7cbb9e2
- Coinbase "Application rejected" rows: https://mobbin.com/screens/ddf0c35f-764d-4dff-a08f-83ce0e93b8c3
- PandaDoc smart views "Upcoming renewals / Expiring soon": https://mobbin.com/screens/2164216f-e201-4d25-8704-f8e2678c151a
- Origin "Not signed" badge + row menu (Upload signed copy / Download original / Mark as signed): https://mobbin.com/screens/2e4adff9-4fd6-426a-a22c-49027ea8a1dc

**Anatomy as observed:**
1. Deactivate pattern: row action "Deactivate" → confirm dialog stating impact ("Are you sure? Removing Jane Doe's guest membership will prevent them from accessing 1 board in SLMobbin." — Air; "Deactivate user — Are you sure you want to deactivate Jon Smith?" — Productboard, red Deactivate) → success toast ("User was deactivated successfully." Salesforce; "User has been deactivated." Zoho) → entity moves to a **Deactivated section/tab with re-Activate link** (Salesforce "Activate"; Air "Deactivated user" group; Productboard DEACTIVATED tab). Revoke is reversible and segregated, not deleted.
2. Slite document-verification lifecycle (best analog for credential validity): quick-filter tiles "0 Outdated / 0 Verification expired / 0 Verification request… / 0 Empty"; per-doc STATUS "Not verified"; bulk context menu "Verify doc / Flag as outdated / Request verification / Clear status"; bulk bar "Change status".
3. Expired artifact page: "Booking expired" headline + reference ID + [Book again] re-issue CTA (Klook).
4. Time-based risk badges: "Overdue / Due soon / Needs remediation" counts (Vanta); list smart-views "Expiring soon", "Upcoming renewals" (PandaDoc).
**Problem solved:** full credential lifecycle — valid → expiring → expired/revoked → reissued — with reversibility and visibility at list level.
**Sad paths:** rejection rows with date + "No action required" (Coinbase); reason capture NOT observed anywhere — see Coverage notes.
**Microcopy:** Air's impact sentence pattern "Removing X will prevent them from …"; Slite's "Flag as outdated".

---

## P16 — Audit log of admin actions

**Apps observed:** Zoho CRM, Gorgias, 7shifts, Discord, Fibery, Grok, Cloudflare
**URLs:**
- Zoho CRM Audit Log: https://mobbin.com/screens/b27943e6-e8ff-4fc0-8d27-dfe0c33c124f
- Gorgias Audit logs: https://mobbin.com/screens/44a16fee-609a-40a5-afa0-f901dcacdfa8
- 7shifts Activity Log: https://mobbin.com/screens/8b845427-b403-4eb7-87c9-aa771a00d378
- Discord Audit Log (expandable diff): https://mobbin.com/screens/f7ab3b03-7c7c-479c-9cfc-4e5a3c4622b1 , https://mobbin.com/screens/335d4d28-4d0f-48b8-bdda-43386205bfb0
- Fibery Audit Log table: https://mobbin.com/screens/8ebb779a-53f5-4ba8-b717-ea5b9cda1017
- Grok audit log with activity chart: https://mobbin.com/screens/ead077d3-5811-4840-8d8b-b8496d1ed8c0
- Cloudflare Admin activity logs: https://mobbin.com/screens/d63c3f57-bf36-47cd-92db-15be7fd24924

**Anatomy as observed:**
1. Zoho: chronological day-grouped feed "05:39 AM — Sam Lee Added a Trusted Domain named Mobbin trusted domain" (actor + verb + object link); "Export Audit Log" link; header "The audit log provides you with a chronological sequence of actions performed by the users."
2. Gorgias/Cloudflare: filterable table (Team member / Event / Object / Date; Email / Product / Date-range filters); Cloudflare adds "READ ONLY" badge and "Monitor when a member on your account creates, updates, or deletes configurations."
3. Discord: rows expand to show field-level diff ("Changed the name from new role to Admin"); Filter by User / Filter by Action.
4. 7shifts: row verb chips (Added / Deleted / Declined) + per-row "Show Details"; month + audit-type + employee filters.
5. Fibery: columns Public ID / Entity / Event / When / Who / **What Changed** (field chips).
**Problem solved:** non-repudiation for issuance/revocation actions.
**Notes:** Export-to-CSV (Zoho), action-type filters, and field-diff expansion are the three features that recur.

---

## P17 — Test send / live preview with sample or real profile data

**Apps observed:** Eventbrite, Loops, Klaviyo, Mailchimp
**URLs:**
- Eventbrite "Sending a test email" flow: https://mobbin.com/flows/9ef9b49d-95d8-4dd0-9723-e6fc1e0b5ad2
- Loops "Send a preview email" flow: https://mobbin.com/flows/f65e5012-07de-4ff8-baf5-0f48dbaf812e
- Klaviyo "Sending a test email" flow: https://mobbin.com/flows/3d5e2fe9-e730-4f9c-b3ea-a560dc559821
- Mailchimp "Sending a test email" flow: https://mobbin.com/flows/190ffe09-df1f-4669-9305-8a05985d08e5

**Anatomy as observed:**
1. Eventbrite: editor right pane shows rendered email; "Send test email" button → modal "Send a test email — Preview your email campaign before sharing with your audience" with subject/from summary card + "Send test email to:" input.
2. Loops: "Send a Preview Email" modal with two tabs — "Select contacts" ("Preview the email with your team and see how it looks in your inbox") and "**Dynamic content**" ("Modify the dynamic content below to preview the email with real data." — editable JSON: `"firstName": "John"`). The cleanest merge-data test pattern observed.
3. Klaviyo: full "Preview Mode" — Desktop/Mobile toggle, right rail "Preview Profile Info" with "Search for a profile" (render with a real recipient's properties), Profile Properties list; "Send test" popover ("Enter recipient email addresses — Separate multiple emails with commas", "Save emails as your default test recipients"); toast "Test message sent successfully"; "Email size Approx. 60 KB — Your email is not at risk of clipping in Gmail."
4. Mailchimp: "Send a Test Email" modal ("Use commas to separate multiple emails", "Include instructions and a personal message (optional)") → success state "**Bon voyage, test email!** Your test email is on its way to the test recipients." + warning "Note: When you send to an email address using the same domain in the reply-to…, it can sometimes trigger Gmail and others to categorize it as spam. Check your junk mail if the test doesn't arrive." + "Send another test email".
**Problem solved:** de-risk a 5,000-recipient send by rendering with real/sample data and emailing yourself first.
**Sad paths:** spam-classification warning (Mailchimp); free-plan From-address limitation note (Mailchimp); clipping-size meter (Klaviyo).

---

## P18 — Version history with restore

**Apps observed:** Notion, Jasper, HubSpot, Slite, Fibery, Confluence
**URLs:**
- Notion page history: https://mobbin.com/screens/68e72133-daba-44cd-a4e7-2d102b73aae8 , https://mobbin.com/screens/2f220e7d-4363-4485-af76-15d1597ae3b5 ; restore confirm: https://mobbin.com/screens/c826f509-9a6d-43d7-842d-281812e8282d
- Jasper Document History: https://mobbin.com/screens/8fd7a550-99c0-4e65-abe1-04d9a0973ad5
- HubSpot email template version history: https://mobbin.com/screens/4699bcdc-f0a2-4cba-8c4a-4705d96870ac
- Slite history (plan-gated): https://mobbin.com/screens/ad1e3ad8-4003-4d7b-87c5-4f76081916bf
- Fibery (Show changes diff toggle): https://mobbin.com/screens/eb05e8be-4a16-47f0-94fe-08ad3da74171
- Confluence Versions table + revert comment: https://mobbin.com/screens/b405410d-7a2d-4bd6-b44d-4efa934e0dec

**Anatomy as observed:** right-rail timestamp list grouped by day with author under each entry; selecting renders that snapshot; primary "Restore version" + Cancel. Variants: Fibery "Show changes" toggle (strikethrough diff) and confirm "Your current version will revert to version Jan 8, 2026 1:13 pm."; Confluence full table (Version / Date / Changed By / Comment) + "Compare selected versions" + revert dialog with editable comment "Reverted from v. 2"; Slite gates older versions ("2 more version — Access all versions of this doc, upgrade to the Standard plan.").
**Problem solved:** template safety net — see who changed what, roll back before a bad batch goes out.

---

## P19 — PDF/document preview with guarded download + expiring share links

**Apps observed:** Deel, Trello, Aboard, WeTransfer, Dropbox, Google Drive
**URLs:**
- Deel "Download PDF preview?" modal: https://mobbin.com/screens/702de603-e84d-4fb5-9284-1a92ee8a3d4b
- Trello attachment viewer: https://mobbin.com/screens/d1bcc3f0-5555-4b15-bb1d-7bb9f7d125e5
- Aboard embedded PDF viewer: https://mobbin.com/screens/e3d5820d-0096-4a1a-905f-00e61e547767
- WeTransfer transfer page: https://mobbin.com/screens/01c9c157-c09f-454e-8516-386127e2c960
- Dropbox preview toolbar: https://mobbin.com/screens/20595806-291c-4308-b3f8-6f6f51159ffb
- Google Drive preview: https://mobbin.com/screens/b81fb867-21fc-4969-8a71-cd0cd53c7a53

**Anatomy as observed:**
1. Deel: template detail with inline PDF viewer (page nav, zoom, download icons) + right metadata rail (Template name, Applicable country, Employee type, Last update, Created on); download intercepted by modal "Download PDF preview? — Please note that the PDF is for viewing only. To request any changes, submit the request on the template preview page." [Go Back / Download] + "Don't show this again".
2. Trello: lightbox with filename, "Added Sep 3, 2025, 11:03 AM • 13.46 KB", actions Open in new tab / Download / Delete.
3. WeTransfer (delivery-page anatomy relevant to certificate links): file card + Download / Preview / Forward / Delete; **"Expires in 4 weeks"** dropdown; optional **Password**; "Sent to 1 person … ✓ Not yet downloaded"; "**Total downloads 0**" counter.
**Problem solved:** recipient/admin can inspect the exact artifact before/after download; WeTransfer shows expiry + password + download-count for controlled distribution.

---

## P20 — Empty state with primary action (templates/issuance areas)

**Apps observed:** Workable, Linear, Frame, Sana AI, Coda
**URLs:**
- Workable document templates empty: https://mobbin.com/screens/c6191351-f538-49b2-9be9-235e5f61cf9b
- Linear documents templates empty: https://mobbin.com/screens/a57bbcb6-f66e-4147-8bc3-09011b17d11b
- Frame empty folder: https://mobbin.com/screens/d554032b-7553-4911-a891-9250d970deee
- Sana AI templates empty: https://mobbin.com/screens/cb749274-3f52-4b87-9890-aaf47229b701
- Coda starting-template bar: https://mobbin.com/screens/d6beb6c7-5eb2-4f38-aeea-24a661aca652

**Anatomy as observed:** illustration (or none) + one-line state + one-line value/why + single primary action, with the same action duplicated in the page header. Workable: "**No document templates yet.** Create templates for documents requiring signatures." + "➕ Add template" (inline AND top-right) + "▶ Watch tutorial" link. Linear: terse "No document templates" + "+ New template" + sentence explaining what templates do. Frame: "This folder is empty, create a new Doc" + three creation-path cards (Create from Doc / Create from template / Create from AI template) + "Import Data". Sana AI: "You have no templates — Templates that you add will end up here. Add a template to get started!"
**Problem solved:** first-run momentum; teaches the object's purpose at the moment of need.

---

## P21 — QR fallback + 2FA-style scan setup (secondary observation)

**Apps observed:** Zapier, IFTTT, OpenAI Platform, Kajabi, Retool, Binance, Revolut, Uvodo
**URLs:** https://mobbin.com/screens/e1db9e52-110b-49b4-9d0a-1fcd881c19b3 (Zapier), https://mobbin.com/screens/1b4d06e6-2413-4c14-b7a8-c543075bb3ec (IFTTT), https://mobbin.com/screens/7ed962bc-0beb-4165-bfc1-f5251a4d2822 (OpenAI), https://mobbin.com/screens/deef3ddc-27c1-4bd6-a0cb-47d134a93f3c (Kajabi), https://mobbin.com/screens/4339955d-dceb-46f7-b202-e4a18e1f5bca (Retool), https://mobbin.com/screens/d479bc12-0219-4a90-8b2a-374d925f3f39 (Binance), https://mobbin.com/screens/fb4e8f88-ffcb-4278-aab2-64f0dc315355 (Revolut), https://mobbin.com/screens/a9516b3c-cf36-4d6b-adc2-b15a4688d0c5 (Uvodo)
**What's reusable:** every QR display ships a manual fallback — "Can't scan this barcode? **Copy code instead.**" (Zapier); "Can't scan QR codes? You can manually enter this text code into your app. KAV4 5CNW W7EQ MENP" (IFTTT); "Trouble scanning?" link (OpenAI/Kajabi). For certificate QRs: always print the human-typable verification ID + URL next to the code (matches Udemy/Uxcel artifacts in P8).

---

## Coverage notes

**Queries that returned nothing relevant (count toward dry-out):**
- "QR code scan to verify ticket or document" (web) → only 2FA/authenticator and identity-verification QR setups; zero public scan-to-verify-document pages.
- "public certificate verification page verify credential authenticity" (web) → half the results were KYC/identity verification (Hims, AWS IAM, Coinbase, Foundation); the usable hits were the certificate pages themselves (Uxcel/Udemy/Codecademy), not a dedicated "enter ID → verdict" page.
- "enter certificate number to validate authenticity lookup" (web) → dupes (Cake Equity) + off-target (New Yorker subscription verify, Twingate device verify, Airwallex UEN lookup). Only adjacent find: Aboard "View case — Please provide the access code you got when you submitted your case." (https://mobbin.com/screens/f1adec7e-f866-42d4-859a-8346297880b9) as a code-gated record-lookup anatomy.
- Final two sweeps ("resend or reissue…", "background job…", "enter certificate number…") produced only enrichment of existing themes, then dupes — sweep declared dry.

**Themes thin or absent on Mobbin:**
1. **Dedicated public verification portal** (Credly/Accredible-style "verify this credential" page with valid/revoked/expired verdict) — not represented; nearest anatomy = Luma scan-result card (P13) + Uxcel/Udemy public pages (P8) + Slite verification states (P15).
2. **Revoke WITH reason capture** — every observed revoke/deactivate confirm states impact but none collects a reason field; reason-capture must be designed from first principles (audit logs in P16 imply where the reason would surface).
3. **Certificate-specific bulk issuance progress** (N of M certificates generated, per-recipient failures) — synthesized from AWS/PandaDoc per-item job UI (P6) + Customer.io delivery log (P7); no app shows it natively for certificates.
4. **Expiration reminder/renewal flow for credentials** — only list-level signals observed (PandaDoc "Expiring soon", Vanta "Due soon", LinkedIn "Expires Jan 2026"); no notification/renewal journey captured.
5. **Wallet pass for a certificate (non-ticket)** — only loyalty/ticket passes observed (P12); certificate-as-pass is an extrapolation.

**NOT swept (out of scope for this BY-PATTERN pass):** Android platform entirely; competitor-by-app deep dives (Credly, Accredible, Certifier, Sertifier are not on Mobbin); pricing/paywall flows around certificate add-ons; localization/multi-language certificate flows; print-production flows; email template builders beyond test-send/merge-tag touchpoints; SSO/admin-permission flows gating who may issue.
