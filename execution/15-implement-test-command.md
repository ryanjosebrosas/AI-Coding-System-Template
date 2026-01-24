---
archon_task_id: 22bb15c6-2ff9-4eef-b65f-a7cd9b22d87f
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 99
assignee: User
created_at: 2026-01-23T16:33:31.711601+00:00
updated_at: 2026-01-23T16:55:42.706488+00:00
---

# 15: Implement Test Command

**Status:** Done

## Description
Create .claude/commands/test.md - run test suites, detect errors, AI-suggested fixes, generate test report.

## Implementation Steps

### Command Structure
- [ ] Create test.md with YAML frontmatter
- [ ] Define feature parameter
- [ ] Document test execution flow

### Test Discovery
- [ ] Search for test files in features/{feature}/testing/
- [ ] Identify test frameworks being used
- [ ] Parse test configuration

### Test Execution
- [ ] Run test suites
- [ ] Capture test output
- [ ] Collect error information

### Error Analysis
- [ ] Parse test failures
- [ ] Identify root causes
- [ ] Generate AI-suggested fixes

### Report Generation
- [ ] Create test report in testing/ directory
- [ ] Include pass/fail statistics
- [ ] List errors with suggested fixes
- [ ] Add coverage information if available

### Archon Integration
- [ ] Find testing-related tasks
- [ ] Update task status based on results

## References
- .claude/commands/template.md - Command template
- features/{feature}/testing/ - Test files
- testing/ directory - Test reports
