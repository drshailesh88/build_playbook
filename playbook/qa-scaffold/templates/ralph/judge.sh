#!/usr/bin/env bash
# judge.sh — deterministic-first verdict ladder (DEC-004, DEC-005, DEC-006)
#
# The single source of "done" for one story. Three tiers, cheapest first;
# a story must clear every requested tier:
#
#   T0  Invariants (free, deterministic, never hallucinate)
#       - frozen contract hash matches manifest (freeze-contracts.sh --verify)
#       - a "RALPH: <id>" commit exists
#       - story commits touched no locked paths (rules: ralph/t0-rules.jsonl)
#       - changed files contain no forbidden patterns (secrets, .only tests)
#   T1  Mechanical proof (seconds to minutes, deterministic)
#       - npx tsc --noEmit            (if tsconfig.json exists)
#       - npm run lint --if-present
#       - the story's fail_to_pass tests pass
#       - test-count guard: total test cases never decrease
#       - optional mutation guard     (JUDGE_MUTATION_CMD + JUDGE_T1_MUTATION=1)
#   T2  Semantic judgment (one LLM call, independent context, READ-ONLY tools)
#       - completeness vs the frozen contract
#       - decision-trace lens: novel architecture decisions → ESCALATE
#       Runs ONLY when T0 and T1 pass — the LLM never overrides determinism.
#
# Ratchet rule: when a T2 finding recurs, promote it to a T0 rule (append a
# line to ralph/t0-rules.jsonl) or a T1 test so it can never recur.
#
# Usage:   ./ralph/judge.sh <story-id>
# Env:     JUDGE_TIERS=t0,t1,t2        tiers to run (default all three)
#          JUDGE_T2_MODEL=...          default claude-sonnet-4-6
#          JUDGE_TEST_CMD=...          default "npm run test:run --"
#          JUDGE_T1_FULL_SUITE=1       also run the full test suite in T1
#          JUDGE_T1_MUTATION=1         enable mutation guard (needs JUDGE_MUTATION_CMD)
#          JUDGE_MUTATION_CMD=...      command printing a numeric mutation score
# Output:  ralph/verdicts/<story-id>.json (full verdict, audit trail)
# Exit:    0 PASS · 1 FAIL · 2 ESCALATE (human decision needed)

set -uo pipefail
cd "$(dirname "$0")/.."

SID="${1:?usage: judge.sh <story-id>}"
PRD=ralph/prd.json
RULES=ralph/t0-rules.jsonl
VERDICTS=ralph/verdicts
VERDICT_FILE="$VERDICTS/$SID.json"
TEST_BASELINE="$VERDICTS/.test-baseline"
MUTATION_BASELINE="$VERDICTS/.mutation-baseline"

JUDGE_TIERS="${JUDGE_TIERS:-t0,t1,t2}"
JUDGE_T2_MODEL="${JUDGE_T2_MODEL:-claude-sonnet-4-6}"
JUDGE_TEST_CMD="${JUDGE_TEST_CMD:-npm run test:run --}"
JUDGE_T1_FULL_SUITE="${JUDGE_T1_FULL_SUITE:-0}"
JUDGE_T1_MUTATION="${JUDGE_T1_MUTATION:-0}"

mkdir -p "$VERDICTS"

# Accumulated check results, one JSON object per line; assembled at the end.
CHECKS_TMP=$(mktemp)
trap 'rm -f "$CHECKS_TMP"' EXIT
FAILED_TIER=""
ESCALATE=0

record() {  # record <tier> <check-id> <pass|fail> <detail>
  python3 - "$1" "$2" "$3" "$4" >> "$CHECKS_TMP" <<'PY'
import json, sys
tier, cid, status, detail = sys.argv[1:5]
print(json.dumps({"tier": tier, "id": cid, "pass": status == "pass",
                  "detail": detail[:2000]}))
PY
}

run_check() {  # run_check <tier> <check-id> <command...>
  local tier="$1" cid="$2"; shift 2
  local out rc=0
  out=$("$@" 2>&1) || rc=$?
  if [ "$rc" -eq 0 ]; then
    record "$tier" "$cid" pass "exit 0"
  else
    record "$tier" "$cid" fail "exit $rc: $(printf '%s' "$out" | tail -c 1500)"
    [ -z "$FAILED_TIER" ] && FAILED_TIER="$tier"
  fi
  return "$rc"
}

tier_requested() { case ",$JUDGE_TIERS," in *",$1,"*) return 0;; *) return 1;; esac; }

