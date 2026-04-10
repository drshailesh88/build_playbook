# Oracle Contamination and GAN-Inspired Testing

How to stop AI agents from cheating on tests, and how GAN architecture solves it.

---

## The Problem: Oracle Contamination

When the same agent writes code AND tests, the tests become a mirror of the code — not an independent check. The agent reads the source, writes assertions that match what the code does, and reports 100% pass rate. This is called **oracle contamination**: the implementation contaminates the test oracle.

> "A single agent that plans, builds, and evaluates its own work will reliably praise its own mediocre output." — [Anthropic Engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)

### Three ways agents cheat:
1. **Tautological tests** — reads source code, asserts exactly what the code does
2. **Mock everything** — database mocked, auth mocked, tests prove mocks work, not the app
3. **DOM-only assertions** — "clicked Save and saw success toast" instead of "clicked Save, got 200, row updated, revision incremented, draft appears after reload"

### The proof: Mutation Testing
- AI-reported **93.1% test coverage**
- Stryker mutation testing revealed actual quality: **58.62% mutation score**
- 34-point gap = bugs that tests would never catch

---

## The Fix: Architectural Separation (Not Better Prompting)

### The Four Things That Must Be Separated
1. **Specification** — what should the code do?
2. **Implementation** — the code itself
3. **Oracle creation** — who decides what "correct" means?
4. **Verification** — did it work?

The current harden flow blends 2, 3, and 4 into one agent. That's the root cause.

---

## How GAN Architecture Solves This

### The GAN Analogy

In a real GAN:
- **Generator** creates outputs (images, text)
- **Discriminator** tries to distinguish real from fake
- They compete — the generator gets better because the discriminator keeps catching its fakes

In software quality:
- **Builder agent** writes code
- **Adversary agent** tries to BREAK the code
- They compete — the code gets better because the adversary keeps finding bugs

> "A generator that evaluates its own work converges on mediocrity. A separate evaluator with the explicit mandate to find failures creates the adversarial pressure that forces quality upward." — Anthropic

### Cole Medin's Adversarial Dev

Three-agent architecture:
- **Planner** — converts user prompt into spec with sprint contracts
- **Generator** — builds features, commits after each
- **Evaluator** — runs the app, probes for failures, scores each criterion 1-10

Key design choices:
- Evaluator's job is explicitly to BREAK things, not approve them
- Sprint contracts define "done" BEFORE implementation (frozen oracle)
- JSON contracts prevent manipulation (structured > markdown)
- File-based communication — no shared context window
- Max 3 retries per sprint before hard stop
- Pass threshold: 7/10 on every criterion

### How This Applies to Testing

| Single-Agent Testing | GAN-Inspired Testing |
|---------------------|---------------------|
| Builder writes tests for its own code | Adversary writes tests to break builder's code |
| Tests match implementation | Tests challenge implementation |
| 100% pass = success | 100% pass = suspicion |
| Coverage is the metric | Mutation score is the metric |
| One context window | Separate context windows |
| Agent is defendant AND judge | Agent is defendant, separate agent is judge |

---

## The Three-Layer Defense Against Cheating

### Layer 1: Frozen Oracle (Pre-Build)
Before implementation, create a **Contract Pack**:

```
contracts/<feature>/
  examples.md           — what should happen
  counterexamples.md    — what should NOT happen
  invariants.md         — what must always be true
  acceptance.spec.ts    — frozen Playwright tests
  api-contract.json     — API shape
```

The builder agent gets this pack. The builder CANNOT edit it.

Rule: **Pre-build tests come from spec. Post-build tests can come from census.**

### Layer 2: Role Isolation (During Build)

**Builder agent:**
- Can read spec
- Can write app code
- CANNOT see or edit frozen acceptance tests
- Uses `.claudeignore` to block test directories

**Tester/adversary agent:**
- Can read spec and product artifacts
- Writes tests against the RUNNING APPLICATION (real browser)
- CANNOT read the source code
- Uses `"deny": ["Read(../src/**)"]` in settings

**They share ONLY the running application.** This forces genuine black-box testing.

### Layer 3: Mutation Testing (Post-Build)

Stryker introduces small mutations to your code:
- Flip `>` to `<`
- Remove a return statement
- Swap `true` for `false`

If tests still pass, the test is weak. **Mutation score** = percentage of mutations caught.

Benchmarks:
- Above 80% = excellent
- 60-80% = good
- Below 60% = tests are decorative

