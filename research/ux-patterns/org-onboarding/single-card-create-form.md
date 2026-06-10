# Pattern: Single-card create-org form (name + URL on one screen)
**Surface:** org-onboarding · **Observed in:** Linear, Frame, Notion (refs: [Linear create workspace](https://mobbin.com/screens/dc1e55eb-22df-482e-9b8f-01acacc0a676), [Linear w/ region picker](https://mobbin.com/screens/12dba166-0eef-401e-94ae-cd27d38c2d96), [Linear w/ profiling fields](https://mobbin.com/screens/33b8943b-9c4a-4337-8e4b-03a966a72719), [Frame create flow](https://mobbin.com/flows/507819f6-3d7d-40ba-94cf-2a4d539c71a0), [Notion team workspace](https://mobbin.com/screens/aafe4d3c-b61b-482f-8a3d-8e9485e284fe))

## Flow
1. One centered card titled "Create a new workspace" with a one-line value prop ("Workspaces are shared environments where teams can work on projects, cycles and issues").
2. Workspace Name input — pre-filled from the user's name/email (Linear pre-fills "John Mobbin"; Frame pre-fills "jdoe.mobbin").
3. Workspace URL input auto-derived from the name (`linear.app/as-mobbin`), editable, prefix locked.
4. Optional inline extras on the same card: hosting region select (Linear: "Workspace will be hosted in the [United States ▾]" with help "?"; note "Set when a workspace is created and cannot be changed"), company size / role selects.
5. Single CTA "Create workspace" → org exists, user lands in app or next onboarding step.
6. Notion variant: icon picker + name only, "Continue" disabled until name entered, "Cancel" top-right.

## Use when
- You want minimum time-to-tenant: one screen, one submit, org created.
- Slug/URL must be claimed at creation time (uniqueness check belongs here, inline).

## Avoid when
- You need 3+ profiling questions — cramming them onto the card buries the primary action (Frame's 4-field version reads like a survey).
- Slug is internal-only and auto-generated — then don't show a URL field at all.

## Sad paths observed
- Linear disables the CTA until name is valid; Notion greys "Continue" until name entered.
- Immutable choices are labeled as such at creation (Linear region: "cannot be changed. Read more ↗") instead of surprising users later.

## Accessibility
- Plain labeled inputs, one primary action, logical tab order. Logged-in identity shown on-screen for account confidence.

## Default verdict for our stack
RECOMMENDED — Linear's name + auto-slug card is the quality bar; pairs with the join-or-create gate and Better Auth `organization.create` in one server action.
