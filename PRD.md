# PRD: Smart Context Retrieval System

**Version**: 1.0 | **Last Updated**: 2026-01-29

## Overview

The Smart Context Retrieval System improves the AI Coding Template's ability to retrieve the RIGHT context efficiently, rather than dumping everything into prompts. This system focuses on token-efficient, accurate context gathering using Archon's RAG knowledge base with intelligent filtering and incremental updates.

### Goals

1. **Improve retrieval accuracy** - Return relevant context based on project type and task
2. **Reduce token usage** - Eliminate redundant/irrelevant context from prompts
3. **Enable language-aware filtering** - Prioritize relevant language examples without excluding cross-language patterns
4. **Optimize prime command** - Only detail changed files, summarize unchanged

### Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Retrieval Accuracy | 90%+ relevant results | Manual verification of query results |
| Token Savings | 50%+ reduction on subsequent primes | Compare token counts before/after |
| Speed | < 3 minutes for full workflow | Timing benchmarks |
| User Satisfaction | Accurate context, fewer irrelevant results | Qualitative feedback |

---

## User Personas

### Developer (Primary)
- **Role**: Software developer using AI Coding Template
- **Goals**: Get relevant code examples and documentation quickly
- **Pain Points**: Receives mixed-language results, token-heavy context dumps
- **Needs**: Language-specific examples, efficient context retrieval

### Template Maintainer (Secondary)
- **Role**: Maintains and configures the AI Coding Template
- **Goals**: Optimize template for various project types
- **Pain Points**: Difficult to tune RAG queries for different languages
- **Needs**: Configurable boost weights, easy cache management

### Multi-Project User (Tertiary)
- **Role**: Developer working across multiple projects (Python, TypeScript, etc.)
- **Goals**: Context automatically adapts per project
- **Pain Points**: Manual context switching, re-priming entire codebase
- **Needs**: Auto-detection of project type, diff-based updates

---

## User Stories

### US-1: Language-Aware RAG Query
**As** a Developer, **I want** RAG queries to prioritize my project's language **so that** I get relevant code examples without irrelevant results.

**Acceptance Criteria**:
- [ ] System detects project language from file markers (requirements.txt, package.json, etc.)
- [ ] Matching language sources receive 1.5x relevance boost
- [ ] Non-matching language sources receive 0.7x weight (not excluded)
- [ ] General documentation (MCP, Anthropic) remains at 1.0x
- [ ] Cross-language patterns still surface when highly relevant

### US-2: Auto Project Detection
**As** a Developer, **I want** the system to automatically detect my project type **so that** I don't need to manually configure language preferences.

**Acceptance Criteria**:
- [ ] Detects Python from requirements.txt or pyproject.toml
- [ ] Detects TypeScript/JavaScript from package.json or tsconfig.json
- [ ] Detects Go from go.mod
- [ ] Detects Rust from Cargo.toml
- [ ] Falls back to file extension analysis if no markers found
- [ ] Detection runs automatically on first RAG query of session

### US-3: Diff-Based Prime
**As** a Developer, **I want** the `/prime` command to only show changed files **so that** I save tokens on subsequent primes.

**Acceptance Criteria**:
- [ ] First prime generates full output and stores file hashes in `.prime-cache.json`
- [ ] Subsequent primes compare current files against cached hashes
- [ ] Changed files shown with full detail and diff summary
- [ ] Unchanged files shown as summary only (count, last modified date)
- [ ] `--full` flag available to force complete dump
- [ ] Token savings of 50%+ on typical subsequent primes

### US-4: Prime Cache Management
**As** a Template Maintainer, **I want** to manage the prime cache **so that** I can reset or inspect cached state.

**Acceptance Criteria**:
- [ ] `.prime-cache.json` stores file paths, hashes, and timestamps
- [ ] Cache can be cleared with `--reset` flag on prime command
- [ ] Cache is human-readable JSON format
- [ ] Cache is excluded from git (added to .gitignore)

### US-5: Contextual Embedding Configuration
**As** a Template Maintainer, **I want** to enable contextual embedding in Archon **so that** retrieval accuracy improves by 35-67%.

**Acceptance Criteria**:
- [ ] Documentation on how to enable contextual embedding in Archon settings
- [ ] Re-indexing process documented for existing knowledge sources
- [ ] Expected accuracy improvement clearly stated
- [ ] Cost implications documented (~$1.02 per million tokens)

### US-6: Boost Weight Configuration
**As** a Template Maintainer, **I want** to configure language boost weights **so that** I can tune relevance for specific use cases.

**Acceptance Criteria**:
- [ ] Boost weights configurable in settings file
- [ ] Default weights: matching=1.5x, general=1.0x, non-matching=0.7x
- [ ] Weights apply to both knowledge base and code example searches
- [ ] Changes take effect immediately without restart

### US-7: Query Result Transparency
**As** a Developer, **I want** to see which boost weights were applied **so that** I understand why certain results ranked higher.

