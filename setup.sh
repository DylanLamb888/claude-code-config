#!/bin/bash
# Claude Code Configuration Setup Script
# Installs all Claude Code configuration files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code configuration..."
echo ""

# Create directories
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/ralph"

# Backup and copy main settings
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "Backing up existing settings.json..."
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup"
fi
cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
echo "[+] settings.json"

# Copy CLAUDE.md
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "[+] CLAUDE.md"

# Copy instruction files
cp "$SCRIPT_DIR/ralph-instructions.md" "$CLAUDE_DIR/ralph-instructions.md"
echo "[+] ralph-instructions.md"

cp "$SCRIPT_DIR/feedback-loops.md" "$CLAUDE_DIR/feedback-loops.md"
echo "[+] feedback-loops.md"

cp "$SCRIPT_DIR/husky-setup.md" "$CLAUDE_DIR/husky-setup.md"
echo "[+] husky-setup.md"

# Copy MCP config
if [ -f "$HOME/.mcp.json" ]; then
    echo "Backing up existing .mcp.json..."
    cp "$HOME/.mcp.json" "$HOME/.mcp.json.backup"
fi
cp "$SCRIPT_DIR/.mcp.json" "$HOME/.mcp.json"
echo "[+] .mcp.json"

# Copy hooks
for hook in "$SCRIPT_DIR/hooks/"*.sh; do
    cp "$hook" "$CLAUDE_DIR/hooks/"
    chmod +x "$CLAUDE_DIR/hooks/$(basename "$hook")"
    echo "[+] hooks/$(basename "$hook")"
done

# Copy commands
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    cp "$cmd" "$CLAUDE_DIR/commands/"
    echo "[+] commands/$(basename "$cmd")"
done

# Copy agents
for agent in "$SCRIPT_DIR/agents/"*.md; do
    cp "$agent" "$CLAUDE_DIR/agents/"
    echo "[+] agents/$(basename "$agent")"
done

# Copy skills (with subdirectories)
for skill_dir in "$SCRIPT_DIR/skills/"*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/"
    echo "[+] skills/$skill_name/"
done

# Copy ralph scripts and files
for ralph_file in "$SCRIPT_DIR/ralph/"*; do
    cp "$ralph_file" "$CLAUDE_DIR/ralph/"
    filename=$(basename "$ralph_file")
    if [[ "$filename" == *.sh ]]; then
        chmod +x "$CLAUDE_DIR/ralph/$filename"
    fi
    echo "[+] ralph/$filename"
done

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Installed to ~/.claude/:"
echo "  - Core: CLAUDE.md, settings.json"
echo "  - Docs: ralph-instructions.md, feedback-loops.md, husky-setup.md"
echo "  - Hooks: $(ls "$SCRIPT_DIR/hooks/"*.sh 2>/dev/null | wc -l | tr -d ' ') scripts"
echo "  - Commands: $(ls "$SCRIPT_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ') commands"
echo "  - Skills: $(ls -d "$SCRIPT_DIR/skills/"*/ 2>/dev/null | wc -l | tr -d ' ') skills"
echo "  - Agents: $(ls "$SCRIPT_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ') agents"
echo "  - Ralph: scripts and examples"
echo ""
echo "Installed to ~/:"
echo "  - .mcp.json"
echo ""
echo "Restart Claude Code to apply changes."
