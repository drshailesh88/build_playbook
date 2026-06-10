# morning-review — What did the factory do overnight, and what needs ME?

Run this in the target app the morning after an AFK run. It compiles the
night's evidence into one report ordered by what needs your judgment, and
proposes ratchet promotions for recurring findings. Read this INSTEAD of
scrolling logs.

Input: `$ARGUMENTS` — optional `--since <git-ref-or-date>` (default: the
marker written by the previous morning-review, falling back to 24h ago).

## Gather (run all of these, read the output)

```bash
# 1. Where the factory stopped + parked stories
./ralph/gh-state.sh recover

# 2. Story flow since last review
python3 -c "
import json
d = json.load(open('ralph/prd.json'))
print(f\"built {sum(1 for s in d if s.get('passes'))}/{len(d)}, \"
      f\"qa'd {sum(1 for s in d if s.get('qa_tested'))}, \"
      f\"approved {sum(1 for s in d if s.get('quorum_approved'))}, \"
      f\"parked {sum(1 for s in d if s.get('parked'))}\")"

# 3. Escalated issues (the human queue)
gh issue list --label escalated --state open --json number,title,labels

# 4. What landed
SINCE=$(cat ralph/.last-review 2>/dev/null || date -v-24H +%F 2>/dev/null || date -d '24 hours ago' +%F)
git log --oneline --since="$SINCE" | head -40

# 5. Run health: exits, circuit breakers, budget
tail -5 ralph/ralph-*.log 2>/dev/null | tail -20
grep -h "CIRCUIT BREAKER\|BUDGET\|ABORT" ralph/ralph-*.log 2>/dev/null | tail -10
tail -20 ralph/witness.log 2>/dev/null

# 6. Judge rejections by check (ratchet input)
python3 -c "
import collections, glob, json
fails = collections.Counter()
for f in glob.glob('ralph/verdicts/*.json'):
    v = json.load(open(f))
    for t in v.get('tiers', {}).values():
        for c in t.get('checks', []):
            if not c['pass']:
                fails[c['id']] += 1
[print(f'{n}x  {cid}') for cid, n in fails.most_common(10)]"

# 7. Quorum triage queue (single-reviewer findings awaiting your call)
python3 -c "
import glob, json
for f in glob.glob('ralph/reviews/*.quorum.json'):
    r = json.load(open(f))
    for x in r.get('triage_findings', []):
        print(f\"{r['story_id']} [{x.get('severity')}] ({x.get('lane')}): {x.get('claim','')[:110]}\")"
```

## Produce the report

Write `ralph/morning/YYYY-MM-DD.md` AND print it. Structure, in this order
(most-needs-a-human first):

```markdown
# Morning Review — YYYY-MM-DD

## TLDR
One paragraph: N stories approved and closed, M parked awaiting you,
run ended <cleanly | circuit breaker | budget | crash>, K triage findings.

## Needs your decision (do these today)
Per escalated/parked story: ID, WHY it was parked (quote the verdict or
quorum reason), and the resume command:
  fix → remove `parked` label on GitHub (or `gh issue edit N --remove-label parked`)
  → next run re-queues it.
Per triage finding (single-reviewer): story, claim, your options
(accept = file as story / reject = note why on the issue).

## Shipped (verify spot-checks, don't re-review)
Approved stories with their issue links and the commits that built them.

## Factory health
Run duration vs budget, circuit-breaker events, witness events, judge
rejection rate (rejections / stories), quorum disagreement rate.

## Ratchet candidates (Ethos #5 — every session leaves the system smarter)
Any check or finding class that failed >= 2 times. For each, PROPOSE the
promotion but do not apply it without approval:
- recurring T2/quorum finding → a concrete `ralph/t0-rules.jsonl` line
- recurring T1 test failure pattern → a test or lint rule
- recurring escalation cause → a contract-authoring fix in prd-to-ralph

## Comprehension debt check
2-3 sentences: which shipped change should the founder actually READ today
to stay the engineer? (Largest diff, or the one touching auth/data/money.)
```

## Finish

```bash
date -u +%FT%TZ > ralph/.last-review
git add ralph/morning/ ralph/.last-review && git commit -m "docs(factory): morning review $(date +%F)"
```

If `NOTIFY_WEBHOOK` is set, post the TLDR line to Slack. If the user approves
any ratchet candidate, append the rule to `ralph/t0-rules.jsonl` in the same
sitting — approved promotions that wait become forgotten promotions.

## Rules

- ORDER BY human-judgment-needed, not chronology. Escalations before trophies.
- Quote verdicts verbatim when explaining a parking — never paraphrase a judge.
- Every parked story must leave the report with a stated next action.
- Never apply a ratchet promotion without explicit approval in this session.
- Keep the TLDR honest: "budget exhausted at 60% done" is a finding, not a failure to hide.
