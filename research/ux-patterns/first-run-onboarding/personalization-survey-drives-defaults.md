# Pattern: Personalization survey that drives workspace defaults
**Surface:** first-run-onboarding · **Observed in:** Attio, ClickUp, folk, Maze (refs: [Attio "Help us customize your workspace"](https://mobbin.com/screens/6acf6949-827f-4bae-b802-0757497de7c4), [Attio variant](https://mobbin.com/screens/4c1f00b8-7405-4a48-aabb-3f9de7ca8bf3), [ClickUp flow](https://mobbin.com/flows/001549fe-c463-449c-83f0-435e6b1a5e40), [folk flow](https://mobbin.com/flows/d6cccc15-0fd8-4412-9b19-d6a00993978d), [Maze "Tell us a bit about yourself"](https://mobbin.com/screens/30545233-1c08-436f-959b-253654674e61))

## Flow
1. During the setup wizard (step ~4/5 in Attio), the app asks 1–2 multiple-choice questions as tappable chips: "What will you be using Attio for?" (Sales/Recruiting/...) and "What are you working on at the moment?".
2. folk asks "What brings you to folk?" and states the payoff explicitly: "We'll create personalized groups to get you started. You can create your own later."
3. ClickUp asks use case + team size + competitor tools, and annotates WHY: "Note: We'll use this to suggest templates that'll help you get started."
4. Answers materialize as pre-built structure on landing: folk lands the user in pre-created groups ("Partners management", "Sales pipeline"); Attio seeds workspace templates; ClickUp suggests templates and offers task import.
5. Questions are single-screen, chip-based, with visible Continue — never free text (Maze uses dropdowns for role/company size).

## Use when
- The answer genuinely changes the default workspace (templates seeded, modules enabled) — and you say so on the screen, folk-style.
- One question suffices ("What kind of event are you running?" → conference/summit/internal offsite template).

## Avoid when
- Answers go only to marketing/CRM and change nothing in-product — users learn the survey is theater (ClickUp's "How did you hear about us?" step adds friction with zero user value).
- It extends an already-long wizard; every extra step is measurable drop-off.
- The product has only one use case at launch — skip and hard-code the default.

## Sad paths observed
- No-fit answer: Attio and folk both include "Other"/"Something else" escape chips so users are never blocked.
- Skipping: Attio's adjacent steps offer "Continue without sync" ([ref](https://mobbin.com/screens/8a212f58-b532-450c-bb47-195590df3223)); the survey steps themselves show no skip — a forced choice, mitigated by "Other".
- Wrong answer remorse: folk pre-creates groups but states "You can create your own later" — reversibility messaging is part of the pattern.

## Accessibility
- Chip groups are radio/checkbox semantics in disguise — must be focusable, with selected state not conveyed by background color alone (Attio uses border+fill change; pair with aria-checked).
- Keep one question per screen; multi-question screens (ClickUp's long scroll) create confusing focus order.

## Default verdict for our stack
VIABLE — a single "What kind of event are you planning first?" question feeding the event template choice would earn its place, but as a separate step it is deferrable for v1; folding it into the first-event wizard (template picker) achieves the same outcome with one less screen.
