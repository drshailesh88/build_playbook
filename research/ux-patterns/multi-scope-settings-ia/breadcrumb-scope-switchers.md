# Pattern: Header Breadcrumb of Switchable Scope Tokens
**Surface:** multi-scope-settings-ia · **Observed in:** Vercel, Neon, PlanetScale, GitHub, Unity (refs: [Vercel project settings header](https://mobbin.com/screens/708e32df-9b01-4e97-8f53-b06e72b782af), [Vercel deployment protection](https://mobbin.com/screens/980d0f97-4e35-4706-8d2b-0e75a0e243e8), [Neon header breadcrumb](https://mobbin.com/screens/1662d1cc-c43f-4227-91f1-bf6652b2146e), [Neon org switcher open](https://mobbin.com/screens/7feb0738-4a43-4bd8-ae68-8ecfbbebf015), [GitHub org account header](https://mobbin.com/screens/5856f998-471f-4cd9-90ae-096f0f4d6003), [Unity org switcher](https://mobbin.com/screens/66cc5607-0f90-4377-b6c7-37ed462dc444))

## Flow
1. The persistent app header renders a breadcrumb chain of scope tokens: logo › team/org name (with plan badge) › project name — Vercel shows "JD Mobbin [Pro Trial] › nextjs" above Project Settings.
2. Each token is itself a switcher (⌄ caret): clicking the org token opens an org list ("Organizations… ✓ current, Create organization" in Neon); clicking the project token switches projects without leaving the page type.
3. The breadcrumb truncates to just the org token when at org scope (Neon: "alexsmith… [Free]" alone) — breadcrumb depth == current scope depth.
4. GitHub's variant labels the entity type explicitly under the avatar: "Organization account · Switch to another account ▾".
5. Unity nests it in the account menu instead: "samleemob — Switch organization › Manage organization" with a searchable org list and CURRENT badge.

## Use when
- Users belong to multiple orgs and/or hop between events often; the breadcrumb is both the "where am I" answer and the fastest lateral jump.
- URL structure mirrors the chain (/[org]/[project]/settings) so breadcrumb and address bar reinforce each other.

## Avoid when
- Single-tenant or single-event accounts dominate — a one-token breadcrumb with a dead caret is noise.
- The header is already crowded with global search/actions; a two-switcher breadcrumb needs reserved left-side real estate.

## Sad paths observed
- Vercel pairs the breadcrumb with a trial-expiry banner directly beneath it ("Your trial expires in 10 days…") — scope context and billing-state warnings coexist without colliding.
- Neon's free-plan badge sits inside the org token, so plan limits stay visible at every scope.

## Accessibility
- Tokens are real buttons with visible carets, not hover-only affordances.
- Entity-type labels (GitHub's "Organization account") disambiguate same-named entities for screen readers; bare avatar+name chains (Vercel) rely on the trailing H1 instead.

## Default verdict for our stack
RECOMMENDED — org token › event token breadcrumb in the app header is the canonical Vercel analog for tenant › event, and it doubles as the scope switcher sub-area (b) answer outside settings.
