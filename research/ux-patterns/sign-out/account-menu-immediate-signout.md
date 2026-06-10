# Pattern: Sign out as last item in account menu, immediate, no confirmation
**Surface:** sign-out · **Observed in:** YouTube, Vapi, Runway, Pitch, Hootsuite, Origin, Fireflies (refs: [YouTube menu](https://mobbin.com/screens/44a3f09f-bb36-451a-a724-42ea6838e8b0), [Vapi flow](https://mobbin.com/flows/910809f2-7fc1-49bb-9572-d4f33e37ccf7), [Runway flow](https://mobbin.com/flows/a6b45554-fcd8-4bdc-8a26-d38df205b9d8), [Pitch flow](https://mobbin.com/flows/d6d80f6b-9d98-4826-b020-444fa4bca705), [Origin flow](https://mobbin.com/flows/d4389e0a-4bb8-400f-93d3-5098cbe63f72), [Hootsuite panel](https://mobbin.com/screens/155a6fa5-52e6-466e-b3b3-6333eb747dd6), [Fireflies menu](https://mobbin.com/flows/4417f42f-b92a-476b-b77b-1392410b9fac))

## Flow
1. User opens the account/avatar menu (top-right avatar: YouTube, Runway; sidebar workspace switcher: Pitch, Vapi; settings panel: Origin).
2. Menu shows identity (name/email) at top, account/workspace items in the middle, and "Sign out"/"Log out" as the LAST item, visually separated; Vapi, Origin, and Fresha render it in red/destructive color ([Fresha ref](https://mobbin.com/screens/c4bdd6f3-7e9a-4a3f-bd9f-a40eae5016be)).
3. Click signs out immediately — no confirmation dialog in any observed B2B app.
4. Lands on the login page (Vapi, Runway, Origin, Pitch).

## Use when
- Default for B2B SaaS: signing out is low-cost and reversible (log back in), so a confirm step is friction. Place it last in the account menu — universal muscle memory.

## Avoid when
- Signing out destroys unrecoverable state (unsent drafts, local-only data) — then confirm (see signout-confirmation-dialog card); or in kiosk/shared-device products where accidental click cost is asymmetric.

## Sad paths observed
- None shown; destructive-red styling (Vapi, Origin, Fresha) is the only guard against mis-click.

## Accessibility
- Standard menu item; separator + destructive color must not be the only signal — the label text ("Sign out") carries the meaning.

## Default verdict for our stack
RECOMMENDED — immediate sign-out from the account dropdown, last position, destructive styling, land on /login; matches every reference-grade app observed.
