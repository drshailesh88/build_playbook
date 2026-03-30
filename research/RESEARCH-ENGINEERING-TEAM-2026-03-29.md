# Engineering Team — Complete Research
## All 10 Engineers: What Exists, What to Build

---

## 1. SECURITY ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **trailofbits/skills** | Professional security firm's skills. Audit context building, variant analysis, differential review, constant-time analysis, firebase scanner. THE gold standard. | High — Trail of Bits is industry-leading |
| **agamm/claude-code-owasp** | OWASP Top 10:2025, ASVS 5.0, agentic AI security, 20+ language-specific security quirks. Auto-activates on security questions. | Focused, well-maintained |
| **AgentSecOps/SecOpsAgentKit** | 25+ skills: SAST (Semgrep, Bandit), DAST (ZAP, Nuclei, ffuf), container scanning (Trivy, Grype), secret detection (TruffleHog, Gitleaks), compliance frameworks. | Comprehensive — the full toolkit |
| **Eyadkelleh/awesome-claude-skills-security** | Pentest advisor, CTF assistant, bug bounty hunter, XSS/SQLi testing, API key scanning, LLM security testing. Curated SecLists payloads. | Offensive security focus |
| **prompt-security/clawsec** | Drift detection, automated audits, skill integrity verification. | Security-first plugin |
| **mukul975/Anthropic-Cybersecurity-Skills** | 753 cybersecurity skills across 38 domains: cloud, pentesting, red teaming, DFIR, malware, threat intel. MITRE ATT&CK mapped. | Massive but review quality |

### Built-In
- Claude Code has `/security-review` command built-in (checks SQL injection, XSS, auth flaws, insecure data handling, dependency vulnerabilities)
- GitHub Actions integration for automated PR security review

### What to Fork
- **trailofbits/skills** — professional quality, security-focused
- **AgentSecOps/SecOpsAgentKit** — comprehensive toolkit with real tools (Semgrep, ZAP, Trivy)
- **agamm/claude-code-owasp** — OWASP-specific, auto-activating

### What to Build Custom
- `/security-audit` — orchestrator that runs secret scanning + dependency check + OWASP audit + API security check in sequence, produces a single report
- Security rules in CLAUDE.md (CSP headers, input sanitization, never expose keys)

---

## 2. PERFORMANCE ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **addyosmani/web-quality-skills** | BY ADDY OSMANI (Google Chrome team). Core Web Vitals (LCP, INP, CLS), Lighthouse integration, accessibility, SEO, best practices. Framework-agnostic. | Gold standard — from THE web performance expert |
| **garrytan/benchmark** | Performance engineer skill: baseline page load times, Core Web Vitals, resource sizes. Part of Garry Tan's (Y Combinator CEO) skill set. | High quality |
| **cloudflare/web-perf** | Audit Core Web Vitals and render-blocking resources. From Cloudflare's official skills. | Production-tested |
| **vercel-labs/agent-skills** (web-design-guidelines) | 100+ rules covering accessibility, performance, UX. Includes proper ARIA, focus states, touch targets, reduced-motion, semantic HTML. | Quality gate skill |
| **secondsky/web-performance-optimization** | Code splitting, tree-shaking, bundle analysis, lazy loading, service workers, caching, Core Web Vitals monitoring. | Comprehensive |

### What to Fork
- **addyosmani/web-quality-skills** — THE authority on web performance
- **vercel-labs/agent-skills** — web design guidelines as quality gate
- **cloudflare/web-perf** — from your hosting provider

### What to Build Custom
- `/perf-audit` — runs Lighthouse, checks bundle size, measures Core Web Vitals, reports scores with fix suggestions
- `/perf-budget` — set performance budgets (max bundle size, max LCP, max INP) that get checked on every build

---