Tools by language:
| Language | Tool |
|----------|------|
| JavaScript/TypeScript | Stryker |
| Python | mutmut |
| Java/Kotlin | PIT |
| C#/.NET | Stryker.NET |
| Go | go-mutesting |
| Rust | cargo-mutants |
| Ruby | mutant |

---

## AutoResearch + GAN for QA: The Overnight Test Discovery Engine

Combine Karpathy's autoresearch loop with GAN-inspired agent separation:

### The Loop
```
for each iteration:
  1. Adversary agent generates a test scenario
     (edge case, attack path, unusual input, weird user journey)
  2. Runs it against the LIVE app (Playwright, real browser)
  3. Measures: 
     - Did we find a new bug? (bug yield)
     - Did mutation score improve? (test quality)
  4. If metric improved -> keep the test, commit
  5. If not -> discard
  6. Repeat all night
```

### Key Rules
- The **generator** (test writer) may be AI
- The **judge** (pass/fail, mutation score) must be external and deterministic
- The adversary CANNOT see source code — only the running app
- Builder agent fixes bugs found by the adversary, but CANNOT edit the adversary's tests
- Metric is **mutation score + bug yield**, not test pass rate

---

## The Anneal Problem and Fix

### Current Anneal (dangerous)
Agent diagnoses "code bug vs test bug" and can edit EITHER the code OR the test.
This lets the agent weaken assertions to make tests pass.

### Fixed Anneal (safe)
**Allowed:**
- Fix app code
- Fix brittle selectors (CSS changed)
- Fix timing/wait issues
- Quarantine flaky tests with explicit reason

**NOT allowed without separate approval:**
- Weakening assertions
- Deleting assertions
- Changing expected business behavior
- Rewriting the scenario itself
- Changing contract tests in the same task as code changes

Rule: **The test should not be easy to bargain with.**

---

## Test Stack That Resists Agent Cheating

| Test Type | What It Checks | Hard to Fake? |
|-----------|---------------|--------------|
| **Acceptance tests** (frozen, from spec) | Did we build the right thing? | Yes — agent can't edit them |
| **Property-based tests** (fast-check) | Invariants across many inputs | Yes — can't fake with narrow examples |
| **Mutation testing** (Stryker) | Do tests actually catch bugs? | Yes — objective measurement |
| **Differential tests** | Consistency under transformation | Yes — deterministic comparison |
| **Regression tests** (from real bugs) | Don't re-break what was fixed | Yes — grounded in reality |
| **Hidden E2E suite** (private repo) | Real user flows | Yes — agent can't see or overfit |

### Assertion Depth Rule for Playwright
Bad: "clicked Save and saw success toast"
Good: "clicked Save, got 200 from draft endpoint, row updated, revision count incremented, draft appears after reload"

Assert at least one of:
- Persisted DB state
- API side effect
- URL/state transition
- Downloaded artifact contents
- Accessibility state
- Domain output (not just UI chrome)

---

## Practical Implementation Path

| Phase | What | Cost |
|-------|------|------|
| 1 | Contract Pack before build (frozen acceptance tests from spec) | Free — workflow change |
| 2 | Role separation (`.claudeignore` + permission deny rules) | Free — config change |
| 3 | Stryker mutation gate on changed modules | One `npm install` |
| 4 | Hidden Playwright suite (private repo or CI-only) | Medium — infrastructure |
| 5 | AutoResearch QA loop (overnight test discovery) | Build the script |

---

## Key Sources

- [Anthropic — Harness Design for Long-Running Apps](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- [Cole Medin — Adversarial Dev](https://github.com/coleam00/adversarial-dev)
- [codecentric — Isolated Specification Testing with Claude Code](https://www.codecentric.de/en/knowledge-hub/blog/dont-let-your-ai-cheat-isolated-specification-testing-with-claude-code)
- [93% Coverage Was Actually 34%](https://dev.to/jghiringhelli/the-ai-reported-931-coverage-it-was-34-290k)
- [Stryker Mutator](https://stryker-mutator.io/)
- [fast-check Property-Based Testing](https://fast-check.dev/docs/introduction/what-is-property-based-testing/)
- [Karpathy AutoResearch](https://github.com/karpathy/autoresearch)
- [Anthropic — Demystifying Evals for AI Agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)
- [NIST — Cheating on AI Agent Evaluations](https://www.nist.gov/blogs/caisi-research-blog/cheating-ai-agent-evaluations)
- [Multi-Agent Systems for Software QA](https://arxiv.org/abs/2601.02454)
- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
