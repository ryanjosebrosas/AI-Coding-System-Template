---
name: Quality Reporter
description: "Generate comprehensive quality reports with metrics, scores, severity levels, and actionable recommendations for documentation artifacts"
phase: reporting
dependencies: [validation]
outputs:
  - path: ".claude/reports/quality-{timestamp}.md"
    description: "Timestamped quality report in reports directory"
  - path: ".claude/reports/INDEX.md"
    description: "Updated index of all quality reports"
inputs:
  - path: "validation results from validators"
    description: "Validation data from line-count, section, YAGNI, and KISS validators"
    required: true
  - path: "documentation artifacts (PRD, TECH-SPEC, MVP, PRP)"
    description: "Documents being validated"
    required: true
---

# Quality Reporter

## Purpose

Generate comprehensive quality reports with metrics calculation (line violations, missing sections, YAGNI/KISS checks), severity classification, and actionable recommendations for documentation artifacts.

## Execution Steps

### Step 1: Collect Validation Data

Collect validation results from all validators:

1. **Run line count validation**:
   - Execute line count validator on each document
   - Extract: line_count, line_status (PASS/WARN/FAIL), line_overage
   - Calculate line_score:
     - PASS (0-499 lines): 100% score
     - WARN (500-600 lines): 50% score
     - FAIL (600+ lines): 0% score

2. **Run section completeness validation**:
   - Execute section validator on each document
   - Extract: required_sections, present_sections, missing_sections, section_status
   - Calculate section_score: `(present_sections * 100 / required_sections)`

3. **Run YAGNI compliance check**:
   - Analyze document for YAGNI violations:
     - verbose_sections: Count of sections > 100 lines
     - duplicate_content: Count of duplicate information instances
     - unnecessary_examples: Count of excessive example usage
     - future_speculation: Count of future-proofing content instances
   - Calculate yagni_violations: Sum of all YAGNI violation types
   - Calculate yagni_score: `100 - (yagni_violations * 10)` (minimum 0%)

4. **Run KISS compliance check**:
   - Analyze document for KISS violations:
     - complex_sentences: Count of sentences > 30 words
     - jargon_without_explanation: Count of undefined technical terms
     - deep_nesting: Count of lists nested > 3 levels
     - convoluted_explanations: Count of overly complex explanations
   - Calculate kiss_violations: Sum of all KISS violation types
   - Calculate kiss_score: `100 - (kiss_violations * 10)` (minimum 0%)

**Expected Result**: All validation metrics collected and calculated for each document.

### Step 2: Calculate Overall Quality Score

Calculate weighted average of all metrics:

1. **Calculate overall score**:
   ```bash
   overall_score = ((line_score * 30) + (section_score * 30) + (yagni_score * 20) + (kiss_score * 20)) / 100
   ```

2. **Apply weights**:
   - Line count: 30% (critical for maintainability)
   - Section completeness: 30% (critical for completeness)
   - YAGNI compliance: 20% (important for conciseness)
   - KISS compliance: 20% (important for readability)

3. **Determine severity level**:
   - Excellent (90-100%): No action needed, does not block commit
   - Good (75-89%): Minor improvements recommended, does not block commit
   - Fair (60-74%): Improvements recommended, does not block commit
   - Poor (40-59%): Significant improvements needed, blocks commit
   - Critical (0-39%): Major issues must be fixed, blocks commit

**Expected Result**: Overall quality score and severity level determined for each document.

### Step 3: Generate Quality Report

Compile metrics and analysis into comprehensive report:

1. **Create report structure**:
   ```markdown
   # Quality Report

   **Date**: {timestamp}
   **Branch**: {current-branch}
   **Commit**: {latest-commit-hash}
   **Files Validated**: {count}

   ## Executive Summary
   - Overall Quality Score: {overall_score}%
   - Severity: {severity_level}
   - Files Passed: {count}
   - Files with Warnings: {count}
   - Files Failed: {count}

   ## Quality Metrics Breakdown
   ### Line Count Validation
   ### Section Completeness
   ### YAGNI Compliance
   ### KISS Compliance

   ## Detailed Analysis
   ### Files Requiring Immediate Attention
   ### Files with Recommended Improvements

   ## Actionable Recommendations
   ### High Priority (Must Fix)
   ### Medium Priority (Should Fix)
   ### Low Priority (Nice to Have)
   ```

2. **Populate quality metrics**:
   - Line Count Validation table:
     | File | Lines | Status | Score |
     |------|-------|--------|-------|
     | {file} | {line_count} | {PASS/WARN/FAIL} | {line_score}% |
   - Section Completeness table:
     | File | Present/Required | Status | Score |
     |------|------------------|--------|-------|
     | {file} | {present}/{required} | {PASS/FAIL} | {section_score}% |
   - YAGNI Compliance table:
     | File | Violations | Score |
     |------|------------|-------|
     | {file} | {count} | {yagni_score}% |
   - KISS Compliance table:
     | File | Violations | Score |
     |------|------------|-------|
     | {file} | {count} | {kiss_score}% |