# ── Story commit discovery ──────────────────────────────────────────────────
# Files touched by this story = files in RALPH:/QA: commits for the id, plus
# anything currently uncommitted (it is about to be committed by a loop).
# The judge's own outputs (ralph/verdicts/) are excluded — they are not the
# story's work. Frozen contracts are NOT excluded: freeze-contracts.sh
# commits them separately, so their presence here means an agent touched them.
STORY_COMMITS=$(git log --format=%H --grep="^RALPH: $SID" --grep="^QA: $SID" 2>/dev/null || true)
CHANGED_FILES=$( {
  for c in $STORY_COMMITS; do
    git diff-tree --no-commit-id --name-only -r "$c" 2>/dev/null
  done
  git status --porcelain -uall 2>/dev/null | cut -c4- | sed 's/^.* -> //'
} | sort -u | grep -v '^$' | grep -v '^ralph/verdicts/' || true)

# ════ T0 — invariants ════════════════════════════════════════════════════════
if tier_requested t0; then
  echo "[judge:$SID] T0 invariants"

  if [ -x ./ralph/freeze-contracts.sh ]; then
    run_check t0 contract-frozen ./ralph/freeze-contracts.sh --verify "$SID" || true
  else
    record t0 contract-frozen fail "ralph/freeze-contracts.sh missing — run scaffold-ralph"
    FAILED_TIER="${FAILED_TIER:-t0}"
  fi

  if [ -n "$STORY_COMMITS" ]; then
    record t0 story-commit-exists pass "$(echo "$STORY_COMMITS" | head -1)"
  else
    record t0 story-commit-exists fail "no commit matching '^RALPH: $SID'"
    FAILED_TIER="${FAILED_TIER:-t0}"
  fi

  # Rule engine: locked-path + forbid-pattern rules from ralph/t0-rules.jsonl.
  RULE_RESULT=$(JUDGE_CHANGED_FILES="$CHANGED_FILES" python3 - "$SID" <<'PY'
import json, os, re, sys

rules_path = 'ralph/t0-rules.jsonl'
changed = [f for f in os.environ.get('JUDGE_CHANGED_FILES', '').split('\n') if f]
results = []

if not os.path.exists(rules_path):
    results.append({"id": "rules-file", "pass": False,
                    "detail": f"{rules_path} missing — install via scaffold-ralph"})
else:
    with open(rules_path) as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            rule = json.loads(line)
            rid, rtype = rule['id'], rule['type']
            if rtype == 'locked-path':
                hits = [f for f in changed if re.search(rule['path_regex'], f)]
                results.append({"id": rid, "pass": not hits,
                                "detail": "touched locked: " + ", ".join(hits[:5]) if hits else "clean"})
            elif rtype == 'forbid-pattern':
                pat = re.compile(rule['pattern'])
                scope = re.compile(rule.get('path_regex', '.'))
                hits = []
                for f in changed:
                    if not scope.search(f) or not os.path.isfile(f):
                        continue
                    try:
                        text = open(f, errors='replace').read()
                    except OSError:
                        continue
                    if pat.search(text):
                        hits.append(f)
                results.append({"id": rid, "pass": not hits,
                                "detail": "pattern found in: " + ", ".join(hits[:5]) if hits else "clean"})
            else:
                results.append({"id": rid, "pass": False, "detail": f"unknown rule type '{rtype}'"})
print(json.dumps(results))
PY
)
  while IFS= read -r row; do
    [ -z "$row" ] && continue
    R_ID=$(printf '%s' "$row" | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])")
    R_PASS=$(printf '%s' "$row" | python3 -c "import json,sys; print('pass' if json.load(sys.stdin)['pass'] else 'fail')")
    R_DETAIL=$(printf '%s' "$row" | python3 -c "import json,sys; print(json.load(sys.stdin)['detail'])")
    record t0 "rule:$R_ID" "$R_PASS" "$R_DETAIL"
    [ "$R_PASS" = "fail" ] && FAILED_TIER="${FAILED_TIER:-t0}"
  done < <(printf '%s' "$RULE_RESULT" | python3 -c "import json,sys; [print(json.dumps(r)) for r in json.load(sys.stdin)]")
fi

