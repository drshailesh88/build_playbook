# Pattern: Live check-in progress strip — counts against a denominator, on the scan surface

**Surface:** check-in-qr / stats · **Observed in:** Luma (web), Eventbrite (refs: https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4, https://mobbin.com/screens/77625847-95c6-46b2-b900-1b8647c84ed4, https://mobbin.com/screens/c02c6938-f9bf-4581-918f-d9bdaa104e66)

## Flow
1. Directly under the scanner viewport: "**0 Checked In** (green) ——— 3 Going" as a progress bar — the operator sees door progress without leaving scan mode.
2. Guests tab "At a Glance": "**1 guest** / cap 1,000" capacity bar with a colored legend (● Going · ● Invited).
3. Session check-in page: footer counters "0 Guests Approved · 0 Guests Checked In".
4. Eventbrite frames every count as a fraction with the denominator visible ("Tickets Sold 2/40") — never a bare number.
5. Counters update on each scan (toast + count move together).

## Use when
Any check-in surface. The denominator (expected attendees) is what turns a count into operational signal ("438 of 612, talk starts in 10 minutes").

## Avoid when
Multi-station doors where a per-device count would mislead — the strip must be the EVENT total (server truth), with offline-queued scans shown separately as pending, not silently mixed in.

## Sad paths observed
- None shown for stale counts; the harvest showed no last-updated indicator on Luma's strip (Posh shows "Last Updated 5:37pm ↻" on its guestlist — steal that for trust).

## Accessibility
Progress bar needs an aria-valuetext like "438 of 612 checked in"; count changes should NOT announce on every scan (too chatty) — announce on operator focus.

## Default verdict for our stack
RECOMMENDED — legacy has stats cards (Total/Checked In/Remaining) on the same page (census), so the bones exist; deltas are the progress-bar framing against capacity, per-session footers, and a freshness indicator.