## 3. DEVOPS / INFRASTRUCTURE ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **ahmedasmar/devops-claude-skills** | Terraform, Kubernetes troubleshooter, AWS cost optimization, CI/CD (GitHub Actions, GitLab CI), GitOps workflows, monitoring/observability. With automated analysis scripts. | Purpose-built for DevOps |
| **akin-ozer/cc-devops-skills** | 31 skills: Ansible, Docker, Kubernetes, Terraform, Helm, GitHub Actions, GitLab CI, Jenkins, Azure Pipelines, Bash. Generator + validator pairs. | Practical, well-structured |
| **rand/cc-polymath** | 200+ skills total. DevOps section: Docker (5), Kubernetes (5), CI/CD (4), Cloud AWS (7), Cloud GCP (6), Cloudflare Workers, Observability (8). | Massive, high quality |
| **saadnvd1/cc-deploy** | One-command deployment: `/deploy`. Auto-detects project type, picks platform (Vercel/Railway), handles auth, deploys. | Simple but effective |
| **mrgoonie/claudekit-skills** | DevOps covering Cloudflare (Workers, R2, D1, KV, Pages), Docker, GCP (Compute Engine, GKE, Cloud Run). | Cloudflare-focused (relevant for you) |
| **wshobson/agents** | kubernetes-operations plugin (4 deployment skills), cloud-infrastructure plugin (AWS/Azure/GCP, 4 cloud skills). | Part of larger system |

### Built-In
- Claude Code GitHub Actions (official) — automated PR review, issue-to-PR, docs updates
- Claude Code supports Docker containers, sandboxed environments

### What to Fork
- **ahmedasmar/devops-claude-skills** — most relevant (Terraform, K8s, CI/CD, cost optimization)
- **akin-ozer/cc-devops-skills** — generator + validator pattern is smart
- **saadnvd1/cc-deploy** — one-command deploy

### What to Build Custom
- `/setup-infra` — interview about hosting needs, then generate Dockerfile, docker-compose, CI/CD pipeline, environment configs
- `/deploy-check` — pre-deployment checklist (env vars set, migrations run, tests pass, security review done)

---

## 4. API ARCHITECT

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **rand/cc-polymath** | API Design section: REST, GraphQL, auth, rate limiting, versioning (7 skills). | Comprehensive |
| **wshobson/agents** | backend-architect agent + api-design-principles skill + fastapi-templates. | Part of larger ecosystem |
| **jezweb/claude-skills** | Stripe payments (checkout, subscriptions, webhooks, billing portal). | Payment-specific |
| Claude Code Best Practices | Built-in api-conventions skill example: kebab-case URLs, camelCase JSON, pagination, API versioning (/v1/, /v2/). | Official pattern |

### What to Build Custom
- `/api-design` — reads data-requirements.md and db-architect output, designs consistent API routes with: input validation schemas (Zod), error response format, rate limiting rules, pagination patterns, versioning strategy
- `/api-review` — audits existing API routes for consistency, missing validation, exposed internal data, missing rate limits

---

## 5. ACCESSIBILITY ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **Community-Access/accessibility-agents** | 11 specialist agents enforcing WCAG 2.2 AA. Covers: cognitive SC, React Native, color contrast, link patterns, document accessibility, desktop a11y. Audit scoring, delta tracking, compliance export (VPAT/ACR). | THE most comprehensive a11y toolkit found |
| **mastepanoski/claude-skills** | Nielsen heuristics, WCAG audit, Don Norman principles. Already in your design repos. | UX + a11y combined |
| **addyosmani/web-quality-skills** | Includes accessibility skill following WCAG 2.2. | Part of web quality suite |
| **vercel-labs/agent-skills** | Web interface guidelines with ARIA, focus states, labeled inputs, touch targets, reduced-motion, keyboard nav. | Quality gate |
| **ehmo/platform-design-skills** | 300+ rules from Apple HIG, Material Design 3, WCAG 2.2. | Cross-platform |
| **ramzesenok/iOS-Accessibility-Audit-Skill** | iOS-specific a11y audit. | Mobile-focused |

### What to Fork
- **Community-Access/accessibility-agents** — 11 specialist agents, most thorough
- **addyosmani/web-quality-skills** — Addy Osmani's a11y skill (doubles as perf)

### What to Build Custom
- `/a11y-audit` — runs axe-core via Playwright on running app, checks WCAG 2.2 AA, produces prioritized fix list
- Accessibility rules in CLAUDE.md (semantic HTML always, ARIA only when needed, keyboard navigation mandatory)

---

