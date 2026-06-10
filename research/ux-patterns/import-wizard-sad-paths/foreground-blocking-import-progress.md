# Pattern: Foreground blocking progress with keep-window-open warning
**Surface:** import-wizard-sad-paths · **Observed in:** PandaDoc, Employment Hero, Reflect, AWS (refs: [PandaDoc](https://mobbin.com/screens/f7443f66-5e59-433b-a611-deebd86db562), [Employment Hero](https://mobbin.com/screens/896e3581-0282-4f0e-a61d-b1f6ae4cd6cd), [Reflect](https://mobbin.com/screens/e92a21ff-f8fb-42f7-aa0a-4894d0c10d74), [AWS](https://mobbin.com/screens/d0b2a1fa-99a9-4c29-ba83-f77a3f850d40))

## Flow
1. Import runs in the page session; the UI demands presence: "Keep this window open so your bulk import can continue uninterrupted" (PandaDoc); "Please give us a few minutes to process your data. Please do not close this" (Employment Hero).
2. Progress is itemized where possible: "Imported 1 of 4 files" with per-file states — Imported / Processing / Uploading 90% (PandaDoc); numeric progress bar "0/7 · 0%" (Employment Hero); count-up "Imported 0 out of 1…" (Reflect).
3. A Cancel action stays available mid-run (PandaDoc "Cancel import", Reflect "Cancel").
4. AWS shows the consequence of this architecture: a banner warns "After you navigate away from this page, the following information is no longer available" — per-file Succeeded/Failed detail exists only in-session, alongside a Summary (Succeeded: 2 files / Failed: 0) and a live per-file status table with an Error column.

## Use when
- The upload itself is the long pole (file bytes still streaming from the browser) — navigation genuinely would kill it; PandaDoc's case is multi-file upload.
- Short, synchronous imports where adding a job queue is real engineering cost and the wait is under ~30 seconds.

## Avoid when
- Multi-minute server-side processing — "do not close this" for minutes is hostile and fragile (crashed tab = lost visibility); the background+email pattern dominates here.
- Results matter later: AWS's evaporating report is the cautionary tale — results must persist to a history page regardless of architecture.

## Sad paths observed
- Mid-run cancel offered (PandaDoc, Reflect) — the only observed way out of a wrong-file commit in foreground mode.
- AWS discloses the data-loss-on-navigation behavior explicitly rather than letting users discover it.
- Per-item status lists make stalls visible (which file is stuck) versus a global spinner.

## Accessibility
- Progress must be text-mirrored ("1 of 4", "65%"), not bar-only; all observed apps do this.
- Keep-window-open warnings should be assertive live regions since they change user behavior.
- Cancel is a labeled button, reachable without dismissing the progress surface.

## Default verdict for our stack
AVOID — for our batch import (background job + history page already decided); acceptable only for the upload phase itself, and even then the post-upload processing must survive navigation and persist results to import history.
