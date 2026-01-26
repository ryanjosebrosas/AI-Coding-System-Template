---
name: Review
description: "AI-powered code review with quality, security, and performance analysis"
phase: review
dependencies: [execution]
outputs:
  - path: "features/{feature-name}/review.md"
    description: "Code review report for feature"
  - path: "reviews/review-{timestamp}.md"
    description: "Timestamped review report in reviews directory"
  - path: "reviews/INDEX.md"
    description: "Updated index of all reviews"
  - path: "features/{feature-name}/STATUS.md"
    description: "Updated feature status tracking file"
inputs:
  - path: "context/prime-{timestamp}.md"
    description: "Baseline codebase export from Prime command"
    required: true
  - path: "features/{feature-name}/prd.md"
    description: "Product Requirements Document for compliance verification"
    required: true
  - path: "features/{feature-name}/tech-spec.md"
    description: "Technical Specification for compliance verification"
    required: true
  - path: "features/{feature-name}/execution.md"
    description: "Execution log with completed tasks"
    required: true
---

# Review Command

## Purpose

Perform AI-powered code review by identifying code changes, analyzing quality (best practices, security, performance), verifying compliance with PRD and tech spec, and generating a comprehensive review report with severity levels, fix recommendations, and code examples.

## Execution Steps

### Step 1: Load Baseline and Current Codebase

Load Prime baseline and current codebase for comparison:

1. **Load Prime baseline**:
   - Find most recent `context/prime-*.md` (or use baseline from feature start)
   - Read and parse Prime export
   - Extract: Project tree, file contents, index statistics
   - Store as baseline

2. **Export current codebase**:
   - Run Prime command to export current codebase
   - Or load most recent Prime export if available
   - Parse current codebase structure
   - Extract: Project tree, file contents, index statistics
   - Store as current

3. **Compare codebases**:
   - Compare project trees (baseline vs current)
   - Identify new files
   - Identify modified files
   - Identify deleted files (if any)
   - Extract file differences

**Expected Result**: Code changes identified and extracted.

### Step 2: Analyze Code Quality

Use AI/MCP to analyze code quality (best practices, security, performance):

1. **Prepare code context**:
   - Combine: Changed files + PRD + Tech Spec + PRP
   - Extract code snippets for analysis
   - Organize by file and change type

2. **Query AI for quality analysis**:
   - For each changed file:
     - Prompt AI: "Review this code for quality, security, and performance. Check: Best practices, code smells, security vulnerabilities, performance issues, maintainability, readability. Provide specific recommendations."
     - Include: File content, PRD requirements, Tech Spec guidelines, PRP anti-patterns
     - Request structured analysis

3. **Extract quality issues**:
   - Parse AI response for:
     - Best practice violations
     - Code smells
     - Security vulnerabilities
     - Performance issues
     - Maintainability concerns
     - Readability issues
   - Categorize by severity (Critical, High, Medium, Low)

4. **Use RAG knowledge base** (optional):
   - Search knowledge base for code review patterns: `rag_search_knowledge_base(query="code review best practices", match_count=3)`
   - Search for security patterns: `rag_search_knowledge_base(query="security vulnerabilities", match_count=3)`
   - Search for performance patterns: `rag_search_knowledge_base(query="performance optimization", match_count=3)`
   - Use results to enhance review

**Expected Result**: Code quality issues identified and categorized.

### Step 3: Verify Compliance

Verify code compliance with PRD, tech spec, and acceptance criteria:

1. **Load PRD and Tech Spec**:
   - Read `features/{feature-name}/prd.md`
   - Read `features/{feature-name}/tech-spec.md`
   - Extract: Features, user stories, acceptance criteria, technical requirements

2. **Check PRD compliance**:
   - For each PRD feature:
     - Verify feature is implemented
     - Check user story acceptance criteria are met
     - Verify feature matches PRD description
     - Identify missing features or incomplete implementations

3. **Check Tech Spec compliance**:
   - Verify architecture matches Tech Spec
   - Verify technology stack matches Tech Spec
   - Verify file structure matches Tech Spec
   - Verify data models match Tech Spec
   - Verify MCP integration matches Tech Spec
   - Verify error handling matches Tech Spec

4. **Check acceptance criteria**:
   - Verify all acceptance criteria are met
   - Check test coverage (if required)
   - Verify feature functionality matches PRD

5. **Document compliance issues**:
   - List PRD violations
   - List Tech Spec violations
   - List missing features
   - List incomplete implementations

**Expected Result**: Compliance issues identified and documented.

### Step 4: Generate Review Report

Compile findings into comprehensive review report:

