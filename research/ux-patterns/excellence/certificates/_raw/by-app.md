# BY-APP Raw Harvest — Certificates / Credentials

Job-to-be-done: design a certificate/credential template → issue at scale to recipients → recipient receives/downloads/shares → anyone verifies authenticity → admin manages lifecycle (revoke/reissue/expire).

Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.

Date: 2026-06-11

---

## Canva (web)

### C1 — Bulk create with data autofill (THE issuance-at-scale editor pattern)
- Flow: "Creating bulk designs" — https://mobbin.com/flows/e7cf2952-1dcb-4fa9-a408-57c2bfd33d67 (12 screens)
- Steps as observed:
  1. Spreadsheet (Canva Sheets) holds row data: columns Date, Content Type, Title/Description, Designer, Status, Engagement Goal, Reference/Link. "Actions" toolbar above grid.
  2. Left rail of editor has a "Bulk create" tool (icon in left toolbar, highlighted orange).
  3. Bulk create panel, stepper "1 2 3". Step heading: "Connect data to your elements" — "Select an element in your page, then connect it to a data field." Empty-state line: "No data fields added". Below: list of detected data fields (Date, Content Type, Title/Description, Designer, Status, Engagement Goal, Reference/Link) each showing a preview of first values ("June 25th, June 26th, June 27th, and 3 more"). Buttons: "Continue", "Advanced options".
  4. On canvas, a text element is selected and tagged with a purple data chip ("Title/Description") showing the binding.
  5. Step "Apply data" — "Create pages based on the data you entered." Checkbox list: "Select all" + one checkbox per row ("1. Maximizing Small Spaces", "2. Clean desk, clear mind", …). Primary button: "Generate 6 designs".
- Problem solved: binds spreadsheet rows to template placeholders and mass-generates one design per row — the exact mechanic for issuing N certificates from one template.
- Microcopy worth stealing: "Connect data to your elements", "Select an element in your page, then connect it to a data field", "Apply data — Create pages based on the data you entered", "Generate 6 designs" (count baked into CTA).
- Sad paths: none shown in flow (no bad-data/missing-field state observed).

### C2 — Fill empty cells with AI (data prep before merge)
- Flow: "Filling empty cell with AI" — https://mobbin.com/flows/d10efe0f-e620-44d4-911c-2f9966930a48
- Steps: select range in Sheet → inline prompt card "Fill empty cells" with generation in progress ("Stop generation / Esc") → cells populated (Status column values: Designed, In Review, Scheduled, Approved, Draft, Pending).
- Related: "Creating a table with AI" — https://mobbin.com/flows/44e2bf00-95f9-4508-9901-08c77091eef5 — Magic Write prompt composes the dataset ("Create a 5-day Instagram content plan... Each row should include: published date, content type..., content status..., assigned designer"), buttons "Clear" / "Generate".
- Problem solved: lowers the cost of building the recipient data table that feeds bulk create.

### C3 — Template browsing & customize
- Flow: "Templates" — https://mobbin.com/flows/8d21cd49-0c4d-4a9e-9319-29107cbdea51
- Steps: Templates rail with categories (Business, Social Media, Education, …) → "Inspired By Your Last Design" + "Curated by Canva" rows → template detail modal: large preview, Pro badge, byline "By Canva Creative Studio" + "Follow", primary button "Customize this template", star/save icons, bullet value props ("Pair words with rich visuals in a flexible design", "Seamless sharing and collaboration", "Looks great on any device, automatically"), "More like this — 25 templates" grid.
- Problem solved: pick-then-personalize entry point; the "Customize this template" CTA is the standard gateway from gallery to editor.
- Also observed: "Creating a document" flows — https://mobbin.com/flows/16fb7d9e-dc3d-4859-ba4b-134964905975 and https://mobbin.com/flows/9464379d-de3c-4b80-8958-b0bbf3a2c941 — "Create a design" modal with type list (Docs, Whiteboards, Presentations, …, Custom size, Upload), editor first-run coach mark "Resize your design for any platform" with "Got it"; header button "Publish as Brand Template".

