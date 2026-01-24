---
archon_task_id: 7baadefd-9436-46ea-9604-12376665eac2
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 105
assignee: User
created_at: 2026-01-23T16:33:18.377478+00:00
updated_at: 2026-01-23T16:55:40.675683+00:00
---

# 12: Implement Task Planning Command

**Status:** Done

## Description
Create .claude/commands/task-planning.md - load contexts, select PRP template, generate PRP, create Archon tasks.

## Implementation Steps

### Command Structure
- [ ] Create task-planning.md with YAML frontmatter
- [ ] Define feature parameter
- [ ] Document task planning flow

### Context Loading
- [ ] Load PRD from features/{feature}/prd.md
- [ ] Load TECH-SPEC from features/{feature}/tech-spec.md
- [ ] Gather codebase patterns
- [ ] Collect relevant references

### PRP Template Selection
- [ ] Analyze feature type
- [ ] Select appropriate PRP template:
  - prp-base.md (default)
  - ai-agent.md
  - mcp-integration.md
  - api-endpoint.md
  - frontend-component.md

### PRP Generation
- [ ] Extract requirements from PRD
- [ ] Map technical details from TECH-SPEC
- [ ] Create Implementation Blueprint with ordered tasks
- [ ] Add Validation Loop section
- [ ] Include Known Gotchas

### PRP Storage
- [ ] Create features/{feature}/prp.md
- [ ] Save generated PRP

### Archon Task Creation
- [ ] Create project in Archon if needed
- [ ] Parse Implementation Blueprint tasks
- [ ] Create tasks via manage_task with proper:
  - title
  - description
  - task_order (priority)
  - dependencies (via addBlockedBy)
- [ ] Link tasks to PRP in descriptions

### Validation
- [ ] Verify all tasks created
- [ ] Check dependency chains
- [ ] Confirm PRP completeness

## References
- .claude/commands/template.md - Command template
- templates/prp/*.md - PRP templates
- features/{feature}/prd.md - Feature requirements
- features/{feature}/tech-spec.md - Technical specifications
