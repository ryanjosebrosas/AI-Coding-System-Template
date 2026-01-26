# Section Validator

**Purpose**: Ensure all documentation artifacts contain required sections for completeness and consistency.

## Configuration

### Required Sections by Document Type

#### PRD (Product Requirements Document)

**Required Sections (7):**

| Section | Purpose | Validation |
|---------|---------|------------|
| `## Problem Statement` | Clear description of the problem being solved | Must exist |
| `## Rationale` | Why this solution is the right approach | Must exist |
| `## User Stories` | User-facing requirements and use cases | Must exist |
| `## Acceptance Criteria` | Definition of done for each feature | Must exist |
| `## Technical Requirements` | Technical constraints and dependencies | Must exist |
| `## Success Metrics` | Measurable outcomes and KPIs | Must exist |
| `## Open Questions` | Unresolved items requiring decisions | Must exist |

**Validation**: All 7 sections must be present (hard requirement).

#### TECH-SPEC (Technical Specification)

**Required Sections (7):**

| Section | Purpose | Validation |
|---------|---------|------------|
| `## Architecture Overview` | High-level system architecture | Must exist |
| `## System Components` | Individual component descriptions | Must exist |
| `## Data Models` | Database schemas, interfaces, types | Must exist |
| `## API Design` | API endpoints, contracts, protocols | Must exist |
| `## Implementation Details` | Technical implementation guidance | Must exist |
| `## Security Considerations` | Security requirements and measures | Must exist |
| `## Testing Strategy` | Testing approach and coverage | Must exist |

**Validation**: All 7 sections must be present (hard requirement).

#### MVP (Minimum Viable Product)

**Required Sections (5):**

| Section | Purpose | Validation |
|---------|---------|------------|
| `## Problem Statement` | Core problem being solved | Must exist |
| `## Solution Overview` | High-level solution approach | Must exist |
| `## Key Features` | Essential features for MVP | Must exist |
| `## Technical Approach` | Technical implementation plan | Must exist |
| `## Success Criteria` | MVP completion definition | Must exist |

**Validation**: All 5 sections must be present (hard requirement).

#### PRP (Project Requirements Plan)

**Required Sections (5):**

| Section | Purpose | Validation |
|---------|---------|------------|
| `## Goal` | Feature goal and deliverable | Must exist |
| `## All Needed Context` | Documentation, patterns, references | Must exist |
| `## Implementation Blueprint` | Data models, tasks, dependencies | Must exist |
| `## Validation Loop` | Testing and validation approach | Must exist |
| `## Anti-Patterns` | Common mistakes to avoid | Must exist |

**Validation**: All 5 sections must be present (hard requirement).

## Validation Logic

### Step 1: Determine Document Type

**By filename pattern:**
```bash
filename=$(basename "$file")

case "$filename" in
    "PRD.md")
        doc_type="PRD"
        ;;
    "TECH-SPEC.md")
        doc_type="TECH-SPEC"
        ;;
    "MVP.md")
        doc_type="MVP"
        ;;
    "prp.md")
        doc_type="PRP"
        ;;
    *)
        echo "Unknown document type: $filename"
        exit 1
        ;;
esac
```

### Step 2: Load Required Sections

**Based on document type:**

```bash
case "$doc_type" in
    "PRD")
        required_sections=("Problem Statement" "Rationale" "User Stories" "Acceptance Criteria" "Technical Requirements" "Success Metrics" "Open Questions")
        ;;
    "TECH-SPEC")
        required_sections=("Architecture Overview" "System Components" "Data Models" "API Design" "Implementation Details" "Security Considerations" "Testing Strategy")
        ;;
    "MVP")
        required_sections=("Problem Statement" "Solution Overview" "Key Features" "Technical Approach" "Success Criteria")
        ;;
    "PRP")
        required_sections=("Goal" "All Needed Context" "Implementation Blueprint" "Validation Loop" "Anti-Patterns")
        ;;
esac
```

### Step 3: Check Each Section

**Method**: Use grep to check for section headers

```bash
missing_sections=()
for section in "${required_sections[@]}"; do
    if ! grep -q "^## $section" "$file"; then
        missing_sections+=("$section")
    fi
done
```

