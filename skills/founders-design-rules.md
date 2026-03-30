# Founder's Design Rules — Portable Across All Apps

Extracted from UX grilling session. These rules apply to EVERY app, not just one project. The UX and UI briefs must encode these. The frontend development must follow these.

## The 10 Rules

### 1. Progressive Disclosure
**Rule:** Show what the user needs RIGHT NOW. Everything else appears when they need it.
**Decision method:** First-time user thinking + logical sequence of tasks.
**Anti-pattern:** 11 buttons on the landing screen. "Here's everything, good luck."

### 2. Guidance Level Based on Task Familiarity
**Rule:** Does the average user already know how to do this task in real life?
- **YES** (writing, searching, browsing) → **Bear model**: minimal, power hidden, keyboard-first, uncluttered
- **NO** (systematic review, illustration, compliance) → **Wizard model**: guided, step-by-step, educational, hand-holding
**Decision question:** "Would a user need a tutorial to understand what this module does?"

### 3. Feedback Intensity Matches User Anxiety
**Rule:** High-effort creative work → clear, reassuring confirmation. Low-effort utility → subtle, fast hint.
- Illustration saved after 30 minutes of work → clear confirmation with preview
- PDF downloaded from a quick tool → small toast, gone in 2 seconds
**Decision question:** "How much effort did the user invest before this action?"

### 4. Navigation Is a Launcher, Not a Companion
**Rule:** Sidebar appears when called, disappears after choice. Each module gets 100% of the screen.
**Model:** Adobe Creative Cloud — you open Premiere, the launcher goes away, Premiere is your world.
**Anti-pattern:** Notion's persistent sidebar reminding you of 50 other things you could be doing while you're trying to write.

### 5. Win the Module, Win the Moment
**Rule:** Each module is designed for its own job first. Brand unity comes from quality of craft, not identical UI.
**Model:** Adobe Rush and Illustrator look completely different but both feel like Adobe products — because of the standard of polish, not matching UIs.
**Anti-pattern:** Making the editor look like the systematic review wizard just for "consistency."

### 6. Speed for Knowledge Work
**Rule:** Knowledge work → instant transitions (150ms max). Non-knowledge work → motion acceptable.
**Reasoning:** A 300ms animation feels beautiful the first time and infuriating the hundredth time during deep work.
**Default:** Instant with 100-150ms crossfade as gentle fallback. Never slide/expand for navigation.

### 7. Design for the User Persona, Not the Founder
**Rule:** The founder's taste sets the QUALITY BAR. The user persona sets the SPECIFIC CHOICES.
**Example:** Founder prefers dark mode. Users are Indian academics on bright-screen laptops. Ship light mode as default.
**Decision source:** Persona gets defined during research/planning phase. Design preferences flow from persona.

### 8. Mobile Strategy Is Per-App
**Rule:** Think about the user's physical state when they need this tool.
- Couch with phone → mobile-first
- Desk with laptop → laptop-first
- Both → responsive from day one
**Aspiration:** Mobile-first if possible. Reality: if it breaks functionality, stay laptop-first.

### 9. Identity First: Vibe + Competition + Inspiration = Identity
**Rule:** Every app has a vibe (how it feels), competition (what it shouldn't look like), and inspirations (what it should steal from). All visual decisions derive from identity.
**Method:** Pick 3-5 inspiration apps. For each, specify WHICH quality to steal. Blend them into something new.
**Example:** "Notion's content structure + Linear's speed + Bear's typography + Superhuman's keyboard shortcuts = a tool none of them are, but anyone who uses them would feel comfortable in."
**The skill must have design judgment** to push back on positioning mismatches.

### 10. Exhaustive Interviewing — Zero Assumptions
**Rule:** All UX/UI questions presented upfront for bulk brain dump. Follow-up questions from answers. Follow-ups from follow-ups. Cycle continues until zero ambiguity. The LLM makes ZERO design decisions on its own.
**Format:** Bulk questionnaire with visual references → brain dump → follow-ups → follow-ups of follow-ups → complete
**Anti-pattern:** LLM silently choosing Inter 14px because "it's a safe default" without asking.

## The Taste Profile

The founder's aesthetic preferences (apply as quality bar, not as rigid rules):

| Preference | Lean Toward | Avoid |
|-----------|------------|-------|
| Density | Spacious (Bear, Apple) | Bloomberg Terminal, AWS Console |
| Complexity | PDF Expert (power + simplicity) | Adobe Acrobat (power + clutter) |
| Navigation | Collapsible, gets out of the way | Persistent sidebars with everything visible |
| Typography | Quality pairing matters, notices bad fonts | Generic system fonts without thought |
| Motion | Speed over beauty in knowledge tools | Decorative animations during deep work |
| Feedback | Proportional to user effort/anxiety | Same toast for everything |
| Color | Per-persona, not per-founder-preference | Defaulting to founder's dark mode for everyone |
| Personality | Opinionated restraint — strong decisions about what NOT to show | Everything visible, user figures it out |

## How These Rules Are Used

- `/ux-brief` reads this file to ensure the questionnaire covers all 10 rules
- `/ui-brief` reads this file to ensure visual decisions align with the taste profile
- Frontend development skills read this file as constraints during implementation
- `/design-review` reads this file to audit the built app against these principles
