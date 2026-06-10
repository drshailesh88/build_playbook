#!/usr/bin/env bash
# review-quorum.sh — independent two-reviewer quorum (DEC-003, DEC-009)
#
# Runs Codex and Grok as INDEPENDENT parallel reviewers of one story, each
# with a distinct lens:
#
#   Codex — runtime skeptic: assume the code is broken; correctness,
#           security, races, data loss (reviewer-codex-prompt.md)
#   Grok  — scope minimalist: spec-completeness vs the frozen contract,
#           decision-trace audit, unauthorized scope (reviewer-grok-prompt.md)
#
# Quorum semantics (from the adversarial-review ecosystem):
#   - finding reported by BOTH reviewers      -> "confirmed"  (auto-fixable)
#   - finding reported by ONE reviewer        -> "triage"     (human queue)
#   - either reviewer verdict REJECT          -> story not approved
#   - reviewers disagree on overall verdict   -> ESCALATE (human decides;
#     never auto-merge on conflict — Ethos #3)
#
# Reviewers are READ-ONLY here: they report findings as JSON; fixing is the
# build loop's job (feedback goes to progress.txt). This keeps the review
# independent — a reviewer that edits code starts grading its own homework.
#
# Usage:   ./ralph/review-quorum.sh <story-id>
# Env:     REVIEW_CODEX=1|0, REVIEW_GROK=1|0    enable lanes (default both 1;
#            with one lane the quorum degrades to single-reviewer mode and
#            every finding becomes "triage")
#          CODEX_ACC1/CODEX_ACC2                codex auth dirs (as qa.sh)
#          GROK_MODEL                           optional grok model override
#          REVIEW_TIMEOUT                       seconds per reviewer (default 900)
# Output:  ralph/reviews/<story-id>.quorum.json
# Exit:    0 approved · 1 rejected (findings -> build feedback) · 2 escalate

set -uo pipefail
cd "$(dirname "$0")/.."

SID="${1:?usage: review-quorum.sh <story-id> | --all}"
PRD=ralph/prd.json

