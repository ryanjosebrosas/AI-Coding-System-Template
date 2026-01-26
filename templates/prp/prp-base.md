# PRP: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp} | **Related**: PRD.md, TECH-SPEC.md

## Goal

### Feature Goal
{Clear description of what this feature accomplishes. Should be specific and measurable.}

### Deliverable
{What will be delivered - specific artifacts, files, functionality. List exact deliverables.}

### Success Criteria
{How to verify success - acceptance criteria, tests, validation. Must be measurable and testable.}

## All Needed Context

### Documentation URLs
{External documentation references - API docs, framework docs, best practices. Include links and why each is needed.}

### Codebase Patterns
{Relevant patterns from codebase - file structure, naming conventions, architecture patterns. Extract from Prime export if available.}

### File References
{Specific files to reference - similar implementations, utilities, helpers. Include file paths and purpose.}

### Naming Conventions
{File naming, function naming, class naming, variable naming conventions. Follow existing patterns from codebase.}

### Architecture Patterns
{Service structure, API patterns, data flow, component organization. Reference existing architecture.}

### Reference Library
{Optional: Specify which reference categories to load for token-efficient context.

**Loading Instructions**: During implementation, query archon_references table by category/tags:
```sql
-- Example: Load python and mcp references
SELECT * FROM archon_references
WHERE category = 'python' OR 'mcp' = ANY(tags);
```

**Required Categories**: {list categories needed - e.g., python, mcp, react}
**Optional Tags**: {list specific tags - e.g., async, hooks, testing}

**Standard Categories**:
- python: Python patterns, libraries, best practices
- mcp: MCP server development
- react: React, Next.js, hooks
- typescript: TypeScript/JavaScript patterns
- ai-agents: AI agent patterns, prompting
- testing: Testing patterns, frameworks
- patterns: General design patterns
- supabase: Supabase/database patterns
- api: API design, REST, GraphQL

If no references are needed, leave this section empty or omit it.}

## Implementation Blueprint

### Data Models
{Data structures, schemas, interfaces, types. Include:
- Data models with fields and types
- Relationships between models
- Validation schemas
- Type definitions}

### Implementation Tasks
{Step-by-step tasks with dependencies. Include:
- Task ID
- Task description
- Dependencies
- Estimated effort}

### Dependencies
{Task dependencies, external dependencies, prerequisites. List:
- Internal dependencies (other tasks, files)
- External dependencies (packages, libraries, services)
- System dependencies (database, API, etc.)}

### File Structure
{Directory layout, file organization, where to create files. Include:
- New directories to create
- New files to create
- Files to modify
- File organization rationale}

### Integration Points
{How this feature integrates with existing codebase, APIs, services. Include:
- Existing APIs to call
- Existing services to integrate with
- Data flow between components
- Event listeners or subscriptions}

## Validation Loop

### Syntax Validation
{Commands to validate syntax - linters, formatters, type checkers. Include:
- Lint commands
- Format commands
- Type check commands
- Pre-commit hooks}

### Unit Tests
{How to write and run unit tests, test structure, test patterns. Include:
- Test framework
- Test file locations
- Test naming conventions
- Coverage requirements}

### Integration Tests
{How to write and run integration tests, test setup, test patterns. Include:
- Test setup and teardown
- Mock/stub requirements
- Test data fixtures
- Test execution commands}

### End-to-End Tests
{How to test complete workflow from user perspective. Include:
- User scenarios to test
- Test data requirements
- Expected outcomes}

## Anti-Patterns

### General Anti-Patterns
- Skipping tests: Always write tests for new code
- Hardcoding values: Use configuration and environment variables
- Ignoring errors: Handle all error cases gracefully
- Not documenting: Document complex logic and decisions
- Over-engineering: Keep solutions simple (YAGNI)
- Premature optimization: Optimize only when needed (YAGNI)
- Violating conventions: Follow existing codebase patterns

### Feature-Specific Anti-Patterns
{Feature-specific anti-patterns to avoid. Include:
- Common mistakes for this feature type
- Domain-specific pitfalls
- Integration issues to watch for
- Performance considerations}

## Notes

- This PRP contains everything needed to implement successfully without prior knowledge
- Extract codebase patterns from Prime export (context/prime-{timestamp}.md)
- Follow naming conventions from existing codebase
- Test thoroughly before marking as complete
- Update STATUS.md as you progress through tasks
