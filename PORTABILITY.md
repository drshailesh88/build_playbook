# PORTABILITY — One Methodology, Any Agent

The Build Playbook is vendor-neutral by design: durable state lives on disk
(`.planning/`, `.quality/`, `.gsd/`, git), never inside any vendor's session.
This document is the capability matrix — what works where, how to install,
and exactly what degrades on each runtime.

Verified June 2026 against: Claude Code, OpenAI Codex CLI, Cursor CLI
(`cursor-agent`), OpenCode, and xAI Grok Build (local user guide in
`~/.grok/docs/user-guide/`).

---

## Install

```bash
# Everything, for every CLI found on PATH
./install.sh --target all

# Or per vendor
./install.sh --target codex
./install.sh --target cursor,opencode,grok

# Then, ONCE PER PROJECT (rules for the non-Claude vendors):
./installers/init-project.sh /path/to/project
```

`init-project.sh` merges the compiled rules into `<project>/AGENTS.md` between
`BUILD-PLAYBOOK` markers — idempotent, preserves your own content. Every
vendor (including Claude Code via Cursor/Grok-style compat or its own
CLAUDE.md import) reads project-root AGENTS.md.

## Where Things Land

| Asset | Claude Code | Codex | Cursor | OpenCode | Grok |
|---|---|---|---|---|---|
| Rules (always-on) | `~/.claude/rules/` | `~/.codex/AGENTS.md` | per-project `AGENTS.md` only¹ | `~/.config/opencode/AGENTS.md` | `~/.grok/AGENTS.md` |
| Commands (56) | `~/.claude/commands/playbook/` → `/playbook:<name>` | skills → `$playbook-<name>` | skills → `/playbook-<name>` | `~/.config/opencode/commands/` → `/playbook-<name>` | skills → `/playbook-<name>` |
| Skills | `~/.claude/skills/` | `~/.agents/skills/` | `~/.agents/skills/` | `~/.agents/skills/` | `~/.grok/skills/`² |
| Hooks (10) | `settings.json` → scripts | `~/.codex/hooks.json` → scripts directly³ | `~/.cursor/hooks.json` → `cursor-shim.sh`⁴ | `plugins/buildplaybook.js`⁵ | `~/.grok/hooks/buildplaybook.json` → `grok-shim.sh`⁶ |
| Subagents (7) | `~/.claude/agents/*.md` | `~/.codex/agents/*.toml` (generated) | `~/.cursor/agents/*.md` | `~/.config/opencode/agents/*.md` (mode: subagent) | `~/.grok/agents/*.md` |
| Headless driver | `claude -p --dangerously-skip-permissions` | `codex exec --full-auto` | `cursor-agent -p --force` | `opencode run` | `grok --always-approve -p` |

¹ Cursor has no documented on-disk global rules location — run
  `init-project.sh` per project, or paste rules once into Cursor Settings → Rules.
² Grok does NOT scan `~/.agents/skills/`; it gets its own copy. It DOES scan
  `~/.claude/skills/` and `~/.cursor/skills/` for compat.
³ Codex speaks the Claude hook protocol natively (same events, same stdin
  fields, `Edit|Write` aliases `apply_patch`). One degradation: it honors
  `permissionDecision` allow/deny only — our "ask" gates become advisory
  warnings instead of approval dialogs. Exit-2 blocking works identically.
⁴ Cursor uses camelCase events and `permission`/`user_message` response
  fields; the shim translates both directions. Exit-2 blocking preserved.
⁵ OpenCode has no shell hooks — a JS plugin bridges `tool.execute.before/after`
  and session events to the canonical scripts. "ask" decisions block with a
  message telling the agent to confirm with the user first (a plugin cannot
  open an approval dialog).
⁶ Grok hooks are FAIL-OPEN: a crashed hook never blocks; only explicit
  `{"decision":"deny"}` JSON blocks — which the shim emits for both deny and
  ask (ask becomes deny + "confirm with the user, then retry"). Grok also
  scans `~/.claude/settings.json` hooks and `~/.claude/skills/` by default;
  if you run both installs, duplicates are harmless (scripts self-dedup via
  state markers) or silence them with `[compat.claude] hooks = false` in
  `~/.grok/config.toml`.

