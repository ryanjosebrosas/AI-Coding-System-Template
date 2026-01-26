# Claude Code Adapter

## Overview

This directory (`.claude/`) is the **Claude Code adapter** - one of potentially many adapters in the multi-layer AI Coding Template architecture. Adapters translate the Universal Core workflows into IDE/LLM-specific prompt formatting and tool integrations.

**Architecture Context**: This adapter is part of a three-layer system:
- **Universal Core** (`AGENT.md`, `WORKFLOWS.md`, `INTEGRATIONS.md`, `commands/`, `config/`) - LLM-agnostic workflows
- **Adapter Layer** (this directory and future `.copilot/`, `.cursor/`) - IDE/LLM-specific formatting
- **MCP Layer** (Archon, Supabase) - Universal interface via MCP servers

## Adapter Purpose

The Claude Code adapter:
1. **Formats prompts** for Claude's context window and response patterns
2. **Integrates MCP tools** (Archon for task management, Supabase for storage)
3. **Preserves all existing functionality** while referencing Universal Core
4. **Provides a template** for future adapters (GitHub Copilot, Cursor, etc.)

## File Structure

```
.claude/
├── ADAPTER.md                 # This file - adapter documentation
├── adapter-config.json        # Claude Code-specific configuration
├── settings.json              # Environment and API configuration
├── commands/                  # Claude Code command definitions
│   ├── prime.md              # Reference: ../../commands/prime.md
│   ├── discovery.md          # Reference: ../../commands/discovery.md
│   ├── planning.md           # Reference: ../../commands/planning.md
│   └── ...                   # All commands reference Universal Core
└── CLAUDE.md                  # Claude Code-specific agent instructions
```

## Key Concepts

### Universal Core References

All command files in this adapter reference Universal Core definitions:

```markdown
## Universal Core Reference

This command is defined in: `../../commands/{command-name}.md`

This file provides Claude Code-specific prompt formatting and tool references.
```

**Pattern**: Adapter commands contain:
1. Reference to Universal Core definition
2. Claude-specific prompt enhancements
3. Claude Code IDE tool usage patterns
4. MCP tool integration (if supported by Claude)

### Adapter Configuration

Each adapter has an `adapter-config.json` defining:
- Adapter name and type
- Supported LLMs
- MCP tool availability
- Universal Core reference paths
- Context loading strategy

Example from `.claude/adapter-config.json`:

```json
{
  "adapter_name": "Claude Code",
  "adapter_id": "claude-code",
  "supported_llms": ["claude"],
  "ide_type": "claude-code",
  "uses_mcp": true,
  "mcp_servers": ["archon", "supabase"],
  "command_pattern": "markdown_slash",
  "context_loading": "full_with_selective_rag",
  "universal_core_references": {
    "agent_instructions": "../../AGENT.md",
    "workflows": "../../WORKFLOWS.md",
    "commands": "../../commands/"
  }
}
```

### MCP Integration

Claude Code adapter has full MCP support:
- **Archon MCP** - Task management (`find_tasks`, `manage_task`)
- **Supabase MCP** - Storage and reference library

**Critical**: Always check MCP availability before use:

```bash
# Check Archon MCP health
health_check()

# If unavailable, inform user and wait
# Do NOT fall back to TodoWrite (per ARCHON-FIRST RULE)
```

## Command Execution Flow

When a user runs `/prime` in Claude Code:

```
User: /prime
  ↓
.claude/commands/prime.md
  ↓
Reads Universal Core: ../../commands/prime.md
  ↓
Formats prompt for Claude (adds Claude-specific context)
  ↓
Claude executes workflow, uses Archon MCP if needed
  ↓
Output written to: context/prime-{timestamp}.md
```

## Backward Compatibility

**CRITICAL**: This adapter preserves all existing `.claude/` functionality:

