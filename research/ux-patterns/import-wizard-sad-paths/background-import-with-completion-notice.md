# Pattern: Background import with navigate-away safety and email-on-completion
**Surface:** import-wizard-sad-paths · **Observed in:** HubSpot, Notion, Loops, Podia, Rox (refs: [HubSpot](https://mobbin.com/screens/36aa37c2-a52f-4303-a648-31245b8b7666), [Notion](https://mobbin.com/screens/27ae8065-9cc6-48ca-989f-cfb95b1f220a), [Loops](https://mobbin.com/screens/fd1c47d7-377c-48c4-a328-f8f0857897b9), [Podia](https://mobbin.com/screens/7afa9431-a200-47af-a6a4-6b4280744ffe), [Rox flow](https://mobbin.com/flows/e88d71cc-ca76-4aec-848f-01c78fc7b29c))

## Flow
1. On commit, the import is handed to a background job and the UI says so immediately: "Your import is processing. We'll send you an email when your import is finished" (HubSpot banner).
2. Navigate-away permission is explicit: "Data is being imported. Feel free to leave this window and we will send you an email when the import is complete or if any problems occur" (Notion) — note the failure clause; "While the import is happening, you're welcome to continue using Loops. We'll email you when the upload is complete" (Loops).
3. A "go back to work" action accompanies the message ("Go back to Notion" button).
4. The import lands as a detail page that fills in as it runs: HubSpot shows the file name, who started it, and Summary tiles (Import rows: 2, New records: --, Updated records: --) with an "Import in progress" illustration — the same page later becomes the results report ("Back to Import History" breadcrumb).
5. Lightweight variants: a dismissible toast "CSV Uploaded — We are parsing the CSV and adding contacts to the campaign. This may take a few minutes" (Rox); a calm full-section state "We're importing your file…" after analysis succeeded (Podia).
6. Per-row enrichment/post-processing failures surface as chips on the records themselves afterwards ("Enrichment failed" — Rox).

## Use when
- Imports exceed a few seconds (our 20MB ceiling guarantees this) — blocking a modal for minutes invites tab-closing anxiety and duplicate attempts.
- Multi-tasking admins: import is one of ten tasks during event setup.

## Avoid when
- Email is the ONLY completion channel — observed gap: no swept app showed an in-app bell/toast on completion; if email is unreliable for your users, the history page status must be the fallback and should be linked from the kickoff message.
- Tiny imports (<2s): showing "we'll email you" for a 10-row file is noise; go straight to results.

## Sad paths observed
- Failure is promised proactively ("…or if any problems occur" — Notion), so users don't equate silence with success.
- The processing page already shows knowable facts (rows in file, actor, timestamp) with "--" placeholders for pending stats (HubSpot) instead of a bare spinner.
- HubSpot keeps "Troubleshoot import errors" help link visible during processing.

## Accessibility
- Status banners are text with dismiss controls; progress communicated in words, not spinner-only.
- The "--" placeholder tiles give screen readers a stable structure that updates in place.
- Completion email must contain a deep link back to the import detail/history page.

## Default verdict for our stack
RECOMMENDED — for any import over a few seconds: commit → import-detail page with pending tiles → "safe to leave, we'll email you (and tell you if it fails)" → email links back to the detail page; history row shows live status meanwhile.
