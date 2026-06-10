# Pattern: Setup deferral and resume mechanics
**Surface:** first-run-onboarding · **Observed in:** Wave, Fresha, SavvyCal, Graphite, Klaviyo, Langdock, Attio, Uxcel (refs: [Wave "Finish later?"](https://mobbin.com/screens/6330c03b-49b9-4bff-ae6d-8c9ff6ca7800), [Fresha resume drawer](https://mobbin.com/screens/d91503ac-a943-46de-b72a-357800c84082), [SavvyCal Guided Setup](https://mobbin.com/screens/914ac4ee-c34e-419e-a70d-b266466b100f), [Graphite "Complete setup later"](https://mobbin.com/screens/52700a50-4600-4a27-a467-f3023a8130a0), [Klaviyo "Skip for now"](https://mobbin.com/screens/e4d1f211-cd52-42a3-b835-556bf0508064), [Langdock "Skip Onboarding"](https://mobbin.com/screens/b4f8bbf3-c566-4ccb-b533-001a1182334c), [Attio "Continue without sync"](https://mobbin.com/screens/8a212f58-b532-450c-bb47-195590df3223), [Uxcel "I'll do this later"](https://mobbin.com/screens/c0e787ee-ab2a-42a3-add2-b253f9040212))

## Flow
1. Every onboarding step that isn't strictly required carries a visible deferral affordance, scoped to the step: "Skip for now" per checklist item (Klaviyo), "Continue without sync" on an integration step (Attio), "I'll do this later" as a peer button to Save (Uxcel), "Skip Onboarding" for the whole template setup (Langdock).
2. Whole-flow deferral is confirmed with a reassurance modal: Wave's "Finish later? Only a few steps left. Come back anytime to continue your setup. Your progress will be saved" with Continue setup / Finish later buttons — exit is safe and explicit.
3. Deferred state is preserved and surfaced on return: Fresha's home drawer greets "Hi Alex, continue setting up your new account — 1 of 5 tasks completed, 60%" with a per-task "Start" button; SavvyCal keeps "Guided Setup" as a permanent sidebar item showing struck-through done items.
4. A header-level escape exists even on the celebration/checklist page itself: Graphite's "Complete setup later" button.
5. Resume surfaces double as discovery: Fresha pairs the resume drawer with "Things to try 🚀" cards (create first appointment, check reports).

## Use when
- Any setup step depends on external state the user may not have at signup (Stripe keys, DNS, colleagues' emails, event dates) — deferral is mandatory, not optional polish.
- Multi-session setup is expected; the resume surface (drawer/sidebar pill) is what makes the persistent checklist work.

## Avoid when
- The step is a true hard dependency (can't defer creating the event itself — everything hangs off it); don't offer skip on the one step that makes the product function.
- Deferral has consequences you don't disclose (SavvyCal's deferred "step" is actually a paywall — links stay inactive; consequences must be stated at skip time).

## Sad paths observed
- Silent abandonment (tab close mid-wizard): only Wave explicitly promises "your progress will be saved"; wizards without persisted drafts (Motion/Asana first-project) restart from zero.
- Skip-everything user: Langdock's "Skip Onboarding" lands them in the raw product; n8n pairs that with a dismissible "Get started faster with pre-built agents" banner as the residual nudge.
- Nagging risk: Fresha's drawer reopens on home — observed apps keep resume passive (pill/drawer) rather than modal-on-every-login; none observed re-blocking the user.

## Accessibility
- Skip links must be real focusable buttons/links, not low-contrast ghost text (Klaviyo and Uxcel render them as proper secondary buttons; Toggl's "Skip this step" is a small underlined link — weaker target).
- Confirmation modals (Wave) must focus-trap and offer keyboard escape to the safe option.
- Resume drawers should not auto-steal focus on login.

## Default verdict for our stack
RECOMMENDED — pair with the checklist and wizard: only "event name" is unskippable; every other step gets "Skip for now" with saved progress, and the checklist card is the standing resume surface.
