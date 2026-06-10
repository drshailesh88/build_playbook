# org-settings — pattern index

## Coverage
- **Queries run:** by-app: "Linear workspace settings general name logo URL", "Notion settings modal workspace settings general name icon domain", plus Vercel team-settings evidence captured during the org-switcher sweep; by-flow: "rename organization change team name or workspace URL in settings". Platform: web only.
- **Apps swept:** Linear (two settings generations), Notion, Vercel, Plane, Adaline, June, Fibery (slug-at-creation).
- **NOT found / excluded:** Slack workspace-admin settings (separate admin site, not surfaced), Stripe org/business settings (not surfaced in queries run), slug-change confirmation dialog ("old links will break") — not observed anywhere, flagged in `slug-url-and-immutable-ids.md` as design-it-ourselves; post-delete confirmation dialog (type-name-to-confirm) not captured; branding/theming beyond logo (custom colors, white-label) not observed on this sweep.

## Patterns
- ★ `settings-page-grouped-nav` — full-page settings route, left nav grouped into Org vs Account scopes (Linear, Vercel, Adaline, Plane). **Recommended default IA.**
- `general-tab-identity-form` — logo + name + explicit Update + success toast (Linear, Plane, June, Notion). RECOMMENDED as the General tab content.
- `slug-url-and-immutable-ids` — locked-prefix editable slug + read-only org ID/region with inline explanations (Linear, Plane, Adaline, Fibery, Notion). RECOMMENDED.
- `danger-zone-delete` — separated destructive section, consequence copy, scheduled deletion (Linear, Plane). RECOMMENDED, owner-only.
- `settings-modal-account-workspace-split` — Notion's settings-as-modal with Account/Workspace nav. AVOID for our admin-heavy, deep-linkable settings.
