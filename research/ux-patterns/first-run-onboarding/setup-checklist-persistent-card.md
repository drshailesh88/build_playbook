# Pattern: Persistent setup checklist with progress
**Surface:** first-run-onboarding · **Observed in:** Google Workspace, Adaline, Outseta, Mailchimp, Klaviyo, Slite, Time2book, ClickUp, Fresha, SavvyCal, Maze (refs: [Google Workspace](https://mobbin.com/screens/05a829a2-525b-4a6e-911a-f4d5e2e5b9ce), [Adaline](https://mobbin.com/screens/8ad4a415-bff7-4350-91af-75519784b729), [Outseta](https://mobbin.com/screens/b1bcf27d-e787-4a4d-81f7-a1ec5515f5fe), [Mailchimp](https://mobbin.com/screens/7f54a57c-ee77-4413-8422-f55774568201), [Klaviyo](https://mobbin.com/screens/e4d1f211-cd52-42a3-b835-556bf0508064), [Slite flow](https://mobbin.com/flows/c2f5c7c8-bd28-4a0c-b49c-585a942cc400), [Time2book](https://mobbin.com/screens/7108e7fa-76da-4616-9d1d-edddf9a6cb40), [ClickUp](https://mobbin.com/screens/1210bc8b-a722-48c2-9f72-96904762bdb5), [Fresha](https://mobbin.com/screens/d91503ac-a943-46de-b72a-357800c84082), [SavvyCal](https://mobbin.com/screens/914ac4ee-c34e-419e-a70d-b266466b100f), [Maze](https://mobbin.com/screens/88414f24-a07a-45be-a8ea-6d3dc6b24772))

## Flow
1. After workspace creation, a "Get started" / "Setup guide" surface appears: a dedicated page (Outseta, Klaviyo, Adaline), a card pinned to home (Maze, Google Workspace, Mailchimp), or a drawer/sidebar pill (Slite "Set up: 29% completed", Fresha right-hand drawer, ClickUp floating card).
2. Checklist shows 4–8 steps, each with title + one-line benefit; some show time estimates per step (Klaviyo "About 15 minutes") or group steps into phases (Adaline "Iterate / Evaluate" quest groups, Klaviyo's 4 phases, Google Workspace numbered sections).
3. Each item expands inline to reveal a direct CTA into the real surface (Slite "Create a channel", Fresha "Start", Mailchimp expandable rows). Some allow manual "Mark as done" (Google Workspace).
4. Steps auto-complete as the user does the real action elsewhere; completed items show check/strikethrough (SavvyCal, Graphite).
5. Progress is always visible: ring (Mailchimp 4/5, Fresha 60%), bar (Outseta 8/8), or sidebar pill (Slite, Klaviyo "0% complete", Adaline mini-widget).
6. Checklist persists across sessions in a stable location (sidebar item "Guided Setup" in SavvyCal, "Getting started" in ClickUp sidebar) until completed or dismissed.

## Use when
- The new admin must do 3+ heterogeneous setup actions (create event, invite team, configure modules) that can't be forced into one wizard.
- You want users exploring the real product, not trapped in a modal — checklist deep-links into actual surfaces.
- Setup spans multiple sessions; the persistent pill/sidebar entry is the resume mechanism.

## Avoid when
- There is exactly ONE meaningful first action (just route them into it — see guided-first-object-wizard).
- Steps are sequential hard dependencies (use a wizard; checklist implies any-order).
- You cannot auto-detect completion — manual "mark as done" checklists rot and feel like homework (Google Workspace relies on this and pads with upsell items).

## Sad paths observed
- Checklist ignored/dismissed: Mailchimp offers explicit "dismiss the checklist" link; Klaviyo "Dismiss this page" — after dismissal the apps offer no obvious re-entry on the screens captured.
- Checklist padded with vendor-interest items (Google Workspace "Set up billing", SavvyCal third step is "Upgrade to activate your link" — a paywall disguised as setup); erodes trust in the checklist.
- Per-step skip: Klaviyo "Skip for now" per item keeps progress honest instead of blocking.
- Stale partial state: Slite pill sits at 29%/71% indefinitely; Fresha greets "continue setting up" with per-task Start buttons — better recovery.

## Accessibility
- Expand/collapse rows and progress rings must be reachable by keyboard and announce state (completed/incomplete count, e.g. "2 of 5 completed" text is present in Adaline/Fresha — keep it textual, not color-only).
- Strikethrough-only completion (SavvyCal, Graphite) needs an accompanying check icon + aria state; observed apps pair both.
- Sidebar progress pills (Slite) are small targets; pair with a full-page checklist view.

## Default verdict for our stack
RECOMMENDED — Event State's admin has exactly this shape of work (create first event → invite team → explore modules); a persistent dismissible checklist card on tenant home with auto-detected completion is the dominant, proven pattern across every reference app swept.
