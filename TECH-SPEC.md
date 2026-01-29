# Technical Specification: Smart Context Retrieval System

**Version**: 1.0 | **Last Updated**: 2026-01-29

## System Architecture

### Overview

The Smart Context Retrieval System enhances the AI Coding Template with intelligent context filtering and incremental updates. It operates as a middleware layer between user commands and Archon MCP, applying language-aware boost weights and diff-based caching.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      User Commands                               │
│                 (/prime, RAG queries)                           │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────────┐
│                   Context Middleware                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Language        │  │ Boost Weight    │  │ Prime Cache     │ │
│  │ Detector        │  │ Applier         │  │ Manager         │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │
└───────────┼────────────────────┼────────────────────┼───────────┘
            │                    │                    │
┌───────────▼────────────────────▼────────────────────▼───────────┐
│                      Data Layer                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ .prime-cache    │  │ settings.json   │  │ Archon MCP      │ │
│  │ .json           │  │ (boost weights) │  │ (RAG queries)   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Design Principles

1. **Non-invasive**: Enhances existing commands without breaking changes
2. **Configurable**: All weights and thresholds adjustable via settings
3. **Transparent**: Debug mode shows applied transformations
4. **Fail-safe**: Falls back to default behavior on errors

---

## Technology Stack

### Core Technologies

| Component | Technology | Purpose |
|-----------|------------|---------|
| Commands | Markdown + YAML frontmatter | Command definitions |
| Runtime | Claude Code CLI | Command execution |
| RAG Backend | Archon MCP | Knowledge base queries |
| Cache Storage | JSON files | Prime cache persistence |
| Configuration | JSON | Boost weights, settings |

### MCP Servers

**Required**:
- `archon` - RAG knowledge base, code examples, task management

**Optional**:
- `archon-local` - Local testing instance

### File Types

| Extension | Purpose |
|-----------|---------|
| `.md` | Command definitions, documentation |
| `.json` | Cache files, configuration |
| `.yaml` | Frontmatter in commands |

---

## Command Structure

### Modified Commands

#### `/prime` Command Enhancement

**New Flags**:
- `--full` - Force complete codebase dump (bypass cache)
- `--reset` - Clear cache and regenerate

**Behavior Change**:
```yaml
# First run (no cache)
1. Scan all files
2. Generate full output
3. Create .prime-cache.json with hashes

# Subsequent runs (cache exists)
1. Load .prime-cache.json
2. Compare current files against cached hashes
3. Output: Full detail for changed, summary for unchanged
```

#### RAG Query Enhancement

**New Behavior**:
```yaml
# Before query execution
1. Detect project language (if not cached)
2. Load boost weights from settings
3. Apply weights to source_id filtering
4. Execute query with weighted sources
```

---

## File System Structure

### New Files

```
AI Coding Template/
├── .prime-cache.json          # Prime cache (git-ignored)
├── .claude/
│   └── settings.local.json    # Boost weight configuration
└── docs/
    └── contextual-embedding-guide.md  # Setup documentation
```

### Cache File Location

`.prime-cache.json` in project root (excluded from git via .gitignore)

---

## Data Models

### Prime Cache Schema

```json
{
  "version": "1.0",
  "created_at": "2026-01-29T00:00:00Z",
  "updated_at": "2026-01-29T01:00:00Z",
  "project_root": "C:/Users/Project",
  "file_count": 45,
  "files": {
    "src/main.py": {
      "hash": "sha256:abc123...",
      "size": 1234,
      "modified": "2026-01-29T00:30:00Z"
    }
  }
}
```

### Language Detection Result

```json
{
  "detected_language": "python",
  "confidence": 0.95,
  "detection_method": "file_marker",
  "markers_found": ["requirements.txt"],
  "extension_stats": {"py": 45, "md": 10}
}
```

### Boost Weight Settings

Location: `.claude/settings.local.json`

```json
{
  "smart_context": {
    "enabled": true,
    "boost_weights": {
      "matching": 1.5,
      "general": 1.0,
      "non_matching": 0.7
    },
    "language_sources": {
      "python": ["c0e629a894699314"],
      "typescript": ["f3246532dd189ef4"],
      "general": ["0475da390fe5f210", "b6fcee627ca78458"]
    },
    "debug": false
  }
}
```

---

## MCP Integration

### Archon MCP Tools Used

