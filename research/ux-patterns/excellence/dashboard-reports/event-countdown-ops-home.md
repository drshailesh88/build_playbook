# Pattern: Event-lifecycle-aware home (countdown, phase bar, capacity at-a-glance)

**Surface:** dashboard-reports / event dashboard header · **Observed in:** Eventbrite, Luma (refs: https://mobbin.com/flows/e45fde58-390e-48e3-bdcd-d1b40e013c14, https://mobbin.com/screens/369500dd-c389-450c-873e-45361ae5fea7, https://mobbin.com/screens/fc3826ca-0719-4e8f-a59e-c7c0c798641a)

## Flow
1. Eventbrite organizer home leads with time-to-event: "Hey there, Sam" + "Your event is happening in **about 1 month**", the event row (date block, tickets 8/20 sold, On Sale status), then a planner timeline of dated next steps and an event-phase progress bar (Early bird → Halfway there → Last call).
2. Luma's event admin leads with "At a Glance": guest count vs capacity as a progress bar ("1 guest / cap 1,000"), status breakdown chips (1 Going · 1 Invited), and the three next-action buttons (Invite / Check In / Guest List).
3. During the event the same header flips to live counters ("0 Checked In / 3 Going" — Luma check-in).
4. Greeting is time-of-day aware (Mixpanel "Good Morning" — which the old app hardcoded; done-spec §2/§3.35).

## Use when
The workspace IS an event with a date — a conference dashboard that doesn't know "47 days out" vs "day 2 of 3" is ignoring the single most decision-relevant variable. Phase awareness can also re-rank quick actions (pre-event: invites/exports; day-of: check-in/transport; post: certificates/archive).

## Avoid when
Cross-event/global dashboards — countdown belongs to one event's workspace; the global hub aggregates instead.

## Sad paths observed
- Event date passed without closure → phase bar must have a "wrap-up" terminal state (archive, certificates), not an eternal "Last call".
- No date set → hide countdown, don't show "NaN days".

## Accessibility
Countdown as text; phase bar needs labeled steps, not color-only progress.

## Default verdict for our stack
RECOMMENDED — conference ops is countdown-driven (the cron kit window is literally 48h-pre-event); this is the cheapest "this product understands my job" signal on the whole module.