3. **List violations with details**:
   - YAGNI Violations:
     - {file}: {violation_type} - {description}
       - Location: {section/line}
       - Recommendation: {fix}
   - KISS Violations:
     - {file}: {violation_type} - {description}
       - Location: {section/line}
       - Recommendation: {fix}

4. **Generate actionable recommendations**:
   - High Priority (Must Fix):
     1. **{file} - Reduce line count**
        - Current: {line_count} lines
        - Target: Under 600 lines
        - Action: {specific actions to reduce}
   - Medium Priority (Should Fix):
     1. **{file} - Remove verbose content**
        - Violations: {count} YAGNI violations
        - Action: {specific actions to simplify}
   - Low Priority (Nice to Have):
     1. **{file} - Minor improvements**
        - Suggestions: {list of minor improvements}
        - Action: Optional enhancements

5. **Add fix guidance**:
   - Include "How to Fix Common Issues" section
   - Provide strategies for reducing line count
   - Provide steps for adding missing sections
   - Provide examples for improving YAGNI/KISS compliance

**Expected Result**: Comprehensive quality report with metrics, severity, and recommendations.

### Step 4: Save and Index Report

Save report and update index:

1. **Generate timestamp**:
   - Use format: YYYYMMDD-HHMMSS
   - Example: 20260126-123456

2. **Save report**:
   - Location: `.claude/reports/quality-{timestamp}.md`
   - Full path: `.claude/reports/quality-20260126-123456.md`

3. **Update index**:
   - Update `.claude/reports/INDEX.md`
   - Add entry:
     ```markdown
     ## {timestamp}
     - **Date**: {timestamp}
     - **Overall Score**: {overall_score}%
     - **Severity**: {severity_level}
     - **Files**: {count}
     - **Link**: [quality-{timestamp}.md](quality-{timestamp}.md)
     ```

4. **Manage retention**:
   - Keep last 10 reports for historical comparison
   - Archive older reports to `.claude/reports/archive/`

**Expected Result**: Report saved and indexed for future reference.

## Output Format

```markdown
# Quality Report

**Date**: {timestamp}
**Branch**: {current-branch}
**Commit**: {latest-commit-hash}
**Files Validated**: {count}

## Executive Summary

- **Overall Quality Score**: {overall_score}%
- **Severity**: {severity_level}
- **Files Passed**: {count}
- **Files with Warnings**: {count}
- **Files Failed**: {count}

## Quality Metrics Breakdown

### Line Count Validation

| File | Lines | Status | Score |
|------|-------|--------|-------|
| {file} | {line_count} | {PASS/WARN/FAIL} | {line_score}% |

**Summary**: {summary of line count validation}

### Section Completeness

| File | Present/Required | Status | Score |
|------|------------------|--------|-------|
| {file} | {present}/{required} | {PASS/FAIL} | {section_score}% |

**Missing Sections**:
- {file}: {missing_sections}

### YAGNI Compliance

| File | Violations | Score |
|------|------------|-------|
| {file} | {count} | {yagni_score}% |

**YAGNI Violations**:
- {file}: {violation_type} - {description}
  - Location: {section/line}
  - Recommendation: {fix}

### KISS Compliance

| File | Violations | Score |
|------|------------|-------|
| {file} | {count} | {kiss_score}% |

**KISS Violations**:
- {file}: {violation_type} - {description}
  - Location: {section/line}
  - Recommendation: {fix}

## Detailed Analysis

### Files Requiring Immediate Attention

**Critical Issues** (blocks commit):
1. {file} - {issue_description}
   - **Impact**: {why this is critical}
   - **Fix**: {actionable steps to fix}

2. {file} - {issue_description}
   - **Impact**: {why this is critical}
   - **Fix**: {actionable steps to fix}

### Files with Recommended Improvements

**Improvement Opportunities**:
1. {file} - {issue_description}
   - **Impact**: {why improvement helps}
   - **Fix**: {actionable steps to fix}

2. {file} - {issue_description}
   - **Impact**: {why improvement helps}
   - **Fix**: {actionable steps to fix}

## Actionable Recommendations

### High Priority (Must Fix)

1. **{file} - Reduce line count**
   - Current: {line_count} lines
   - Target: Under 600 lines
   - Action: {specific actions to reduce}

2. **{file} - Add missing sections**
   - Missing: {section_list}
   - Action: Reference template: {template_path}

### Medium Priority (Should Fix)

1. **{file} - Remove verbose content**
   - Violations: {count} YAGNI violations
   - Action: {specific actions to simplify}

2. **{file} - Simplify complex explanations**
   - Violations: {count} KISS violations
   - Action: {specific actions to clarify}

### Low Priority (Nice to Have)

1. **{file} - Minor improvements**
   - Suggestions: {list of minor improvements}
   - Action: Optional enhancements

## How to Fix Common Issues

### Reducing Line Count

**Strategies**:
- Remove redundant explanations
- Consolidate similar sections
- Use tables instead of long lists
- Remove unnecessary examples
- Move supplementary content to separate docs

**Example**:
```markdown
# Before (verbose)
In order to implement the feature, we need to first understand the requirements. The requirements state that...

