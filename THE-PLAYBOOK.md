# THE PLAYBOOK — From Idea to Hardened Product
## Read This When Starting Any New Project or Resuming Work

---

## HOW TO USE THIS DOCUMENT

**If you're the founder:** Read top-to-bottom. Each phase tells you what to do, what command to run, and what you'll produce. You don't skip phases. You don't jump ahead. The order is the strategy.

**If you're the AI agent:** Read the current phase. Execute the command listed. Produce the output listed. Do not proceed to the next phase until the output exists and the founder has confirmed. If you don't know where you are, run `/where-am-i`.

---

## PHASE 0: SETUP (Once Per Project)

### 0.1 — Install the Skills and Commands

```bash
# Copy from master skills repo into your project
./install.sh /path/to/your-project

# This copies:
#   .claude/commands/   — all slash commands
#   .claude/skills/     — all skills with reference files
```

### 0.2 — Install Plugins and MCPs

```bash
# Design
claude mcp add --transport http figma https://mcp.figma.com/mcp
claude mcp add playwright -s user -- npx @playwright/mcp@latest
claude plugin add anthropic/frontend-design
claude plugin marketplace add gbasin/figma-to-react
claude plugin add nextlevelbuilder/ui-ux-pro-max-skill

# Database
claude plugin marketplace add timescale/pg-aiguide
claude plugin marketplace add supabase/agent-skills

# Security
claude plugin marketplace add trailofbits/skills
claude plugin marketplace add AgentSecOps/SecOpsAgentKit

# Performance + Accessibility
# (Install Addy Osmani's web-quality-skills)
npx add-skill addyosmani/web-quality-skills

# DevOps
claude plugin marketplace add ahmedasmar/devops-claude-skills

# Project Management
npx get-shit-done-cc@latest
```

### 0.3 — Install Playwright for Testing

```bash
npm install -D @playwright/test
npx playwright install chromium
```

### Output Checklist
- [ ] `.claude/commands/` has all command files
- [ ] `.claude/skills/` has all skill folders
- [ ] All plugins installed (verify with `claude /plugins`)
- [ ] Playwright installed
- [ ] GSD initialized

---

## PHASE 1: CAPTURE & RESEARCH

> **What happens here:** You dump everything in your head. You research your competition. You establish what you're building and who you're building for.

### Step 1.1 — Capture Planning (if coming from a planning session)

```
/capture-planning [paste your Claude.ai / ChatGPT planning notes]
```

**Produces:** `.planning/decisions/YYYY-MM-DD-topic.md`
**You do:** Paste your planning session output. The command structures it.

### Step 1.2 — Competition Research

```
/compete-research
```

**Produces:** `.planning/competition-research.md`
**You do:** Provide two lists:
1. **Competitors** (3-5 apps doing the same job)
2. **Design inspirations** (2-4 apps from ANY industry whose feel you want to steal)

For each inspiration, specify WHAT you're stealing (speed? typography? layout? keyboard shortcuts?)

**The command does:**
- Crawls competitor apps (screenshots, features, UX teardown)
- Detects competitor tech stacks
- Extracts visual DNA from inspiration apps (fonts, colors, spacing, motion)
- Produces feature parity matrix
- Produces identity synthesis: "Our app should feel like X's speed meets Y's typography"

---

## PHASE 2: GRILL & INTERVIEW

> **What happens here:** You get grilled on every decision. Every question asked, every edge case explored, zero ambiguity left. This phase produces the specifications that everything downstream consumes.

### Step 2.1 — Product Grilling

```
/grill-me [topic or paste your idea]
```

**Produces:** Stress-tested decisions, captured in conversation
**You do:** Answer every question. Push back if you disagree. Say "I don't know" if unsure.

### Step 2.2 — UX Brief

```
/ux-brief app
```

**Produces:** `.planning/ux-brief.md`
**You do:** Receive ALL UX questions at once. Brain dump your answers in bulk. Answer follow-ups until zero ambiguity.

**Reads:** `.planning/competition-research.md` (uses competitor examples in questions)
**References:** `.claude/skills/design-rules/founders-design-rules.md` (your 10 portable design rules)

