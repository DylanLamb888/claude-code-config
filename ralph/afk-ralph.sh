#!/bin/bash
# afk-ralph.sh - Away-from-keyboard Ralph loop with Docker sandbox
# Runs Claude Code in isolated container for safety during unattended execution
#
# Usage: ./afk-ralph.sh <iterations> [prd-file]
#   iterations: Maximum number of loop iterations (required)
#   prd-file: Path to PRD (default: prd.json in current directory)

set -e

# Validate arguments
if [[ -z "$1" ]]; then
    echo "Usage: $0 <iterations> [prd-file]"
    echo "  iterations: Maximum number of loop iterations (required)"
    echo "  prd-file: Path to PRD (default: prd.json)"
    exit 1
fi

MAX_ITERATIONS="$1"
PRD_FILE="${2:-prd.json}"
PROGRESS_FILE="progress.txt"
PROMPT_TEMPLATE="$HOME/.claude/ralph/prompt.md"
ARCHIVE_DIR="archive"

# Validate PRD exists
if [[ ! -f "$PRD_FILE" ]]; then
    echo "Error: PRD file not found: $PRD_FILE"
    exit 1
fi

# Validate prompt template exists
if [[ ! -f "$PROMPT_TEMPLATE" ]]; then
    echo "Error: Prompt template not found: $PROMPT_TEMPLATE"
    echo "Run the Ralph setup or create ~/.claude/ralph/prompt.md"
    exit 1
fi

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    echo "Install Docker Desktop: https://docs.docker.com/desktop/"
    exit 1
fi

# Create progress file if it doesn't exist
if [[ ! -f "$PROGRESS_FILE" ]]; then
    echo "# Ralph Progress Log" > "$PROGRESS_FILE"
    echo "Created: $(date)" >> "$PROGRESS_FILE"
    echo "PRD: $PRD_FILE" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
fi

# Archive previous run if branch changed (requires jq)
if command -v jq &> /dev/null && [[ -f "$PRD_FILE" ]]; then
    BRANCH_NAME=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null)

    if [[ -n "$BRANCH_NAME" ]]; then
        # Check for existing progress with different branch
        if [[ -f "$PROGRESS_FILE" ]]; then
            PREV_BRANCH=$(grep -m1 "^Branch:" "$PROGRESS_FILE" 2>/dev/null | cut -d: -f2 | tr -d ' ' || echo "")
            if [[ -n "$PREV_BRANCH" && "$PREV_BRANCH" != "$BRANCH_NAME" ]]; then
                # Archive previous run
                ARCHIVE_NAME=$(date +%Y-%m-%d)-${PREV_BRANCH//ralph\//}
                mkdir -p "$ARCHIVE_DIR/$ARCHIVE_NAME"
                mv "$PROGRESS_FILE" "$ARCHIVE_DIR/$ARCHIVE_NAME/" 2>/dev/null || true
                echo "Archived previous run to: $ARCHIVE_DIR/$ARCHIVE_NAME/"
            fi
        fi

        # Switch to feature branch
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
        if [[ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]]; then
            echo "Creating/switching to branch: $BRANCH_NAME"
            git checkout -B "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"
        fi

        # Update progress file with branch
        if ! grep -q "^Branch:" "$PROGRESS_FILE" 2>/dev/null; then
            sed -i '' "3i\\
Branch: $BRANCH_NAME\\
" "$PROGRESS_FILE" 2>/dev/null || echo "Branch: $BRANCH_NAME" >> "$PROGRESS_FILE"
        fi
    fi
fi

echo "=========================================="
echo "Ralph AFK Loop - Docker Sandbox"
echo "PRD: $PRD_FILE"
echo "Max iterations: $MAX_ITERATIONS"
echo "Progress: $PROGRESS_FILE"
echo "=========================================="
echo ""
echo "Starting at: $(date)"
echo ""

# Read prompt template content
PROMPT_CONTENT=$(cat "$PROMPT_TEMPLATE")

# Main loop
for ((i=1; i<=MAX_ITERATIONS; i++)); do
    echo "----------------------------------------"
    echo "Iteration $i of $MAX_ITERATIONS"
    echo "Started: $(date)"
    echo "----------------------------------------"

    # Run Claude in Docker sandbox with print mode
    result=$(docker sandbox run claude --permission-mode acceptEdits -p \
"$PROMPT_CONTENT

---
# PRD
$(cat "$PRD_FILE")

---
# Progress
$(cat "$PROGRESS_FILE")
" 2>&1) || true

    echo "$result"

    # Check for completion signal
    if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
        echo ""
        echo "=========================================="
        echo "PRD COMPLETE after $i iterations!"
        echo "Finished: $(date)"
        echo "=========================================="

        # Terminal notification
        printf '\a'
        echo -e "\n\033[1;32mRalph has finished!\033[0m"

        exit 0
    fi

    echo ""
done

echo "=========================================="
echo "Max iterations ($MAX_ITERATIONS) reached"
echo "Finished: $(date)"
echo "Review progress.txt and prd.json for status"
echo "=========================================="

# Terminal notification
printf '\a'
echo -e "\n\033[1;33mRalph reached iteration limit.\033[0m"
