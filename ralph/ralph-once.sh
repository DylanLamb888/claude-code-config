#!/bin/bash
# ralph-once.sh - Human-in-the-loop Ralph iteration
# Run a single iteration, watch what happens, then run again
#
# Usage: ./ralph-once.sh [prd-file]
#   prd-file: Path to PRD (default: prd.json in current directory)

set -e

PRD_FILE="${1:-prd.json}"
PROGRESS_FILE="progress.txt"
PROMPT_TEMPLATE="$HOME/.claude/ralph/prompt.md"

# Validate PRD exists
if [[ ! -f "$PRD_FILE" ]]; then
    echo "Error: PRD file not found: $PRD_FILE"
    echo "Usage: $0 [prd-file]"
    exit 1
fi

# Create progress file if it doesn't exist
if [[ ! -f "$PROGRESS_FILE" ]]; then
    echo "# Ralph Progress Log" > "$PROGRESS_FILE"
    echo "Created: $(date)" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
fi

# Check for branchName in PRD and create/switch branch if needed
if command -v jq &> /dev/null && [[ -f "$PRD_FILE" ]]; then
    BRANCH_NAME=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null)
    if [[ -n "$BRANCH_NAME" ]]; then
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
        if [[ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]]; then
            echo "Switching to branch: $BRANCH_NAME"
            git checkout -B "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"
        fi
    fi
fi

echo "=========================================="
echo "Ralph HITL - Single Iteration"
echo "PRD: $PRD_FILE"
echo "Progress: $PROGRESS_FILE"
echo "=========================================="
echo ""

# Run Claude Code with acceptEdits permission mode
claude --permission-mode acceptEdits \
    "@$PROMPT_TEMPLATE" \
    "@$PRD_FILE" \
    "@$PROGRESS_FILE"

echo ""
echo "=========================================="
echo "Iteration complete. Run again with: $0 $PRD_FILE"
echo "=========================================="
