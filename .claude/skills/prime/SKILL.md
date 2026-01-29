---
name: prime
description: "Export codebase context with structured markdown output"
user-invocable: true
disable-model-invocation: false
---

# Prime Skill

Export entire codebase for context gathering with structured markdown output. Supports incremental indexing to only process changed files.

## Execution Flow

1. **Detect Language** - Scan for file markers (requirements.txt, package.json)
2. **Generate Index** - Build file tree with metadata
3. **Export Content** - Write files with syntax highlighting
4. **Smart Context** - Apply language-aware boost weights
5. **Save Export** - Write to `context/prime-{timestamp}.md`

## Language Detection

| Marker | Language |
|--------|----------|
| requirements.txt, pyproject.toml | Python |
| package.json, tsconfig.json | TypeScript/JavaScript |
| Cargo.toml | Rust |
| go.mod | Go |

## Smart Context Integration

Applies boost weights to RAG queries:
- Matching language sources: 1.5x
- General documentation: 1.0x
- Non-matching languages: 0.7x

## Output

- `context/prime-{timestamp}.md` - Full codebase export
- `context/.prime-state.json` - Incremental index state
- `.smart-context-config.json` - Language detection config
- Updated `context/INDEX.md`

## Options

- `--debug` - Show language detection details
- `--full` - Force full re-index (ignore incremental)

## Reference

Full implementation details: `.claude/commands/prime.md`
