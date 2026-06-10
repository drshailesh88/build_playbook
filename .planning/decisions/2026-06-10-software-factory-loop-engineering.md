# Planning Session: Software Factory — Loop Engineering Upgrade
**Date:** 2026-06-10
**Source:** Claude Code (Fable 5) interactive planning session
**Status:** captured
**Decision range:** DEC-001 to DEC-007

## Context

The Build Playbook is a strong command collection but produces "maybe it
will produce something" outcomes on AFK runs. The founder wants an
enterprise-grade software factory: high-quality, robust software built
mostly AFK on a Tailscale-connected VPS running builder Claude plus
reviewers Grok and Codex.

Inputs to this session:
- Deep-research doc on loop engineering (Steinberger/Cherny "design loops
  that prompt your agents", Ralph Wiggum loop, /goal mechanics,
  maker-checker, feedback-substrate-first staging, Gas Town).
- Prior Supermemory decisions, reaffirmed (not re-litigated): judge ladder
  T0/T1/T2 with ratchet rule, three-store state architecture, model
  routing policy (Opus default builder / Sonnet low-risk / Fable reserved
  for catastrophic blast radius), two-layer independent review,
  never-interrupt-a-running-loop policy.

Gap analysis: the design (in memory) is ahead of the implementation (in
repo). Judge today is a single Codex pass; loop state is local files;
Grok appears nowhere in the repo; story contracts are not frozen.

## Decisions

#### DEC-001: Steal /goal mechanics; do not use /goal for factory runs
- **Question:** Adopt Anthropic's /goal command as the factory loop, or extract its lessons into the bash-loop backbone?
- **Options Considered:**
  1. Use /goal directly — built-in Worker/Judge, but loops inside one context window
  2. Steal mechanics into fresh-context bash loop — more work, no compaction degradation
- **Selected:** Steal mechanics. Three specifically: (a) frozen externalized success contract written before the worker starts, immutable during the run; (b) deterministic checks injected to a command-less judge via hooks; (c) first-class circuit breakers (turn limits, max-continues, completion sentinels).
- **Rationale:** /goal degrades on long AFK runs through context compaction. Fresh-context-per-story keeps each iteration inside one clean window (HumanLayer: "carve off small bits of work into independent context windows").
- **Rejected:** Running /goal as the primary factory loop. Kept for interactive single-story debugging via existing /ralph-goal.
- **Dependencies:** None
- **Status:** DECIDED
- **Confidence:** HIGH
- **Reversibility:** EASY
- **Scope-Risk:** SYSTEM
- **Counterargument:** If Anthropic ships /goal with fresh-context-per-attempt or robust compaction, the built-in judge plumbing may beat maintained bash. Evidence that would change this: a /goal release note adding external state + fresh-context restarts.
- **Valid Until:** indefinite
- **Consequences:**
  - Enables: AFK runs of arbitrary length; external circuit breakers; full logging
  - Constrains: We maintain our own judge plumbing instead of using Anthropic's
  - Rollback plan: Swap loop entrypoint to /goal per story; contracts already in goal-condition format

#### DEC-002: Orchestrator loop runs on the VPS
- **Question:** Where does the factory's outer loop physically run?
- **Options Considered:**
  1. VPS (systemd/tmux) — survives laptop sleep, true AFK
  2. Laptop driving VPS over SSH — easier early debugging, dies on lid close
  3. Both (laptop dev, VPS prod) — cleanest but more setup
- **Selected:** VPS. Laptop becomes a monitoring/approval surface over Tailscale.
- **Rationale:** True AFK requires the loop to outlive the laptop session.
- **Rejected:** Laptop-hosted loop (not AFK); dual-host (premature).
- **Dependencies:** None
- **Status:** DECIDED
- **Confidence:** HIGH
- **Reversibility:** EASY
- **Scope-Risk:** MODULE
- **Counterargument:** VPS debugging friction could slow early iteration; mitigate by developing scripts locally and deploying via git.
- **Valid Until:** indefinite
- **Consequences:**
  - Enables: overnight/multi-day runs, phone monitoring via Tailscale
  - Constrains: secrets and CLIs (claude, codex, grok, gh) must be provisioned on the VPS
  - Rollback plan: scripts are host-agnostic; run anywhere with the CLIs

#### DEC-003: Grok and Codex are independent parallel reviewers
- **Question:** What role does Grok play next to Codex in the review layer?
- **Options Considered:**
  1. Independent parallel reviewers, different lenses
  2. Tie-breaker only when builder and Codex disagree — cheaper, loses diversity
  3. Red-team only (harden phase) — keeps in-loop review fast