## 6. ERROR / RESILIENCE ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **garrytan/careful** | Safety guardrails: warns before destructive commands (rm -rf, DROP TABLE, force-push). | Prevention |
| **rand/cc-polymath** | Observability section: logging, metrics, tracing, OpenTelemetry, incident response (8 skills). | Comprehensive |
| **ahmedasmar/devops-claude-skills** | monitoring-observability plugin. | Part of DevOps suite |
| **wshobson/agents** | incident-response plugin with smart-fix command, observability-engineer agent. | Enterprise-grade |
| **ComposioHQ/awesome-claude-skills** | Sentry Automation — automate Sentry: issues, events, projects, releases, alerts. | Error tracking integration |

### What to Build Custom
- `/resilience-review` — checks every API call for error handling, every fetch for retry logic, every form for network failure graceful degradation, every long operation for timeout handling
- `/error-patterns` — skill with reference patterns: retry with exponential backoff, circuit breaker, optimistic UI with rollback, offline queue, error boundaries

---

## 7. RELEASE MANAGER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **kelp /release** | Manages releases: changelogs, README review, version increment evaluation. | Focused |
| **garrytan/document-release** | Technical writer: update all project docs to match what you just shipped. | Post-release docs |
| **garrytan/autoplan** | One command, fully reviewed plan: runs CEO → design → eng review automatically. | Planning automation |
| Claude Code GitHub Actions | Official: automated PR review, issue-to-PR, docs updates on push. | Built-in |

### What to Build Custom
- `/release-prep` — pre-release checklist: all tests pass, security review done, performance budget met, a11y audit clean, changelog updated, version bumped, migration tested
- `/feature-flag` — skill for implementing feature flags (ship code without enabling for all users, staged rollouts)

---

## 8. COST / BUDGET ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **ahmedasmar/devops-claude-skills** | aws-cost-optimization plugin: find unused resources, analyze Reserved Instances, detect cost anomalies, rightsize instances, evaluate Spot, detect anomalies. 6 automated analysis scripts. | AWS-specific but patterns are universal |
| **deanpeters/finance-metrics-quickref** | Reference guide for 32+ SaaS finance metrics with formulas and benchmarks. | Strategic, not operational |

### What to Build Custom
- `/cost-track` — monitors AI API usage per feature, estimates monthly cost, alerts when spending exceeds budget
- `/cost-review` — audits code for expensive patterns: unnecessary API calls, unoptimized queries, missing caching, oversized payloads

---

## 9. DOCUMENTATION ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **garrytan/document-release** | Auto-update docs when code changes. | Release-triggered |
| Claude Code GitHub Actions | Docs update workflow: detects src/ changes, auto-updates corresponding docs. | Built-in pattern |
| **google-labs-code/design-md** | Create and manage DESIGN.md files. | Design docs |
| Your existing `/generate-feature-doc` | Already built — generates feature docs from GSD + code. | Custom |

### What to Build Custom
- `/doc-architecture` — generates/updates ARCHITECTURE.md from codebase analysis (modules, dependencies, data flow)
- `/doc-api` — generates API documentation from route files + Zod schemas
- Already mostly covered by your feature-census + generate-feature-doc pipeline

---

## 10. SEO / GROWTH ENGINEER

### Best Repos Found

| Repo | What It Does | Stars/Quality |
|------|-------------|---------------|
| **addyosmani/web-quality-skills** | SEO skill: meta tags, structured data, sitemap, keyword optimization. | Part of web quality suite |
| **AgriciDaniel/claude-seo** | Universal SEO skill for comprehensive website analysis and optimization. | SEO-focused |
| Your existing content-marketing skills | Already have social-media-trends-research, content-marketing-social-listening. | Custom |

### What to Build Custom
- `/seo-audit` — checks meta tags, Open Graph, structured data (schema.org), sitemap, page speed, social preview cards
- Lower priority than the other 8 engineers

---

## REPOS TO ADD TO YOUR MASTER REPO

### Tier 1 — Fork These (Critical)

