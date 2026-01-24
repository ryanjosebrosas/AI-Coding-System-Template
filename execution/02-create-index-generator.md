---
archon_task_id: 003f73e6-422a-4e51-bfbd-84876c859f23
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 125
assignee: User
created_at: 2026-01-23T16:32:50.395773+00:00
updated_at: 2026-01-23T16:39:14.872145+00:00
---

# 02: Create INDEX.md Generator

**Status:** Done

## Description
Implement INDEX.md generation utility with template format, auto-update on file creation, navigation links.

## Implementation Steps

### INDEX.md Template Design
- [ ] Define standard INDEX.md structure:
  - Directory purpose
  - File listing
  - Navigation links
  - Quick reference
- [ ] Create template for consistency

### Directory Structure Scan
- [ ] Use Glob to scan directory contents
- [ ] Filter by file type
- [ ] Sort files alphabetically
- [ ] Generate markdown listing

### Auto-Update Mechanism
- [ ] Integrate with file creation commands
- [ ] Update INDEX.md when files added
- [ ] Maintain existing content
- [ ] Preserve custom sections

### Root INDEX.md
- [ ] Create root INDEX.md
- [ ] Add project overview
- [ ] Link to all subdirectory INDEX.md files

### Subdirectory INDEX.md Files
- [ ] Create INDEX.md in:
  - context/
  - discovery/
  - features/
  - templates/
  - templates/prp/
  - reviews/
  - testing/
  - execution/

### Navigation Links
- [ ] Add breadcrumb navigation
- [ ] Link to parent directories
- [ ] Link to sibling directories
- [ ] Link to child directories

### /update-index Command
- [ ] Create .claude/commands/update-index.md
- [ ] Generate or update INDEX.md for specified directory
- [ ] Support recursive updates

## References
- PRD.md - Directory structure requirements
- .claude/commands/update-index.md - Update command