### C4 — Brand Kit (governance of logo / colors / fonts)
- Flows: "Brand kit" — https://mobbin.com/flows/9c4c0ca9-dba1-4f3f-b9cf-580409dbfd10 and https://mobbin.com/flows/e0e057b9-5ff5-4838-8f0d-a23d7d84df94 ; "Adding a font" — https://mobbin.com/flows/f0159b0d-809b-4d4e-960e-add7f7630468
- Steps as observed:
  1. Brand area with sub-nav: Brand Kits / Brand Templates / Brand Controls. Setup banner: "Ready to set up your Brand Kit?" with checklist bullets ("Easily set up, manage, and grow your brand with all your ingredients, assets, controls, and workflows in one place." / "Replace logos and images across existing designs in just a few clicks." / "Find all of your brand assets and templates from the editor.") and CTA "Set up your Brand Kit". Search field "Search for a Brand Kit", "+ Add new".
  2. Brand Kit detail: sections Logos (asset grid, "+ Add new"), Colors ("Color palette" and "Brand Colours" groups, swatches with names, "+ Add new"), Fonts (role-based text styles list: Title, Subtitle, Heading, Subheading, Section header, Body, Quote, Caption — each row editable with Font picker / Heading type / Size / B / I; link "Manage uploaded fonts"), Brand voice, Photos, Graphics, Icons (empty state: "Add an icon or just drag and drop one"), Charts (banner "Start with on-brand charts every time").
- Problem solved: centralizes brand assets so every template/certificate stays on-brand; role-based font slots map 1:1 to certificate text hierarchy.

### C5 — Download (export) a finished design
- Flow: "Downloading a project" — https://mobbin.com/flows/fa2a0be3-cd19-495a-b54f-6074ef42cff2
- Steps: design context menu (Open in a new tab, Make a copy, Star for team, Move to a folder, Download, Share, Copy link, Move to Trash) → "Download" panel: File type dropdown ("PNG" with "Suggested" badge), Size slider with px readout, "Limit file size to [KB]" checkbox, "Compress file (lower quality)" checkbox, "Transparent background" checkbox (Pro-gated icons), "Select pages: All pages (13)" dropdown, primary "Download" → progress/done toast: "PNG - SLMobbin Site — Completed — If your download hasn't started, click here." Plus a gamified milestone card ("You're on a roll, Sam Lee! You've created more than 10 designs here...", CTA "View and edit my award").
- Problem solved: export configuration with format guidance ("Suggested") and a recovery link if the download didn't start — directly reusable for certificate PDF/PNG export.

### C6 — Share with permission tiers
- Flow: "Copying a link" — https://mobbin.com/flows/6ac8c2a8-2ca0-4aac-941b-de25c3f6abe4
- Steps: "People with access" panel ("Add names, groups or emails", "Create a group — Easily share with multiple people using groups", owner row) → "Collaboration link" dropdown with three tiers, each with explainer: "Only you can access — Only you can access the design using this link" / "Sam Lee's team — Anyone from Sam Lee's team can access the design using this link" / "Anyone with the link — Anyone can access the design using this link. No sign in required." → button flips to "Copied" + toast "Link copied to clipboard". Coach mark: "Link sharing is private — If you want to share this link with others, add them to the design or change access to allow anyone with the link to edit." with "Got it".
- Problem solved: link-scope model for sharing artifacts; "No sign in required" tier is what a public certificate share link is.

### C7 — Admin reports on template usage / brand compliance
- Flow: "Reports" — https://mobbin.com/flows/b5f92b31-b5c8-4b32-b06d-b03a27c74025
- Steps: admin Reports page: "Usage summary" cards (Designs created 51, Total published 21, Total shared 4; Active members 2 with Admins/Members/Brand Designers split) → "Activity reports" tabs Templates / Members / Brand Kits. Templates tab: table per template with Used / Published / Shared sortable counts, "Download report". Brand Kits tab: nudge card "Some designs aren't using a Brand Kit — Some designs your team has created aren't using a Brand Kit. You might want to take look and make sure everything's on brand." + "View designs"; table Brand Kit / Applied ("7 (14%)") / Created / Last updated.
- Problem solved: issuer-side analytics — which templates get used and whether output is on-brand; maps to "certificates issued per template" reporting.

