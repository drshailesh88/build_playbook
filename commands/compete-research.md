# Competition Research — Deep Dive Into Competitors and Design Inspirations

Research your competition and design inspirations BEFORE writing a PRD. Produces a comprehensive document covering feature parity, UX teardowns, infrastructure analysis, and extracted design patterns.

Input: $ARGUMENTS (paste a list of competitor URLs and inspiration URLs, or "interactive" to be asked)

## Why This Exists

Building without knowing your competition means reinventing what already exists and missing what users already expect. Building without design inspiration means the AI defaults to generic UI. This command does both — studies what competitors DO and how inspirations FEEL — so your PRD and design are informed from the start.

## Process

### Step 1: Gather the Two Lists

Ask the user for two separate lists:

**Competitors** — apps in the same space doing the same job:
> "List 3-5 apps that your users might use instead of yours. These are the products you need to match or beat on features."

**Design Inspirations** — apps from ANY space whose FEEL you want to steal:
> "List 2-4 apps from any industry whose design, speed, or vibe you admire. These don't have to be in your space. Superhuman, Linear, Bear, Notion — whatever apps make you think 'I want my app to feel like that.'"

For each inspiration, ask:
> "What specifically do you admire about [app]? Is it the speed? The layout? The typography? The way it handles complexity? The keyboard shortcuts? Be specific — you're not copying the whole app, you're stealing specific qualities."

### Step 2: Competitor Feature Analysis

For each competitor, use Playwright MCP to navigate their app (or their marketing site if the app requires signup):

#### 2a: Feature Inventory

Navigate through every visible page and section. For each, record:
- Page/section name
- What features are visible
- How features are organized (sidebar? tabs? cards?)
- What actions are available on each screen

If the app requires signup, use their marketing site, demo videos, documentation, and help center to extract features.

Also search:
```
"[competitor name] features" site:reddit.com
"[competitor name] vs" — comparison articles reveal feature lists
"[competitor name]" site:youtube.com — product demos show real features
```

#### 2b: UX Teardown

For each competitor's key screens, analyze:

**Information Architecture:**
- How many items are visible on the landing screen?
- How is navigation structured? (sidebar, top nav, command palette)
- How deep is the hierarchy? (how many clicks to reach core features?)

**Progressive Disclosure:**
- What's shown immediately vs what's hidden behind clicks?
- How many buttons/actions on the primary screen?
- Are advanced features discoverable but not overwhelming?

**Onboarding:**
- What does a new user see first?
- Is there guided onboarding or blank slate?
- How quickly can a new user accomplish their first task?

**Cognitive Load:**
- How many decisions does the user face at any given moment?
- Are there clear visual hierarchies (one primary action stands out)?
- Does the UI feel calm or overwhelming?

#### 2c: Infrastructure Analysis

For each competitor, detect their tech stack:
```bash
# Use curl to check response headers
curl -sI https://competitor.com | grep -i "server\|x-powered-by\|x-frame\|content-security"

# Check for framework signatures in HTML
curl -s https://competitor.com | grep -i "next\|nuxt\|react\|angular\|vue\|svelte\|__NEXT\|__NUXT"

# Check for common services
curl -s https://competitor.com | grep -i "clerk\|auth0\|firebase\|supabase\|stripe\|intercom\|segment\|hotjar\|sentry\|posthog"
```

Also check:
- Their job postings (reveal tech stack in requirements)
- Their GitHub (if open source or if they have public repos)
- BuiltWith or Wappalyzer lookup for deeper analysis

Record: frontend framework, backend (if detectable), auth system, payment provider, analytics, error tracking, hosting (check DNS, CDN headers).

#### 2d: Pricing and Positioning

For each competitor:
- What plans exist? What are the prices?
- What's the free tier limitation?
- How do they position themselves? (tagline, hero text, value proposition)
- Who is their target user? (from their marketing language)

### Step 3: Design Inspiration Extraction

For each inspiration app, this is NOT a feature analysis — it's a DESIGN LANGUAGE extraction.

#### 3a: Visual DNA

Take screenshots of the inspiration app and analyze:

**Layout:**
- Content width (narrow like Bear, medium like Notion, full like dashboards?)
- Whitespace ratio (spacious or dense?)
- Grid system (how many columns? how are elements arranged?)
- Sidebar behavior (persistent, collapsible, hidden?)

**Typography:**
- What font family? (serif, sans-serif, monospace)
- Base font size (small like 13px or generous like 16px?)
- Line height (tight or airy?)
- Font weight usage (how do they create hierarchy? bold headings vs size difference?)

