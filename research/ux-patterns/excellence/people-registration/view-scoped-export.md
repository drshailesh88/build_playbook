# Pattern: View-scoped export (download what you're looking at, with honest caveats)

**Surface:** people-registration / export · **Observed in:** Airtable, Front, Luma, Pipedrive (refs: https://mobbin.com/flows/3c8b481b-50b3-461f-8f1b-097c30766101 , https://mobbin.com/flows/707ab494-e532-423f-b5bf-6e13bade31c7 , https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d)

## Flow
1. Export lives next to Import as a peer header action ("Export / Create / Import" — Front; "Import / Export ▾" — Attio header) or inside the view menu ("Download CSV" — Airtable).
2. The export is scoped to the CURRENT VIEW: active filters, visible columns, sort — what you see is what you download (Airtable per-view CSV; Luma's guest-list download icon exports that roster).
3. Async preparation gets a toast ("Preparing CSV for download…", Airtable).
4. Caveats are stated at download time: Airtable's "Attachment links expiring" dialog ("links… expire after a few hours") with don't-show-again — egress limitations are disclosed, not discovered.
5. Pipedrive additionally keeps "Export data" as a standing tool for full-DB egress, separate from view downloads.

## Use when
Always — operators live in Excel; badge printers, audit requests, and venue lists all start as "give me this list as a file".

## Avoid when
Never entirely; but role-gate it (read-only/ops roles may view yet not exfiltrate PII) and audit-log every export — for medical attendee data this is a compliance event, not a convenience.

## Sad paths observed
- Large exports go async with progress feedback instead of a hung click.
- Expiring/secondary content is flagged in a pre-download dialog.

## Accessibility
Export is a labeled menu item/button, toast announced; no icon-only download affordances except with tooltips + labels (Luma's icon is borderline — prefer labeled).

## Default verdict for our stack
RECOMMENDED — the old app has NO people export (done-spec §48 NEVER-ATTEMPTED; data leaves only via reports). Every excellence app treats Export-next-to-Import as table stakes. V1: filtered-view CSV with role gate + audit log; full-DB export stays in reports.
