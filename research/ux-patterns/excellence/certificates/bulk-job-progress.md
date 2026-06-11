# Pattern: Bulk job progress — aggregate % + per-item status + failure isolation

**Surface:** certificates / bulk-issuance · **Observed in:** AWS S3, PandaDoc, Jira, mymind, Profound, Tally (refs: https://mobbin.com/screens/d0b2a1fa-99a9-4c29-ba83-f77a3f850d40, https://mobbin.com/screens/f7443f66-5e59-433b-a611-deebd86db562, https://mobbin.com/screens/ac622c55-a317-42ef-8bc2-9440231108a6, https://mobbin.com/flows/02d91dea-9b37-4f0a-8a1c-c0acc51560f0)

## Flow
1. Top progress banner: %, remaining count/size, est. time, Cancel (AWS).
2. Summary card splits **Succeeded / Failed** counts live (AWS); header counts items: "Imported 1 of 4 files" (PandaDoc).
3. Per-item table: Status column (Succeeded / In progress (58%) / Pending) + dedicated Error column (AWS).
4. Navigation contract stated explicitly — one of two, never ambiguous: "Keep this window open so your bulk import can continue uninterrupted." (PandaDoc) vs "You can navigate away and come back once the task has completed." (Jira).
5. Completion banner + counts (AWS "Upload succeeded").

## Use when
Any batch over a few seconds: bulk certificate generation, bulk notification, bulk ZIP.

## Avoid when
Sub-second operations — a progress theater for 5 rows erodes trust.

## Sad paths observed
- Failed counter + per-row error column isolates failures without killing the batch (AWS).
- Ephemerality warned: "After you navigate away from this page, the following information is no longer available." (AWS) — persist run results instead (see issuer-analytics / audit-log).

## Accessibility
Progress needs aria-live polite updates at milestones, not per-percent; per-row status as text.

## Default verdict for our stack
RECOMMENDED — legacy has queued batches + completion counts (pathways PATH-certificates-004: generated/skipped/failed) but no per-recipient live table; add per-item rows with error text and a persisted run record. State the navigation contract (Inngest = safe to leave: say so).
