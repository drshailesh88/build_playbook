# Pattern: Global date-range control with named presets + compare-to

**Surface:** dashboard-reports / overview, report pages · **Observed in:** Mailchimp, Mixpanel, Amplitude, Front, Toggl (refs: https://mobbin.com/screens/b3f28c30-f957-44b0-904b-4e629ce606b1, https://mobbin.com/screens/5a96aa64-7f0f-49f2-8624-ace6a1868706, https://mobbin.com/screens/61716928-e7a8-41f3-ad75-71459432d78c, https://mobbin.com/screens/917464ff-021c-430e-a254-60a2b9beb06b, https://mobbin.com/screens/10d96779-e6e7-4366-8a2c-625ce1e62bc6)

## Flow
1. One control at the top of the board scopes every widget: named presets (Today / Yesterday / 7D / 30D / 3M / 12M / Custom — Mixpanel segmented; Mailchimp dropdown list with Quarter-to-date etc.).
2. Comparison is a separate, optional control: Mailchimp pairs "Date range" with a "Comparison" dropdown ("Previous 30 days"); Mixpanel shows it as a removable chip ("Compare to previous day ×").
3. Custom range = dual-month calendar with explicit start/end inputs (Front, Amplitude); Amplitude adds Last/Since/Between tabs and an "Add Offset" affordance.
4. Comparative rendering: Toggl overlays both periods on one x-axis with dual date labels per tick (Mon 08/21 over Mon 08/28).

## Use when
Multiple widgets share a time scope — a per-chart picker forces N interactions for one question ("how was last week?").

## Avoid when
The dashboard is event-lifecycle-scoped rather than calendar-scoped (a 3-day conference cares about "since registration opened" and "day 1 vs day 2", not "last 30 days") — presets must be domain-tuned (e.g. "Since reg opened", "Last 7 days", "Day of event") or the control is borrowed furniture.

## Sad paths observed
- Range with no data → charts render with full axes at zero (Mailchimp $0 cards), never blank panels.
- Mixpanel's chip pattern makes the comparison dismissible — avoids the "why are there two lines" confusion for new users.

## Accessibility
Preset buttons are real buttons (keyboard reachable); calendar needs full arrow-key support; the active range must be announced as text, not just highlighted.

## Default verdict for our stack
VIABLE — valuable on a registrations-over-time chart; the full preset battery is overkill for V1. Domain-tuned presets are the differentiator if adopted.
