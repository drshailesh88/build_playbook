# Pattern: Table footer aggregations + live record count

**Surface:** people-registration / table chrome · **Observed in:** Attio, Airtable, Clay (refs: https://mobbin.com/flows/ba9faa69-a275-4e70-ab76-c4ae1b1f946c , https://mobbin.com/flows/3c8b481b-50b3-461f-8f1b-097c30766101 , https://mobbin.com/flows/a91dfb3c-c3d9-4a31-bca7-261f27332669)

## Flow
1. A persistent footer row shows the live record count of the current view ("13 count" Attio, "21 records" Airtable, "5 Rows, 0 Selected" Clay) — updating with every filter change.
2. Each column footer cell is a "+ Add calculation" slot (Attio) or aggregation cell (Airtable: Sum $37,064.10, Avg $1,764.96); the user picks count/sum/avg/empty/filled per column.
3. Selection count joins the row count when rows are selected (Clay).

## Use when
Ops questions are aggregate questions ("how many delegates have no email?", "how many from Mumbai?") and you want them answered without leaving the table.

## Avoid when
The count is the only aggregate anyone needs — then a header count line (which the old app already has) is enough; per-column calculation pickers are a power-user feature.

## Sad paths observed
- Aggregations are per-view and recompute under filters; none observed persisting stale values.

## Accessibility
Footer is a table row with header-associated cells, not a floating overlay.

## Default verdict for our stack
AVOID for V1 beyond the existing total count (already shipped); revisit "filled/empty per column" alongside the data-health pattern in V2.
