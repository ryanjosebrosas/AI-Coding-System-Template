---
name: Validate Quality
description: "Automated quality checks validate syntax, structure, and completeness of generated documentation artifacts (PRDs, tech specs, PRPs)"
phase: independent
dependencies: []
outputs:
  - description: "Quality report with validation results, violations, and actionable recommendations"
inputs: []
---

# Validate Quality Command

## Purpose

Perform automated quality validation on documentation artifacts to ensure they meet YAGNI/KISS principles, stay within line limits (500-600 lines max), and contain all required sections. This maintains documentation standards and prevents verbose artifacts from being committed.

## Execution Steps

### Step 1: Identify Documentation Artifacts

Scan the codebase for documentation artifacts requiring validation:

**1.1 Find PRD files:**
- Search for `PRD.md` in root directory
- Search for `features/*/PRD.md` in feature directories
- Mark for validation if they exist

**1.2 Find TECH-SPEC files:**
- Search for `TECH-SPEC.md` in root directory
- Search for `features/*/TECH-SPEC.md` in feature directories
- Mark for validation if they exist

**1.3 Find MVP files:**
- Search for `MVP.md` in root directory
- Search for `features/*/MVP.md` in feature directories
- Mark for validation if they exist

**1.4 Find PRP files:**
- Search for `features/*/prp.md` in feature directories
- Mark for validation if they exist

**1.5 Skip validation for:**
- Files in `.git/` directory
- Files in `node_modules/` or vendor directories
- Files marked as drafts or templates

### Step 2: Validate Line Counts

For each documentation artifact, check line count limits:

**2.1 Count lines:**
```bash
# Get line count (exclude blank lines for fair assessment)
grep -cve '^\s*$' {file}
```

**2.2 Check limits:**
- **Hard limit**: 600 lines (FAIL)
- **Warning zone**: 500-600 lines (WARN)
- **Acceptable**: < 500 lines (PASS)

**2.3 Document types and limits:**
| Document Type | Warning Limit | Hard Limit |
|---------------|---------------|------------|
| PRD.md | 500 | 600 |
| TECH-SPEC.md | 500 | 600 |
| MVP.md | 500 | 600 |
| prp.md | 500 | 600 |

**2.4 Track violations:**
- Count files exceeding hard limit
- Count files in warning zone
- Record exact line count for reporting

### Step 3: Validate Required Sections

For each document type, verify all required sections exist:

**3.1 PRD required sections (7 sections):**
```markdown
## Problem Statement
## Rationale
## User Stories
## Acceptance Criteria
## Technical Requirements
## Success Metrics
## Open Questions
```

**3.2 TECH-SPEC required sections (7 sections):**
```markdown
## Architecture Overview
## System Components
## Data Models
## API Design
## Implementation Details
## Security Considerations
## Testing Strategy
```

**3.3 MVP required sections (5 sections):**
```markdown
## Problem Statement
## Solution Overview
## Key Features
## Technical Approach
## Success Criteria
```

**3.4 PRP required sections (5 sections):**
```markdown
## Goal
## All Needed Context
## Implementation Blueprint
## Validation Loop
## Known Gotchas
```

**3.5 Check for sections:**
```bash
# For each required section, grep for it
grep -q '^## {Section Name}' {file}
```

**3.6 Track missing sections:**
- List which sections are missing
- Count total missing sections per file
- Mark severity (critical if >2 sections missing)

### Step 4: Check YAGNI/KISS Principles

Verify documentation follows simplicity principles:

**4.1 YAGNI checks:**
- Check for verbose explanations (sections > 100 lines)
- Check for redundant content (duplicate information across sections)
- Check for unnecessary examples (multiple examples for same concept)
- Check for future-proofing content (features not needed now)

**4.2 KISS checks:**
- Check for complex sentence structures (sentences > 30 words)
- Check for jargon without explanation
- Check for nested lists > 3 levels deep
- Check for convoluted explanations

**4.3 Flag violations:**
- Count YAGNI violations (unnecessary content)
- Count KISS violations (over-complexity)
- Note severity and location

### Step 5: Generate Quality Report

Create comprehensive quality report:

