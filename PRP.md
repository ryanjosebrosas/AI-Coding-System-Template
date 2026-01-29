# PRP: Smart Context Retrieval System

**Version**: 1.0 | **Last Updated**: 2026-01-29 | **Related**: PRD.md, TECH-SPEC.md

## Goal

Implement a smart context retrieval system that improves RAG query accuracy through language-aware filtering and reduces token usage through diff-based prime caching. Target: 90%+ retrieval accuracy, 50%+ token savings.

## Deliverables

1. Language detection system (file markers + extension fallback)
2. Boost weight configuration and application
3. Diff-based prime command with caching
4. Contextual embedding documentation
5. Debug mode for transparency

## Success Criteria

- [ ] Language detection correctly identifies Python/TypeScript/Go/Rust projects
- [ ] Boost weights applied to RAG results (1.5x matching, 1.0x general, 0.7x non-matching)
- [ ] Prime cache reduces subsequent prime token usage by 50%+
- [ ] Cache corruption auto-recovers
- [ ] All acceptance criteria from PRD user stories met

---

## All Needed Context

### Documentation URLs

- [Anthropic Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval) - Core technique reference
- [MCP Documentation](https://modelcontextprotocol.io/) - Protocol reference
- [Archon MCP Tools](./CLAUDE.md) - Local tool reference

### File References

| File | Purpose |
|------|---------|
| `.claude/commands/prime.md` | Prime command to modify |
| `.claude/settings.local.json` | Settings for boost weights |
| `CLAUDE.md` | Archon integration docs |
| `AGENT.md` | Universal instructions |

### Naming Conventions

- Cache files: `.{name}-cache.json` (dot-prefixed, git-ignored)
- Settings: `.claude/settings.local.json`
- Commands: `.claude/commands/{name}.md`

### Architecture Patterns

```
Context Middleware Layer:
┌─────────────────┐
│ Language        │ → Detects project type from markers/extensions
│ Detector        │
└────────┬────────┘
         │
┌────────▼────────┐
│ Boost Weight    │ → Applies weights to RAG results
│ Applier         │
└────────┬────────┘
         │
┌────────▼────────┐
│ Prime Cache     │ → Manages .prime-cache.json for diff output
│ Manager         │
└─────────────────┘
```

---

## Implementation Blueprint

### Data Models

**Prime Cache** (`.prime-cache.json`):
```json
{
  "version": "1.0",
  "created_at": "ISO8601",
  "files": {
    "path": {"hash": "sha256", "size": 0, "modified": "ISO8601"}
  }
}
```

**Boost Settings** (`.claude/settings.local.json`):
```json
{
  "smart_context": {
    "enabled": true,
    "boost_weights": {"matching": 1.5, "general": 1.0, "non_matching": 0.7},
    "language_sources": {"python": [...], "typescript": [...], "general": [...]}
  }
}
```

### Implementation Tasks

| Order | Task | Phase | Estimate |
|-------|------|-------|----------|
| 100 | Add boost weight configuration | Phase 1 | 1h |
| 95 | Implement language detection (markers) | Phase 1 | 2h |
| 90 | Implement extension fallback | Phase 1 | 1h |
| 85 | Integrate boost weights with RAG | Phase 1 | 2h |
| 80 | Implement file hash generation | Phase 2 | 2h |
| 75 | Create prime cache management | Phase 2 | 2h |
| 70 | Modify prime output format | Phase 2 | 2h |
| 65 | Add --full and --reset flags | Phase 2 | 1h |
| 60 | Create contextual embedding guide | Phase 3 | 1h |
| 55 | Add debug mode | Phase 3 | 1h |
| 50 | Update .gitignore | Phase 3 | 30m |
| 48 | Update /check cleanup (cache + discovery) | Phase 3 | 1h |
| 45 | Test and validate | Phase 3 | 2h |

### Dependencies

```
Phase 1 (Language Detection):
  Task 100 (config) → Task 95 (markers) → Task 90 (fallback) → Task 85 (integrate)

Phase 2 (Diff Prime):
  Task 80 (hash) → Task 75 (cache) → Task 70 (output) → Task 65 (flags)

Phase 3 (Polish):
  Task 60 (docs) | Task 55 (debug) | Task 50 (gitignore) → Task 45 (test)
```

### File Structure

```
AI Coding Template/
├── .prime-cache.json          # NEW: Prime cache (git-ignored)
├── .claude/
│   ├── commands/
│   │   └── prime.md           # MODIFY: Add diff-based output
│   └── settings.local.json    # MODIFY: Add smart_context section
├── docs/
│   └── contextual-embedding-guide.md  # NEW: Setup documentation
└── .gitignore                 # MODIFY: Add .prime-cache.json
```

---

## Validation Loop

### Syntax Validation

- JSON schema validation for cache and settings files
- Markdown lint for documentation

### Unit Tests

| Component | Test |
|-----------|------|
| Language Detector | Marker detection, fallback, edge cases |
| Hash Generator | Correct hashes, change detection |
| Boost Applier | Weight application, sorting |

### Integration Tests

| Scenario | Expected |
|----------|----------|
| Python project RAG | Python sources rank higher |
| Prime with changes | Only changed files detailed |
| Cache corruption | Auto-rebuild |

### End-to-End Tests

- Full workflow: detect → boost → query → verify results
- Prime: first run → change file → second run → verify diff output
- Token measurement: compare before/after

---

## Anti-Patterns

### Avoid

- **Hard filtering**: Don't exclude non-matching languages entirely
- **Eager caching**: Don't cache everything, use lazy loading
- **Silent failures**: Always inform user of fallbacks
- **Over-engineering**: Keep implementation minimal (YAGNI)

### Prefer

- **Soft filtering**: Boost/reduce weights, don't exclude
- **Lazy loading**: Detect only when needed
- **Transparent fallbacks**: Log when using defaults
- **Simplicity**: Minimal viable implementation first

---

## Archon Project Reference

**Project ID**: `451d02b1-df47-4fef-898a-a63f896c868a`
**Project Title**: Smart Context Retrieval System

### Task IDs

| Task | ID |
|------|-----|
| Add boost weight configuration | d1a188ad-d5ea-4904-ab32-5bd4502f6115 |
| Implement language detection (markers) | 96799df4-5021-4eb0-b83c-eb94e13f9eca |
| Implement extension fallback | 7078b6aa-1fb4-406c-9901-367cb5424aa8 |
| Integrate boost weights with RAG | 85e09b6e-5ffd-49da-a8a3-49b53a4046c5 |
| Implement file hash generation | 2663195f-9cd2-4d98-95da-438922b9a87b |
| Create prime cache management | 26595e7b-7ebb-4d09-8e56-b213dd9c1e6b |
| Modify prime output format | 05cab092-11e3-46d3-97ea-06a76faa2a33 |
| Add --full and --reset flags | c53701a9-b0fe-4ddc-9903-4b0f2029c05e |
| Create contextual embedding guide | b590a33c-9ffc-44ae-bd33-04481dc47927 |
| Add debug mode | 77cf0895-be97-44b6-bca5-ad7c5a0f3b52 |
| Update .gitignore | 332b2775-9ff9-4633-b9a1-60b52350e03b |
| Update /check cleanup | 47785acc-3b72-4e38-8eb4-5fe6f52d9899 |
| Test and validate | c700ab4e-d98b-493e-a6ca-fb910aed306b |
