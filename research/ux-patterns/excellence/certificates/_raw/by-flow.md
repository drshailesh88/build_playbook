# BY-FLOW Raw Harvest — Certificates / Credentials

Job: design a certificate/credential template → issue at scale to recipients → recipient receives/downloads/shares → anyone verifies authenticity → admin manages lifecycle (revoke/reissue/expire).

Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.

Date: 2026-06-11

---

## F1 — Designing a certificate (admin-side template builder)

### Deel — Creating a certificate
- URL: https://mobbin.com/flows/e75e5b29-6ae8-4424-ab8f-8c525fdde012
- Steps observed:
  1. Learning > All courses list. "Create new" dropdown: Create course / Create program / Create folder / **Create certificate** / Browse templates / Create training event.
  2. Full-screen "Create certificate" wizard, 3 steps shown in right-rail stepper: 1 Certificate details (COMPLETED) → 2 Design & review → 3 Certificate settings. Footer: "Step 2 of 3 / Next: Certificate settings", Back / Next.
  3. Design & review step: Orientation radios (Landscape / Portrait), Layout radios (Left aligned / Centered / Right aligned), Colors (Text #000000, Background #ffffff), Logo dropzone ("Supported file formats: PNG, JPG; Maximum file size: 10MB").
  4. Live Preview card renders sample recipient "John Doe" with date and title field below ("Title: Achievement").
  5. Certificate detail page after save: large preview, name "Achievement", Description, metadata row: Status (Draft pill), Created by, Last edited on, **Validity: ∞ Unlimited**, **Issuing Authority**, **Endorsed by**. Tabs: "Awarded certificates (0)" / "Resources (0)". Edit button + kebab.
- Problem solved: wizard-based certificate template creation with live preview and lifecycle metadata (validity, issuing authority) from day one.
- Microcopy: "Certificates are personalized documents awarded to learners upon the successful completion of learning resources."
- Notes: Draft status + "Awarded certificates (0)" tab = template vs issued-instance separation.

### Teachable — Creating a certificate
- URL: https://mobbin.com/flows/21f569ff-7862-482d-85e8-3f33d1d25c22
- Steps observed:
  1. Course > Certificates empty state: "You don't have any certificates yet — You can distribute a certificate of completion to students who have completed your course." CTA "Create new certificate" + "Learn more about course certificates in the Teachable Knowledge Base".
  2. Editor with left panel tabs **Content / Design**. Content: Logo upload ("Size: 300x300px (PNG, SVG)"), Title, Subtitle ("Awarded To"), Graduating From, Date Label, Signature upload (optional). Top bar: "• Saved", Preview, Finish.
  3. Design tab: Background Color, Primary Text Color, Secondary Text Color (hex inputs).
  4. Canvas preview shows full certificate with **Serial No. block ("cert_123456789")** and script-font signature rendering.
  5. After Finish → "Active certificates" list: "You can only have one active certificate at a time. The active certificate will be issued automatically when a student completes a course." Card shows thumbnail, "Issued 0 times", "Last time updated Jan 7 2025 07:41", Preview button + kebab.
- Problem solved: simple two-tab (content/design) certificate editor with automatic issuance on completion.
- Microcopy worth stealing: "You can only have one active certificate at a time."; "Issued 0 times".

### Podia — Preview a certificate / certificate toggle
- URL: https://mobbin.com/flows/66885cf7-aaf1-43b1-bf25-db000f521391
- Steps observed:
  1. Product Details page > Options card > "Certificate — Send customers a certificate when they complete all lessons in your course." Toggle + Preview + Edit buttons.
  2. Full-page certificate preview: ornamental border, "Certificate of Completion / This certificate is awarded to / Jean-Luc Picard / For successfully completing the online course: ...", footer-left date "2024 November 12", **footer-right short verification code "r3EjKHXy"**.
- Problem solved: certificate as a per-course option toggle with one-click preview; no separate builder.

### Kajabi — Enabling course certificates
- URLs: https://mobbin.com/flows/0cef33a3-a1f9-499a-8071-389d598a4719 and https://mobbin.com/flows/c2741cc8-9cf4-49f0-a79e-26fcedf146d7
- Steps observed:
  1. Course > Certificates tab. Master toggle "Provide certificates for this course" + "Preview ↗".
  2. Until toggle is ON, all fields below are disabled/greyed (checkbox-gated fields): Logo (with "Recommended dimensions of 640x640", Replace file), Certificate title ("Certificate of Completion"), Recipient subtitle ("This certificate is awarded to"), Show student's name, Course subtitle. Each field has its own enable checkbox.
  3. Preview renders "[Name of Student]" placeholder, "Issued on November 05, 2024" and "Certificate no. 706f42c2" bottom-right.
- Problem solved: checklist-style field-by-field composition of certificate content gated behind one master toggle.
- Microcopy: "Celebrate your customers by offering them a certificate upon course completion. The certificate will be emailed upon course completion. You can customize the content of the email in Email templates." (links issuance email to template editing).

---

## F2 — Creating from / saving as template (template governance analogs)

### Adobe Express — Creating a template
- URL: https://mobbin.com/flows/42362400-db42-425b-931b-c227d79d965d
- Steps: Share menu → "Make a template" → modal with Name, "Save to" brand picker, Optional settings: **"Note — Write a note that will help users understand the purpose of this template"** and **"Locks & Restrictions — Control the use of color, fonts, layers, and content while using this template."** → Save template → toast "ASMobbin - Video Poster was saved to ASMobbin Brand" + "Copy link".
- Problem solved: converting a design into a governed, brand-scoped reusable template (locks = brand control for certificate templates).

### Figma — Adding a template
- URL: https://mobbin.com/flows/d0fce046-940c-406c-bf93-0f281b0d9500
- Steps: FigJam canvas → "FigJam's good for many things — Pick one, we'll show you." quick-start cards → "See more templates" → template browser with categories by activity and **by role** (Designer, Developer, User researcher, Student & educator), hover "Add template" → template stamped onto canvas.
- Problem solved: template gallery with role-based filtering as entry point to creation.

### Bonsai — Using a template
- URL: https://mobbin.com/flows/58625560-054a-4da8-b784-da8ee50948d9
- Steps: "Select a Template — Get a headstart with one of our customizable templates." Tabs Type / **Industry** with counts (All Templates 95, Design 10...). Cards: "Blank Form — Start from scratch" vs named templates with "Use Template". → Full preview page ("Previewing: Graphic Design Brief" + Use Template button) → opens in editor.
- Problem solved: industry-filtered template gallery with full preview before committing.

### ClickUp — Using a template
- URL: https://mobbin.com/flows/cd63e524-76cb-4ecf-9ef6-4b4c28fd503c
- Steps: doc page → template sidebar (Creative & Design category list with one-line descriptions) → select → success toasts "Selected Template has been used successfully!" / "Your template has been appended."
- Problem solved: in-context template insertion with confirmation.

---

## F3 — Issuing a credential/badge (create + award)

### Zendesk — Creating a badge
- URL: https://mobbin.com/flows/80df1afb-3304-44a2-95b7-12e6bf47d634
- Steps:
  1. Settings > User badges: catalog table (Icon, Name, Category, Created) with preset badges ("Rising star (Silver)", "Expert (Gold)"... categories Achievements / Titles). "Create badge" button.
  2. Create badge form: Name ("The badge name will be seen by community members."), Description, Category dropdown ("Learn about badge categories"), Icon upload ("JPG, PNG, SVG, or GIF. Maximum file size is 500KB. Recommended icon size is 40x40px." + "Choose image").
  3. Save → back to list, new badge at top, toast **"Your badge is ready to use"**.
- Problem solved: badge catalog management with category taxonomy.
- Microcopy: "Create badges to recognize people in your community with special roles or skills. They help point out who's who for better communication and interactions."

### Uber — Create a voucher (bulk issuance analog)
- URL: https://mobbin.com/flows/406936be-9cd8-4c55-adc1-a2dbfc1edf00
- Steps: "New voucher" form: Voucher name ("Recipients will see this name in the app." 0/50 counter), **Number of vouchers** ("Each recipient can only accept the voucher once. You can always add more recipients later."), Voucher type with "Select value type" modal (Recommended chips), Credit per recipient preset chips ($25/$50/$75/$100/Other), **Voucher duration: Starts on / Expires on with timezone ("Vouchers can't be used after the expiration date.")**, right-rail live Summary (Number of vouchers, Max value per voucher, Max total budget, Estimated spend) + "How do vouchers work?".
- Problem solved: issue-at-scale config with per-recipient quantity, validity window and live cost summary.
- Sad path: "Sign up to share vouchers" interstitial — work is saved, "Your voucher details will be saved, so you can continue once you've signed up."

### Airwallex — Creating an employee card (issuance-to-person analog)
- URL: https://mobbin.com/flows/b5ec186b-37fc-48bb-b332-c4696cb07ab2
- Steps: Card type chooser (Company vs Employee, capability tags) → recipient + limits → live right-rail preview of card with recipient name → Create card → detail page with status **Pending** and banner: "We need more information from Sam Lee. We need to verify Sam Lee's personal information (legal name, address) before they can access their card."
- Problem solved: issued item exists immediately but is gated on recipient verification — claim-before-active lifecycle.

---

## F4 — Sending certificates to a list / bulk email campaign

### Klaviyo — Adding personalization (merge fields)
- URL: https://mobbin.com/flows/8a292cb8-bc2e-4e8f-bff5-a95916e18b32
- Steps: campaign editor (stepper RECIPIENTS → CONTENT → REVIEW) → text block → **"Add personalization"** button → searchable picker scoped to "Profile": First name, Last name, Title, Email, Recipient organization, **Unique ID** → inserts token rendered as `Hi {{ first_name|default:'firstname' }},` — default fallback inline in the tag.
- Problem solved: per-recipient personalization tokens with explicit fallback values (the core of certificate name-merge).

### Squarespace — Editing campaign email + Sending a campaign to recipients
- URLs: https://mobbin.com/flows/93bfcd7f-5d86-4836-af1f-19e0c8ce432e and https://mobbin.com/flows/63ed4ef4-d06e-4e40-98d4-50d4c2e748cb
- Steps observed:
  1. Email editor, right rail "Campaign": SUBJECT LINE supports token "Subscriber First Name" with popover "Default Value — If there is no subscriber first name, this default text will be used instead." Cancel/Apply.
  2. TO & FROM: Unique Recipients (count), Sender Details; FOOTER: Legal Address; Schedule: Immediately.
  3. Buttons: **SEND TEST** / **SEND TO RECIPIENTS**.
  4. After send: dialog "Your email is being sent. OK"; analytics panel: "No analytics available — Your campaign is currently being sent. Analytics should be available shortly." Sidebar counters Drafts/Scheduled/Sent.
- Problem solved: test-send before bulk send; graceful "being sent / analytics pending" states.

### Wix — Sending an email campaign
- URL: https://mobbin.com/flows/9ca0fc19-6356-44ef-b2cb-d55c68213c9a
- Steps: 3-step header "1. Create → 2. Add Recipients → 3. Campaign Overview". Overview page: Subject line (Edit), Sender details (sender name, reply-to email, Manage), Email recipients ("Estimated recipients count: 2", Edit), preview thumbnail + "Send Test Email", footer "By selecting 'Schedule' or 'Send Now', you agree to the Terms of Use", buttons Schedule / Send Now. Campaign list shows status pill "SENDING" and Reuse button.
- Problem solved: final review checkpoint summarizing who/what/from before bulk send.

---

## F5 — Recipient claim (from email/invite)

### Discord — Redeem gift
- URL: https://mobbin.com/flows/078707ba-5e65-400c-a207-486f2077e223
- Steps: Settings > Gift Inventory: "Redeem Codes — Received A Code For Nitro Or A Game? That's Exciting! Enter It Below:" input with format ghost "WUMP-AAAAA-BBBBB-CCCCC" + Redeem. "Your Gifts" row: **"Gift is available to claim until April 16, 2025. More Details"** + Claim button. → modal "Awesome!" with Redemption Code + Copy, "**This code is included in a confirmation email we just sent you.**", Maybe Later / Redeem.
- Problem solved: claim-by-code with visible claim deadline and email backup of the code.
- Sad-path signal: claim expiry date surfaced on the gift row before claiming.

### Cake Equity — Accepting invite
- URL: https://mobbin.com/flows/1d1def13-36fb-4ae9-b391-be3e28bbe85b
- Steps: Login (Google/LinkedIn/Microsoft/email) → "**You've been invited!** Check your invitation e-mail. Make sure you match the same invitation e-mail and enter below the provided invitation code to activate your account." Invitation code field + "Activate account", "Logged in as Jon Smith ... Change account" → onboarding dashboard.
- Problem solved: identity-bound claim — invitation code must be redeemed by the invited email; explicit account-mismatch escape hatch ("Change account").

### Dub — Accepting an invitation
- URL: https://mobbin.com/flows/c5d087ad-7dd4-482e-9d53-7ffeabbbdb2f
- Steps: sidebar "Invitations (1)" tab → card with inviter logo, "Invited September 16" badge, reward summary, **Learn more / Accept invite** → program dashboard + toast "Program invite accepted!".
- Problem solved: in-app invitation inbox pattern (claims don't only live in email).

### Fey — Claiming a referral
- URL: https://mobbin.com/flows/927fb29a-162e-489f-8cc8-0c3abdd17c9e
- Steps: gift-box landing page → "Welcome to Fey — Thank you for signing up. To start enjoying the benefits, let's set up your account." email input → "**Check your inbox** — We have sent you a secure login link. Please click the link to authenticate your account." (magic-link claim).
- Problem solved: passwordless claim via emailed magic link.

### Uxcel — Unlocking a certificate (recipient-side claim + name confirmation)
- URL: https://mobbin.com/flows/a2e3dcaf-c6ed-4bbc-af0a-818f566e1c33
- Steps:
  1. "Unlock your certificate — Your certificate demonstrates that you learned new design skills, so share this achievement with the world." Blurred cert preview with padlock "Ready to unlock". Button **Unlock**.
  2. Modal "**Add your full name** — Please add or review your name and then we'll generate your shareable certificate." Full Name field, button in "Generating…" state; toast "Generating certificate, please be patient."
  3. Certificate page: COURSE CERTIFICATE header, cert with "ISSUED TO Jane Doe", signatures, **QR code**, "Issued on May 7, 2024 • ID: 854VANBUFU". Actions: **Share on LinkedIn** (primary), Download Certificate, **Add to LinkedIn**, "..." more. Right rail: Rate this course (1–5), "Issued to Jane Doe ✓ **Credentials Verified**", "This course certificate of completion was issued on May 7, 2024. **Does not expire.**", Course completed card, Issued on.
- Problem solved: name-confirmation gate before generating the artifact — prevents misspelled-name reissues.

---

## F6 — Recipient views/downloads certificate

### Udemy — Certificate detail / Download / Share
- URLs: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d , https://mobbin.com/flows/ea144def-6d70-4318-8a98-58c69d99ca61 , https://mobbin.com/flows/d3c6841c-5d55-4314-a12a-73f5bddc9d7c
- Steps observed:
  1. In course player: "Get certificate" pill in top bar → popover "43 of 43 complete. **Get certificate**".
  2. Certificate page: cert canvas with top-right metadata block: "**Certificate no:** UC-…", "**Certificate url:** ude.my/UC-…", "Reference Number: 0004". Right rail: Certificate Recipient (avatar + name), About the Course card.
  3. **Download** → format popover "Choose the format: .jpg / .pdf".
  4. **Share** → popover "Share this certificate" with Facebook / Twitter / LinkedIn icons.
  5. Link below buttons: "**Update your certificate** with your correct name or preferred language." (self-serve reissue trigger!)
  6. Footer verification sentence: "This certificate above verifies that Jane Doe successfully completed the course … on 06/25/2023 as taught by … on Udemy. The certificate indicates the entire course was completed as validated by the student. The course duration represents the total video hours of the course at time of most recent completion."
- Problem solved: single page combining artifact, identity, verifiable ID/URL, download formats, share targets and correction path.

### Codecademy — Completing a course → certificate modal
- URL: https://mobbin.com/flows/943886cb-68e4-4bba-84df-f6926b0bebd9
- Steps: course player "Mark lesson completed" → "Next Steps & Course Feedback — You've completed Learn CSS: Responsive Design!" → feedback survey → "Certificate of Completion" modal: cert with name, course, QR code, year, signature. Footer actions: **Edit Name** (link), **Save as PDF**, **Add to Profile** (LinkedIn-styled button), "View All".
- Problem solved: certificate delivered in-flow at completion with name-correction escape hatch right on the artifact.

### Skillshare (iOS) — View certificate
- URL: https://mobbin.com/flows/0f5bde65-f504-40d5-9908-d2aba895eb5e
- Steps: Profile > **Achievements** tab > "My Achievements > Certificates — Earn a class certificate by completing a class and submitting a project. FAQ about Certificates." Cert row (course, teacher, date) with **View / Share** → full-screen landscape certificate; tiny "CERTIFICATE ID: skillshr.es/…" URL printed on the cert edge.
- Problem solved: mobile certificate locker under profile achievements.

---

## F7 — Add to LinkedIn / professional profile

### LinkedIn — Adding a profile section (licenses & certifications)
- URL: https://mobbin.com/flows/d97a84bf-7296-41d6-847b-34a7b5c016b2
- Steps:
  1. Profile → "Add profile section" → modal with Core / **Recommended** ("Completing these sections will increase your credibility and give you access to more opportunities") / Additional accordions → "**Add licenses & certifications**".
  2. Modal "Add license or certification": Name*, Issuing organization* (typeahead with org logos), checkbox "**This credential does not expire**", Issue date (Month/Year), Expiration date (Month/Year), **Credential ID**, **Credential URL**. Save.
  3. Profile now shows "Licenses & Certifications: Certified Associate in Project Management (CAPM), Project Management Institute, **Issued Jan 2021 · Expires Jan 2026**".
- Problem solved: the canonical target schema for "Add to LinkedIn" deep links (name, org, dates, credential ID + URL).

### LinkedIn — Public profile settings + badge
- URL: https://mobbin.com/flows/f54be105-7a32-47b5-bd9f-a8aebba7bb43
- Steps: public-profile visibility rail with per-section Show toggles (incl. **Certifications: Show**); card "**Public Profile badge** — Promote your profile by adding a badge to your blog, online resume, or website. Create a badge".
- Problem solved: recipient controls public visibility of credentials; embeddable badge.

### LinkedIn — Skill Assessments
- URL: https://mobbin.com/flows/0d87a3c8-e3cd-4521-9d5c-1c0b9d1ec0ce
- Steps: "Skill assessments — Check your skill level. Answer 15 multiple choice questions, score in the top 30%, and earn a **skill badge**." Catalog with filter chips; right rail "Your assessments: 0 Badges / 0 To retake".
- Problem solved: earned-badge catalog + retake state.

### Upwork — Adding / Importing a certification
- URLs: https://mobbin.com/flows/51f133f7-1918-42b5-8b80-f7058e9eb97b , https://mobbin.com/flows/33e5892c-973b-43bd-8883-30def3491463
- Steps observed:
  1. Profile "Certifications" empty state: trophy illustration, "Listing your certifications can help prove your specific knowledge or abilities. (+10%) You can add them manually or **import them from Credly**." Links: "Add manually" / "Import from Credly".
  2. Add Certification modal: provider-catalog certificate (name + Provider: Udemy + description), Issue date / Expiration date (Optional), Certification ID (Optional), Certification URL (Optional). Add Certification disabled until valid.
  3. Import path: "Import certifications — Select the Credly certifications you want to import (1/1)" with checkbox rows, buttons **Unlink account / Cancel / Import**.
  4. Imported credential renders with badge image, "**✓ Verified by Credly**" tag, skill chips, "Provider: Coursera, Issued: October 2022", "Show description • **View certification link**".
- Problem solved: third-party verified import beats self-attestation; "Verified by Credly" label is the trust differentiator.
- Banner microcopy: "Now you can add certifications with Credly, a third-party digital credential network."

---

## F8 — Sharing an achievement (social)

### Replit — Congrats share modal
- URL: https://mobbin.com/flows/bbe22c41-e24b-43b3-a146-4de331ec14a1
- Steps: "Mark lesson completed" → modal "🎉 **Congrats on completing Day 1!** Share your progress" with **pre-filled share text** ("Hello to the world of coding and my very first project! Day 1 of #Replit100DaysOfCode #100DaysOfCode. Join me on @Replit https://join.replit.com/python") + copy icon, buttons: Back to the learning hub / **Share on Twitter** / LinkedIn / Facebook.
- Problem solved: zero-effort sharing via prewritten post with hashtags and referral link.

### Duolingo (iOS) — Share an achievement
- URLs: https://mobbin.com/flows/3f0795fd-8c9a-4887-acbb-cdd1ffa81b3d , https://mobbin.com/flows/e3fc2983-0802-408d-bcae-fe6c521159f5
- Steps: full-screen unlock moment ("You unlocked your Duolingo French Score!") with share icon → auto-generated **square share card** (date, score, mascot, logo) over a share tray: Messages / Instagram / **Save image** / More. Variant: "SHARE +20 GEMS" (incentivized share); after save → toast "Image saved".
- Problem solved: platform-ready share card generation distinct from the certificate artifact itself.

### Any Distance (iOS) — Sharing a collectible
- URL: https://mobbin.com/flows/b07960b3-0375-49df-97aa-a5f6a85e6051
- Steps: achievement medal screen ("YOU ARE SUPER … This is your exclusive collectible medal.") with **Wear Your Medal** + Share → "Share Collectible" composer with story-format card preview, targets Instagram / Messages / Twitter, **Save to Photos**, More Options.
- Problem solved: vertical story-format render for the same achievement.

### Superhuman — Showing achievements
- URL: https://mobbin.com/flows/41c5123d-a470-4e05-a809-89b4130ea0aa
- Steps: settings "Achievements" → modal cards (Inbox Zero, streaks, counts) headed "**Share your achievements!**" with X and LinkedIn icon buttons inline.
- Problem solved: lightweight stats-as-achievement share without dedicated share-card step.

### Whop — Creating a post
- URL: https://mobbin.com/flows/f9c0d543-5154-444e-adc6-db2394c6258b
- Steps: feed composer ("Your next post could blow up...") → emoji/GIF/poll toolbar → Post → post detail with Like/comments/Share. (Generic social posting; recorded as the community-feed share target.)

---

## F9 — Verifying authenticity

### Udemy — Certificate detail (verification affordances)
- URL: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d
- Observed: "Certificate no:", "Certificate url: ude.my/UC-…", "Reference Number", plus the full verification sentence under the cert (see F6). The public cert URL *is* the verification page.

### Uxcel — certificate page trust marks
- URL: https://mobbin.com/flows/a2e3dcaf-c6ed-4bbc-af0a-818f566e1c33
- Observed: QR code printed on cert, "ID: 854VANBUFU", "✓ Credentials Verified" badge next to recipient, "Does not expire."

### Upwork — "Verified by Credly" label
- URL: https://mobbin.com/flows/33e5892c-973b-43bd-8883-30def3491463
- Observed: green check "Verified by Credly" + "View certification link" — verification delegated to issuing network.

### OpenAI Platform — Verify an organization (verification-flow analog)
- URL: https://mobbin.com/flows/e156eb5b-7896-4268-b6cc-5d26a55474fc
- Steps: empty-state gate "Verify organization — Verify organization details to use the Images playground. [Verify →]" → Organization settings > Verifications > "Verify Organization" → modal "**Verify your identity** — To verify this organization, you'll need to complete an identity check using our partner Persona." URL field + copy/refresh + "Start ID Check ↗".
- Problem solved: feature-gating until third-party identity verification completes.

### Screens search (QR verification) — mostly 2FA, two keepers
- Binance "Scan With Your Phone": **"QR code expired — Refresh"** state inside the QR frame. https://mobbin.com/screens/92c083bc-d3d5-40ce-9146-5049c02e14b0 (sad path for any QR claim/verify surface)
- Deel × Veriff: "Let's get you verified — Prepare a valid document / Make sure it's not expired or physically damaged… Option 1: Scan the QR code / Option 2: Send link via SMS… Don't have a smartphone? Continue with your current device." https://mobbin.com/screens/b5e7cca6-7a5b-4c64-a090-af4adbd1cd6d (multi-channel handoff pattern)
- Udemy "Certification preparation" catalog (browse third-party cert badges by Issuer/Subject area): https://mobbin.com/screens/7b323678-0529-414e-8717-280f800083c0

---

## F10 — Importing recipients from CSV

### Apollo — Importing a CSV / Importing contacts
- URLs: https://mobbin.com/flows/5b22533b-8aa7-4446-9016-0ffe74856ed1 , https://mobbin.com/flows/2eb0884f-5123-4de0-8f77-af07565397b0
- Steps observed:
  1. Import dropdown (Single contact / CSV) → "Import contacts" screen, header shows filename + "4 rows included".
  2. **Column Mappings**: "Each column below must be mapped to the related field… When possible, we will automatically detect and map related fields for you." Status chips: "**8 columns detected: ✓ 6 recognized, 2 need mapping**" (unmapped highlighted orange with ⚠). Hint: "Don't see the field you want to map to…? Create a custom field in Apollo here."
  3. Each column card shows mapped field dropdown + first sample rows underneath.
  4. Settings section: "If contacts already exist in Apollo → **Update the existing record with information from CSV**", "If existing contacts already have owner → Do not override ownership", "If owner value is missing in your CSV, assign owner to:*", "Auto-assign accounts? Assign/create account based on Website/Email Domain in the CSV", "Add to a List?" 
- Problem solved: auto-mapping with explicit recognized/needs-mapping counts and dedupe/merge policy controls.

### Attio — Resolving issues (import)
- URL: https://mobbin.com/flows/535a7828-5915-47a2-b782-c6bfd708adc0
- Steps: 4-step wizard "1 Upload file → 2 Map columns → 3 **Review values** → 4 Preview import". Review values: per-column raw→mapped table, sections "Automatically mapped 3" and "**Needs review 3**"; invalid cell shows red "**Invalid domain**" chip with inline editor (remove bad value, "+ Add domain"); select-type column offers "**+ Create 3 missing select options**" bulk-fix button; per-row revert/ban icons.
- Problem solved: row-level error remediation inside the import wizard instead of failing the file.

### Rox — Uploading a CSV / Adding contacts with CSV
- URLs: https://mobbin.com/flows/3d307696-63db-486b-91e8-10d5f7f85b77 , https://mobbin.com/flows/e88d71cc-ca76-4aec-848f-01c78fc7b29c
- Steps: "Add Contacts via CSV" menu → "**Map your columns** — Map as many fields as possible. We will use the mapped fields to enrich the data… In order of preference: LinkedIn URL, Email ✓, Company Website ✓, First + Last Name or Full Name, Company Name." Auto-map toggle + "Sample values from CSV" panel → Next Step. Campaign contacts table with status tabs: All / Not Started / Active / Completed / **Bounced** / **Verification Failed** / **Needs Attention**; rows show red "**Enrichment failed**" chips; toast "**CSV Uploaded — We are parsing the CSV and adding contacts to the campaign. This may take a few minutes…**".
- Problem solved: post-import per-recipient status taxonomy (bounced/failed/needs attention) — directly reusable for certificate delivery states.

### HoneyBook — Importing a CSV
- URL: https://mobbin.com/flows/05e0758b-9dc8-464a-9bfe-27fe9fa67402
- Steps: Contacts page (Add new contact / Sync Google contacts / **Upload CSV** / Export CSV) → "**Upload a CSV of your clients** — Only certain fields are supported in our CSV upload. Please **download our template** to make sure your client information is imported correctly." Dropzone "Drag into this screen to upload — Your file must be a .csv or .xls file type under 2MB" → "**Great, we're adding your clients… This import could take some time.** Feel free to handle other business in HoneyBook and we'll notify you when it's complete. OK, GOT IT".
- Problem solved: template-download guidance + async import with notify-when-done.

### 15Five — Importing people (error)
- URL: https://mobbin.com/flows/27cfd50f-ed50-40ba-a356-aaa5f23c83bc
- Steps: Settings: People > Import — "Update or create multiple profiles… with a CSV file." "**Download current structure**" button; rules list ("Only the fields in the example are permitted.", "**email is the only required field**, all other fields are optional."); field-by-field reference table with descriptions; "Check the status & history of previous imports" link.
- Sad paths observed: yellow "**Import upload warning** — We recommend creating a backup… changes made to active_group_names will override any current group settings."; red "**Import Error — Oops! Your file was not successfully uploaded. Please make the corrections and try again. • Cannot decode file. Please ensure file is ASCII or UTF-8 encoded.**"
- Problem solved: actionable file-level error messaging + import history.

---

## F11 — Tracking delivery/open status (did recipients get it?)

### AutoSend — Email activity + detail
- URLs: https://mobbin.com/flows/9d10f1ae-8ab3-425b-993c-2d810a904be1 , https://mobbin.com/flows/ca0625d9-4aff-40df-b17f-836adf61670a
- Steps:
  1. Email Activity table: KPI strip REQUESTS / SUPPRESSED / SENT / DELIVERED 100% / BOUNCED 0% / SPAM REPORTS 0%; per-row status pills **SUPPRESSED / DELIVERED / OPENED** with recipient + campaign + "Last event at"; search by email address; date-range + Filters.
  2. Row click → modal with tabs **EVENT HISTORY / DETAILS**. Event history grouped by hop: "Received by AutoSend: PROCESSED → QUEUED → SENT (timestamps)" → "Received by Google mail server: DELIVERED **IN 1 SEC** — This email was received by the Google mail server and delivered to the recipient." → "Received by <recipient>: OPENED ×6 (each timestamped)".
  3. DETAILS tab: To / From / Subject / Transactional Template link / Unsubscribe Group / Message ID / Sending IP Address.
  4. Dashboard per-campaign cards: REQUESTS / SUPPRESSED / SENT / DELIVERED / OPENS / CLICKS / COMPLAINTS (or "Not tracking").
- Problem solved: per-recipient delivery forensics — exactly the "did they receive their certificate email?" admin question.

### Resend — Sent email details / Delivered details
- URLs: https://mobbin.com/flows/df02112c-50f5-4c3f-b149-71cf8724098b , https://mobbin.com/flows/2a71339e-b702-424d-b4bc-d54fe17928ea
- Steps: Emails list (status pills "Opened", filters Last 15 days / All Statuses / All API Keys) → detail: FROM/SUBJECT/TO/ID header + **EMAIL EVENTS horizontal timeline** (Sent → Delivered → Opened → Opened → Opened, each timestamped); hover Delivered → tooltip "Resend successfully delivered the email to the recipient's mail server. **See details**" → side panel "**Delivered Details** — The recipient's mail server accepted the email and returned a successful response…" with raw SMTP RESPONSE block. Tabs Preview / Plain Text / HTML / **Insights** — deliverability checklist ("POSSIBLE IMPROVEMENTS: Use a subdomain"; "DOING GREAT: …, DMARC record is valid, Include plain text version, **Don't use 'no-reply'**").
- Problem solved: visual event timeline + deliverability coaching.

### Navan / Circle / ElevenLabs — invite status + resend (see F14) also serve as "claimed?" tracking.

---

## F12 — Bulk download / export (zip)

### Midday — Downloading files
- URL: https://mobbin.com/flows/cfedd50d-0a5b-4d6c-b6a1-b6b979b0e74f
- Steps: vault grid/list toggle → checkbox multi-select → bottom action bar "4 selected — Deselect all — **Download ↓**" → button shows spinner while preparing.
- Problem solved: select-N-then-download with persistent selection bar.

### Runway — Downloading assets
- URL: https://mobbin.com/flows/f4a23403-de68-470c-9c23-7ac4ff8bea52
- Steps: multi-select rows → "4 asset selected — Actions ▾" (Share with workspace / Download / Favorite / Move / Delete) → toasts "**Preparing to download.**" → "**4 files downloaded**".
- Problem solved: two-stage feedback (preparing → done) for bulk download.

### Frame.io — Download assets
- URL: https://mobbin.com/flows/ae09e933-cdd6-464b-aad5-980991e8acc8
- Steps: project menu "**Download All Assets**" → modal "Download with the Desktop App — Unlock even faster download speeds, plus preserve your folder structures on download." Buttons: Download with App / Download in Browser, checkbox "Always use this download method", Cancel download.
- Problem solved: channel choice for big archives.

### Tally — Downloading submissions (CSV)
- URL: https://mobbin.com/flows/02d91dea-9b37-4f0a-8a1c-c0acc51560f0
- Steps: Submissions table → "Download CSV" (also "Download 2 file uploads") → full-page spinner "**Generating a CSV file—this may take a couple of minutes**" → "**Download complete, you can now close this window**".
- Problem solved: honest async-generation states for exports.

### Trello — Exporting data
- URL: https://mobbin.com/flows/5a6f5220-1058-4a30-9dc7-57e53418e3d3
- Steps: Export (PREMIUM) → "Create new export", checkbox "Include raw attachments…", copy: "Downloads will be in a **ZIP format** that includes members, boards, and all other data in CSV and JSON formats. If you choose to include raw attachments, they will be in their native format…" → Exports history row "Today at 10:59 PM - 9.72 MB — Download".
- Problem solved: export history with sizes; zip+structured formats.

### Duolingo — Data Vault (async archive)
- URL: https://mobbin.com/flows/7819fdf4-8ab5-42bd-8574-1b530acef012
- Steps: settings "EXPORT MY DATA" → "Duolingo Data Vault > Access Personal Data — request a copy… **can take up to 30 days**" → confirmation: "Duo is busy gathering up all of your personal data into a zip file… **When he's finished we'll send you an email with instructions for how to download your data file.** We've also sent you a confirmation email…"
- Problem solved: long-running archive with email handoff.

### Zoho CRM — Downloading a folder
- URL: https://mobbin.com/flows/a5acdca7-1674-4b30-946c-7eed32995ab5
- Steps: select folder → zip action → bottom-right progress toast "**Item ready for download — Zipped 1 folder · 100% ✓**".
- Problem solved: inline zip progress indicator.

---

## F13 — Revoke / deactivate issued things

### Copilot — Revoking a key
- URL: https://mobbin.com/flows/e02b9b31-d997-4488-a839-8a40c647a951
- Steps: API page, key row ("copilot_slmobbin — Created by Sam Lee on 12/10/2024") with red **Revoke** link → confirm dialog "**Are you sure you want to revoke this API key?**" Cancel / Revoke (red) → row removed.
- Problem solved: minimal two-step revoke.

### Twingate — Deleting a service (guarded delete)
- URL: https://mobbin.com/flows/db5f82c9-f4d3-4810-89c8-13cec343ea0c
- Steps: Services list → Delete → modal "Delete Service Account — Deleting the SLMobbin Service Account **cannot be undone**." Red inline guard: "**SLMobbin contains 1 active key that must be revoked or deleted first.**" Delete button DISABLED until dependencies cleared → after deletion, banner toast "Service Account 'SLMobbin' was deleted" + empty state.
- Problem solved: dependency-aware revocation — can't delete an issuer while issued artifacts are live.

### Twingate — Disabling an access
- URL: https://mobbin.com/flows/5f8e0fe0-327b-44da-8ce2-62613c149ab3
- Steps: resource row kebab → Edit / Add Access / **Disable** / Delete → status filter dropdown (Connected / Disconnected / **Disabled**) shows disabled item; Last Updated changes to "just now".
- Problem solved: reversible disable as soft alternative to delete + status-filterable list.

### Vanta — Disconnecting an integration
- URL: https://mobbin.com/flows/8a586d43-ce27-416f-b1c2-ad0e98cd0aad
- Steps: integration detail → "Connected Vercel API tokens" modal listing tokens with trash icon, buttons "Add API Token" / red "**Delete all API Tokens**".
- Problem solved: granular vs nuclear revocation in one modal.

### Navan — Revoke invites (bulk)
- URL: https://mobbin.com/flows/9d8af34f-5293-47eb-92cd-faba0c6e0dc7 (same flow as F14)
- Observed: bulk-select invite rows → bottom bar "Invites selected (1) — Send a reminder / **Revoke invites**".

---

## F14 — Reissue / correct after sending (rename, change recipient, resend)

### PandaDoc — Changing signer
- URL: https://mobbin.com/flows/d5d129fc-3300-4ead-a25a-d305e555195b
- Steps: document Recipients rail → recipient card → Recipient settings: **Edit personal details / Change signer / Remove from document**; toggle "**Recipient verification** — Protect your document by requiring recipient verification."; "Qualified electronic signature — …uniquely linked to the signer. Subsequent changes will be detectable." → "**Change signer** — Select another signer to replace Jane Doe." choose new person + checkbox "**Keep Jane Doe as CC recipient.**" → Change → rail updates (Jane Doe → CC, Jessica Smith → Signer).
- Problem solved: swap recipient on an already-sent artifact while preserving the old recipient's visibility — the certificate "sent to wrong person" fix.
- Also observed (Recipient permissions): Document forwarding / Signature forwarding / Suggest edits / Download toggles.

### Contractbook — Editing a contract (resend after change)
- URL: https://mobbin.com/flows/cb98b1d9-490c-4c30-b531-57d1a1ef7bbd
- Steps: contract status "Pending" with progress "1/3 signed"; edit signees ("New signees will not have access to the document until you send it for signature."); after edits buttons "**Resend now and sign later**" / "**Resend and sign**"; bottom "**Document history**" audit trail: Created by → Sent for signature to [emails] by → Contract viewed by → Signed and sent (timestamps + actors).
- Problem solved: re-send semantics plus a tamper-evident audit log after correction.

### Docusign — Renaming a document
- URL: https://mobbin.com/flows/9a50e50a-3620-48ce-a6f2-dab8def61bdb
- Steps: envelope prep → document kebab → "Rename document" modal "Update name*" → Rename → title updates everywhere. Recipients block: "I'm the only signer" checkbox, per-recipient role dropdown "Needs to Sign" + Customize.
- Problem solved: artifact metadata correction pre-send.

### Navan — Sending a reminder / resending invite
- URL: https://mobbin.com/flows/9d8af34f-5293-47eb-92cd-faba0c6e0dc7
- Steps: Guest travel table (filters: Inviters / Guests / **Invite status**; per-row status pill "● Invited" + icon actions link/edit/**email**/copy/delete) → select rows → "Send a reminder" → green toast "**Successfully resent invite email.**" Also "Invite has been created." toast + "The booking link has been successfully created… Guest invite link [copy]" modal (link-based fallback).
- Problem solved: nudge unclaimed recipients in bulk; copyable claim link as backup channel.

### Circle — Resending an invitation
- URL: https://mobbin.com/flows/47feff98-b19e-4e8f-a135-008d1959603e
- Steps: Manage members tabs "Members 2 / **Invited 1** / Admins / Moderators" → invited row kebab → resend → dark toast "**An invitation has been resent to Abigail. If they still don't see it, please ask them to check the spam folder.**"
- Problem solved: invited-vs-member segmentation + spam-folder guidance in the confirmation.

### ElevenLabs — Sending an email reminder
- URL: https://mobbin.com/flows/f5465aa4-cd18-4db0-bcb0-e1123963c22b
- Steps: Workspace Members list shows seat summary ("Members: 1/1 Full Seat, 1/20 Basic Seats, 1 invite"); pending-invite row ("Invited on Basic Seat by … - Mar 26") with paper-plane resend icon → toast "**Reminder email sent successfully.**"
- Problem solved: single-click reminder from the roster row.

### Udemy — "Update your certificate" link (recipient-initiated correction)
- URL: https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d
- Observed: "Update your certificate with your correct name or preferred language." — self-serve reissue without admin involvement.

### Codecademy — "Edit Name" on certificate modal
- URL: https://mobbin.com/flows/943886cb-68e4-4bba-84df-f6926b0bebd9 — same correction affordance placed on the artifact.

---

## F15 — Expiry / renewal lifecycle

### 7shifts — Uploading a certification with expiry reminder
- URL: https://mobbin.com/flows/7d1cba3c-5ea4-4613-9074-d15d6d4e9bf0
- Steps:
  1. Employee profile > Documents: dropzone "**Upload Certifications** — Drag and drop certificates, licenses, permits and other public documents. PDF, JPEG, PNG, DOCX, or XSLX (max: 500MB)".
  2. "**Add Certification**" modal: "**You will receive an email notification on the expiration date.**" Fields: File Name, Type (optional, e.g., Food Handling), **Expiration Date (Optional)**, **Reminder dropdown ("30 days") with ⓘ**. Footnote: "**Expiration reminders will be sent to you, the employee, and the account Admin.**" Cancel / Upload.
  3. Certifications table: File Name / Type / **Expiration Date** / Last Modified columns, sortable, row kebab; "+ Upload certification".
- Problem solved: expiration tracking with multi-party reminder routing — the cleanest observed model for certificate expiry management.

### Craft — Updating expiration date (link expiry)
- URL: https://mobbin.com/flows/4d59c23f-2a33-4461-9d15-fdd6280a7362
- Steps: Publish-to-web popover (secret link, Password, **Expiration: Never**, view analytics "Readers viewed this link in the last 30 days") → Expiration Date calendar → buttons "**Expire on Nov 12**" / "**Never expires**" → toast "Secret Link successfully updated".
- Problem solved: expiring share/claim links with explicit never-expire alternative.

### Apple Wallet (iOS) — Expired passes + pass lifecycle
- URLs: https://mobbin.com/flows/7bd95ae6-065a-4ccd-977e-61cf4c01a913 , https://mobbin.com/flows/040484d6-4902-4213-9127-06b471d0f18f , https://mobbin.com/flows/f64a6b33-1eae-4b9b-bcf1-943e24690d57 , https://mobbin.com/flows/6c864cb4-d7cd-4668-ab2c-bd18414efc95
- Steps observed:
  1. Wallet "…" menu → **Expired (9 Passes)** → "Expired" list grouping old boarding passes, event tickets and **"Vaccination Certificate" entries** (credential-as-pass precedent), Edit button to bulk-manage.
  2. Pass detail: card face with QR code, share icon, ⓘ info → settings sheet: **Automatic Updates / Allow Notifications / Suggest on Lock Screen ("Show based on time or location.") / Remove Pass (red)** + "Updated 9/11/25" stamp.
  3. "Passes and Tickets — Find apps and start collecting your passes in one place. [Get]" promo card.
  4. Adding a card: scan → "Card Details — Verify and complete your card information" → "Adding Card ✓ Your card has been added to Wallet."
- Problem solved: recipient-side credential wallet — auto-updating passes, expiry bucket, lock-screen surfacing, removal.
- Mobile/a11y notes: passes stack by color; expired items moved out of main stack rather than deleted.

---

## Coverage notes

Queries that returned nothing relevant / dry:
- "managing issued items list with status filters and audit history" (web) → Framer localization review states, Charma action items, Depop draft listings — no certificate-registry pattern. Dry.
- search_screens "certificate verification page with QR code or credential ID lookup" (web) → dominated by 2FA/authenticator QR setup screens (ChatGPT, Confluence, Family); only Binance "QR code expired → Refresh" and Deel/Veriff handoff kept. Mobbin appears to have no dedicated public cert-verification page (Credly/Accredible-style verify pages are not in the corpus).
- "claiming a digital badge or credential after course completion" (web) → mostly repeats of Uxcel/Udemy; only new item was Codecademy completion flow.

What was NOT swept (gaps):
- Dedicated credentialing platforms (Credly, Accredible, Certifier, Sertifier, Canvas Badges) — not present in Mobbin's corpus; only Upwork's Credly *import* shows their ecosystem surface.
- Public third-party verification page UX (enter cert ID → see status, incl. "revoked" result) — no direct example found; nearest analogs are Udemy's cert-URL page and OpenAI/Persona gated verification.
- Revocation messaging shown to the *recipient/verifier* after revoke (what a revoked cert looks like publicly) — not observed anywhere.
- Wallet pass *issuance* from a web app ("Add to Apple Wallet" button flow end-to-end) — only the Wallet-side iOS flows were captured.
- Blockchain-anchored credential UX — nothing in corpus.
- Android/Google Wallet side — not swept (out of scope: ios + web only).
- "tracking delivery status" was covered via email-infra tools (AutoSend, Resend) and invite rosters (Navan, Circle, ElevenLabs, Rox) — no LMS showed per-certificate claim analytics.
- Seat/quota limits on issuance (billing-style "X of Y issued") — only ElevenLabs seat counter as a faint analog.
