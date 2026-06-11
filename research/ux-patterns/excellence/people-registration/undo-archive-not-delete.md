# Pattern: Archive-not-delete with undo toast (reversible by default, confirm only the irreversible)

**Surface:** people-registration / destructive actions · **Observed in:** Attio, Notion, Airtable, Neon, Front (refs: https://mobbin.com/flows/68010b7b-10dc-46bf-a183-5f3f419d9075 , https://mobbin.com/flows/30b98bed-ae6c-4b9d-bf43-b03193211e1f , https://mobbin.com/flows/09eadbd7-fd3a-4694-a70b-f3cc3ca1d888)

## Flow
1. The default destructive verb is ARCHIVE/TRASH, executed immediately with an undo toast — no confirm dialog (Attio: "Status (2) attribute archived — Undo"; Notion: "Moved to trash — Undo"; Airtable: "Base moved to trash — UNDO").
2. Archived items collapse into an expandable "Archived" section in place, restorable any time (Attio attributes).
3. Truly irreversible operations invert the pattern: explicit confirm modal naming the consequence ("permanently delete the selected records" — Neon) or an up-front warning in the flow ("Merging cannot be undone" — Front).
4. The hierarchy: instant+undo for reversible → confirm for permanent → double-confirm + role-gate for catastrophic (GEM's anonymize already does the last).

## Use when
All people-module destructive verbs: archive person (reversible), merge (irreversible), anonymize (irreversible + super-admin).

## Avoid when
Undo cannot actually restore full state server-side — an undo that half-restores is worse than a confirm. Don't use undo toasts for actions with external side effects (sent emails, issued certificates).

## Sad paths observed
- Undo expires with the toast; the archived section remains as the slow path to recovery.
- Archived records keep detail pages reachable with an "Archived" badge + Restore (GEM already ships this — keep).

## Accessibility
Toasts with actions persist long enough to reach (≥10s), are focusable, and the action is a real button; never the only recovery path (archived section is).

## Default verdict for our stack
RECOMMENDED — swap GEM's archive confirm-dialog for instant-archive + undo toast (restore action already exists server-side), keep confirm for merge and double-confirm for anonymize. Add an "Archived" saved view so recovery is discoverable (today archived people vanish from all lists).
