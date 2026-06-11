# Pattern: Status-integrity guardrails — too-early blocks, escalating nags, gaming-proof metrics

**Surface:** transport · **Observed in:** Limo Anywhere, Moovs
(refs: A11, A12, A20, A21, A19 — URLs in `_raw/by-app.md`; key: https://kb.limoanywhere.com/docs/5172/, https://intercom.help/moovs-05c940f1970e/en/articles/8007480-driver-notification-remind-driver-to-update-trip-statuses)

## Flow
1. Too-early protection: "Do not allow status change X hours before Pickup Time" (default 24h) — a driver tapping On The Way prematurely gets a warning; configurable as soft (acknowledge and proceed) or hard (blocked until the window opens) (Limo Anywhere).
2. Staleness protection: time-anchored escalating reminders (Moovs, exact rules): not 'On the Way' and trip is 45 min away → nag every 10 min; not 'On Location' and 5 min away → every 5 min; not 'Passengers on Board' and 10 min PAST pickup → every 5 min; not 'Done' and 30 min past drop-off → every 15 min. Push if app installed, SMS otherwise.
3. Status vocabulary is extensible but governed: custom statuses get an immutable code + name + color; system statuses ("Dispatched", "Cancelled by Affiliate") are protected from modification; status changes stamp timestamps used downstream (driver pay, reporting) (Limo Anywhere).
4. Metrics distrust statuses: the on-time performance report uses "trip checkpoint data rather than trip status changes" — measurement decoupled from driver-entered state.

## Use when
Any driver- or ops-entered status feeds live boards, passenger notifications, or reports — i.e., as soon as statuses have consumers, they need integrity protection.

## Avoid when
V1 has no driver-facing status entry (ops marks everything) — nags don't apply; the too-early guard still does (an ops user "completing" tomorrow's batch today is the same corruption).

## Sad paths observed
- Both modes documented for premature changes: acknowledge-and-override vs hard block — pick per role.
- The whole nag feature exists because stale statuses silently rot dashboards; the fallback channel (SMS when no app) is part of the design.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
VIABLE — V1: validate status transitions against batch service date/time (no `in_progress` yesterday, no `completed` tomorrow) with explicit override + audit. Nag automation becomes RECOMMENDED the day a driver surface ships.