| # | Repo | Engineer | Install Command |
|---|------|----------|----------------|
| 1 | **trailofbits/skills** | Security | `claude plugin marketplace add trailofbits/skills` |
| 2 | **AgentSecOps/SecOpsAgentKit** | Security | `claude plugin marketplace add AgentSecOps/SecOpsAgentKit` |
| 3 | **agamm/claude-code-owasp** | Security | Copy to `.claude/skills/owasp-security/` |
| 4 | **addyosmani/web-quality-skills** | Performance + A11y + SEO | `npx add-skill addyosmani/web-quality-skills` |
| 5 | **Community-Access/accessibility-agents** | Accessibility | Copy agents to `.claude/agents/` |
| 6 | **ahmedasmar/devops-claude-skills** | DevOps + Cost | `claude plugin marketplace add ahmedasmar/devops-claude-skills` |
| 7 | **akin-ozer/cc-devops-skills** | DevOps | `claude plugin marketplace add akin-ozer/cc-devops-skills` |

### Tier 2 — Fork These (Valuable)

| # | Repo | Engineer | Why |
|---|------|----------|-----|
| 8 | **rand/cc-polymath** | Multi (API, Observability, Cloud) | 200+ skills. Cherry-pick: API design, observability, cloud sections |
| 9 | **saadnvd1/cc-deploy** | DevOps | One-command deploy. Simple, effective. |
| 10 | **garrytan skills** (benchmark, careful, document-release) | Performance, Safety, Docs | Y Combinator CEO's personal toolkit |
| 11 | **vercel-labs/agent-skills** | A11y + Quality | Web interface guidelines as quality gate |

### Tier 3 — Bookmark (Reference Only)

| Repo | Why Bookmark |
|------|-------------|
| wshobson/agents | Massive. Already extracted database patterns. Cherry-pick incident-response and observability if needed. |
| mrgoonie/claudekit-skills | Cloudflare-specific DevOps. Useful if staying on Cloudflare. |
| Eyadkelleh/awesome-claude-skills-security | Offensive security. Only if you need pentest/CTF. |
| mukul975/Anthropic-Cybersecurity-Skills | 753 skills. Too massive to fork whole. |

---

## CUSTOM COMMANDS/SKILLS TO BUILD

These don't exist in any repo and need to be built custom for your workflow:

| # | Command | Engineer Role | What It Does |
|---|---------|--------------|-------------|
| 1 | `/security-audit` | Security | Orchestrates: secret scan → dependency check → OWASP audit → API security → report |
| 2 | `/perf-audit` | Performance | Runs Lighthouse, checks bundle size, Core Web Vitals, produces scores + fixes |
| 3 | `/setup-infra` | DevOps | Interviews about hosting, generates Dockerfile, CI/CD, env configs |
| 4 | `/deploy-check` | DevOps | Pre-deployment checklist (env vars, migrations, tests, security) |
| 5 | `/api-design` | API Architect | Reads data-requirements + db schema, designs consistent API routes |
| 6 | `/api-review` | API Architect | Audits existing routes for consistency, validation, rate limits |
| 7 | `/a11y-audit` | Accessibility | Runs axe-core via Playwright, WCAG 2.2 AA check, prioritized fixes |
| 8 | `/resilience-review` | Error/Resilience | Checks error handling, retry logic, graceful degradation |
| 9 | `/release-prep` | Release Manager | Pre-release checklist: tests, security, perf, a11y, changelog, version |
| 10 | `/cost-track` | Cost/Budget | Monitors AI API usage, estimates monthly cost, budget alerts |

---

## UPDATED MASTER REPO TOTALS

| Category | Custom Built | Vendor Repos | Plugins/MCPs |
|----------|:-:|:-:|:-:|
| Planning & Workflow | 6 commands + 1 skill | 2 repos | 1 |
| Competition & Research | 1 command | — | — |
| UX/UI Design | 2 commands + 1 reference | 5 repos | 4 |
| Database | 1 command + 1 skill (4 refs) | 2 repos | 2 |
| Testing & QA | 4 commands + 1 skill (1 ref) | — | 1 |
| Security | 1 command (to build) | 3 repos | 2 |
| Performance | 2 commands (to build) | 3 repos | 1 |
| DevOps/Infrastructure | 2 commands (to build) | 3 repos | 1 |
| API Architecture | 2 commands (to build) | 1 repo | — |
| Accessibility | 1 command (to build) | 2 repos | — |
| Error/Resilience | 1 command (to build) | 1 repo | — |
| Release Management | 1 command (to build) | 1 repo | — |
| Cost/Budget | 1 command (to build) | 1 repo | — |
| **TOTAL** | **25 commands + 4 skills** | **20 repos** | **12 installs** |
