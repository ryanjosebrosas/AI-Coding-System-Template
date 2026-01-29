---
name: learn
description: "Save coding insights to reference library"
user-invocable: true
disable-model-invocation: false
---

# Learn Skill

Search, digest, and save coding insights to reference library.

## Execution Flow

1. **Search** - Query for topic (web + RAG)
2. **Digest** - Extract key insights
3. **Save** - Store in reference library
4. **Index** - Update searchable index

## Usage

```
/learn "React hooks best practices"
/learn "FastAPI middleware patterns"
/learn "PostgreSQL indexing strategies"
```

## Reference Library Structure

```
.claude/reference/
├── INDEX.md           # Searchable index
├── topics/
│   ├── react-hooks.md
│   ├── fastapi-middleware.md
│   └── postgresql-indexing.md
└── sources/           # Raw sources
```

## Insight Format

```markdown
# {Topic}

**Learned**: {timestamp}
**Sources**: {URLs}

## Key Insights

1. {Insight with code example}
2. {Insight with code example}

## When to Use

{Practical guidance}

## Anti-Patterns

{What to avoid}
```

## Output

- New entry in reference library
- Updated INDEX.md
- Summary of learned insights

## Reference

Full implementation details: `.claude/commands/learn.md`
