# promote-finding — Promote a recurring finding into a deterministic check

The ratchet (Ethos #5, DEC-009): when the same class of mistake is caught
twice by anything probabilistic — the T2 judge, a reviewer, QA, or you — it
gets promoted into a deterministic check that runs for free, in milliseconds,
forever. Soft memory (Supermemory) makes the orchestrator smarter; hard
memory (the promoted check) makes the JUDGE stricter. This command is the
promotion pipeline: **fail → investigate → verify → distill → consult → apply**.

Input: `$ARGUMENTS` — a check id from `/morning-review`'s ratchet candidates
(e.g. `llm-judge`), a finding slug from a quorum report, or free text
describing the recurring mistake.

## Why the ratchet matters

LLM judges and reviewers are probabilistic: the same stubbed implementation
gets caught on Tuesday and slips through on Thursday. A `t0-rules.jsonl`
line never has a Thursday. Every promotion permanently shrinks the space of
mistakes the expensive tiers must catch — the factory gets MORE deterministic
with age, not less.

## Process

### 1. INVESTIGATE — collect every instance

```bash
# All verdict failures matching the finding
python3 -c "
import glob, json, sys
needle = '$ARGUMENTS'.lower()
for f in sorted(glob.glob('ralph/verdicts/*.json')):
    v = json.load(open(f))
    for t in v.get('tiers', {}).values():
        for c in t.get('checks', []):
            if not c['pass'] and (needle in c['id'].lower() or needle in c['detail'].lower()):
                print(f\"{v['story_id']}: [{c['id']}] {c['detail'][:140]}\")"

# Quorum findings matching
python3 -c "
import glob, json
needle = '$ARGUMENTS'.lower()
for f in glob.glob('ralph/reviews/*.quorum.json'):
    r = json.load(open(f))
    for x in r.get('confirmed_findings', []) + r.get('triage_findings', []):
        if needle in (x.get('claim','') + x.get('id','')).lower():
            print(f\"{r['story_id']}: [{x.get('severity')}] {x.get('claim','')[:140]}\")"

# Prior promotions — never promote the same finding twice
grep -i "$ARGUMENTS" ralph/ratchet-log.jsonl 2>/dev/null
```

Also `recall` from Supermemory: "recurring finding: $ARGUMENTS".

**Gate:** fewer than 2 instances → STOP. Report "1 occurrence — not yet a
pattern. Logged; promote on recurrence." (Save the single instance to
Supermemory so the next occurrence finds it.)

### 2. DISTILL — choose the LOWEST tier that can express the rule

Work down this ladder and pick the first tier that can fully express the
check. Lower is better: cheaper, faster, can't hallucinate.

| Tier | Form | When it fits |
|---|---|---|
| T0 forbid-pattern | regex over changed files → `ralph/t0-rules.jsonl` | The mistake leaves a grep-able fingerprint (a banned API, a pattern like `catch {}` or `: any`, a missing-tenant-scope query shape) |
| T0 locked-path | path regex → `ralph/t0-rules.jsonl` | The mistake is "touched something it shouldn't" |
| T0 architecture rule | dependency-cruiser / lint-boundary config | The mistake is a forbidden import direction or module-boundary breach |
| T1 test | a real test file (respecting phase file-locks) | The mistake is behavioral and needs execution to detect |
| T1 lint rule | eslint rule/config (note: configs are T0-locked — this needs a human-signed change) | Stylistic-but-dangerous patterns lint can see |
| Contract fix | better wording in the prd-to-ralph mapping or contract template | The mistake is really an ambiguity builders keep misreading |
| Sign | one constraint line in `ralph/build-prompt.md` (Huntley's "signs") | LAST RESORT — not deterministic, just feedforward. Use when nothing above fits. |

Generalize honestly: the rule must catch the CLASS, not just the instances —
but never so broad it fires on legitimate code. Write down 2 examples it
must catch and 2 it must NOT.

### 3. VERIFY — replay before apply (Evidence Over Assertion)

For a T0 rule, prove it fires on the historical instances and not on clean code:

```bash
# The pattern must match the offending diffs:
git show <offending-commit> | grep -E '<pattern>'   # expect: match

# And must NOT match the current clean tree:
git ls-files -z | xargs -0 grep -lE '<pattern>'      # expect: only known-bad files, ideally none
```

For a T1 test: RED on a revert of the fix, GREEN on current code.
A rule that cannot be replay-verified does not get applied — refine or
downgrade it to a sign.

### 4. CONSULT — human approves the ratchet click

Present: the finding, instance count, the proposed rule (exact JSONL line or
test diff), the catch/not-catch examples, and replay evidence. The founder
approves, narrows, or rejects. **Never append without approval** — a bad T0
rule blocks every future story.

### 5. APPLY + LOG

```bash
# T0: append the approved line
cat >> ralph/t0-rules.jsonl <<'EOF'
{"id": "<rule-id>", "type": "forbid-pattern", "pattern": "<regex>", "path_regex": "<scope>", "description": "<what + why, one line>"}
EOF

# Replay through the real judge — the new check id must appear:
JUDGE_TIERS=t0 ./ralph/judge.sh <historical-story-id> || true
grep '<rule-id>' ralph/verdicts/<historical-story-id>.json

# Ratchet ledger (append-only)
printf '{"date":"%s","finding":"%s","instances":%d,"promoted_to":"t0:<rule-id>","source":"%s"}\n' \
  "$(date -u +%F)" "<finding summary>" <N> "verdicts+quorum" >> ralph/ratchet-log.jsonl

git add ralph/t0-rules.jsonl ralph/ratchet-log.jsonl
git commit -m "ratchet: promote '<finding>' to t0:<rule-id> (<N> occurrences)"
```

Then save to Supermemory (project tag): "Ratchet promotion: <finding class>
is now deterministic check t0:<rule-id>; the T2 judge no longer needs to
catch it." This closes the loop — soft memory records that hard memory took
over.

### 6. RETIRE the soft check (when applicable)

If the T2 judge prompt or a reviewer lens explicitly lists this finding
class, remove that line — paying an LLM to look for what a grep now
guarantees is waste. Note the removal in the same commit.

## Rules

- NEVER promote on a single occurrence — log it and wait for the pattern
- NEVER apply without replay verification AND founder approval
- NEVER weaken or delete an existing rule to make a new one fit — rules only accumulate (it's a ratchet)
- Prefer narrowing scope (`path_regex`) over softening the pattern
- One finding per promotion; one promotion per commit
- If the rule can't be expressed deterministically, say so plainly and add a sign — an honest sign beats a fake invariant
