# Ralph for Claude Code

Autonomous AI coding loops using Claude Code. Run the same prompt repeatedly - Claude picks tasks from a PRD, implements them, commits, and continues until done.

## Quick Start

1. **Create a PRD** (in your project directory):
   ```bash
   claude
   # Type: /prd
   ```

2. **Convert to JSON**:
   ```bash
   # In claude, type: /ralph
   ```

3. **Run Ralph**:
   ```bash
   # HITL (watch and intervene)
   ~/.claude/ralph/ralph-once.sh

   # AFK (unattended, Docker sandbox)
   ~/.claude/ralph/afk-ralph.sh 50
   ```

## Scripts

### ralph-once.sh (HITL)
Single iteration with native Claude Code. Watch what happens, then run again.

```bash
~/.claude/ralph/ralph-once.sh [prd-file]
```

- Uses `--permission-mode acceptEdits`
- Auto-creates/switches to branch from PRD
- Good for learning and prompt refinement

### afk-ralph.sh (AFK)
Loop with Docker sandbox for unattended execution.

```bash
~/.claude/ralph/afk-ralph.sh <iterations> [prd-file]
```

- Runs in isolated Docker container
- Archives previous runs when branch changes
- Exits early on `<promise>COMPLETE</promise>`
- Terminal bell notification when done

## Commands

### /prd
Interactive PRD generation. Asks about your feature, explores the codebase, and creates a structured PRD at `tasks/prd-[feature].md`.

### /ralph
Converts markdown PRD to JSON format (`prd.json`) for Ralph execution.

## Files

| File | Purpose |
|------|---------|
| `prompt.md` | Instructions sent to Claude each iteration |
| `prd.json.example` | Example JSON PRD format |
| `prd.md.example` | Example markdown PRD format |

## PRD Format (JSON)

```json
{
  "project": "Feature Name",
  "branchName": "ralph/feature-name",
  "description": "What the feature does",
  "userStories": [
    {
      "id": "US-001",
      "title": "Story title",
      "description": "As a user, I want...",
      "acceptanceCriteria": ["Criterion 1", "Typecheck passes"],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## How It Works

Each iteration:
1. Reads PRD and progress.txt
2. Finds highest-priority incomplete story
3. Implements it
4. Runs feedback loops (typecheck, test, lint)
5. Commits on success
6. Sets `passes: true` in PRD
7. Appends learnings to progress.txt
8. Repeats until all stories pass or max iterations reached

## Tips

- **Start with HITL** to refine your prompt before going AFK
- **Keep stories small** - one context window max
- **Prioritize risky work first** - architectural decisions, integrations
- **Define explicit stop conditions** - vague PRDs lead to endless loops
- **Use feedback loops** - typecheck, test, lint before every commit

## Add to PATH (optional)

```bash
echo 'export PATH="$HOME/.claude/ralph:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then run from anywhere:
```bash
ralph-once.sh
afk-ralph.sh 50
```

## References

- [Ralph Wiggum](https://ghuntley.com/ralph/) - Original technique by Geoffrey Huntley
- [11 Tips for AI Coding with Ralph](https://www.aihero.dev/tips-for-ai-coding-with-ralph-wiggum) - Matt Pocock
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
