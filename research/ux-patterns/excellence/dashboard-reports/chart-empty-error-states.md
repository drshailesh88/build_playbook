# Pattern: Per-panel empty, error, and first-run states (chrome stays alive)

**Surface:** dashboard-reports / resilience · **Observed in:** Slack, Causal, Shopify, Mailchimp, Eventbrite (refs: https://mobbin.com/screens/6e8301b5-63ad-48a2-b71a-59e28b060c0e, https://mobbin.com/screens/557539ea-ede2-4669-ab7d-624693839f01, https://mobbin.com/screens/3286f573-4327-4022-8794-f11d9f1f74f6, https://mobbin.com/screens/031efda0-3055-497c-a640-06b70875e7e2)

## Flow
1. Failure is scoped to the panel, not the page: Slack Analytics shows "Member data unavailable — Something went wrong. Try again later." INSIDE the table area while tabs, date picker, and Export CSV remain alive.
2. Errors are actionable: Shopify's "Unable to access Bill Pay" names the cause (unverified email) and the fix (resend link + Account Settings) plus "Reload this page" — what happened / why / what to do.
3. First-run empty differs from zero-data: Causal's "This model has no charts! Create your first chart: select a variable and click New Chart" with a pointer arrow to the button; zero-data charts render full axes at zero (Mailchimp $0 cards).
4. Empty-state copy states capability + limits (Eventbrite scheduled reports: "You can schedule up to 10 custom reports…").

## Use when
Always — a dashboard composed of N independent queries WILL have partial failures; the page dying because one aggregate threw is the old app's BUG-1 lesson ("Could not load metrics" took down the whole dashboard).

## Avoid when
Nothing — but don't over-fragment: if all cards come from one snapshot query, one error block with one retry is honest; per-card retries on a shared query are theater.

## Sad paths observed (this card IS the sad-path card)
- Full-page reload-only errors (Chronicle, Tines: "An error occurred. Please reload the page.") — the anti-pattern to avoid for panel-level failures; acceptable only for app-shell crashes.
- Distinguish four states everywhere: loading skeleton · zero-data (real axes) · filtered-to-empty ("no rows match — clear filters") · failed ("couldn't load — try again").

## Accessibility
Error text in role=alert (project norm already); retry is a real button; skeletons aria-hidden.

## Default verdict for our stack
RECOMMENDED — done-spec §3.23/26/33 show the old app had pieces of this untested; the rebuild should make the four-state contract a locked pathway criterion for every dashboard panel.
