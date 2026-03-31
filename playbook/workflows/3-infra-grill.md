# Infrastructure Grill — Extract Every Hosting Decision From Your Brain

Interview you about everything your app needs to run in the real world — without using cloud jargon. No mention of Docker, Kubernetes, CDN, load balancers, or any infrastructure term. Just business questions about your users, your budget, and your expectations.

Input: $ARGUMENTS (path to PRD, or "interactive" to start fresh)

## Why This Exists

Your PRD says "a web app for academic writing." That hides 30 infrastructure decisions: How many people will use it at the same time? What happens if the server crashes at 2am? Do users upload files? How big? Do you need the app to work in India as fast as it works in the US? How much can you spend per month on hosting?

You know the answers. You've just never been asked.

**You will never see the words "container", "kubernetes", "CDN", "load balancer", "serverless", or "auto-scaling" during this interview. Those are the engineer's problem.**

## Process

### Step 1: Load Context

Read everything that describes what you're building:
- PRD or `.planning/decisions/`
- `.planning/data-requirements.md` (from data-grill)
- `.planning/ux-brief.md` (device priority tells us mobile vs desktop)
- `.planning/competition-research.md` (competitor infrastructure section)
- Existing code if any (package.json, framework detection)

### Step 2: Detect What Already Exists

If the project has code, detect the current stack:
```bash
# Framework
grep -l "next\|nuxt\|vite\|remix\|astro" package.json 2>/dev/null
# Database
grep -l "drizzle\|prisma\|mongoose\|supabase" package.json 2>/dev/null
# Auth
grep -l "clerk\|auth0\|next-auth\|supabase" package.json 2>/dev/null
# Hosting clues
ls -la vercel.json wrangler.toml netlify.toml fly.toml railway.json Dockerfile docker-compose.yml 2>/dev/null
```

Present findings:
> "I see your app uses Next.js with Drizzle ORM and Clerk auth. You currently have a wrangler.toml (Cloudflare) configuration. I'll ask questions with this in mind."

### Step 3: Present All Questions

All questions upfront. Group by section. Plain English only.

---

### SECTION A: Your Users

**A1. How many people use your app today?**
- None yet (pre-launch)
- Under 100 (early beta)
- 100-1,000 (growing)
- 1,000-10,000 (established)
- 10,000+ (scaling)

**A2. How many people do you expect in 6 months? In 2 years?**
Give your best guess. It's okay to be wrong — we can adjust later.

**A3. Where are your users located?**
- Mostly one country (which one?)
- One region (e.g., South Asia, Europe, North America)
- Worldwide (users everywhere)

This matters because an app serving users in India from a server in the US will feel slow.

**A4. When do your users use the app?**
- Business hours only (9-5 in one timezone)
- Spread across the day (students at all hours)
- Peaks at specific times (e.g., before paper deadlines)
- 24/7 constant (enterprise, global teams)

**A5. How many people might use the app AT THE SAME TIME during peak?**
Think about the busiest moment — a product launch, a deadline, an event.

---

### SECTION B: What the App Does

**B1. Does your app need to respond instantly, or is some waiting acceptable?**
- Instant (every click should feel immediate — like Google Search)
- Fast (1-2 seconds is fine for most actions — like Notion)
- Some waiting is okay (AI processing, report generation — users expect it)

**B2. Does your app handle file uploads?**
- No files
- Small files only (images, profile pictures — under 5MB)
- Medium files (PDFs, documents — up to 50MB)
- Large files (videos, datasets — over 100MB)

**B3. Does your app use AI features (calling OpenAI, Claude, etc.)?**
- No AI
- Light AI (occasional summarization, search)
- Heavy AI (real-time AI writing, chat, continuous processing)
- Critical AI (the entire product IS the AI feature)

If yes: How many AI calls per user per day, roughly?

**B4. Does your app send emails or notifications?**
- No
- Occasional (password resets, welcome emails)
- Regular (daily digests, notifications)
- Heavy (marketing campaigns, bulk emails)

**B5. Does your app need to work offline or with poor internet?**
- No — always requires internet
- Partially — should save work if connection drops
- Yes — core features should work offline

**B6. Does your app have scheduled tasks?**
Things that run automatically without a user clicking — like:
- "Send daily summary email at 8am"
- "Check for new papers every hour"
- "Clean up old temporary files weekly"

---

### SECTION C: Reliability and Trust

