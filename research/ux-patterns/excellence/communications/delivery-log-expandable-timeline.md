# Pattern: Delivery log — status-filterable table with expandable plain-language timeline and inline resend
**Surface:** delivery-log · **Observed in:** Customer.io, AutoSend (refs: [Customer.io sent tab](https://mobbin.com/screens/dc4b82d5-e361-499f-8bde-c52fd44308b2), [Customer.io deliveries](https://mobbin.com/screens/4ccd301f-856d-47b4-996c-e19d5ca0ef2a), [status taxonomy](https://mobbin.com/screens/b83be075-2f4b-47cd-b46e-2e6ab2e1b44e), [AutoSend activity](https://mobbin.com/screens/203c7575-11eb-45d1-bf20-ae879d22dee5))

## Flow
1. Table rows: date created / action+message name / recipient (linked to person) / STATUS badge. Status taxonomy is explicit and color-dotted: Attempted / Deferred / Sent / Failed / Bounced / Suppressed (+ Opened / Clicked) — exposed in the filter dropdown (Customer.io).
2. Filter bar: channel / status / date range; "Last updated today at 11:14 am" + AUTO-REFRESH toggle + Export to CSV.
3. Row EXPANDS in place to a plain-language relative timeline: "Created today at 11:11:53 am / Sent 2 minutes later / Bounced 2 minutes later / **Reason: No MX for topmailers.net**" — with an inline **Resend** button right where the failure is read (Customer.io).
4. AutoSend puts a FUNNEL SUMMARY STRIP above the table: REQUESTS 5 / SUPPRESSED 0 / SENT 5 / DELIVERED 100% / BOUNCED 0% / SPAM 0, each with a tooltip — the log doubles as a dashboard.
5. Search by recipient email; scope variants: per-campaign Sent tab and workspace-wide Deliveries & Drafts use the identical UI (Customer.io).

## Use when
Operators ask "did X get the email and if not why" daily — conference ops during event week is exactly this persona.

## Avoid when
Don't replace a failures-only queue with this alone; a dedicated failed view with retry semantics still pays (ours exists).

## Sad paths observed
- Bounce REASON in human words inside the row — no provider dashboard hop (Customer.io).
- Suppressed is a visible status, distinguishing "we chose not to send" from "we failed to send" (AutoSend).
- "(No subject)" placeholder rows render rather than blank cells.

## Accessibility
Expandable rows with real buttons; status badges pair dot color with text; auto-refresh is a labeled toggle.

## Default verdict for our stack
RECOMMENDED — our notification_log + delivery_events already store everything this UI needs (timestamps, error codes, statuses); the expandable-timeline row + funnel strip + auto-refresh is the M13 delivery-log target shape.
