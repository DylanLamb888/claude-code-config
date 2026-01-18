# Claude Code Configuration

Personal Claude Code configuration for portable workflows. Includes settings, hooks, skills, commands, agents, MCP servers, and Ralph autonomous coding loop.

## Quick Setup

```bash
git clone https://github.com/DylanLamb888/claude-code-config.git
cd claude-code-config
./setup.sh
```

## What's Included

### Core Config Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions for Claude Code (code quality, plan mode, Ralph) |
| `settings.json` | Permissions, hooks, enabled plugins |
| `.mcp.json` | MCP server configurations |
| `ralph-instructions.md` | Instructions for Ralph autonomous loops |
| `feedback-loops.md` | Language-specific feedback commands |
| `husky-setup.md` | Husky + lint-staged setup guide |

### Hooks (`hooks/`)

Pre and post tool-use hooks for quality gates and automation.

| Hook | Trigger | Purpose |
|------|---------|---------|
| `security-check.sh` | PreToolUse (Bash) | Blocks commits with sensitive data patterns |
| `pre-commit-test.sh` | PreToolUse (Bash) | Runs tests before git commits |
| `typecheck-pre-commit.sh` | PreToolUse (Bash) | Runs TypeScript check before commits |
| `branch-protection.sh` | PreToolUse (Bash) | Prevents direct commits to main/master |
| `format-typescript.sh` | PostToolUse (Write/Edit) | Auto-formats TS/JS with Prettier |
| `lint-on-write.sh` | PostToolUse (Write/Edit) | Runs ESLint on edited files |
| `notify-complete.sh` | PostToolUse (Bash) | macOS notification on long command completion |

### Commands (`commands/`)

Custom slash commands for common workflows.

| Command | Description |
|---------|-------------|
| `/prd` | Interactive PRD generation for Ralph loops |
| `/ralph` | Convert markdown PRD to JSON for Ralph |
| `/preflight` | Run all verification checks before commit |
| `/self-review` | Review staged changes for common issues |
| `/verify-build` | Run build and report errors |
| `/verify-ui` | Screenshot and check for visual issues |
| `/check-console` | Read browser console for errors |

### Skills (`skills/`)

Specialized knowledge and guidelines.

| Skill | Description |
|-------|-------------|
| `agent-browser` | Browser automation with agent-browser CLI |
| `react-best-practices` | 40+ React/Next.js performance rules from Vercel |
| `ui-skills` | Opinionated UI constraints (Tailwind, animations, components) |
| `web-design-guidelines` | Review UI code against Web Interface Guidelines |

### Agents (`agents/`)

Custom agent definitions.

| Agent | Description |
|-------|-------------|
| `code-improver` | Code review for readability, performance, best practices |

### Ralph (`ralph/`)

Autonomous AI coding loop for completing PRDs.

| File | Description |
|------|-------------|
| `afk-ralph.sh` | AFK loop with Docker sandbox (unattended) |
| `ralph-once.sh` | HITL single iteration (watch and intervene) |
| `prompt.md` | Instructions sent to Claude each iteration |
| `prd.json.example` | Example JSON PRD format |
| `prd.md.example` | Example markdown PRD format |
| `README.md` | Ralph usage documentation |

## Settings Overview

### Allowed Permissions

```json
{
  "permissions": {
    "allow": [
      "WebSearch", "WebFetch",
      "Bash(npm run:*)", "Bash(npm test:*)", "Bash(npm install:*)",
      "Bash(git add:*)", "Bash(git commit:*)", "Bash(git push:*)",
      "Bash(git status:*)", "Bash(git diff:*)", "Bash(git log:*)",
      "Bash(npx prettier:*)", "Bash(npx eslint:*)"
    ],
    "deny": [
      "Read(.env)", "Read(.env.*)", "Read(**/secrets/**)"
    ]
  }
}
```

### Enabled Plugins

- `frontend-design` - Frontend design assistance
- `context7` - Documentation lookup
- `github` - GitHub integration
- `feature-dev` - Feature development workflow
- `code-review` - Code review assistance
- `commit-commands` - Git commit helpers
- `playwright` - Browser testing
- `agent-sdk-dev` - Agent SDK development
- `security-guidance` - Security best practices
- `Notion` - Notion integration
- `vercel` - Vercel deployment

### MCP Servers

- `chrome-devtools` - Chrome DevTools integration for browser automation

## Ralph Workflow

Ralph is an autonomous coding loop that works through PRDs.

### Quick Start

1. Create a PRD: `claude` then type `/prd`
2. Convert to JSON: `/ralph`
3. Run Ralph:
   - HITL: `~/.claude/ralph/ralph-once.sh`
   - AFK: `~/.claude/ralph/afk-ralph.sh 50`

### How It Works

Each iteration:
1. Reads PRD and progress.txt
2. Finds highest-priority incomplete story
3. Implements it
4. Runs feedback loops (typecheck, test, lint)
5. Commits on success
6. Sets `passes: true` in PRD
7. Repeats until all stories pass

## Manual Installation

### All Files

```bash
# Core configs
cp CLAUDE.md ~/.claude/
cp settings.json ~/.claude/
cp ralph-instructions.md ~/.claude/
cp feedback-loops.md ~/.claude/
cp husky-setup.md ~/.claude/
cp .mcp.json ~/

# Hooks
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Commands
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Skills
cp -r skills/* ~/.claude/skills/

# Agents
mkdir -p ~/.claude/agents
cp agents/*.md ~/.claude/agents/

# Ralph
mkdir -p ~/.claude/ralph
cp ralph/*.sh ~/.claude/ralph/
cp ralph/*.md ~/.claude/ralph/
cp ralph/*.example ~/.claude/ralph/
chmod +x ~/.claude/ralph/*.sh
```

## Customization

### Adding Hooks

1. Create `hooks/your-hook.sh`
2. Add to `settings.json` under `hooks.PreToolUse` or `hooks.PostToolUse`
3. Make executable: `chmod +x hooks/your-hook.sh`

### Adding Skills

1. Create `skills/your-skill/SKILL.md`
2. Add frontmatter: `name`, `description`
3. Add skill content

### Adding Commands

1. Create `commands/your-command.md`
2. Commands are available as `/your-command`

### Adding Agents

1. Create `agents/your-agent.md`
2. Add frontmatter: `name`, `description`, `tools`, `model`
3. Add agent instructions

## Syncing Changes

```bash
cd ~/claude-code-config
git pull
./setup.sh
```

## License

MIT
