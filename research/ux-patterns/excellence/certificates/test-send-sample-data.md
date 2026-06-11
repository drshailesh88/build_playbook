# Pattern: Test send / preview with sample or real recipient data

**Surface:** certificates / issuance + notification · **Observed in:** Loops, Klaviyo, Eventbrite, Mailchimp, Squarespace (refs: https://mobbin.com/flows/f65e5012-07de-4ff8-baf5-0f48dbaf812e, https://mobbin.com/flows/3d5e2fe9-e730-4f9c-b3ea-a560dc559821, https://mobbin.com/flows/9ef9b49d-95d8-4dd0-9723-e6fc1e0b5ad2, https://mobbin.com/flows/190ffe09-df1f-4669-9305-8a05985d08e5, https://mobbin.com/flows/93bfcd7f-5d86-4836-af1f-19e0c8ce432e)

## Flow
1. "Send test email to:" input next to the live preview (Eventbrite); comma-separated multiple recipients + "Save emails as your default test recipients" (Klaviyo).
2. Merge-data control: Loops' "Dynamic content" tab exposes the variables as editable JSON ("Modify the dynamic content below to preview the email with real data" — `"firstName": "John"`); Klaviyo's Preview Mode renders against a REAL profile ("Search for a profile") with Desktop/Mobile toggle.
3. Success state is explicit: "Test message sent successfully" (Klaviyo); "Bon voyage, test email!" (Mailchimp).
4. Send button pair keeps test primary-adjacent: SEND TEST / SEND TO RECIPIENTS (Squarespace).

## Use when
Anything templated is about to go to many people — for certificates: render MY name on the PDF and email it to me before the batch runs.

## Avoid when
Never skip for bulk; for single issuance the deliberate-issue preview already covers it.

## Sad paths observed
- Spam-classification warning: "When you send to an email address using the same domain in the reply-to…, it can sometimes trigger Gmail… Check your junk mail if the test doesn't arrive." (Mailchimp)
- Email size meter: "Approx. 60 KB — Your email is not at risk of clipping in Gmail." (Klaviyo)

## Accessibility
Preview toggle (Desktop/Mobile) and profile search are standard controls; confirmation toast needs aria-live.

## Default verdict for our stack
RECOMMENDED — never attempted in legacy (no test-send in census); for a medical-conference audience a misrendered name/credit-hours field is a reputation event. "Send test certificate to myself" = one button on the bulk screen.
