# PRD: Smart Reference Library

**Version**: 1.0 | **Last Updated**: 2026-01-24

## Overview

A token-efficient reference library system with `/learn` and `/learn-health` commands. Organizes best practices by category, loads only what's relevant to current task.

### Goals

1. Build growing knowledge library via `/learn` command
2. Track library health via `/learn-health` command
3. Enable selective loading - only relevant refs load into context
4. Integrate with PRP and Skills for reference linking

### Success Metrics

- Library grows over time (tracked in BRAIN.md)
- Context stays lean (only relevant refs load)
- Empty categories get flagged and addressed

## User Stories

### US-1: Learn New Topics
**As** a Developer, **I want** to run `/learn {topic}` **so that** I can search RAG/web and save useful patterns to my reference library.

**Acceptance Criteria**:
- Search Archon RAG and web for topic
- Present findings for approval
- Save approved content to appropriate category folder
- Update BRAIN.md stats after save

### US-2: Check Library Health
**As** a Developer, **I want** to run `/learn-health` **so that** I can see which categories need attention.

**Acceptance Criteria**:
- Show stats per category (ref count, last updated)
- Flag empty or stale categories
- Suggest topics to learn next
- Display overall health percentage

### US-3: Selective Loading
**As** a Developer, **I want** PRP and Skills to reference only needed files **so that** LLM context stays lean.

**Acceptance Criteria**:
- PRP specifies which reference files to load
- Skills can reference specific reference files
- CLAUDE.md does not preload all references
- Only referenced files load into context

### US-4: Brain Dashboard
**As** a Developer, **I want** a BRAIN.md dashboard **so that** I can see library status at a glance.

**Acceptance Criteria**:
- Visual progress bars per category
- Last activity timestamp
- Growth tracking (refs added this week)
- Suggestions for what to learn

## Features

### Feature 1: Reference Storage (Archon Documents)
Store digested insights as Archon documents with category tags.

**Categories (via tags)**:
- python
- mcp
- react
- ai-agents
- typescript
- testing
- patterns

**Storage**: Archon/Supabase (not local markdown files)

**Priority**: High

### Feature 2: `/learn` Command
Command to search, digest, and save insights.

**Flow**:
1. User runs `/learn {topic}`
2. Search Archon RAG + web
3. **Digest into concise, actionable insights**
4. Present for approval
5. Store via `manage_document` with category tags

**Priority**: High

### Feature 3: `/learn-health` Command
Command to check library health on demand.

**Output**:
- Stats per category
- Empty/stale flags
- Suggestions
- Overall health score

**Priority**: High

### Feature 4: BRAIN Dashboard
Generated from Archon document stats.

**Contents**:
- Health percentage (calculated from category coverage)
- Per-category counts (queried from Archon)
- Last learned timestamp
- Growth metrics
- Suggestions for empty categories

**Note**: Stats queried live from Archon, not stored in markdown

**Priority**: Medium

### Feature 5: Skills Integration
Skills can reference specific reference files.

**How it works**:
- Skills specify needed references
- References provide patterns
- Skills provide workflows
- Selective loading applies

**Priority**: Medium

## Technical Requirements

### Architecture: Hybrid (Archon + Markdown)

**Storage**: Archon/Supabase documents
**Output**: Generated markdown (BRAIN.md) for quick reference

### New Files

| File | Purpose |
|------|---------|
| `.claude/commands/learn.md` | Learn command definition |
| `.claude/commands/learn-health.md` | Health check command |

### Integrations

- **Archon MCP**: 
  - `rag_search_knowledge_base` - Search for topics
  - `manage_document` - Store digested insights
  - `find_documents` - Query references by category
- **Web Search**: External best practices
- **Archon Documents**: Store references (not local markdown files)

### Data Models

**Reference Document** (stored in Archon):
- `title`: Insight title
- `document_type`: "reference"
- `tags`: Category tags (python, mcp, react, etc.)
- `content`: Digested insight (concise, actionable)
- `source_url`: Original source (RAG/web)
- `created_at`: Timestamp

**BRAIN Stats** (queried from Archon):
- Count documents by tag/category
- Last updated per category
- Total reference count
- Health percentage calculated

### `/learn` Flow

1. User runs `/learn {topic}`
2. Search Archon RAG + web for topic
3. **Digest findings into concise insights**
4. Present for approval
5. Store approved insights via `manage_document`
6. Tags determine category

### Selective Loading Flow

1. PRP/Skill specifies needed categories (e.g., "python", "mcp")
2. Query: `find_documents(document_type="reference", query="python")`
3. Only relevant insights load into context

## Dependencies

### Required
- Archon MCP (RAG search)
- Existing command structure

### Optional
- Web MCP (enhanced web search)

## Out of Scope

- Business/non-technical content
- Automatic reference detection from code
- Reference versioning
- Cross-reference linking