## Credly

Credly is NOT on Mobbin as a standalone app. Its presence appears only as an integration inside Upwork (below). Recorded honestly as third-party-verification-network pattern.

### CR1 — Import certifications from Credly (Upwork web)
- Flow: "Importing a certification" — https://mobbin.com/flows/33e5892c-973b-43bd-8883-30def3491463
- Steps as observed:
  1. Profile "Certifications" section, empty state with trophy illustration: "Listing your certifications can help prove your specific knowledge or abilities. (+10%) You can add them manually or import them from Credly." Links: "Add manually" / "Import from Credly".
  2. Modal "Import certifications — Select the Credly certifications you want to import (1/1)" — row: issuer logo, "Google …, Issued October 2022", checkbox. Buttons: "Unlink account" / "Cancel" / "Import".
  3. Result: Certifications card shows badge image, title, green check "Verified by Credly", skill tag chips (Spreadsheet Software, Metadata, SQL, SQL Programming), "Provider: Coursera", "Issued: October 2022", links "Show description" / "View certification link".
- Problem solved: imports externally verified credentials instead of self-claims; "Verified by Credly" chip is the trust marker.
- Microcopy worth stealing: "(+10%)" profile-strength incentive; "Verified by Credly"; "Now you can add certifications with Credly, a third-party digital credential network." (announcement banner seen in CR2 flow).

### CR2 — Add a certification manually (Upwork web) — the self-claim fallback
- Flow: "Adding a certification" — https://mobbin.com/flows/51f133f7-1918-42b5-8b80-f7058e9eb97b
- Steps: Certifications "+" → search/select certification (e.g. "Akka Essentials with Scala | Rock the JVM", provider Udemy, with course description + "Learn more") → form: Issue date, Expiration date (Optional), Certification ID (Optional), Certification URL (Optional) → Cancel / Add Certification (disabled until valid) → card listed with "Provider: Udemy, Issued: June 2023, Show description"; banner above: "Now you can add certifications with Credly, a third-party digital credential network. — Import from Credly" (dismissible X).
- Problem solved: manual entry coexists with verified import; optional ID + URL fields are the hooks any verifier needs.

## Coursera (web)

### CO1 — Course completion moment (where the certificate is born)
- Flow: "Rating a course" — https://mobbin.com/flows/d96738cf-f47a-494c-88b1-57402164db45
- Steps: course page with all modules green-checked → top banner card "Congratulations on completing this course!" → "Next course in Google UX Design" card with "Your progress" step dots (1✓ 2 3 4 5 6 7) and "Get started" → upsell "Did you know completing the Professional Certificate can earn you credit towards a degree?" with university links + "Request info" → "Rate this course" stars → review modal ("Your review", stars, "Write your review (optional)", consent fine print, "Submit").
- Problem solved: completion screen chains celebration → next action → credential upsell; certificate moment doubles as progression + feedback capture.

