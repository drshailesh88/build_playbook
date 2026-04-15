# Wiring Claude Code Action + CodeRabbit + Composio — Grounded Research

**Date:** 2026-04-15
**Purpose:** Inspect the three repos and answer whether they compose into a coherent pipeline for a non-technical solo builder.

## 1. anthropics/claude-code-action

- **Triggers (verified in `action.yml`):** `issue_comment`, `pull_request_review_comment`, `issues` (opened/assigned/labeled), `pull_request_review` (submitted), and `workflow_run` (for CI auto-fix). Mode auto-detected from event.
- **Auth:** Anthropic API key, Claude Code OAuth token, or cloud providers (Bedrock / Vertex / Foundry via OIDC — no key needed).
- **Required workflow permissions:** `contents: write`, `pull-requests: write`, `id-token: write`, optionally `actions: read` for CI logs.
- **Key gotcha:** `@claude` mentions posted by the action **do not re-trigger workflows** (GitHub security). You cannot chain `@claude` comments recursively.
- **Fork safety:** the canonical `examples/ci-failure-auto-fix.yml` explicitly guards against running on forks.
- **Can:** push commits, open PRs, comment inline. **Cannot:** submit a formal PR review, approve a PR, or modify workflow files.
- **Cost:** Anthropic token pricing only. Typical PR review 100–200k tokens (~$0.60–$1.20 Sonnet); typical CI fix 50–150k tokens.
- Source: https://github.com/anthropics/claude-code-action

## 2. CodeRabbit

- **Status:** the OSS repo `coderabbitai/ai-pr-reviewer` is **in maintenance mode** and explicitly redirects to the Pro (SaaS) product.
- **Install model:** GitHub App via coderabbit.ai (OAuth). The OSS Action model is legacy.
- **Output:** PR summary + release-notes-style diff + per-commit incremental inline review + in-comment chat.
- **Config:** `.coderabbit.yaml` in the repo.
- **Pricing (verifiable):** free for open source. Private-repo pricing is not in the OSS repo; redirects to SaaS — my research agent could not cite a specific number.
- **Cannot:** create branches, commit fixes, approve PRs.
- Source: https://github.com/coderabbitai/ai-pr-reviewer, https://coderabbit.ai
- **Important caveat:** I can't independently verify current Pro pricing or feature diff vs legacy from public repos alone. Worth checking coderabbit.ai directly before committing.

## 3. ComposioHQ/composio

- **What it actually is:** an **SDK** (Python + TypeScript) that connects agent frameworks (LangChain, LangGraph, OpenAI Agents, Claude Agent SDK, CrewAI, Autogen, Gemini) to ~150 external tools (GitHub, Slack, Gmail, Jira, etc.).
- **"Agent Orchestrator" is marketing.** There is no dedicated `AgentOrchestrator` repo. Orchestration happens via whichever framework you plug in (LangGraph being the common example in the repo).
- **GitHub toolkit:** 50+ actions — create/update/merge PRs, comment, manage issues, branches, list workflows. All OAuth.
- **Integration shape:** you write a Python or TS script, call `ComposioToolSet`, deploy somewhere (local box, CI job, or a server). It is **not** a GitHub Action — you'd invoke it from a workflow step.
- **Multi-agent dispatch:** there is no native built-in multi-agent dispatcher. You compose it yourself in LangGraph or similar.
- **Non-technical feasibility:** low. Requires writing + hosting orchestration code + managing OAuth tokens + framework choice.
- **Public CI examples composing Composio + claude-code-action + CodeRabbit:** none found.
- Source: https://github.com/ComposioHQ/composio

## 4. Proposed Composition (if all three were used)

```
Ralph + Stryker (build loop, pre-CI) → push PR branch
   │
   ▼
PR opened / synchronized
   │
   ├─ CodeRabbit (GitHub App, auto)   → summary + inline advisory comments
   │
   └─ CI (lint / typecheck / tests / security)
        │
        └─ on failure (workflow_run):
             Claude Code Action CI auto-fix → commits to PR branch
                │
                └─ (optional) Composio orchestration layer
                   could run a LangGraph flow: Reviewer agent
                   reads CodeRabbit + CI output, Fixer agent acts.
                   But this is build-it-yourself, not plug-and-play.
```

### Division of labor that actually works
- **CodeRabbit** — always-on PR reviewer (summary + inline). Never touches code.
- **Claude Code Action** — on-demand fixer (`@claude` mentions + `workflow_run` auto-fix). Pushes commits.
- **Composio** — only meaningful if you want multi-agent coordination beyond Claude (e.g. Codex + Claude + a custom agent), or want to route the same events into Slack/Jira/Linear. Otherwise it adds a Python/TS surface you don't need.

## 5. Overlaps & Conflicts

| Concern | Reality |
|---|---|
| Both CodeRabbit and claude-code-action can comment on PRs | Noise risk. Mitigate by scoping Claude to `@claude` mentions only, letting CodeRabbit auto-run. |
| Both can review security/style | Duplicate findings. Accept duplication or turn off one dimension in Claude's prompt. |
| Recursive `@claude` loops | Not possible — GitHub blocks Action-posted comments from re-triggering workflows. Good safety, but means you can't chain fixes via comments alone. |
| Fork PRs | claude-code-action's official example guards against fork execution; CodeRabbit App inherits GitHub App sandboxing. |
| Token budget | Each tool bills separately. Claude-Action per-PR ~$0.60–1.20 Sonnet. CodeRabbit SaaS subscription. Composio adds your chosen agent framework's API bill on top. |
| Secrets surface | Each tool wants its own auth. claude-code-action needs Anthropic key or OIDC. CodeRabbit is App OAuth. Composio needs a Composio API key + whatever framework keys. |

## 6. Honest Minimum for a Solo Non-Technical Builder

**Pick two, not three.**

**CodeRabbit (reviewer) + Claude Code Action (fixer).** This gives you:
- Always-on second pair of eyes on every PR (CodeRabbit)
- On-demand code surgery + CI auto-fix (Claude Code Action)
- No hand-written orchestration code
- No extra infra to host

**Skip Composio** unless/until you specifically need cross-vendor agent coordination (Codex + Claude + Gemini voting on the same PR, or piping review results into Slack/Linear through a scripted flow). For a solo builder whose build loop is already Ralph, Composio's value proposition is pointed at teams running fleets of agents, not individuals.

## 7. Could Not Verify
- CodeRabbit Pro pricing tiers / private-repo free allowance (closed SaaS pages).
- Actual count of public repos that run claude-code-action + CodeRabbit together (requires authed code search).
- Any production repo that wires all three. None surfaced in the research.
- Whether Composio's Claude Agent SDK provider is stable enough for CI use (repo exists, but no test of reliability at scale).

## References
- https://github.com/anthropics/claude-code-action
- https://github.com/anthropics/claude-code-action/blob/main/action.yml
- https://github.com/anthropics/claude-code-action/tree/main/examples
- https://github.com/coderabbitai/ai-pr-reviewer
- https://coderabbit.ai
- https://github.com/ComposioHQ/composio
- https://github.com/ComposioHQ/composio/tree/main/python/providers/claude_agent_sdk
- https://github.com/ComposioHQ/composio/tree/main/python/providers/langgraph