**Covers:** App identity (vibe, persona, anti-patterns), navigation, per-module UX (Bear model vs Wizard model), content density, motion speed, feedback patterns.

### Step 2.3 — UI Brief

```
/ui-brief app
```

**Produces:** `.planning/ui-brief.md` (with CSS variables template)
**You do:** Receive visual DNA extractions from inspirations, then answer visual questions. The skill recommends font pairings — you approve.

**Reads:** `.planning/competition-research.md` + `.planning/ux-brief.md`

**Covers:** Typography (fonts, sizes, weights), colors (palette with exact hex values), spacing scale, border radius, shadows, button/input/icon styles, motion timing.

### Step 2.4 — Data Grilling

```
/data-grill [path to PRD or "latest"]
```

**Produces:** `.planning/data-requirements.md`
**You do:** Answer questions about every piece of data your app stores. No database jargon. Plain English.

**Covers per data subject:** What is it, who creates/sees it, lifecycle (create/update/delete/recover), contents and connections, limits and rules, search and discovery, billing impact, future growth.

### Step 2.5 — Infrastructure Grilling

```
/infra-grill [path to PRD or "interactive"]
```

**Produces:** `.planning/infra-requirements.md`
**You do:** Answer questions about users, traffic, budget, reliability, growth. No cloud jargon.

**Covers:** User geography and scale, response time expectations, file uploads, AI usage, reliability/downtime tolerance, monthly budget, existing platforms, future plans (mobile, API, institutional sales).

---

## PHASE 3: LANGUAGE & PRD

> **What happens here:** You establish shared vocabulary and write the formal product document. The PRD is informed by everything from Phase 1 and Phase 2.

### Step 3.1 — Ubiquitous Language

```
/ubiquitous-language
```

**Produces:** `UBIQUITOUS_LANGUAGE.md`
**You do:** Work with the agent to define terms. "Document" vs "paper" vs "article" — what does YOUR app call things?

### Step 3.2 — Write the PRD

```
/write-a-prd
```

**Produces:** PRD document (GitHub issue or markdown file)
**You do:** The agent drafts based on everything gathered. You review and approve.

**Reads:** All `.planning/` files from Phase 2 + competition research + ubiquitous language.

---

## PHASE 4: TECHNICAL ARCHITECTURE

> **What happens here:** The grilling outputs from Phase 2 get converted into technical specifications by expert skills. You don't need to understand the output — the skills do.

### Step 4.1 — Database Architecture

```
/db-architect
```

**Produces:**
- `src/lib/db/schema/*.ts` — Drizzle ORM TypeScript schema files
- Migration SQL via `npx drizzle-kit generate`
- `SCHEMA_DECISIONS.md` — every table/column/index explained in plain English
- ERD diagram (Mermaid)

**Reads:** `.planning/data-requirements.md` (from Step 2.4)
**References:** PostgreSQL golden rules, schema patterns, migration safety, anti-pattern detection

### Step 4.2 — Infrastructure Architecture

```
/infra-architect
```

**Produces:**
- `INFRA_DECISIONS.md` — platform choices explained in plain English with costs
- Config files (vercel.json / wrangler.toml / Dockerfile as needed)
- `.github/workflows/ci.yml` — CI/CD pipeline
- `.env.example` — required environment variables

**Reads:** `.planning/infra-requirements.md` (from Step 2.5)

### Step 4.3 — Design in Figma (Optional but Recommended)

Using the UX brief + UI brief + competition screenshots:
- Create wireframes/mockups in Figma
- Use Figma MCP: paste Figma link → Claude reads design structure
- Or use Figma Make to generate from prompts

### Step 4.4 — Code From Design

```
# If using Figma:
# Use gbasin/figma-to-react plugin — pixel-perfect React from Figma
# Visual validation loop ensures ≤5% diff from design

# If using screenshots:
# Use abi/screenshot-to-code for initial clone, then refine
```

---

## PHASE 5: MILESTONE & EXECUTION

> **What happens here:** The PRD becomes a GSD milestone with phases. You build, one phase at a time.

