# Pattern: Issuer analytics — per-template usage counts + engagement stats + compliance nudge

**Surface:** certificates / reporting · **Observed in:** Canva (admin Reports), Teachable, Luma, AutoSend (refs: https://mobbin.com/flows/b5f92b31-b5c8-4b32-b06d-b03a27c74025, https://mobbin.com/flows/21f569ff-7862-482d-85e8-3f33d1d25c22, https://mobbin.com/screens/50740c5b-cfba-47d6-8f87-3114eecced4d, https://mobbin.com/flows/9d10f1ae-8ab3-425b-993c-2d810a904be1)

## Flow
1. Per-template counters where the template lives: "Issued 0 times" + last-updated on the card (Teachable); sortable Used / Published / Shared per template table + "Download report" (Canva Reports).
2. Usage summary cards: Designs created / Total published / Total shared, with member split (Canva).
3. Per-send engagement: "Open Rate — 2 Opened • 4 Delivered" popover with per-person chips (Luma); per-campaign KPI cards REQUESTS / SENT / DELIVERED / OPENS (AutoSend).
4. Compliance nudge with action: "Some designs aren't using a Brand Kit… make sure everything's on brand." + "View designs" (Canva).

## Use when
The issuer asks "which templates are used, were the certificates received, were they viewed/verified?" — closes the loop after bulk sends.

## Avoid when
Don't ship vanity dashboards before delivery-log basics exist; counts belong NEXT TO the objects (template card, certificate row) before they belong on a dashboard.

## Sad paths observed
- "Not tracking" state shown honestly when a channel can't report (AutoSend).

## Accessibility
Counters as labeled text; sortable tables with proper headers.

## Default verdict for our stack
VIABLE — legacy already counts verifications (census #43); add "Issued N times" per template and verification-count per certificate as inline stats first; dashboard-level reporting is the dashboard-reports module's job.