1. **Create document structure**:
   ```markdown
   # Code Review: {feature-name}

   ## Review Summary
   {Overall assessment}

   ## Code Changes
   {List of new, modified, deleted files}

   ## Quality Issues
   {Issues categorized by severity}

   ## Security Findings
   {Security vulnerabilities and recommendations}

   ## Performance Findings
   {Performance issues and recommendations}

   ## Compliance Verification
   {PRD and Tech Spec compliance status}

   ## Recommendations
   {Prioritized fix recommendations}

   ## Approval Status
   {Approved, Approved with Changes, Blocked}
   ```

2. **Populate content**:
   - Fill in: Code changes from Step 1
   - Fill in: Quality issues from Step 2
   - Fill in: Security findings from Step 2
   - Fill in: Performance findings from Step 2
   - Fill in: Compliance verification from Step 3
   - Fill in: Prioritized recommendations

3. **Generate timestamp**:
   - Use ISO 8601 format: YYYY-MM-DDTHH:mm:ssZ
   - Include in filename and document

4. **Save documents**:
   - Save feature review: `features/{feature-name}/review.md`
   - Save timestamped review: `reviews/review-{timestamp}.md`
   - Update `reviews/INDEX.md` with new entry

5. **Update STATUS.md**:
   - Mark Review phase with status
   - Add approval status
   - Update next steps based on review

## Output Format

```markdown
# Code Review: {feature-name}

**Reviewed By**: AI Assistant
**Review Date**: {timestamp}
**Feature**: {feature-name}
**Baseline**: {prime-timestamp}
**Current**: {current-timestamp}

## Review Summary

### Overall Assessment
{Overall quality assessment and approval status}

### Statistics
- **Files Changed**: {count}
- **Issues Found**: {count}
  - Critical: {count}
  - High: {count}
  - Medium: {count}
  - Low: {count}
- **Security Issues**: {count}
- **Performance Issues**: {count}
- **Compliance Issues**: {count}

## Code Changes

### New Files
| File | Lines | Purpose |
|------|-------|---------|
| {path} | {count} | {description} |

### Modified Files
| File | Changes | Lines Added | Lines Removed |
|------|---------|-------------|----------------|
| {path} | {description} | {count} | {count} |

### Deleted Files
| File | Reason |
|------|--------|
| {path} | {reason} |

## Quality Issues

### Critical Issues
{Critical issues requiring immediate fix}

### High Priority Issues
{High priority issues with significant impact}

### Medium Priority Issues
{Medium priority issues for improvement}

### Low Priority Issues
{Low priority issues for consideration}

### Code Smells
| File | Type | Description | Recommendation |
|------|------|-------------|----------------|
| {path} | {type} | {description} | {fix} |

## Security Findings

### Vulnerabilities
| Severity | File | Issue | Recommendation |
|----------|------|-------|----------------|
| {level} | {path} | {description} | {fix} |

### Security Best Practices
{Recommendations for improving security}

## Performance Findings

### Performance Issues
| Severity | File | Issue | Recommendation |
|----------|------|-------|----------------|
| {level} | {path} | {description} | {fix} |

### Performance Recommendations
{Recommendations for improving performance}

## Compliance Verification

### PRD Compliance
| Feature | Status | Notes |
|---------|--------|-------|
| {feature} | {Met/Not Met/Partial} | {notes} |

### Tech Spec Compliance
| Requirement | Status | Notes |
|-------------|--------|-------|
| {req} | {Met/Not Met/Partial} | {notes} |

### Acceptance Criteria
| Criteria | Status | Notes |
|----------|--------|-------|
| {criteria} | {Met/Not Met/Partial} | {notes} |

## Recommendations

### Immediate Actions
{Actions that must be taken before approval}

### Short-Term Improvements
{Improvements to implement soon}

### Long-Term Enhancements
{Enhancements for future consideration}

## Approval Status

**Status**: {Approved / Approved with Changes / Blocked}

**Reason**: {Justification for approval status}

**Conditions for Approval**:
- All critical issues resolved
- All high priority issues addressed
- PRD and Tech Spec compliance met
- Acceptance criteria satisfied

**Next Steps**:
{Recommended next steps based on review}
```

## Error Handling

- **Baseline Not Found**: Check `context/` directory, list available exports, use oldest or request manual specification
- **PRD Not Found**: Check `features/{feature-name}/` directory, error and stop
- **Tech Spec Not Found**: Check `features/{feature-name}/` directory, error and stop
- **Execution Log Not Found**: Check `features/{feature-name}/` directory, warn about missing execution log
- **AI Analysis Fails**: Log error, proceed with manual review option
- **Compliance Check Fails**: Log which document failed, continue with available documents

## Notes

- Review provides quality assurance before testing and deployment
- Severity levels help prioritize fixes
- Approval status gates progression to next phase
- Reviews are stored both with feature and globally
- Use RAG knowledge base to enhance review quality
- Recommendations should be actionable and specific