# After (concise)
To implement this feature, we need to understand the requirements, which state that...
```

### Adding Missing Sections

**Steps**:
1. Identify missing section
2. Reference template for structure
3. Add section header: `## {Section Name}`
4. Add relevant content
5. Validate section is present

**Templates**:
- PRD: `templates/prd/PRD.md`
- TECH-SPEC: `templates/tech-spec/TECH-SPEC.md`
- MVP: `templates/mvp/MVP.md`
- PRP: `templates/prp/prp-base.md`

### Improving YAGNI Compliance

**Remove**:
- Future enhancement sections
- Unnecessary examples (>2 for same concept)
- Redundant explanations
- Speculative features
- Over-detailed background info

**Keep**:
- Current requirements only
- Essential context
- Single clear example per concept
- Actionable information

### Improving KISS Compliance

**Simplify**:
- Break long sentences (>30 words) into shorter ones
- Define jargon on first use
- Flatten nested lists (>3 levels)
- Remove convoluted explanations
- Use plain language

**Example**:
```markdown
# Before (complex)
In the event that the user encounters a situation where they need to perform an action that requires...

# After (simple)
If users need to perform an action that requires...
```

## Severity Reference

### Severity Classification

| Score Range | Severity | Action | Blocks Commit? |
|-------------|----------|--------|----------------|
| 90-100% | Excellent | No action needed | No |
| 75-89% | Good | Minor improvements recommended | No |
| 60-74% | Fair | Improvements recommended | No |
| 40-59% | Poor | Significant improvements needed | Yes |
| 0-39% | Critical | Major issues must be fixed | Yes |

### Severity Rules

**Critical (0-39%):**
- Line count FAIL (> 600 lines)
- Section completeness < 50%
- Multiple YAGNI/KISS violations
- **Blocks commit**

**Poor (40-59%):**
- Line count WARN (500-600 lines)
- Section completeness 50-75%
- Several YAGNI/KISS violations
- **Blocks commit**

**Fair (60-74%):**
- Line count near warning (450-500 lines)
- Section completeness 75-90%
- Some YAGNI/KISS violations
- **Does not block commit**

**Good (75-89%):**
- Line count acceptable (< 450 lines)
- Section completeness 90-100%
- Few or no YAGNI/KISS violations
- **Does not block commit**

**Excellent (90-100%):**
- Line count well under limit (< 400 lines)
- All required sections present
- No YAGNI/KISS violations
- **Does not block commit**
```

## Error Handling

**If validation fails:**
- Generate partial report with available data
- Mark failed validations in report
- Exit with error code
- Recommend manual review

**If report generation fails:**
- Output basic metrics to stdout
- Log error to stderr
- Exit with error code
- Recommend re-running validation

**If score calculation fails:**
- Use default score of 0%
- Mark score as "ERROR" in report
- Continue with other metrics
- Flag for manual review

**If file write fails:**
- Check directory permissions
- Create .claude/reports/ if missing
- Log error with full path
- Output report to stdout as fallback

## Notes

- Quality reports provide actionable feedback for documentation improvement
- Scores are weighted to prioritize completeness and conciseness
- Severity levels determine if commits are blocked
- Reports are saved for historical tracking
- Recommendations are specific and actionable
- Both automated metrics and manual review are valuable
- Quality gates enforce standards without being overly strict
- Historical reports enable trend analysis

## Integration

### Shell Script Integration

```bash
generate_quality_report() {
    local report_file=".claude/reports/quality-$(date +%Y%m%d-%H%M%S).md"

    # Run all validators
    validate_line_count "$file"
    validate_sections "$file" "$doc_type"
    validate_yagni "$file"
    validate_kiss "$file"

    # Calculate scores
    line_score=$(calculate_line_score "$file")
    section_score=$(calculate_section_score "$file")
    yagni_score=$(calculate_yagni_score "$file")
    kiss_score=$(calculate_kiss_score "$file")
    overall_score=$(calculate_overall_score $line_score $section_score $yagni_score $kiss_score)

    # Generate report
    cat > "$report_file" << EOF
# Quality Report

**Date**: $(date -Iseconds)
**Overall Quality Score**: ${overall_score}%
...

EOF

    echo "Quality report generated: $report_file"
}
```

### Pre-Commit Hook Integration

```bash
# In .git/hooks/pre-commit.quality-gate
report_file=$(bash scripts/validate-quality.sh --report)
overall_score=$(grep "Overall Quality Score" "$report_file" | grep -oP '\d+%')

# Remove % and convert to number
overall_score=${overall_score%\%}

if [ $overall_score -lt 60 ]; then
    echo "❌ Quality score too low: ${overall_score}% (minimum: 60%)"
    echo "   Report: $report_file"
    exit 1
fi
```

### Report Storage

**Location**: `.claude/reports/quality-{timestamp}.md`

**Retention**: Keep last 10 reports for historical comparison

**Filename format**: `quality-YYYYMMDD-HHMMSS.md`

**Index**: `.claude/reports/INDEX.md` lists all reports with summaries