## Ralph On Any Vendor

`adapters/headless/run-agent.sh` (installed to `~/.buildplaybook/bin/` and
shipped inside `ralph/` by `/scaffold-ralph`) is the single interface:

```bash
run-agent.sh -v codex -m gpt-5.4-codex "Build exactly ONE feature..."
run-agent.sh -v grok "Read .planning/STATE.md and report where we are"
```

- Claude's `@file` prompt references are rewritten for other vendors into an
  explicit "read these files first" instruction.
- Claude model ids are dropped (with a warning) when targeting other vendors
  so their CLI default applies. Pass vendor-correct ids via `-m`.
- `BP_CODEX_UNSAFE=1` switches Codex from `--full-auto` (sandboxed,
  no network) to full bypass — needed when a loop must `npm install`.

The Ralph **build loop** honors it natively:

```bash
RALPH_AGENT=codex RALPH_BUILD_MODEL=gpt-5.4-codex ./ralph/build.sh
RALPH_AGENT=grok ./ralph/build.sh          # vendor default model
./ralph/build.sh                           # unchanged: Claude Opus
```

Other loops (`qa.sh`, `harden*.sh`) stay pinned to their proven
Claude/Codex pairing for now — the adversarial value comes from MIXING
vendors, and `qa.sh` carries Codex dual-account failover logic. To swap any
of them, replace the `claude -p`/`codex exec` line with a
`./ralph/run-agent.sh -v "$VENDOR"` call — same pattern as `build.sh:143`.

## Phase-By-Phase Capability

| Playbook phase | Claude | Codex | Cursor | OpenCode | Grok |
|---|---|---|---|---|---|
| 1. Capture & research (grills, compete-research, thought-dump) | full | full | full | full | **full — Grok's strong zone** |
| 2. PRD compile (write-a-prd, coverage-audit) | full | full | full | full | full |
| 3. Architecture (data/infra grills, db/infra-architect) | full | full | full | full | full |
| 4. UX/UI briefs | full | full | full | full | full |
| 5. Build loops (Ralph, sprint, adversarial) | full | full (build or attack side) | full | full | supervised only — see below |
| 6. QA harness + hardening | full | full | full | full | supervised only |
| 7. Ship/review/security | full | full | full | full | full for review; gate merges elsewhere |

**Grok stance (June 2026):** planning-stage work (phases 1–4) is fully
trusted — grills, PRDs, research, briefs are file-writing conversations where
the disk artifacts are reviewable. For build/QA phases the machinery is
installed and works, but treat unattended runs as not yet earned: Grok's
hooks fail-open (a crashed safety hook blocks nothing) and `--always-approve`
plus allow/deny rules are newer and less battle-tested than Claude's
permission system or Codex's OS sandbox. Re-evaluate as Grok matures — the
adapter is ready the day you are.

## What Does NOT Port (Claude-only)

- **Claude plugins** (frontend-design, pg-aiguide, trailofbits skills
  installed via `claude plugin add`) — other vendors have their own
  marketplaces; the playbook does not depend on any of these to function.
- **Agent teams / Workflow orchestration / `/code-review ultra`** — Claude
  Code harness features. Equivalent: run more loop iterations or use the
  adversarial cross-vendor skills, which need only two CLIs and bash.
- **GSD harness integration** — `.gsd/` state files are plain markdown and
  readable everywhere, but the `/gsd:*` command suite is installed for
  Claude; on other vendors, read/write the state files per THE-PLAYBOOK.md.
- **Hook "ask" dialogs** — only Claude can pause for user approval from a
  hook. Codex degrades to warnings; OpenCode/Grok degrade to block-with-
  retry-after-confirmation. Cursor preserves ask via its `permission` field.

## Keeping It In Sync

The repo is the single source of truth. After editing rules/, commands/,
skills/, agents/, or hooks/, rerun:

```bash
./install.sh --target all
```

Reinstalls are idempotent: marker-merged AGENTS.md blocks are replaced in
place, skills/agents are overwritten, your own content is never touched.