- **Selected:** Independent parallel reviewers with distinct lenses: Codex = correctness/security; Grok = spec-completeness + decision-trace audit. Reviewer disagreement escalates to founder; never auto-merge on conflict. If only one reviewer is available, Codex is the trusted primary (founder trusts Codex on par with Opus).
- **Rationale:** Diverse lenses catch failure modes redundant reviews miss; two-layer independent review is already a standing memory decision.
- **Rejected:** Tie-breaker (loses per-story diversity); red-team-only (leaves single-reviewer in-loop gap).
- **Dependencies:** DEC-004 (verdicts consumed by judge ladder)
- **Status:** DECIDED
- **Confidence:** HIGH
- **Reversibility:** EASY
- **Scope-Risk:** MODULE
- **Counterargument:** Double review cost per story; if Grok's signal-to-noise proves low, demote it to red-team lane.
- **Valid Until:** indefinite
- **Consequences:**
  - Enables: cross-vendor blind-spot coverage; decision-leak detection at review time
  - Constrains: every story pays two review invocations
  - Rollback plan: env flag to disable the Grok lane; Codex-only remains fully functional

#### DEC-004: Build order — judge ladder first
- **Question:** Which factory phase gets built first?
- **Options Considered:**
  1. Phase 1: T0/T1/T2 judge ladder + frozen contracts
  2. Phase 3 first: GitHub-as-source-of-truth state
  3. Phase 2 first: Grok quorum