**Color:**
- Background color (pure white, warm white, grey, dark?)
- Primary accent color
- How many colors total? (minimal palette or colorful?)
- How is color used? (sparingly for accents or generously for backgrounds?)

**Motion:**
- Page transition speed (instant, fast crossfade, slide?)
- Hover effects (subtle or pronounced?)
- Loading states (skeleton, spinner, or nothing?)
- Micro-animations (button clicks, checkbox ticks, menu opens)

**Density:**
- How many items visible at once?
- Spacing between elements (tight or generous?)
- Border usage (lines between items or spacing alone?)

#### 3b: Interaction Patterns

- How does navigation work?
- Is there a command palette (Cmd+K)?
- Keyboard shortcut density (few essentials or comprehensive?)
- How do modals/dialogs appear? (overlay, slide-in, inline expand?)
- How do lists and feeds work? (infinite scroll, pagination, load more?)

### Step 4: Produce the Research Document

Save to: `.planning/competition-research.md`

```markdown
# Competition & Inspiration Research: [Project Name]
**Date:** [date]
**Competitors analyzed:** [count]
**Inspirations analyzed:** [count]

---

## COMPETITORS

### 1. [Competitor Name] — [tagline]
**URL:** [url]
**Positioning:** [who they target and how they describe themselves]
**Pricing:** [plans and prices]

**Feature Inventory:**
| Feature | They Have It | We Plan It | Priority |
|---------|:-:|:-:|---------|
| [Feature 1] | ✅ | ✅ | Must match |
| [Feature 2] | ✅ | ❌ | Consider |
| [Feature 3] | ❌ | ✅ | Our advantage |

**UX Teardown:**
- Landing screen: [what user sees first, how many actions visible]
- Navigation: [sidebar/top/command palette, persistent/collapsible]
- Progressive disclosure: [what's hidden, how deep]
- Cognitive load: [calm/moderate/overwhelming]
- Onboarding: [guided/blank/template]

**Infrastructure:**
- Frontend: [framework]
- Auth: [system]
- Payments: [provider]
- Hosting: [CDN/cloud]

**Strengths:** [what they do well]
**Weaknesses:** [what feels wrong or missing]

### 2. [Next Competitor]
...

---

## FEATURE PARITY MATRIX

| Feature | Competitor A | Competitor B | Competitor C | Our Plan |
|---------|:-:|:-:|:-:|:-:|
| ... | | | | |

---

## DESIGN INSPIRATIONS

### 1. [App Name] — Stealing: [what specifically]
**URL:** [url]

**Visual DNA:**
- Layout: [description]
- Typography: [font, size, weight patterns]
- Colors: [palette description]
- Motion: [speed, transition style]
- Density: [spacious/medium/dense]

**Patterns to Steal:**
1. [Specific pattern] — because [why it works for our product]
2. [Specific pattern] — because [why]
3. [Specific pattern] — because [why]

### 2. [Next Inspiration]
...

---

## IDENTITY SYNTHESIS

Blending the inspirations above, our app should feel like:
> "[App] should feel like [Inspiration A]'s [quality] meets [Inspiration B]'s [quality] with [Inspiration C]'s [quality]. Unlike [Competitor], which feels [description], we should feel [description]."

**Derived Design Direction:**
- Layout model: [from which inspiration]
- Speed/motion model: [from which inspiration]
- Typography model: [from which inspiration]
- Density model: [from which inspiration]
- Navigation model: [from which inspiration]

---

## OPEN QUESTIONS FOR UX BRIEF
_Questions that came up during research that the founder needs to answer:_
- [ ] ...
```

### Step 5: Commit

```bash
git add .planning/competition-research.md
git commit -m "research: competition analysis + design inspiration extraction"
```

### Step 6: Handoff

> "Competition research complete. Analyzed [N] competitors and [N] inspirations.
>
> Key findings:
> - [Top finding about competitors]
> - [Top finding about design direction]
> - [N] open questions need your input
>
> Next: Run `/ux-brief` to design the user experience using this research."

## Rules

- NEVER skip the inspiration extraction — features alone don't make a product. The FEEL matters equally.
- ALWAYS separate competitors (same job) from inspirations (same vibe) — they serve different purposes
- ALWAYS ask WHAT SPECIFICALLY to steal from each inspiration — "I like Notion" is not actionable
- Infrastructure analysis is best-effort — not everything is detectable from outside. Note what you could and couldn't determine.
- Screenshots are evidence — capture and reference them. Don't describe from memory.
- The identity synthesis at the bottom is the MOST IMPORTANT output — it becomes the north star for all design work.
