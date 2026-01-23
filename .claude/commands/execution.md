---
name: Execution
description: "Execute tasks step-by-step following task plan and PRP guidance"
phase: execution
dependencies: [task-planning]
outputs:
  - path: "features/{feature-name}/execution.md"
    description: "Execution log showing progress through tasks"
  - path: "features/{feature-name}/STATUS.md"
    description: "Updated status showing execution progress"
inputs:
  - path: "features/{feature-name}/task-plan.md"
    description: "Task plan with ordered tasks and dependencies"
    required: true
  - path: "features/{feature-name}/prp.md"
    description: "PRP document with implementation guidance"
    required: true
---

# Execution Command

## Purpose

Execute tasks step-by-step following the task plan and PRP guidance. This command loads the task plan and PRP, executes tasks sequentially using Archon MCP for tracking, handles errors with checkpoint/resume, and updates STATUS.md with progress.

## Execution Steps

### Step 1: Load Task Plan and PRP

Load execution artifacts:

1. **Load task plan**:
   - Read `features/{feature-name}/task-plan.md`
   - Parse task list with dependencies
   - Extract task order and priorities

2. **Load PRP document**:
   - Read `features/{feature-name}/prp.md`
   - Parse implementation blueprint
   - Extract codebase patterns and validation commands

3. **Verify Archon MCP availability**:
   - Call `health_check()` to verify server is available
   - If unavailable, stop and inform user

**Expected Result**: Task plan and PRP loaded, Archon MCP verified.

### Step 2: Initialize Execution

Set up execution environment:

1. **Create execution log file**:
   - Create `features/{feature-name}/execution.md`
   - Add header with timestamp
   - Initialize task progress tracking

2. **Update STATUS.md**:
   - Mark current phase as "Execution - In Progress"
   - List all tasks as "Pending"

3. **Create checkpoint directory** (if needed):
   - Create `features/{feature-name}/checkpoints/` directory
   - For saving state between tasks

**Expected Result**: Execution environment initialized, STATUS.md updated.

### Step 3: Execute Tasks Sequentially

Execute each task following dependencies:

1. **For each task in task plan**:
   - Check task dependencies are complete
   - Mark task as "Doing" in Archon: `manage_task("update", task_id="...", status="doing")`
   - Load task context from PRP
   - Execute task following PRP Implementation Blueprint

2. **Task Execution**:
   - Read PRP section for current task
   - Follow step-by-step instructions
   - Create/modify files as specified
   - Run validation commands if specified

3. **Update Progress**:
   - Log task completion in `execution.md`
   - Mark task as "Review" in Archon: `manage_task("update", task_id="...", status="review")`
   - Update STATUS.md with progress

4. **Checkpoint State**:
   - Save checkpoint after each task completes
   - Store current state for resume capability

**Expected Result**: Tasks executed sequentially, progress tracked in Archon and STATUS.md.

### Step 4: Handle Errors

Implement comprehensive error handling:

1. **Task Execution Errors**:
   - Log error details in `execution.md`
   - Stop execution on critical errors
   - Allow manual recovery on non-critical errors
   - Provide error context and suggested fixes

2. **Checkpoint on Error**:
   - Save checkpoint before failing
   - Record error state
   - Enable resume from before failing task

3. **Error Recovery**:
   - Analyze error type (syntax, runtime, logic)
   - Suggest recovery action (fix, skip, retry)
   - Ask user for decision on blocking errors

**Expected Result**: Errors handled gracefully, checkpoints saved, recovery enabled.

### Step 5: Complete Execution

Finalize execution:

1. **Verify All Tasks Complete**:
   - Check all tasks marked as "Done" or "Review"
   - Run final validation if specified in PRP
   - Review execution log

2. **Update STATUS.md**:
   - Mark phase as "Execution - Completed"
   - Update artifact list
   - Add timestamp

3. **Generate Summary**:
   - Count completed tasks
   - Count failed tasks
   - Calculate execution time
   - Note any skipped tasks

**Expected Result**: Execution complete, STATUS.md updated, summary generated.

## Output Format

```markdown
# Execution Log: {feature-name}

**Started**: {timestamp}
**Completed**: {timestamp}
**Duration**: {duration}

## Task Progress

### Task 1: {task-name}
- **Status**: {Pending/Doing/Review/Done}
- **Started**: {timestamp}
- **Completed**: {timestamp}
- **Result**: {Success/Failure}
- **Notes**: {Any notes or issues}

### Task 2: {task-name}
... (repeat for all tasks)

## Summary
- **Total Tasks**: {count}
- **Completed**: {count}
- **Failed**: {count}
- **Skipped**: {count}
- **Duration**: {duration}

## Checkpoints
- Last checkpoint: {timestamp}
- Resume capability: {Available/Not available}
```

## Error Handling

- **Task Plan Not Found**: Check `features/{feature-name}/` directory, suggest running Task Planning first
- **PRP Not Found**: Check `features/{feature-name}/` directory, suggest running Task Planning first
- **Archon MCP Unavailable**: Stop execution, inform user, wait for availability (per ARCHON-FIRST RULE)
- **Task Execution Fails**: Log error, checkpoint state, suggest recovery
- **Validation Fails**: Log validation errors, suggest fixes, ask user

## Checkpoint & Resume

### Checkpoint Format
Save state after each task:
```json
{
  "last_completed_task": "task-id",
  "current_phase": "execution",
  "timestamp": "ISO8601-timestamp",
  "files_created": ["file1", "file2"],
  "files_modified": ["file3"]
}
```

### Resume Process
1. Load checkpoint file
2. Verify state is valid
3. Resume from next pending task
4. Continue execution

## Validation

Run validation as specified in PRP:
- Syntax validation: Run lint/format commands
- Unit tests: Run test suite if specified
- Integration tests: Run integration tests if specified
- Manual review: Prompt user for review if validation succeeds

## Notes

- Always use Archon MCP for task tracking (ARCHON-FIRST RULE)
- Never use TodoWrite fallback
- Update STATUS.md after each phase
- Checkpointing enables resume after interruptions
- Follow PRP Implementation Blueprint for each task
- Run PRP Validation Loop after task completion