**Alternative**: Check for section with optional whitespace (more flexible)

```bash
if ! grep -q "^##[[:space:]]*$section" "$file"; then
    missing_sections+=("$section")
fi
```

### Step 4: Report Results

**All sections present:**
```bash
if [ ${#missing_sections[@]} -eq 0 ]; then
    echo "✓ $file - All required sections present (${#required_sections[@]}/${#required_sections[@]})"
    return 0
fi
```

**Sections missing:**
```bash
missing_count=${#missing_sections[@]}
echo "✗ $file - Missing $missing_count required section(s):"

for section in "${missing_sections[@]}"; do
    echo "   - $section"
done

# Severity based on missing count
if [ $missing_count -gt 2 ]; then
    echo "   Severity: CRITICAL (more than 2 sections missing)"
    return 2
else
    echo "   Severity: WARNING ($missing_count section(s) missing)"
    return 1
fi
```

## Validation Rules

### Section Header Format

**Valid formats:**
- `## Section Name` (standard)
- `##  Section Name` (with extra space)

**Invalid formats:**
- `# Section Name` (wrong level - should be h2)
- `### Section Name` (wrong level - too deep)
- `Section Name` (no header marker)

**Validation**: Use regex `^##[[:space:]]*Section Name`

### Section Content Requirements

**Minimum content**: Section header must be followed by at least one non-blank line within 10 lines.

```bash
# Check if section has content
check_section_content() {
    local file="$1"
    local section="$2"

    # Find section line number
    local line_num=$(grep -n "^## $section" "$file" | cut -d: -f1)

    # Get next 10 lines after section header
    local content=$(tail -n +$((line_num + 1)) "$file" | head -n 10)

    # Check if content has non-blank lines
    if [ -z "$(echo "$content" | grep -v '^\s*$')" ]; then
        echo "✗ Section '$section' has no content"
        return 1
    fi

    return 0
}
```

**Optional**: Validate section content (more complex, may not be needed for MVP).

## Common Violations & Fixes

### Violation: Missing Section

**Symptom**: Section header not found in document

**Fix**:
1. Identify which section is missing
2. Reference template for correct section name
3. Add section with appropriate content
4. Use template structure as guide

**Template references:**
- PRD: `templates/prd/PRD.md` (if exists)
- TECH-SPEC: `templates/tech-spec/TECH-SPEC.md` (if exists)
- MVP: `templates/mvp/MVP.md` (if exists)
- PRP: `templates/prp/prp-base.md`

### Violation: Typos in Section Name

**Symptom**: Section exists but name doesn't match exactly

**Common typos:**
- "Architecutre Overview" → "Architecture Overview"
- "User Stories" vs "User Story"
- "Acceptance Criteria" vs "Acceptance criterion"
- Extra spaces, missing capitalization

**Fix**:
1. Use exact section names from required sections list
2. Capitalize each word (Title Case)
3. No extra spaces or special characters
4. Match template exactly

### Violation: Wrong Header Level

**Symptom**: Section uses h1 (`#`) or h3 (`###`) instead of h2 (`##`)

**Fix**:
```markdown
# Wrong (h1)
# Problem Statement

# Correct (h2)
## Problem Statement

# Also wrong (h3)
### Problem Statement
```

### Violation: Empty Section

**Symptom**: Section header exists but no content follows

**Fix**:
1. Add meaningful content to section
2. If section not applicable, add "N/A" with explanation
3. If work in progress, add "TODO: Add content for [section]"

## Testing

### Test Cases

**Valid PRD (all sections present):**
```bash
# Should PASS
cat > /tmp/test-prd.md << 'EOF'
## Problem Statement
This is the problem.

## Rationale
This is the rationale.

## User Stories
As a user, I want...

## Acceptance Criteria
- Criteria 1
- Criteria 2

## Technical Requirements
- Requirement 1
- Requirement 2

## Success Metrics
- Metric 1
- Metric 2

## Open Questions
- Question 1
- Question 2
EOF

validate_sections /tmp/test-prd.md PRD
# Expected: PASS, All 7 sections present
```

