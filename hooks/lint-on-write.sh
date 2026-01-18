#!/bin/bash
# Lint hook: Runs ESLint on files after write/edit
# Shows issues but doesn't block (informational)

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Only lint TypeScript and JavaScript files
if [[ ! $file_path =~ \.(ts|tsx|js|jsx)$ ]]; then
  exit 0
fi

# Check if file exists
if [[ ! -f "$file_path" ]]; then
  exit 0
fi

# Check if eslint is available
if ! command -v npx &> /dev/null; then
  exit 0
fi

# Check if project has eslint config
if [[ ! -f ".eslintrc.json" ]] && [[ ! -f ".eslintrc.js" ]] && [[ ! -f ".eslintrc" ]] && [[ ! -f "eslint.config.js" ]] && [[ ! -f "eslint.config.mjs" ]]; then
  exit 0
fi

# Run eslint (don't block, just report)
result=$(npx eslint "$file_path" 2>&1)
lint_exit=$?

if [[ $lint_exit -ne 0 ]]; then
  echo "⚠️  Lint issues in $file_path:" >&2
  echo "$result" | head -10 >&2
fi

# Always exit 0 - this is informational, not blocking
exit 0
