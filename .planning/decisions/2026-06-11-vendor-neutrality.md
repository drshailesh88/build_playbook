# Vendor Neutrality — the methodology must survive any vendor

**Date:** 2026-06-11
**Status:** RATIFIED (founder, verbatim: "i want this methodology to be useful
with any agent. i dont want to be married to a vendor - any vendor for that
matter - thats why i wanted claude code parity with this playbook in other
agents too.")
**Scope:** PLAYBOOK doctrine, all projects.

## DEC-013 — The methodology lives in open artifacts; vendors are adapters

**The asset is never the agent.** The playbook's entire value must reside in
things no vendor owns:

- **markdown** (commands, doctrine, DEC ledgers, pathways, WOW-DELTAs,
  STATE.md) — readable by any model, any tool, any human
- **git** (state, provenance, distribution)
- **bash + POSIX tooling** (ralph loops, judges, sync scripts)
- **open conventions** (SKILL.md dirs, AGENTS.md, conventional commits)

Binding rules:

1. **No methodology content in vendor-proprietary features.** Nothing
   essential may exist only as a Claude Code hook config, a Cursor rule
   format, a Codex config, or any vendor's memory/cloud feature. Vendor
   features may ACCELERATE (hooks that auto-run a check) but the check
   itself must exist as a script/markdown any agent can execute.
2. **Vendor couplings are swappable adapters.** Any place a specific
   agent CLI or model id appears (ralph `claude -p`, judge T2 model,
   Gemini taste lane, Codex audit lane) must be env-var/config-driven
   with the vendor as the DEFAULT, never the assumption. The seats are
   doctrine (author/auditor separation, taste quorum); the occupants are
   configuration.
3. **Distribution is by sync, not by rewrite.** One source of truth
   (`commands/` in this repo), generated into each agent's native
   convention by `scripts/sync-playbook-commands.py`. Adding an agent =
   adding a target to the script, never forking content.
4. **Every project repo carries `AGENTS.md` at root** (the cross-vendor
   standard read by Codex, Grok, Cursor, OpenCode — template:
   `templates/AGENTS.md`). Claude Code's CLAUDE.md becomes a one-line
   import of it. The doctrine an agent needs to behave correctly in the
   repo must not depend on WHICH agent opened it.
5. **The acceptance test:** "If <current vendor> disappeared tomorrow,
   could another agent resume the factory from a git clone within a
   day?" Any 'no' is a lacuna.

**Known debt at ratification (tracked as L-018, fixed as adapter work,
not a mid-project rewrite):** 9 ralph templates hardcode the `claude` CLI
(builder + T2 judge invocations); ~9 commands reference `~/.claude/...`
paths for installed locations. Neither blocks another agent from READING
and following the protocols today — the debt is in the EXECUTION seats.

**What stays vendor-specific by design:** seat assignments (DEC-012 —
Claude authors, Codex audits, Gemini tastes) are deliberate diversity,
not lock-in: the point is independent perspectives, and any occupant can
be swapped without touching doctrine.
