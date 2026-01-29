# MVP: Smart Context Retrieval System

## Goals

1. **Improve retrieval accuracy** - Get the RIGHT context, not all context
2. **Reduce token usage** - Eliminate redundant/irrelevant context from prompts
3. **Language-aware filtering** - Prioritize relevant language examples without excluding cross-language patterns

## Key Features

### Priority 1: Soft Smart Language Filtering
- Auto-detect project language from markers (requirements.txt, package.json, etc.)
- Apply relevance boost weights to RAG queries:
  - Matching language: 1.5x boost
  - General docs (MCP, Anthropic): 1.0x (unchanged)
  - Non-matching language: 0.7x (included but lower rank)
- No hard exclusions - preserves cross-language patterns

### Priority 2: Diff-Based Prime Command
- Store file hashes in `.prime-cache.json`
- On `/prime`, compare current vs cached hashes
- Output format:
  - **Changed files**: Full detail with diff summary
  - **Unchanged files**: Summary only (count, last modified)
- Support `--full` flag for complete dump when needed

### Priority 3: Contextual Embedding (if Archon supports)
- Enable contextual embedding option in Archon settings
- Re-index knowledge sources with contextual chunks
- Expected improvement: 35-67% better retrieval accuracy

## Success Criteria

| Metric | Target | Measurement |
|--------|--------|-------------|
| Retrieval Accuracy | Right context returned | Manual verification of query results |
| Token Savings | 50%+ reduction on subsequent primes | Compare token counts before/after |
| Speed | 2-3 min acceptable | Timing benchmarks |

## Architecture Recommendations

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ Project Scanner │────▶│ Language Detector │────▶│ Boost Weights   │
│ (file markers)  │     │ (py/ts/go/rust)   │     │ (1.5x/1.0x/0.7x)│
└─────────────────┘     └──────────────────┘     └────────┬────────┘
                                                          │
                                                          ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ Prime Cache     │────▶│ Hash Comparison   │────▶│ Diff Output     │
│ (.prime-cache)  │     │ (changed/unchanged)│    │ (detail/summary)│
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

### Language Detection Logic
```
IF requirements.txt OR pyproject.toml exists → Python
IF package.json OR tsconfig.json exists → TypeScript
IF go.mod exists → Go
IF Cargo.toml exists → Rust
ELSE → Analyze file extension distribution
```

### Archon Integration Points
- RAG query: Apply boost weights before search
- Code examples: Filter by detected language tag
- Knowledge sources: Weight by relevance to project type

## Next Steps

1. **Run /planning** - Generate detailed PRD from this MVP
2. **Run /development** - Create technical specification
3. **Run /task-planning** - Break down into implementable tasks
4. **Run /execution** - Implement features

## Source Discovery

- **Discovery Document**: [discovery-2026-01-29T00-43-01Z](./discovery/discovery-2026-01-29T00-43-01Z.md)
- **Date**: 2026-01-29