1. **All commands still work** - `/prime`, `/discovery`, `/planning`, etc.
2. **Same output directories** - `context/`, `discovery/`, `features/`
3. **CLAUDE.md preserved** - Now references Universal Core for LLM-agnostic content
4. **No breaking changes** - Existing workflows continue unchanged

## Creating New Adapters

Use this adapter as a template for future IDE/LLM integrations:

### Step 1: Create Adapter Directory

```bash
# For GitHub Copilot
mkdir .copilot/
cd .copilot/

# For Cursor
mkdir .cursor/
cd .cursor/
```

### Step 2: Create Adapter Config

Create `adapter-config.json` (copy from `.claude/adapter-config.json`):
- Update `adapter_name` and `adapter_id`
- Set `uses_mcp` based on IDE/LLM support
- Update `supported_llms`
- Keep `universal_core_references` paths the same

### Step 3: Create Command Files

For each command in `commands/`:
1. Copy to adapter directory (e.g., `.copilot/commands/prime.md`)
2. Add Universal Core reference at top
3. Add IDE/LLM-specific prompt formatting
4. Implement MCP tool fallback patterns (if MCP unsupported)

### Step 4: Create Agent Instructions

Create IDE/LLM-specific instructions (e.g., `.copilot/COPILOT.md`):
1. Reference Universal Core: `../../AGENT.md`
2. Add IDE-specific patterns
3. Document MCP tool usage (if supported)
4. Define token budget strategy (see `../../config/agents.json`)

### Step 5: Test Adapter

Verify all commands work:
- `/prime` creates `context/prime-{timestamp}.md`
- `/discovery` creates `discovery/discovery-{timestamp}.md`
- Command outputs match expected structure

## Token Efficiency

Claude Code adapter uses the **"full_with_selective_rag"** strategy:
- Load all Universal Core context
- Use RAG for specific documentation queries
- Optimized for Claude's 200K token limit

See `../../config/agents.json` for other strategies:
- `chunked_priority` - For LLMs with smaller token limits
- `priority_only` - For very limited token budgets
- `full` - For LLMs with large token budgets (e.g., Gemini 1M)

## Concurrency Considerations

Multiple adapters may write to shared directories (`context/`, `discovery/`, `features/`):

**Collision Prevention**:
- All adapters use timestamp-based filenames (e.g., `prime-{timestamp}.md`)
- Adapter identifier can be appended (e.g., `prime-claude-{timestamp}.md`)
- Document write patterns in adapter-specific docs

## Error Handling

**MCP Tool Unavailability**:

If MCP tools are not supported by the LLM/IDE:
1. Check tool availability via `health_check()`
2. Provide fallback instructions
3. Document which tools are required vs optional
4. Pattern: "Try MCP tool first, fall back to manual instructions if unavailable"

Example from `INTEGRATIONS.md`:
```markdown
### MCP Tool Fallback Pattern

When MCP tools are unavailable:

1. Check availability
   ```bash
   health_check()
   ```

2. If unavailable, use manual workflow
   - Create tasks in features/{name}/tasks.md manually
   - Search documentation using web search
   - Manage state via file-based tracking

3. Document limitations
   - Inform user which features require MCP
   - Provide alternative approaches
```

## Related Documentation

- **[../../AGENT.md](../../AGENT.md)** - Universal Core agent instructions
- **[../../WORKFLOWS.md](../../WORKFLOWS.md)** - Universal Core workflow definitions
- **[../../INTEGRATIONS.md](../../INTEGRATIONS.md)** - Adapter development guide
- **[../../config/agents.json](../../config/agents.json)** - Agent configurations
- **[../../INDEX.md](../../INDEX.md)** - Complete directory structure
- **[CLAUDE.md](../CLAUDE.md)** - Claude Code-specific agent instructions

## Status

**Version**: 1.0 (Three-Layer Architecture)
**Last Updated**: 2026-01-26
**Status**: Active - Preserving all existing functionality
