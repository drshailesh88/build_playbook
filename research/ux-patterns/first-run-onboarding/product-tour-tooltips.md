# Pattern: Product tour tooltip overlays
**Surface:** first-run-onboarding · **Observed in:** Zoho CRM, Salesforce, ClickUp, Toggl Track, Otter.ai (refs: [Zoho CRM segmented tour](https://mobbin.com/screens/4e90996d-cb99-4e9e-8c70-a87e61c0f65b), [Salesforce "Step 1 of 3"](https://mobbin.com/screens/1b478674-9a26-4872-af28-b479c0c6ce08), [ClickUp "1 of 4" invite tooltip](https://mobbin.com/screens/1210bc8b-a722-48c2-9f72-96904762bdb5), [Toggl "STEP 7/9"](https://mobbin.com/screens/fb80baca-1fd8-4e94-bd5c-954e818f94b2), [Otter.ai dot-progress tooltip](https://mobbin.com/screens/92781490-4d08-4865-99ad-ff8edf130a37))

## Flow
1. On first landing in the real UI, an anchored tooltip/popover appears pointing at a navigation element or button, explaining what it does.
2. Tooltip carries step position ("1 of 4" ClickUp, "Step 1 of 3" Salesforce, "STEP 7/9" Toggl, dots in Otter) plus Next, and usually Skip ("Skip" button Salesforce, "Skip this step" link Toggl, X close ClickUp/Otter).
3. Tour advances tooltip-by-tooltip across UI regions; Zoho goes furthest with a bottom rail of tour SEGMENTS (Main Menu 1/4, Teamspace 1/2, Modules 1/2...) — a tour of tours.
4. Tours coexist with other onboarding: ClickUp shows the tooltip on top of its Getting-started checklist; Salesforce pairs tooltips with dismissible "Create your first contact" suggestion cards.
5. Tour ends silently; no observed completion state.

## Use when
- A genuinely non-discoverable, high-value control needs one contextual nudge at the moment it matters (single tooltip, not a chained tour — Otter's single "Add a highlight" tip during first recording is the defensible version).
- Dense legacy UI where information architecture can't be simplified (Zoho/Salesforce are this case).

## Avoid when
- The UI is young and navigable — chained tours front-load information users can't act on yet and are dismissed reflexively; notably ABSENT from Linear/Notion/Attio-class first-runs in this sweep, which rely on checklists, wizards and templates instead.
- Tooltips block the element they describe or fight with other overlays (ClickUp stacks tooltip + checklist + video modal on first land — three competing demands).
- Content describes static layout ("This is your main dashboard" — Zoho) rather than prompting an action.

## Sad paths observed
- Reflexive dismissal: every observed tour leads with Skip/X — apps expect abandonment; an abandoned tour leaves no residue or resume path (unlike a checklist).
- Tour collision: ClickUp's tooltip pointing at Invite while a "Welcome to ClickUp" video modal also opens ([ref](https://mobbin.com/screens/0f25edb6-5ac0-4747-9bad-44eeec746a2f)) — overlay pile-up.
- Mid-tour context loss: Toggl's step 7/9 fires alongside a second toast ("You just saw an animation!") — competing ephemeral UI.

## Accessibility
- Anchored popovers must trap focus or be reachable next-in-DOM; auto-advancing/auto-appearing tooltips are a known screen-reader hazard (focus is yanked from the user's task).
- Dismiss must be keyboard-accessible (Esc + visible close); step position must be text ("1 of 4" — present in all observed).
- Spotlight/dimming treatments need sufficient contrast for the highlighted target.

## Default verdict for our stack
AVOID — chained tooltip tours are the legacy-CRM pattern; our reference class (Linear/Notion/Attio) ships none, and the checklist + guided-first-event combination covers the same need with persistence and user control. Permit at most one contextual tooltip per surface, fired on first relevant action.