**C1. What happens if your app goes down for 1 hour?**
- Minor inconvenience (users can wait)
- Significant problem (users lose work or can't meet deadlines)
- Critical failure (users lose money, data, or trust permanently)

**C2. Can you afford downtime for updates?**
- Yes — a few minutes of downtime during updates is fine (off-peak)
- Ideally not — users should not notice updates happening
- Never — the app must never go down, even during updates

**C3. Has your app ever lost user data? How important is data safety?**
- Data is replaceable (settings, preferences)
- Data is important (documents, projects)
- Data is irreplaceable (research, years of work)
- Data is regulated (medical records, financial data, personal information)

**C4. Do you need to know when something breaks before users tell you?**
- No — users will report problems
- Yes — I want to get an alert when errors spike
- Absolutely — I want to know within 5 minutes if anything is wrong

---

### SECTION D: Money

**D1. What can you spend per month on hosting and infrastructure?**
- Free tier only ($0 — just getting started)
- Starter ($5-25/month)
- Growth ($25-100/month)
- Scale ($100-500/month)
- Enterprise ($500+/month)

**D2. How do you want to pay — fixed monthly cost or pay-per-use?**
- Fixed (predictable bills, even if I sometimes overpay)
- Pay-per-use (cheaper when quiet, could spike during busy periods)
- Hybrid (fixed base + pay-per-use for spikes)

**D3. Is there a platform you're already paying for?**
- Vercel (free or paid)
- Cloudflare (free or paid)
- AWS / Google Cloud / Azure
- Railway / Render / Fly.io
- Supabase / Neon / PlanetScale
- None — starting fresh

---

### SECTION E: Growth and Future

**E1. Do you plan to have a mobile app (native, not just responsive web)?**
- No — web only
- Maybe later (1-2 years)
- Yes — soon (within 6 months)

**E2. Will you ever need a public API (other apps connecting to yours)?**
- No
- Maybe (for integrations)
- Yes (it's part of the product)

**E3. Do you plan to sell to institutions (universities, hospitals, companies)?**
If yes, they often require:
- Data to stay in a specific country
- Security certifications
- Dedicated infrastructure (not shared with other customers)
- Single sign-on (SSO) with their systems

**E4. Do you plan to have multiple environments?**
- Just production (what users see) is enough for now
- Production + a staging/test environment
- Production + staging + development environments

**E5. Who deploys updates to the app?**
- Just me (solo founder)
- Me and an AI agent (Claude Code, Codex)
- A small team (2-5 people)
- Automated (push code → app updates automatically)

---

### SECTION F: Existing Constraints

**F1. Are you locked into any platform right now?**
For example: "My database is on Neon and I don't want to migrate" or "I bought a Vercel Pro plan."

**F2. Is there anything about your current setup that frustrates you?**
- Slow deployments
- Confusing dashboards
- Unexpected bills
- Things breaking with no explanation
- Having to do too many manual steps

**F3. Is there anything a competitor does with their infrastructure that you admire?**
For example: "SciSpace loads instantly" or "Notion works offline" or "Linear deploys 50 times a day."

---

### Step 4: Follow-Up Cycle

Same as all other grilling sessions:
1. Read every answer
2. Ask follow-ups from answers
3. Follow-ups from follow-ups
4. Zero ambiguity remaining

<HARD-GATE>
Do NOT produce the infrastructure requirements document until every section has been addressed and all follow-up questions answered. The LLM makes ZERO infrastructure decisions on its own.
</HARD-GATE>

### Step 5: Produce the Infrastructure Requirements

Save to: `.planning/infra-requirements.md`

```markdown
# Infrastructure Requirements: [Project Name]
**Date:** [date]
**Source:** Infrastructure grilling session
**Status:** GRILLED — ready for infrastructure architect

## Users
- Current users: [count]
- Expected 6 months: [count]
- Expected 2 years: [count]
- Location: [geography]
- Peak concurrent: [estimate]
- Usage pattern: [business hours / spread / peaks / 24-7]

## App Characteristics
- Response time expectation: [instant / fast / some waiting]
- File uploads: [none / small / medium / large]
- AI usage: [none / light / heavy / critical]
  - AI calls per user per day: [estimate]
- Emails/notifications: [none / occasional / regular / heavy]
- Offline support needed: [no / partial / yes]
- Scheduled tasks: [list if any]

## Reliability
- Downtime tolerance: [minor / significant / critical]
- Update downtime: [acceptable / prefer not / never]
- Data sensitivity: [replaceable / important / irreplaceable / regulated]
- Monitoring need: [reactive / proactive / immediate]

## Budget
- Monthly budget: [range]
- Payment preference: [fixed / pay-per-use / hybrid]
- Existing platform commitments: [list]

## Future Growth
- Mobile app planned: [no / maybe / yes]
- Public API planned: [no / maybe / yes]
- Institutional sales: [no / maybe / yes]
  - Data residency requirements: [list countries if any]
  - Security certifications needed: [list if any]
- Environments needed: [production only / + staging / + dev]
- Deployment method: [solo / AI agent / team / automated]

## Existing Stack (auto-detected + confirmed)
- Framework: [detected]
- Database: [detected]
- Auth: [detected]
- Current hosting: [detected]

## Constraints
- Platform lock-ins: [list]
- Current frustrations: [list]
- Admired competitor infrastructure: [list]

## Open Questions
- [ ] [anything unresolved]
```

### Step 6: Commit and Handoff

```bash
git add .planning/infra-requirements.md
git commit -m "infra: capture infrastructure requirements from grilling session"
```

> "Infrastructure requirements captured. Your app serves [N] users in [geography] with [budget] budget.
>
> Next: Run `/infra-architect` — it will read this document and recommend the complete hosting setup. You won't need to make any cloud platform decisions yourself."

## Language Rules

<HARD-GATE>
Do NOT use these words during the interview:
- container, Docker, Kubernetes, pod, cluster, node
- CDN, edge, worker, serverless, lambda, function
- load balancer, reverse proxy, nginx, ingress
- auto-scaling, horizontal scaling, vertical scaling
- CI/CD, pipeline, workflow, deployment, artifact
- S3, R2, blob storage, object storage
- Redis, cache layer, memcached
- SSL, TLS, certificate, DNS, CNAME
- VPC, subnet, security group, firewall

Use these instead:
- "your app's home on the internet" instead of "server/hosting"
- "how fast does your app need to feel?" instead of "latency requirements"
- "what happens when lots of people come at once?" instead of "scaling strategy"
- "keeping copies of your data safe" instead of "backups and replication"
- "making your app available in different countries" instead of "multi-region deployment"
- "updating your app without users noticing" instead of "zero-downtime deployment"
- "knowing when something breaks" instead of "monitoring and alerting"
</HARD-GATE>
