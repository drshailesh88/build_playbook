# LIVE-WEB Raw Harvest — Issuer-side credential platform UX (Mobbin-absent platforms)

Date: 2026-06-11
Method: Live web harvest. Sources, in descending quality: (a) JS-rendered help-center articles read in a real browser session (accessibility snapshot of full article incl. screenshot references), (b) help-center / knowledge-base articles fetched as text (screenshots referenced but not viewed), (c) marketing/feature/pricing pages, (d) search-result snippets where the source itself was unreachable (lowest confidence — flagged).

Evidence-class legend:
- **[interactive-demo]** — clicked through a real product demo (Storylane/Navattic/Arcade etc.). NONE FOUND this harvest — see Coverage notes.
- **[help-doc/browser]** — full article body read in browser, screenshots confirmed embedded (image alt text read; pixel content NOT inspected).
- **[help-doc]** — help/KB article fetched as text. UI strings quoted from article prose. Screenshots referenced in article but not viewed → treat described flows as capability-level-plus (step sequences and exact labels are documented, but not visually verified).
- **[marketing-screenshot]** — product/feature/pricing page; claims + described screenshots.
- **[search-snippet]** — only the search-engine snippet of an otherwise unreachable article was read. Lowest confidence.
- **[observed-live]** — actual live product surface loaded in browser.

Rule honored: nothing below is claimed as "observed UI" unless tagged help-doc/browser or observed-live.

---

## Sertifier (help.sertifier.com)

### Send flow — campaign wizard
[help-doc] https://help.sertifier.com/send-your-first-credential and https://help.sertifier.com/credentials-complete-guide (screenshots embedded in both)
- Entry: "Create Campaign" / "Send Certificates" button, top-left menu.
- Wizard step names (screen names): "Credential Designs" → "Credential Details" → "Campaign Options" → "Email Templates" → "Recipients" → "Preview and Send".
- Credential Designs: pick a previously created design or "Create New Design". Can design certificate, badge, or BOTH per campaign.
- Credential Details (reusable component): title ("primary identifier"), description, "Search for Existing Skills", "AI Generated Skill Suggestions", "Add Custom Skills", optional fields: "Credential Type, Duration, Cost, Level, Earning Criteria, Expiry Date, and Supporting Documents". "Save".
- Campaign Options: campaign title "will remain hidden from recipients"; privacy (private/public); "social sharing text".
- Email Templates: choose existing or "Browse Templates > Create New Email"; Sender Name; Email Subject; custom email domain address option.
- Recipients: "Upload Spreadsheet" (Excel or .csv), attribute↔column matching.
- Preview and Send: preview credential pages + emails; "Schedule for Later"; "Send a Test Credential"; final "Send".

### Recipient import
[help-doc] https://help.sertifier.com/how-do-i-add-recipients (screenshots embedded)
- Buttons: "Select Recipients", "Add Recipients", three methods: "Upload Spreadsheet" / "Import From Recipients" (pick existing individuals) / "Import From Lists" (saved lists).
- After upload: align "attributes and columns" (exact header match not required → mapping UI).
- Update-strategy dialog when uploaded data conflicts with existing recipient records — SIX options (exact strings):
  1. "Keep everything as it is"
  2. "Update everywhere (dates only for this campaign)"
  3. "Update this campaign only"
  4. "Update this campaign + set defaults for future"
  5. "Create a new copy for this campaign"
  6. "Create a new copy + use details for future"
- Post-send campaign editing: "Send to New Recipients" (auto-duplicates campaign), "Edit Recipients", "Delete Selected" / "Delete All".