# Batch mode: quorum every qa_tested story that has no quorum verdict yet.
if [ "$SID" = "--all" ]; then
  APPROVED=0; REJECTED=0; ESCALATED=0
  while IFS= read -r sid; do
    [ -z "$sid" ] && continue
    echo ""
    echo "═══ quorum: $sid ═══"
    "$0" "$sid"; RC=$?
    case "$RC" in
      0) APPROVED=$((APPROVED + 1)) ;;
      2) ESCALATED=$((ESCALATED + 1)) ;;
      *) REJECTED=$((REJECTED + 1)) ;;
    esac
  done < <(python3 -c "
import json, os
prd = json.load(open('ralph/prd.json'))
for s in prd:
    if s.get('qa_tested') and not os.path.exists(f\"ralph/reviews/{s['id']}.quorum.json\"):
        print(s['id'])")
  echo ""
  echo "[quorum] batch done — approved=$APPROVED rejected=$REJECTED escalated=$ESCALATED"
  [ "$ESCALATED" -gt 0 ] && exit 2
  [ "$REJECTED" -gt 0 ] && exit 1
  exit 0
fi
REVIEWS=ralph/reviews
OUT="$REVIEWS/$SID.quorum.json"
REVIEW_CODEX="${REVIEW_CODEX:-1}"
REVIEW_GROK="${REVIEW_GROK:-1}"
REVIEW_TIMEOUT="${REVIEW_TIMEOUT:-900}"
CODEX_ACC1="${CODEX_ACC1:-$HOME/.codex-acc1}"
CODEX_ACC2="${CODEX_ACC2:-$HOME/.codex-acc2}"

mkdir -p "$REVIEWS"

if command -v timeout >/dev/null 2>&1; then TCMD=(timeout "$REVIEW_TIMEOUT");
elif command -v gtimeout >/dev/null 2>&1; then TCMD=(gtimeout "$REVIEW_TIMEOUT");
else TCMD=(); fi

CONTRACT_FILE=ralph/contracts/$SID.contract.md
STORY_COMMITS=$(git log --format=%H --grep="^RALPH: $SID" --grep="^QA: $SID" 2>/dev/null || true)
DIFF_EXCERPT=$(for c in $STORY_COMMITS; do git show --stat --patch "$c" 2>/dev/null; done | head -c 80000)
VERDICT_JSON=ralph/verdicts/$SID.json

REVIEW_SCHEMA='Respond with ONLY this JSON object — no prose before or after:
{
  "verdict": "APPROVE | REJECT",
  "findings": [
    {"id": "short-slug", "severity": "critical|major|minor",
     "claim": "one-sentence finding", "evidence": "file:line or quoted diff",
     "fix_hint": "one sentence"}
  ]
}'

build_packet() {  # build_packet <lens-prompt-file> <fallback-role-line>
  printf '%s\n\nSTORY: %s\n\nFROZEN CONTRACT (sha256-verified):\n%s\n\nDETERMINISTIC JUDGE VERDICT (T0/T1/T2 all passed):\n%s\n\nSTORY DIFF (truncated at 80KB):\n%s\n\n%s\n' \
    "$(cat "$1" 2>/dev/null || echo "$2")" \
    "$SID" \
    "$(cat "$CONTRACT_FILE" 2>/dev/null || echo '(contract missing)')" \
    "$(cat "$VERDICT_JSON" 2>/dev/null || echo '(no verdict file)')" \
    "$DIFF_EXCERPT" \
    "$REVIEW_SCHEMA"
}

parse_review() {  # stdin: raw output -> stdout: normalized JSON, exit 1 if unparseable
  python3 -c "
import json, re, sys
text = sys.stdin.read()
m = re.search(r'\{.*\}', text, re.DOTALL)
if not m: sys.exit(1)
try: v = json.loads(m.group(0))
except json.JSONDecodeError: sys.exit(1)
if v.get('verdict') not in ('APPROVE', 'REJECT'): sys.exit(1)
v.setdefault('findings', [])
print(json.dumps(v))
"
}

# ── Codex lane (runtime skeptic) — dual-account failover like qa.sh ─────────
run_codex_review() {
  local packet out
  packet=$(build_packet ralph/reviewer-codex-prompt.md \
    'You are a RUNTIME SKEPTIC reviewer. Assume the code is broken; hunt correctness, security, race, and data-loss bugs.')
  for dir in "$CODEX_ACC1" "$CODEX_ACC2" "$HOME/.codex"; do
    [ -s "$dir/auth.json" ] || continue
    out=$(printf '%s' "$packet" | CODEX_HOME="$dir" "${TCMD[@]}" codex exec --sandbox read-only - 2>&1)
    if printf '%s' "$out" | tail -n 30 | grep -qiE 'HTTP 429|rate.limit|quota|usage.limit|insufficient_quota'; then
      echo "[quorum] codex ($dir) quota-limited, trying next account" >&2
      continue
    fi
    printf '%s' "$out" | parse_review && return 0
    echo "[quorum] codex ($dir) output unparseable" >&2
    return 1
  done
  return 1
}

# ── Grok lane (scope minimalist) — headless single-turn, read-only ──────────
run_grok_review() {
  local packet
  packet=$(build_packet ralph/reviewer-grok-prompt.md \
    'You are a SCOPE MINIMALIST reviewer. Audit spec-completeness vs the frozen contract and flag every decision or scope expansion the contract did not authorize.')
  # Read-only via deny-list: --tools allow-lists break agent building in
  # grok 0.2.39; denying the mutating tools is the supported path.
  PACKET_FILE=$(mktemp)
  printf '%s' "$packet" > "$PACKET_FILE"
  "${TCMD[@]}" grok --prompt-file "$PACKET_FILE" \
      ${GROK_MODEL:+--model "$GROK_MODEL"} \
      --max-turns 15 \
      --disallowed-tools "write,search_replace,run_terminal_cmd" \
      --disable-web-search --no-subagents --no-memory \
      2>&1 | parse_review
  local rc=$?
  rm -f "$PACKET_FILE"
  return "$rc"
}

# ── Run requested lanes in parallel ──────────────────────────────────────────
CODEX_FILE=$(mktemp) GROK_FILE=$(mktemp)
trap 'rm -f "$CODEX_FILE" "$GROK_FILE"' EXIT
CODEX_PID="" GROK_PID=""

if [ "$REVIEW_CODEX" = "1" ] && command -v codex >/dev/null 2>&1; then
  echo "[quorum:$SID] codex lane started (runtime skeptic)"
  run_codex_review > "$CODEX_FILE" & CODEX_PID=$!
fi
if [ "$REVIEW_GROK" = "1" ] && command -v grok >/dev/null 2>&1; then
  echo "[quorum:$SID] grok lane started (scope minimalist)"
  run_grok_review > "$GROK_FILE" & GROK_PID=$!
fi

CODEX_OK=skip GROK_OK=skip
[ -n "$CODEX_PID" ] && { wait "$CODEX_PID" && CODEX_OK=ok || CODEX_OK=error; }
[ -n "$GROK_PID" ]  && { wait "$GROK_PID"  && GROK_OK=ok  || GROK_OK=error; }

if [ "$CODEX_OK" != "ok" ] && [ "$GROK_OK" != "ok" ]; then
  echo "[quorum:$SID] no reviewer produced a usable verdict (codex=$CODEX_OK grok=$GROK_OK) — escalating" >&2
  printf '{"story_id":"%s","quorum":"ESCALATE","reason":"no usable reviewer output","codex":"%s","grok":"%s"}\n' \
    "$SID" "$CODEX_OK" "$GROK_OK" > "$OUT"
  exit 2
fi

# ── Merge: 2-of-2 quorum semantics ───────────────────────────────────────────
SID="$SID" CODEX_FILE="$CODEX_FILE" GROK_FILE="$GROK_FILE" \
CODEX_OK="$CODEX_OK" GROK_OK="$GROK_OK" OUT="$OUT" python3 <<'PY'
import datetime, difflib, json, os, sys

def load(path, status):
    if status != 'ok':
        return None
    with open(path) as fh:
        text = fh.read().strip()
    return json.loads(text) if text else None

codex = load(os.environ['CODEX_FILE'], os.environ['CODEX_OK'])
grok = load(os.environ['GROK_FILE'], os.environ['GROK_OK'])

def similar(a, b):
    return difflib.SequenceMatcher(None, a.lower(), b.lower()).ratio() > 0.55

confirmed, triage = [], []
c_findings = (codex or {}).get('findings', [])
g_findings = (grok or {}).get('findings', [])
matched_g = set()
for cf in c_findings:
    match = next((i for i, gf in enumerate(g_findings)
                  if i not in matched_g and similar(cf['claim'], gf['claim'])), None)
    if match is not None and codex and grok:
        matched_g.add(match)
        confirmed.append({**cf, 'also_reported_by': 'grok', 'lane': 'both'})
    else:
        triage.append({**cf, 'lane': 'codex'})
triage += [{**gf, 'lane': 'grok'} for i, gf in enumerate(g_findings) if i not in matched_g]

verdicts = {v.get('verdict') for v in (codex, grok) if v}
if verdicts == {'APPROVE'}:
    quorum = 'APPROVED'
elif verdicts == {'REJECT'}:
    quorum = 'REJECTED'
else:
    # Single-lane mode: trust the one verdict but everything stays triage.
    # Two lanes disagreeing on the overall verdict: a human decides.
    quorum = ('APPROVED' if 'APPROVE' in verdicts else 'REJECTED') \
        if (codex is None or grok is None) else 'ESCALATE'

result = {
    'story_id': os.environ['SID'],
    'quorum': quorum,
    'codex_verdict': (codex or {}).get('verdict', os.environ['CODEX_OK']),
    'grok_verdict': (grok or {}).get('verdict', os.environ['GROK_OK']),
    'confirmed_findings': confirmed,
    'triage_findings': triage,
    'timestamp': datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
}
with open(os.environ['OUT'], 'w') as fh:
    json.dump(result, fh, indent=2)

print(f"[quorum:{os.environ['SID']}] {quorum} — "
      f"codex={result['codex_verdict']} grok={result['grok_verdict']} "
      f"confirmed={len(confirmed)} triage={len(triage)}")
sys.exit(0 if quorum == 'APPROVED' else 2 if quorum == 'ESCALATE' else 1)
PY
RC=$?

if [ "$RC" -eq 0 ]; then
  # Approved: record locally and close out the story on GitHub.
  python3 - "$SID" <<'PY'
import json, sys
d = json.load(open('ralph/prd.json'))
for s in d:
    if s.get('id') == sys.argv[1]:
        s['quorum_approved'] = True
json.dump(d, open('ralph/prd.json', 'w'), indent=2)
PY
  if [ -x ./ralph/gh-state.sh ]; then
    ./ralph/gh-state.sh event "$SID" quorum-approved "$OUT" || true
  fi
elif [ -f "$OUT" ]; then
  SUMMARY=$(python3 -c "
import json
r = json.load(open('$OUT'))
items = r.get('confirmed_findings', []) + r.get('triage_findings', [])
print('; '.join(f\"[{f.get('severity','?')}] {f.get('claim','')[:100]}\" for f in items[:4]))")
  printf '\n%s — QUORUM %s %s: %s\n' "$(date +%F)" \
    "$([ "$RC" -eq 2 ] && echo ESCALATED || echo REJECTED)" "$SID" "$SUMMARY" \
    >> ralph/progress.txt
  if [ "$RC" -eq 2 ]; then
    # Reviewers disagree (or no usable verdict): a human decides. Park it.
    if [ -x ./ralph/gh-state.sh ]; then
      ./ralph/gh-state.sh escalate "$SID" "reviewer quorum disagreement — never auto-merge on conflict" "$OUT" || true
    fi
  else
    # Rejected by both reviewers: send the story back through the build loop.
    python3 - "$SID" <<'PY'
import json, sys
d = json.load(open('ralph/prd.json'))
for s in d:
    if s.get('id') == sys.argv[1]:
        s['passes'] = False
        s['qa_tested'] = False
        s['quorum_approved'] = False
json.dump(d, open('ralph/prd.json', 'w'), indent=2)
PY
    if [ -x ./ralph/gh-state.sh ]; then
      ./ralph/gh-state.sh event "$SID" quorum-rejected "$OUT" || true
    fi
  fi
fi
exit "$RC"
