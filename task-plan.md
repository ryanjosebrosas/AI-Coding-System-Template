# Task Plan: Smart Context Retrieval System

**Generated**: 2026-01-29T01:02:00Z
**PRP Version**: 1.0
**Total Tasks**: 13
**Archon Project ID**: 451d02b1-df47-4fef-898a-a63f896c868a

## Task List

| Order | Task ID | Task Title | Phase | Estimate | Status |
|-------|---------|------------|-------|----------|--------|
| 100 | d1a188ad | Add boost weight configuration to settings | Phase 1 | 1h | todo |
| 95 | 96799df4 | Implement language detection from file markers | Phase 1 | 2h | todo |
| 90 | 7078b6aa | Implement extension fallback for language detection | Phase 1 | 1h | todo |
| 85 | 85e09b6e | Integrate boost weights with RAG queries | Phase 1 | 2h | todo |
| 80 | 2663195f | Implement file hash generation for prime cache | Phase 2 | 2h | todo |
| 75 | 26595e7b | Create prime cache management | Phase 2 | 2h | todo |
| 70 | 05cab092 | Modify prime command output format | Phase 2 | 2h | todo |
| 65 | c53701a9 | Add --full and --reset flags to prime | Phase 2 | 1h | todo |
| 60 | b590a33c | Create contextual embedding setup guide | Phase 3 | 1h | todo |
| 55 | 77cf0895 | Add debug mode for weight transparency | Phase 3 | 1h | todo |
| 50 | 332b2775 | Update .gitignore and finalize configuration | Phase 3 | 30m | todo |
| 48 | 47785acc | Update /check to reset cache and clean discoveries | Phase 3 | 1h | todo |
| 45 | c700ab4e | Test and validate all features | Phase 3 | 2h | todo |

**Total Estimated Effort**: ~18.5 hours

## Execution Order

### Phase 1: Language Detection + Boost Weights (~6h)

1. **Task 100**: Add boost weight configuration to settings
   - Add `smart_context` section to `.claude/settings.local.json`
   - Define boost weights and language-source mapping

2. **Task 95**: Implement language detection from file markers
   - Scan for: requirements.txt, package.json, go.mod, Cargo.toml
   - Return detected_language, confidence, markers_found

3. **Task 90**: Implement extension fallback for language detection
   - Count files by extension when no markers found
   - 40% threshold for primary language

4. **Task 85**: Integrate boost weights with RAG queries
   - Modify RAG workflow to apply weights
   - Update CLAUDE.md with new behavior

### Phase 2: Diff-Based Prime (~7h)

5. **Task 80**: Implement file hash generation for prime cache
   - SHA-256 hashing for file content
   - Store path, hash, size, modified timestamp

6. **Task 75**: Create prime cache management
   - Create/load/validate `.prime-cache.json`
   - Handle cache corruption with auto-rebuild

7. **Task 70**: Modify prime command output format
   - Full detail for changed files
   - Summary for unchanged files

8. **Task 65**: Add --full and --reset flags to prime
   - --full: bypass cache
   - --reset: clear cache before run

### Phase 3: Documentation + Polish (~5.5h)

9. **Task 60**: Create contextual embedding setup guide
   - How to enable in Archon
   - Re-indexing process
   - Cost implications

10. **Task 55**: Add debug mode for weight transparency
    - Show detected language
    - Show applied weights

11. **Task 50**: Update .gitignore and finalize configuration
    - Add .prime-cache.json
    - Verify settings

12. **Task 48**: Update /check to reset cache and clean discoveries
    - Delete .prime-cache.json during /check
    - Delete discovery/*.md (except INDEX.md) during /check

13. **Task 45**: Test and validate all features
    - End-to-end testing
    - Verify 50% token savings

## Archon Commands Reference

### Start a task
```
manage_task("update", task_id="{id}", status="doing")
```

### Complete a task
```
manage_task("update", task_id="{id}", status="done")
```

### View all tasks
```
find_tasks(project_id="451d02b1-df47-4fef-898a-a63f896c868a")
```

## Next Steps

1. Start with **Task 100** (Add boost weight configuration)
2. Follow execution order through Phase 1 → Phase 2 → Phase 3
3. Mark tasks `doing` when starting, `done` when complete
4. Run `/execution` to begin implementation

## Source Documents

- **PRP**: [PRP.md](./PRP.md)
- **PRD**: [PRD.md](./PRD.md)
- **Tech Spec**: [TECH-SPEC.md](./TECH-SPEC.md)
- **Discovery**: [discovery-2026-01-29T00-43-01Z](./discovery/discovery-2026-01-29T00-43-01Z.md)
