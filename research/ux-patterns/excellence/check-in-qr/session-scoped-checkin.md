# Pattern: Session-scoped check-in — pick the session, then scan

**Surface:** check-in-qr / sessions · **Observed in:** Luma (web) (refs: https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198, https://mobbin.com/screens/04e7b28d-2411-461d-830d-dcde23206d83)

## Flow
1. The check-in surface carries a **Session selector** at the top ("Session: 🕐 8 Jun, 14:00 Thu ▾") — the operator sets scope ONCE; every subsequent scan/tap checks into that session.
2. Guest rows annotate relative to the session: "✓ Checked In in 13 hours" (early check-in is allowed and labeled honestly, not blocked).
3. The master guest list gets an "All Sessions" filter and per-row Session chips.
4. Counters scope with the selector ("0 Guests Approved · 0 Guests Checked In" for THIS session).

## Use when
Multi-session events (conference workshops, CME-credit sessions) where per-session presence is the billable/creditable fact. Critical for medical conferences: session attendance feeds certificates.

## Avoid when
Single-room single-track events — the selector is noise; default to event-level and hide the control until ≥2 sessions exist.

## Sad paths observed
- Early check-in (before session start): allowed, time-annotated — the audit trail, not a gate, handles it.
- Wrong-session scanning by a misconfigured station: not addressed in the harvest (gap — station naming/locking is first-principles territory).

## Accessibility
Selector must announce current scope; mis-scoped scanning is the worst silent failure on this surface, so the active session belongs in the page title/header too.

## Default verdict for our stack
RECOMMENDED — legacy schema is fully session-aware (census: sessionId on records, COALESCE unique index, session-aware duplicate checks; PATH-attendance-006) but the census shows NO session-picker UI on the qr page; the data layer was built and the control surface never was.
