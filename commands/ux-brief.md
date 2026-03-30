# UX Brief — Design the User Experience Before Writing Code

Interview the founder about every UX decision for the app. All questions upfront with visual references. Produces a complete UX specification that the UI and frontend skills consume.

Input: $ARGUMENTS (module name for per-module brief, or "app" for app-wide brief)

## Why This Exists

LLMs build for functionality, not experience. A feature that WORKS but feels wrong will lose users. This interview captures how every feature should FEEL — before a single line of frontend code is written. The AI makes ZERO UX decisions on its own. Everything comes from the founder's answers.

## Prerequisites

Read these first (if they exist):
- `.planning/competition-research.md` — informs questions with real competitor examples
- PRD or `.planning/decisions/` files — informs what features need UX decisions
- `.planning/data-requirements.md` — informs what data appears on screens

## Process

### Step 1: Present the Full Questionnaire

Present ALL questions at once. Group them by section. For each question, include 2-3 visual references (links to apps that demonstrate the options). The founder answers in bulk — their flow state, their brain dump.

Tell the user:

> "Here are all the UX questions for [app/module]. Each question has examples you can look at. Answer as many as you can in one go — write as much or as little as you want. Say 'skip' for any you're unsure about. After your dump, I'll ask follow-ups based on your answers."

---

### SECTION A: App Identity (app-wide, asked once)

**A1. What is the vibe of this app?**
Pick 3-5 words that describe how it should FEEL. Not what it does — how it feels.
Examples: fast, calm, powerful, playful, serious, premium, minimal, warm, clinical, bold, quiet, intense
- Linear feels: fast, precise, clean
- Notion feels: flexible, calm, organized
- Superhuman feels: fast, dark, powerful

**A2. Who is the primary user?**
Describe them like a person, not a demographic.
- What's their job?
- How tech-savvy are they? (uses Terminal daily / uses Word daily / barely uses a computer)
- When do they use this app? (morning at desk / commute on phone / late night crunch)
- What are they trying to accomplish? (not features — the outcome they want in life)
- What frustrates them about current tools?

**A3. What should this app NOT feel like?**
Sometimes knowing what to avoid is more useful than knowing what to aim for.
- "Not like Jira — too complex, too many options"
- "Not like a toy — needs to feel professional"
- "Not like enterprise software — no corporate coldness"

