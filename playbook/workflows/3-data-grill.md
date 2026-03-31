# Data Grill — Extract Every Data Decision From Your Brain

Read your PRD and project plans, then interview you about every piece of data your app will ever touch. No database jargon. No technical language. Just business questions in plain English that expose every data decision hiding inside your product vision.

Input: $ARGUMENTS (path to PRD file, GSD requirements file, or "latest" for most recent .planning/ files)

## Why This Exists

Your PRD says "users can create projects." That one sentence hides 15 database decisions: Can a project belong to multiple users? Can deleted projects come back? Is there a limit per user? What happens to a project when a user deletes their account? Do projects have versions? Can projects be shared publicly?

You know the answers to all of these questions — you just haven't been asked yet. This command asks every single one, in language you understand, and writes down your answers so a database engineer can build exactly what you described.

**You will never see the words "normalization", "foreign key", "index", or "schema" during this grilling. Those are the engineer's problem, not yours.**

## Process

### Step 1: Load Your Plans

Read everything that describes what you're building:

- PRD (from $ARGUMENTS or latest in .planning/)
- GSD REQUIREMENTS.md (if exists)
- GSD ROADMAP.md (if exists)
- .planning/decisions/ files (if exist)
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

### Step 7: Handoff

Tell the user:

> "Data requirements captured in `.planning/data-requirements.md`.
>
> I found [N] data subjects with [N] relationships between them.
> [N] future-proofing decisions were made.
> [N] open questions need your thought.
>
> When you're ready, run `/db-architect` — it will read this document and design the full database. You won't need to answer any more questions. The database engineer has everything it needs."

Commit:
```bash
git add .planning/data-requirements.md
git commit -m "data: capture data requirements from grilling session"
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