### Designer
[help-doc] https://help.sertifier.com/credential-design-complete-guide (screenshots embedded)
- Canvas editor. Left-menu tabs: Design, Attributes, Layers; for badges additionally "Bases", "Ribbons", "Icons", "Images".
- Certificates: "seven size options from the menu in the upper left corner" (A4, Letter, Legal, 16:9 etc.), horizontal/vertical orientation. Pre-made templates.
- Badges: component-based composition (base + ribbon + icon) or "Import SVG".
- Attributes drag-dropped onto canvas: Recipient Name, Course Name, Issue Date, Issuer Name, Credential ID + "Create Custom Attribute" (text, date, number). After placement adjust "color, size, and position".
- Upload own design: "Upload Design button", "Import SVG or Import Image options". Certificates: SVG/PNG/JPG/JPEG max 1 MB. Badges: 3000×3000 px recommended.
- Shortcuts article exists ("How to Use Shortcuts in the Credential Designer") — keyboard support in editor.

### Delivery & engagement tracking
[help-doc] https://help.sertifier.com/analytics-status-update (screenshot embedded) — per-recipient statuses:
- "Delivered", "Opened", "Downloaded", "Shared" ("see the platforms on which your recipients shared"), "Undelivered", "Added to LinkedIn" ("directly track if the credential is added to LinkedIn profile of the recipient").
[help-doc] https://help.sertifier.com/analytics-pages (multiple dashboard screenshots embedded):
- Summary page: total credentials created, total recipients, "Your delivery success rate", rates for email opens / shares / downloads.
- Credential Reports columns: Recipient Information, Campaign Title, Credential Status, Credential ID, Credential Page URL, Send Date.
- "Marketing & Ads Reports": share counts per social platform + "estimated paid advertising equivalency costs" (organic-reach-as-ad-spend framing — distinctive).
- Recipient Engagement Reports: per-person top skills, credentials earned, totals downloaded/shared.
- Recipient Directory: qualification-based queries.
- Event Logs: "all of your recipients' recent activities" (received/downloaded/shared).
- Exports: "Download as Excel File", "Bulk download PDF's" (sent to email after filtering).
- Resend: Analytics > Credentials tab > "Send Again" button (per [search-snippet] of resend article).

### Lifecycle: expire / delete
[help-doc] https://help.sertifier.com/what-is-the-expiry-date (screenshot details9.png embedded):
- Fixed expiry set in Credential Details (all recipients) or per-recipient via Recipients-step column mapped to Expiration Date attribute.
- After expiry: credential stays accessible but shows an "Expired" banner.
- "up to three expiry reminder emails" at chosen intervals before expiration.
- Updates to expired credentials: globally via Components > Credential Details, or per-recipient/bulk at campaign level; updates trigger notification emails by default, toggleable off.
[help-doc] https://help.sertifier.com/how-can-i-delete-a-credential (screenshots embedded):
- Per-recipient: Recipients section → recipient → "Delete Credential" button under the credential.
- Whole campaign: Credentials tab → "Delete" icon under campaign. No revoke-with-record concept documented; deletion is the removal path. Recipient-after-delete behavior not documented.

### Issuer settings / branding / domain
[help-doc] https://help.sertifier.com/issuer-profile (3 screenshots embedded):
- Settings > Organization Settings → "Customize Issuer Profile" → issuer profile designer: org info, profile images, social links; three showcase directories — Credentials, Collections, "Recipient Directory"; per-item toggle switches; "Edit Credentials," "Edit Collections," "Edit Recipients"; "Save Changes, then Save Changes & Publish"; "Visit Issuer Profile". Public profile is search-engine visible.
[help-doc] https://help.sertifier.com/verification-page:
- Default credential pages on verified.sertifier.com subdomain; "Custom Domain" field + CNAME record; branding fields all optional — "the fields that are left blank will be replaced by our default values so nothing is required".
[help-doc] https://help.sertifier.com/premium-branding-and-custom-domain — pricing gates:
- Pro or Enterprise: customize email content + credential page with own logo/colors.
- "Branding Add-On": custom SMTP — replace default sender "no-reply@sertifier.com" with "sender-name@your-organization-domain.com"; custom credential URL replacing verified.sertifier.com ("Verified by Sertifier" pages). Upgrade via "Settings > Subscription".
[help-doc] https://help.sertifier.com/email-domain ([search-snippet] level): subdomain like "sertifier-mailing.example.com" strongly recommended for sending domain.

---

## Certifier (support.certifier.io)

