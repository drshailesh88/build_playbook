# Pattern: Bulk download/export — honest async states, channel choice, export history

**Surface:** certificates / bulk-download · **Observed in:** Midday, Runway, Frame.io, Tally, Trello, Duolingo, Zoho CRM (refs: https://mobbin.com/flows/cfedd50d-0a5b-4d6c-b6a1-b6b979b0e74f, https://mobbin.com/flows/f4a23403-de68-470c-9c23-7ac4ff8bea52, https://mobbin.com/flows/ae09e933-cdd6-464b-aad5-980991e8acc8, https://mobbin.com/flows/02d91dea-9b37-4f0a-8a1c-c0acc51560f0, https://mobbin.com/flows/5a6f5220-1058-4a30-9dc7-57e53418e3d3, https://mobbin.com/flows/7819fdf4-8ab5-42bd-8574-1b530acef012, https://mobbin.com/flows/a5acdca7-1674-4b30-946c-7eed32995ab5)

## Flow
1. Multi-select → persistent action bar: "4 selected — Deselect all — Download ↓" (Midday).
2. Two-stage feedback: "Preparing to download." → "4 files downloaded" toasts (Runway); inline zip progress "Zipped 1 folder · 100% ✓" (Zoho).
3. Long generation owns its states: full-page "Generating a CSV file—this may take a couple of minutes" → "Download complete, you can now close this window" (Tally).
4. Big archives offer channel choice: "Download with the Desktop App… plus preserve your folder structures" vs "Download in Browser" + "Always use this download method" (Frame.io); VERY long jobs hand off to email: "When he's finished we'll send you an email with instructions…" (Duolingo, 30-day vault).
5. Export history with sizes: "Today at 10:59 PM - 9.72 MB — Download" rows (Trello); content contract stated ("Downloads will be in a ZIP format that includes… CSV and JSON").

## Use when
Bulk certificate ZIP (legacy census #32–36) and event-archive exports — anything whose generation outlives a request cycle.

## Avoid when
Don't email-handoff small batches (an event's 200 certs zip in seconds — inline toast is right); don't block the tab for jobs that are actually safe to leave.

## Sad paths observed
- Size cap honesty: legacy already enforces 200MB aggregate (census #36) — surface the cap and the split strategy BEFORE the run, not as a failure.
- Selection lost on regeneration — Trello's history rows make re-downloads free.

## Accessibility
Action bar reachable via keyboard after row selection; progress states announced.

## Default verdict for our stack
RECOMMENDED — legacy has the lock-protected ZIP backend; steal the UI contract: selection bar, two-stage toasts, export-history rows (re-download without re-zipping), email handoff only above a size/time threshold.