# ════ T1 — mechanical proof (only if T0 clean) ═══════════════════════════════
if tier_requested t1 && [ -z "$FAILED_TIER" ]; then
  echo "[judge:$SID] T1 mechanical proof"

  if [ -f tsconfig.json ]; then
    run_check t1 tsc npx tsc --noEmit || true
  fi
  run_check t1 lint npm run lint --if-present || true

  # Story's fail_to_pass tests — the oracle from the frozen contract.
  while IFS= read -r t; do
    [ -z "$t" ] && continue
    SAFE_ID=$(printf '%s' "$t" | tr -c 'A-Za-z0-9._-' '_' | cut -c1-60)
    if printf '%s' "$t" | grep -q '::'; then
      T_FILE="${t%%::*}"; T_NAME="${t#*::}"
      run_check t1 "test:$SAFE_ID" bash -c "$JUDGE_TEST_CMD '$T_FILE' -t '$T_NAME'" || true
    else
      run_check t1 "test:$SAFE_ID" bash -c "$JUDGE_TEST_CMD '$t'" || true
    fi
  done < <(python3 -c "
import json
prd = json.load(open('$PRD'))
s = next((x for x in prd if x.get('id') == '$SID'), {})
print('\n'.join(s.get('fail_to_pass', [])))")

  if [ "$JUDGE_T1_FULL_SUITE" = "1" ]; then
    run_check t1 full-suite bash -c "$JUDGE_TEST_CMD" || true
  fi

  # Test-count guard — total test cases must never decrease (guard metric).
  CURRENT_TESTS=$(git ls-files '*.test.*' '*.spec.*' 2>/dev/null \
    | xargs grep -hE '^[[:space:]]*(it|test)(\.each[^(]*)?\(' 2>/dev/null | wc -l | tr -d ' ')
  BASELINE_TESTS=$(cat "$TEST_BASELINE" 2>/dev/null || echo 0)
  if [ "$CURRENT_TESTS" -lt "$BASELINE_TESTS" ]; then
    record t1 test-count-guard fail "test cases dropped: $BASELINE_TESTS -> $CURRENT_TESTS"
    FAILED_TIER="${FAILED_TIER:-t1}"
  else
    record t1 test-count-guard pass "$BASELINE_TESTS -> $CURRENT_TESTS"
  fi

  # Optional mutation guard — never regress (guard-only until runtime cost is known).
  if [ "$JUDGE_T1_MUTATION" = "1" ] && [ -n "${JUDGE_MUTATION_CMD:-}" ]; then
    CURRENT_MUT=$(bash -c "$JUDGE_MUTATION_CMD" 2>/dev/null | tail -1 | tr -dc '0-9.' || echo "")
    BASELINE_MUT=$(cat "$MUTATION_BASELINE" 2>/dev/null || echo 0)
    if [ -n "$CURRENT_MUT" ] && python3 -c "exit(0 if float('$CURRENT_MUT') >= float('$BASELINE_MUT') else 1)"; then
      record t1 mutation-guard pass "$BASELINE_MUT -> $CURRENT_MUT"
      echo "$CURRENT_MUT" > "$MUTATION_BASELINE"
    else
      record t1 mutation-guard fail "mutation score regressed: $BASELINE_MUT -> ${CURRENT_MUT:-unreadable}"
      FAILED_TIER="${FAILED_TIER:-t1}"
    fi
  fi
fi

# ════ T2 — semantic judgment (only if T0+T1 clean) ═══════════════════════════
T2_REASON=""
if tier_requested t2 && [ -z "$FAILED_TIER" ]; then
  echo "[judge:$SID] T2 semantic judgment ($JUDGE_T2_MODEL, read-only)"

  T2_PROMPT_FILE=ralph/judge-t2-prompt.md
  [ -f "$T2_PROMPT_FILE" ] || T2_PROMPT_FILE=ralph/judge-t2-prompt.template.md
  CONTRACT_FILE=ralph/contracts/$SID.contract.md

  DIFF_EXCERPT=$(for c in $STORY_COMMITS; do git show --stat --patch "$c" 2>/dev/null; done | head -c 60000)

  T2_RAW=""
  for ATTEMPT in 1 2; do
    # Prompt goes via stdin: --allowedTools is variadic and would swallow a
    # trailing prompt argument as a tool name.
    T2_RAW=$(printf '%s' \
"$(cat "$T2_PROMPT_FILE" 2>/dev/null || echo 'You are an independent completeness judge. Compare the diff to the contract. Respond with only a JSON object: {"verdict":"PASS|FAIL|ESCALATE","reasons":[...],"decision_trace_flags":[...]}')

STORY: $SID

FROZEN CONTRACT (sha256-verified by T0):
$(cat "$CONTRACT_FILE" 2>/dev/null || echo '(contract file missing)')

CHANGED FILES:
$CHANGED_FILES

STORY DIFF (truncated at 60KB):
$DIFF_EXCERPT

T0 and T1 deterministic checks: ALL PASSED.
Respond with ONLY the JSON verdict object." \
      | claude -p --model "$JUDGE_T2_MODEL" --allowedTools "Read,Grep,Glob" 2>&1) || true

    T2_PARSED=$(printf '%s' "$T2_RAW" | python3 -c "
import json, re, sys
text = sys.stdin.read()
m = re.search(r'\{.*\}', text, re.DOTALL)
if not m:
    sys.exit(1)
try:
    v = json.loads(m.group(0))
except json.JSONDecodeError:
    sys.exit(1)
verdict = v.get('verdict', '')
if verdict not in ('PASS', 'FAIL', 'ESCALATE'):
    sys.exit(1)
print(json.dumps(v))
" 2>/dev/null) && break
    T2_PARSED=""
    echo "[judge:$SID] T2 returned unparseable output (attempt $ATTEMPT)" >&2
  done

  if [ -z "${T2_PARSED:-}" ]; then
    record t2 llm-judge fail "unparseable T2 output after 2 attempts — escalating"
    FAILED_TIER="t2"
    ESCALATE=1
    T2_REASON="judge output unparseable"
  else
    T2_VERDICT=$(printf '%s' "$T2_PARSED" | python3 -c "import json,sys; print(json.load(sys.stdin)['verdict'])")
    T2_REASON=$(printf '%s' "$T2_PARSED" | python3 -c "import json,sys; v=json.load(sys.stdin); print('; '.join(v.get('reasons', [])[:5]))")
    T2_FLAGS=$(printf '%s' "$T2_PARSED" | python3 -c "import json,sys; v=json.load(sys.stdin); print('; '.join(v.get('decision_trace_flags', [])[:5]))")
    case "$T2_VERDICT" in
      PASS)
        record t2 llm-judge pass "$T2_REASON"
        [ -n "$T2_FLAGS" ] && record t2 decision-trace pass "noted (non-blocking): $T2_FLAGS"
        ;;
      FAIL)
        record t2 llm-judge fail "$T2_REASON"
        FAILED_TIER="t2"
        ;;
      ESCALATE)
        record t2 llm-judge fail "ESCALATE: $T2_REASON${T2_FLAGS:+ | flags: $T2_FLAGS}"
        FAILED_TIER="t2"
        ESCALATE=1
        ;;
    esac
  fi
