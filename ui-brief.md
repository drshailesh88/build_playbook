# UI Brief — Define the Visual Language Before Writing Frontend Code

Interview the founder about the visual identity of the app — fonts, colors, spacing, borders, shadows, animations, component style. Extracts visual DNA from inspiration apps identified in competition research. Produces a design specification that frontend development follows.

Input: $ARGUMENTS (module name or "app" for app-wide visual language)

## Why This Exists

A UX brief says "the sidebar should collapse after selection." A UI brief says "the sidebar should collapse with a 150ms ease-out transition, have a 1px border-right in #e5e7eb, use Inter 14px medium for labels, and have 12px vertical padding between items."

Without this, the AI picks defaults — and defaults produce generic-looking apps that all look the same.

## Prerequisites

Read these first:
- `.planning/competition-research.md` — especially the Design Inspirations section with visual DNA
- `.planning/ux-brief.md` — UX decisions that the visual language must support

## Process

### Step 1: Extract Visual DNA from Inspirations

Before asking the founder anything, analyze the inspiration apps from competition research. For each inspiration app, extract (using Playwright MCP or screenshots):

```
Font family (inspect or detect from CSS)
Font sizes (base, headings, small text)
Line height
Letter spacing
Color palette (background, text, accent, borders, hover states)
Border radius (sharp corners, slightly rounded, pill-shaped)
Shadow usage (none, subtle, pronounced)
Spacing scale (tight 4px, medium 8px, generous 16px base unit)
Border usage (lines between items, or spacing alone)
Icon style (outlined, filled, duotone)
Button style (solid, outline, ghost, text-only)
Input style (bordered, underlined, filled background)
```

Present these extractions to the founder as a starting point:

