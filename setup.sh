#!/bin/bash
# Claude Code Configuration Setup Script
# This script installs your Claude Code configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code configuration..."

# Create directories
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"

# Copy settings (with backup)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "Backing up existing settings.json..."
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup"
fi
cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
echo "Installed settings.json"

# Copy MCP config
if [ -f "$HOME/.mcp.json" ]; then
    echo "Backing up existing .mcp.json..."
    cp "$HOME/.mcp.json" "$HOME/.mcp.json.backup"
fi
cp "$SCRIPT_DIR/.mcp.json" "$HOME/.mcp.json"
echo "Installed .mcp.json"

# Copy hooks
cp "$SCRIPT_DIR/hooks/"*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/"*.sh
echo "Installed hooks"

# Copy skills
for skill_dir in "$SCRIPT_DIR/skills/"*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/"
done
echo "Installed skills"

# Copy commands
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_DIR/commands/"
echo "Installed commands"

echo ""
echo "Setup complete!"
echo ""
echo "Installed:"
echo "  - settings.json"
echo "  - .mcp.json"
echo "  - hooks/security-check.sh"
echo "  - hooks/pre-commit-test.sh"
echo "  - hooks/format-typescript.sh"
echo "  - skills/agent-browser"
echo "  - skills/react-best-practices"
echo "  - skills/ui-skills"
echo "  - commands/web-interface-guidelines.md"
echo ""
echo "Restart Claude Code to apply changes."
