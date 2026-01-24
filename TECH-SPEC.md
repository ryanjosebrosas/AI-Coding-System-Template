# Technical Specification: Smart Reference Library

**Version**: 1.0 | **Last Updated**: 2026-01-24

## System Architecture

### Overview

The Smart Reference Library uses Archon/Supabase as the storage backend. References are stored as Archon documents with category tags, enabling structured queries and selective loading.

```
┌─────────────────────────────────────────────────────────────┐
│                      User Commands                          │
│              /learn {topic}    /learn-health                │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  Command Layer                              │
│   .claude/commands/learn.md  .claude/commands/learn-health.md│
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  Research Layer                             │
│     rag_search_knowledge_base()    WebSearch (fallback)     │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  Digest Layer (LLM)                         │
│     Raw findings → Concise, actionable insights             │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  Storage Layer (Archon)                     │
│     manage_document()  find_documents()  find_projects()    │
└─────────────────────────────────────────────────────────────┘
```

### Design Principles

1. **Token Efficiency**: Only load relevant references via selective queries
2. **Digested Insights**: Store processed knowledge, not raw dumps
3. **Structured Storage**: Leverage Archon/Supabase for querying and stats
4. **Category Tagging**: Enable filtering by technology/domain

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Storage | Supabase (direct SQL) | `archon_references` table |
| Search | Archon RAG | Knowledge base search for topics |
| Web Research | WebSearch tool | External best practices |
| Commands | Markdown + YAML | Command definitions |
| Digest | LLM (Claude) | Process raw → insights |
| DB Access | Supabase JS/REST API | Direct table queries |

### MCP Servers

**Required**:
- `user-archon`: RAG search only (not for storage)

**Optional**:
- `web-search`: Enhanced web research (fallback to built-in)

### Database

**Table**: `archon_references` (dedicated, not project docs)
**Migration**: `012_add_smart_reference_library.sql`

## Data Models

### Dedicated Database Table

References are stored in a dedicated `archon_references` table (not in project docs JSONB).

**Migration**: `012_add_smart_reference_library.sql`

```sql
CREATE TABLE archon_references (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  category TEXT NOT NULL,  -- python, mcp, react, etc.
  tags TEXT[] DEFAULT '{}',
  content JSONB NOT NULL,  -- {summary, insights, code_examples, sources}
  source_url TEXT,
  author TEXT DEFAULT 'AI Coding System',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_archon_references_category ON archon_references(category);
CREATE INDEX idx_archon_references_tags ON archon_references USING GIN(tags);
```

### Reference Record

Each reference stored as a row:

```json
{
  "id": "uuid",
  "title": "Python Async Best Practices",
  "category": "python",
  "tags": ["async", "concurrency", "patterns"],
  "content": {
    "summary": "Key patterns for async Python development",
    "insights": [
      "Use asyncio.gather() for concurrent tasks",
      "Avoid mixing sync/async - use async all the way down",
      "Use asyncio.create_task() for fire-and-forget"
    ],
    "code_examples": [
      {
        "title": "Concurrent HTTP requests",
        "language": "python",
        "code": "async def fetch_all(urls): ..."
      }
    ],
    "sources": ["https://docs.python.org/3/library/asyncio.html"],
    "learned_at": "2026-01-24T19:00:00Z"
  },
  "source_url": "https://docs.python.org/3/library/asyncio.html",
  "author": "AI Coding System"
}
```

### Direct SQL Queries

Since we're using a dedicated table (not Archon MCP documents), queries are direct SQL:

```sql
-- Insert reference
INSERT INTO archon_references (title, category, tags, content, source_url)
VALUES ('Python Async', 'python', ARRAY['async'], '{"summary": "..."}', 'https://...');

-- Query by category
SELECT * FROM archon_references WHERE category = 'python';

-- Query by tag
SELECT * FROM archon_references WHERE 'async' = ANY(tags);

-- Get stats per category
SELECT category, COUNT(*) as count, MAX(updated_at) as last_updated
FROM archon_references GROUP BY category;
```

### Category Tags

Standard category tags for filtering:

| Tag | Description |
|-----|-------------|
| `python` | Python patterns, libraries, best practices |
| `typescript` | TypeScript/JavaScript patterns |
| `react` | React components, hooks, patterns |
| `mcp` | MCP server development |
| `ai-agents` | AI agent patterns, prompting |
| `testing` | Testing patterns, frameworks |
| `patterns` | General design patterns |
| `supabase` | Supabase/database patterns |
| `api` | API design, REST, GraphQL |

### BRAIN Stats Model

Stats calculated from Archon queries:

```json
{
  "total_references": 15,
  "categories": {
    "python": { "count": 5, "last_updated": "2026-01-24" },
    "mcp": { "count": 3, "last_updated": "2026-01-23" },
    "react": { "count": 0, "last_updated": null },
    "testing": { "count": 2, "last_updated": "2026-01-22" }
  },
  "health_percentage": 60,
  "empty_categories": ["react", "ai-agents"],
  "suggestions": ["Learn React hooks", "Learn AI agent patterns"]
}
```

## Command Structure

### `/learn` Command

**File**: `.claude/commands/learn.md`

```yaml
---
name: Learn
description: "Search, digest, and save knowledge to reference library"
phase: independent
dependencies: []
inputs:
  - name: topic
    description: "Topic to learn (e.g., 'python async', 'react hooks')"
    required: true
outputs:
  - path: "Archon document"
    description: "Digested insight stored in Archon"
---
```

**Execution Flow**:

