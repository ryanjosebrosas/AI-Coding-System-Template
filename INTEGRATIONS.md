# Integrations & Adapter Development Guide

## Overview

This guide explains how to create IDE/LLM-specific adapters for the AI Coding Template. The three-layer architecture separates concerns: **Universal Core** defines workflows, **Adapters** format prompts for specific platforms, and **MCP Layer** provides universal tool access.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│     Universal Core (LLM-Agnostic)       │
│  AGENT.md, WORKFLOWS.md, commands/      │
│         "What to do"                    │
└──────────────┬──────────────────────────┘
               │ References
┌──────────────▼──────────────────────────┐
│      Adapter Layer (Platform-Specific)  │
│  .claude/, .copilot/, .cursor/          │
│    "How to format for this LLM/IDE"     │
└──────────────┬──────────────────────────┘
               │ Invokes
┌──────────────▼──────────────────────────┐
│         MCP Layer (Universal)           │
│    Archon, Supabase MCP servers         │
│       "Tools and storage"               │
└─────────────────────────────────────────┘
```

## Adapter Development Steps

### 1. Create Adapter Directory

```bash
# Create new adapter directory in root
mkdir .{adapter-name}/

# Example for GitHub Copilot
mkdir .copilot/
```

### 2. Create Adapter Configuration

Create `.{adapter-name}/adapter-config.json`:

```json
{
  "adapter_name": "GitHub Copilot",
  "adapter_id": "copilot",
  "supported_llms": ["openai", "claude"],
  "ide_type": "vscode",
  "uses_mcp": false,
  "mcp_servers": [],
  "command_pattern": "markdown_slash",
  "context_loading": "chunked_priority",
  "universal_core_references": {
    "agent_instructions": "../../AGENT.md",
    "workflows": "../../WORKFLOWS.md",
    "commands": "../../commands/"
  },
  "adapter_specific_files": [
    "COPILOT.md",
    ".copilot/commands/*.md"
  ]
}
```

**Configuration Fields:**
- `adapter_name`: Human-readable name
- `adapter_id`: Unique identifier (directory name)
- `supported_llms`: List of LLMs this IDE supports
- `ide_type`: IDE platform (claude-code, vscode, cursor, etc.)
- `uses_mcp`: Does this adapter use MCP tools?
- `mcp_servers`: Which MCP servers to connect to (if supported)
- `command_pattern`: How commands are triggered (markdown_slash, custom, etc.)
- `context_loading`: Strategy for loading context (see config/agents.json for strategies)
- `universal_core_references`: Relative paths to Universal Core files
- `adapter_specific_files`: List of adapter-specific files

### 3. Create Adapter Documentation

Create `.{adapter-name}/ADAPTER.md` following this template:

```markdown
# {Adapter Name} Adapter

## Purpose

This adapter formats Universal Core workflows for {IDE/LLM name}. It provides {specific capabilities}.

## Adapter Structure

```
.{adapter-name}/
├── ADAPTER.md           # This file
├── adapter-config.json  # Adapter configuration
├── {AGENT}.md           # Agent instructions (IDE-specific)
└── commands/            # IDE-specific command formatting
    ├── prime.md
    ├── discovery.md
    └── ...
```

## Universal Core References

This adapter references:
- **Agent Instructions**: `../../AGENT.md`
- **Workflows**: `../../WORKFLOWS.md`
- **Commands**: `../../commands/`

## {IDE/LLM}-Specific Features

- Feature 1: Description
- Feature 2: Description
- MCP Integration: {Yes/No, details}

## Context Loading Strategy

{Strategy}: {Description}

Priority sections loaded:
1. ../../AGENT.md
2. ../../WORKFLOWS.md
3. ../../commands/{current-task}.md
4. {AGENT}.md (IDE-specific)

## Concurrency Control

When writing to shared directories:
- Use timestamp-based filenames (e.g., `context/prime-{timestamp}.md`)
- Append adapter identifier if needed (e.g., `context/prime-copilot-{timestamp}.md`)
- Document shared write patterns in ADAPTER.md

## Token Budget Adaptation

{LLM name} token limit: {number}

Strategy: {How to adapt to token limits}
- Load priority sections first
- Use RAG for specific queries instead of full docs
- Chunk large context files if needed
```

### 4. Create Agent Instructions

Create `.{adapter-name}/{AGENT}.md` (e.g., `.copilot/COPILOT.md`):

```markdown
# CRITICAL: {IDE/LLM}-SPECIFIC RULES

