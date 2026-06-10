# Pattern: Format-quirk and limit messaging at the upload boundary
**Surface:** import-wizard-sad-paths · **Observed in:** Deel, Okta, 15Five, Airtable, HubSpot, Front (refs: [Deel](https://mobbin.com/screens/01967762-ed25-4a5c-98dc-f409d882abc7), [Okta](https://mobbin.com/screens/cab6e65b-dae5-4852-b2f0-b0201bde0141), [15Five flow](https://mobbin.com/flows/27cfd50f-ed50-40ba-a356-aaa5f23c83bc), [Airtable](https://mobbin.com/screens/36e65ded-77fa-4cc1-8f44-301b58a2493b), [HubSpot](https://mobbin.com/screens/f0277000-8884-4ac9-8ae7-8a3d085a1ace), [Front](https://mobbin.com/screens/bab57a69-6ffc-42a5-a168-20411cf371bf))

## Flow
1. Limits are printed under the dropzone before failure: "Supported format: .csv · Max file size: 10MB · Max rows allowed: 1000" (Deel); "max 10MB and 10,000 users" with a template link (Okta).
2. When the limit is hit, the error restates the limit and the fix in one sentence: "File is too large. Upload a file smaller than 10MB and containing fewer than 1000 rows" (Deel, inline red box above the dropzone).
3. Encoding quirks get named: "Import Error: Cannot decode file. Please ensure file is ASCII or UTF-8 encoded" (15Five).
4. Non-obvious format side effects get a proactive modal: Airtable's "Attachment links expiring" — "This CSV contains attachment columns with links that expire after a few hours" with a don't-show-again checkbox.
5. Plan/quota collisions surface as a persistent banner inside the wizard, not a post-import surprise: "You've used 4 of 1,000 contacts. Once you reach the contact limit, you won't be able to add new contacts" + Upgrade link (HubSpot).
6. Structural conventions enforced with a directive toast: "The first column should be 'email'" (Front).
7. Sample/template downloads sit beside the limits (Deel's Sample File + Mass import template; Okta's template link) so the fix is one click away.

## Use when
- Always — every limit your importer enforces (our 20MB cap, row caps, encoding) must be visible pre-upload and restated on violation.
- Quota-bound tenants (plan-based attendee caps) — warn during the wizard while the user can still trim the file.

## Avoid when
- Listing quirks the parser actually handles fine — warning fatigue; Airtable scopes its modal to files that actually contain attachment columns.
- Burying limits only in docs/tooltips — every observed app prints them at the dropzone.

## Sad paths observed
- Limit error repeats the exact numbers instead of "file invalid" (Deel).
- Encoding failure names the accepted encodings (15Five).
- Quota banner appears at wizard start (HubSpot step 1 of 4), before the user invests in mapping.

## Accessibility
- Limits as static text under the control — available to screen readers without triggering errors first.
- Error boxes adjacent to the dropzone in DOM order, with icon + text.
- Don't-show-again checkboxes (Airtable) must not suppress errors, only advisories.

## Default verdict for our stack
RECOMMENDED — cheap and high-trust: print our 20MB/format/encoding limits under the dropzone, restate the violated limit with the fix in the error, and surface plan caps at wizard entry.