**A4. Default color mode?**
- Light (for users in bright environments, traditional feel)
- Dark (for power users, long sessions, premium feel)
- System (follows user's OS setting)
- User choice with smart default based on persona

Look at: Bear (beautiful in both), Linear (dark-first), Notion (light-first)

**A5. Device priority?**
Think about your user's physical state when they need this app.
- Laptop-first (deep work, complex tasks)
- Mobile-first (quick tasks, on-the-go)
- Both equally (responsive from day one)

---

### SECTION B: Navigation and Structure (app-wide)

**B1. How should the user move between major sections?**
- Collapsible sidebar (appears when called, hides when working) — like VS Code, Bear
- Persistent sidebar (always visible) — like Notion, Slack
- Top navigation (horizontal tabs) — like Google Docs
- Command palette primary (Cmd+K to navigate) — like Superhuman, Raycast
- Combination (sidebar + command palette for power users)

**B2. When the sidebar is open, how should items be organized?**
- Flat list (all modules equal)
- Grouped by category (Writing tools, Research tools, Settings)
- Favorites/pinned at top, rest below
- Recent items first, then all items

**B3. Should the sidebar show ALL available modules or only relevant ones?**
- Show everything (user sees full capability)
- Show context-relevant items (if you're in "writing mode," show writing tools)
- Let user customize what appears

**B4. After the user picks a module, what happens to navigation?**
- Sidebar auto-collapses, module gets full screen — like Adobe CC
- Sidebar stays but shrinks to icons only — like VS Code
- Sidebar stays full — like Notion

---

### SECTION C: Per-Module UX (repeat for each major module)

**C1. Does the average user already know how to do this task in real life?**
- Yes → Bear model (minimal, power hidden, keyboard-first)
- No → Wizard model (guided, step-by-step, educational)
- Mixed → Offer both paths (quick start for experts, guided for beginners)

Look at: Bear editor (everyone knows writing), TurboTax (nobody knows taxes)

**C2. What does the user see THE FIRST TIME they open this module with no data?**
- Blank with one action ("Create new")
- Welcome message + one clear call to action
- Guided wizard that asks questions and sets things up
- Sample/template showing what a finished result looks like
- Combination (welcome + template + create button)

Look at: Notion (template gallery), Linear (guided setup), Bear (just start typing)

**C3. What are the 3 most important actions in this module?**
List them in order. The #1 action should be the most visible/accessible thing on screen.
Everything else is secondary and can be revealed progressively.

**C4. How many screens/steps does the core workflow take?**
- 1 screen (everything happens in one view) — like an editor
- 2-3 screens (setup → work → result) — like a simple wizard
- 5+ screens (guided multi-step process) — like your systematic review (13 screens)

**C5. What advanced features exist that most users won't need immediately?**
These get hidden behind menus, "Advanced" sections, or keyboard shortcuts.
List them. They're real features but not first-impression features.

**C6. How should this module handle loading and waiting?**
- Content appears instantly (optimistic UI — assume success)
- Skeleton loading (grey shapes where content will appear)
- Progress bar/indicator (for long operations like AI processing)
- Spinner (simple, for short waits)

**C7. What feedback should the user get after completing the main action?**
- Silent (it just works, no confirmation)
- Subtle toast (small notification, auto-dismisses in 2 seconds)
- Clear confirmation (stays until dismissed)
- Animated (button transforms to checkmark)
- Redirect (takes them to the result)

This depends on user anxiety: high-effort creative work → clear confirmation. Low-effort utility → subtle or silent.

**C8. What errors can occur and how should they feel?**
- Inline validation (red border on the field that's wrong, message next to it)
- Toast notification (error message at top/bottom of screen)
- Modal/dialog (for serious errors that need attention)
- Retry suggestion ("Something went wrong. Try again?")

---

### SECTION D: Content and Density

**D1. How much information should be visible at once?**
- Spacious (generous whitespace, large text, fewer items — like Bear, Apple)
- Medium (balanced, good readability, reasonable density — like Notion)
- Dense (lots of data, compact, power-user oriented — like Linear)

Your preference profile from our conversation suggests: spacious by default, with the ability to show density when the content demands it (like search results).

**D2. When content demands density (like a list of 20 search results), how do you handle it?**
- Show fewer items with more detail each (5 results with full abstracts)
- Show more items with less detail (20 results with titles only, click to expand)
- Let user toggle between views (compact/comfortable/detailed)
- Card layout (visual cards with key info, grid arrangement)

**D3. How should long lists work?**
- Infinite scroll (content loads as you scroll down)
- Pagination (page 1, 2, 3 with explicit navigation)
- Load more button (click to show next batch)

**D4. What width should content areas be?**
- Narrow column (like a book — ~650px max, best for reading/writing)
- Medium column (~900px, balanced for mixed content)
- Full width (uses all available space, best for dashboards and tables)
- Responsive (narrow for text-heavy, full for data-heavy)

---

### SECTION E: Motion and Speed

**E1. How fast should navigation feel?**
- Instant (click → content appears with no transition, <50ms)
- Quick crossfade (content fades in over 100-150ms, removes jarring flash)
- Slide transition (content slides in, ~250ms)

Your preference from our conversation: instant for knowledge work, quick crossfade as gentle fallback. Never slide for navigation in knowledge tools.

**E2. Should there be micro-animations?**
- Yes, subtle (hover effects, button press feedback, smooth reveals)
- Minimal (only where they serve understanding — like a progress indicator)
- None (pure speed, zero decoration)

**E3. How should modals and panels appear?**
- Instant overlay (appears immediately with backdrop dim)
- Quick fade-in (100ms fade with backdrop)
- Slide from edge (panel slides in from right or bottom)

---

### Step 2: Receive the Brain Dump

The user answers as many questions as they want, in whatever order, with as much or as little detail as they want. They can skip questions.

### Step 3: Follow-Up Questions

Read every answer carefully. For each answer that raises new questions, ask them:

> "You said [X]. That makes me wonder: [follow-up question]?"

Continue until zero ambiguity remains. The LLM should have NO unanswered questions about any UX decision.

<HARD-GATE>
Do NOT proceed to producing the UX Brief document until:
1. Every section has been addressed (or explicitly skipped)
2. All follow-up questions from the brain dump have been asked and answered
3. All follow-ups from the follow-ups have been asked and answered
4. You have ZERO remaining questions about any UX decision
</HARD-GATE>

### Step 4: Produce the UX Brief

Save to: `.planning/ux-brief.md`

```markdown
# UX Brief: [App/Module Name]
**Date:** [date]
**Source:** UX interview + competition research
**Status:** COMPLETE — ready for UI brief and frontend development

## App Identity
- **Vibe:** [3-5 words]
- **Not like:** [what to avoid]
- **Primary user:** [persona description]
- **Device priority:** [laptop/mobile/both]
- **Color mode default:** [light/dark/system]

## Design DNA (from inspirations)
- [Inspiration 1]: stealing [specific quality]
- [Inspiration 2]: stealing [specific quality]
- [Inspiration 3]: stealing [specific quality]

## Navigation
- Pattern: [collapsible sidebar / persistent / top nav / command palette]
- After module selection: [auto-collapse / shrink to icons / stay]
- Organization: [flat / grouped / favorites]

## Per-Module Decisions

### [Module 1]
- **Model:** [Bear / Wizard / Hybrid]
- **Empty state:** [blank / welcome / wizard / template]
- **Primary actions (top 3):** [list]
- **Workflow length:** [1 screen / 2-3 / 5+]
- **Hidden advanced features:** [list]
- **Loading:** [instant / skeleton / progress / spinner]
- **Feedback:** [silent / toast / confirmation / animated]
- **Error handling:** [inline / toast / modal / retry]

### [Module 2]
...

## Content Density
- Default: [spacious / medium / dense]
- Density handling: [fewer with detail / more with less / toggle / cards]
- Lists: [infinite scroll / pagination / load more]
- Content width: [narrow / medium / full / responsive]

## Motion
- Navigation speed: [instant / crossfade / slide]
- Micro-animations: [subtle / minimal / none]
- Modal appearance: [instant / fade / slide]

## Rules (extracted from interview)
1. [Rule from this specific project/app]
2. ...

## Open Questions
- [ ] [Anything unresolved]
```

### Step 5: Commit and Handoff

```bash
git add .planning/ux-brief.md
git commit -m "ux: complete UX brief from founder interview"
```

> "UX brief complete. [N] modules covered, [N] decisions documented.
>
> Next: Run `/ui-brief` to define the visual language (fonts, colors, spacing).
> Or run `/write-a-prd` if the PRD hasn't been written yet (the UX brief will inform it)."

## Rules

- **ALL questions presented upfront** — founder answers in bulk brain dump, not drip-fed
- **Visual references for every question** — link to apps that demonstrate the options
- **Follow-ups until zero ambiguity** — cycle continues until no questions remain
- **LLM makes ZERO UX decisions** — if the founder didn't answer it, it stays as an open question. Never assume.
- **Read competition research first** — use real competitor examples in questions ("Your competitor SciSpace uses X. Do you want that or something different?")
- **No design jargon** — say "how many things should the user see at once" not "information density ratio"
- **Per-module decisions are separate** — don't apply editor decisions to systematic review. Each module gets its own treatment.
