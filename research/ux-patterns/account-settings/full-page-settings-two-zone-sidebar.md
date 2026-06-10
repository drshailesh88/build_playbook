# Pattern: Full-page settings with two-zone sidebar (Workspace vs My Account)
**Surface:** account-settings · **Observed in:** Linear, Vercel, GitHub, GitLab, Pipedrive, folk, Frame.io (refs: [Linear](https://mobbin.com/screens/e8b79488-0647-4503-93b4-1db2be786a84), [Vercel](https://mobbin.com/screens/27420f1c-ed8e-483f-9336-5722b4850453), [GitHub](https://mobbin.com/screens/5a8b8d3c-3721-4b93-97ed-db33916d3869), [GitLab](https://mobbin.com/screens/38670cce-dc00-46bb-ad31-f080206dd25d), [Pipedrive](https://mobbin.com/screens/7ed47d98-c70b-4186-ac34-5a9b8bf02028), [folk](https://mobbin.com/screens/574745bc-656d-4c5f-ac6f-e3bf7ff3273c), [Frame.io](https://mobbin.com/screens/abc6973b-7c2d-42cb-a555-607ce6d0783e))

## Flow
1. User opens Settings from account menu or sidebar; app navigates to a dedicated settings route (leaves the working canvas).
2. Left sidebar shows grouped nav: a "Workspace"/"Company" section and a separate "My Account"/"Personal" section (Linear: Workspace + My Account; Pipedrive: My Account + Company Overview; folk: My account + Workspace).
3. Selecting a nav item renders that settings panel on the right; a back affordance ("< Settings", breadcrumb, or logo) returns to the app.
4. Personal items observed under the account zone: Profile, Preferences, Notifications, Security & Access, Sessions/Devices.

## Use when
- Settings surface is large (tenant + personal) and will keep growing; deep-linkable URLs per section are wanted; desktop-web-first.

## Avoid when
- Settings are tiny (a handful of fields) — a full sub-app is overkill; or when users must keep their work context visible while tweaking a setting.

## Sad paths observed
- Linear keeps trial/billing notices visible inside the settings shell ("Business trial ends" pill), so account state is not hidden while in settings.

## Accessibility
- Sidebar is a standard nav list (keyboard-focusable links); GitHub/GitLab group items under visible headings, giving screen readers a section structure.

## Default verdict for our stack
RECOMMENDED — maps directly to Next.js App Router nested layouts (`/settings/[section]`), scales to tenant + personal zones, and matches the Linear/Vercel quality bar.