**Missing sections (PRD):**
```bash
# Should FAIL
cat > /tmp/test-prd-incomplete.md << 'EOF'
## Problem Statement
This is the problem.

## User Stories
As a user, I want...

## Acceptance Criteria
- Criteria 1
EOF

validate_sections /tmp/test-prd-incomplete.md PRD
# Expected: FAIL, Missing: Rationale, Technical Requirements, Success Metrics, Open Questions
```

**Typo in section name:**
```bash
# Should FAIL
cat > /tmp/test-prd-typo.md << 'EOF'
## Problem Statement
This is the problem.

## Rationales  # Typo: should be "Rationale"
This is the rationale.

## User Stories
As a user, I want...
EOF

validate_sections /tmp/test-prd-typo.md PRD
# Expected: FAIL, Missing: Rationale (typo "Rationales" not found)
```

**Wrong header level:**
```bash
# Should FAIL
cat > /tmp/test-wrong-level.md << 'EOF'
# Problem Statement  # h1 instead of h2
This is the problem.

## Rationale
This is the rationale.
EOF

validate_sections /tmp/test-wrong-level.md PRD
# Expected: FAIL, Missing: Problem Statement (wrong header level)
```

## Integration

### Shell Script Integration

```bash
validate_sections() {
    local file="$1"
    local doc_type="$2"

    # Load required sections based on doc type
    case "$doc_type" in
        "PRD")
            required_sections=("Problem Statement" "Rationale" "User Stories" "Acceptance Criteria" "Technical Requirements" "Success Metrics" "Open Questions")
            ;;
        "TECH-SPEC")
            required_sections=("Architecture Overview" "System Components" "Data Models" "API Design" "Implementation Details" "Security Considerations" "Testing Strategy")
            ;;
        "MVP")
            required_sections=("Problem Statement" "Solution Overview" "Key Features" "Technical Approach" "Success Criteria")
            ;;
        "PRP")
            required_sections=("Goal" "All Needed Context" "Implementation Blueprint" "Validation Loop" "Anti-Patterns")
            ;;
        *)
            echo "Unknown document type: $doc_type"
            return 2
            ;;
    esac

    # Check each section
    missing_sections=()
    for section in "${required_sections[@]}"; do
        if ! grep -q "^##[[:space:]]*$section" "$file"; then
            missing_sections+=("$section")
        fi
    done

    # Report results
    if [ ${#missing_sections[@]} -eq 0 ]; then
        echo "✓ $file - All required sections present"
        return 0
    else
        echo "✗ $file - Missing ${#missing_sections[@]} section(s): ${missing_sections[*]}"
        return 2
    fi
}
```

### Pre-Commit Hook Integration

```bash
# In .git/hooks/pre-commit.quality-gate
for file in $(git diff --cached --name-only | grep -E '\.(md)$'); do
    doc_type=$(detect_doc_type "$file")

    if [ -n "$doc_type" ]; then
        validate_sections "$file" "$doc_type"
        exit_code=$?

        if [ $exit_code -ne 0 ]; then
            echo "❌ Section validation failed for $file"
            echo "   Missing sections must be added before committing."
            exit 1
        fi
    fi
done
```

## Error Handling

**If file cannot be read:**
- Return exit code 2 (FAIL)
- Log error to stderr
- Continue with other files

**If document type cannot be determined:**
- Skip validation
- Log warning to stderr
- Continue with other files

**If section check fails:**
- Return exit code 2 (FAIL)
- List missing sections
- Continue with other files

## Notes

- Section validation ensures completeness and consistency
- Required sections are based on document templates
- Section names must match exactly (case-sensitive)
- Section headers must be h2 (`##`) level
- Missing sections prevent commits (hard gate)
- Use templates as reference for correct section structure
- Content validation is optional (header validation is primary focus)

## Rationale

**Why require specific sections?**
- Ensures all critical information is documented
- Provides consistent structure across documents
- Makes documents navigable and predictable
- Prevents incomplete documentation from being committed
- Supports review and collaboration processes

**Why exact section names?**
- Automated validation requires exact matches
- Consistency improves findability
- Reduces ambiguity in documentation structure
- Aligns with template-based generation
