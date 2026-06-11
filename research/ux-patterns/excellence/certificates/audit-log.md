# Pattern: Audit log — actor + verb + object, filters, field-level diff, export

**Surface:** certificates / lifecycle-admin · **Observed in:** Zoho CRM, Discord, Cloudflare, Fibery, Gorgias, 7shifts, Grok, Contractbook (refs: https://mobbin.com/screens/b27943e6-e8ff-4fc0-8d27-dfe0c33c124f, https://mobbin.com/screens/f7ab3b03-7c7c-479c-9cfc-4e5a3c4622b1, https://mobbin.com/screens/d63c3f57-bf36-47cd-92db-15be7fd24924, https://mobbin.com/screens/8ebb779a-53f5-4ba8-b717-ea5b9cda1017, https://mobbin.com/flows/cb98b1d9-490c-4c30-b531-57d1a1ef7bbd)

## Flow
1. Chronological feed grouped by day: "05:39 AM — Sam Lee Added a Trusted Domain named Mobbin trusted domain" — actor + verb + object link (Zoho).
2. Filters: by user, by action type, by object, date range (Discord, Gorgias, Cloudflare).
3. Rows expand to field-level diffs: "Changed the name from new role to Admin" (Discord); "What Changed" column with field chips (Fibery).
4. "Export Audit Log" (Zoho); READ ONLY badge on the surface itself (Cloudflare).
5. Per-artifact variant: Document history on the item — Created → Sent to → Viewed → Signed, timestamps + actors (Contractbook).

## Use when
Issuance, revocation, template activation, bulk runs — non-repudiation for credential actions; CME audits ask "who issued this and when".

## Avoid when
Don't build the org-wide audit console inside certificates — the module needs the PER-CERTIFICATE history strip; a global log is a platform concern.

## Sad paths observed
- The log is the destination where revocation reasons and correction events become inspectable — without it, reason capture (legacy census #20) is write-only.

## Accessibility
Feed is text; diffs as text chips, not color-only.

## Default verdict for our stack
RECOMMENDED scoped to per-certificate history (issued → notified → viewed/downloaded → superseded/revoked with actor + reason) on the certificate detail; the three recurring features to keep: action filters, field diffs, CSV export.
