# MVP: Smart Reference Library

**Version**: 1.1 | **Created**: 2026-01-24

## What We're Building

A token-efficient reference library with `/learn` command and brain health tracking - loading only what's relevant to the current task.

## Core Problem

All context gets loaded regardless of relevance. If building a Python feature, we don't need React patterns cluttering the LLM context.

## In Scope (Must Have)

### 1. Reference Directory Structure
```
references/
├── BRAIN.md          # Health dashboard
├── INDEX.md          # Available references
├── python/
├── mcp/
├── react/
├── ai-agents/
├── typescript/
├── testing/
└── patterns/
```

### 2. `/learn` Command
- `/learn {topic}` - Search RAG + web for topic
- Present findings for approval
- Save approved content to appropriate category
- Update BRAIN.md stats

### 3. `/learn-health` Command
- Check reference library health on demand
- Show stats per category
- Flag empty/stale categories
- Suggest what to learn next
- Quick overview without running full learn

### 4. Brain Health Tracking (`BRAIN.md`)
- Visual progress per category
- Empty categories flagged
- Last activity timestamp
- Growth tracking
- Suggestions for what to learn next

### 5. Skills Integration
- Skills can reference specific `references/` files
- References provide patterns, skills provide workflows
- Skills use selective loading same as PRP
- Example: `create-skill` skill references `references/patterns/skill-creation.md`

### 6. Selective Loading
- PRP and Skills specify only needed references
- CLAUDE.md doesn't preload everything
- Only relevant refs load into context
- Example: Python MCP task → load only `python/` + `mcp/`

## Out of Scope

- Business/non-technical content
- Automatic reference detection
- Reference versioning
- Cross-reference linking

## How It Integrates

- `/learn` builds the library (independent of PIV loop)
- PRP references specific files needed for task
- Only referenced files load into LLM context
- Brain health shows library growth

## Estimated Effort

2-3 days
