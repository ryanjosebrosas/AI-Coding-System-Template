# Line Count Validator

**Purpose**: Validate documentation artifacts stay within acceptable line count limits (500-600 lines) to enforce YAGNI/KISS principles.

## Configuration

### Thresholds

| Document Type | Warning Limit | Hard Limit | Rationale |
|---------------|---------------|------------|-----------|
| PRD.md | 500 lines | 600 lines | PRDs should be concise, focusing on essential requirements only |
| TECH-SPEC.md | 500 lines | 600 lines | Tech specs should be pragmatic, not comprehensive architecture documents |
| MVP.md | 500 lines | 600 lines | MVP definitions should be minimal, focusing on core value proposition |
| prp.md | 500 lines | 600 lines | PRPs should be actionable blueprints, not exhaustive documentation |

### Severity Levels

- **PASS**: 0-499 lines - No action needed
- **WARN**: 500-600 lines - Approaching limit, consider trimming
- **FAIL**: 600+ lines - Exceeds limit, must reduce before commit

## Validation Logic

### Step 1: Count Lines

**Method**: Exclude blank lines for fair assessment

```bash
# Count non-blank lines
grep -cve '^\s*$' {file}

# Alternative: Count all lines (more strict)
wc -l {file}
```

**Recommended**: Use `grep -cve '^\s*$'` to exclude blank lines, as blank lines are formatting, not content.

### Step 2: Apply Thresholds

```bash
# Get line count
line_count=$(grep -cve '^\s*$' "$file")

# Check against thresholds
if [ $line_count -gt 600 ]; then
    status="FAIL"
    severity="critical"
elif [ $line_count -gt 500 ]; then
    status="WARN"
    severity="warning"
else
    status="PASS"
    severity="info"
fi
```

### Step 3: Report Violations

**For PASS (0-499 lines):**
```
✓ {file} - {line_count} lines (within limit)
```

**For WARN (500-600 lines):**
```
⚠ {file} - {line_count} lines (approaching 600-line limit, consider trimming)
   Overage: {line_count - 500} lines
   Recommendation: Remove redundant content or consolidate sections
```

**For FAIL (600+ lines):**
```
✗ {file} - {line_count} lines (EXCEEDS 600-line limit)
   Overage: {line_count - 600} lines
   Severity: CRITICAL
   Action: Must reduce line count before committing
```

## Validation Rules

### What Counts

- All non-blank lines
- Code blocks
- Tables
- Lists
- Section headers

### What Doesn't Count

- Blank lines (lines with only whitespace)
- Lines with only whitespace characters

### Document Type Detection

**By filename pattern:**
- `PRD.md` or `*/PRD.md` → PRD
- `TECH-SPEC.md` or `*/TECH-SPEC.md` → TECH-SPEC
- `MVP.md` or `*/MVP.md` → MVP
- `prp.md` or `*/prp.md` → PRP

**Fallback**: If document type cannot be determined, apply default threshold (600 lines).

## Common Violations & Fixes

### Violation: Verbose Explanations

**Symptom**: Excessive wordiness in sections

**Fix**:
- Remove redundant phrases ("in order to", "for the purpose of")
- Use bullet points instead of long paragraphs
- Combine related points
- Remove unnecessary examples

### Violation: Duplicate Content

**Symptom**: Same information repeated across sections

**Fix**:
- Reference other sections instead of repeating
- Use "See X section" pattern
- Consolidate related information

### Violation: Excessive Examples

**Symptom**: Multiple examples for same concept

**Fix**:
- Keep only the clearest example
- Use tables to show variations compactly
- Move supplementary examples to separate documentation

### Violation: Future-Proofing

**Symptom**: Documenting features not needed now (violates YAGNI)

**Fix**:
- Remove "future enhancements" sections
- Document only current requirements
- Create separate roadmap doc if needed

## Testing

### Test Cases

**Valid files (< 500 lines):**
```bash
# Should PASS
echo -e "Line 1\nLine 2\nLine 3" | grep -cve '^\s*$'
# Expected: 3, Status: PASS
```

**Warning files (500-600 lines):**
```bash
# Should WARN (simulate 550-line file)
for i in {1..550}; do echo "Line $i"; done | grep -cve '^\s*$'
# Expected: 550, Status: WARN
```

**Invalid files (> 600 lines):**
```bash
# Should FAIL (simulate 700-line file)
for i in {1..700}; do echo "Line $i"; done | grep -cve '^\s*$'
# Expected: 700, Status: FAIL
```

**Blank lines excluded:**
```bash
# Should exclude blank lines
echo -e "Line 1\n\n\nLine 2\n   \nLine 3" | grep -cve '^\s*$'
# Expected: 3 (not 6)
```

## Integration

### Shell Script Integration

```bash
validate_line_count() {
    local file="$1"
    local line_count=$(grep -cve '^\s*$' "$file")

    if [ $line_count -gt 600 ]; then
        echo "FAIL: $file has $line_count lines (limit: 600)"
        return 2
    elif [ $line_count -gt 500 ]; then
        echo "WARN: $file has $line_count lines (approaching limit)"
        return 1
    else
        echo "PASS: $file has $line_count lines"
        return 0
    fi
}
```

### Pre-Commit Hook Integration

```bash
# In .git/hooks/pre-commit.quality-gate
for file in $(git diff --cached --name-only | grep -E '\.(md)$'); do
    validate_line_count "$file"
    exit_code=$?
    if [ $exit_code -eq 2 ]; then
        echo "❌ Line count validation failed. Cannot commit."
        exit 1
    fi
done
```

## Error Handling

**If file cannot be read:**
- Return exit code 2 (FAIL)
- Log error to stderr
- Continue with other files

**If grep command fails:**
- Return exit code 2 (FAIL)
- Log error to stderr
- Recommend manual validation

**If file doesn't exist:**
- Skip gracefully
- Log warning to stderr
- Continue with other files

## Notes

- Line count validation enforces YAGNI by preventing documentation bloat
- Thresholds are configurable per document type
- Blank lines are excluded for fair assessment
- Warnings don't block commits, but failures do
- Use `git commit --no-verify` to bypass in emergencies (not recommended)

## Rationale

**Why 500-600 lines?**
- Empirically sufficient for comprehensive but concise documentation
- Forces prioritization of essential information
- Maintains readability and navigability
- Prevents documentation sprawl
- Enforces YAGNI principle on documentation itself

**Why exclude blank lines?**
- Blank lines are formatting, not content
- Fairer assessment of actual verbosity
- Prevents gaming the system with extra spacing
- Aligns with content-focused quality metrics
