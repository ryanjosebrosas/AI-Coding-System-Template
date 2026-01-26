---
name: Workflow
description: "Unified workflow command for complete development lifecycle"
phase: workflow
dependencies: [prime, discovery, planning, development, task-planning, execution, review, test]
outputs:
  - path: "features/{feature-name}/STATUS.md"
    description: "Updated feature status tracking file after each phase"
inputs:
  - path: "features/{feature-name}/STATUS.md"
    description: "Feature status tracking file for resume support"
    required: false
---

# Workflow Command

## Purpose

Execute the complete development lifecycle by running all phases sequentially. This command orchestrates Prime, Discovery, Planning, Development, Task Planning, Execution, Review, and Test phases with progress tracking, error handling, and resume support.

**When to use**: Use this command to execute the entire workflow from start to finish, or to resume from a specific phase after an error.

**What it solves**: This command addresses the need for a single unified command that automates the complete development lifecycle with error recovery and progress tracking.

## Prerequisites

- All phase commands must exist (prime, discovery, planning, development, task-planning, execution, review, test)
- Archon MCP server should be available (recommended)
- Web MCP servers should be available (recommended)

## Execution Steps

### Step 1: Parse Arguments

**Objective**: Parse command arguments.

**Actions**:
1. Parse `/workflow <feature-name> [--from-<phase>]`
2. Extract feature name (required)
3. Extract `--from-<phase>` option (optional)
4. Validate feature name (kebab-case)
5. Validate phase name if provided

**Valid phases**: `prime`, `discovery`, `planning`, `development`, `task-planning`, `execution`, `review`, `test`

### Step 2: Determine Starting Phase

**Objective**: Determine which phase to start from.

**Actions**:
1. If `--from-<phase>` provided: Use that as starting phase
2. Else if STATUS.md exists: Resume from next incomplete phase
3. Else: Start from Prime (first phase)
4. Validate dependencies are met for starting phase

**Phase Order**: Prime → Discovery → Planning → Development → Task Planning → Execution → Review → Test

### Step 3: Execute Phases Sequentially

**Objective**: Execute each phase in order.

**Actions**:
For each phase starting from determined phase:
1. Check if phase already completed (skip if done)
2. Execute phase command:
   - Prime: `/prime`
   - Discovery: `/discovery`
   - Planning: `/planning {feature-name}`
   - Development: `/development {feature-name}`
   - Task Planning: `/task-planning {feature-name}`
   - Execution: `/execution {feature-name}`
   - Review: `/review {feature-name}`
   - Test: `/test {feature-name}`
3. Wait for completion
4. Update STATUS.md on success
5. On error: Log, create checkpoint, stop, allow resume

### Step 4: Progress Feedback

**Objective**: Provide progress feedback.

**Actions**:
1. Log phase start: "Starting phase {phase}..."
2. Log phase completion: "Phase {phase} completed ({duration})"
3. Log progress: "{completed}/{total} phases ({percentage}%)"
4. Update STATUS.md checkpoint

### Step 5: Error Recovery

**Objective**: Handle errors gracefully.

**Actions**:
1. Detect phase failure
2. Log error to console and STATUS.md
3. Create checkpoint
4. Provide resume command: `/workflow {feature-name} --from-{phase}`
5. Stop execution

## Output Format

**Console Output**:
```
[Workflow] Starting workflow for feature: {feature-name}
[Workflow] Starting phase: prime
[Workflow] Phase prime completed (2m 30s)
[Workflow] Progress: 1/8 phases (12.5%)
[Workflow] Starting phase: discovery
[Workflow] Phase discovery completed (1m 45s)
[Workflow] Progress: 2/8 phases (25%)
...
[Workflow] Workflow completed successfully!
[Workflow] Total duration: 45m 20s
[Workflow] Artifacts generated:
  - context/prime-{timestamp}.md
  - discovery/discovery-{timestamp}.md
  - features/{feature-name}/prd.md
  - features/{feature-name}/tech-spec.md
  - features/{feature-name}/prp.md
  - features/{feature-name}/task-plan.md
  - features/{feature-name}/execution.md
  - features/{feature-name}/review.md
  - features/{feature-name}/test-results.md
```

**Error Output**:
```
[Workflow] Error in phase {phase}:
{error_message}

[Workflow] To resume, run:
/workflow {feature-name} --from-{phase}

[Workflow] Checkpoint saved to STATUS.md
```

## Usage Examples

### Full Workflow

**Command**: `/workflow my-feature`

**Output**: Executes all 8 phases from Prime to Test

### Resume from Phase

**Command**: `/workflow my-feature --from-development`

**Output**: Starts from Development phase, continues through Test

## Error Handling

### Invalid Arguments
- Error: "Invalid arguments. Usage: /workflow <feature-name> [--from-<phase>]"

### Invalid Phase
- Error: "Invalid phase: {phase}. Valid phases: prime, discovery, planning, development, task-planning, execution, review, test"

### Dependencies Not Met
- Error: "Cannot resume from {phase}. Required phases {dependencies} must be completed first."

### Phase Execution Fails
- Log error
- Create checkpoint
- Provide resume command
- Stop execution

## Notes

- **Skip completed phases**: Workflow automatically skips phases already marked as completed in STATUS.md
- **Checkpoint system**: STATUS.md is updated after each phase for resume support
- **Progress tracking**: Real-time progress feedback provided throughout execution
- **Error recovery**: Resume from any failed phase using `--from-{phase}` option
- **Duration**: Total duration varies by feature complexity (typically 30-60 minutes)
- **Phase dependencies**: Each phase requires previous phases to complete first

## Phase Reference

| Phase | Command | Duration | Dependencies |
|-------|----------|----------|--------------|
| Prime | `/prime` | 2-5 min | None |
| Discovery | `/discovery` | 1-2 min | prime |
| Planning | `/planning {feature}` | 2-3 min | discovery |
| Development | `/development {feature}` | 1-2 min | planning |
| Task Planning | `/task-planning {feature}` | 3-5 min | development |
| Execution | `/execution {feature}` | varies | task-planning |
| Review | `/review {feature}` | 2-3 min | execution |
| Test | `/test {feature}` | varies | execution |
