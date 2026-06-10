# delete-org — pattern index

**Coverage note.** Queries run — by-pattern: "danger zone delete organization type name to confirm consequences", "you have been removed from this workspace screen" (returned additional delete screens), "access removed from workspace you have been logged out choose another workspace" (returned Slack/Linear delete screens); by-app evidence accumulated across Slack, Linear, Notion sweeps. Apps swept: PlanetScale, Clerk, Supabase, Campsite, GitBook, TheyDo, Linear, Slack, Superlist, Amie, Current, Strut, Fibery, Notion. NOT found: Vercel delete-team specifically (queried via reference-app names; Vercel screens did not surface — Clerk/PlanetScale/Supabase stand in at the same quality tier); grace-period/soft-delete for an ORG ("scheduled for deletion, restore within X days") — only Grain's post-hoc "marked for deletion" page (catalogued under revoked-mid-session) and GitBook's space-level 7-day trash hint at it; no org-level restore window observed.

- ★ `type-org-name-confirm-modal.md` — danger-zone card → modal with consequences + irreversibility statement + type-org-name gate + disabled destructive button (PlanetScale, Clerk, Supabase, Campsite, TheyDo)
- `itemized-consequence-acknowledgement.md` — live-counted "I understand N X will be deleted forever" checkboxes stacked on the type-name gate (GitBook, Fibery) — adopt on top of ★
- `email-code-verification-delete.md` — emailed deletion code + acknowledgement checkbox (Linear)
- `password-confirm-full-page-delete.md` — full page with export/rename off-ramps + password + checkbox (Slack)
- `acknowledge-checkbox-simple-confirm.md` — one-checkbox or plain-dialog delete (Superlist, Amie, Current, Strut)
- `deletion-reason-survey.md` — churn survey before the destructive confirm (Notion)