> "I analyzed your inspiration apps. Here's what I found:
>
> **Linear**: Inter font, 14px base, very tight spacing, subtle borders, blue accent (#5E6AD2), 6px border-radius, minimal shadows, outlined icons
>
> **Bear**: Custom serif for content, system sans for UI, generous line height, warm backgrounds, almost no borders, very rounded (12px), no shadows, minimal icons
>
> **Superhuman**: Inter/SF Pro, 13px base, dark backgrounds (#1a1a2e), high-contrast accent (#e94560), sharp corners (4px), no shadows, custom icons
>
> These are your ingredients. Now let me ask which elements to pick from each."

### Step 2: Present the Visual Questionnaire

All questions at once, with the inspiration extractions as reference points.

---

### SECTION A: Typography

**A1. What feeling should the fonts create?**
- Clinical precision (clean sans-serif, tight spacing — like Linear, Figma)
- Warm readability (rounded sans-serif or serif for content — like Bear, Medium)
- Bold authority (strong weights, tight tracking — like Superhuman, Stripe)
- Neutral professionalism (safe, clean, inoffensive — like Google Docs, Notion)

Show examples of each. Link to apps that demonstrate the feeling.

**A2. Should headings and body text use the same font or different fonts?**
- Same font, different weights (clean, unified — most modern apps)
- Different fonts (serif headings + sans body, or vice versa — editorial feel)
- Monospace for certain contexts (code blocks, data, terminal-like sections)

**A3. Font size preference for body text:**
- Compact: 13-14px (dense, more content visible — Linear, VS Code)
- Standard: 15-16px (balanced readability — Notion, most web apps)
- Generous: 17-18px (editorial, long-form reading — Medium, Bear)

**A4. How much breathing room between lines of text?**
- Tight: 1.3-1.4 line height (dense, data-oriented)
- Comfortable: 1.5-1.6 line height (balanced, most apps)
- Airy: 1.7-1.8 line height (editorial, reading-focused)

**A5. Should the skill suggest specific font pairings?**
The founder may not know font names — and that's fine. Based on the vibe and feeling answers above, the skill should recommend 2-3 font pairing options with visual previews:

> "Based on your 'warm readability' preference, here are three options:
> 1. **Inter + Lora** — clean sans-serif UI + elegant serif for content
> 2. **Plus Jakarta Sans** — slightly rounded, friendly, works for everything
> 3. **IBM Plex Sans + IBM Plex Serif** — professional, pairs well, open source
>
> Which direction feels right? Or should I look for others?"

<HARD-GATE>
If the founder says they don't know — DO NOT default to Inter/system fonts. Recommend based on vibe and explain WHY each option works. The founder has opinions about fonts (they said so — they can spot bad pairings). Help them find what matches their taste.
</HARD-GATE>

---

### SECTION B: Color

**B1. What mood should the color palette create?**
- Cool and professional (blues, greys — like Linear, Figma)
- Warm and inviting (warm whites, muted accents — like Notion, Bear)
- Bold and energetic (saturated accent colors, contrast — like Superhuman, Vercel)
- Earthy and calm (muted greens, browns, low saturation — like Headspace)

**B2. From your inspiration apps, which app's color feeling do you want to start from?**
Show the extracted palettes from Step 1. Let the founder point at one.

**B3. How should accent color be used?**
- Sparingly (only for primary buttons and active states — 5% of the screen)
- Moderately (buttons, links, highlights, active tabs — 10-15%)
- Generously (colored backgrounds, headers, large UI elements — 20%+)

**B4. Background tone:**
- Pure white (#FFFFFF — clinical, bright)
- Warm white (#FAFAF9, #F5F5F0 — softer, easier on eyes)
- Cool grey (#F8FAFC, #F1F5F9 — modern, slightly muted)
- Dark (#0F172A, #1E1E2E — for dark mode default)

**B5. For dark mode (if applicable), what darkness level?**
- True black (#000000 — OLED-friendly, high contrast like Superhuman)
- Dark grey (#1a1a2e, #1E1E2E — easier on eyes, most dark mode apps)
- Soft dark (#2D2D2D, #3C3C3C — less contrast, warmer)

**B6. How many colors total in the palette?**
- Minimal (1 accent + neutrals — like Bear, Apple)
- Standard (1 primary + 1 secondary + neutrals — like Linear)
- Rich (primary + secondary + success/warning/error + neutrals — like full design systems)

The skill should generate the complete palette based on answers, including:
- Background shades (4-5 levels)
- Text colors (primary, secondary, muted)
- Border colors
- Accent and its hover/active states
- Semantic colors (success green, error red, warning yellow, info blue)

---

### SECTION C: Spacing and Layout

**C1. Overall spacing feel:**
- Tight (4px base unit — dense, efficient — like Linear)
- Medium (8px base unit — balanced — like most apps)
- Generous (12-16px base unit — spacious, calm — like Bear, Apple)

**C2. How should sections be separated?**
- Borders (1px lines between sections — traditional, clear)
- Spacing only (whitespace separates things, no lines — modern, clean)
- Cards (content in bordered/shadowed containers — Material Design)
- Combination (borders for lists, spacing for sections)

**C3. How should cards/containers feel?**
- No elevation (flat, modern — like Linear, Bear)
- Subtle shadow (slight depth — like Notion)
- Pronounced shadow (clear elevation — like Material Design)

**C4. Border radius — how rounded?**
- Sharp (0-2px — technical, precise)
- Slightly rounded (4-6px — modern default)
- Rounded (8-12px — friendly, softer)
- Pill (full rounding on buttons — playful, iOS-like)

---

### SECTION D: Components

**D1. Button style:**
- Solid filled (colored background, white text — most common)
- Outline (transparent, colored border — secondary feel)
- Ghost (no background, no border, just text — minimal)
- Mix (primary action = solid, secondary = outline, tertiary = ghost)

**D2. Input field style:**
- Bordered (full border around the field — traditional)
- Underlined (only bottom border — Material Design)
- Filled (light background, no visible border — modern)

**D3. Icon style:**
- Outlined (line icons — Lucide, Feather — lightweight, modern)
- Filled (solid icons — heavier, more visible)
- Duotone (two-tone icons — distinctive, Phosphor style)

---

### SECTION E: Imagery and Personality

**E1. Does the app use illustrations or imagery?**
- No — pure functional UI, content is the visual (like Bear, Terminal)
- Minimal — empty states have illustrations, rest is functional (like Linear)
- Moderate — onboarding, marketing, error states have illustrations (like Notion)

**E2. If illustrations exist, what style?**
- Geometric/abstract (shapes and lines — like Linear)
- Hand-drawn/sketchy (warm, human — like Notion's illustrations)
- Photographic (real images — unusual for SaaS tools)
- None — text and icons only

---

### Step 3: Receive Brain Dump and Follow Up

Same pattern as UX brief:
1. Founder answers in bulk
2. Follow-up questions from answers
3. Follow-ups from follow-ups
4. Cycle until zero ambiguity

<HARD-GATE>
Do NOT produce the UI Brief until zero questions remain. The LLM makes ZERO visual decisions on its own.

Exception: Technical details the founder explicitly can't answer (exact hex codes, font size in pixels). For these, the skill RECOMMENDS based on the stated preferences and explains why. But it presents the recommendation for approval, never silently applies it.
</HARD-GATE>

### Step 4: Produce the UI Brief

Save to: `.planning/ui-brief.md`

```markdown
# UI Brief: [App/Module Name]
**Date:** [date]
**Source:** UI interview + competition research + UX brief
**Status:** COMPLETE — ready for frontend development

## Design Identity
- **Vibe in 3 words:** [from UX brief]
- **Inspired by:** [App A]'s [quality] + [App B]'s [quality] + [App C]'s [quality]
- **Not like:** [what to avoid]

## Typography
- **Heading font:** [font name] — [why]
- **Body font:** [font name] — [why]
- **Monospace font:** [font name] — for code blocks
- **Base size:** [px]
- **Scale:** [size scale for h1-h6, body, small, caption]
- **Line height:** [ratio]
- **Font weights used:** [list — e.g., 400 regular, 500 medium, 600 semibold, 700 bold]

## Color Palette
- **Light mode:**
  - Background: [hex] → [hex] → [hex] (3-4 levels)
  - Text: [primary hex], [secondary hex], [muted hex]
  - Accent: [hex] (hover: [hex], active: [hex])
  - Borders: [hex]
  - Semantic: success [hex], error [hex], warning [hex], info [hex]

- **Dark mode:** (if applicable)
  - Background: [hex] → [hex] → [hex]
  - Text: [primary hex], [secondary hex], [muted hex]
  - Accent: [same or adjusted hex]
  - Borders: [hex]

## Spacing
- **Base unit:** [px]
- **Scale:** 4, 8, 12, 16, 24, 32, 48, 64 (or custom)
- **Section separation:** [borders / spacing / cards]
- **Content max-width:** [px for text-heavy, full for data-heavy]

## Components
- **Buttons:** [solid primary / outline secondary / ghost tertiary]
- **Inputs:** [bordered / underlined / filled]
- **Border radius:** [px]
- **Shadows:** [none / subtle: values / pronounced: values]
- **Icons:** [Lucide / Phosphor / custom] — [outlined / filled / duotone]

## Motion
- **Navigation:** [instant / crossfade Xms]
- **Hover effects:** [description]
- **Modal appearance:** [instant / fade Xms / slide]
- **Button feedback:** [description]
- **Loading states:** [skeleton / spinner / progress bar]

## Imagery
- **Style:** [none / geometric / hand-drawn / photographic]
- **Usage:** [empty states only / onboarding / throughout]

## CSS Variables Template
```css
:root {
  /* Typography */
  --font-heading: '[font]', sans-serif;
  --font-body: '[font]', sans-serif;
  --font-mono: '[font]', monospace;
  --font-size-base: [X]px;
  --line-height-base: [X];
  
  /* Colors - Light */
  --bg-primary: [hex];
  --bg-secondary: [hex];
  --bg-tertiary: [hex];
  --text-primary: [hex];
  --text-secondary: [hex];
  --text-muted: [hex];
  --accent: [hex];
  --accent-hover: [hex];
  --border: [hex];
  
  /* Spacing */
  --space-unit: [X]px;
  --space-xs: calc(var(--space-unit) * 0.5);
  --space-sm: var(--space-unit);
  --space-md: calc(var(--space-unit) * 2);
  --space-lg: calc(var(--space-unit) * 3);
  --space-xl: calc(var(--space-unit) * 4);
  
  /* Shape */
  --radius: [X]px;
  --shadow: [value or 'none'];
  
  /* Motion */
  --transition-fast: [X]ms ease;
  --transition-normal: [X]ms ease;
}
```
```

### Step 5: Commit and Handoff

```bash
git add .planning/ui-brief.md
git commit -m "ui: complete visual language specification from founder interview"
```

> "Visual language defined. Typography, colors, spacing, components, and motion all documented.
>
> The CSS variables template is ready to drop into your project.
> 
> Next steps:
> - Start building with frontend-design skill (it will read the UI brief)
> - Or design in Figma first using these specs, then /figma-to-code
> - The UI brief + UX brief together give the AI everything it needs to build screens that match your vision."

## Rules

- **ALL questions presented upfront** — bulk brain dump, not drip-fed
- **Visual references from actual inspiration apps** — don't describe "warm sans-serif," show Bear's typography
- **Extract visual DNA BEFORE asking questions** — start with concrete data from inspirations, not abstract choices
- **Follow-up cycle until zero ambiguity** — brain dump → follow-ups → follow-ups of follow-ups → done
- **LLM makes ZERO visual decisions alone** — recommend with reasoning, but founder approves everything
- **Generate actionable output** — CSS variables template, exact hex codes, exact font names. Not "use a warm color" — use "#F5F5F0"
- **Font guidance is mandatory** — the founder said they can spot bad fonts but don't know font names. The skill MUST recommend specific pairings with explanations, never just ask "what font do you want?"
- **Respect the positioning** — if the founder picks a playful font for a serious medical tool, push back: "This font might make your app feel less credible to researchers. Here's an alternative that's approachable but still professional."