| Tool | Purpose | Integration Point |
|------|---------|-------------------|
| `rag_search_knowledge_base` | Search docs | Apply source boost weights |
| `rag_search_code_examples` | Search code | Filter by language tag |
| `rag_get_available_sources` | List sources | Map sources to languages |
| `health_check` | Verify connection | Pre-flight check |

### Boost Weight Application

```python
# Pseudocode for weight application
def apply_boost_weights(results, detected_lang, weights, mapping):
    for result in results:
        source_id = result.source_id
        if source_id in mapping[detected_lang]:
            result.score *= weights.matching  # 1.5x
        elif source_id in mapping.general:
            result.score *= weights.general   # 1.0x
        else:
            result.score *= weights.non_matching  # 0.7x
    return sorted(results, key=lambda r: r.score, reverse=True)
```

---

## Command Implementation

### Feature 1: Language Detection

**Implementation Steps**:

1. **Scan for file markers** (priority order):
   - `requirements.txt` / `pyproject.toml` → Python
   - `package.json` / `tsconfig.json` → TypeScript
   - `go.mod` → Go
   - `Cargo.toml` → Rust

2. **Fallback to extension analysis**:
   - Count files by extension
   - Primary language = highest count (threshold: 40%)

3. **Cache result** for session duration

### Feature 2: Diff-Based Prime

**Implementation Steps**:

1. **Check for `.prime-cache.json`**:
   - If missing: Full prime, create cache
   - If exists: Load and compare

2. **Hash comparison**:
   - Use SHA-256 for file content hashing
   - Compare: current hash vs cached hash

3. **Generate output**:
   - Changed files: Full content + diff markers
   - Unchanged files: Summary line only

### Feature 3: Boost Weight Application

**Implementation Steps**:

1. **Load settings** from `.claude/settings.local.json`
2. **Detect language** (or use cached)
3. **Map sources** to language categories
4. **Apply multipliers** to result scores
5. **Re-sort** results by adjusted score

---

## Error Handling

### Error Types

| Error | Handling | User Message |
|-------|----------|--------------|
| Cache corrupted | Delete and rebuild | "Cache rebuilt" |
| Language detection failed | Use "general" | "Using default weights" |
| Archon unavailable | Skip boost weights | "RAG without filtering" |
| Settings invalid | Use defaults | "Using default settings" |

### Recovery Strategy

```yaml
1. Log error with context
2. Fall back to default behavior
3. Inform user of fallback
4. Continue operation (non-blocking)
```

---

## Performance

### Targets

| Operation | Target | Measurement |
|-----------|--------|-------------|
| Language detection | < 500ms | File system scan |
| Hash comparison (1000 files) | < 2s | SHA-256 computation |
| Boost weight application | < 100ms | In-memory operation |
| Full prime | < 60s | First run |
| Diff prime | < 30s | Subsequent runs |

### Optimizations

1. **Lazy loading**: Detect language only on first RAG query
2. **Incremental hashing**: Only hash modified files (by mtime)
3. **Source caching**: Cache Archon source list per session

---

## Security

### Data Protection

- Cache contains paths/hashes only (no file content stored)
- Cache excluded from version control
- No credentials in configuration files

### Access Control

- Cache file uses project directory permissions
- Settings follow existing `.claude/` permissions

---

## Implementation Phases

### Phase 1: Language Detection + Boost Weights
- Implement file marker scanning
- Add boost weight configuration
- Integrate with RAG queries

### Phase 2: Diff-Based Prime
- Implement hash generation
- Create cache management
- Modify prime output format

### Phase 3: Documentation + Polish
- Contextual embedding guide
- Debug mode implementation
- Settings validation

---

## Testing Strategy

### Unit Tests

| Component | Test Cases |
|-----------|------------|
| Language Detector | Marker detection, extension fallback, edge cases |
| Hash Generator | Correct hashes, file changes detected |
| Boost Applier | Correct weights, sorting, edge cases |

### Integration Tests

| Scenario | Validation |
|----------|------------|
| Python project RAG query | Python sources ranked higher |
| Prime with changes | Only changed files detailed |
| Cache corruption | Auto-rebuild succeeds |

---

## Source Documents

- **PRD**: [PRD.md](./PRD.md)
- **MVP**: [MVP.md](./MVP.md)
- **Discovery**: [discovery-2026-01-29T00-43-01Z](./discovery/discovery-2026-01-29T00-43-01Z.md)
