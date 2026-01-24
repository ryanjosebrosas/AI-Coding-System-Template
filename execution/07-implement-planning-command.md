---
archon_task_id: 53d4d1c6-4326-4f1b-9c99-5949fab5d80c
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 115
assignee: User
created_at: 2026-01-23T16:33:00.396929+00:00
updated_at: 2026-01-23T16:53:38.295072+00:00
---

# 07: Implement Planning Command

**Status:** Done

## Description
Create .claude/commands/planning.md - load discovery, create feature directory, generate PRD.

## Implementation Steps

### Command Structure
- [ ] Create planning.md with YAML frontmatter
- [ ] Define feature-name parameter
- [ ] Document planning flow

### Discovery Loading
- [ ] Find latest discovery document
- [ ] Load from discovery/ directory
- [ ] Parse insights and recommendations
- [ ] Extract feature concept

### Feature Directory Creation
- [ ] Create features/{feature-name}/ directory
- [ ] Create subdirectories:
  - src/ (implementation files)
  - tests/ (test files)
  - docs/ (feature documentation)
- [ ] Create INDEX.md in feature directory

### PRD Generation
- [ ] Analyze discovery insights
- [ ] Define feature scope
- [ ] Create features/{feature-name}/prd.md with:
  - Overview
  - Goals
  - Requirements (functional/non-functional)
  - Success Criteria
  - Dependencies

### Documentation Standards
- [ ] Keep PRD under 600 lines (YAGNI)
- [ ] Use concise language (KISS)
- [ ] Focus on essential requirements only

### STATUS.md Update
- [ ] Create/update STATUS.md
- [ ] Set phase to "planning"
- [ ] Add feature to tracking

### Archon Integration
- [ ] Create or update project for feature
- [ ] Create initial planning tasks

## References
- .claude/commands/template.md - Command template
- discovery/*.md - Discovery documents
- CLAUDE.md - Documentation standards