### Step 5.1 — Create Milestone

```
/prd-to-gsd [path to PRD]
```

**Produces:** `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/STATE.md`
**Readiness gate:** PRD must score ≥ 6/10 on clarity, user stories, scope, decisions, testability.

### Step 5.2 — Build (Choose Your Builder)

You have 6 ways to build. Pick based on your situation:

**Option A: Manual inside Claude Code (you're at the keyboard, learning)**
```
/gsd:discuss-phase N    ← Flesh out implementation decisions
/gsd:plan-phase N       ← Create atomic task plans
/gsd:execute-phase N    ← Build with task loop
/gsd:quick "fix the broken search"   ← Small tasks
```

**Option B: Sprint Build Perfect — build, test, perfect loop (recommended)**
```
/sprint-build-perfect           ← build current phase
/sprint-build-perfect 3         ← build Phase 3
/sprint-build-perfect all       ← build everything
```
Claude builds each feature, runs unit tests + Playwright E2E tests, and keeps iterating until ALL tests pass. Features do NOT exit the loop until perfected. Full QA sweep at phase boundaries. GSD-aware — tracks progress in `.gsd/` or `.planning/` automatically. Safe to restart in a fresh session — it reads state from disk and picks up where you left off.

**Option C: Adversarial — Claude builds, Codex attacks (best quality)**
```
/adversarial-claude-builds 10
```
Claude writes the code. Codex (different company, different blind spots) tries to break it. What Claude misses, Codex catches. Uses Claude Max tokens for building + Codex tokens for review. Uses Karpathy autoresearch — test score must never decrease.

**Option D: Adversarial — Codex builds, Claude attacks (saves Claude tokens)**
```
/adversarial-codex-builds 10
```
Codex writes the code (cheaper). Claude reviews with deeper reasoning (better adversary). Saves your Claude Max quota. Uses Karpathy autoresearch — test score must never decrease.

**Option E: Overnight via terminal script (unattended, walk away)**
```bash
# In a separate terminal (not Claude Code):
cp ~/Build\ Playbook/adapters/codex/overnight-adversarial.sh ./
./overnight-adversarial.sh 75
```
Codex builds and attacks itself. Runs overnight. Autoresearch score gates + phase boundary regression detection. Review with `/where-am-i` + `/harden` in the morning.

**Option F: GSD v2 (separate CLI, any model)**
```bash
# In a separate terminal:
gsd
/gsd migrate     ← reads your .planning/ files
/gsd auto        ← builds overnight on GLM-5 or any cheap model
```

**When to use which:**

| Situation | Use |
|-----------|-----|
| Learning the codebase, want control | Option A (manual GSD) |
| Building features with full QA | **Option B (`/sprint-build-perfect`) — recommended** |
| Want highest quality, two-company review | Option C (Claude builds, Codex attacks) |
| Running low on Claude Max tokens | Option D (Codex builds, Claude attacks) |
| Going to sleep, build overnight | Option E (terminal script) or F (GSD v2) |
| Quick small fix | `/gsd:quick "fix the thing"` |

### Step 5.3 — Resume After a Break

```
/where-am-i
```

**Reads:** STATE.md, quality-score.json, git log. Tells you exactly where you are and what to do next. Takes 10 seconds.

---

## PHASE 6: QUALITY GATES

> **What happens here:** After building, every quality dimension gets checked before shipping.

### Step 6.1 — Security Audit

```
/security-audit full
```

**Produces:** `.planning/security-audit-YYYY-MM-DD.md`
**Checks:** Leaked secrets, dependency vulnerabilities, OWASP Top 10, API route security, auth implementation, security headers.
**Gate:** CRITICAL findings block shipping. HIGH findings should be fixed first.

### Step 6.2 — Quality Score Check

```
/anneal-check --gate
```

**Produces:** Score comparison (before vs after). Fails if score dropped.
**Reads:** `quality-score.json` baseline → runs `quality-score.mjs` → compares.

### Step 6.3 — Cross-Model Verification

```
/verify-with-codex
```

**Produces:** `.planning/reviews/review-YYYY-MM-DD.md`
**You do:** Copy the review file to Codex or ChatGPT. Paste their verdict back. Agent applies fixes if CONCERNS or REWORK.

### Step 6.4 — Design Review (UX Audit)

Use installed skills:
```
# Nielsen heuristics audit
"Run a Nielsen heuristics audit on the running app at http://localhost:3000"

# WCAG accessibility check  
"Run a WCAG accessibility audit on http://localhost:3000"

# Web quality check (Addy Osmani's skills)
"Audit my site for Core Web Vitals and performance"
```

### Step 6.5 — Human QA

```
/qa
```

**You do:** Walk through the app yourself. File issues for anything wrong.
**Issues format:** Behavior description (no file paths), steps to reproduce, expected vs actual.

---

## PHASE 7: FEATURE DOCUMENTATION & TESTING

> **What happens here:** Every capability gets documented and tested, including features that came from libraries you never explicitly asked for.

### Step 7.1 — Feature Census

```
/feature-census [module]
```

**Produces:** `feature-census/[module]/CENSUS.md` + raw JSON per layer + screenshot
**Layers:**
1. Code extraction (handlers, state, conditionals, API calls, library registrations)
2. Library capability enrichment (what each extension brings — uses `references/library-capabilities.md`)
3. Runtime Playwright crawl (accessibility tree, DOM query, hidden interactions)
**Tags each feature:** CONFIRMED, EMERGENT, CODE-ONLY, RUNTIME-ONLY

### Step 7.2 — Generate Test Specs

```
/census-to-specs [module]
```

**Produces:** `qa/specs/[module]/spec-*.md` files + `qa/queue.jsonl`
**Each feature becomes a testable checkpoint** with pass/fail criteria and source tags.

### Step 7.3 — Run Tests

```
/spec-runner [module]
```

**Produces:** Playwright test files in `qa/generated/[module]/`, results written back to spec files.

### Step 7.4 — Self-Healing Loop

```
/anneal [module]
```

**Does:** Reads failures → diagnoses (code bug vs test bug vs spec bug) → fixes → re-runs → repeats.
**Limits:** 3 retries per checkpoint, 50 total iterations. STUCK items flagged for human.

### Step 7.5 — Full Pipeline (One Command)

```
/harden [module]
```

**Runs:** Census → Specs → Test → Anneal → Verify. One command, walk away.

---

## PHASE 8: SHIP

> **What happens here:** Pre-deployment checks, deploy, post-deploy verification.

### Step 8.1 — Pre-Deploy Checklist

Verify manually or with commands:
- [ ] `/security-audit full` — no CRITICAL or HIGH findings
- [ ] `/anneal-check --gate` — quality score held or improved
- [ ] All tests passing
- [ ] Environment variables set on hosting platform
- [ ] Database migrations applied to production
- [ ] Changelog updated
- [ ] Version bumped

### Step 8.2 — Deploy

```bash
# Vercel
git push origin main  # Auto-deploys if connected

# Or manual
vercel --prod

# Railway
railway up

# Cloudflare
wrangler deploy
```

### Step 8.3 — Post-Deploy Verification

- [ ] App loads at production URL
- [ ] Login works
- [ ] Core feature works (create a document, run a search, etc.)
- [ ] No errors in monitoring dashboard (Sentry)
- [ ] Performance acceptable (run Lighthouse on production URL)

---

## PHASE 9: NEXT

```
/where-am-i
```

Back to Phase 5 for the next milestone, or Phase 1 for a new feature/project.

---

## QUICK REFERENCE — ALL COMMANDS

### Planning & Workflow
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/capture-planning` | After a Claude.ai/ChatGPT session | Paste planning notes | `.planning/decisions/` |
| `/where-am-i` | Resuming after a break | None | Status + next action |
| `/prd-to-gsd` | After PRD is written | PRD path | GSD milestone files |
| `/gsd:discuss-phase N` | Before building a phase | Phase number | Implementation decisions |
| `/gsd:plan-phase N` | After discussion | Phase number | Atomic task plans |
| `/gsd:execute-phase N` | Building | Phase number | Built features |
| `/gsd:quick "task"` | Small tasks | Task description | Quick fix |

### Adversarial Build (Ralph Loop + GAN + Autoresearch)
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/sprint-build-perfect` | **Recommended** — build, test, perfect loop with Playwright QA | Phase number, "all", or nothing (current phase) | Built + tested + perfected code |
| `/adversarial-claude-builds` | Best quality — Claude builds, Codex attacks | Iteration count (default 10) | Built + adversarially reviewed code |
| `/adversarial-codex-builds` | Save Claude tokens — Codex builds, Claude attacks | Iteration count (default 10) | Built + adversarially reviewed code |
| `./overnight-adversarial.sh N` | Overnight unattended build (run in terminal, not Claude Code) | Iteration count | Built code on a branch |

### Research & Design
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/compete-research` | Start of project | Competitor + inspiration URLs | `.planning/competition-research.md` |
| `/grill-me` | Stress-testing an idea | Topic or idea | Grilled decisions |
| `/ux-brief` | After competition research | Bulk brain dump answers | `.planning/ux-brief.md` |
| `/ui-brief` | After UX brief | Visual preferences | `.planning/ui-brief.md` + CSS vars |
| `/ubiquitous-language` | Before PRD | Domain discussion | `UBIQUITOUS_LANGUAGE.md` |
| `/write-a-prd` | After all interviews | Gathered context | PRD document |

### Architecture
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/data-grill` | After PRD | PRD path | `.planning/data-requirements.md` |
| `/db-architect` | After data-grill | Auto-reads requirements | Drizzle schemas + SCHEMA_DECISIONS.md |
| `/infra-grill` | After PRD | PRD path | `.planning/infra-requirements.md` |
| `/infra-architect` | After infra-grill | Auto-reads requirements | Configs + INFRA_DECISIONS.md |

### Quality & Security
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/security-audit` | Before shipping | "full" or module name | Security report |
| `/anneal-check` | After building | `--gate` for hard stop | Score comparison |
| `/verify-with-codex` | After building | Commit count | Review package for second model |

### Testing & Documentation
| Command | When | Input | Output |
|---------|------|-------|--------|
| `/feature-census` | After building | Module name | Complete capability inventory |
| `/census-to-specs` | After census | Module name | Test spec files |
| `/spec-runner` | After specs | Module name | Test results |
| `/anneal` | After test failures | Module name | Self-healing fixes |
| `/harden` | Full pipeline | Module name | Census → specs → test → heal |
| `/generate-feature-doc` | After building | Module name | Feature testing document |

### Auto-Triggered Skills (No Command Needed)
| Skill | Triggers When |
|-------|--------------|
| `verification-before-completion` | Agent claims work is done |
| `feature-census` | Agent needs capability extraction |
| `db-architect` | Agent needs database design |
| `infra-architect` | Agent needs infrastructure decisions |
| `design-rules` | Agent makes UI/UX decisions |

### Installed Plugins (Always Available)
| Plugin | What It Does |
|--------|-------------|
| Figma MCP | Bidirectional design ↔ code |
| Playwright MCP | Agent browses and interacts with web apps |
| anthropic/frontend-design | Opinionated, distinctive UI generation |
| gbasin/figma-to-react | Pixel-perfect Figma → React conversion |
| ui-ux-pro-max-skill | Searchable design intelligence database |
| timescale/pg-aiguide | PostgreSQL best practices + live docs |
| supabase/agent-skills | PostgreSQL performance patterns |
| trailofbits/skills | Professional security audit skills |
| AgentSecOps/SecOpsAgentKit | 25+ security tools (Semgrep, ZAP, etc.) |
| ahmedasmar/devops-claude-skills | DevOps: Terraform, K8s, CI/CD, cost optimization |
| addyosmani/web-quality-skills | Core Web Vitals, Lighthouse, a11y, SEO |
| GSD v1 | Project management inside Claude Code |

---

## THE ONE RULE

**When in doubt, run `/where-am-i`.** It reads your project state, quality score, and git history. It tells you exactly where you are and exactly what to do next. Takes 10 seconds.
