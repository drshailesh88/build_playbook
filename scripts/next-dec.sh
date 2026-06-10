#!/usr/bin/env bash
# next-dec.sh — atomically allocate the next DEC id (fixes lacuna L-014)
#
# Two sessions grilling concurrently raced .planning/next-dec-id when each
# read the counter at session start and wrote records later (observed live:
# pathways compile and design-extract both claimed DEC-076..081). The rule
# is allocate-at-write-time, and this helper makes the allocation atomic
# via a portable mkdir lock.
#
# Usage:  scripts/next-dec.sh [count]     # from the project root
#         NEXT=$(./scripts/next-dec.sh)   # allocates 1, prints "DEC-076"
#         ./scripts/next-dec.sh 6         # allocates 6, prints "DEC-076..DEC-081"
#
# The counter file always holds the NEXT unallocated number.

set -euo pipefail

COUNT="${1:-1}"
COUNTER=.planning/next-dec-id
# Same lock dir grill-me's inline protocol uses — one mutex for all writers.
LOCK=.planning/.dec-lock

case "$COUNT" in (*[!0-9]*|'') echo "usage: next-dec.sh [count>=1]" >&2; exit 1;; esac
[ "$COUNT" -ge 1 ] || { echo "usage: next-dec.sh [count>=1]" >&2; exit 1; }
mkdir -p .planning

for _ in $(seq 1 50); do
  if mkdir "$LOCK" 2>/dev/null; then
    trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT
    START=$(cat "$COUNTER" 2>/dev/null || echo 1)
    case "$START" in (*[!0-9]*|'') echo "ERROR: $COUNTER is corrupt: '$START'" >&2; exit 1;; esac
    echo $((START + COUNT)) > "$COUNTER"
    if [ "$COUNT" -eq 1 ]; then
      printf 'DEC-%03d\n' "$START"
    else
      printf 'DEC-%03d..DEC-%03d\n' "$START" $((START + COUNT - 1))
    fi
    exit 0
  fi
  sleep 0.2
done

echo "ERROR: could not acquire $LOCK after 10s — another session is allocating. Retry, or remove a stale lock if no session is running." >&2
exit 1
