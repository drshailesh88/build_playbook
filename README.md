# Build Playbook

An open-source system for building software with AI agents — from idea to shipped product. Works with Claude Code, Codex, GSD, Aider, or any future agent.

**Battle-tested through 12 rounds of adversarial review (Claude vs Codex). 39 bugs found and fixed.**

## The Problem

AI coding agents are powerful but chaotic. They build fast, break things, and have no quality gates. Running them overnight means waking up to either working software or a mess of broken commits.

## The Solution

A structured workflow that separates **thinking** (grilling, requirements, architecture) from **building** (autonomous loops with quality gates), with three ML-inspired safety mechanisms:

1. **Autoresearch (Karpathy)** — Test score must never decrease. Auto-revert if it does.
2. **Adversarial Review (GAN-inspired)** — Two different AI companies review each other's code. Claude builds, Codex attacks. Or vice versa. They can't collude.
3. **Annealing (Self-healing)** — When tests fail, diagnose and fix automatically, cooling down with each retry.

## How It Works

```
DAYTIME — Thinking (Claude Code or any AI):
  /playbook:compete-research     → know your competitors
  /playbook:ux-brief             → how should it feel
  /playbook:data-grill           → what data does it store
  /playbook:prd-to-gsd           → lock decisions into requirements

EVENING — Building (any agent):
  /playbook:sprint-build-perfect-v2    → build, test, perfect loop
  OR ./overnight-adversarial-v2.sh 75  → Codex overnight with quality gates
  OR ./sprint-loop-v2.sh               → fresh Claude sessions, zero context rot

MORNING — Review:
  /playbook:where-am-i           → what got built
  /playbook:harden               → test everything
  /playbook:security-audit       → check for vulnerabilities
```

## The .planning/ Folder — Universal Interface

Every thinking tool writes to `.planning/`. Every building tool reads from `.planning/`. Switch tools anytime — your planning artifacts are plain markdown.

```
ANY thinking tool           .planning/           ANY building tool
(Claude, ChatGPT,    →    ├── ux-brief.md    →  (Codex, Claude Code,
 any chatbot)              ├── data-reqs.md      Aider, GSD v2,
                           ├── REQUIREMENTS.md    any future agent)
                           └── STATE.md
```

## Build Methods

| Method | What | When |
|--------|------|------|
| `/sprint-build-perfect-v2` | Build + test + Codex review + perfect loop | Recommended daily driver |
| `/adversarial-claude-builds-v2` | Claude builds, Codex attacks + architect review | Highest quality |
| `/adversarial-codex-builds-v2` | Codex builds, Claude attacks | Save Claude tokens |
| `overnight-adversarial-v2.sh` | Terminal overnight loop with all safety gates | Unattended overnight |
| `sprint-loop-v2.sh` | Fresh Claude sessions in a loop | Zero context rot |

## V2 Safety Features (learned from 12 adversarial review rounds)

- **Structured JSON requirements** — no more sed regex failures on checkboxes
- **Git worktree isolation** — each iteration in a disposable worktree, zero-risk reverts
- **API rate limit auto-wait** — detects limits, waits up to 1 hour, resumes automatically
- **Mandatory two-pass review** — adversary (find bugs) + architect (check design)
- **Webhook notifications** — Slack/Telegram/Discord alerts on completion, errors, stuck items
- **Docker sandbox option** — `--docker` flag for safe unattended runs
- **Fail-closed test parsing** — unparseable test output = failure, not success
- **Portable** — works on macOS and Linux (no more BSD sed failures)
- **Cross-tool state sync** — JSON and markdown stay in sync for V1/V2 interop

## 24 Slash Commands

### Planning & Research
| Command | What |
|---------|------|
| `/playbook:capture-planning` | Save planning sessions to repo |
| `/playbook:compete-research` | Competition analysis + design inspiration |
| `/playbook:ux-brief` | UX interview — how should it feel |
| `/playbook:ui-brief` | Visual language — how should it look |
| `/playbook:data-grill` | Database requirements in plain English |
| `/playbook:infra-grill` | Infrastructure requirements in plain English |
| `/playbook:prd-to-gsd` | Bridge PRD to build milestone |

### Building (V1 + V2)
| Command | What |
|---------|------|
| `/playbook:sprint-build-perfect` | Build + test + perfect loop (V1) |
| `/playbook:sprint-build-perfect-v2` | + worktree isolation, Codex review, JSON status |
| `/playbook:adversarial-claude-builds` | Claude builds, Codex attacks (V1) |
| `/playbook:adversarial-claude-builds-v2` | + worktree, architect review |
| `/playbook:adversarial-codex-builds` | Codex builds, Claude attacks (V1) |
| `/playbook:adversarial-codex-builds-v2` | + worktree, architect review |

### Testing & Quality
| Command | What |
|---------|------|
| `/playbook:harden` | Full pipeline: census → specs → test → heal |
| `/playbook:anneal` | Self-healing test loop |
| `/playbook:security-audit` | 6-check OWASP security review |
| `/playbook:verify-with-codex` | Cross-model code review |

### Navigation
| Command | What |
|---------|------|
| `/playbook:where-am-i` | 10-second context resume |
| `/playbook:guide` | Full playbook walkthrough |
| `/playbook:commands` | Quick reference of all commands |

## Install

```bash
git clone https://github.com/your-username/build-playbook.git
cd build_playbook
./install.sh
```

Then in any project: `/playbook:where-am-i`

## No Vendor Lock-in

The playbook content (questions, workflows, rules) is agent-agnostic. The adapters are thin wrappers:

```
playbook/           ← portable content (works everywhere)
adapters/
├── claude-code/    ← slash commands + sprint loop
├── codex/          ← AGENTS.md + overnight scripts
├── aider/          ← budget overnight loop
└── gsd/            ← GSD v2 integration
```

Switch agents anytime. Your `.planning/` files are the handoff.

## Credits

Built by combining ideas from:
- [Geoffrey Huntley](https://ghuntley.com/) — Ralph Loop pattern
- [Matt Pocock](https://github.com/mattpocock) — Skills + TDD
- [Jesse Vincent](https://github.com/obra) — Verification gates
- [Andrej Karpathy](https://github.com/karpathy) — Autoresearch
- [snarktank/ralph](https://github.com/snarktank/ralph) — Structured prd.json
- [umputun/ralphex](https://github.com/umputun/ralphex) — Worktree isolation + multi-pass review
- [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code) — API limit detection

## License

MIT
