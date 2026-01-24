---
archon_task_id: f040f883-989e-453e-96f0-0d11da1eb62f
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 119
assignee: User
created_at: 2026-01-23T16:32:55.449094+00:00
updated_at: 2026-01-23T16:42:10.285648+00:00
---

# 05: Implement Prime Command

**Status:** Done

## Description
Create .claude/commands/prime.md - traverse codebase, export tree/contents, save to context/prime-{timestamp}.md.

## Implementation Steps

### Command Structure
- [ ] Create prime.md with YAML frontmatter
- [ ] Define command options
- [ ] Document export format

### Codebase Traversal
- [ ] Use Glob to discover all files
- [ ] Filter out common exclusions:
  - node_modules/
  - .git/
  - build/
  - dist/
  - *.log
  - .env files
- [ ] Organize by directory structure

### Content Export
- [ ] Generate file tree structure
- [ ] Read file contents with metadata:
  - File path
  - Line count
  - Language/extension
  - Last modified
- [ ] Format as structured markdown

### Output File Creation
- [ ] Create context/ directory if needed
- [ ] Save to context/prime-{timestamp}.md
- [ ] Include generation timestamp

### Format Specification
- [ ] Use consistent heading hierarchy
- [ ] Include table of contents
- [ ] Add file statistics summary
- [ ] Structure by directory

### Validation
- [ ] Verify all important files included
- [ ] Check file size limits (skip huge files)
- [ ] Ensure markdown is valid

## References
- .claude/commands/template.md - Command template
- context/ directory - Output location