### Issue flow
[help-doc] https://support.certifier.io/en/articles/10857242-how-to-issue-credentials-from-setup-to-delivery (screenshots referenced):
- Entry: "Credentials tab" → "+ Issue Credentials" (also from Credential Templates tab).
- Recipient step: "Add recipients manually" or "Import the recipients using a Spreadsheet"; "Confirm whether you selected the right Credential Template"; **consent checkbox: "Confirm that you have permission to use the personal data"**; "Add Recipients".
- Spreadsheet: "Upload the Recipient list", "Get a Spreadsheet template", "Reupload Spreadsheet"; map "each dynamic attribute to the column".
- Manual: "+ Add Recipient"; required "Recipient Name", recommended "Recipient Email". "+ Add Attribute" → "Select an Attribute from the list".
- "Next: Preview" → editable issue/expiration dates ("pen button").
- Issue options: "Issue immediately" / "Schedule issuance for later" (+date/time); email choice: "Email credentials to the recipients" or "Don't send emails"; or "Create Draft Credentials". Drafts later: Credentials tab → Filter → "Credential Status" "is" "Draft" → "Issue".

### Status taxonomy (3 layers)
[help-doc] https://support.certifier.io/en/articles/10870224-understanding-credential-statuses — exact definitions:
- Credential: "Draft" ("The credential is a draft, and has not been issued yet."), "Published" ("…successfully issued, and it is valid."), "Scheduled" (hover shows date), "Expired" ("The credential is expired. To renew it, enter the details and change the expiration date.").
- Email: "Email is not sent", "Email is not provided" ("…due to a lack of email address."), "Sending" ("…If sent successfully, the status will change to 'not opened'."), "Email is not opened", "Email is bounced", "Email is opened".
- Engagement: "Credential was not opened", "Credential was opened", "No engagement received", "Engagement Received" ("downloaded as PDF, shared on social media, copied link"), "Added to LinkedIn profile" ("shared on LinkedIn and/or added to the LinkedIn profile").
- "Change Request": recipients can request modifications; hover icon to "view the details"; icon disappears when closed.

### Manage / track / resend
[help-doc] https://support.certifier.io/en/articles/10904902-how-to-manage-credentials-editing-tracking-and-resending:
- Credentials table: "Settings" button (top right) → hide/show, pin/unpin, reorder columns.
- Filter groups: Credential Template (name), Credential (Status, Engagement, Issue/Expiration/Schedule date calendars), Email (Status, Engagement), Change Request (open/closed), Custom Attributes with operators "is, is not, contains, does not contain, starts with, ends with, has any value, is empty". CTA: "Apply filters!".
- Bulk actions after selection: "Export" (CSV incl. "recipient details, engagement statuses, and direct links"; PDF/PNG files), "Delete", "Resend email".
- Credential detail view: Information (editable name/email/dates/attributes + "Save"), History (created/published/expired timestamps), Engagement timeline, "Recipient View" button (see it as the recipient).

### Designer ("Design Builder")
[help-doc] https://support.certifier.io/en/articles/10770704 (GIFs + PNGs embedded):
- Canvas drag-drop editor. Panels: Background, Images, Elements (lines, shapes, icons, ribbons, bases), Text, Attributes, QR Code, Layers.
- "up to 300+ templates", filter by category/style/color; pick orientation (Landscape/Portrait) + size (A4/US letter) first.
- Dynamic attributes like `[recipient.name]`; custom attributes via "+ Add attribute"; "Use" button applies an attribute.
- Buttons: "+ Create Design", "Add Custom Background", "Preview" (top-right, sample rendering), "Create Design" (save). Images JPG/SVG/PNG max 2MB. QR code with custom URL.

### Email templates & branding
[help-doc] https://support.certifier.io/en/articles/10770743 (GIFs/PNGs embedded). "Professional plan users and above".
- Email Templates section → "Create email template". Tabs: Content, Branding, Attributes, Settings.
- Settings tab: template name + subject. Content: logo/images, editable text (double-click), dividers. Button: text customizable, "The button can be used on your design only once, and the link it leads to is always the Credential URL".
- Branding tab: background color, template color, border-radius, per-section text colors/sizes/fonts, link color/style, button color/text-color/size/border-radius, divider color.
- Attributes in email body "will be replaced with valid data from your spreadsheet or automation". Final button "Create".

