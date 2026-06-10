# Pattern: Dedicated settings area with grouped left nav (Org vs Account sections)
**Surface:** org-settings · **Observed in:** Linear, Vercel, Adaline, Plane (refs: [Linear settings (classic)](https://mobbin.com/screens/480db52c-fce1-409e-9477-ff51f7cb7b12), [Linear settings (current)](https://mobbin.com/screens/60dd3590-48ba-4a6b-933a-7f8ef3ab8b6d), [Vercel team settings](https://mobbin.com/screens/f08174ad-4883-4e9a-9ae6-2d86e23f379b), [Adaline flow](https://mobbin.com/flows/da18ec57-c6e4-42d2-bb27-c01dae98f232), [Plane flow](https://mobbin.com/flows/ad1e88c4-7acb-4b4d-a2ab-583cf13bcc4e))

## Flow
1. Settings is a full-page route, not a modal: "‹ Back to app" escape at top-left of its own left nav.
2. Left nav is sectioned by scope with explicit group labels: Linear — **Workspace** (Overview, General, Security, Members, Labels, Billing…) / **My Account** (Profile, Preferences, Notifications…) / **Teams**; Vercel — **TEAM** (General, Billing, Invoices, Members, Security & Privacy…) / **ACCOUNT** (My Notifications); Adaline — **Account** / **Workspace** groups; Plane adds top-level tabs Account | Workspace | Projects above the nav.
3. Org-scoped and personal-scoped settings live in the same shell but never in the same group — scope is readable from the nav itself.
4. Content pane is a single scrollable column per nav item.

## Use when
- Settings exceed ~3 categories; org admin surfaces (members, billing, security) need URLs of their own (deep-linking, role-gating per route).
- App Router: each nav item = a route segment under `/settings/(org|account)/…`.

## Avoid when
- Tiny products with one settings card — a full area is bureaucracy.

## Sad paths observed
- Plane shows current role badge ("Admin", "Business trial") in the settings header — permission context is visible where it matters.
- Linear current version notes plan-gated rows inline ("Available on Enterprise" on Welcome message).

## Accessibility
- Real navigation (links, not tabs-in-modal) → browser back works, focus lands per page; group labels give nav landmarks.

## Default verdict for our stack
RECOMMENDED — full-page `/settings` with grouped org-vs-personal nav is the Linear/Vercel-bar answer and maps directly to App Router layouts with server-side role gating.
