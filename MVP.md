# MVP: Flexible Multi-CLI AI Workflow System

## Goals

1. Create universal AGENT.md that works with any CLI/IDE
2. Trim CLAUDE.md to Claude-specific configuration only
3. Update documentation for clarity
4. Remove dead references to deleted features

## Key Features

### 1. Universal AGENT.md (~300 lines)
- Development principles (YAGNI, KISS, DRY)
- Task-driven workflow pattern
- RAG research workflow
- Error handling patterns
- Decision-making framework
- Command reference

### 2. Lean CLAUDE.md (~150 lines)
- Archon-first rule
- TodoWrite override
- Claude-specific MCP syntax
- Claude Code settings

### 3. Clear Documentation
- README.md with 5-minute setup
- MCP addition guide
- Command usage examples

## Success Criteria

| Metric | Target |
|--------|--------|
| AGENT.md lines | ~300 |
| CLAUDE.md lines | ~150 |
| Setup time | < 5 minutes |
| Commands work | 100% |

## Out of Scope

- Performance optimization features (removed)
- Analytics dashboard (removed)
- Caching system (removed)
- Multi-agent adapters (future)

## Architecture

```
AGENT.md              - Universal (any CLI)
CLAUDE.md             - Claude Code specific
.claude/commands/     - Workflow commands
.mcp.json             - MCP servers
```

## Tasks

1. Extract universal content → AGENT.md
2. Trim CLAUDE.md → Remove dead sections
3. Update README.md → Setup guide
4. Clean command files → Remove dead refs
5. Test full workflow → Verify functionality

## Timeline

Single sprint - estimated 4-6 tasks
