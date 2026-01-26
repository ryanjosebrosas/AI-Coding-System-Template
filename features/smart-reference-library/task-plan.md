# Task Plan: Smart Reference Library

**Generated**: 2026-01-24T11:24:00Z
**PRP Version**: 1.0
**Total Tasks**: 7
**Archon Project ID**: `acf45b67-51aa-475d-b4cc-7c1055b4a032`

## Task List

| Task ID | Task Title | Dependencies | Priority | Estimate | Status |
|---------|------------|--------------|----------|----------|--------|
| `da02cd4b-208c-48ca-9089-88edb1ee47ef` | Run SQL migration for archon_references table | None | 100 | 5 min | todo |
| `4e570391-cbeb-4439-90c3-ead0254137f2` | Create /learn command file | Task 1 | 90 | 1 hour | todo |
| `ed1fea70-2c91-4a98-9d2b-2655f49f58b8` | Create /learn-health command file | Task 1 | 80 | 45 min | todo |
| `a259b76e-7201-4f80-9f61-894dbfdaaedc` | Update PRP templates with Reference Library section | Tasks 2,3 | 70 | 30 min | todo |
| `28e0409f-b91b-4bee-be20-23176ab8ea8b` | Update CLAUDE.md with Reference Library documentation | Tasks 2,3 | 60 | 30 min | todo |
| `3fa7bbe6-2ebd-4e7a-bf70-cdca8cea43b5` | Test /learn command end-to-end | Tasks 1-5 | 50 | 30 min | todo |
| `40648c16-1af0-4d2e-9e59-83df45e0421a` | Test /learn-health command | Tasks 1-5 | 40 | 30 min | todo |

## Execution Order

1. **Task da02cd4b**: Run SQL migration for archon_references table
2. **Task 4e570391**: Create /learn command file
3. **Task ed1fea70**: Create /learn-health command file
4. **Task a259b76e**: Update PRP templates with Reference Library section
5. **Task 28e0409f**: Update CLAUDE.md with Reference Library documentation
6. **Task 3fa7bbe6**: Test /learn command end-to-end
7. **Task 40648c16**: Test /learn-health command

## Next Steps

1. Run migration `012_add_smart_reference_library.sql` in Supabase SQL Editor
2. Mark Task 1 as `doing` then `done` in Archon
3. Proceed to Task 2: Create /learn command
4. Track progress in Archon MCP

## Commands

```bash
# Mark task as doing
manage_task("update", task_id="da02cd4b-208c-48ca-9089-88edb1ee47ef", status="doing")

# Mark task as done
manage_task("update", task_id="da02cd4b-208c-48ca-9089-88edb1ee47ef", status="done")

# Get next todo task
find_tasks(filter_by="status", filter_value="todo")
```
