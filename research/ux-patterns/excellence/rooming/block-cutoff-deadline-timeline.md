# Pattern: Deadline-tier timeline (refund cliffs / cutoff dates with per-tier consequences)
**Surface:** rooming · **Observed in:** Vrbo, Airbnb, American Airlines, Codecademy, Linktree
(refs: https://mobbin.com/flows/b44f3218-ce6b-44ed-8df0-223e6e84485f , https://mobbin.com/screens/c8b30eb5-2755-4d35-be80-45c2a8aba753 , https://mobbin.com/screens/155d1353-a9e7-41be-af05-9450a6208d57 , https://mobbin.com/flows/339b5c1d-1fdf-446d-903a-2d62adffe299 ; raw: `_raw/by-flow.md` §F12/F14, `_raw/by-pattern.md` §P23/P31)

## Flow
1. Vertical timeline with date nodes and consequence badges: "Today — Full refund → Oct 30 — Partial refund → Check-in"; "Cancel by 11:59pm (property's local time) on the date listed…" (Vrbo); Airbnb: "Reservation confirmed · Full refund → 24 Jun, 3:00 PM · Full refund, minus the first night → 25 Jun · Check-in".
2. Live countdown on the free-change window: "You can cancel for all passengers within 48 hours 9 minutes for a refund." (AA).
3. Persistent banner pairing relative + absolute: "03d:23h:18m:51s … Ends Oct 4." (Codecademy).
4. Auto-expiring state: "Active until [datetime, timezone]… will automatically restore when the Redirect expires." (Linktree).

## Use when
A contracted block has cutoff/attrition/release dates with money consequences; delegates have cancellation deadlines tied to those dates.

## Avoid when
No real deadline exists — countdown theater erodes trust (every Mobbin countdown observed outside policy contexts was marketing pressure).

## Sad paths observed
- The whole pattern is sad-path engineering: penalty schedules rendered visually before the act; "Cancellations can't be reversed." bolded; "Times are based on the property's local time."
- Expiry handled by design: state auto-reverts (Linktree), items move to "Past" (OpenSea).

## Accessibility
Pair every live countdown with the absolute date; countdowns must not be the only signal.

## Default verdict for our stack
RECOMMENDED as the *grammar* — but note honestly: no app on Mobbin applies it to ops-side block cutoffs ("Hotel releases 12 unsold rooms in 5 days"). That application is first-principles assembly (`first-principles-gaps.md` #4) borrowing this exact visual language.
