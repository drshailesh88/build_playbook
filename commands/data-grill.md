# Data Grill — Extract Every Data Decision From Your Brain

Read your PRD and project plans, then interview you about every piece of data your app will ever touch. No database jargon. No technical language. Just business questions in plain English that expose every data decision hiding inside your product vision.

**Every decision gets a unique DEC-NNN ID and structured record. These feed into `/write-a-prd` which compiles them — not re-asks them.**

Input: $ARGUMENTS (path to PRD file, GSD requirements file, or "latest" for most recent .planning/ files)

## Why This Exists

Your PRD says "users can create projects." That one sentence hides 15 database decisions: Can a project belong to multiple users? Can deleted projects come back? Is there a limit per user? What happens to a project when a user deletes their account? Do projects have versions? Can projects be shared publicly?

You know the answers to all of these questions — you just haven't been asked yet. This command asks every single one, in language you understand, and writes down your answers so a database engineer can build exactly what you described.

**You will never see the words "normalization", "foreign key", "index", or "schema" during this grilling. Those are the engineer's problem, not yours.**

## Process

### Step 0: Load Decision Context and Atomic Counter

Before anything, check existing decision artifacts:
```bash
ls .planning/decision-index.md 2>/dev/null
ls .planning/CONTEXT.md 2>/dev/null
ls .planning/grill-log.md 2>/dev/null
cat .planning/next-dec-id 2>/dev/null
```

**DEC ID allocation:** Read `.planning/next-dec-id` for the next ID to
assign. After each decision, increment the counter immediately. **Allocate at WRITE time, never at session start** — parallel sessions race the counter (observed live 2026-06-10: two sessions both claimed DEC-076..081). Use the atomic helper when available: `<playbook>/scripts/next-dec.sh [count]` (mkdir-lock, prints the allocated id); otherwise read+increment the file in one step immediately before writing each record. If the
file doesn't exist, create it. **Never derive IDs by scanning grill-log
or decision-index** — parallel sessions would collide.

### Step 1: Load Your Plans

Read everything that describes what you're building:

- PRD (from $ARGUMENTS or latest in .planning/)
- GSD REQUIREMENTS.md (if exists)
- GSD ROADMAP.md (if exists)
- .planning/decisions/ files (if exist)
- .planning/grill-log.md (if exists — decisions already made)
- .planning/decision-index.md (if exists — to continue numbering)
- .planning/CONTEXT.md (if exists — glossary terms already defined)
- UBIQUITOUS_LANGUAGE.md (if exists)
- Feature census documents (if exist)
- Any competitive analysis or research docs

From these documents, extract every noun that represents something the app stores or manages. These are your **data subjects**. Examples: users, projects, documents, citations, papers, subscriptions, settings, search results, chat messages, notifications, files.

### Step 2: Present What You Found

Before grilling, show the user what you found:

> "I read your plans. Here's what I think your app stores and manages:
>
> **People:** users, teams/organizations
> **Content:** projects, documents, papers, citations
> **Activity:** searches, chat messages, notifications
> **System:** subscriptions, settings, usage tracking
>
> Am I missing anything? Are any of these wrong?"

Wait for confirmation. Add anything the user mentions. Remove anything that's wrong.

## Decision Record Format

Every resolved question becomes a DEC record with full metadata. The data grill produces some of the HIGHEST impact decisions (data model choices are often HARD to reverse), so metadata is critical.

```markdown
#### DEC-[NNN]: [Short title]
- **Question:** [The question asked]
- **Options Considered:**
  1. [Option A] — [tradeoff]
  2. [Option B] — [tradeoff]
- **Selected:** [What the user decided]
- **Rationale:** [Why, in the user's words]
- **Rejected:** [Alternatives not chosen, with reasons]
- **Dependencies:** [DEC-NNN] or "None"
- **Status:** DECIDED | DEFERRED | REJECTED
- **Confidence:** HIGH | MEDIUM | LOW
- **Reversibility:** EASY | MODERATE | HARD
- **Scope-Risk:** LOCAL | MODULE | SYSTEM
- **Counterargument:** [Strongest genuine attack on the selected option. What evidence would change this?]
- **Valid Until:** [YYYY-MM-DD — 6 months for HARD, 12 months for MODERATE, "indefinite" for EASY]
- **Consequences:**
  - Enables: [what this unlocks]
  - Constrains: [what this limits]
  - Rollback plan: [how to undo, or "N/A"]
- **Prediction:** [optional — "If this is right, we will see [observable] reach [threshold] by [verify_after date]." Required for HARD reversibility + LOW/MEDIUM confidence.]
- **Observation Indicators:** [optional — "[metric] — watch for [concern]." Metrics to WATCH but NOT optimize.]
```