### Lifecycle: expiration UX (recipient/verifier side)
[help-doc via search corroboration] https://support.certifier.io/en/articles/10835883-how-to-manage-issue-and-expiration-dates-for-credentials + expiration feature pages:
- On expiry: PDF can no longer be downloaded/shared from wallet; anyone opening the link sees "a red banner with the information that the credential is no longer valid".
- "Contact Issuer" icon appears under recipient name — one-click renewal request to issuer.
- Two automatic emails: reminder ~2 weeks before expiry + notification after expiry.
- Deletion: deleted credentials cease to exist — recipient email buttons stop working (deletion = hard revoke; no soft "revoked" state documented).

### Custom domain & workspaces
[help-doc, search-corroborated] https://support.certifier.io/en/articles/10770459: Settings → Workspace → Custom Domain; enter domain/subdomain → "Next"; 2 TXT records for ownership verification. Workspace Admin role holds "Custom Sender Details" + custom domain permissions. "Full White Label" add-on: host certificates on custom domain, remove Certifier footer from emails, remove "Distributed by Certifier" label.
[help-doc] Workspaces (11646165): each workspace is "a fully independent environment" with own branding/designs/integrations/analytics/team.

### Pricing gates
[marketing-screenshot] https://certifier.io/pricing:
- Plans: Starter $0 / Professional $67/mo annual ("MOST POPULAR") / Advanced $339/mo / Enterprise custom.
- Gates: Starter = 1,000 credentials/yr, 1 user, "Credential delivery analytics" only. Professional = 5,000/yr, 3 users, "Premium branding", "Advanced analytics", custom email sender; Custom Domain is a $99/mo add-on; "Verified Issuer" $19/mo add-on. Advanced = 10,000/yr, "7 custom users with roles", custom domain + verified issuer included, dedicated account manager. Enterprise = custom limits, SSO.
[marketing-screenshot] https://certifier.io/ — no interactive demo embed; "Watch Explainer" video only; screenshots described: design builder, bulk generator, white-label credential portal, analytics dashboard.

---

## Accredible (help.accredible.com — Salesforce help center, read in browser)

