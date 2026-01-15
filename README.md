# Claude Code Configuration

Personal Claude Code configuration including settings, hooks, skills, commands, and MCP servers.

## Quick Setup

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-code-config.git
cd claude-code-config

# Run the setup script
./setup.sh
```

## Manual Setup

### 1. Settings

Copy the main settings file:

```bash
cp settings.json ~/.claude/settings.json
```

**Note:** If you have existing settings, merge them manually to preserve any project-specific configurations.

### 2. MCP Servers

Copy the MCP configuration to your home directory:

```bash
cp .mcp.json ~/.mcp.json
```

### 3. Hooks

Copy hook scripts and make them executable:

```bash
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

### 4. Skills

Copy skill directories:

```bash
cp -r skills/* ~/.claude/skills/
```

### 5. Commands

Copy custom commands:

```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/
```

## What's Included

### Settings (`settings.json`)

- **Permissions**: Pre-approved commands for common operations (git, npm, prettier, eslint)
- **Denied patterns**: Blocks reading `.env` files and secrets
- **Enabled plugins**: Full list of official Claude plugins
- **Hook configurations**: Pre and post tool-use hooks

### Hooks (`hooks/`)

| Hook | Trigger | Purpose |
|------|---------|---------|
| `security-check.sh` | PreToolUse (Bash) | Blocks commits containing sensitive data patterns |
| `pre-commit-test.sh` | PreToolUse (Bash) | Runs tests before allowing git commits |
| `format-typescript.sh` | PostToolUse (Write/Edit) | Auto-formats TS/JS files with Prettier |

### Skills (`skills/`)

| Skill | Description |
|-------|-------------|
| `agent-browser` | Browser automation for web testing and interaction |
| `react-best-practices` | React/Next.js performance optimization guidelines |
| `ui-skills` | Opinionated constraints for building better UIs |

### Commands (`commands/`)

| Command | Description |
|---------|-------------|
| `web-interface-guidelines` | Reviews UI code for Vercel Web Interface Guidelines compliance |

### MCP Servers (`.mcp.json`)

| Server | Description |
|--------|-------------|
| `chrome-devtools` | Chrome DevTools integration for browser automation |

## Enabled Plugins

This config enables the following official plugins:

- `frontend-design` - Frontend design assistance
- `context7` - Documentation lookup
- `github` - GitHub integration
- `feature-dev` - Feature development workflow
- `code-review` - Code review assistance
- `commit-commands` - Git commit helpers
- `playwright` - Browser testing
- `supabase` - Supabase integration
- `agent-sdk-dev` - Agent SDK development
- `figma` - Figma design integration
- `security-guidance` - Security best practices
- `typescript-lsp` - TypeScript language server
- `explanatory-output-style` - Educational output mode
- `Notion` - Notion integration
- `hookify` - Hook creation helper
- `vercel` - Vercel deployment
- `ralph-loop` - Ralph Loop workflow
- `stripe` - Stripe integration
- `gopls-lsp` - Go language server
- `pyright-lsp` - Python language server

## Customization

### Adding New Hooks

1. Create a new `.sh` file in `hooks/`
2. Add the hook configuration to `settings.json` under `hooks.PreToolUse` or `hooks.PostToolUse`
3. Make the script executable: `chmod +x hooks/your-hook.sh`

### Adding New Skills

1. Create a new directory in `skills/`
2. Add a `SKILL.md` file with frontmatter (name, description) and content

### Adding New Commands

1. Create a new `.md` file in `commands/`
2. Add frontmatter with `description` and optional `argument-hint`

## Syncing Changes

To update your local Claude Code config from this repo:

```bash
cd ~/claude-code-config
git pull
./setup.sh
```

## License

MIT
