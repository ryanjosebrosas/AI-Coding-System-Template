---
archon_task_id: de83d047-05df-486f-8286-174acfcd4769
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 97
assignee: User
created_at: 2026-01-23T16:33:36.665985+00:00
updated_at: 2026-01-23T16:55:43.523642+00:00
---

# 16: Implement Workflow Command

**Status:** Done

## Description
Create .claude/commands/workflow.md - unified command executing all phases, support --from-{phase} resume.

## Implementation Steps

### Command Structure
- [ ] Create workflow.md with YAML frontmatter
- [ ] Define command options and flags
- [ ] Document usage examples

### Phase Execution
- [ ] Implement phase sequence:
  1. /prime (if no context exists)
  2. /discovery
  3. /planning {feature}
  4. /development {feature}
  5. /task-planning {feature}
  6. /execution {feature}
  7. /review {feature}
  8. /test {feature}

### Resume Functionality
- [ ] Add --from-discovery flag
- [ ] Add --from-planning flag
- [ ] Add --from-development flag
- [ ] Implement state checking before resuming

### Progress Tracking
- [ ] Update STATUS.md after each phase
- [ ] Track artifacts created
- [ ] Log completion status

### Error Handling
- [ ] Handle phase failures gracefully
- [ ] Allow continuation after fixes
- [ ] Provide clear error messages

## References
- .claude/commands/template.md - Command template
- All other command files for phase implementations
- PRD.md - Workflow overview