### Recipient import / bulk issuance (the standout artifact of this harvest)
[help-doc/browser] https://help.accredible.com/s/article/how-to-issue-a-batch-of-credentials-spreadsheet-upload — full article read in browser; ~12 screenshots embedded (alt texts incl. "Assign Columns", "Bulk create credentials for single group - credit is not enough to publish", "Create credentials complete - time to publish").
- Entry: Dashboard top menu "Credentials" → Credentials List → "Create Credentials" → dropdown "Single Group" / "Multiple Group". Also from Groups page: hover a Group → "Create Credentials" (or three-vertical-dots next to Group Settings in list view).
- Single group: pop-up Group selector → Create Credentials page with "Download Spreadsheet Template" (pre-built with all required fields + the group's custom attributes) or "Upload Spreadsheet" (own file; required columns: Recipient Name, Recipient Email, Issue Date; missing Issue Date auto-set to creation date).
- Multiple groups: quick-guide page with "Browse Groups" (copy Group IDs), "Download Spreadsheet Template" (includes Group ID column), "Browse Custom Attributes". Group ID + Recipient Name + Recipient Email required.
- Column mapping ("Assign Columns To Attributes"): system analyzes/validates spreadsheet, auto-assigns recognizable columns; alert above columns if a required field missing — hover "Required attributes" to see the missing list; "Skip" per unwanted column; "Next"; "re-upload" to start over. Date formats MM/DD/YYYY, DD/MM/YYYY or YYYY/MM/DD; must pick the matching format; display format on credential is independent.
- "Validate Records" step: reports count of valid records. Two invalid classes: **warnings** (e.g., duplicate emails where allowed; auto-included with valid records unless you check **"Exclude records with warnings"**) and **errors** (must be corrected before publishing). "view" link per class; similar messages grouped with totals; "Download a CSV file" of issues — formatted: only bad rows, original column order preserved, rows organized by message, one extra rightmost column carrying the specific warning/error message. Fix and re-upload.
- Publish step: "Create, but don't publish" recommended for first upload vs publish immediately. Processing async — "You can continue working within your dashboard while your records process"; status bar shows next steps. Scale: 100,000 records per spreadsheet, 5 uploads queued (per [search-snippet] of same KB).
- Post-create review: "View Unpublished Credentials" → list; click credential ID to preview; amend name/email/date/custom attributes inline on the credential preview page; tick boxes (or select-all) → "Publish" → "Confirm" → recipients emailed access to the live credential.

### Lifecycle: revoke / expire / update
- [search-snippet] help.accredible.com "why-has-my-credential-been-revoked" + marketing FAQ: issuers "can expire, revoke, or update credentials at any time, even once they have been delivered"; shared credentials direct verifiers to the official credential page "where it's easy to see if the credential is live and in date". Exact revoked-state banner wording NOT captured (article unreachable — see Coverage notes).
- [search-snippet] "Updating Credentials": on a group → "Update Credentials" tab (top right) → upload spreadsheet of changes.
- [marketing-screenshot] https://www.accredible.com/frequently-asked-questions: credentials stay active "as long as you have not put an expiration date on them"; "Live Credentials" service = "Keep certifications current with ongoing validation"; analytics exportable "as a spreadsheet at any time"; recipient email has a "call to action" to view certificate; recipients log in by email address.

### Recipient-side credential page (context for issuer settings)
[observed-live] https://www.credential.net/d4bd834b-0937-4b7c-993e-e923567dc053 (loaded in browser):
- Credential page action bar ("Credential actions"): Download / Email / Embed / Help / More (dropdown). "View All Credentials" (recipient wallet link), LinkedIn profile link. Certificate image alt text pattern: "Certificate for credential <name> issued to <recipient> on <date>". Footer: "Issue Credentials" vs "Credential Recipients" nav split; "Retrieve a Credential" self-service link; 36-language selector.

---

## Certopus (help.certopus.com — Intercom KB)

### Concepts & issuance
[help-doc] https://help.certopus.com/en/articles/9040972-what-is-an-event:
- Core object = "event": "a group of certificates or badges issued for a similar purpose" (workshop, course, membership, conference). Event holds design, email template, recipient data, configurations. Multiple "recipient categories" (subgroups) per event for different credential variants. Ongoing issuance into the same event supported (per-credential issue dates).
- [search-snippet/marketing] Publish toggle: "toggle 'Publish' on to make the credential immediately available… if turned off, the credential will need to be manually generated or published in Certopus". Bulk issuing via spreadsheet upload; column↔placeholder matching.

### Designer
[help-doc] https://help.certopus.com/en/articles/9054495-how-to-design-a-custom-certificate (multiple screenshots embedded):
- Canvas certificate editor. Buttons: "Change Layout" (page size/orientation), "Change Background", "SAVE" (top-right), "YOUR CUSTOM DESIGN" (top-right, custom-design workflow), "Import Images", "USE AS BACKGROUND", "Select Certificate Design".
- Custom-design guidance: "leave blank spaces for variables/attributes that you will place from Certopus editor". SVG ("without any raster image embedded") / PNG / JPG backgrounds.
- KB structure: 6 collections — Setting Up Certopus Account (6), Digital Credentials (4), Designing (6), Integrations (11), FAQs (3), Emailing and Delivery (2).

---

## CertifyMe (certifyme.online)

[marketing-screenshot] https://www.certifyme.online/blog/send-bulk-certificates.html (blog with product walkthrough):
- Page name: "Award Credentials" (per credential template). Button "Bulk Award" → reveals "Upload CSV" + sample CSV download. CSV: one row per recipient, columns per variable attribute (Name, Course Name, Date of Completion). Verify column↔variable mapping before sending.
- "Design Template" section in left nav; "Edit your credential template" launches drag-and-drop editor for variable field placement; "Save my Credential Template". Program details form: course name, issuing organization, metadata.
- [search-snippet] analytics reports downloadable (issued counts, demographics, completion), export CSV/Excel.
- No public structured help-center found (help.certify.me belongs to a different company — workforce management). Evidence is blog/marketing only.

---

## Virtualbadge.io (help.virtualbadge.io)

### Recipient import
[help-doc] https://help.virtualbadge.io/article/uploading-recipients:
- Manual add via "Recipients" tab (name, email, dynamic custom fields).
- CSV: max 1,000 recipients per upload; UTF-8; columns: names, emails, one per dynamic custom field; sample template downloadable; Apple Numbers warning — don't enable "Include table names".
- New (draft) certificate: "simply drag and drop your CSV file into the software". Active certificate: "Add Recipients" → "Add List".
- Adding recipients does NOT auto-send; status stays "not sent" until "Send All Emails".
- Integrations: Zapier (4,000+ apps), API.
- Dynamic text: "Dyn. Content" tab, predefined "Recipient Name" field, "Add Dynamic Text" for custom fields.

### Send flow
[help-doc] https://help.virtualbadge.io/article/sending-certificates (2 screenshots embedded):
- "Send all emails" button top-right of dashboard.
- First-time: guided pop-up + vertical progress nav showing unfinished tasks (add recipients → send).
- Recurring cohorts: open active certificate, add new recipients, send — "only newly added recipients will receive the email" (idempotent resend guard).
- Not documented: test send, scheduling, per-recipient send statuses beyond "not sent".

---

## Hyperstack (thehyperstack.com/docs — docs site with llms.txt)

### Dashboard & issuance
[help-doc] https://thehyperstack.com/docs/tutorials/getting-started/hyperstack-dashboard-walkthrough/ (screenshot embedded): sidebar = admin features; workspace = usage insights + credential creation/issuance entry.
[help-doc] https://thehyperstack.com/docs/tutorials/credential-setup/issuing-credential.md (screenshots embedded):
- "Create/issue New Credential" from issuer home. Credential-group picker with top-right search.
- Recipients: manual form OR spreadsheet — "download Spreadsheet template button" (XLSX required for international characters; "Do not alter predefined rows") → "Attach the Spreadsheet and click Confirm and Continue".
- "Verify the details and click Generate Credentials" (custom issue/expiry dates settable here). Generated ≠ published: credentials land on "Under Review page"; per-credential review shows recipient view; then Issuer Home → "Pending review" → "Select all the credentials you want to publish and click publish now".

### Lifecycle: suspension (their revoke)
[help-doc] https://thehyperstack.com/docs/tutorials/miscellaneous/credential-suspension.md (3 screenshots embedded):
- Home > Credentials → select credential → "Suspend" (top menu). Reverse: Home > Credentials > "Suspended" → select → "Unsuspend".
- No suspension-reason field documented. Verification page shows suspended status indicator (screenshots). Reversible suspend/unsuspend rather than terminal revoke.
- Also in docs index: "Credential Error Correction" tutorial + "Resend Credential Invitation" (URLs in llms.txt; error-correction .md returned 404 at fetch time).

### Email & branding
[help-doc] email-customization.md: Settings > Email Templates → "Create Email Template"; template name, subject, body; "Dynamic Tags that can be used inside subject and body"; templates assignable per credential group; default template fallback. Sender-address customization not documented here.
[help-doc] branding-and-whitelabeling.md (6 screenshots embedded):
- "The branding and white-labeling are premium features" — gates landing-page appearance.
- Settings > Branding: "Horizontal Logo (Used in Credential Navigation bar)", "Navigation Bar color", "Primary text color (Used in credential page navigation bar menu)".
- Custom domain: subdomain e.g. credentials.yourdomain.com — "add a CNAME record in your DNS settings pointing to hosting.thehyperstack.com".
- Docs index (llms.txt) also lists: Verification Page walkthrough, Analytics & Insights, full REST API (issue/update/publish credential, groups, update recipient, webhooks).

---

## Credly issuer side (Credly Acclaim org admin)

[search-snippet] https://credlyissuer.zendesk.com/hc/en-us/articles/360027938531-Revoking-badges (direct fetch 403'd; snippet only):
- Path: "Badges" (left nav) → "Earners" (top nav) → search name/email → select badge → bottom of earner's badge page → "Revoke".
- Credly recommends telling the earner the reason for revocation (reason communicated by issuer, not a structured platform field per available text).
- Key doctrine: "revoking and deleting a badge are not the same thing"; revoking "leaves a record of the badge".
[search-snippet] "Badge replacements during bulk issuing (duplicate detection)" article exists (4418439056411) — bulk-issue dedupe/replacement behavior; content not retrievable.
- support.credly.com + credlyissuer.zendesk.com both return HTTP 403 to fetchers; academy.credly.com courses ("Issuing Badges", "Create and Issue Badges") likely gated. Issuer UI itself unreachable.

## BadgeCert

[marketing-screenshot] https://www.badgecert.com/:
- Portal: app.badgecert.com. Claims: "Create, issue, store, and track 100% verifiable digital badges and certificates"; "24/7 analytics with real-time data"; "View real-time insights on sharing, reach, and engagement"; "Full control over badge expiration rules"; LMS/AMS integration via APIs; "Configurable credential workflows".
- No issuer help docs public; user guides are earner-focused (badgecert.com/user-guides). No screenshots of admin UI described. Capability-level only.

---

## Cross-platform patterns

1. **Spreadsheet-first import with platform-supplied template + column→attribute mapping** — Sertifier, Certifier, Accredible, Certopus, CertifyMe, Virtualbadge.io, Hyperstack (7/8; all help-doc, Accredible help-doc/browser). Every serious player ships: (a) downloadable template pre-populated with that group's required fields/custom attributes, (b) a mapping screen tolerant of header mismatches, (c) "skip column" affordance (Accredible explicit).
2. **Two-stage issuance: create/draft → review → publish** — Accredible ("Create, but don't publish" → "View Unpublished Credentials" → Publish → Confirm), Certifier ("Create Draft Credentials" + Draft status filter), Hyperstack (Generate → "Under Review"/"Pending review" → "publish now"), Certopus (Publish toggle off → manual publish). Help-doc class.
3. **Issue-time choices: immediately / schedule / email-or-silent** — Certifier ("Issue immediately" / "Schedule issuance for later" / "Email credentials to the recipients" vs "Don't send emails"), Sertifier ("Schedule for Later", "Send a Test Credential"), Hyperstack (custom dates at generation). Test send explicitly documented only at Sertifier.
4. **Three-layer per-recipient status ladder (credential / email-delivery / engagement)** — fully formalized at Certifier (Draft–Published–Scheduled–Expired × not-sent–sending–bounced–opened × not-opened–engaged–LinkedIn); Sertifier equivalent set (Delivered, Opened, Downloaded, Shared, Undelivered, Added to LinkedIn); Virtualbadge minimal ("not sent"). Help-doc.
5. **"Added to LinkedIn" as a first-class tracked engagement outcome** — Certifier ("Added to LinkedIn profile") + Sertifier ("Added to LinkedIn"). The industry's north-star engagement metric.
6. **Expiry = banner on credential page + automated reminder emails** — Sertifier ("Expired" banner; up to 3 reminders), Certifier (red "no longer valid" banner, "Contact Issuer" renewal request icon, reminder 2 weeks before + post-expiry notice), Accredible (expiration optional; "Live Credentials" ongoing-validation upsell), BadgeCert ("expiration rules", capability-level). Credential remains reachable post-expiry — never a dead link.
7. **Revoke ≠ delete doctrine** — Credly (revoke "leaves a record"; recommend telling earner the reason) vs Sertifier/Certifier (hard delete: links/buttons die) vs Hyperstack (reversible Suspend/Unsuspend, no reason field). No platform documented a structured "revocation reason shown to verifier" field — a genuine white-space.
8. **Import-time validation triage: errors block, warnings pass with opt-out** — Accredible's pattern ("Exclude records with warnings" checkbox; grouped messages with totals; error-only CSV export in original column order with message column appended). Echoed lighter at Certifier (required-field confirms) and Credly (duplicate detection w/ replacement). Help-doc/browser at Accredible.
9. **Canvas drag-drop designer + `[recipient.name]`-style dynamic attributes + QR + layers** — Certifier (Background/Images/Elements/Text/Attributes/QR Code/Layers), Sertifier (Design/Attributes/Layers + badge Bases/Ribbons/Icons), Certopus, CertifyMe. Template galleries (Certifier "300+"; filter by category/style/color) and orientation/size pickers precede the canvas.
10. **White-label as the premium lever** — custom credential domain via CNAME/TXT (Sertifier, Certifier, Hyperstack), custom email sender/SMTP replacing platform no-reply (Sertifier "no-reply@sertifier.com" → own domain; Certifier custom sender Professional+), removal of platform attribution ("Distributed by Certifier" via Full White Label add-on), branding of credential page. Universally gated to Pro/Enterprise or paid add-ons ($99/mo custom domain, $19/mo "Verified Issuer" at Certifier).
11. **Issuer profile / directory page as public showcase** — Sertifier (Issuer Profile w/ Credentials, Collections, Recipient Directory + per-item toggles, SEO-visible), Certifier ("Verified Issuer" status add-on). Recipient directory doubles as marketing surface.
12. **Reusable components decoupled from the send** — Sertifier (Designs, Details, Email Templates as libraries assembled per campaign), Certopus (event holds design+email+recipients), Hyperstack (email templates assignable per credential group), Certifier (Credential Templates). Campaign = composition of reusable parts.
13. **Resend as a first-class recovery action** — Sertifier ("Send Again" in Analytics>Credentials; resend article), Certifier (bulk "Resend email"), Hyperstack ("Resend Credential Invitation" doc), Virtualbadge (re-send sends only to newly added). 

## Coverage notes

- **Interactive demos: ZERO found.** Searched Storylane/Navattic/Arcade/Walnut tours for Sertifier, Certifier (homepage fetched and inspected — only a "Watch Explainer" video), Certopus, Virtualbadge. No public click-through demo embeds located for any target platform. The [interactive-demo] evidence class is therefore empty.
- **Accredible**: Salesforce help center is JS-rendered; WebFetch fails ("CSS Error"). One full article (spreadsheet batch issuance) captured at help-doc/browser level before the shared browser session became unusable (another session kept stealing navigation — tabs jumped to credly.com and credential.net mid-harvest). NOT captured: revoke article body ("Why has my credential been revoked"), "What Happens When Credentials Expire" body, Analytics Overview ("credential-analytic-events"), designer docs. These remain search-snippet/capability level.
- **Credly issuer**: both support.credly.com and credlyissuer.zendesk.com return 403 to fetchers; Credly Academy issuance courses appear login-gated. Revoke flow recorded from search snippet only. Issuer admin (template management, bulk issue UI) effectively unreachable without an account.
- **BadgeCert**: marketing claims only; no public issuer documentation; weakest coverage of the set.
- **CertifyMe**: no official KB found (help.certify.me is an unrelated company); evidence is their own blog walkthrough (marketing class) — labels look real but unverified.
- **YouTube/video evidence**: not harvested — generic searches surfaced no citable walkthrough videos with readable transcripts/descriptions; no video-metadata entries recorded rather than fabricating. Accredible maintains accredible.com/videos (not itemized).
- **Hyperstack**: credential-error-correction.md 404'd at fetch time despite appearing in search index; reissue/correct flow not documented here.
- **Screenshots caveat**: for all [help-doc] entries, screenshots are referenced/embedded in the articles but their pixel content was not inspected; UI strings quoted come from article prose. Only the Accredible batch article (alt-text level) and the live credential.net page were read in-browser.
