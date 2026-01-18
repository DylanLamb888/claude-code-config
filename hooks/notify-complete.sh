#!/bin/bash
# Notification hook: Sends macOS notification when long-running commands complete
# Useful for AFK/Ralph loops

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')
exit_code=$(echo "$input" | jq -r '.tool_result.exit_code // 0')
stdout=$(echo "$input" | jq -r '.tool_result.stdout // empty' | head -c 100)

# Commands that warrant notification
notify_commands=("npm test" "npm run build" "npm run typecheck" "bun test" "bun run build" "pytest" "go test" "cargo build" "cargo test")

should_notify=false
for cmd in "${notify_commands[@]}"; do
  if [[ $command == *"$cmd"* ]]; then
    should_notify=true
    break
  fi
done

if [[ "$should_notify" == "true" ]]; then
  if [[ "$exit_code" == "0" ]]; then
    osascript -e "display notification \"$command\" with title \"✓ Command Succeeded\" sound name \"Glass\""
  else
    osascript -e "display notification \"$command\" with title \"❌ Command Failed\" sound name \"Basso\""
  fi
fi

exit 0
