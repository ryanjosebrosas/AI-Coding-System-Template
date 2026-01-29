# Technical Specification: Flexible Multi-CLI AI Workflow System

**Version**: 1.0 | **Last Updated**: 2026-01-28

## System Architecture

### Design Principles
- **Separation of Concerns**: Universal instructions (AGENT.md) vs CLI-specific config
- **YAGNI**: Only include what's needed now
- **Portability**: Work across Claude Code, Codex, Cursor, future CLIs

### Architecture Diagram
```
┌─────────────────────────────────────────────────────┐
│                    User Request                      │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│              CLI/IDE (Claude Code, Codex, etc.)     │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  CLI-Specific Config (.claude/*, .codex/*, etc.)    │
│  - CLAUDE.md (Claude Code specific)                 │
│  - Future: .codex/, .cursor/                        │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│              AGENT.md (Universal Core)              │
│  - Development Principles                           │
│  - Task Workflow                                    │
│  - Command Reference                                │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│              .claude/commands/ (Workflow)           │
│  - /discovery, /planning, /development              │
│  - /task-planning, /execution                       │
│  - /review, /test, /workflow                        │
│  - /learn, /learn-health, /check                    │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│                 MCP Servers                         │
│  - Archon (tasks, RAG, projects)                    │
│  - Supabase (database)                              │
└─────────────────────────────────────────────────────┘
```

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Instructions | Markdown | Human-readable, portable |
| Commands | Markdown + YAML | Executable workflows |
| Config | JSON | MCP server definitions |
| Task Management | Archon MCP | Projects, tasks, RAG |
| Database | Supabase | Reference library storage |

### MCP Servers
**Required**:
- `archon` - Task management, RAG knowledge base, project tracking

**Optional**:
- `supabase` - Database operations for reference library

## File System Structure

### Current → Target
```
CURRENT                          TARGET
───────                          ──────
CLAUDE.md (653 lines)    →       AGENT.md (~300 lines, universal)
                                 CLAUDE.md (~150 lines, Claude-specific)

.claude/commands/ (12)   →       .claude/commands/ (12, unchanged)
.mcp.json               →       .mcp.json (unchanged)
```

### Target Structure
```
AI-Coding-Template/
├── AGENT.md                 # Universal core (NEW)
├── CLAUDE.md                # Claude-specific only (TRIMMED)
├── README.md                # Setup guide (UPDATED)
├── INDEX.md                 # Navigation
├── LICENSE                  # MIT
├── .mcp.json                # MCP servers
├── .gitignore
├── .claude/
│   ├── commands/            # 12 workflow commands
│   │   ├── discovery.md
│   │   ├── planning.md
│   │   ├── development.md
│   │   ├── task-planning.md
│   │   ├── execution.md
│   │   ├── review.md
│   │   ├── test.md
│   │   ├── workflow.md
│   │   ├── prime.md
│   │   ├── learn.md
│   │   ├── learn-health.md
│   │   └── check.md
│   └── settings.local.json  # Permissions
└── discovery/               # Discovery outputs
```

## Content Split Specification

### AGENT.md Content (~300 lines)
Extract from CLAUDE.md:

| Section | Source Lines | Target |
|---------|--------------|--------|
| Development Principles | 192-211 | Keep as-is |
| Documentation Standards | 213-221 | Keep as-is |
| Error Handling | 223-246 | Keep as-is |
| Command Reference | 250-265 | Keep as-is |
| Reference Library | 268-336 | Keep as-is |
| Decision Framework | 597-614 | Keep as-is |
| File Modification Guidelines | 629-648 | Keep as-is |

**AGENT.md Structure**:
```markdown
# Universal Agent Instructions

## Development Principles
- YAGNI, KISS, DRY

## Task Workflow
- Task-driven development pattern

## RAG Workflow
- Research before implementation

## Error Handling
- Error patterns and recovery

## Decision Framework
- When to proceed vs ask

## Commands
- Reference table

## File Guidelines
- Safe edits vs ask first
```

### CLAUDE.md Content (~150 lines)
Keep Claude-specific only:

| Section | Source Lines | Action |
|---------|--------------|--------|
| Archon-First Rule | 1-10 | KEEP |
| Core Workflow | 14-29 | KEEP (with ref to AGENT.md) |
| RAG Workflow | 31-78 | KEEP |
| Project Workflows | 82-105 | KEEP |
| Tool Reference | 107-146 | KEEP |
| MCP Health | 148-180 | KEEP |
| Usage Analytics | 338-399 | REMOVE (deleted feature) |
| Performance Optimization | 400-575 | REMOVE (deleted feature) |
| PRP Template | 577-595 | MOVE to AGENT.md |

**CLAUDE.md Structure**:
```markdown
# Claude Code Configuration

> For universal instructions, see AGENT.md

## Archon-First Rule
- Use Archon MCP primary
- Never use TodoWrite

## MCP Tool Syntax
- Claude-specific tool calls

## MCP Health & Fallback
- Health check procedures
```

### README.md Content (~100 lines)
Rewrite with:

```markdown
# AI Coding Workflow System

## Quick Start (5 minutes)
1. Clone repo
2. Configure .mcp.json
3. Run /discovery

## Prerequisites
- Claude Code CLI (or compatible)
- Archon MCP server

## Commands
[table of 12 commands]

## Workflow
Discovery → Planning → Development → Task Planning → Execution → Review → Test
```

## Implementation Tasks

| # | Task | Files | Effort |
|---|------|-------|--------|
| 1 | Create AGENT.md | AGENT.md (new) | Medium |
| 2 | Trim CLAUDE.md | CLAUDE.md | Low |
| 3 | Update README.md | README.md | Low |
| 4 | Clean dead refs | .claude/commands/*.md | Low |
| 5 | Test workflow | N/A | Low |

## Error Handling

### File Operations
- Read before write
- Preserve existing patterns
- Backup before major changes

### MCP Unavailable
- Check health first
- Inform user of limitations
- Suggest alternatives

## Validation Checklist

After implementation:
- [ ] AGENT.md exists (~300 lines)
- [ ] CLAUDE.md trimmed (~150 lines)
- [ ] No dead references to deleted features
- [ ] README.md has clear setup
- [ ] All 12 commands work
- [ ] /workflow executes successfully
