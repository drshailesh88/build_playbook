# Pattern: Automation builder — trigger→action stack, test with real record, draft until activated
**Surface:** automation-triggers · **Observed in:** Airtable, Attio, HubSpot, Klaviyo, HoneyBook, Tines (refs: [Airtable](https://mobbin.com/screens/0c875d47-d678-4e3d-810d-1034d4468391), [Airtable test fail](https://mobbin.com/screens/6fe09f43-28e0-4b38-8ee3-83d585895969), [Attio](https://mobbin.com/screens/011b0bc8-2ab9-4722-bef0-b598870d2811), [HubSpot](https://mobbin.com/screens/ed1431fd-2e61-4006-84de-223a9ea3ce53), [Klaviyo flow](https://mobbin.com/screens/62ce7150-570f-4c3e-b8eb-d040a43e4a53), [HoneyBook](https://mobbin.com/screens/4770d160-cb9d-4fb2-a330-b95c2da6d2ee))

## Flow
1. Left: list of automations, each with an ON/OFF toggle and an auto-generated one-line summary ("At a scheduled time, send an email") (Airtable).
2. Center: vertical TRIGGER → ACTIONS card stack; "+ Add advanced logic or action". Right: config panel for the selected card — trigger type, table/entity, visual condition rows ("When Date is within the next 7 days") + "Add condition" (the guard-condition UI).
3. TEST STEP block in the config panel: "Test this trigger to confirm its configuration is correct" with "Use suggested record / Choose record"; RESULTS block shows the failure in red ("Table does not contain any records that match the provided filters") plus a "Fix testing error" chip on the canvas (Airtable).
4. Draft-until-published is universal: "This workflow has not yet been published" banner + Publish (Attio); "Workflow is OFF" chip + Review CTA (HubSpot); "Review and turn on" (Klaviyo); SAVE vs ACTIVATE split (HoneyBook).
5. Misconfigured steps wear inline badges: red "• Changes needed" on a Send-email step (HubSpot); yellow "⚠ Set up email" + per-node Draft status (Klaviyo).
6. Run history / Revision history tabs record what fired and what changed (Airtable); per-node Run/Test/Events toolbar (Tines).

## Use when
Triggers fan out to real recipients — test-with-a-real-record plus draft-until-activated is the difference between configuring and praying.

## Avoid when
Fixed built-in cascades with no user configuration — show them as a readable registry instead (see system-template-registry).

## Sad paths observed
- Test failure is a first-class state with remediation copy and a learn-more link, shown BEFORE the automation can be enabled (Airtable).
- Wait/branch logic (HoneyBook Yes/No on "file viewed within 1 day"; Klaviyo conditional split) shows where non-responders go — the unhappy branch is visible, not implied.

## Accessibility
Stack cards are buttons; config is plain form controls; status conveyed by badge text, not only color.

## Default verdict for our stack
RECOMMENDED (form-first variant) — our M53 triggers page should adopt: visual guard-condition rows, a "Test with a real record (no real sends)" block, enabled-only-after-save semantics, and misconfiguration badges. Full drag canvas is AVOID for v1 — Cal.com/Airtable form-style covers our trigger shapes.
