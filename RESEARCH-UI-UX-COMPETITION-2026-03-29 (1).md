# UI/UX + Competition Research — Deep Dive Findings
## Date: 2026-03-29
## Purpose: Build skills for design-first development, competition analysis, and UI cloning

---

## THE 4 PROBLEMS YOU RAISED

1. **UI/UX is an afterthought** — LLMs build functional code, not beautiful experiences. You fix it after, which is cumbersome.
2. **Competition analysis happens too late** — you want competitor feature teardowns, UX research, and infrastructure analysis at the START, not during building.
3. **UI cloning is broken** — your ui_cloner repo gets landing pages but HTML-to-React translation is poor, and product UI (not just marketing pages) is the real gap.
4. **You're design-opinionated but can't execute** — you have taste but no training to translate vision into code.

---

## ASPECT 1: DESIGN-FIRST UI/UX IN AI-DRIVEN DEVELOPMENT

### The Core Problem
LLMs optimize for "does it work?" not "does it feel right?" The result: functional code served in a way no user would want to use. Changing colors and fonts on top doesn't fix structural UX problems (cognitive load, information architecture, flow design).

### What I Found

#### Tier 1: The Figma Pipeline (Best Solution for Your Problem)

**Figma MCP (Official)** — Bidirectional integration between Claude Code and Figma, announced Feb 2026.
- **Design → Code**: Claude reads actual Figma layers, auto-layout rules, design tokens, component structure (not flat screenshots). Generates code that uses your design system variables, not hardcoded colors.
- **Code → Canvas**: Push UIs built in Claude Code BACK to Figma as editable frames. Not screenshots — real, editable Figma layers.
- **Why this matters for you**: Design the UX in Figma first (even rough wireframes), then Claude Code generates code that matches. The design IS the spec.
- **Setup**: Claude Desktop → click + icon → add Figma integration. Or in Claude Code: `claude mcp add --transport http figma https://mcp.figma.com/mcp`

**gbasin/figma-to-react** (github.com/gbasin/figma-to-react)
- Claude Code PLUGIN (not just a skill) that converts Figma designs into pixel-perfect TypeScript React + Tailwind components
- **Visual validation loop**: Takes screenshot of generated code → compares to Figma reference → calculates diff % → if >5% diff, LLM makes targeted fix → loops (max 10 passes) until match
- Downloads and deduplicates assets by content hash
- Extracts CSS variables from Figma automatically
- **Install**: `claude plugin marketplace add gbasin/figma-to-react`

**scoobynko/claude-code-design-skills** (github.com/scoobynko/claude-code-design-skills)
- Systematic Figma MCP workflow: metadata → context → screenshot → variables
- Component reuse first (uses existing components over creating new ones)
- Figma variant mapping (maps Figma variant properties to React props)
- Mock data support for frontend-first development

**arinspunk/claude-talk-to-figma-mcp** (github.com/arinspunk/claude-talk-to-figma-mcp)
- Community MCP that works with FREE Figma accounts (official MCP requires Dev Mode license)
- Two-way: agent sends commands to Figma AND receives responses
- React/Vue/SwiftUI component generation from designs

#### Tier 2: Design Intelligence Skills (No Figma Required)

**Anthropic's frontend-design skill** (official, built-in)
- The opinionated design skill that pushes Claude toward bold, distinctive interfaces
- Covers: spatial composition, asymmetry, gradient meshes, noise textures, dramatic shadows, custom cursors, grain overlays
- Prevents Claude from generating "the same interface every time"
- **Install**: `cp -r skills/skills/frontend-design ~/.claude/skills/`

