---
name: update-status
description: Update STATUS.md file with phase progress, artifacts, and next steps
phase: utility
inputs:
  - feature_path: Path to feature directory (e.g., "features/ai-coding-workflow-system")
  - action: Action to perform - create, update-phase, add-artifact, update-next-steps, update-checkpoint
  - phase: Phase name to update (Prime, Discovery, Planning, Development, Task Planning, Execution, Review, Test)
  - completed: Whether phase is completed (true/false)
  - set_current: Whether to set as current phase (true/false)
  - artifact_name: Name of artifact file to add
  - artifact_description: Description of artifact (optional)
  - next_steps: Description of next steps
  - task_id: ID or description of last completed task (for checkpoint)
outputs:
  - Updated STATUS.md file
dependencies:
  - Feature directory must exist
  - STATUS.md may or may not exist (will create if missing)
---

# Update STATUS Command

## Purpose

Update or create STATUS.md files to track feature development progress through all phases of the workflow.

## When to Use

Use this command during feature development:
- After Planning command creates feature directory (create STATUS.md)
- After any phase completes (mark phase as completed)
- After generating artifacts (add artifact to STATUS.md)
- Before starting next phase (update next steps)
- After completing tasks (update checkpoint)

## Execution Steps

### Step 1: Determine Action

Extract action from command context:
- `create`: Create new STATUS.md from template
- `update-phase`: Mark phase as completed and/or set current phase
- `add-artifact`: Add generated artifact to STATUS.md
- `update-next-steps`: Update next steps description
- `update-checkpoint`: Update checkpoint timestamp and last completed task

### Step 2: Read Existing STATUS.md

If action is not `create`:
1. Check if `{feature_path}/STATUS.md` exists
2. If exists, read current content
3. Parse current phase, completed phases, artifacts

### Step 3: Perform Action

#### Action: create

1. Create STATUS.md from template
2. Replace {feature-name} with actual feature name
3. Replace {timestamp} with current timestamp
4. Set initial phase (default: Planning)
5. All phases marked as incomplete

#### Action: update-phase

1. Update specified phase checkbox: `- [ ]` to `- [x]` if completed=true
2. If set_current=true, update Current Phase to specified phase
3. Update checkpoint timestamp
4. Validate phase order (can't skip phases unless resuming)

Phase order: Prime → Discovery → Planning → Development → Task Planning → Execution → Review → Test

#### Action: add-artifact

1. Add artifact to Generated Artifacts section
2. Remove from Pending Artifacts section
3. Include creation timestamp
4. Format: `- `{artifact_name}` - Created: {timestamp} - {description}`

#### Action: update-next-steps

1. Update Next Steps section
2. Provide clear, actionable next steps
3. Update checkpoint timestamp

#### Action: update-checkpoint

1. Update Checkpoint section
2. Set Last updated timestamp
3. Set Last completed task

## STATUS.md Format

```markdown
# Feature: {feature-name}

## Current Phase
{current-phase}

## Progress

### Completed Phases
- [x] Prime
- [x] Discovery
- [ ] Planning
- [ ] Development
- [ ] Task Planning
- [ ] Execution
- [ ] Review
- [ ] Test

## Artifacts

### Generated Artifacts
- `prd.md` - Created: 2026-01-23T16:00:00Z
- `tech-spec.md` - Created: 2026-01-23T17:00:00Z
- `prp.md` - Created: 2026-01-23T18:00:00Z
- `task-plan.md` - Created: 2026-01-23T18:30:00Z

### Pending Artifacts
- `execution.md` - To be created in Execution phase
- `review.md` - To be created in Review phase
- `test-results.md` - To be created in Test phase

## Next Steps
{description of next steps}

## Checkpoint
Last updated: 2026-01-23T18:30:00Z
Last completed task: Generated task plan with 12 tasks
```

## Usage Examples

### Create STATUS.md for new feature

```
/update-status feature_path="features/ai-coding-workflow-system" action="create" phase="Planning"
```

### Mark Planning phase complete, set Development as current

```
/update-status feature_path="features/ai-coding-workflow-system" action="update-phase" phase="Planning" completed=true set_current=false
/update-status feature_path="features/ai-coding-workflow-system" action="update-phase" phase="Development" completed=false set_current=true
```

### Add PRD artifact

```
/update-status feature_path="features/ai-coding-workflow-system" action="add-artifact" artifact_name="prd.md" artifact_description="Product Requirements Document"
```

### Update next steps

```
/update-status feature_path="features/ai-coding-workflow-system" action="update-next-steps" next_steps="Generate tech spec from PRD"
```

### Update checkpoint after task completion

```
/update-status feature_path="features/ai-coding-workflow-system" action="update-checkpoint" task_id="Created directory structure"
```

## Phase Definitions

| Phase | Description | Artifacts |
|-------|-------------|-----------|
| Prime | Codebase context export | context/prime-*.md |
| Discovery | Ideas and opportunities | discovery/discovery-*.md |
| Planning | PRD generation | prd.md |
| Development | Tech spec generation | tech-spec.md |
| Task Planning | PRP and tasks | prp.md, task-plan.md |
| Execution | Task implementation | execution.md |
| Review | Code review | review.md |
| Test | Test execution | test-results.md |

## Error Handling

### If STATUS.md doesn't exist
- Create new STATUS.md from template
- Initialize with specified phase
- Set all phases as incomplete

### If STATUS.md is corrupted
- Detect corruption (missing sections, invalid format)
- Backup existing file to STATUS.md.backup
- Regenerate STATUS.md from template
- Attempt to recover phase/artifact data from backup

### If phase update fails
- Verify phase name is valid
- Check STATUS.md format
- Validate phase order
- Log error and continue

### If feature directory doesn't exist
- Create directory first
- Then create STATUS.md
- Report permission errors if unable to create

## Validation

After updating STATUS.md:
- [ ] File was created or updated successfully
- [ ] Current phase is correct
- [ ] Completed phases are marked with [x]
- [ ] Artifacts listed correctly
- [ ] Next steps are clear and actionable
- [ ] Checkpoint timestamp is current
- [ ] Phase order is valid

## Integration with Commands

### Planning Command
After creating feature directory and generating PRD:
```
/update-status feature_path="features/{feature-name}" action="create" phase="Planning"
/update-status feature_path="features/{feature-name}" action="add-artifact" artifact_name="prd.md"
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Planning" completed=true set_current=false
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Development" completed=false set_current=true
```

### Development Command
After generating tech-spec:
```
/update-status feature_path="features/{feature-name}" action="add-artifact" artifact_name="tech-spec.md"
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Development" completed=true set_current=false
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Task Planning" completed=false set_current=true
```

### Task Planning Command
After generating PRP and task-plan:
```
/update-status feature_path="features/{feature-name}" action="add-artifact" artifact_name="prp.md"
/update-status feature_path="features/{feature-name}" action="add-artifact" artifact_name="task-plan.md"
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Task Planning" completed=true set_current=false
/update-status feature_path="features/{feature-name}" action="update-phase" phase="Execution" completed=false set_current=true
```

## Notes

- Use ISO 8601 format for timestamps: YYYY-MM-DDTHH:mm:ssZ
- Phase names must match exactly (case-sensitive)
- Checkboxes use markdown format: `- [ ]` for incomplete, `- [x]` for complete
- Next steps should be specific and actionable
- Checkpoint enables error recovery and resume functionality
- STATUS.md serves as single source of truth for feature progress