1. **Parse Topic**: Extract keywords and infer category
2. **Search RAG**: `rag_search_knowledge_base(query="{topic}", match_count=5)`
3. **Search Web** (optional): WebSearch for external resources
4. **Digest Findings**: LLM processes raw results into:
   - Summary (1-2 sentences)
   - Key insights (3-5 bullet points)
   - Code examples (if applicable)
   - Sources
5. **Present for Approval**: Show digest to user
6. **Store on Approval** (direct SQL via Supabase):
   ```sql
   INSERT INTO archon_references (title, category, tags, content, source_url)
   VALUES (
     'Python Async Best Practices',
     'python',
     ARRAY['async', 'concurrency'],
     '{"summary": "...", "insights": [...], "code_examples": [...], "sources": [...]}',
     'https://docs.python.org/...'
   );
   ```
7. **Confirm**: Show success message

### `/learn-health` Command

**File**: `.claude/commands/learn-health.md`

```yaml
---
name: Learn Health
description: "Check reference library health and stats"
phase: independent
dependencies: []
outputs:
  - description: "Health report displayed to user"
---
```

**Execution Flow**:

1. **Query Stats** (direct SQL via Supabase):
   ```sql
   SELECT category, COUNT(*) as count, MAX(updated_at) as last_updated
   FROM archon_references
   GROUP BY category;
   ```
2. **Calculate Health**:
   - Count refs per category
   - Find empty categories (compare against standard list)
   - Calculate health percentage
3. **Generate Suggestions**: Based on empty/stale categories
4. **Display Report**:
   ```
   ## Brain Health: 60%
   
   | Category | Refs | Last Updated |
   |----------|------|--------------|
   | python   | 5    | 2026-01-24   |
   | mcp      | 3    | 2026-01-23   |
   | react    | 0    | -            |
   
   **Empty**: react, ai-agents
   **Suggestions**: Learn React hooks, Learn AI agent patterns
   ```

## Integration Points

### PRP Integration

PRPs specify needed references via tags:

```markdown
## All Needed Context

### Reference Library
Load references with tags: ["python", "mcp"]
```

**Loading Flow**:
1. PRP parser extracts required categories/tags
2. Query (direct SQL):
   ```sql
   SELECT * FROM archon_references 
   WHERE category = 'python' OR 'mcp' = ANY(tags);
   ```
3. Load matching references into context
4. Agent has relevant insights available

### Skills Integration

Skills can specify reference dependencies:

```markdown
## Prerequisites

### Reference Library
Required: ["mcp", "patterns"]
```

**Loading Flow**: Same as PRP - selective query by tags.

### CLAUDE.md Integration

CLAUDE.md does NOT preload references. Instead:

```markdown
## Reference Library

References are stored in Archon under project "Smart Reference Library".
Use `/learn {topic}` to add new references.
Use `/learn-health` to check library status.

PRP and Skills specify which references to load via tags.
```

## Implementation Plan

### Phase 1: Setup (Required First)

1. **Run SQL Migration**
   - Execute `012_add_smart_reference_library.sql` in Supabase SQL Editor
   - Creates `archon_references` table with indexes and RLS

2. **Create Command Files**
   - `.claude/commands/learn.md`
   - `.claude/commands/learn-health.md`

### Phase 2: `/learn` Command

1. **Parse topic and infer category**
   - Keywords → category mapping
   - Example: "python async" → tags: ["python", "async"]

2. **Search and gather sources**
   - RAG search first
   - Web search if needed

3. **Digest into insights**
   - Prompt LLM to summarize
   - Extract actionable patterns
   - Include code examples

4. **Approval flow**
   - Present digest
   - Wait for user confirmation
   - Store on approval

### Phase 3: `/learn-health` Command

1. **Query all documents**
   - `find_documents(project_id="{id}")`

2. **Aggregate by tags**
   - Count per category
   - Track last updated

3. **Calculate health**
   - Categories covered / total categories
   - Flag empty categories

4. **Generate report**
   - Table format
   - Suggestions for empty categories

### Phase 4: Integration

1. **Update PRP templates**
   - Add reference loading section

2. **Document in CLAUDE.md**
   - Reference library usage

## Error Handling

| Error | Handling |
|-------|----------|
| Supabase unavailable | Inform user, suggest retry later |
| Table not found | Prompt to run migration SQL |
| No results from RAG | Fall back to web search |
| No results from web | Inform user, suggest different topic |
| Insert fails | Show error, offer retry |
| Health query fails | Show partial results if available |

## Performance Considerations

1. **Query Optimization**
   - Use `per_page` limit for document queries
   - Query by specific tags rather than all documents

2. **Token Efficiency**
   - Digests are concise (not full articles)
   - Selective loading only what's needed
   - Category-based filtering

3. **Caching**
   - Project ID can be cached (rarely changes)
   - Stats can be calculated on-demand (no caching needed)

## Security

1. **Content Filtering**
   - Only technical/coding content
   - No business secrets or sensitive data
   - User approval before storage

2. **Source Attribution**
   - Track source URLs
   - Maintain provenance

## Validation Checklist

### `/learn` Command
- [ ] Topic parsed correctly
- [ ] RAG search executed
- [ ] Findings digested into insights
- [ ] Approval flow works
- [ ] Document stored in Archon
- [ ] Correct tags applied

### `/learn-health` Command
- [ ] Documents queried successfully
- [ ] Stats calculated correctly
- [ ] Empty categories identified
- [ ] Health percentage accurate
- [ ] Suggestions generated

### Integration
- [ ] PRP can specify reference tags
- [ ] Selective loading works
- [ ] CLAUDE.md updated
