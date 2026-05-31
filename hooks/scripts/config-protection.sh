#!/bin/bash
# Config Protection Hook (PreToolUse → Edit)
#
# Prevents Claude from weakening linter/formatter/TypeScript configs.
# A classic agent failure mode: it "fixes" errors by loosening the rules.
# This hook blocks that pattern.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Edit" ]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_NAME=$(basename "$FILE_PATH" 2>/dev/null)

# Protected config files
PROTECTED_CONFIGS="tsconfig.json .eslintrc .eslintrc.js .eslintrc.json eslint.config.js eslint.config.mjs .prettierrc .prettierrc.json prettier.config.js biome.json"

IS_PROTECTED=false
for config in $PROTECTED_CONFIGS; do
  if [ "$FILE_NAME" = "$config" ]; then
    IS_PROTECTED=true
    break
  fi
done

if [ "$IS_PROTECTED" = false ]; then
  # Phase-based file locking for autoresearch improvement loops
  # Fast path: skip if no active lazy-dev state
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
  LAZY_STATE="$PROJECT_DIR/.quality/goals/lazy-dev-state.md"
  if [ -f "$LAZY_STATE" ]; then
    ACTIVE_PHASE=$(grep "| in-progress |" "$LAZY_STATE" 2>/dev/null | head -1 | sed 's/.*| \([^ ]*\) |.*/\1/' | tr -d ' ')
    if [ -n "$ACTIVE_PHASE" ]; then
      case "$ACTIVE_PHASE" in
        coverage|mutation)
          # Test phase: block source edits
          if echo "$FILE_PATH" | grep -qE '/(src|app|lib|components)/'; then
            if ! echo "$FILE_PATH" | grep -qE '\.(test|spec)\.(ts|tsx|js|jsx)$'; then
              echo "PHASE LOCK: $ACTIVE_PHASE phase — source files are READ-ONLY. Edit tests only." >&2
              printf '{"permissionDecision":"deny","message":"Phase lock (%s): source files are read-only during test-improvement phases. Edit test files only."}\n' "$ACTIVE_PHASE"
              exit 0
            fi
          fi
          ;;
        tsc-errors|eslint|axe-violations|lighthouse-perf|lighthouse-a11y|playwright-pass)
          # Source phase: block test edits
          if echo "$FILE_PATH" | grep -qE '\.(test|spec)\.(ts|tsx|js|jsx)$|/__tests__/|/tests?/'; then
            echo "PHASE LOCK: $ACTIVE_PHASE phase — test files are READ-ONLY. Edit source only." >&2
            printf '{"permissionDecision":"deny","message":"Phase lock (%s): test files are read-only during source-improvement phases. Edit source files only."}\n' "$ACTIVE_PHASE"
            exit 0
          fi
          ;;
      esac
    fi
  fi
  exit 0
fi

# Check if the edit weakens the config
NEW_STRING=$(echo "$INPUT" | grep -o '"new_string"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1)

# Detect common weakening patterns
WEAKENING=false
REASON=""

# ts-ignore, @ts-nocheck additions
if echo "$NEW_STRING" | grep -qi "ts-ignore\|ts-nocheck\|ts-expect-error"; then
  WEAKENING=true
  REASON="Adding TypeScript suppression comments"
fi

# eslint-disable additions
if echo "$NEW_STRING" | grep -qi "eslint-disable"; then
  WEAKENING=true
  REASON="Disabling ESLint rules"
fi

# Changing strict to false
if echo "$NEW_STRING" | grep -qi '"strict"[[:space:]]*:[[:space:]]*false'; then
  WEAKENING=true
  REASON="Disabling strict mode"
fi

# Changing noEmit or skipLibCheck
if echo "$NEW_STRING" | grep -qi '"skipLibCheck"[[:space:]]*:[[:space:]]*true'; then
  WEAKENING=true
  REASON="Enabling skipLibCheck bypasses type safety"
fi

if [ "$WEAKENING" = true ]; then
  echo "CONFIG PROTECTION: Blocked edit to $FILE_NAME" >&2
  echo "Reason: $REASON" >&2
  echo "Fix the code, not the config." >&2
  cat <<GATE
{"permissionDecision":"deny","message":"Config Protection: $REASON in $FILE_NAME. Fix the code instead of weakening the config."}
GATE
  exit 0
fi

# Allow non-weakening config edits
exit 0
