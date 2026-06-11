# Build Method + Grill Quorum — Playbook Doctrine

**Date:** 2026-06-11
**Status:** RATIFIED (founder, laptop orchestrator session)
**Scope:** PLAYBOOK-level doctrine — applies to every factory project.
First instantiation: EventState DEC-102..104
(`test_Gica/.planning/decisions/2026-06-11-build-method-design-gates-vertical-slices.md`).
This doc generalizes those project DECs plus the grill-agent-assignment
discussion into permanent factory rules.

**Evidence base:** GEM India done-specs (transport: 100% tested actions,
0% built UI — unit-tested ≠ shipped), oracle-ceiling lacuna L-016,
DEC-076..081 counter race, Codex adversarial passes that corrected every
EventState WOW-DELTA.

---

## DEC-010 — Design is a per-module gate inside the build pipeline

Two rejected extremes, one ratified pipeline:

- **Free-run REJECTED:** coding agents inventing layout at code time is
  design decision-leak — the mechanism behind GEM India's module poverty.
- **Whole-app upfront design REJECTED:** designing before the wow-grills
  ratify scope produces wireframes of rejected features and a second
  oracle that drifts. Waterfall design rots like waterfall specs.

**RATIFIED — every module passes these gates in order before its story
contracts freeze:**

1. Wow-grill ratifies scope (V1-CORE / POLISH / V2 / REJECTED DECs)
2. Wireframe the module's 3–7 anatomy-defining screens (Pencil).
   Pathways govern states; excellence cards + tokens + design.md govern
   everything not wireframed.
3. Design quorum — independent taste judge (Gemini lane) reviews before
   the wireframes bind.
4. Export PNGs + one-page written layout spec per screen; commit both.
   **The exports + spec are the binding artifacts.** Encrypted working
   files (.pen) are unreadable by headless/VPS agents and are never truth.
5. Story contracts cite the exports by path like any frozen reference;
   build loop + design judge verify against them.

Per-module sequence: grill → DECs → pathway addenda → wireframes →
design quorum → contract freeze → code.

**Pending machinery:** `/wireframe-module` command to mechanize gates
2–4 — drafted after the first EventState module passes through by hand,
so the command is shaped by a real module (same promote-once-proven rule
as L-016).

## DEC-011 — Vertical slices; auth-first walking skeleton; JIT platform

- **"Modules first, auth wrapped last" REJECTED and blocked.** In
  multi-tenant apps auth is load-bearing in every query (tenant scoping
  inside each query, session-derived org context in every server action).
  Retrofit = rewriting every data path on Tier-1 code.
- **Horizontal layering REJECTED** on done-spec evidence: a layer can
  complete while the slice never ships.

**RATIFIED build order for every factory project:**

1. **Walking skeleton first** (supervised, `hitl:true`, Tier-1): auth +
   tenant model + ONE thin end-to-end slice, deployed. Proves the spine.
2. **Module-by-module vertical slices** in dependency order; each slice =
   schema + actions + UI + Playwright pathways, judged as one unit.
   UI-level evidence required for DONE — action-layer evidence alone
   never closes a story (escapes-ledger rule, now doctrine).
3. **Just-in-time platform:** cross-cutting infrastructure is built once,
   when the first vertical slice needs it — never as an upfront
   horizontal phase.
4. **Ratchet the spine immediately:** when the skeleton merges, promote
   its core invariant (e.g., no db query without tenant scope) to a
   deterministic T0 rule so every later module inherits it for free.

## DEC-012 — Author/auditor separation extends to SCOPE decisions (grill quorum)

The review-quorum principle (DEC-003/009) applied one layer up: **never
let the same intelligence be both author and auditor of a scope
decision.** Three binding rules:

1. **Harvesters never ratify their own harvest.** The agent that spent a
   session advocating candidates is the prosecution, not the judge. Grills
   run in fresh sessions reading the committed artifacts — if a fresh
   session lacks context the harvester had, that is an artifact defect to
   fix, not a reason to grill inside the harvester's session.
2. **Grill seats:** Claude authors (interviewer + scribe — the grill
   protocol, dump consumption, atomic DEC allocation, and ledger
   discipline live in Claude-native command machinery); **Codex audits**:
   after each module's grill, the verdicts go through a read-only
   `codex exec` break-these-DECs pass — which acceptances rest on no card
   evidence, which V2 deferral leaves a V1 pathway dangling, which DEC
   contradicts a prior one, what the founder waved through unchallenged.
   Codex findings return to the FOUNDER, never to the authoring agent to
   self-adjudicate. Disagreement escalates; it never auto-resolves.
   (This deploys L-015's `/break-my-claim` pattern at the grill layer,
   earlier than its roadmap slot.)
3. **Parallel-agent retirement protocol:** before closing any parallel
   work session (cmux terminal, worktree agent), everything that lives
   only in its chat — open questions, founder answers, judgment calls —
   must be flushed into the committed artifact (or a `/handoff` doc).
   Anything not in an artifact dies with the terminal. Centralized grills
   depend on this.

---

**Deferred by the promote-once-proven rule:** THE-PLAYBOOK.md phase docs
get the design-gate and vertical-slice phases written in after EventState
validates them end-to-end (same deferral L-016 already records for the
three-track doctrine).