```markdown
# Quality Report

**Date**: {timestamp}
**Branch**: {current-branch}
**Commit**: {latest-commit-hash}

## Summary

- **Files Validated**: {count}
- **Passed**: {count}
- **Warnings**: {count}
- **Failed**: {count}

## Line Count Validation

### Passed (Under 500 lines)
- {file} - {line_count} lines ✓

### Warnings (500-600 lines)
- {file} - {line_count} lines ⚠ (approaching limit)

### Failed (Over 600 lines)
- {file} - {line_count} lines ✗ (exceeds limit by {overage} lines)

## Required Sections Validation

### All Sections Present
- {file} - All {count} required sections ✓

### Missing Sections
- {file} - Missing: {section_list} ✗

## YAGNI/KISS Validation

### Violations Found
- {file} - {violation_type}: {description}

**YAGNI Violations**: {count}
- {file} - {violation_description}

**KISS Violations**: {count}
- {file} - {violation_description}

## Overall Quality Score

- **Line Count Score**: {X}%
- **Sections Score**: {X}%
- **YAGNI/KISS Score**: {X}%
- **Overall**: {X}%

## Actionable Recommendations

1. {specific recommendation for file}
2. {specific recommendation for file}

## How to Fix

### Reducing Line Count
- Remove redundant explanations
- Consolidate similar sections
- Remove unnecessary examples
- Focus on essential information only (YAGNI)

### Adding Missing Sections
- Add section: {missing_section}
- Reference template: {template_path}

### Improving YAGNI/KISS Compliance
- Simplify complex explanations
- Remove future speculation
- Use shorter sentences
- Avoid nested lists
```

### Step 6: Determine Exit Status

Set exit status based on validation results:

**Exit codes:**
- `0` - All validations passed
- `1` - Warnings only (line count 500-600, minor violations)
- `2` - Failures (line count > 600, critical missing sections)

**Decision logic:**
```bash
if [ $hard_limit_violations -gt 0 ]; then
    exit 2  # Critical failure
elif [ $warnings -gt 0 ]; then
    exit 1  # Warning
else
    exit 0  # Success
fi
```

## Validation Reference

### Line Count Thresholds

| Status | Range | Action |
|--------|-------|--------|
| PASS | 0-499 lines | No action needed |
| WARN | 500-600 lines | Consider trimming |
| FAIL | 600+ lines | Must reduce before commit |

### Required Sections by Document Type

| Document Type | Required Sections | Count |
|---------------|-------------------|-------|
| PRD | Problem, Rationale, User Stories, Acceptance Criteria, Technical Requirements, Success Metrics, Open Questions | 7 |
| TECH-SPEC | Architecture, Components, Data Models, API Design, Implementation, Security, Testing | 7 |
| MVP | Problem, Solution, Key Features, Technical Approach, Success Criteria | 5 |
| PRP | Goal, Context, Blueprint, Validation, Gotchas | 5 |

### YAGNI/KISS Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Verbose sections | Any section > 100 lines | Warning |
| Duplicate content | Same info in multiple sections | Warning |
| Unnecessary examples | >2 examples for same concept | Warning |
| Future speculation | Features not needed now | Warning |
| Complex sentences | Sentences > 30 words | Info |
| Deep nesting | Lists > 3 levels | Info |
| Jargon without explanation | Undefined terms | Info |

## Error Handling

**If file not found:**
- Skip gracefully
- Note in report that file was referenced but not found
- Continue with other files

**If file cannot be read:**
- Report error
- Mark as validation failure
- Recommend manual review

**If line count check fails:**
- Report error
- Continue with other validations
- Mark file as failed

**If section check fails:**
- Report error
- List sections that couldn't be checked
- Continue with other sections

**If report generation fails:**
- Output basic validation results to stderr
- Exit with error code
- Recommend manual validation

## Usage Examples

**Validate all documentation:**
```bash
/validate-quality
```

**Validate specific file:**
```bash
/validate-quality PRD.md
```

**Validate with verbose output:**
```bash
/validate-quality --verbose
```

**Validate and auto-fix (where possible):**
```bash
/validate-quality --fix
```

## Notes

- Always run before committing documentation changes
- Line counts exclude blank lines for fair assessment
- Quality gates enforce documentation standards automatically
- Failed quality gates should be fixed before committing
- Use `git commit --no-verify` to bypass in emergency (not recommended)
- Reports are saved to `.claude/reports/quality-{timestamp}.md`
- Previous reports are kept for historical comparison

### Integration with Git Hooks

This command is designed to be called by pre-commit hooks:

**Hook integration:**
```bash
# In .git/hooks/pre-commit.quality-gate
bash scripts/validate-quality.sh
exit_code=$?

if [ $exit_code -eq 2 ]; then
    echo "❌ Quality gates failed. Fix issues before committing."
    echo "   Use 'git commit --no-verify' to bypass (not recommended)."
    exit 1
elif [ $exit_code -eq 1 ]; then
    echo "⚠️  Quality warnings present. Consider fixing before committing."
    echo "   Use 'git commit --no-verify' to bypass."
    exit 1
fi
```

### Bypassing Quality Gates

**Emergency bypass (not recommended):**
```bash
git commit --no-verify -m "Emergency commit, skipping quality gates"
```

**Valid bypass reasons:**
- Emergency hotfix for production issue
- Initial documentation draft (mark as [DRAFT] in title)
- Documentation work-in-progress (use WIP branch)
- Migration or refactoring in progress

**Never bypass for:**
- Normal documentation updates
- New feature documentation
- Documentation reviews
- Pull request submissions
