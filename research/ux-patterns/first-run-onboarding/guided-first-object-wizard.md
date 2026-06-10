# Pattern: Guided first-object creation with live preview
**Surface:** first-run-onboarding · **Observed in:** Asana, Airtable, Motion, ClickUp (refs: [Asana "Let's set up your first project"](https://mobbin.com/screens/176e7d11-e21c-49d8-9096-1ce77ea4d6cd), [Asana layout pick](https://mobbin.com/screens/54db7ec2-06cb-4a1f-add1-2cfc7b842e29), [Airtable name+color](https://mobbin.com/screens/7b0294ea-5877-4c62-ba55-2dc6252c0eb8), [Airtable seed rows](https://mobbin.com/screens/d43001c0-0787-4d99-ac3f-885a267bb68c), [Motion flow](https://mobbin.com/flows/423c6fa6-9b73-409e-b306-30a1b6d07521), [ClickUp flow](https://mobbin.com/flows/001549fe-c463-449c-83f0-435e6b1a5e40))

## Flow
1. Immediately after account/workspace creation, the app routes the new user into creating the core object — no empty dashboard first (Asana, Motion: "Create your first workspace" → "Create your first project").
2. Step 1 asks only for a name, phrased as work not config: "What's something you and your team are currently working on?" (Asana, Motion).
3. Subsequent steps seed real content: Airtable asks "I'd like to track: Projects/Teams/Tasks" then has you type 3 actual rows; Asana asks for first tasks.
4. A live preview pane builds the object in real time beside the form — typed rows appear in a mock table/board instantly (Asana, Airtable, Attio-style split layout).
5. One scaffolding decision with a safety note: "What layout works best? You can change this later" (Asana List/Board/Timeline/Calendar).
6. Wizard ends by landing the user INSIDE the object they just created, already populated (Motion lands in the tasks view with their project; ClickUp lands in a "Space copied!" workspace).
7. Segmented progress bar across the top shows 3–4 steps total; Back is available (Motion, Asana).

## Use when
- The product is useless until the core object exists (an Event for us) — fastest path to the aha moment.
- You can keep it to 2–4 steps and every answer produces visible structure (live preview is the trust mechanism).
- The first-run wizard can share components with the normal create flow (extra scaffolding only on first run).

## Avoid when
- The core object needs heavy mandatory data up front — long wizards bleed users (ClickUp's 23-screen flow is the cautionary maximum).
- Invited members hit it — only the org creator should be routed here (see role-aware-onboarding-split).
- The user arrived with intent to import/migrate existing data; offer an import escape hatch (ClickUp asks "Do you use any of these tools? We'll help you import tasks").

## Sad paths observed
- Empty required field: Asana's standard New Project modal shows inline "Project name is required" in red ([ref](https://mobbin.com/screens/4134b7e4-8465-4176-bd43-c33b9b72d2f1)) — validation is inline, not on submit-only.
- Abandonment mid-wizard: Motion/Asana wizards have no visible save-and-exit; the object exists only at the end. Wave (adjacent setup wizard) shows the better recovery: "Finish later? Your progress will be saved" modal ([ref](https://mobbin.com/screens/6330c03b-49b9-4bff-ae6d-8c9ff6ca7800)).
- Wizard fatigue: ClickUp pads with low-value steps (favorite color theme, "how did you hear about us") — each non-essential step is a drop-off point.

## Accessibility
- Live preview panes are decorative duplicates of form input — they should be aria-hidden so screen readers aren't told everything twice.
- Segmented progress bars (Motion) need text equivalents ("step 2 of 3"); Slack's wizard shows the textual "Step 1 of 5" treatment.
- Single-input steps with large type (Slack-style) are the easiest keyboard/screen-reader path: one field, one Next.

## Default verdict for our stack
RECOMMENDED — route the new org admin straight into "Create your first event" with 2–3 steps (name/date → optional template → land inside the event); it matches our event-centric object model exactly and every PM-tool peer does it this way.
