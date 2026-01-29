# Universal Agent Instructions

> CLI-agnostic workflow instructions for AI-assisted development. Works with Claude Code, Codex, Cursor, and other AI coding tools.

## Development Principles

### YAGNI (You Aren't Gonna Need It)
- Don't implement features that are not needed
- Focus on current requirements, not future possibilities
- Avoid over-engineering and premature optimization
- Build only what's necessary for current task

### KISS (Keep It Simple, Stupid)
- Prefer simple solutions over complex ones
- Avoid unnecessary abstractions
- Write code that's easy to understand and maintain

### DRY (Don't Repeat Yourself)
- Extract common patterns when appropriate
- Reuse code and components
- But don't over-abstract - balance with YAGNI

## Documentation Standards

- **Line Limits**: MVP, PRD, TECH-SPEC must be 500-600 lines max (fewer is better)
- **YAGNI**: Only document what's needed NOW
- **KISS**: Use simple, direct language
- **Focus**: Keep only essential technical details

## Task-Driven Workflow

### Task Cycle
1. **Get Task** → Find next todo task
2. **Start Work** → Mark as "doing"
3. **Research** → Use knowledge base before implementing
4. **Implement** → Write code based on research
5. **Review** → Mark as "review" when done
6. **Next Task** → Get next todo task

### Task Status Flow
```
todo → doing → review → done
```

### Task Guidelines
- Only ONE task in "doing" status at a time
- Each task should be 30 minutes to 4 hours of work
- Use "review" for completed work awaiting validation
- Mark "done" only after verification

## RAG Workflow (Research Before Implementation)

### Search Knowledge Base
```
# Search with 2-5 keywords (SHORT and FOCUSED)
rag_search_knowledge_base(query="authentication JWT", match_count=5)

# Find code examples
rag_search_code_examples(query="React hooks", match_count=3)
```

**Good queries**: "vector search", "React useState", "authentication JWT"
**Bad queries**: "how to implement vector search with pgvector in PostgreSQL..."

### Research Flow
1. Get available sources → `rag_get_available_sources()`
2. Search knowledge base → `rag_search_knowledge_base(query="...")`
3. Read full pages → `rag_read_full_page(page_id="...")`

## Error Handling

### When Errors Occur
1. **Stop and assess** - Don't continue with broken state
2. **Inform user clearly** - Explain what went wrong
3. **Suggest recovery** - Provide actionable next steps
4. **Preserve work** - Checkpoint if possible

### Common Scenarios
- **Server unavailable**: Check health, inform user, wait
- **Task not found**: Verify ID, check project context
- **File operation failed**: Check permissions, verify path
- **Search returns no results**: Try broader query

## Decision Framework

### Proceed Autonomously When:
- Task is clear from context
- Implementation pattern is established
- No ambiguity in requirements
- Standard file operations within scope
- Following existing codebase patterns

### Ask User When:
- Requirements are ambiguous or conflicting
- Multiple valid approaches exist
- Breaking changes or major refactoring needed
- External dependencies required
- User preferences or business logic decisions needed

**Rule**: If unsure, **ask**. Better to clarify than assume incorrectly.

## Commands Reference

| Command | Description | Phase |
|---------|-------------|-------|
| `/prime` | Export codebase context | Prime |
| `/discovery` | Explore ideas and opportunities | Discovery |
| `/planning {feature}` | Generate PRD | Planning |
| `/development {feature}` | Generate Tech Spec | Development |
| `/task-planning {feature}` | Create PRP and tasks | Task Planning |
| `/execution {feature}` | Execute tasks | Execution |
| `/review {feature}` | Code review | Review |
| `/test {feature}` | Run tests | Test |
| `/workflow {feature}` | Full pipeline | All |
| `/learn {topic}` | Store coding insights | Independent |
| `/learn-health` | Check reference library | Independent |
| `/check` | Health check & cleanup | Utility |

## File Modification Guidelines

### Safe to Edit Autonomously
- Files within current feature scope
- New files being created for current task
- Documentation files for current feature
- Test files for current feature

### Ask Before Editing
- Files outside current feature directory
- Core system files (commands, configs)
- Files shared across multiple features
- Breaking changes or major refactoring

### Best Practices
- Read file first to understand context
- Preserve existing patterns and style
- Make minimal, focused changes
- Document changes in commits

## Reference Library

### Using /learn
Build knowledge by storing digested insights:
```bash
/learn python async patterns
/learn React hooks
```

### Categories
- `python` - Python patterns, libraries
- `mcp` - MCP server development
- `react` - React, Next.js, hooks
- `typescript` - TypeScript/JavaScript
- `ai-agents` - AI agent patterns
- `testing` - Testing patterns
- `patterns` - General design patterns
- `supabase` - Database patterns
- `api` - API design, REST, GraphQL

### Selective Loading
PRPs specify required categories → Only relevant references load → Token savings
