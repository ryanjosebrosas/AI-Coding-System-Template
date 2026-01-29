# PRP: Flexible Multi-CLI AI Workflow System

**Project ID**: 8fde1267-e953-494a-b5d7-294da01a3fbd

## Goal

Refactor the AI Coding Workflow System to be CLI-agnostic by separating universal instructions (AGENT.md) from Claude-specific config (CLAUDE.md).

**Success Criteria**:
- AGENT.md: ~300 lines (universal)
- CLAUDE.md: ~150 lines (Claude-specific)
- Zero dead references
- 5-minute setup for new users

## Tasks

| # | Task | Priority | Status |
|---|------|----------|--------|
| 1 | Create AGENT.md with universal instructions | 100 | todo |
| 2 | Trim CLAUDE.md to Claude-specific only | 90 | todo |
| 3 | Update README.md with setup guide | 80 | todo |
| 4 | Clean dead references in command files | 70 | todo |
| 5 | Test full workflow | 60 | todo |

## Implementation Blueprint

### Task 1: Create AGENT.md
**Extract from CLAUDE.md**:
- Lines 192-211: Development Principles (YAGNI, KISS, DRY)
- Lines 213-221: Documentation Standards
- Lines 223-246: Error Handling
- Lines 250-265: Command Reference
- Lines 268-336: Reference Library
- Lines 597-614: Decision Framework
- Lines 629-648: File Modification Guidelines

**Structure**:
```markdown
# Universal Agent Instructions
## Development Principles
## Task Workflow
## RAG Workflow
## Error Handling
## Decision Framework
## Commands
## File Guidelines
```

### Task 2: Trim CLAUDE.md
**Keep**:
- Lines 1-10: Archon-First Rule
- Lines 14-180: Core Workflow, RAG, MCP Health

**Remove**:
- Lines 338-399: Usage Analytics (deleted)
- Lines 400-575: Performance Optimization (deleted)

**Add**:
- Reference to AGENT.md at top

### Task 3: Update README.md
**Sections**:
- Quick Start (5 steps)
- Prerequisites
- MCP Setup
- Commands table
- Workflow diagram

### Task 4: Clean Commands
**Check all 12 files** in .claude/commands/:
- Remove refs to /analytics, /benchmark, /profile, /preprocess
- Remove refs to .auto-claude/, performance_cache.json
- Remove refs to validation templates

### Task 5: Test Workflow
- Run /discovery → /planning → /development
- Verify no errors
- Confirm AGENT.md referenced

## Validation

After each task:
```bash
# Check line counts
wc -l AGENT.md CLAUDE.md README.md

# Search for dead refs
grep -r "analytics\|benchmark\|profile\|preprocess\|auto-claude" .
```

## Reference Library
**Required Categories**: markdown, mcp
**Optional Tags**: cli, workflow
