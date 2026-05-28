# Build Playbook — Quick Start Card

Print this. Pin it. Open it when you sit down to build.

---

## Starting a NEW Project

```
1. /playbook:office-hours          ← deep interrogation (do this FIRST)
2. /playbook:compete-research      ← who else does this, what to steal
3. /playbook:ux-brief              ← UX interview
4. /playbook:ui-brief              ← visual language
5. /playbook:data-grill            ← database needs in plain English
6. /playbook:infra-grill           ← infrastructure needs in plain English
7. /write-a-prd                    ← create the PRD
8. /playbook:prd-to-gsd            ← convert PRD into build milestones
```

## Resuming Work (Every Session)

```
/playbook:where-am-i
```
That's it. It reads git state, learnings, and tells you what to do next.

## Building

```
Build with GSD auto, Aider, or manual coding.
Hooks fire AUTOMATICALLY on every edit:
  - GateGuard forces you to investigate before editing
  - Quality Gate runs typecheck after every change
  - Config Protection blocks weakening your linter
  - Careful Check warns before destructive commands
```

You don't have to remember to run anything. The hooks do it.

## After Building

```
/playbook:review            ← multi-specialist code review
/playbook:security-audit    ← OWASP security check
/playbook:harden            ← census → specs → test → heal
/playbook:investigate       ← if something's broken (root cause first!)
```

## Shipping

```
/playbook:ship              ← test → push → PR (automated)
/playbook:canary            ← monitor production after deploy
```

## Learning (The System Gets Smarter)

```
/playbook:learn             ← see what the system has learned
/playbook:learn search X    ← find past discoveries
/playbook:learn add         ← manually teach it something
```

Learnings are captured automatically at session end. Loaded automatically at session start.

---

## The 7 Layers (What Protects Your Code)

```
7. PHILOSOPHY    → Ethos: boil the lake, search before building
6. DIALOGUE      → Office-hours, grills, briefs extract the product from your head
5. PLANNING      → Specialist agents plan before you code
4. EXECUTION     → TDD, adversarial loops build the code
3. RUNTIME GUARDS → Hooks fire automatically on every edit
2. REVIEW        → Multi-specialist review catches what you missed
1. LEARNING      → Every session makes the next one better
```

## The 5 Principles (Memorize These)

1. **Boil the Lake** — 100%, not 90%. Every edge case. Every sad path.
2. **Search Before Building** — Check stdlib → check ecosystem → THEN build
3. **User Sovereignty** — AI recommends, you decide. Always.
4. **Evidence Over Assertion** — Run it. Read the output. THEN claim it works.
5. **Every Session Compounds** — Learnings persist. Session 50 > Session 1.

## The 6 Agents (They Work For You)

| Agent | When It Activates |
|-------|------------------|
| Planner | Feature spans 3+ files |
| Code Reviewer | Before any PR |
| Security Reviewer | Touches auth/payments/user data |
| TDD Guide | Starting any new feature |
| Build Error Resolver | Build/tests crash |
| Database Reviewer | Schema/migration changes |

You don't invoke them manually. The system delegates to them when needed.

## Where Things Live

```
~/.claude/rules/          ← 5 always-loaded rules (security, testing, etc.)
~/.claude/agents/         ← 6 specialist agents
~/.claude/skills/         ← 17 auto-triggered skills
~/.claude/commands/playbook/  ← 39 slash commands
~/.buildplaybook/hooks/   ← 6 automatic hook scripts
~/.buildplaybook/projects/    ← per-project learnings
```

## If You Modify the Playbook

```bash
cd ~/Build\ Playbook
# Edit files...
./install.sh              ← re-deploys everything
```

## Emergency Commands

```
/playbook:investigate     ← something's broken, find root cause
/playbook:learn search X  ← "have we seen this before?"
/playbook:where-am-i     ← "what was I doing?"
/playbook:commands        ← "what commands do I have?"
```