**nextlevelbuilder/ui-ux-pro-max-skill** (github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- Searchable databases of UI styles, color palettes, font pairings, chart types, and UX guidelines
- Covers 12+ frontend stacks (React, Next.js, Vue, Svelte, SwiftUI, Flutter, etc.)
- BM25 + regex hybrid search engine for finding design patterns
- Design system generation script
- **Install**: `claude plugin add nextlevelbuilder/ui-ux-pro-max-skill`

**mastepanoski/claude-skills** (github.com/mastepanoski/claude-skills)
- UX audit skills using industry standards: Nielsen's heuristics, WCAG compliance, Don Norman's principles
- `ux-audit-rethink` for comprehensive evaluation
- Can audit from URL, screenshot, or React component code
- **Install**: `npx skills add mastepanoski/claude-skills --skill nielsen-heuristics-audit`

**wondelai/skills** — 25 agent skills for UX design based on books by Don Norman, Cialdini, Ries, Hormozi

**ehmo/platform-design-skills** — 300+ design rules from Apple HIG, Material Design 3, WCAG 2.2

**Google Labs Stitch skills** (google-labs-code/) — design-md, enhance-prompt, react-components, shadcn-ui, stitch-loop (iterative design-code loop)

#### Tier 3: Animation and Motion (Polish Layer)

**Motion design skills** — Motion (formerly Framer Motion) patterns: declarative animations, gestures, scroll effects, spring physics, layout animations
- Trained on Emil Kowalski, Jakub Krehel, Jhey Tompkins design patterns
- Finds conditional UI that SHOULD be animated but isn't
- Bundle optimization (LazyMotion at 4.6KB)

#### The Meta-Tool

**wilwaldon/Claude-Code-Frontend-Design-Toolkit** (github.com/wilwaldon/Claude-Code-Frontend-Design-Toolkit)
- **THE comprehensive guide** — curates ALL the tools above into one setup
- Recommended minimal setup: `claude plugin add anthropic/frontend-design` + Context7 MCP + `claude plugin add nextlevelbuilder/ui-ux-pro-max-skill` + Playwright MCP
- Lists every MCP, plugin, and skill relevant to frontend design
- Includes Figma Code Connect explanation, design audit skills, animation tools

---

## ASPECT 2: COMPETITION ANALYSIS + UX TEARDOWNS

### What I Found

#### The "Claude Watchtower" Pattern (shareuhack.com)
A complete workflow for automated competitor benchmarking:
1. Use an API (or manual list) to find top competitors
2. Playwright navigates to each competitor's app and takes structured screenshots
3. Claude Vision analyzes screenshots: extracts layout patterns, CTA colors, feature lists, visual hierarchy scores
4. Outputs a clean Markdown matrix for your PRD or Notion workspace
- **Result**: 8 hours of manual competitor audit → 10 minutes of review
- Limitation: Static screenshots only. Deep interaction flows need human-in-the-loop.

#### Competition Research Skills

**deanpeters/company-research** — Deep-dive competitor or company analysis skill

**deanpeters/competitive-analyst** — Structured competitive intelligence

**Termo "Competitor Teardown"** (termo.ai/skills/competitor-teardown)
- Feature matrices, SWOT analysis, positioning maps, and UX review
- Pricing comparison, review mining
- Available as a deployable skill

**sanjay3290/deep-research** — Autonomous multi-step research using Gemini Deep Research Agent for market analysis and competitive landscaping

#### Tech Stack Detection (Competitor Infrastructure)

**Wappalyzer** — browser extension, detects 3,000+ technologies. Free tier: 50 lookups/month. Best for frontend detection.

**BuiltWith** — largest database (673M websites), historical tracking (when competitors adopted/dropped tech). Better for backend detection. Free lookup available.

**WhatRuns** — free extension, good for WordPress ecosystem. Also extracts fonts and color palettes.

**DetectZeStack** — developer-first API, 7,200+ signatures, 4 detection layers. Free: 100 requests/month via RapidAPI.

**PublicWWW** — search engine for source code. Find websites using specific JavaScript libraries, CSS frameworks, or code patterns.

**For your workflow**: Run Wappalyzer extension on competitor sites during research phase. Use BuiltWith for historical tracking. Use PublicWWW to find what specific open-source libraries competitors use.

---

## ASPECT 3: UI CLONING + HTML-TO-REACT

### Your Current Problem
Your `ui_cloner` repo goes to a page, clones the landing page HTML, and discusses copy inputs. Two gaps:
1. HTML-to-React translation isn't good enough
2. Product UI (dashboards, editors, settings) is much harder than landing pages

### What I Found

#### Screenshot-to-Code Tools

**abi/screenshot-to-code** (github.com/abi/screenshot-to-code) — The gold standard
- Drop in a screenshot → get clean HTML/Tailwind/React/Vue code
- Supports GPT-4 Vision AND Claude Sonnet
- Can also enter a URL to clone a live website
- Supports screen RECORDING to code (not just static screenshots)
- React/Vite frontend + FastAPI backend
- **The main tool people use for UI cloning**

**superyhee/claude-ui-copilot** (github.com/superyhee/claude-ui-copilot)
- Converts text, screenshots, AND Figma designs into functional code
- Conversational approach — continuous adjustments
- Supports AWS Bedrock and Claude Sonnet

**ScreenCoder** (github.com/leigest519/ScreenCoder)
- Multi-agent framework for screenshot → HTML/CSS
- Post-training with SFT + RL alignment
- ScreenBench: 1,000 real-world web screenshots with corresponding HTML
- Better accuracy than single-model approaches

**OpenKombai** — Free, privacy-first. Local LLMs (Llama 3.2 Vision + Qwen 2.5). No API keys, zero cloud costs.

#### The HTML-to-React Workaround

Your core problem: cloned HTML doesn't translate well to React components. Here's the solution path:

**Option A: Figma as the middleman (RECOMMENDED)**
1. Clone competitor's UI using abi/screenshot-to-code → gets HTML/Tailwind
2. Push that HTML to Figma using Claude Code-to-Canvas (Figma MCP)
3. Now you have editable Figma frames
4. Use gbasin/figma-to-react to generate pixel-perfect React from those Figma frames
5. The React output uses YOUR component library, YOUR design tokens

**Option B: Direct screenshot → React via Claude Vision**
1. Take screenshots of competitor's product pages (all states, all screens)
2. Feed to Claude with a system prompt: "Generate React + Tailwind + shadcn/ui components that match this design. Use semantic component names. Use design tokens not hardcoded values."
3. Iterate visually using Playwright MCP (Claude sees the rendered result and adjusts)

**Option C: Playwright MCP crawl + rebuild**
1. Use Playwright MCP to navigate the competitor's app
2. At each screen: dump accessibility tree + take screenshot
3. The accessibility tree gives you the SEMANTIC structure (roles, labels, hierarchy)
4. Use that semantic structure + screenshot to generate React components
5. This catches interactive states that static screenshots miss

#### Why Your Current Approach Fails

Your ui_cloner grabs raw HTML. Raw HTML from production websites is:
- Full of vendor scripts, analytics, A/B testing code, CDN references
- Using the competitor's class names, design system, component library
- Tightly coupled to their build system (webpack chunks, hashed class names)
- Not componentized — it's rendered output, not source code

You need to go from **visual output** (what it looks like) to **semantic structure** (what it IS), then to **your implementation** (React + your design system). The Figma middleman approach handles this because Figma strips away all the noise and gives you clean layers.

---

## ASPECT 4: BEING DESIGN-OPINIONATED WITHOUT DESIGN TRAINING

### Your Situation
You have taste. You can look at a screen and say "that's wrong" or "that feels heavy" or "the spacing is off." But you can't translate that into CSS, component structure, or design system decisions.

### The Workflow That Solves This

```
STEP 1: Competition Research
  /compete-research <competitor-urls>
  → Deep UX teardown of each competitor
  → Feature matrix: what they have, what you want
  → Screenshots of every screen/state
  → Infrastructure analysis (what they're built with)
  → Output: .planning/competition-research.md

STEP 2: UX Design Brief  
  /ux-brief
  → Reads competition research + your PRD
  → Grills you on UX preferences (in plain English):
    "Do you prefer dense dashboards or spacious layouts?"
    "Should the sidebar be collapsible or always visible?"
    "How many actions should a user see at once?"
  → Produces a UX specification document
  → Output: .planning/ux-brief.md

STEP 3: Design in Figma (You + AI)
  → Use Figma Make to turn prompts into prototypes
  → OR use competitor screenshots as Figma frames and edit them
  → You arrange, adjust, react to options
  → The design is your taste made tangible

STEP 4: Code from Figma
  /figma-to-code <figma-link>
  → Uses gbasin/figma-to-react or Figma MCP
  → Pixel-perfect React + Tailwind from your approved design
  → Visual validation loop ensures match

STEP 5: UX Audit
  → Run mastepanoski/nielsen-heuristics-audit on the result
  → Catches: cognitive load issues, missing affordances, accessibility gaps
  → Fix before shipping
```

---

## WHAT TO BUILD NEXT (Skills/Commands)

Based on everything found, here are the skills to build in priority order:

### 1. `/compete-research` — Competition Deep Dive
**Reads**: competitor URLs (list of 3-5 competitors)
**Does**:
- Playwright crawls each competitor's app (screenshots of every screen)
- Claude Vision analyzes: layout patterns, feature inventory, UX patterns, visual hierarchy
- Wappalyzer-style tech detection (from HTML headers, scripts, meta tags)
- Feature matrix: what each competitor has vs what you plan
- UX teardown: information architecture, cognitive load, navigation patterns
- Infrastructure notes: what framework, what CDN, what auth system
**Outputs**: `.planning/competition-research.md`

### 2. `/ux-brief` — UX Design Requirements (Plain English Grilling)
**Reads**: PRD + competition research
**Does**: Grills you on UX preferences — no design jargon, just "how should it feel?"
**Outputs**: `.planning/ux-brief.md` — feeds into Figma design or direct frontend skill

### 3. `/design-review` — UX Audit of Running App
**Reads**: Running app URL
**Does**: Playwright crawls, takes screenshots, runs Nielsen heuristics + WCAG + cognitive load analysis
**Outputs**: Prioritized list of UX issues with screenshots and fix suggestions

### 4. Install these existing tools (no building needed):
- `claude plugin add anthropic/frontend-design` — opinionated design skill
- `claude plugin add nextlevelbuilder/ui-ux-pro-max-skill` — design intelligence database
- `claude plugin marketplace add gbasin/figma-to-react` — pixel-perfect Figma-to-React
- `claude mcp add --transport http figma https://mcp.figma.com/mcp` — official Figma connection
- Playwright MCP: `claude mcp add playwright -s user -- npx @playwright/mcp@latest`
- Bookmark: abi/screenshot-to-code for quick UI cloning

---

## REFERENCE REPOS SUMMARY

### Must-Read Repos (Clone and Study)

| Repo | What It Does | Priority |
|------|-------------|----------|
| wilwaldon/Claude-Code-Frontend-Design-Toolkit | Meta-guide to ALL frontend design tools | READ FIRST |
| gbasin/figma-to-react | Pixel-perfect Figma → React plugin | INSTALL |
| abi/screenshot-to-code | Screenshot/URL → HTML/React/Vue code | USE |
| mastepanoski/claude-skills | UX audit (Nielsen, WCAG, Don Norman) | INSTALL |
| nextlevelbuilder/ui-ux-pro-max-skill | Design intelligence database | INSTALL |
| scoobynko/claude-code-design-skills | Figma-to-code workflow skill | STUDY |
| superyhee/claude-ui-copilot | Screenshot/Figma → code with conversation | STUDY |
| deanpeters/* skills | Competition research, customer journey mapping | STUDY |

### Tools (Not Repos)

| Tool | What It Does | Cost |
|------|-------------|------|
| Figma (free plan) | Design tool — Claude integrates bidirectionally | Free |
| Figma MCP (official) | Claude ↔ Figma connection | Free (Dev Mode for full features) |
| Wappalyzer extension | Detect competitor tech stacks | Free (50/month) |
| BuiltWith | Historical tech stack data | Free lookup |
| Playwright MCP | Claude browses and interacts with web apps | Free |

---

## YOUR UPDATED WORKFLOW (With UI/UX + Competition)

```
PHASE 0:  CAPTURE          → /capture-planning
PHASE 1:  COMPETE           → /compete-research (NEW — deep competition dive)
PHASE 2:  GRILL             → /grill-me (stress-test the idea)
PHASE 3:  UX BRIEF          → /ux-brief (NEW — UX preferences in plain English)
PHASE 4:  LANGUAGE           → /ubiquitous-language
PHASE 5:  PRD                → /write-a-prd (now informed by competition + UX brief)
PHASE 6:  DATABASE           → /data-grill → /db-architect
PHASE 7:  DESIGN             → Figma (wireframes/mockups from UX brief + competition screenshots)
PHASE 8:  CODE FROM DESIGN   → /figma-to-code (pixel-perfect React from approved Figma)
PHASE 9:  MILESTONE          → /prd-to-gsd
PHASE 10: BUILD              → /gsd:discuss → /gsd:plan → /gsd:execute
PHASE 11: DESIGN REVIEW      → /design-review (NEW — UX audit of built app)
PHASE 12: VERIFY             → /anneal-check --gate
PHASE 13: CROSS-CHECK        → /verify-with-codex
PHASE 14: QA                 → /qa
PHASE 15: DOCUMENT           → /feature-census → /census-to-specs
PHASE 16: TEST & HARDEN      → /harden
PHASE 17: NEXT               → /where-am-i → next milestone
```

The key additions: Competition research and UX brief happen BEFORE the PRD, so the PRD is informed by what competitors do and how you want your product to feel. Design happens AFTER the PRD but BEFORE coding, so code is generated FROM approved designs. Design review happens AFTER building, as a quality gate before shipping.