**Data grill note:** Many data decisions are MODERATE or HARD to reverse (changing a data model after launch requires migrations, data backfills, and downstream API changes). Be especially vigilant about flagging LOW confidence + HARD reversibility combinations. Push the user to increase confidence on these.

## Superseding Prior Decisions

If a data decision contradicts or replaces a prior decision:
1. Create the new DEC record as normal
2. Add `Supersedes: DEC-[old ID]` to the new record
3. Update the old DEC's status to `SUPERSEDED by DEC-[new ID]` in the grill-log
4. Update the decision-index Superseded Decisions table

## The Save Rule

**NEVER rely on conversation context for decisions. ALWAYS write to disk.**

After EVERY 3-5 resolved questions:
1. Append the new DEC records to `.planning/grill-log.md` (under a "Data Grill" phase heading)
2. Update `.planning/decision-index.md` with the new rows (include Confidence, Reversibility, Scope-Risk columns)
3. Update `.planning/CONTEXT.md` if any data entity terms were defined

If you've resolved 3-5 questions and haven't saved, STOP ASKING and SAVE. The data grill can run for hours — if the context window compacts, unsaved decisions are gone forever.

## The Counter Rule

Track decisions since last save. Display a counter:
> "[DEC-042, DEC-043, DEC-044 captured — saving to disk...]"

## Escape Hatch — Respect User Pushback

If the user pushes back on a question TWICE, stop. Record as DEFERRED with `Reason Deferred: User explicitly deferred after discussion` and move on. First pushback: rephrase or explain why it matters. Second pushback: respect it immediately. Never ask a third time.

## Depth Calibration

Not every decision needs the full record. ALL tiers must persist the minimum fields downstream compilers need: Question, Selected, Rationale, Status, Confidence, Reversibility, Scope-Risk, Consequences (Enables, Constrains). Use **note** (minimum fields only) for trivial EASY/LOCAL decisions, **tactical** (minimum + Rejected) for moderate decisions, **standard** (full record) for important decisions, and **deep** (full record + ADR, Prediction required) for HARD reversibility or SYSTEM scope-risk decisions. When in doubt, go one tier higher.

## Parity Enforcement

When presenting options for data decisions:
- Options must be genuinely distinct (not "do it well" vs "do it worse")
- Steel-man each option — present the best case for shared references vs separate copies, soft delete vs hard delete, etc.
- Declare the selection policy BEFORE scoring — state the rule for choosing ("We'll pick the option that [criterion]") before evaluating options
- Ask: "Is there an approach I haven't considered?"

## Anti-Sycophancy Rules

Never say "That's interesting", "That could work", or "You might consider." Take a position on every answer with a recommendation and reason. State what evidence would change your mind. Challenge vague answers. Name tradeoffs explicitly.

### Step 3: Grill — One Data Subject at a Time

For EACH data subject identified, ask these categories of questions. Ask ONE question at a time. Use plain English. Give your recommended answer for each question.

#### 3a: What Is It?

- "In one sentence, what is a [project]? What does it represent to your users?"
- "Can you give me a real example? Like 'A project called CRISPR Gene Editing Review that contains 3 documents and 12 saved papers'?"

#### 3b: Who Creates It and Who Sees It?

- "Who creates a [project]? Only the user, or can the system create one automatically?"
- "Can a [project] belong to more than one user? For example, if two researchers are collaborating, do they share the same project or each have their own copy?"
- "Can a [project] be shared with people who don't have an account? Like a public link?"
- "Are there different levels of access? Like one person can edit and another can only view?"

#### 3c: What Happens Over Its Lifetime?