- **Selected:** Phase order: (1) judge ladder + frozen contracts → (2) Grok+Codex quorum → (3) GitHub state migration (issues=plan/status, PR comments=verdict trail, cursor in pinned tracking-issue body, VPS .loop/ scratchpad) → (4) ops hardening (token budget hard caps, heartbeat/dead-man's-switch, /morning-review) → (5) mechanized ratchet (/promote-finding).
- **Rationale:** Every phase depends on trustworthy verdicts. Verification, not generation, is the bottleneck.
- **Rejected:** State-first (auditable garbage is still garbage); quorum-first (reviews without a deterministic floor inherit LLM-judge noise).
- **Dependencies:** None
- **Status:** DECIDED
- **Confidence:** HIGH
- **Reversibility:** MODERATE
- **Scope-Risk:** SYSTEM
- **Counterargument:** If crash recovery pain dominates before judge quality pain, Phase 3 should jump the queue.
- **Valid Until:** 2027-06-10
- **Consequences:**
  - Enables: each later phase consumes structured verdicts from day one
  - Constrains: until Phase 3, state remains file-based and host-local
  - Rollback plan: phases are additive; order can change between phases

#### DEC-005: Frozen story contracts (hash-verified)
- **Question:** How do we prevent the builder from renegotiating "done" mid-run?
- **Options Considered:**
  1. Per-story contract file written before build, sha256-hashed, judge verifies hash
  2. Trust acceptance criteria embedded in prd.json behavior field (status quo)
- **Selected:** Contract files generated from prd.json before the loop starts; sha256 recorded in a manifest; judge fails any story whose contract hash changed during the run.
- **Rationale:** /goal's deepest lesson — the success condition is a contract the worker cannot edit. This is the execution-time anti-decision-leak mechanism.
- **Rejected:** Status quo (nothing structurally stops drift mid-run).
- **Dependencies:** DEC-001
- **Status:** DECIDED
- **Confidence:** HIGH
- **Reversibility:** EASY
- **Scope-Risk:** MODULE
- **Counterargument:** Legitimate contract fixes (typo in a test name) require a human-signed re-freeze step; adds friction.
- **Valid Until:** indefinite
- **Consequences:**
  - Enables: immutable "done"; auditable diff between promised and delivered
  - Constrains: contract changes mid-run require explicit human re-freeze
  - Rollback plan: judge flag to skip hash verification

#### DEC-006: Decision firewall in execution
- **Question:** How do we catch architectural decisions invented by the builder mid-story that trace to no DEC record?
- **Options Considered:**
  1. Reviewer lens: Grok audits the diff for novel architectural choices vs the decision index and story scope
  2. Hook-based static detection (hard to express "novel decision" deterministically)
- **Selected:** Grok's review lens includes a decision-trace audit: new dependencies, schema changes, auth/infra choices, or cross-module patterns not traceable to a DEC or the story contract get flagged ESCALATE.
- **Rationale:** Planning capture is already strong (DEC-NNN, compiler-not-interviewer PRD); the leak happens at execution time and is semantic — an LLM lens fits, with ratchet promotion to deterministic checks when patterns recur.
- **Rejected:** Pure hook detection (the category isn't grep-able yet; promote recurring instances per the ratchet rule).
- **Dependencies:** DEC-003
- **Status:** DECIDED
- **Confidence:** MEDIUM
- **Reversibility:** EASY
- **Scope-Risk:** MODULE
- **Counterargument:** May over-flag routine implementation choices; tune the lens prompt with an allowlist of "implementation detail" categories.
- **Valid Until:** 2026-12-10
- **Consequences:**
  - Enables: decisions stay in the ledger; builders implement, founders decide (Ethos #3)
  - Constrains: some escalations will be false positives early
  - Rollback plan: drop the lens section from the Grok review prompt

#### DEC-007: No multi-agent fan-out orchestration (Gas Town) at this stage
- **Question:** Should the factory orchestrate many parallel builder agents?
- **Options Considered:**
  1. Adopt Gas Town / Gas City style fan-out now
  2. Stay single-builder-pipeline with parallel reviewers
- **Selected:** Stay single-builder pipeline. Revisit only when comfortably running 5+ parallel agents AND merge-queue coordination — not generation — is the bottleneck.
- **Rationale:** Verification is the current bottleneck; fan-out multiplies unverified output and token spend (reported ~$100/hr at 12–30 agents).
- **Rejected:** Fan-out now.
- **Dependencies:** None
- **Status:** REJECTED (the fan-out option; single-pipeline DECIDED)
- **Confidence:** HIGH
- **Reversibility:** EASY
- **Scope-Risk:** SYSTEM
- **Counterargument:** If story throughput (not quality) becomes the complaint after Phases 1–4, parallel worktree lanes are the natural next step.
- **Valid Until:** 2026-12-10
- **Consequences:**
  - Enables: focus on verification quality; bounded token spend
  - Constrains: throughput capped at one builder lane
  - Rollback plan: N/A (nothing built to undo)

## Open Questions

- [ ] Exact Grok CLI invocation + auth on the VPS (binary name, non-interactive flags, output format) — verify on the VPS before Phase 2.
- [ ] Is mutation score a hard T1 gate or a guard-only metric initially? (Leaning guard-only until Stryker runtime cost per story is measured.)
- [ ] Which repo hosts the pinned tracking issue for Phase 3 (target app repo vs a dedicated factory-ops repo)?

## Constraints & Requirements

- Never run Tier 1 modules (auth, payments, data) unattended — standing autoresearch rule, unchanged.
- Reviewer disagreement escalates to founder; never auto-merge on conflict (Ethos #3, User Sovereignty).
- Never interrupt an ongoing run to apply a policy change; apply forward to the next run (standing memory rule).
- Judge must be deterministic-first: T2 LLM-judge only evaluates what T0/T1 cannot decide.
- Every recurring T2 finding gets promoted to a deterministic T0/T1 check (ratchet rule).

## Next Steps

- Build Phase 1 in this repo: `judge.sh` ladder (T0 invariants → T1 tests/tsc/lint/mutation-guard → T2 independent-context LLM judge), contract freezer + hash manifest, wiring into the Ralph scaffold templates.
- Then Phase 2: Grok reviewer lane beside Codex in qa/review loops, distinct lens prompts, escalation path.
- Save session learnings to Supermemory after implementation.

## Raw Notes

Planning session 2026-06-10 (Claude Code, Fable 5) — "Build Playbook → Software Factory" upgrade. Founder request: evolve playbook into a software factory producing high-quality robust software mostly AFK; steal lessons from /goal without using it; VPS connected via Tailscale runs builder Claude and reviewers Grok + Codex; grind harder in planning and capture planning without decision leak in long discussions or during execution; move from "maybe it will produce something" to enterprise-grade.

Assessment delivered: design (in Supermemory) is ~3 months ahead of implementation (in repo). Six gaps: (1) judge ladder decided but not implemented — QA today is one Codex pass; (2) GitHub-as-source-of-truth state decided but loop state is local files; (3) Grok in zero files; (4) /ralph-goal generates goal conditions but bash loops don't consume them and nothing enforces immutability; (5) no decision firewall at execution time; (6) factory ops partial — webhooks and stuck counters exist, no budget caps, heartbeat, or morning review.

/goal lessons identified: frozen success contract; command-less judge fed by deterministic Stop-hook evidence; circuit breakers as first-class. /goal weakness for this use case: single-context-window looping degrades via compaction.

Founder answers to decision questions: loop host = VPS; Grok role = "grok and codex both independent reviewers. if 1 reviewer - codex - i trust and love it as much as opus"; start = Phase 1 judge ladder.
