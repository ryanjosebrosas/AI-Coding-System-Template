---
archon_task_id: e257f7e0-021f-4ff9-b0f2-6942fefcdf2f
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 101
assignee: User
created_at: 2026-01-23T16:33:27.043969+00:00
updated_at: 2026-01-23T16:55:42.024135+00:00
---

# 14: Implement Review Command

**Status:** Done

## Description
Create .claude/commands/review.md - analyze code changes, generate review report, verify compliance.

## Implementation Steps

### Command Structure
- [ ] Create review.md with YAML frontmatter
- [ ] Define feature parameter
- [ ] Document review process

### Change Detection
- [ ] Get git diff for feature branch
- [ ] Identify modified files
- [ ] Parse change statistics

### Code Analysis
- [ ] Review code quality
- [ ] Check for security vulnerabilities
- [ ] Verify adherence to patterns
- [ ] Assess performance implications

### Compliance Verification
- [ ] Check against PRP requirements
- [ ] Validate TECH-SPEC compliance
- [ ] Verify YAGNI/KISS principles followed

### Report Generation
- [ ] Create review report in reviews/ directory
- [ ] Include quality score
- [ ] List issues found with severity
- [ ] Provide improvement suggestions

### Archon Integration
- [ ] Find review tasks for feature
- [ ] Update task status to review/done

## References
- .claude/commands/template.md - Command template
- features/{feature}/ - Feature code to review
- features/{feature}/prp.md - Requirements to verify
- reviews/ directory - Review reports
