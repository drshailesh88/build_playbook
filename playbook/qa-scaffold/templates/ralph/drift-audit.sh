#!/usr/bin/env bash
# drift-audit.sh — aggregate-drift audit at the controller level (DEC-009 item 5)
#
# Per-story checks cannot see accumulation: ten individually-reasonable
# changes across ten stories can add up to an architecture nobody authorized
# ("governance debt"). This audit watches the run as a whole.
#
# Surfaces watched:
#   deps    — package.json dependencies + devDependencies
#   schema  — db schema and migration files
#   config  — build/deploy/CI configuration
#
# snapshot (run start): record dep versions + sha256 of surface files +
#   baseline commit into ralph/.drift-baseline.json
# audit (run end): diff current state vs baseline. Every change is
#   ATTRIBUTED (a story commit touched it AND that story's frozen contract
#   mentions it) or UNATTRIBUTED (nobody authorized it — a human reviews it
#   in /morning-review). Writes ralph/drift-report.json.
#
# Usage:  ./ralph/drift-audit.sh snapshot
#         ./ralph/drift-audit.sh audit       (exit 0 clean, 1 unattributed drift)
# Env:    DRIFT_EXTRA_GLOBS="infra/** terraform/**"   additional surfaces

set -uo pipefail
cd "$(dirname "$0")/.."

MODE="${1:?usage: drift-audit.sh snapshot|audit}"
BASELINE=ralph/.drift-baseline.json
REPORT=ralph/drift-report.json

run_py() {
  DRIFT_MODE="$MODE" DRIFT_EXTRA_GLOBS="${DRIFT_EXTRA_GLOBS:-}" python3 <<'PY'
import glob, hashlib, json, os, subprocess, datetime, sys

SCHEMA_GLOBS = ['src/lib/db/schema/**', 'prisma/schema.prisma', 'drizzle/**',
                'migrations/**', 'db/migrations/**', 'supabase/migrations/**']
CONFIG_GLOBS = ['*.config.js', '*.config.ts', '*.config.mjs', 'tsconfig.json',
                '.env.example', 'vercel.json', 'wrangler.toml', 'Dockerfile',
                'docker-compose*.yml', '.github/workflows/**']
EXTRA = [g for g in os.environ.get('DRIFT_EXTRA_GLOBS', '').split() if g]

def sh(*args):
    return subprocess.run(args, capture_output=True, text=True).stdout.strip()

def surface_files():
    seen = {}
    for cat, globs in (('schema', SCHEMA_GLOBS), ('config', CONFIG_GLOBS + EXTRA)):
        for g in globs:
            for f in glob.glob(g, recursive=True):
                if os.path.isfile(f):
                    seen[f] = cat
    return seen

def file_sha(path):
    h = hashlib.sha256()
    with open(path, 'rb') as fh:
        h.update(fh.read())
    return h.hexdigest()

def deps():
    try:
        pkg = json.load(open('package.json'))
    except Exception:
        return {}
    out = {}
    for sect in ('dependencies', 'devDependencies'):
        for name, ver in pkg.get(sect, {}).items():
            out[name] = str(ver)
    return out

if os.environ['DRIFT_MODE'] == 'snapshot':
    state = {
        'commit': sh('git', 'rev-parse', 'HEAD'),
        'timestamp': datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
        'deps': deps(),
        'files': {f: {'sha': file_sha(f), 'category': cat}
                  for f, cat in surface_files().items()},
    }
    json.dump(state, open('ralph/.drift-baseline.json', 'w'), indent=2)
    print(f"[drift] baseline: {len(state['deps'])} deps, {len(state['files'])} surface files @ {state['commit'][:8]}")
    sys.exit(0)

# ── audit ────────────────────────────────────────────────────────────────────
try:
    base = json.load(open('ralph/.drift-baseline.json'))
except Exception:
    print('[drift] no baseline — run `drift-audit.sh snapshot` at run start. Skipping.')
    sys.exit(0)

def story_commits_for(path):
    """Story ids whose RALPH:/QA: commits touched path since the baseline."""
    log = sh('git', 'log', f"{base['commit']}..HEAD", '--format=%s', '--', path)
    ids = set()
    for line in log.splitlines():
        for prefix in ('RALPH: ', 'QA: '):
            if line.startswith(prefix):
                ids.add(line[len(prefix):].split(' ')[0].split(':')[0].rstrip(' —-'))
    return sorted(ids)

contracts = {}
for f in glob.glob('ralph/contracts/*.contract.md'):
    sid = os.path.basename(f).replace('.contract.md', '')
    contracts[sid] = open(f, errors='replace').read().lower()

def authorized(term, stories):
    """A change is attributed if a touching story's contract mentions the term."""
    return [s for s in stories if term.lower() in contracts.get(s, '')]

findings = []
now_deps = deps()
for name, ver in now_deps.items():
    if name not in base['deps']:
        stories = story_commits_for('package.json')
        auth = authorized(name, stories)
        findings.append({'kind': 'dep-added', 'item': f'{name}@{ver}',
                         'stories': stories, 'authorized_by': auth,
                         'attributed': bool(auth)})
    elif base['deps'][name] != ver:
        findings.append({'kind': 'dep-version-changed', 'item': f'{name}: {base["deps"][name]} -> {ver}',
                         'stories': story_commits_for('package.json'),
                         'authorized_by': [], 'attributed': True})  # version bumps are routine
for name in base['deps']:
    if name not in now_deps:
        findings.append({'kind': 'dep-removed', 'item': name,
                         'stories': story_commits_for('package.json'),
                         'authorized_by': [], 'attributed': False})

now_files = surface_files()
for f, cat in now_files.items():
    sha = file_sha(f)
    old = base['files'].get(f)
    if old is None:
        kind = f'{cat}-file-added'
    elif old['sha'] != sha:
        kind = f'{cat}-file-changed'
    else:
        continue
    stories = story_commits_for(f)
    # A schema change is authorized if the touching story's contract mentions
    # the file, its name, or schema work at all. Config stays strict: configs
    # are T0-locked, so ANY config drift defaults to suspicious.
    terms = [os.path.basename(f).split('.')[0], f]
    if cat == 'schema':
        terms += ['schema', 'migration']
    auth = sorted({s for t in terms for s in authorized(t, stories)})
    findings.append({'kind': kind, 'item': f, 'stories': stories,
                     'authorized_by': auth, 'attributed': bool(auth)})
for f in base['files']:
    if f not in now_files:
        findings.append({'kind': 'surface-file-removed', 'item': f,
                         'stories': story_commits_for(f),
                         'authorized_by': [], 'attributed': False})

unattributed = [x for x in findings if not x['attributed']]
report = {
    'baseline_commit': base['commit'],
    'audited_at': datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
    'findings': findings,
    'unattributed_count': len(unattributed),
}
json.dump(report, open('ralph/drift-report.json', 'w'), indent=2)

print(f"[drift] {len(findings)} change(s) across deps/schema/config, {len(unattributed)} UNATTRIBUTED")
for x in unattributed:
    stories = ','.join(x['stories']) or 'no story commit'
    print(f"[drift]   UNATTRIBUTED {x['kind']}: {x['item']} (touched by: {stories})")
sys.exit(1 if unattributed else 0)
PY
}

run_py
RC=$?

if [ "$MODE" = "audit" ] && [ "$RC" -eq 1 ] && [ -x ./ralph/gh-state.sh ]; then
  ./ralph/gh-state.sh note "**Drift audit:** unattributed changes to deps/schema/config — see drift-report.json. Review in /morning-review." "ralph/drift-report.json" || true
fi
exit "$RC"
