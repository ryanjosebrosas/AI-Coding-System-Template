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

**1.2 Check for project artifacts to clean up:**
- `PRD.md` - Project requirements (delete if project complete)
- `MVP.md` - Project MVP definition (delete if project complete)
- `TECH SPEC.md` - Project technical spec (delete if project complete)

**1.3 Check for artifact files:**
- `nul` - Windows artifact (45 bytes typically)
- `.DS_Store` - macOS artifact
- `Thumbs.db` - Windows thumbnail cache
- `*.tmp`, `*.temp` - Temporary files
- Files matching patterns in `.gitignore` that were accidentally committed

**1.4 Check for old context exports:**
- `context/prime-*.md` files - Count how many exist
- If more than 3, flag old files for cleanup
- Prime files are large (10,000+ tokens) - cleanup saves space

**1.5 Check for cache and discovery files to clean:**
- `.prime-cache.json` - Prime cache (delete to force fresh prime)
- `discovery/*.md` (except INDEX.md) - Old discovery documents
- `/check` is typically run when finishing a project, so these can be cleaned

**1.5 Check documentation consistency:**
- Root `INDEX.md` - Should list all commands
- `features/INDEX.md` - Should reflect current feature statuses
- `context/INDEX.md` - Should list all prime exports
- `discovery/INDEX.md` - Should list all discovery documents
- `execution/INDEX.md` - Should list all execution tasks

**1.6 Check for outdated status references:**
- Feature STATUS.md files - Should match actual completion state
- Compare features/INDEX.md status with feature/STATUS.md
- Check for "Ready for X" phases that are actually complete

**1.7 Check command file integrity:**
- All commands in `.claude/commands/` should have proper YAML frontmatter
- All commands listed in INDEX.md should exist
- No orphaned or missing command files

**1.8 Check template files:**
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
# Remove PRD.md, MVP.md, TECH SPEC.md if project is complete
# Remove old context/prime-*.md files (keep latest 2-3)
# Remove .prime-cache.json (reset prime cache)
# Remove discovery/*.md except INDEX.md (clean old discoveries)
```

**2.4 Update outdated INDEX.md entries:**
- Update feature statuses to match actual completion
- Update last updated dates
- Add missing commands to command tables
- Add completed features to status sections

**2.5 Fix INDEX.md inconsistencies:**
- Fix INDEX.md inconsistencies by calling update-index with regenerate=true for directories with mismatches
- Automatically regenerate INDEX.md files that don't match actual directory contents
- This ensures all INDEX.md files stay synchronized with the codebase structure

**2.6 Update .claude/settings.local.json permissions:**
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

### INDEX.md Auto-Fixed
- {directory}/INDEX.md - {entries_added} added, {entries_removed} removed - Synchronized with directory contents

## Issues Requiring Manual Action

### {issue-description}
- **File**: {file}
- **Problem**: {description}
- **Suggested Fix**: {recommendation}

## Health Score

- **Required Files**: {X}/{Y} present
- **Documentation**: {X}/{Y} up-to-date
- **INDEX.md Sync**: {X}/{Y} synchronized
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
- {count} INDEX.md files auto-fixed
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

### Project Artifacts (Cleaned Up When Complete)

| File | Purpose | Cleanup Condition |
|------|---------|-------------------|
| `PRD.md` | Project requirements | Project complete, no active tasks |
| `MVP.md` | Project MVP definition | Project complete, no active tasks |
| `TECH SPEC.md` | Project technical spec | Project complete, no active tasks |

### Artifact Patterns

| Pattern | Description | Action |
|---------|-------------|--------|
| `context/prime-*.md` | Context export files (large!) | Keep latest 2-3, delete rest |
| `.prime-cache.json` | Prime cache for diff output | Delete (reset cache) |
| `discovery/*.md` | Discovery documents | Delete all except INDEX.md |
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

### File Preservation Rules

**NEVER DELETE (System Documentation)**:
- `CLAUDE.md`, `README.md`, `INDEX.md`, `LICENSE` - Permanent system files
- `.claude/commands/*.md` - Workflow command definitions

**CLEAN UP (Project/Feature Artifacts)**:
- `PRD.md`, `MVP.md`, `TECH SPEC.md` - Root project artifacts (delete when project complete)
- `features/{name}/*` - Feature artifacts (delete when feature complete)
- `context/prime-*.md` - Old context exports (keep latest 2-3)
- `nul`, `.DS_Store`, `Thumbs.db` - OS artifacts
- `*.tmp`, `*.temp` - Temporary files

**Before deleting project artifacts, check:**
- Is the project/feature marked as complete in STATUS.md?
- Are there any active tasks in Archon?
- Has the code been reviewed and tested?

**Context/Prime Files Cleanup:**
```bash
# List all prime files sorted by date (oldest first)
ls -lt context/prime-*.md | tail -n +4 | xargs rm -f

# This keeps the latest 3 prime files, removes older ones
# Prime files are large context exports - cleanup saves space
```

**Context cleanup logic:**
- Keep latest 2-3 prime exports (most recent context)
- Delete older prime-*.md files to save repository space
- Prime files can be 10,000+ tokens each - cleanup is important
- Always keep at least 1-2 recent exports for reference
