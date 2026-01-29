# AI Coding Workflow System

Markdown-based command system for orchestrating AI-assisted development workflows through MCP integration.

## Structure

```
.claude/commands/   - Workflow commands
CLAUDE.md           - Developer guidelines (Archon integration)
.mcp.json           - MCP server config
```

## Commands

| Command | Description | Phase |
|---------|-------------|-------|
| `/prime` | Export codebase for context gathering | Prime |
| `/discovery` | Explore ideas and opportunities | Discovery |
| `/planning {feature}` | Generate PRD from discovery | Planning |
| `/development {feature}` | Generate tech spec from PRD | Development |
| `/task-planning {feature}` | Generate PRP and create tasks | Task Planning |
| `/execution {feature}` | Execute tasks sequentially | Execution |
| `/review {feature}` | Run code review | Review |
| `/test {feature}` | Run tests with AI-suggested fixes | Test |
| `/workflow {feature}` | Execute full workflow | All phases |
| `/learn {topic}` | Search, digest, and store coding insights | Independent |
| `/learn-health` | Check reference library health | Independent |
| `/check` | Codebase health check and cleanup | Utility |

## Quick Start

1. `/prime` - Export codebase context
2. `/discovery` - Explore opportunities
3. `/planning {feature}` - Create PRD
4. `/development {feature}` - Create tech spec
5. `/task-planning {feature}` - Create implementation plan
6. `/execution {feature}` - Implement tasks
7. `/review {feature}` - Review code
8. `/test {feature}` - Run tests

Or run `/workflow {feature}` to execute all phases automatically.

## Archon Integration

This system uses Archon MCP for task management. See `CLAUDE.md` for workflow details.

**Task Flow**: `todo` → `doing` → `review` → `done`

## Version

**Last Updated**: 2026-01-28
