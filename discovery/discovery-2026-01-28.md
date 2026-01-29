# Discovery: 2026-01-28

## User Vision & Insights

### Vision Statement
Create a flexible AI coding workflow system that works across multiple CLIs/IDEs (Claude Code, Codex, etc.) for building AI agent software. The system should be easy to update, extend with new MCPs, and follow best practices.

### Key Challenges
1. **CLAUDE.md is too long** (653 lines) - needs YAGNI applied
2. **System is too Claude-specific** - needs universal AGENT.md
3. **References deleted features** - analytics, benchmark, profile, preprocess commands
4. **MCP integration not obvious** - should be easier to add new servers
5. **Best practices not enforced** - /learn not utilized enough

### Ideas & Requests
1. Add AGENT.md for universal agent instructions (CLI-agnostic)
2. Trim CLAUDE.md to Claude-specific config only
3. Update README.md with clear explanations
4. Make MCP addition workflow obvious
5. Better /learn command utilization

### Success Criteria
- System works with multiple CLIs (Claude Code, Codex, future tools)
- CLAUDE.md under 200 lines (Claude-specific only)
- AGENT.md contains universal workflow (~300 lines)
- Easy to add new MCP servers
- Clear documentation for new users

## Codebase Analysis

### Current Structure
```
.claude/commands/   - 12 workflow commands (~164KB)
CLAUDE.md           - 653 lines (TOO LONG)
INDEX.md            - Navigation
README.md           - Project docs
.mcp.json           - MCP config
```

### Problems Identified

| Issue | Lines | Problem |
|-------|-------|---------|
| Usage Analytics Dashboard | 338-399 | References removed `/analytics` command |
| Performance Optimization | 400-575 | References removed `/profile`, `/benchmark`, `/preprocess` |
| Caching section | 431-466 | References `.auto-claude/` which we deleted |
| Migration Guide | 568 | References deleted file |

### What Works Well
- Core workflow commands (12 commands)
- Archon MCP integration
- Task-driven development pattern
- PIV Loop methodology
- /learn and /learn-health commands

## Opportunities

### High Priority

| Opportunity | Impact | Effort | Description |
|------------|--------|--------|-------------|
| Create AGENT.md | High | Medium | Universal agent instructions for any CLI |
| Trim CLAUDE.md | High | Low | Remove dead sections, keep Claude-specific only |
| Update README.md | Medium | Low | Clear setup/usage guide |

### Medium Priority

| Opportunity | Impact | Effort | Description |
|------------|--------|--------|-------------|
| MCP Setup Guide | Medium | Low | Document how to add new MCP servers |
| /learn utilization | Medium | Medium | Pre-populate reference library |
| Command docs cleanup | Medium | Low | Update command files to remove dead refs |

## Recommended Architecture

### File Structure (Proposed)
```
AGENT.md              - Universal core (any CLI)
CLAUDE.md             - Claude Code specific (~150 lines)
.codex/               - Future: Codex adapter
.cursor/              - Future: Cursor adapter
.claude/
  commands/           - Workflow commands
  settings.local.json - Permissions
.mcp.json             - MCP servers
```

### AGENT.md Content (Universal)
- Development principles (YAGNI, KISS, DRY)
- Task-driven workflow
- RAG workflow patterns
- Error handling
- Decision-making framework
- Available commands reference

### CLAUDE.md Content (Claude-Specific)
- Archon-first rule (Claude Code specific)
- TodoWrite override (Claude Code specific)
- MCP tool syntax for Claude
- Claude-specific settings

## MVP Recommendation

**MVP**: Flexible Multi-CLI AI Workflow System

### Goals
1. Create AGENT.md with universal instructions
2. Trim CLAUDE.md to ~150 lines
3. Update README.md with setup guide
4. Clean dead references from commands

### Key Features
1. Universal AGENT.md (works with any CLI)
2. Lean CLAUDE.md (Claude-specific only)
3. Clear MCP setup documentation
4. Updated command files

### Success Metrics
- AGENT.md: ~300 lines (universal)
- CLAUDE.md: ~150 lines (specific)
- README.md: Clear 5-minute setup
- All commands work without errors

## Next Steps

1. **Create AGENT.md** - Extract universal content from CLAUDE.md
2. **Trim CLAUDE.md** - Remove dead sections, keep Claude-specific
3. **Update README.md** - Add clear setup instructions
4. **Clean commands** - Remove references to deleted features
5. **Test workflow** - Verify /discovery → /planning → /execution works

## Timestamp
2026-01-28T23:10:00Z
