# Factory Lacunae Ledger

Standing assignment (2026-06-10): while EventState is built, every gap,
friction point, or design flaw observed in the 5-phase factory or the wider
playbook gets logged HERE — at the moment it's observed, not at retro time.
The orchestrator (Claude) appends during sessions; `/morning-review`
friction and shakedown findings land here too. Items graduate: fixed →
moved to the Fixed section with the commit; promoted → becomes a DEC or a
t0 rule.

Severity: BLOCKER (factory cannot run) · DEFECT (wrong behavior) ·
GAP (missing capability) · DEBT (works, but fragile) · QUESTION (unvalidated).

## Open

| # | Sev | Area | Lacuna | Found | Proposed fix |
|---|-----|------|--------|-------|--------------|
| L-002 | DEBT | judge.sh T1 | Never executed against a real Node project; test invocation assumes vitest CLI semantics (`npm run test:run -- <file> -t <name>`). Jest/playwright-only projects untested. | 2026-06-10 | Validate during EventState shakedown; make JUDGE_TEST_CMD project-customizable in scaffold step (it is env-overridable — document in scaffold) |
| L-003 | GAP | VPS ops | Mobbin MCP headless: transport authed (✓ Connected) but tool call triggers app-level OAuth with localhost callback — headless runs can't complete it; interactive token didn't carry to `claude -p`. Observed live. | 2026-06-10 VPS test | VPS claude updated to 2.1.170 (2026-06-10); remaining: one interactive /mcp re-auth on the new version + headless retest. Mobbin work runs on laptop meanwhile (DEC-032) |
| L-004 | DEBT | VPS sizing | clawdbot has 7.5GB RAM (16GB research floor). MITIGATED 2026-06-10: 8GB swap added (swappiness 10, persistent) — sufficient for supervised/serial runs. CAX31 rescale was unavailable (ARM capacity sold out at location). | 2026-06-10 | Before heavy parallel/overnight phases: retry CAX31 rescale (capacity fluctuates) or snapshot→new CAX31 in another location; then raise MemoryMax 5G→12G in ralph.service |
| L-006 | DEBT | qa.sh dual-account | Failover design assumes two Codex accounts; VPS has one. Long runs will hit the 5h window with no fallback — loop sleeps 5 min and retries (single-account path), burning wall-clock budget. | 2026-06-10 | Either add acc2 on VPS or tune BOTH_EXHAUSTED_SLEEP for single-account reality |
| L-007 | GAP | gh-state | Stories appended later (completeness loop) get no GitHub issue until someone re-runs `gh-state.sh init`. run.sh never calls init. | 2026-06-10 design review | run.sh: call `gh-state.sh init` (idempotent) after pull, not just at scaffold time |
| L-008 | DEBT | heartbeat | Only build.sh and qa.sh write `ralph/.heartbeat`; harden/quorum/drift phases run dark — Witness would mis-read a long harden phase as STALLED. | 2026-06-10 design review | Add heartbeat writes to harden.sh + review-quorum.sh batch loop, or Witness exempts phases per cursor |
| L-009 | QUESTION | git flow | Factory commits straight to the target repo branch (Ralph style). Research consensus prefers small PRs for reviewability; current design has no PR lane, so /morning-review reads commits, not diffs-with-discussion. Intentional? | 2026-06-10 | Decide: keep direct-commit (fast, Ralph-pure) vs per-story branch+PR (reviewable, slower). Candidate DEC |
| L-010 | QUESTION | spec-runner | extract-pathways says spec-runner generates Playwright from pathways.json — but the existing spec-runner skill predates pathways and reads census specs only. Integration unimplemented. | 2026-06-10 | Update spec-runner skill to prefer pathways.json when present (census remains fallback) |
| L-012 | GAP | escalation | ESCALATE parks and notifies, but there is no approval-with-timeout lane (ESCALATE.md semantics from DEC-009 item 3 were partially implemented: park+notify yes, timed approval window no). Acceptable for now — founder reviews via morning-review. | 2026-06-10 | Revisit if parked-story latency becomes the bottleneck |
| L-013 | DEBT | vendor | Vendored Pocock skills predate his 2026-04-28 reorg: qa, design-an-interface, ubiquitous-language (folded into grill-with-docs), request-refactor-plan are deprecated upstream; github-triage renamed/reworked. Prune/upgrade pass needed (prototype replaces design-an-interface; watch his in-progress `review` skill — spec-faithfulness lens for our T2). | 2026-06-10 research | Prune after EventState ships; do not churn mid-project |

## Fixed

| # | Lacuna | Fixed by |
|---|--------|----------|
| L-001 | qa.sh refused to run with single `~/.codex` login (clawdbot reality) | qa.sh single-account fallback, fixed same day |
| L-014 | DEC counter race: two concurrent sessions (design-extract + pathways compile) both claimed DEC-076..081 — newer commands lacked grill-me's lock protocol and allocated at session start | scripts/next-dec.sh (atomic, shares grill-me's .planning/.dec-lock mutex, race-tested 6-way) + allocate-at-WRITE-time convention swept into 6 command files, same day |
| L-005 | Factory templates had no path to the VPS | build_playbook pushed to GitHub (made PRIVATE — it had been public since May 31), cloned to ~/build_playbook on clawdbot, PLAYBOOK_ROOT exported, judge.sh verified present |
| L-011 | claude version skew (VPS 2.1.97 vs laptop) | VPS updated to 2.1.170, /usr/local/bin symlink repointed; per-run version preflight still worth adding to run.sh later |

## Promotion rules

- A lacuna observed twice in real runs is no longer a note — it gets fixed or becomes a DEC before the next run.
- BLOCKERs stop the factory until fixed; nothing else does.
- This file is reviewed at every `/morning-review` (factory-health section) and before every scaffold of a new project.
