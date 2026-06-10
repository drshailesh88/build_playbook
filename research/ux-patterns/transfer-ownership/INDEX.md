# transfer-ownership — pattern index

**Coverage note.** Queries run — by-app/by-pattern: "transfer ownership of organization confirm with password re-authentication", "cannot leave team you are the last admin transfer ownership first error" (surfaced Maze + Canva transfer modals); corroborating screens from leave/remove sweeps (Lyssna, GitBook). Apps swept: Maze, Canva, GitBook, Lyssna, Fresha, Zoom (assign-new-owner branch catalogued under last-admin-guard). NOT found: Stripe account-ownership transfer (queried by name, nothing returned on web); a picker-with-search for large member lists (both observed pickers are dropdown/nominee-card scale); email-confirmation-link transfer (code-to-email exists only on Linear's delete-workspace, not transfer).

- ★ `type-name-confirm-immediate-transfer.md` — dropdown picker + modal stating "full control to X, you demoted to admin" + type org name + immediate effect and redirect (Maze)
- `nominate-and-accept-transfer.md` — consent-based transfer with 30-day acceptance window and pending state (Canva)
- `reauth-gate-before-sensitive-action.md` — session-freshness re-auth (multi-method) wrapping any privileged org action (GitBook, Lyssna, Fresha)
