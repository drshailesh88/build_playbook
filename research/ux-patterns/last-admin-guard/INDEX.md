# last-admin-guard — pattern index

**Coverage note.** Queries run — by-pattern: "cannot leave team you are the last admin transfer ownership first error"; corroborated via by-flow "leaving a workspace or team" and by-app sweeps on the leave-org / transfer-ownership surfaces. Apps swept: Fireflies, Zoom, Canva, Maze, plus Notion/ClickUp/Typeform/Clay (none of which surfaced a last-admin branch). NOT found: a pure blocking error with no resolution path (toast/banner "you can't leave — you're the last admin" with only a dismiss) — absent from all swept apps, which consistently offer a resolution inside the guard; also not found: last-admin guard on role demotion (only on leave) — demote-last-admin UX has no observed precedent and must be designed from the same guard logic.

- ★ `transfer-first-wizard-inline.md` — modal embeds the member list with Make-admin actions, Continue disabled until a replacement exists, then completes the leave (Fireflies)
- `blocking-dialog-with-resolution-actions.md` — intercepting dialog offering Assign New Owner vs Delete-for-all as explicit buttons (Zoom)
