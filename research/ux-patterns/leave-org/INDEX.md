# leave-org — pattern index

**Coverage note.** Queries run — by-app: "leave workspace confirmation dialog Notion Slack"; by-pattern: "last member leave workspace will be deleted owner cannot leave"; by-flow: "leaving a workspace or team". Apps swept: Notion (workspace + teamspace), Typeform, ClickUp, Clay, FLORA, Fireflies, Zoom. NOT found: an explicit last-member-leaves treatment ("leaving will delete this org" / auto-archive) — no app surfaced it on Mobbin web; owner-leaving guards exist but are catalogued under last-admin-guard (Fireflies, Zoom), not here. Slack web returned account-deactivation pages rather than a member-initiated leave flow, so Slack is absent from this surface.

- ★ `danger-zone-leave-with-confirm.md` — Leave colocated with Delete in settings danger zone, consequence copy on the row, minimal confirm dialog (Notion)
- `inline-leave-action-with-toast.md` — leave on the org list/overflow with light confirm, post-leave landing on org picker, success toast (Typeform, ClickUp, Clay, FLORA)

**Open design decision for us (no observed precedent):** last member leaving — block-and-point-to-delete-org vs auto-delete. Must be decided from first principles; Mobbin gave no candidate.
