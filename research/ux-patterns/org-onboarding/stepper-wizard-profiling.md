# Pattern: Full-screen step wizard with profiling questions
**Surface:** org-onboarding · **Observed in:** Slack, Air, Fibery, Linear, Notion (refs: [Slack "Step 1 of 5"](https://mobbin.com/screens/b58ce3ef-5180-4cee-a62c-20347539d2ea), [Slack 3-step variant](https://mobbin.com/screens/59cf344d-f40d-4522-9f05-a65a6da21185), [Air stepper flow](https://mobbin.com/flows/4a12588a-cbb2-461e-966f-6a0ac1dfb88e), [Fibery onboarding flow](https://mobbin.com/flows/028cdf95-4b10-4eb0-a0be-44f333ab340a), [Linear "You're good to go"](https://mobbin.com/screens/9cd928d5-21fc-4dcd-973a-dcec833eb54b), [Notion "What is this space for?"](https://mobbin.com/screens/cc865690-f319-4b7b-ba18-ea37ac09e40e))

## Flow
1. After account creation, a full-screen wizard with explicit progress ("Step 1 of 5" text in Slack; segmented progress bar in Air; dot stepper in Linear).
2. One question per screen: workspace/company name → segmentation (company size, role, primary goal, "how did you hear about us") → invite step → finish.
3. Per-step "Skip" affordances on non-essential steps (Air bottom-right "Skip"; Slack "Skip this step"; Linear "I'll do this later").
4. Answers personalize setup (Air: "This helps us tailor your plan and workspace setup"; Notion routes work/personal/school to different defaults).
5. Completion screen: Linear "You're good to go!" with 3 next-step cards (Tell your team / Integrate GitHub & Slack / Keyboard shortcuts) and a single "Open Linear" CTA.

## Use when
- Marketing/product genuinely consumes the segmentation data and you accept the friction cost.
- Setup choices materially branch the workspace (templates, defaults, plan).

## Avoid when
- Questions are decoration — every non-skippable profiling step delays time-to-value (Fibery's wizard runs ~19 screens).
- B2B users arriving via invite — they should never see org-creation profiling.

## Sad paths observed
- Slack keeps the partially-built workspace visible in the left rail during the wizard, so abandonment mid-flow still leaves a usable shell.
- Fibery gates "Create Workspace" button until required fields (name + URL) validate.
- Air marks the first option pre-selected ("Personal use") so Next is never dead.

## Accessibility
- Large single-question headings, chip-style single-tap answers (Air); explicit "Step N of M" text (Slack) is screen-reader friendlier than bare progress dots (Linear).

## Default verdict for our stack
VIABLE — only if we cap it at 2–3 steps (create → invite → done); full profiling wizards conflict with the Linear/Vercel speed bar we're targeting.
