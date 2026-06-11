# Pattern: Freshness stamps + manual refresh on every aggregate

**Surface:** dashboard-reports / all metric surfaces · **Observed in:** Stripe, Amplitude, Eventbrite, Front (refs: https://mobbin.com/flows/29a0bba1-f256-494d-9756-77cb7bb2ef4f, https://mobbin.com/screens/61716928-e7a8-41f3-ad75-71459432d78c, https://mobbin.com/flows/9261e137-c8a1-4cec-a39c-2786af0e0864, https://mobbin.com/screens/917464ff-021c-430e-a254-60a2b9beb06b)

## Flow
1. Every chart/card states its data age: Stripe "Updated 06:23" / "Updated yesterday" per card; Front "Last updated 1 minute ago" at page level; Eventbrite report pages "Last updated 2 hours ago"; the analytics explorer states cadence "Updates every minute".
2. Amplitude pairs the stamp with action: "Computed 6 min ago · ⟳ Refresh" — the user can force recomputation instead of F5-ing the whole app.
3. Stamps sit at the granularity of the computation (per-card when cards load independently, page-level when one query feeds all).

## Use when
Always, on any aggregate — trust in a dashboard is exactly trust in its freshness. During day-of-event ops ("did the last 10 check-ins land?") this is the difference between a tool and a decoration.

## Avoid when
Data is hard-realtime by construction and labeled so ("Realtime" badge, Amplitude live-users gauge) — a timestamp on a websocket feed is noise.

## Sad paths observed
- Refresh failure must keep the LAST stamp + an error note, never silently show stale data as fresh (old app BUG-1 "Could not load metrics" + Try again is the precedent; done-spec §3.26 wants the retry path tested).
- Torn snapshots (done-spec §2: Promise.all of 9 selects, transactions reverted on neon-http) — a single "as of" stamp per load at least makes the snapshot's claim explicit even when reads aren't transactional.

## Accessibility
Relative times need absolute datetime in title/aria; auto-updating stamps shouldn't announce on every tick.

## Default verdict for our stack
RECOMMENDED — trivially cheap (one timestamp per payload), uniquely high trust yield, and it honestly papers the known torn-snapshot exposure until a driver-compatible fix exists.