**Acceptance Criteria**:
- [ ] Debug mode shows detected project language
- [ ] Debug mode shows applied boost weights per source
- [ ] Can be enabled via flag or environment variable
- [ ] Does not affect normal output when disabled

---

## Features

### Feature 1: Soft Smart Language Filtering
Auto-detect project language and apply relevance boost weights to RAG queries without hard-excluding any sources.

**Components**:
- Project Scanner: Reads file markers to detect language
- Language Detector: Determines primary project language
- Boost Weight Applier: Applies weights to RAG query results

**Priority**: High

### Feature 2: Diff-Based Prime Command
Optimize `/prime` to only detail changed files, with hash-based change detection and cached state.

**Components**:
- Hash Generator: Creates file hashes for comparison
- Prime Cache: Stores hashes in `.prime-cache.json`
- Diff Output Generator: Produces detailed/summary output based on changes

**Priority**: High

### Feature 3: Language Detection System
Automatic detection of project language from file markers and extension analysis.

**Components**:
- File Marker Scanner: Checks for requirements.txt, package.json, etc.
- Extension Analyzer: Fallback analysis of file extension distribution
- Language Classifier: Determines primary language with confidence

**Priority**: High

### Feature 4: Configurable Boost Weights
Allow customization of relevance boost weights for different source types.

**Components**:
- Settings Schema: Defines boost weight configuration
- Weight Loader: Reads weights from settings
- Weight Applier: Applies weights during RAG queries

**Priority**: Medium

### Feature 5: Contextual Embedding Integration
Documentation and support for enabling Anthropic's contextual retrieval in Archon.

**Components**:
- Setup Documentation: How to enable in Archon
- Re-indexing Guide: Process for updating existing sources
- Verification Tests: Confirm contextual embedding is active

**Priority**: Medium

---

## Technical Requirements

### Data Models

**Prime Cache Schema** (`.prime-cache.json`):
```json
{
  "version": "1.0",
  "created_at": "ISO8601 timestamp",
  "updated_at": "ISO8601 timestamp",
  "project_root": "/path/to/project",
  "files": {
    "relative/path/to/file.py": {
      "hash": "sha256 hash",
      "size": 1234,
      "modified": "ISO8601 timestamp"
    }
  }
}
```

**Language Detection Result**:
```json
{
  "detected_language": "python",
  "confidence": 0.95,
  "markers_found": ["requirements.txt", "pyproject.toml"],
  "extension_distribution": {"py": 45, "md": 10, "json": 5}
}
```

**Boost Weight Configuration**:
```json
{
  "boost_weights": {
    "matching_language": 1.5,
    "general_docs": 1.0,
    "non_matching_language": 0.7
  },
  "language_source_mapping": {
    "python": ["c0e629a894699314"],
    "typescript": ["f3246532dd189ef4"],
    "general": ["0475da390fe5f210", "b6fcee627ca78458"]
  }
}
```

### Integrations

| System | Integration Point | Purpose |
|--------|------------------|---------|
| Archon MCP | RAG queries | Apply boost weights to search results |
| Archon MCP | Code examples | Filter by detected language |
| File System | Prime cache | Store/read `.prime-cache.json` |
| File System | Project detection | Scan for language markers |

### Performance

| Metric | Requirement |
|--------|-------------|
| Language detection | < 500ms |
| Hash comparison (1000 files) | < 2 seconds |
| RAG query with boost weights | < 5 seconds |
| Full prime (first time) | < 60 seconds |
| Diff prime (subsequent) | < 30 seconds |

### Security

- Prime cache contains file paths and hashes only (no content)
- Cache file excluded from version control
- No sensitive data in boost weight configuration
- RAG queries respect Archon's existing security model

---

## Dependencies

### Required
- Archon MCP server (running and healthy)
- File system access (read for detection, write for cache)
- Existing workflow commands (`.claude/commands/`)

### Optional
- Contextual embedding enabled in Archon (for accuracy improvement)
- Hybrid BM25 + semantic search in Archon (for best results)

---

## Risks & Assumptions

### Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Archon API changes | High | Low | Version pin, monitor releases |
| False language detection | Medium | Medium | Confidence threshold, manual override |
| Cache corruption | Low | Low | Validation on read, auto-rebuild |
| Boost weights too aggressive | Medium | Medium | Configurable, sensible defaults |

### Assumptions

1. Archon MCP server supports result ranking/weighting
2. File markers are reliable indicators of project language
3. Users prefer relevant results over comprehensive results
4. Token savings justify implementation effort
5. Contextual embedding can be enabled in Archon settings

---

## Out of Scope (Future)

- Token Usage Monitoring Agent (tracking where tokens are wasted)
- Semantic Context Cache (embedding codebase for similarity search)
- Cross-session context persistence (remembering state between sessions)
- Multi-language project support (projects with equal Python/TypeScript)

---

## Source Documents

- **Discovery**: [discovery-2026-01-29T00-43-01Z](./discovery/discovery-2026-01-29T00-43-01Z.md)
- **MVP**: [MVP.md](./MVP.md)
- **Research**: [Anthropic Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval)
