# Planning Session: Factory Project #1 — App Rebuild Kickoff
**Date:** 2026-06-10
**Source:** Claude Code (Fable 5) interactive session
**Status:** captured
**Decision range:** DEC-010 to DEC-011

## Context

The factory (DEC-001..009) is implemented through all five phases and needs
its first real project. Founder proposed using an existing app — a Next.js +
Postgres SaaS currently mid-auth-migration with multiple unsolved bugs — as
the testing/hardening vehicle. Assessment: great hardening project, dangerous
first target if worked in place (Tier 1 auth mid-migration, brownfield vs
fresh-context premise, confounded shakedown variables).

## Decisions

#### DEC-010: Project #1 is a FRESH REBUILD with the old app as oracle
- **Question:** Work the existing mid-migration codebase, strangler-pattern it module by module, or rebuild fresh?
- **Options Considered:**
  1. Fresh rebuild — new repo; old app supplies census, pathways, and bug list; target auth implemented directly (no migration); data migration last, human-led
  2. Strangler hybrid — rebuild module-by-module behind existing routing
  3. Fix in place — factory works the existing bug list (advised against: Tier 1 mid-migration blast radius, brownfield breaks fresh-context premise)
- **Selected:** Fresh rebuild. The old app is treated as a competitor/oracle: `/feature-census` + `/compete-research` extract the capability surface, `/extract-pathways` derives behavior chains from it, and the unsolved-bug list compiles into must-NOT-reproduce sad-path criteria.
- **Rationale:** Ralph canon is greenfield-only (field report); a rebuild dissolves the auth-migration problem into a direct implementation of the target auth; bugs become acceptance criteria instead of work items.
- **Rejected:** In-place (vetoed as first project); strangler (slower, kept as fallback if rebuild scope balloons).
- **Status:** DECIDED · **Confidence:** HIGH · **Reversibility:** MODERATE · **Scope-Risk:** SYSTEM
- **Counterargument:** Rebuilds classically underestimate the long tail of implicit behavior. Mitigation: the census's 3-layer extraction (code, library enrichment, runtime crawl) exists precisely to surface implicit capabilities; completeness loop + drift audit net the rest.
- **Valid Until:** 2026-12-10
- **Consequences:**
  - Enables: factory operates in its designed (greenfield) regime; auth built once, correctly, supervised
  - Constrains: a cutover + data migration milestone at the end (human-led, Tier 1)
  - Rollback plan: old app keeps running untouched throughout; cutover is reversible until DNS/data move

#### DEC-011: No separate calibration run — straight into the rebuild, first run supervised
- **Question:** Run a throwaway Run 0 before the real project?
- **Selected:** No. The rebuild's first phase IS the calibration: story ordering puts boring Tier-3 modules (UI shell, utils, layout) first, so the earliest factory iterations carry minimal blast radius while exercising the full pipeline. First run is supervised (founder watching), not overnight. Auth stories run supervised per the standing Tier 1 rule regardless.
- **Rationale:** No throwaway work; Tier-3-first ordering gives calibration for free.
- **Status:** DECIDED · **Confidence:** MEDIUM · **Reversibility:** EASY · **Scope-Risk:** LOCAL
- **Counterargument:** Integration friction may burn tokens on real stories; accepted — first run is supervised so friction is caught live.
- **Valid Until:** indefinite

## Constraints & Requirements

- Stack confirmed: Next.js + Postgres SaaS — scaffold defaults (tsc, vitest, playwright, drizzle) fit as-is.
- Auth stories: supervised only (standing autoresearch Tier 1 rule). Factory builds everything else AFK after the supervised first run.
- Data migration: last milestone, human-led; credentials never enter a session (standing security rule).
- Old app remains untouched and running throughout the rebuild.

## Open Questions

- [ ] Which app (name, repo path — laptop or clawdbot, running instance URL for the census crawl)
- [ ] Where the bug list lives (GitHub issues / notes / memory)
- [ ] Target auth provider (what the abandoned migration was moving TO)
- [ ] New repo name + GitHub location (hosts the factory's story issues)

## Next Steps

1. Founder supplies the four pointers above.
2. `/compete-research` + `/feature-census` against the old app → capability surface.
3. `/grill-me` on the deltas: rebuild as-is vs fix design mistakes (each delta = a DEC).
4. Bug list → sad-path pathway criteria; `/ux-brief` reuse/refresh → `/extract-pathways`.
5. `/write-a-prd` → `/prd-to-ralph` → `/playbook:scaffold-ralph` in the new repo on clawdbot.
6. First supervised run (Tier-3 stories), then progressively AFK.
