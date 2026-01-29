# AI Coding Workflow System

Markdown-based command system for AI-assisted development with MCP integration.

## Quick Start (5 minutes)

### 1. Prerequisites
- [Claude Code CLI](https://claude.ai/code) (or compatible AI CLI)
- Archon MCP server access

### 2. Clone & Configure
```bash
git clone <repo-url>
cd ai-coding-template
```

### 3. Configure MCP Servers
Edit `.mcp.json` with your server URLs:
```json
{
  "mcpServers": {
    "archon": {
      "type": "http",
      "url": "https://your-archon-server/mcp"
    }
  }
}
```

### 4. Verify Connection
```bash
# In Claude Code, check Archon health
health_check()
```

### 5. Start Building
```bash
/discovery
```

## Commands

| Command | Description |
|---------|-------------|
| `/prime` | Export codebase context |
| `/discovery` | Explore ideas and opportunities |
| `/planning {feature}` | Generate PRD |
| `/development {feature}` | Generate Tech Spec |
| `/task-planning {feature}` | Create PRP + Archon tasks |
| `/execution {feature}` | Execute tasks |
| `/review {feature}` | Code review |
| `/test {feature}` | Run tests |
| `/workflow {feature}` | Full pipeline |
| `/learn {topic}` | Store coding insights |
| `/learn-health` | Check reference library |
| `/check` | Health check & cleanup |

## Workflow

```
/discovery → /planning → /development → /task-planning → /execution → /review → /test
```

Or run all at once:
```bash
/workflow {feature-name}
```

## Project Structure

```
AGENT.md              # Universal instructions (any CLI)
CLAUDE.md             # Claude Code specific config
INDEX.md              # Navigation
.mcp.json             # MCP server configuration
.claude/commands/     # Workflow command files
```

## Key Concepts

### Task-Driven Development
1. Get task from Archon → `find_tasks(status="todo")`
2. Mark as doing → `manage_task(status="doing")`
3. Implement
4. Mark for review → `manage_task(status="review")`
5. Next task

### PIV Loop
- **P**urpose: `/discovery` → `/planning` → `/development`
- **I**mplementation: `/task-planning` → `/execution`
- **V**alidation: `/review` → `/test`

## Adding MCP Servers

Edit `.mcp.json`:
```json
{
  "mcpServers": {
    "your-server": {
      "type": "http",
      "url": "http://localhost:8000/mcp"
    }
  }
}
```

## Documentation

- [AGENT.md](./AGENT.md) - Universal agent instructions
- [CLAUDE.md](./CLAUDE.md) - Claude Code configuration
- [INDEX.md](./INDEX.md) - Command reference

## License

MIT