- "When someone creates a [project], what information do they provide upfront? Just a name? Or also a description, a category, a deadline?"
- "Does a [project] change over time? What gets updated after creation?"
- "Can a [project] be in different states? Like 'draft', 'in progress', 'published', 'archived'?"
- "When someone deletes a [project], should it disappear forever? Or should they be able to recover it within 30 days? Or should it stay hidden but recoverable by an admin?"
- "Do you need to know the history of a [project]? Like 'who changed what and when'? For legal compliance, for undo, or for collaboration?"

#### 3d: What Does It Contain or Connect To?

- "What goes INSIDE a [project]? Documents? Papers? Notes? Settings?"
- "If a [project] is deleted, what happens to everything inside it? Does it all get deleted too? Or do some things survive?"
- "Can the same [document] exist in multiple [projects]? Or does each project have its own separate copy?"
- "Is there an order to things inside a [project]? Like sections in a specific sequence?"

#### 3e: Limits and Rules

- "Is there a maximum number of [projects] a user can create? Does it depend on their subscription plan?"
- "Is there a maximum size for a [project]? Like a maximum number of documents or papers inside it?"
- "Are there any rules about [project] names? Must they be unique? Can they contain special characters? Is there a length limit?"
- "Can a [project] be empty? Or must it have at least one thing inside it?"

#### 3f: Search and Discovery

- "Do users search for [projects]? What do they search by — name, content, date, tags?"
- "Do users filter or sort [projects]? By date created? By status? By size?"
- "Do users need to find [projects] by who created them? By shared status?"

#### 3g: Money and Plans (for billable items)

- "Does the number of [projects] affect what the user pays? Is it part of a usage limit?"
- "Do different subscription tiers give different capabilities for [projects]?"

#### 3h: Future Growth

- "In 2 years, what new things might [projects] need? Categories? Tags? AI-generated summaries? Templates?"
- "Will [projects] ever need to work across different disciplines or domains? Like a medical project vs a physics project?"
- "Will [projects] ever need to be exported or imported? Like transferring to another platform?"

### Step 4: Cross-Subject Relationships

After grilling each subject individually, ask about connections BETWEEN subjects:

- "When a user deletes their account, what happens to their [projects]? Their [documents]? Their [saved papers]?"
- "If user A shares a [project] with user B, and user A deletes their account, what happens to user B's access?"
- "Can a [citation] exist without a [document]? Can a [document] exist without a [project]?"
- "Are [notifications] tied to specific [projects] or [documents], or are they global to the user?"

### Step 5: The Future-Proofing Questions

These are the questions that prevent database redesigns later:

- "What features are you definitely NOT building now but might build in the next 2 years?"
- "Will you ever have teams or organizations, not just individual users?"
- "Will you ever need real-time collaboration? Like two people editing the same document at the same time?"
- "Will you ever need an admin panel where you can see all users' data?"
- "Will you ever need analytics? Like 'how many papers were searched this week' or 'which features are most used'?"
- "Will you ever sell to institutions (universities, hospitals) where one organization buys access for many users?"
- "Will you ever need to comply with data regulations? Like 'delete all my data' requests or 'export all my data'?"
- "Will you ever need an API that other apps can connect to?"

### Step 6: Write the Data Requirements Document

After the grilling is complete, compile ALL answers into a structured document:

