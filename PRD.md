# PRD: Flexible Multi-CLI AI Workflow System

**Version**: 1.0 | **Last Updated**: 2026-01-28

## Overview

Refactor the AI Coding Workflow System to be CLI-agnostic, enabling use with Claude Code, Codex, Cursor, and future AI coding tools. The system currently has Claude-specific instructions mixed with universal workflow patterns in a 653-line CLAUDE.md file that needs separation and trimming.

**Goals**:
- Create universal AGENT.md for any CLI/IDE
- Reduce CLAUDE.md to Claude-specific config only
- Apply YAGNI to remove dead code/references
- Improve documentation clarity

**Success Metrics**:
- AGENT.md: ~300 lines (universal content)
- CLAUDE.md: ~150 lines (Claude-specific only)
- Zero references to deleted features
- 5-minute setup time for new users

## User Personas

**Developer**: Uses Claude Code daily, wants consistent workflow across projects

**Multi-Tool User**: Switches between Claude Code, Codex, Cursor; needs portable workflow

**New User**: Setting up system for first time; needs clear documentation

## User Stories

### US-1: Universal Agent Instructions
**As** a multi-tool user, **I want** universal agent instructions in AGENT.md **so that** I can use the same workflow with any CLI/IDE.

**Acceptance Criteria**:
- AGENT.md contains CLI-agnostic instructions
- Works with Claude Code, Codex (future), Cursor (future)
- No tool-specific syntax in AGENT.md

### US-2: Lean Claude Configuration
**As** a Claude Code user, **I want** CLAUDE.md to contain only Claude-specific config **so that** I don't read irrelevant content.

**Acceptance Criteria**:
- CLAUDE.md under 150 lines
- Contains only: Archon-first rule, TodoWrite override, Claude MCP syntax
- References AGENT.md for universal instructions

### US-3: Clean Documentation
**As** a new user, **I want** documentation without dead references **so that** I don't get confused by non-existent features.

**Acceptance Criteria**:
- No references to /analytics, /benchmark, /profile, /preprocess
- No references to .auto-claude/ folder
- All command references match existing commands

### US-4: Quick Setup
**As** a new user, **I want** clear setup instructions **so that** I can start using the system in under 5 minutes.

**Acceptance Criteria**:
- README.md has step-by-step setup
- MCP configuration documented
- First command example included

## Features

### Feature 1: AGENT.md Creation
Extract universal content from CLAUDE.md into new AGENT.md file.

**Content to include**:
- Development principles (YAGNI, KISS, DRY)
- Task-driven workflow pattern
- RAG research workflow
- Error handling patterns
- Decision-making framework
- Command reference table

**Priority**: High

### Feature 2: CLAUDE.md Trimming
Remove universal content, dead references, and keep Claude-specific only.

**Content to keep**:
- Archon-first rule (lines 1-10)
- TodoWrite override instruction
- Claude MCP tool syntax examples
- Reference to AGENT.md

**Content to remove**:
- Lines 338-399: Usage Analytics Dashboard
- Lines 400-575: Performance Optimization
- Lines 431-466: Caching section
- Duplicate content moved to AGENT.md

**Priority**: High

### Feature 3: README.md Update
Rewrite README with clear setup and usage instructions.

**Sections**:
- Quick Start (5 steps)
- Prerequisites
- MCP Setup
- Command Overview
- Workflow Example

**Priority**: Medium

### Feature 4: Command Cleanup
Update command files to remove dead references.

**Files to check**:
- All 12 commands in .claude/commands/
- Remove references to deleted features
- Update examples if needed

**Priority**: Medium

## Technical Requirements

**File Changes**:
| File | Action | Target Lines |
|------|--------|--------------|
| AGENT.md | Create | ~300 |
| CLAUDE.md | Trim | ~150 |
| README.md | Rewrite | ~100 |
| Commands | Update | As needed |

**No New Dependencies**: Uses existing file structure

**Backward Compatibility**: All existing commands continue to work

## Dependencies

**Required**:
- Existing CLAUDE.md (source content)
- Existing .claude/commands/ (12 commands)
- Archon MCP server (for task management)

**Optional**:
- None

## Risks & Assumptions

**Risks**:
- Content split may miss dependencies between sections
- Some Claude-specific content may be misidentified as universal

**Mitigations**:
- Review split carefully before finalizing
- Test with both Claude Code and generic prompts

**Assumptions**:
- Universal workflow patterns work across CLIs
- Future CLIs (Codex, Cursor) will support markdown instructions
- MCP integration remains Claude-specific for now
