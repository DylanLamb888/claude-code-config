#!/bin/bash
# Auto-format hook: Runs Prettier on TypeScript/JavaScript files after write/edit
# Ensures consistent code style across all your projects

file_path=$(cat | jq -r '.tool_input.file_path // empty')

# Only format TypeScript and JavaScript files
if [[ ! $file_path =~ \.(ts|tsx|js|jsx|mjs|cjs)$ ]]; then
  exit 0
fi

# Check if file exists
if [[ ! -f "$file_path" ]]; then
  exit 0
fi

# Try to format with prettier if available
if command -v npx &> /dev/null; then
  # Check if prettier is available in the project
  if npx prettier --version &> /dev/null; then
    npx prettier --write "$file_path" 2>/dev/null
    if [[ $? -eq 0 ]]; then
      echo "Formatted: $file_path"
    fi
  fi
fi

exit 0