```markdown
# Data Requirements: [Project Name]
**Date:** [date]
**Source:** PRD + data grilling session
**Status:** GRILLED — ready for database engineer

## Data Subjects

### 1. [Subject Name] (e.g., "Users")

**What it is:** [one-sentence description in user's words]
**Example:** [concrete example from the grilling]

**Lifecycle:**
- Created by: [who/what creates it]
- Updated by: [who/what changes it]
- Deleted by: [who/what removes it]
- Deletion behavior: [permanent / soft delete / recoverable for N days]
- History needed: [yes for compliance / yes for undo / no]

**Ownership & Access:**
- Belongs to: [one user / multiple users / organization]
- Sharing: [no sharing / read-only link / collaborative editing]
- Access levels: [owner / editor / viewer / none]

**Content:**
- Contains: [list of things inside it]
- Cascade on delete: [what happens to contents when this is deleted]
- Shared references: [can the same child exist in multiple parents?]
- Ordering: [is there a specific order to contents?]

**Limits:**
- Max per user: [number or "by plan"]
- Max size: [number or "unlimited"]
- Name rules: [unique? length? characters?]
- Can be empty: [yes/no]

**Search & Filter:**
- Searchable by: [fields]
- Sortable by: [fields]
- Filterable by: [fields]

**Billing impact:**
- Counted for usage: [yes/no]
- Plan-dependent capabilities: [what changes by tier]

**Future expansion:**
- Planned features: [what might be added in 2 years]
- Domain variations: [does this differ by discipline/domain?]

---

### 2. [Next Subject]
...

## Relationships Between Subjects

| Subject A | Relationship | Subject B | On Delete A | On Delete B |
|-----------|-------------|-----------|-------------|-------------|
| User | has many | Projects | delete all projects | N/A |
| Project | has many | Documents | delete all documents | orphan |
| ... | | | | |

## Future-Proofing Decisions

- Teams/organizations: [answer]
- Real-time collaboration: [answer]
- Admin panel: [answer]
- Analytics: [answer]
- Institutional sales: [answer]
- Data compliance (GDPR-like): [answer]
- Public API: [answer]
- Export/import: [answer]

## Open Questions
_Anything that came up during grilling that the user wants to think about more._

- [ ] ...
```

Save to: `.planning/data-requirements.md`

### Step 7: Verify Decision Artifacts

If you followed the Save Rule (saving every 3-5 decisions during the grill), the artifacts should already be up to date. This step is a VERIFICATION pass, not a bulk write.

1. **Verify `.planning/grill-log.md`** has ALL DEC records from this session (under "Data Grill" heading)
2. **Verify `.planning/decision-index.md`** has all rows with Confidence, Reversibility, and Scope-Risk columns filled
3. **Verify `.planning/CONTEXT.md`** has all data entity terms in the glossary
4. **Check the Risk Dashboard** in decision-index.md — flag any LOW confidence + HARD reversibility combinations

Every answer in Step 3 that resolves a question should have been recorded as a DEC-NNN. If you answered 30 questions, there should be ~30 DEC records. If the count doesn't match, find the gap and save the missing records.

### Step 8: Handoff

Tell the user:

> "Data requirements captured in `.planning/data-requirements.md`.
>
> [N] decisions captured (DEC-[start] to DEC-[end]).
> [N] data subjects with [N] relationships between them.
> [N] future-proofing decisions were made.
> [N] open questions need your thought.
>
> Decision index updated. `/write-a-prd` will compile these into the PRD.
>
> When you're ready, run `/db-architect` — it will read this document and design the full database. You won't need to answer any more questions. The database engineer has everything it needs."

Commit:
```bash
git add .planning/data-requirements.md .planning/decision-index.md .planning/grill-log.md .planning/CONTEXT.md
git commit -m "data: capture data requirements with DEC-NNN decision records"
```

## Language Rules

<HARD-GATE>
Do NOT use these words during the grilling:
- schema, table, column, row, field, record
- foreign key, primary key, index, constraint
- normalization, denormalization, 1NF/2NF/3NF
- JSONB, TEXT, BIGINT, TIMESTAMPTZ, VARCHAR
- migration, rollback, transaction
- query, JOIN, SELECT, WHERE
- ORM, Drizzle, Prisma, SQL

Use these instead:
- "things your app stores" instead of "tables"
- "information about a [thing]" instead of "columns"
- "connection between [A] and [B]" instead of "foreign key"
- "finding [things]" instead of "querying"
- "changing the database safely" instead of "migration"
- "keeping track of changes" instead of "audit trail"
- "making sure data is correct" instead of "constraints"
</HARD-GATE>

## Rules

- ONE question at a time — never overwhelm with multiple questions
- ALWAYS give your recommended answer — "I'd suggest [X] because [reason]. Does that match what you have in mind?"
- NEVER skip a subject — every data subject gets the full treatment
- NEVER assume — if the PRD doesn't say, ask
- NEVER use database jargon — the user is a doctor, not a DBA
- The output document is for the DATABASE ENGINEER (Layer 2), so it CAN use structured terms in the output — but the CONVERSATION must be in plain English
- If the user says "I don't know" or "I'll think about it", put it in Open Questions and move on
- The grilling is complete when every subject has been covered and the user confirms "that's everything"