fi

# ── Assemble verdict ─────────────────────────────────────────────────────────
if [ -z "$FAILED_TIER" ]; then VERDICT=PASS; elif [ "$ESCALATE" = "1" ]; then VERDICT=ESCALATE; else VERDICT=FAIL; fi

VERDICT="$VERDICT" FAILED_TIER="$FAILED_TIER" SID="$SID" \
CHECKS_TMP="$CHECKS_TMP" VERDICT_FILE="$VERDICT_FILE" \
python3 <<'PY'
import json, os, subprocess, datetime

checks = []
with open(os.environ['CHECKS_TMP']) as fh:
    for line in fh:
        line = line.strip()
        if line:
            checks.append(json.loads(line))

tiers = {}
for c in checks:
    tiers.setdefault(c['tier'], {"pass": True, "checks": []})
    tiers[c['tier']]['checks'].append({"id": c['id'], "pass": c['pass'], "detail": c['detail']})
    if not c['pass']:
        tiers[c['tier']]['pass'] = False

head = subprocess.run(['git', 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
verdict = {
    "story_id": os.environ['SID'],
    "verdict": os.environ['VERDICT'],
    "failed_tier": os.environ['FAILED_TIER'] or None,
    "tiers": tiers,
    "head_commit": head,
    "timestamp": datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
}
with open(os.environ['VERDICT_FILE'], 'w') as fh:
    json.dump(verdict, fh, indent=2)
PY

# Ratchet the test-count baseline upward only on PASS.
if [ "$VERDICT" = "PASS" ] && tier_requested t1; then
  CURRENT_TESTS=$(git ls-files '*.test.*' '*.spec.*' 2>/dev/null \
    | xargs grep -hE '^[[:space:]]*(it|test)(\.each[^(]*)?\(' 2>/dev/null | wc -l | tr -d ' ')
  BASELINE_TESTS=$(cat "$TEST_BASELINE" 2>/dev/null || echo 0)
  [ "$CURRENT_TESTS" -gt "$BASELINE_TESTS" ] && echo "$CURRENT_TESTS" > "$TEST_BASELINE"
fi

echo "[judge:$SID] verdict: $VERDICT${FAILED_TIER:+ (failed tier: $FAILED_TIER)} -> $VERDICT_FILE"
case "$VERDICT" in
  PASS) exit 0 ;;
  ESCALATE) exit 2 ;;
  *) exit 1 ;;
esac
