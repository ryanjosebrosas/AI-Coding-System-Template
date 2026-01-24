# PRP: Smart Reference Library

**Version**: 1.0 | **Last Updated**: 2026-01-24 | **Related**: MVP.md, PRD.md, TECH-SPEC.md

## Goal

### Feature Goal
Build a token-efficient reference library with `/learn` and `/learn-health` commands that stores digested coding insights in a dedicated Supabase table, enabling selective context loading based on current task needs.

### Deliverable
- SQL migration: `012_add_smart_reference_library.sql` (created)
- Command: `.claude/commands/learn.md`
- Command: `.claude/commands/learn-health.md`
- Updated: `templates/prp/prp-base.md` with Reference Library section
- Updated: `CLAUDE.md` with Reference Library documentation

### Success Criteria
- `/learn {topic}` searches RAG/web, digests findings, stores approved insights
- `/learn-health` displays category stats, health percentage, suggestions
- PRP templates can specify required reference categories
- References stored in dedicated `archon_references` table (not project docs)

## All Needed Context

### Documentation URLs
- Supabase SQL reference: https://supabase.com/docs/guides/database
- Archon RAG API: See `mcps/user-archon/tools/*.json`

### Codebase Patterns
- Commands use YAML frontmatter + markdown body
- Commands define inputs, outputs, execution steps
- Existing commands: `.claude/commands/*.md`

### File References
- Command template: `.claude/commands/template.md`
- Existing commands: `prime.md`, `discovery.md`, `planning.md`, `development.md`
- PRP base template: `templates/prp/prp-base.md`

### Naming Conventions
- Commands: lowercase with hyphens (e.g., `learn-health.md`)
- Supabase tables: `archon_` prefix (e.g., `archon_references`)
- Indexes: `idx_archon_references_{column}`

### Architecture Patterns
- Direct SQL via Supabase (not Archon MCP documents)
- RAG search for topic research
- LLM digest for insight extraction
- User approval before storage

## Implementation Blueprint

### Data Models

**archon_references table** (already defined in migration):
```sql
- id: UUID PRIMARY KEY
- title: TEXT NOT NULL
- category: TEXT NOT NULL (python, mcp, react, etc.)
- tags: TEXT[] (additional tags)
- content: JSONB (summary, insights, code_examples, sources)
- source_url: TEXT
- author: TEXT
- created_at, updated_at: TIMESTAMPTZ
```

**Content JSONB structure**:
```json
{
  "summary": "string",
  "insights": ["string"],
  "code_examples": [{"title": "", "language": "", "code": ""}],
  "sources": ["url"],
  "learned_at": "timestamp"
}
```

### Implementation Tasks

| Order | Task | Dependencies | Estimate |
|-------|------|--------------|----------|
| 1 | Run SQL migration | None | 5 min |
| 2 | Create /learn command | Migration done | 1 hour |
| 3 | Create /learn-health command | Migration done | 45 min |
| 4 | Update PRP templates | Commands done | 30 min |
| 5 | Update CLAUDE.md | Commands done | 30 min |
| 6 | Test /learn command | All above | 30 min |
| 7 | Test /learn-health command | All above | 30 min |

### File Structure

```
.claude/commands/
├── learn.md              # New
├── learn-health.md       # New
└── ... (existing)

templates/prp/
├── prp-base.md           # Update (add Reference Library section)
└── ... (existing)

features/smart-reference-library/
├── prp.md                # This file
├── task-plan.md          # Task tracking
└── STATUS.md             # Progress tracking

Archon MCP/migration/
└── 012_add_smart_reference_library.sql  # Created
```

### Integration Points

**Supabase Direct SQL**:
- INSERT for storing references
- SELECT for querying by category/tags
- GROUP BY for stats calculation

**Archon RAG**:
- `rag_search_knowledge_base(query, match_count)` for topic research
- `rag_read_full_page(page_id)` for full content

**Web Search** (fallback):
- WebSearch tool if RAG returns no results

## Validation Loop

### Syntax Validation
- YAML frontmatter valid in command files
- SQL migration runs without errors
- Markdown formatting correct

### Unit Tests
- SQL: Insert/query references manually in Supabase
- Commands: Verify YAML parsing works

### Integration Tests
- `/learn python async`: Full flow from search to storage
- `/learn-health`: Stats calculation with test data

### End-to-End Tests
1. Run migration in Supabase
2. Execute `/learn mcp server patterns`
3. Approve digest
4. Verify row in `archon_references`
5. Run `/learn-health`
6. Verify stats show new reference

## Anti-Patterns

### General Anti-Patterns
- Skipping user approval before storage
- Storing raw content instead of digested insights
- Preloading all references in CLAUDE.md
- Using Archon project docs instead of dedicated table

### Feature-Specific Anti-Patterns
- Long RAG queries (keep to 2-5 keywords)
- Storing non-technical content
- Missing category/tags on references
- Not handling Supabase connection errors