**Critical rules specific to this platform:**

1. **Rule 1**: Description
2. **Rule 2**: Description

---

## Universal Core

See [../../AGENT.md](../../AGENT.md) for LLM-agnostic AI agent instructions.

This file provides {IDE/LLM}-specific enhancements and platform patterns.

## Platform-Specific Instructions

### Tool Usage

{How to use IDE/LLM-specific tools}

### Formatting Preferences

{Formatting conventions for this platform}

### MCP Integration {If Applicable}

{How to use MCP tools with this adapter}

**Important**: {IDE/LLM} {supports/does not support} MCP tools.

{If supported}: Configure in .mcp.json or adapter-specific config
{If not supported}: Use manual fallback patterns when MCP tools unavailable
```

### 5. Create Command References

Create `.{adapter-name}/commands/*.md` for each command:

```markdown
---
name: Prime
description: "Export codebase for context gathering"
phase: prime
dependencies: []
outputs:
  - path: "context/prime-{timestamp}.md"
    description: "Codebase export"
inputs: []
---

## Universal Core Reference

**See**: `../../../commands/prime.md` for universal command definition.

This file provides {IDE/LLM}-specific prompt formatting and tool references.

## {IDE/LLM}-Specific Instructions

### Platform Formatting

{How to format prompts for this platform}

### Tool Usage

{Which tools to use, how to invoke them}

### Expected Output

{What the output should look like for this platform}
```

## Adapter Examples

### .copilot/ Adapter (GitHub Copilot)

**Directory Structure:**
```
.copilot/
├── ADAPTER.md
├── adapter-config.json
├── COPILOT.md
└── commands/
    ├── prime.md
    ├── discovery.md
    └── ...
```

**adapter-config.json:**
```json
{
  "adapter_name": "GitHub Copilot",
  "adapter_id": "copilot",
  "supported_llms": ["openai", "claude"],
  "ide_type": "vscode",
  "uses_mcp": false,
  "mcp_servers": [],
  "command_pattern": "markdown_slash",
  "context_loading": "chunked_priority",
  "universal_core_references": {
    "agent_instructions": "../../AGENT.md",
    "workflows": "../../WORKFLOWS.md",
    "commands": "../../commands/"
  },
  "adapter_specific_files": [
    "COPILOT.md",
    ".copilot/commands/*.md"
  ]
}
```

**Key Differences from .claude/ adapter:**
- No MCP tool support (fallback to manual instructions)
- Smaller token budget (OpenAI: 128K vs Claude: 200K)
- Use `chunked_priority` context loading
- Commands must work without Archon MCP task management

### .cursor/ Adapter (Cursor IDE)

**Directory Structure:**
```
.cursor/
├── ADAPTER.md
├── adapter-config.json
├── CURSOR.md
└── commands/
    ├── prime.md
    ├── discovery.md
    └── ...
```

**adapter-config.json:**
```json
{
  "adapter_name": "Cursor IDE",
  "adapter_id": "cursor",
  "supported_llms": ["claude", "gpt-4"],
  "ide_type": "cursor",
  "uses_mcp": false,
  "mcp_servers": [],
  "command_pattern": "markdown_slash",
  "context_loading": "full_with_selective_rag",
  "universal_core_references": {
    "agent_instructions": "../../AGENT.md",
    "workflows": "../../WORKFLOWS.md",
    "commands": "../../commands/"
  },
  "adapter_specific_files": [
    "CURSOR.md",
    ".cursor/commands/*.md"
  ]
}
```

**Key Differences:**
- Supports multiple LLMs (Claude and GPT-4)
- May add MCP support in future
- Use `full_with_selective_rag` for context loading
- Cursor-specific shortcuts and features

## MCP Tool Integration Pattern

### When MCP is Supported

```markdown
## MCP Tool Usage

This adapter supports MCP tools via {configuration method}.

**Available MCP Tools:**
- `tool_name_1`: Description
- `tool_name_2`: Description

**Usage Pattern:**
```bash
# 1. Check MCP server health
health_check()

# 2. Use tool if available
if health_check():
    result = mcp_tool_function()
else:
    # Fallback to manual instructions
    result = manual_method()
```
```

### When MCP is NOT Supported

```markdown
## MCP Tool Integration

**This adapter does not support MCP tools.**

**Fallback Patterns:**
- **Task Management**: Use manual task tracking (create tasks.md files)
- **Knowledge Search**: Use web search or document reading instead of RAG
- **Project Management**: Use manual project notes instead of manage_project()

**Example Fallback:**
```markdown
## Manual Task Tracking

Since MCP tools are unavailable, track tasks manually:

1. Create `execution/tasks.md` with task list
2. Mark tasks as [ ], [~], [x] for todo/in-progress/done
3. Update status as you work
```
```

## Token Budget Adaptation

### Context Loading Strategies

From `config/agents.json`:

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| `full` | Load all Universal Core and adapter context | Large token budgets (1M+) |
| `full_with_selective_rag` | Load all context, use RAG for specific queries | Medium-large budgets (200K) |
| `chunked_priority` | Load critical sections first, load remaining as needed | Medium budgets (128K) |
| `priority_only` | Load only high-priority sections | Small budgets (<100K) |

### Priority Sections

Always load these first:
1. `../../AGENT.md` - Core agent instructions
2. `../../WORKFLOWS.md` - Workflow definitions
3. `../../commands/{current-task}.md` - Current task command
4. `.{adapter}/{AGENT}.md` - Platform-specific instructions

### Adaptation Pattern

```markdown
## Context Loading

**Token Limit**: {number}

**Strategy**: {strategy_name}

**Loading Order**:
1. Priority sections (AGENT.md, WORKFLOWS.md, current command)
2. Adapter-specific instructions
3. Remaining context if token budget allows
4. Use RAG for specific queries instead of loading full docs

**If Token Budget Exceeded**:
- Load priority sections only
- Use RAG search for specific information
- Chunk large files and load incrementally
```

## Concurrency Control

### Shared Directories

Multiple adapters may write to these directories:
- `context/` - Prime exports
- `discovery/` - Discovery documents
- `features/` - Feature artifacts
- `execution/` - Task breakdowns

### Preventing Conflicts

**Rule 1**: Use timestamp-based filenames
```bash
context/prime-{timestamp}.md
discovery/discovery-{timestamp}.md
```

**Rule 2**: Append adapter identifier if concurrent access expected
```bash
context/prime-claude-20260126-143022.md
context/prime-copilot-20260126-143045.md
```

**Rule 3**: Document write patterns in adapter ADAPTER.md
```markdown
## Concurrent Access

This adapter writes to:
- `context/` with `{prefix}-{adapter}-{timestamp}.md` pattern
- `discovery/` with `{prefix}-{adapter}-{timestamp}.md` pattern

When reading from shared directories, use glob patterns to find latest:
`context/prime-*-{timestamp}.md`
```

## Validation Checklist

Before considering an adapter complete:

- [ ] Adapter directory created (.{adapter-name}/)
- [ ] adapter-config.json created with all required fields
- [ ] ADAPTER.md documents adapter purpose and structure
- [ ] {AGENT}.md provides platform-specific instructions
- [ ] commands/ directory created with all command references
- [ ] All command files reference Universal Core (../../../commands/)
- [ ] MCP tool integration documented (supported or not)
- [ ] Token budget adaptation strategy defined
- [ ] Concurrency control guidelines documented
- [ ] Relative paths to Universal Core are correct
- [ ] Adapter tested with at least one command (/prime)

## Troubleshooting

### Common Issues

**Issue**: Commands not found
- **Check**: Relative paths to Universal Core commands/
- **Fix**: Verify path is `../../../commands/{command}.md` from adapter commands/

**Issue**: Token budget exceeded
- **Check**: Context loading strategy in adapter-config.json
- **Fix**: Change to `chunked_priority` or `priority_only`

**Issue**: MCP tools unavailable
- **Check**: `uses_mcp` field in adapter-config.json
- **Fix**: Set to `false` and document fallback patterns

**Issue**: File conflicts in shared directories
- **Check**: Filenames include timestamps
- **Fix**: Append adapter identifier if needed

## Getting Help

1. Check existing adapters (`.claude/`) for reference
2. Review Universal Core documentation (AGENT.md, WORKFLOWS.md)
3. Verify adapter-config.json matches schema
4. Test with simple command first (e.g., /prime)

## Related Documentation

- **[AGENT.md](./AGENT.md)** - Universal Core agent instructions
- **[WORKFLOWS.md](./WORKFLOWS.md)** - Workflow definitions
- **[config/agents.json](./config/agents.json)** - Agent configuration schema
- **[INDEX.md](./INDEX.md)** - Directory structure overview
