# ux-pattern-harvest — Exhaustive Mobbin sweep into a frozen pattern library

Harvests design patterns from Mobbin (MCP) into pattern cards on disk —
every relevant path, every relevant pattern, distilled once — so builders
always work from a frozen reference instead of live research. Research in
the loop is decision leak; research into an artifact is a library.

Input: `$ARGUMENTS` — surfaces to harvest (e.g. `org-switcher invites
onboarding roles billing`), or `--from-planning` to derive the surface list
from `.planning/` (ux-brief gaps, REBUILD-KICKOFF delta track, pathway
modules without pattern citations).

## Two destinations

| What | Where | Why |
|---|---|---|
| Generic pattern cards (how the industry does org switching) | playbook repo `research/ux-patterns/` | Reusable across every future project |
| This project's surface needs + chosen patterns | project `.planning/ux-patterns/` + DEC records | The choice is a decision; the card is just evidence |

## Process

### 1. Load Mobbin tools and scope the sweep

Discover the MCP tools first (`ToolSearch "mobbin"` — load ALL of them).
Build the sweep matrix: each surface × three search modes:
- **by-app**: the named reference apps (default set: Raycast, Linear, Slack,
  Notion, Vercel, Stripe — override per project) — walk their relevant flows
- **by-pattern**: pattern-name searches ("workspace switcher", "team invite",
  "member management", "role picker", "plan upgrade", "empty state")
- **by-flow**: task searches ("invite a teammate", "create workspace",
  "accept invitation", "change member role", "cancel subscription")

Multi-modal matters: each mode surfaces patterns the others miss.

### 2. Sweep until dry

For each surface, run all three modes. Keep harvesting until 2 consecutive
queries return nothing new (loop-until-dry — fixed query counts miss the
tail). For every distinct pattern found, record: app, flow name, Mobbin
reference/URL, step sequence as observed, and what problem the pattern is
solving. Save screenshots/refs links — never paste binary content.

### 3. Distill into pattern cards

One card per distinct pattern (not per app) at
`research/ux-patterns/<surface>/<pattern-slug>.md`:

```markdown
# Pattern: Inline workspace switcher (sidebar header)
**Surface:** org-switcher · **Observed in:** Raycast, Linear, Slack (refs: <mobbin links>)

## Flow
1. Avatar/workspace name in sidebar header, click opens popover
2. Popover lists workspaces with avatars + checkmark on active
3. Footer actions: "Create workspace", "Join workspace", settings gear
4. Switch is instant — no page reload, optimistic, toast on failure

## Use when
Multi-workspace users switch frequently; sidebar is persistent.

## Avoid when
Switching is rare (better in account menu) or mobile-first (use sheet).

## Sad paths observed
- Last-workspace deletion → forced create/join screen (Linear)
- Invite revoked mid-session → graceful eviction to picker (Slack)

## Accessibility
Popover keyboard-navigable; active workspace announced.

## Default verdict for our stack
RECOMMENDED / VIABLE / AVOID — one line why.
```

Plus `research/ux-patterns/<surface>/INDEX.md`: every pattern found, one
line each, with the recommended default marked. Coverage note at the top:
which apps/modes were swept, what was excluded (no silent truncation).

### 4. Choose → DEC (the part that prevents the mess)

The harvest produces CANDIDATES. For each project surface, a short grill:
present the cards, founder picks (or amends), the choice is captured as a
DEC with the card cited as evidence and rejected patterns named. Pathways
for that surface then cite the DEC + card: builders implement a decided
pattern, never "something like Linear".

### 5. Freeze

Project `.planning/ux-patterns/` is covered by the same T0 locked-path rule
as pathways. Refreshing the library = re-running this command deliberately,
never an agent's mid-build improvisation.

## Rules

- Cards record what was OBSERVED, with refs — never invent a pattern and
  attribute it to an app
- One pattern per card; apps are evidence, not the unit
- Every card states when NOT to use the pattern — a library without
  anti-recommendations is a mood board
- Sad paths are first-class harvest targets (how do these apps handle
  revoked invites, last-member-leaves, expired sessions?)
- The harvest NEVER makes the choice — choices are DECs, made by the founder
- Coverage honesty: state what wasn't swept
