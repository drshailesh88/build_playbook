# Pattern: One-tap list check-in — search-first door mode without a camera

**Surface:** check-in-qr / manual check-in · **Observed in:** Partiful, Luma, Posh (refs: https://mobbin.com/flows/615d6618-b41d-4b54-a012-d518ef0ad559, https://mobbin.com/flows/26b0f3ea-2156-43d2-b580-f4774fbb7fc7, https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684)

## Flow
1. Guest list with a search field pinned on top ("Find a guest…" / "Search event guests…").
2. Status segmentation: tabs (Going / Invited / Not Going / Checked In — Luma) or filter chips with live counts ("👍 Going 1 · 🤔 Maybe 1" — Partiful).
3. Each row: avatar, name, email/handle, status chip, and a per-row **Check in** button.
4. Tap → button flips to a filled ✓ (Partiful) or the row gains a "· Checked In" annotation (Luma); no navigation, no dialog.
5. Bulk-actions sheet on the list: "Download CSV" / "Check in guests" (Partiful).
6. Sort control (by register time, status, name) for desk-style lookup.

## Use when
QR-less situations: phone dead, never got the email, registered 30 seconds ago at the desk, VIP who shouldn't be asked for a code. Also the entire door mode for small/casual events.

## Avoid when
It's the ONLY mode at high volume — name search is ~10x slower than a scan; keep it one tap from the scanner, not instead of it.

## Sad paths observed
- Empty status segment: explicit empty state "No Guests — There are no guests of this status." (Luma).
- Ambiguous names: rows carry email + avatar as disambiguators; search matches across fields.

## Accessibility
Per-row button state must change in accessible name (Check in → Checked in), not just fill; status tabs need counts announced.

## Default verdict for our stack
RECOMMENDED — legacy already has CheckInSearch (census: full-text search, per-registration button, already-checked-in marking); deltas are status segmentation with counts, avatars for face-matching, and bulk actions on the same list.
