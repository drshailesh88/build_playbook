# Pattern: Audit log with from→to + actor (incl. Automated), layered with undo toast + trash/restore
**Surface:** rooming · **Observed in:** Customer.io, Coda, Dropbox, 1Password, 15Five, PlanetScale, Asana, HubSpot, GitBook, Fibery
(refs: https://mobbin.com/screens/b38ebe97-02ca-4634-95ea-5b959fe8c9b5 , https://mobbin.com/screens/9992a223-1c84-45a1-9267-8094d8c2c70b , https://mobbin.com/screens/36cb9092-004d-4cfa-abc7-930e4a7ff931 , https://mobbin.com/screens/762eacbd-2fb7-452d-a5c5-f631a55cc564 ; raw: `_raw/by-pattern.md` §P15/P29)

## Flow
1. Audit row = sentence + structured from→to: "[X]'s role was changed from a Doc Maker to an Editor by Jane Smith." (Coda); expanded JSON `{ from: "", to: "…" }` with provenance "Source: manual change in dashboard by [email], IP: …" (Customer.io); "Previous value: invited · New value: active" (Dropbox).
2. Actor taxonomy includes `Automated` (15Five) — system reallocations attributable.
3. Failure events are first-class rows ("Attempted to Send Email", "Bounced Email"); visibility permission-scoped and stated (1Password).
4. Undo layer one — toast: "Product Demo - A was deleted · Undo" with draining timer; for edits too: "Date updated to Tomorrow 17:00 · Undo" (Asana/Todoist).
5. Undo layer two — the vacated place explains itself ("It was moved to Trash") and a Trash table (Entity / When / Who / Restore) with stated retention ("permanently deleted after 7 days") (HubSpot/GitBook/Fibery).
6. Restore confirmed with its own toast ("Welcome back! This space has been restored…").

## Use when
Every assignment mutation; dispute resolution with hotels/delegates; recovering a fat-fingered unassignment before it propagates.

## Avoid when
Treating the audit log as the user-facing history — it backs the UI; the delegate record shows the curated Communications ledger (`delegate-response-capture.md`).

## Sad paths observed
Bounced/failed sends logged; deletion recoverable in two layers; retention windows stated.

## Accessibility
Sentences + structured values; undo toasts keyboard-reachable and persistent long enough.

## Default verdict for our stack
RECOMMENDED — the rooming audit row: "Tanaka moved from Hilton Twin 412 to Marriott King 218 by [ops] · notified hotel ✓ / delegate ✓" with expandable from→to and Automated actor. Undo-before-notify is the cheap path; after notification, reversal becomes a new cascade send.
