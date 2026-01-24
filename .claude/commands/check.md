---
name: Check
description: "Comprehensive codebase health check, cleanup, and documentation updates"
phase: independent
dependencies: []
outputs:
  - description: "Health report with issues found and fixes applied"
inputs: []
---

# Check Command

## Purpose

Perform comprehensive codebase health check, automatically fix issues, update outdated documentation, and clean up artifacts. This ensures the repository remains clean, consistent, and up-to-date.

## Execution Steps

### Step 1: Health Check Scan

Run systematic checks across the codebase:

**1.1 Check for required files:**
- `.gitignore` - Should exist with standard patterns
- `LICENSE` - Should exist (usually MIT)
- `README.md` - Should exist with project documentation
- `CLAUDE.md` - Should exist with developer guidelines
- `INDEX.md` - Should exist in root and subdirectories

**1.2 Check for artifact files:**
- `nul` - Windows artifact (45 bytes typically)
- `.DS_Store` - macOS artifact
- `Thumbs.db` - Windows thumbnail cache
- `*.tmp`, `*.temp` - Temporary files
- Files matching patterns in `.gitignore` that were accidentally committed

**1.3 Check documentation consistency:**
- Root `INDEX.md` - Should list all commands
- `features/INDEX.md` - Should reflect current feature statuses
- `context/INDEX.md` - Should list all prime exports
- `discovery/INDEX.md` - Should list all discovery documents
- `execution/INDEX.md` - Should list all execution tasks

**1.4 Check for outdated status references:**
- Feature STATUS.md files - Should match actual completion state
- Compare features/INDEX.md status with feature/STATUS.md
- Check for "Ready for X" phases that are actually complete

**1.5 Check command file integrity:**
- All commands in `.claude/commands/` should have proper YAML frontmatter
- All commands listed in INDEX.md should exist
- No orphaned or missing command files

**1.6 Check template files:**
- PRP templates should exist in `templates/prp/`
- STATUS.md template should exist in `.claude/templates/`

### Step 2: Automated Fixes

Apply fixes for common issues:

**2.1 Create missing .gitignore:**
```bash
# Create with standard patterns for Node, Python, IDE, OS, Claude
```

**2.2 Create missing LICENSE:**
```bash
# Create MIT License file (default, or ask user for preference)
```

**2.3 Delete artifact files:**
```bash
# Remove nul, .DS_Store, Thumbs.db, *.tmp, *.temp
```

**2.4 Update outdated INDEX.md entries:**
- Update feature statuses to match actual completion
- Update last updated dates
- Add missing commands to command tables
- Add completed features to status sections

**2.5 update .claude/settings.local.json permissions:**
- Add permissions for commonly used git commands
- Add permissions for Archon MCP tools used in project

### Step 3: Generate Health Report

Create comprehensive report showing:

```markdown
# Codebase Health Report

**Date**: {timestamp}
**Branch**: {current-branch}
**Commit**: {latest-commit-hash}

## Summary

- **Issues Found**: {count}
- **Issues Fixed**: {count}
- **Issues Requiring Manual Action**: {count}

## Issues Fixed

### Missing Files Created
- {file} - {reason}

### Artifacts Removed
- {file} - {size} - {reason}

### Documentation Updated
- {file} - {changes made}

## Issues Requiring Manual Action

### {issue-description}
- **File**: {file}
- **Problem**: {description}
- **Suggested Fix**: {recommendation}

## Health Score

- **Required Files**: {X}/{Y} present
- **Documentation**: {X}/{Y} up-to-date
- **Artifacts**: {X} found and cleaned
- **Overall**: {percentage}%

## Recommendations

1. {actionable recommendation}
2. {actionable recommendation}
```

### Step 4: Confirm Changes

Before committing, present summary to user:

```
Found {count} issues:
- {count} missing files (created)
- {count} artifact files (deleted)
- {count} outdated documentation (updated)
- {count} issues requiring manual review

Changes staged. Review above or run 'git diff' to see details.
```

**Ask user**: "Commit these changes? (y/n)"

### Step 5: Commit (If Approved)

If user approves, create commit with descriptive message:

```bash
git add .
git commit -m "Codebase health check and cleanup

- {summary of changes}

Health Score: {percentage}%
Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Check Items Reference

### Required Files

| File | Purpose | Template |
|------|---------|----------|
| `.gitignore` | Git ignore patterns | Standard template |
| `LICENSE` | License file | MIT (default) |
| `README.md` | Project documentation | Should exist |
| `CLAUDE.md` | Developer guidelines | Should exist |
| `INDEX.md` | Root navigation | Should exist |

### Artifact Patterns

| Pattern | Description | Action |
|---------|-------------|--------|
| `nul` | Windows artifact (45 bytes) | Delete |
| `.DS_Store` | macOS artifact | Delete |
| `Thumbs.db` | Windows thumbnail cache | Delete |
| `*.tmp` | Temporary files | Delete |
| `*.temp` | Temporary files | Delete |

### Documentation Sync Points

| File | Syncs With | Check Method |
|------|------------|--------------|
| `INDEX.md` | Command files | Commands in table exist in .claude/commands/ |
| `features/INDEX.md` | Feature STATUS.md | Statuses match actual phase |
| `context/INDEX.md` | Context exports | All prime-*.md files listed |
| `discovery/INDEX.md` | Discovery docs | All discovery-*.md files listed |

### Status Values (by phase)

| Phase | Status Value |
|-------|--------------|
| Discovery | "Discovery - Completed" |
| MVP | "MVP - Completed" |
| Planning | "Planning (PRD) - Completed" |
| Development | "Development (TECH-SPEC) - Completed" |
| Task Planning | "Task Planning - Completed" |
| Execution | "Execution - Completed" |
| Review | "Review - Completed" or "Review - In Progress" |
| Test | "Test - Completed" or "Test - In Progress" |

## Error Handling

**If .gitignore has issues:**
- Preserve existing entries
- Add missing standard patterns
- Don't remove user-specific entries

**If LICENSE exists but different:**
- Don't overwrite (user may have chosen different license)
- Note in report that license exists

**If manual review needed:**
- Clearly flag in report
- Provide specific recommendations
- Don't auto-fix, ask user

**If git has uncommitted changes:**
- Warn user before making changes
- Ask if they want to proceed or stash changes

## Notes

- Always ask before committing changes
- Preserve user preferences and configurations
- Don't modify code files, only documentation and meta-files
- Run checks before committing to ensure clean state
- Report issues clearly even if auto-fixed