### CO2 — Profile Credentials section
- Flow: "Profile" — https://mobbin.com/flows/35c2a252-e4df-4297-b22d-f7c3b8f8bc37
- Steps: profile page, left card with avatar + "Share profile link" button + "Update profile visibility" → Education block, "Credentials ⓘ" section with "+ Add" button, promo line "Get job-ready with role-based training from industry-leading companies like Google, Meta, and IBM. — Browse Professional Certificates", existing credential row with edit pencil. Account menu includes "Accomplishments" item (https://mobbin.com/flows/35c2a252-e4df-4297-b22d-f7c3b8f8bc37 first screens; menu observed in screen at https://mobbin.com/flows/d96738cf-f47a-494c-88b1-57402164db45 context).
- Problem solved: recipient-side credential locker on the profile with one-click public share link.

### CO3 — Share modal (course asset level)
- Flow: "Sharing a video lesson" — https://mobbin.com/flows/07d1b590-2c6d-48c0-8fc9-ca057ebb89d0
- Steps: "Share" → modal "Share this video — If you enjoy this video, take the time to show your friends." → icon row LinkedIn, Email, WhatsApp, Facebook, X → URL field with "COPY" → state flips to "COPIED!".
- Problem solved: standard multi-channel share modal; same chassis Coursera uses for shareable artifacts.
- Note: a dedicated Coursera certificate-view/download flow was NOT found on Mobbin (see Coverage notes).

## Udemy

### U1 — Certificate of completion page (web) — recipient view/download/share
- Screen: https://mobbin.com/screens/6f26edde-fdbb-4cbd-aace-e3161e09fe04
- Observed: full-bleed certificate render: "CERTIFICATE OF COMPLETION", course title, "Instructors", recipient name "Jane Doe", "Date June 25, 2023", "Length 2.5 total hours". Top-right of certificate: "Certificate no: UC-9582e423-572c-4a74-be71-9b06765d748f", "Certificate url: ude.my/UC-9582e423-…", "Reference Number: 0004". Right rail: "Certificate Recipient:" avatar + name; "About the Course:" card (with rating 4.6, hours, price); buttons "Download" and "Share" → popover "Share this certificate" with Facebook / Twitter / LinkedIn icons. Link: "Update your certificate with your correct name or preferred language". Footer verification sentence: "This certificate above verifies that Jane Doe successfully completed the course 7 Lessons on Writing for Becoming a Standout Writer on 06/25/2023 as taught by Duncan Koerber on Udemy. The certificate indicates the entire course was completed as validated by the student. The course duration represents the total video hours of the course at time of most recent completion."
- Localized variant: https://mobbin.com/screens/7d5be8a2-c69a-4962-9a3d-6b33c92294ba — identical layout fully localized (Korean labels 수료증/강사/날짜/길이), certificate no/url preserved — certificate language switching is a first-class feature.
- Problem solved: one page is simultaneously the recipient's download/share hub and the verifier's landing page (unique cert no + short URL + plain-language verification statement).
- Microcopy worth stealing: the entire verification footer; "Update your certificate with your correct name or preferred language".

### U2 — Certificate entry point + empty state (iOS) — SAD PATH
- Flow: "Course certificate" — https://mobbin.com/flows/b356dff2-17ab-408d-a419-2cc155b4fe2f
- Steps: course player "More" tab lists "Course certificate" row (alongside Share this course, Notes, Resources…) → bottom sheet with certificate illustration: "No certificates for this course — Only paid, approved courses offer a certificate of completion. Free courses and courses that only include practice tests do not offer a certificate." Button: "Got it".
- Problem solved: explains WHY no certificate exists instead of hiding the entry point — eligibility rules stated in recipient language.
- Mobile note: presented as a dismissible sheet, not a dead-end page.

## Skillshare

### S1 — Certificate page with share modal (web)
- Screens: https://mobbin.com/screens/06a6f901-f956-4fc4-89f8-fe9673a4361b (page), https://mobbin.com/screens/7d1055dd-affd-463a-b61c-f11d2f2bf1b7 (share modal open)
- Observed: large certificate render on dark canvas: "Skillshare officially and enthusiastically celebrates that [Name] has completed the class and project for [Class]." Fields on certificate: DATE OF ISSUE / CLASS LENGTH / TEACHER; tiny "CERTIFICATE ID: 25b7a555-6bd1-4021-b12a-cfcdc907479" printed top-right. Right rail: "This Certificate Belongs to" (avatar + name), "Class Completed" card (class thumbnail, student count, duration, teacher), "Project Submitted" card (project thumbnail + likes). Bottom-left "Share" button → modal: class badge, title, recipient, date, share icons Facebook / Twitter / LinkedIn, short-link field "https://skl.sh/42Asc0T" + "Copy".
- Problem solved: certificate page proves provenance by pairing the artifact with the work (submitted project) — evidence-backed credential.
- Microcopy: "Skillshare officially and enthusiastically celebrates that…" (voice), "This Certificate Belongs to".

### S2 — Achievements hub → certificate viewer (iOS)
- Flow: "View certificate" — https://mobbin.com/flows/0f5bde65-f504-40d5-9908-d2aba895eb5e
- Steps: profile "Achievements" tab → "My Achievements" page: "Certificates — Earn a class certificate by completing a class and submitting a project. FAQ about Certificates" → certificate card (class title, teacher, date) with "View" and "Share" text buttons → full-screen certificate render (landscape artifact in portrait viewer, close X).
- Problem solved: mobile credential locker with explicit earn-criteria copy and an FAQ escape hatch.
- Mobile/a11y note: certificate shown as image at readable scale; actions are text buttons not icon-only.

## Uxcel

### UX1 — Course certificate page (the richest single recipient screen found)
- Screen: https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7
- Observed: header buttons "Go to Home" + "Share on LinkedIn" (primary, blue). Label "COURSE CERTIFICATE" + title. Certificate render contains: seal, "ISSUED TO Jane Doe", descriptive sentence ("The bearer of this certificate has completed the … course, which is equivalent to 2 hours or more of UX training."), founders' signatures, "Issued on May 7, 2024", "ID: 854VANBUFU", QR code bottom-right. Under certificate: "Share on LinkedIn" (filled), "Download Certificate", "Add to LinkedIn", "…" overflow. Right rail: "Rate this course" 1–5 boxes ("Your feedback is vital…"), "Issued to — Jane Doe — ✓ Credentials Verified" (green check), sentence "This course certificate of completion was issued on May 7, 2024. Does not expire.", "Course completed" card, "Issued on" date block.
- Problem solved: separates the three jobs cleanly — artifact (QR + ID on the cert), distribution (Share/Download/Add to LinkedIn), and trust ("Credentials Verified" + expiry statement).
- Microcopy worth stealing: "Does not expire." as an explicit lifecycle statement; "Credentials Verified".
- Note distinction: "Share on LinkedIn" (post) vs "Add to LinkedIn" (profile Licenses & Certifications) presented as separate actions.

## Codecademy

### CC1 — Certificate modal with PDF + LinkedIn profile actions
- Screen: https://mobbin.com/screens/93071642-c4dc-42ec-bd64-ff93afb7646e
- Observed: modal "Certificate of Completion": certificate render (recipient name large, course "Learn CSS: Responsive Design Course", QR code, completion year, certificate number "70288076-8", signature "Head of Learning"). Footer actions: "Edit Name" (left, text link), "Save as PDF", "Add to Profile" (LinkedIn-blue with in logo). "View All" link below.
- Problem solved: in-context modal covers the top three recipient needs (fix name, get PDF, push to LinkedIn) without leaving the page.

## Fiverr (Fiverr Learn)

### F1 — Completion celebration modal with badge + share + upsell
- Screen: https://mobbin.com/screens/eeb9e354-0908-449c-a054-24cf2b04ed58
- Observed: modal with scroll illustration: "You've Just Completed Online Freelancing Essentials: Be A Successful Fiverr Seller. Congrats On Earning Your New Badge." Subtext "Show off your new achievement" + Facebook/LinkedIn/Twitter icons. Below: "Take 20% off your next course by using promo code 'learnnext20'" + three course cards.
- Problem solved: converts the credential moment into share + next purchase; badge framing ("earning your new badge") rather than document framing.

## LinkedIn (web)

### L1 — Add license or certification to profile
- Flow: "Adding a profile section" — https://mobbin.com/flows/d97a84bf-7296-41d6-847b-34a7b5c016b2 ; key screen: https://mobbin.com/screens/ff867250-9ec4-4458-9aac-e5414a18abe2
- Steps as observed:
  1. Profile → "Add profile section" → modal with accordions Core / Recommended / Additional; Recommended contains "Add licenses & certifications" ("Completing these sections will increase your credibility and give you access to more opportunities").
  2. Modal "Add license or certification" — "* Indicates required". Fields: Name*, Issuing organization* (with typeahead/company logo), checkbox "This credential does not expire", Issue date (Month/Year dropdowns), Expiration date (Month/Year — grayed out when the does-not-expire checkbox is ticked), Credential ID, Credential URL. Button "Save".
  3. Profile then shows "Licenses & Certifications": issuer logo, "Certified Associate in Project Management (CAPM)", "Project Management Institute", "Issued Jan 2021 · Expires Jan 2026".
- Problem solved: THE de-facto target schema for any "Add to LinkedIn" button: name, issuer, issue/expiry, credential ID, credential URL.
- Lifecycle note: expiry surfaces on the public profile as "Issued … · Expires …".

### L2 — Public visibility control for certifications
- Flow: "Public profile settings" — https://mobbin.com/flows/f54be105-7a32-47b5-bd9f-a8aebba7bb43
- Observed: per-section "Show" checkboxes for public profile, including a dedicated "Certifications — Show" toggle; "Public Profile badge — Promote your profile by adding a badge to your blog, online resume, or website. — Create a badge".
- Problem solved: recipient controls whether credentials are publicly visible; embeddable badge for off-platform display.

### L3 — Share chassis (post / message / copy link)
- Screen: https://mobbin.com/screens/eb015d21-8b4d-4c3b-bd97-54436d3799e3 (Share dropdown: "Share in a post", "Send in a message", "Other options: Copy link, Facebook, Twitter") — the destination UX a certificate "Share on LinkedIn" button lands in.

## Handshake (iOS) — observed social proof of certificate sharing

### H1 — Certificate-of-completion shared as feed post
- Flow: "Post detail" — https://mobbin.com/flows/0eb021f2-221c-4f1a-9c2f-393583991aae
- Observed: student feed post "Excited to share that I have earned a certification in HTML, CSS, and Bootstrap from edureka! …" with the certificate image embedded (purple "CERTIFICATE OF COMPLETION — THIS IS TO CERTIFY THAT …" with name, module, date, signature), hashtags #WebDevelopment #Certification, likes/comments ("Congrats!").
- Problem solved: shows what the shared artifact must look like in-feed — the certificate image IS the creative; design for thumbnail legibility.

## Adjacent patterns (no direct certificate app coverage — recorded for the gaps they fill)

### A1 — Template with merge/auto-fill fields (Workable, Deputy)
- Workable "Create document template": https://mobbin.com/screens/7013adec-6af9-4dfc-9676-d982b9cbbfb7 — left panel "Fields / Documents": Signer dropdown, Signature fields (Signature, Initials), Auto-fill fields (Date signed, Full name, Email address, Company, Title), Standard fields (Textbox, Checkbox, Dropdown, Radio group); doc body shows placeholders "[Recipient Name]" etc.; right rail "Nothing selected — Select a field to make changes"; "Save template".
- Deputy equivalent: https://mobbin.com/screens/7f97aebf-1eed-4004-9506-e771be96a4fe — selected Signature field with "Assigned to", "Required field" checkbox, "Field name (required)".
- Fills: the field-palette + canvas + inspector triad for a certificate template designer.

### A2 — Branded document theme picker (QuickBooks invoices)
- https://mobbin.com/screens/01284237-6f6b-47dc-9576-3cdcb05b5024 — "Create invoices that turn heads and open wallets" wizard: Design / Content / Emails tabs; named theme thumbnails (Airy new, Airy classic, Modern, Fresh, Bold, Friendly); tasks "Make logo edits", "Splash on some colour", "Select a different font"; live preview right; "Preview PDF" / "Done".
- Fills: lightweight theme-first template picker (alternative to full editor) for certificate styling.

### A3 — Bulk send with per-recipient message (Docusign)
- https://mobbin.com/screens/f24411d3-7582-42ae-aa4e-ec5048e21564 — recipient rows (Name*, Email*, role dropdown "Needs to Sign", "Customize"), "Add Recipient", info banner "Fields are not automatically included in the document when new signers are added…", "Add message" (Subject*, Message), "Next".
- Fills: issuance step UX — recipients list + customizable email envelope.

### A4 — Credential-expiry / re-auth sad paths (closest revoked/expired patterns on Mobbin)
- Klaviyo: https://mobbin.com/screens/53552905-983e-4059-8fd4-c2ecb4aeb062 — red alert "Your credentials have expired — Please re-authenticate with Shopify to resume syncing." + "Action Required" tag + floating "Re-Authenticate with Shopify" CTA; confirm dialog "Disable integration — You're about to pause all future data from syncing… You can enable the integration at any time." (https://mobbin.com/screens/36faf2be-76dd-4e27-97ba-dcac834ce13a).
- Twingate: https://mobbin.com/screens/e15687ca-e18a-4e48-bb16-9f25e709c757 — inline error "Unauthorized access. Check that you have the right credentials and access, then retry."
- Quicken: https://mobbin.com/screens/15fc8181-6e51-43aa-ae2c-4fe54c87afbe — "Session expired — You have been logged out. You need to sign in to continue." buttons "KEEP ME LOGGED OUT" / "SIGN IN".
- Fills: tone + recovery-CTA model for "credential revoked/expired" states (state badge + why + single recovery action).

### A5 — Add to Apple Wallet (iOS recipient-side wallet pattern)
- BlaBlaCar: https://mobbin.com/screens/0a14903d-3da6-4336-aad6-be549790e2c8 — post-purchase: "Thank you for your purchase — We just sent a confirmation email with your ticket attached to [email]. If you can't find the ticket please check your spam folder", buttons "Download the ticket" + "Add to  Apple Wallet" (disabled state) with caption "Apple Wallet tickets are being generated. Please wait a moment.", then "For quick boarding, simply use the QR code below" + QR.
- Apple Store session: https://mobbin.com/screens/63cc1cbb-36c7-4d38-9a9c-8eefa928f498 — "You're all set. We'll see you soon." + Attendees + "Share details" + black "Add to Apple Wallet" badge.
- Qantas boarding pass: https://mobbin.com/screens/1264085c-c8b7-41c9-b3dc-a8670b757795 — pass detail with "Add to Apple Wallet" badge centered under the pass.
- Wise/Tabby card-ready: https://mobbin.com/screens/f1ae5aff-34af-412c-a8f2-fcc91ad246a8 , https://mobbin.com/screens/a556fc68-171f-40cc-bb7b-9ac2e30c298c — "Your card is ready" + "Add to Apple Wallet" + secondary "Add manually"/"View card".
- Fills: email + download + wallet trio, async-generation wait state, and QR-for-presentation — directly transferable to conference certificates/credentials.

## Coverage notes

- Absent from Mobbin (searched, zero presence as apps): **Accredible, Sertifier, Certopus, CertifyMe, Credly** (Credly appears only as an Upwork integration). The dedicated credential-issuance admin UX (issue/revoke/reissue dashboards) is therefore NOT covered by Mobbin at all — biggest gap in this harvest.
- "credential revoked / certificate expired / verification failed" queries (2 attempts, web): returned only auth-session/integration-credential errors (Klaviyo, Twingate, Quicken, OpenAI, Jitter, folk, WorkOS). No certificate-domain revoked/expired/verification-failed page exists on Mobbin → recorded adjacents in A4 and declared dry.
- "verify certificate ID public verification page QR" (2nd verification attempt): returned only 2FA/identity-verification screens (Wise, ChatGPT, Mixpanel, Gusto, Salesforce, Airwallex, Kraken, X safety number). Public third-party verification pages (the "anyone verifies authenticity" job) are NOT on Mobbin; the only observed verification surfaces are Udemy's cert no + ude.my URL + footer statement, Uxcel's QR + ID + "Credentials Verified", Skillshare's printed Certificate ID, and Upwork's "Verified by Credly".
- "Accredible Sertifier Certopus CertifyMe issue credentials" query returned unrelated recipient/payment screens (Wise, Mercury, Revolut, Posh "Send Complimentary Tickets", Docusign, n8n, AWS) → only Docusign/Posh kept as adjacents.
- Coursera: no dedicated certificate view/download flow found on Mobbin (only completion banner, Credentials profile section, share-modal chassis). LinkedIn Learning: not surfaced by any query (not found).
- Canva "certificate template" specifically: Mobbin's Canva coverage shows the generic template/editor/bulk-create flows, not a certificate-category template gallery; recorded the generic flows as the mechanic.
- NOT swept (out of scope/budget): Android platform; Mobbin iOS apps for Coursera/LinkedIn; print-shop flows; email-client rendering of issuance emails; deeper pagination (page 2+) on Canva and LinkedIn queries (has_next_page was true on several).
