#!/usr/bin/env bash

# validate-quality.sh - Code Quality Gates Validation Script
#
# Purpose: Validates PRDs, tech specs, and PRPs against quality standards:
# - Line count limits (500-600 lines max)
# - Required sections present
# - YAGNI/KISS compliance
#
# Usage: ./scripts/validate-quality.sh [file|directory]
#   If no argument provided, checks all markdown files in current directory
#
# Exit codes:
#   0 - All checks passed
#   1 - Quality gate violations found
#   2 - Usage error

set -euo pipefail

# Configuration
MAX_LINES=600
WARN_LINES=500
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required sections by document type
declare -A REQUIRED_SECTIONS
REQUIRED_SECTIONS["PRD"]="User Stories Acceptance Criteria Rationale"
REQUIRED_SECTIONS["TECH-SPEC"]="Architecture Components Data Models APIs Testing Deployment"
REQUIRED_SECTIONS["PRP"]="Goal Context Implementation_Blueprint Validation_Loop Known_Gotchas"
REQUIRED_SECTIONS["MVP"]="Core_Features Success_Criteria Out_of_Scope Timeline"

# ==========================================
# Utility Functions
# ==========================================

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_section() {
    echo -e "\n${BLUE}▶ $1${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# ==========================================
# Validation Functions
# ==========================================

detect_document_type() {
    local file="$1"
    local basename=$(basename "$file" .md)

    if [[ "$basename" == "PRD" ]]; then
        echo "PRD"
    elif [[ "$basename" == "TECH-SPEC" ]] || [[ "$basename" == "TECH SPEC" ]]; then
        echo "TECH-SPEC"
    elif [[ "$basename" == "MVP" ]]; then
        echo "MVP"
    elif [[ "$file" =~ features/.*/prp\.md$ ]]; then
        echo "PRP"
    elif [[ "$file" =~ templates/prp/.*\.md$ ]]; then
        echo "PRP"
    else
        echo "UNKNOWN"
    fi
}

validate_line_count() {
    local file="$1"
    local line_count=$(wc -l < "$file" 2>/dev/null || echo 0)

    if [[ $line_count -gt $MAX_LINES ]]; then
        print_error "Line count violation: $line_count lines (max: $MAX_LINES)"
        return 1
    elif [[ $line_count -gt $WARN_LINES ]]; then
        print_warning "Line count warning: $line_count lines (warn: $WARN_LINES, max: $MAX_LINES)"
        return 0
    else
        print_success "Line count: $line_count lines (within limit)"
        return 0
    fi
}

validate_required_sections() {
    local file="$1"
    local doc_type="$2"
    local sections="${REQUIRED_SECTIONS[$doc_type]:-}"

    if [[ -z "$sections" ]] || [[ "$doc_type" == "UNKNOWN" ]]; then
        print_warning "No required sections defined for document type: $doc_type"
        return 0
    fi

    local missing_sections=()
    local found_sections=0

    for section in $sections; do
        # Handle spaces in section names (replace underscores with spaces for search)
        local search_pattern="${section//_/ }"
        if grep -q "^#.*$search_pattern" "$file"; then
            ((found_sections++))
        else
            missing_sections+=("$search_pattern")
        fi
    done

    local total_sections=$(echo "$sections" | wc -w)

    if [[ ${#missing_sections[@]} -gt 0 ]]; then
        print_error "Missing required sections ($found_sections/$total_sections):"
        for section in "${missing_sections[@]}"; do
            echo -e "  ${RED}  - $section${NC}"
        done
        return 1
    else
        print_success "All required sections present ($found_sections/$total_sections)"
        return 0
    fi
}

validate_yagni_compliance() {
    local file="$1"

    # Check for verbose/potentially redundant content
    local violations=()

    # Check for excessive examples (YAGNI)
    local example_count=0
    example_count=$(grep -c "^>.*Example" "$file" 2>/dev/null) || example_count=0
    if [[ $example_count -gt 5 ]]; then
        violations+=("Too many examples ($example_count), consider reducing (YAGNI)")
    fi

    # Check for verbose explanations (KISS)
    local verbose_lines=0
    verbose_lines=$(grep -E "^(The following|In order to|It is important to note)" "$file" 2>/dev/null | wc -l)
    if [[ $verbose_lines -gt 10 ]]; then
        violations+=("Verbose language detected ($verbose_lines verbose intros), simplify (KISS)")
    fi

    if [[ ${#violations[@]} -gt 0 ]]; then
        print_warning "YAGNI/KISS suggestions:"
        for violation in "${violations[@]}"; do
            echo -e "  ${YELLOW}  - $violation${NC}"
        done
        return 0  # Warning, not failure
    else
        print_success "YAGNI/KISS compliant"
        return 0
    fi
}

# ==========================================
# Main Validation Logic
# ==========================================

validate_file() {
    local file="$1"
    local violations=0
    local result=0

    print_section "Validating: $file"

    # Detect document type
    local doc_type=$(detect_document_type "$file")
    echo "Document type: $doc_type"

    # Run validations - track violations without triggering set -e
    validate_line_count "$file" || result=$?
    if [[ $result -ne 0 ]]; then
        ((violations++))
        result=0
    fi

    if [[ "$doc_type" != "UNKNOWN" ]]; then
        validate_required_sections "$file" "$doc_type" || result=$?
        if [[ $result -ne 0 ]]; then
            ((violations++))
            result=0
        fi
    fi

    validate_yagni_compliance "$file"  # Non-blocking

    # Always return 0, violations tracked via count
    if [[ $violations -gt 0 ]]; then
        return 1
    else
        return 0
    fi
}

generate_quality_report() {
    local total_files=$1
    local passed_files=$2
    local failed_files=$3
    local total_violations=$4

    # Calculate overall quality score
    local overall_score=0
    if [[ $total_files -gt 0 ]]; then
        overall_score=$(( (passed_files * 100) / total_files ))
    fi

    # Determine severity level based on score
    local severity="Excellent"
    local severity_color="$GREEN"
    if [[ $overall_score -lt 60 ]]; then
        severity="Critical"
        severity_color="$RED"
    elif [[ $overall_score -lt 80 ]]; then
        severity="Fair"
        severity_color="$YELLOW"
    elif [[ $overall_score -lt 90 ]]; then
        severity="Good"
        severity_color="$GREEN"
    fi

    echo -e "\n"
    print_header "Quality Report"

    # Summary Statistics
    echo -e "${BLUE}### Summary${NC}\n"
    echo "Total files checked: $total_files"
    echo "Passed: $passed_files"
    echo "Failed: $failed_files"
    echo "Total violations: $total_violations"
    echo ""

    # Overall Quality Score with severity
    echo -e "${BLUE}### Overall Assessment${NC}\n"
    echo -e "Quality Level: ${severity_color}$severity${NC}"
    echo -e "Overall Score: ${severity_color}$overall_score%${NC}"
    echo ""

    # Quality Gate Status
    if [[ $failed_files -eq 0 ]]; then
        print_success "All quality gates passed!"
        echo ""
        echo -e "${GREEN}Approval Status: Approved${NC}"
        echo -e "Reason: All files meet quality standards (YAGNI/KISS compliance, line limits, required sections)"
        return 0
    else
        print_error "Quality gates failed for $failed_files file(s)"
        echo ""
        echo -e "${RED}Approval Status: Blocked${NC}"
        echo -e "Reason: Quality violations must be resolved before approval"

        # Recommendations
        echo -e "\n${BLUE}### Recommendations${NC}\n"
        echo -e "${YELLOW}Immediate Actions:${NC}"
        echo "  • Review files with line count violations (max: $MAX_LINES lines)"
        echo "  • Add missing required sections for failed documents"
        echo "  • Reduce verbose content to improve YAGNI/KISS compliance"
        echo ""

        # Bypass instructions
        echo -e "${YELLOW}To bypass quality gates and commit anyway:${NC}"
        echo -e "  ${YELLOW}git commit --no-verify${NC}"
        echo ""

        return 1
    fi
}

# ==========================================
# Main Entry Point
# ==========================================

main() {
    local target="${1:-.}"
    local files=()

    # Determine files to check
    if [[ -f "$target" ]]; then
        files=("$target")
    elif [[ -d "$target" ]]; then
        # Find all markdown files
        while IFS= read -r -d '' file; do
            # Skip node_modules, .git, etc.
            if [[ ! "$file" =~ (node_modules|\.git|\.claude/context) ]]; then
                files+=("$file")
            fi
        done < <(find "$target" -name "*.md" -type f -print0)
    else
        print_error "Invalid target: $target"
        echo "Usage: $0 [file|directory]"
        exit 2
    fi

    if [[ ${#files[@]} -eq 0 ]]; then
        print_warning "No markdown files found to validate"
        exit 0
    fi

    print_header "Code Quality Gates Validation"
    echo "Checking ${#files[@]} file(s)..."
    echo ""

    local total_files=${#files[@]}
    local passed_files=0
    local failed_files=0
    local total_violations=0

    # Validate each file
    for file in "${files[@]}"; do
        if validate_file "$file"; then
            ((passed_files++)) || true
        else
            ((failed_files++)) || true
            ((total_violations++)) || true
        fi
    done

    # Generate final report
    generate_quality_report "$total_files" "$passed_files" "$failed_files" "$total_violations"
    exit $?
}

# Run main function
main "$@"
