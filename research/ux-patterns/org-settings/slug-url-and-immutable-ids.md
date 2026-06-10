# Pattern: URL/slug row with locked prefix + read-only immutables
**Surface:** org-settings · **Observed in:** Linear, Plane, Adaline, Fibery, Notion (refs: [Linear URL field](https://mobbin.com/screens/480db52c-fce1-409e-9477-ff51f7cb7b12), [Linear region immutable](https://mobbin.com/screens/60dd3590-48ba-4a6b-933a-7f8ef3ab8b6d), [Plane workspace URL](https://mobbin.com/flows/ad1e88c4-7acb-4b4d-a2ab-583cf13bcc4e), [Adaline slug + org ID](https://mobbin.com/flows/da18ec57-c6e4-42d2-bb27-c01dae98f232), [Fibery slug claim at signup](https://mobbin.com/flows/028cdf95-4b10-4eb0-a0be-44f333ab340a), [Notion domain](https://mobbin.com/screens/c14151f0-6cf8-4b17-9dae-8b488d8b1437))

## Flow
1. Slug rendered as a composite field with the host prefix locked and only the slug segment editable: `linear.app/`**slmobbin**, `app.plane.so/`**asmobbin**, `jsmobbin`**.fibery.io** (suffix-locked variant), Notion: `outgoing-meeting-048`**.notion.site** with a "Set your own" upgrade link.
2. Slug is first claimed at org creation (auto-derived from name, uniqueness-checked inline — Fibery "Fill your company name and check workspace URL"), then editable later from General settings via the same Update button as name (Linear, Adaline).
3. Truly immutable values are shown read-only with explanation: Adaline "Organization ID — org-8b84691f… This is the identifier for this organization and may sometimes be used in API requests"; Linear region — "Set when a workspace is created and cannot be changed. Read more ↗".
4. No app observed hid the slug; even when uneditable it stays visible as the org's address.

## Use when
- Org slug appears in URLs (tenant routing) — show it, lock the prefix, validate uniqueness inline on both create and rename.

## Avoid when
- Slug is purely internal — then expose only a copyable org ID (Adaline style) and skip rename machinery entirely.

## Sad paths observed
- **Gap:** no app surfaced a "changing your URL breaks old links" confirmation dialog in harvested screens — the danger communication for slug rename is under-specified in the wild; assume we must design it.
- Immutability is always labeled at point of display, never discovered by failed edit.

## Accessibility
- Locked prefix as static text adjacent to the input keeps the editable target small and unambiguous; read-only fields rendered as disabled inputs with explanatory helper text.

## Default verdict for our stack
RECOMMENDED — locked-prefix slug row + copyable read-only org ID; add (design ourselves) a confirm dialog on slug change since no observed reference covers it.
