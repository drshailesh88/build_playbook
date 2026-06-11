# Pattern: Export center — async generation with history, status, expiry

**Surface:** dashboard-reports / exports · **Observed in:** Slack, Customer.io, Eventbrite, Clay, Apollo (refs: https://mobbin.com/screens/85dd544d-465c-4062-9048-ae3111f7daea, https://mobbin.com/screens/c01b45fb-68ce-4276-9c15-0d4fd1fec457, https://mobbin.com/screens/b98182dd-1cf3-45b8-a6e9-43a035eb10d6, https://mobbin.com/screens/44af26eb-d319-4748-90b5-1707e186a32f, https://mobbin.com/screens/01d12b3e-ede8-47ba-af57-faade2137152)

## Flow
1. Requesting an export returns immediately: "Your export is now being generated. You'll receive an email when the export is ready for download." (Slack) — the user is never held hostage by a spinner.
2. A Past Exports table records every request: who requested ("Set by Sam Lee" / "Exported by jane.smith@…"), when, scope/description (Customer.io prints the attribute list), status (Waiting… / Success / progress bar — Apollo), Download button.
3. Artifacts expire and say so: Clay shows an "Expires" column; Slack footnotes "Exports will be permanently removed 10 days after they are downloaded."
4. Slack's request screen also prints what's included / NOT included — scope honesty before generation.

## Use when
Exports are slow (archive ZIP with hundreds of certificate PDFs), audit-relevant (who pulled attendee PII, when — a real concern given the old app's chronic Ops-PII scars), or produced by cron (nightly emergency kits currently land in R2 with NO UI evidence they exist).

## Avoid when
The export is small and instant (6-row Excel) — forcing async + inbox round-trip on a 2-second file is worse than a direct download. Offer sync-when-fast, async-when-slow.

## Sad paths observed
- Generation failure → status column shows it in place; the request row never silently disappears.
- Signed-URL expiry (old app: 1h) without a re-request path = dead link in someone's inbox; history page IS the re-request path.

## Accessibility
Status as text in a table (not color-only badges); download links named with the report name + date.

## Default verdict for our stack
RECOMMENDED — the rebuild already generates async artifacts (cron kits) with zero UI surface; an exports-history table also doubles as the PII-access audit trail the SCARS section begs for.
