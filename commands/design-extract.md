# design-extract — Extract design.md + voice.md from an inspiration site

Replaces the extractable half of the UI grill with measurement. A UI has two
separable layers and they get two different treatments:

1. **Design tokens** (colors, type, spacing, radius, shadows, motion — "how
   they play") — these are FACTS about an inspiration site. Extract them
   with a browser, don't interview the founder about them.
2. **Copy & voice** (how things are written — terminology, tone, microcopy)
   — this is a CONTRACT for the AI to write within. Extract the inspiration's
   voice rules, merge with the project's ubiquitous language, and let the AI
   write copy inside those rails.

The founder's job shrinks to RATIFICATION: approve/amend the extraction,
captured as DECs. `/ui-brief` then grills only the deltas the extraction
can't answer (brand identity, what to deliberately do differently).

Input: `$ARGUMENTS` — inspiration URL(s), e.g. `https://clay.com`. Multiple
URLs allowed; the first is primary, others contribute named exceptions
("buttons like X, tables like Y").

## Produces

```
.planning/design.md       tokens + the "how they play" narrative
.planning/tokens.css      CSS custom properties, drop-in
.planning/voice.md        copy contract: voice rules + term mappings
.planning/design-refs/    screenshots captured during extraction
```

## Process

### 1. Capture (browser, not vibes)

Use the available browser tooling (agent-browser CLI, Playwright MCP, or
Chrome MCP — whichever is connected). For the primary URL:

- Screenshot: landing hero, a content-dense section, nav, footer, any
  app/dashboard screenshots the site shows, mobile viewport (390px).
- Extract computed styles via JS evaluation on real elements:
  - Type: font-family stacks (display/body/mono), the actual size ladder
    (h1..body..caption with weights and line-heights), letter-spacing
  - Color: background layers (page/surface/raised), text hierarchy
    (primary/secondary/muted), accent(s) and where they are SPENT (links?
    CTAs only? icons?), semantic colors, border colors
  - Space: base unit (measure paddings/gaps across 10+ components — find
    the rhythm), container max-widths, section vertical rhythm
  - Shape: border-radius scale (buttons vs cards vs inputs vs pills),
    border weights, shadow recipes (copy exact box-shadow values)
  - Motion: transition durations/easings on hover/focus states (read the
    CSS, hover real elements)
  - Components: button anatomy (height, padding, font, radius, hover
    delta), input anatomy, card anatomy
- Pull the site's CSS files and grep for custom properties — many sites
  ship their token system in plain sight (`--color-*`, `--space-*`).

### 2. Distill design.md

Not a dump — a system description:

```markdown
# Design System — extracted from <url> (YYYY-MM-DD)

## How it plays (the narrative — REQUIRED)
3-6 sentences a builder can hold in mind: e.g. "Near-monochrome surface
stack with one warm accent spent ONLY on primary actions. Generous spacing
(8px base, sections breathe at 96-128px). Type does the hierarchy work —
color almost never does. Radius is large (12-16px) and consistent. Motion
is minimal: 150ms ease-out on interactive elements only."

## Tokens
[tables: type ladder, color roles with hex, spacing scale, radius scale,
shadow recipes, motion]

## Component anatomies
[button/input/card measured specs]

## Exceptions from secondary inspirations
[named: "data tables follow <url2>: denser, 40px rows"]

## What we deliberately do differently
[FOUNDER section — filled during ratification, not extraction]
```

And `tokens.css` with the same values as custom properties, named by ROLE
(`--surface-raised`, `--text-muted`, `--accent`), never by hue.

### 3. Distill voice.md (the copy contract)

From the site's actual copy (hero, CTAs, empty states, error text if
reachable, docs/marketing tone):

```markdown
# Voice — extracted from <url>, merged with UBIQUITOUS_LANGUAGE.md

## Voice rules (measured, with examples quoted from the site)
- Person & address: ("you" direct? "we"? imperative?)
- Sentence length: (avg words in headings / body)
- Capitalization: (Title Case vs Sentence case — headings, buttons, labels)
- CTA verb style: ("Start building" pattern — verb+object, no "Submit")
- Microcopy temperature: (playful/neutral/formal; contractions?)
- Numbers & specificity: (does the copy use concrete numbers?)

## Term mappings (ours, from UBIQUITOUS_LANGUAGE.md — overrides inspiration)
[our domain terms win over inspiration phrasing, always]

## Banned
[words/patterns the founder vetoes: "leverage", exclamation marks, ...]
```

The AI writes all UI copy and landing copy INSIDE this contract — free hand
on content, zero freedom on voice. Landing-page copy gets drafted as its own
deliverable for founder review, never silently shipped.

### 4. Ratify (the shrunken grill)

Present design.md + voice.md to the founder section by section. Three
possible responses per section: APPROVE / AMEND (founder states the change)
/ DIFFERENTIATE (deliberately diverge — goes in "What we do differently").
Each ratified section = one DEC (continue from `.planning/next-dec-id`).
Then hand off: `/ui-brief` runs ONLY for questions the extraction could not
answer — brand assets, logo treatment, dark mode stance, density preference
if the inspiration conflicts with the app's data-heavy needs.

### 5. Adapt, don't clone

Extraction targets the SYSTEM (relationships, scales, rhythm), not the
identity. During ratification, shift identity elements: swap the accent hue,
keep the "spend accent only on primary actions" rule; swap the display font,
keep the size ladder. The narrative section is the part worth stealing —
exact hex values are the least important output. Never copy logos, imagery,
or distinctive illustrations; never reproduce copy verbatim — voice.md
captures RULES, not sentences.

## Downstream

- `/ui-brief` consumes design.md (grills only deltas) — run AFTER this
- Pathways/stories reference tokens by role name; builders import tokens.css
- voice.md is referenced in frontend story contracts ("all copy per
  .planning/voice.md") and is T0-lockable during runs
- Re-extraction is a deliberate act (like the Mobbin harvest), never a
  build-time lookup

## Rules

- Measure, don't eyeball: every token value comes from computed styles or
  the site's own CSS, with the source noted
- The narrative ("how it plays") is REQUIRED — tokens without the system
  description produce cargo-cult UIs
- Founder ratifies before anything downstream consumes the artifacts
- Multiple inspirations = one primary system + named exceptions; never blend
  two systems into mush
- Screenshots saved to design-refs/ are evidence, not assets — never shipped
