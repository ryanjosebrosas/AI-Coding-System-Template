---
name: execution
description: "Execute tasks step-by-step with Archon tracking"
user-invocable: true
disable-model-invocation: false
---

# Execution Skill

Execute tasks step-by-step following the task plan and PRP guidance.

## Execution Flow

1. **Load Task Plan** - Read `features/{feature}/task-plan.md`
2. **Load PRP** - Read implementation blueprint
3. **Verify Archon** - Check MCP availability
4. **Execute Tasks** - One at a time, following dependencies
5. **Track Progress** - Update Archon and STATUS.md
6. **Checkpoint** - Save state for resume capability

## Task Execution

For each task:
1. Mark as "doing" in Archon
2. Read task file from `execution/`
3. Follow PRP Implementation Blueprint
4. Execute task steps
5. Mark as "done" in Archon
6. Delete task file from `execution/`

## Error Handling

| Error | Response |
|-------|----------|
| Task fails | Log error, checkpoint state, suggest recovery |
| Archon unavailable | Stop, inform user, wait for availability |
| Validation fails | Log errors, suggest fixes, ask user |

## Checkpoint Format

```json
{
  "last_completed_task": "task-id",
  "current_phase": "execution",
  "timestamp": "ISO8601",
  "files_created": [],
  "files_modified": []
}
```

## Output

- `features/{feature}/execution.md` - Execution log
- Updated STATUS.md with progress
- Deleted task files (as completed)

## Reference

Full implementation details: `.claude/commands/execution.md`
