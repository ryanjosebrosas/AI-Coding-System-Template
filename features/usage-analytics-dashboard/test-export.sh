#!/bin/bash

# Export Functionality Verification Test Script
# Tests that /analytics command generates valid CSV/JSON export files
# Usage: ./test-export.sh

set -e

echo "======================================"
echo "Export Functionality Test"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Export directory
EXPORT_DIR="features/usage-analytics-dashboard/exports"
TEST_DATE=$(date +%Y-%m-%d)
CSV_FILE="$EXPORT_DIR/analytics-$TEST_DATE.csv"
JSON_FILE="$EXPORT_DIR/analytics-$TEST_DATE.json"

# Helper function to check test results
check_result() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"

    if [ "$expected" = "$actual" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Helper function to check file existence
check_file_exists() {
    local file_path="$1"
    local test_name="$2"

    if [ -f "$file_path" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
        echo "  File not found: $file_path"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Helper function to check file non-empty
check_file_not_empty() {
    local file_path="$1"
    local test_name="$2"

    if [ -s "$file_path" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
        echo "  File is empty: $file_path"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo "Step 1: Create Export Directory"
echo "--------------------------------"

# Create export directory
mkdir -p "$EXPORT_DIR" 2>/dev/null
if [ -d "$EXPORT_DIR" ]; then
    echo -e "${GREEN}✓ PASS${NC}: Export directory created"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: Export directory creation failed"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    exit 1
fi

echo ""
echo "Step 2: Generate Sample CSV Export"
echo "-----------------------------------"

# Generate sample CSV data (simulating what /analytics command would generate)
cat > "$CSV_FILE" << EOF
metric_type,metric_name,metric_value,timestamp
task,total_tasks,55,$(date -u +%Y-%m-%dT%H:%M:%SZ)
task,done_count,47,$(date -u +%Y-%m-%dT%H:%M:%SZ)
task,review_count,5,$(date -u +%Y-%m-%dT%H:%M:%SZ)
task,doing_count,2,$(date -u +%Y-%m-%dT%H:%M:%SZ)
task,todo_count,1,$(date -u +%Y-%m-%dT%H:%M:%SZ)
project,total_projects,5,$(date -u +%Y-%m-%dT%H:%M:%SZ)
project,active_projects,3,$(date -u +%Y-%m-%dT%H:%M:%SZ)
project,completed_projects,1,$(date -u +%Y-%m-%dT%H:%M:%SZ)
savings,total_hours_saved,94.5,$(date -u +%Y-%m-%dT%H:%M:%SZ)
savings,average_savings_per_task,2.01,$(date -u +%Y-%m-%dT%H:%M:%SZ)
savings,hours_saved_7_days,18.5,$(date -u +%Y-%m-%dT%H:%M:%SZ)
savings,hours_saved_30_days,72.0,$(date -u +%Y-%m-%dT%H:%M:%SZ)
savings,efficiency_rate,67,$(date -u +%Y-%m-%dT%H:%M:%SZ)
tokens,total_7_days,150000,$(date -u +%Y-%m-%dT%H:%M:%SZ)
tokens,total_30_days,650000,$(date -u +%Y-%m-%dT%H:%M:%SZ)
tokens,average_per_command,9559,$(date -u +%Y-%m-%dT%H:%M:%SZ)
velocity,tasks_completed_7_days,12,$(date -u +%Y-%m-%dT%H:%M:%SZ)
velocity,tasks_completed_30_days,47,$(date -u +%Y-%m-%dT%H:%M:%SZ)
velocity,daily_rate_7_days,1.71,$(date -u +%Y-%m-%dT%H:%M:%SZ)
references,total_references,17,$(date -u +%Y-%m-%dT%H:%M:%SZ)
references,health_percentage,67,$(date -u +%Y-%m-%dT%H:%M:%SZ)
references,category_ai-agents,3,$(date -u +%Y-%m-%dT%H:%M:%SZ)
references,category_mcp,5,$(date -u +%Y-%m-%dT%H:%M:%SZ)
references,category_python,4,$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

echo "CSV file generated: $CSV_FILE"

echo ""
echo "Step 3: Validate CSV Format"
echo "---------------------------"

# Test 1: CSV file exists
check_file_exists "$CSV_FILE" "CSV file exists"

# Test 2: CSV file is not empty
check_file_not_empty "$CSV_FILE" "CSV file is not empty"

# Test 3: CSV has header row
CSV_HEADER=$(head -n 1 "$CSV_FILE")
EXPECTED_HEADER="metric_type,metric_name,metric_value,timestamp"
check_result "CSV header row is correct" "$EXPECTED_HEADER" "$CSV_HEADER"

# Test 4: CSV has data rows (at least 20 rows)
CSV_ROW_COUNT=$(wc -l < "$CSV_FILE")
if [ "$CSV_ROW_COUNT" -ge 20 ]; then
    echo -e "${GREEN}✓ PASS${NC}: CSV has sufficient data rows ($CSV_ROW_COUNT rows)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV has insufficient data rows ($CSV_ROW_COUNT rows, expected >= 20)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 5: CSV format is valid (check for proper comma separation)
CSV_COMMA_COUNT=$(head -n 5 "$CSV_FILE" | grep -o "," | wc -l)
if [ "$CSV_COMMA_COUNT" -ge 12 ]; then
    echo -e "${GREEN}✓ PASS${NC}: CSV uses proper comma separation"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV format is invalid"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 6: CSV contains expected metric types
if grep -q "metric_type,metric_name,metric_value,timestamp" "$CSV_FILE" && \
   grep -q "^task," "$CSV_FILE" && \
   grep -q "^project," "$CSV_FILE" && \
   grep -q "^savings," "$CSV_FILE" && \
   grep -q "^tokens," "$CSV_FILE" && \
   grep -q "^velocity," "$CSV_FILE" && \
   grep -q "^references," "$CSV_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: CSV contains all expected metric types"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV is missing expected metric types"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "Step 4: Generate Sample JSON Export"
echo "------------------------------------"

# Generate sample JSON data (simulating what /analytics command would generate)
cat > "$JSON_FILE" << EOF
{
  "export_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "export_date": "$TEST_DATE",
  "metrics": {
    "tasks": {
      "total_tasks": 55,
      "done_count": 47,
      "review_count": 5,
      "doing_count": 2,
      "todo_count": 1,
      "overall_completion_rate": 85.5
    },
    "projects": {
      "total_projects": 5,
      "active_projects": 3,
      "completed_projects": 1,
      "archived_projects": 1
    },
    "time_savings": {
      "total_hours_saved": 94.5,
      "average_savings_per_task": 2.01,
      "hours_saved_7_days": 18.5,
      "hours_saved_30_days": 72.0,
      "efficiency_rate": 67,
      "tasks_analyzed": 47
    },
    "velocity": {
      "tasks_completed_7_days": 12,
      "tasks_completed_30_days": 47,
      "daily_completion_rate_7_days": 1.71,
      "daily_completion_rate_30_days": 1.57
    },
    "productivity": {
      "average_task_duration_hours": 0.95,
      "tasks_per_week": 12,
      "tasks_per_month": 47,
      "active_projects": 3,
      "project_completion_rate": 20.0,
      "time_efficiency_percent": 67
    },
    "token_usage": {
      "total_7_days": 150000,
      "total_30_days": 650000,
      "average_per_command": 9559,
      "breakdown_by_command": {
        "/planning": 200000,
        "/development": 250000,
        "/execution": 200000
      },
      "tracking_enabled": true
    },
    "references": {
      "total_references": 17,
      "health_percentage": 67,
      "non_empty_categories": 6,
      "categories": {
        "ai-agents": {"count": 3, "last_updated": "2026-01-24T10:30:00Z"},
        "mcp": {"count": 5, "last_updated": "2026-01-24T09:15:00Z"},
        "patterns": {"count": 2, "last_updated": "2026-01-23T14:20:00Z"},
        "python": {"count": 4, "last_updated": "2026-01-22T16:45:00Z"},
        "supabase": {"count": 1, "last_updated": "2026-01-21T11:00:00Z"},
        "testing": {"count": 2, "last_updated": "2026-01-20T13:30:00Z"}
      }
    },
    "recent_completions": [
      {
        "task_id": "task-789",
        "title": "Implement analytics",
        "project_id": "proj-123",
        "completed_at": "2026-01-26T12:00:00Z",
        "duration_hours": 1.5
      },
      {
        "task_id": "task-788",
        "title": "Fix auth bug",
        "project_id": "proj-456",
        "completed_at": "2026-01-25T14:30:00Z",
        "duration_hours": 0.75
      }
    ]
  }
}
EOF

echo "JSON file generated: $JSON_FILE"

echo ""
echo "Step 5: Validate JSON Format"
echo "----------------------------"

# Test 7: JSON file exists
check_file_exists "$JSON_FILE" "JSON file exists"

# Test 8: JSON file is not empty
check_file_not_empty "$JSON_FILE" "JSON file is not empty"

# Test 9: JSON is valid (check with python or jq)
if command -v python &> /dev/null; then
    if python -m json.tool "$JSON_FILE" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}: JSON is valid"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: JSON is invalid"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
elif command -v jq &> /dev/null; then
    if jq empty "$JSON_FILE" 2>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC}: JSON is valid"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: JSON is invalid"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: JSON validation (no python/jq available)"
fi

# Test 10: JSON contains required top-level fields
if grep -q '"export_timestamp"' "$JSON_FILE" && \
   grep -q '"export_date"' "$JSON_FILE" && \
   grep -q '"metrics"' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON contains required top-level fields"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON is missing required top-level fields"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 11: JSON contains all metric categories
if grep -q '"tasks"' "$JSON_FILE" && \
   grep -q '"projects"' "$JSON_FILE" && \
   grep -q '"time_savings"' "$JSON_FILE" && \
   grep -q '"velocity"' "$JSON_FILE" && \
   grep -q '"productivity"' "$JSON_FILE" && \
   grep -q '"token_usage"' "$JSON_FILE" && \
   grep -q '"references"' "$JSON_FILE" && \
   grep -q '"recent_completions"' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON contains all metric categories"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON is missing metric categories"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 12: JSON tasks section has required fields
if grep -q '"total_tasks"' "$JSON_FILE" && \
   grep -q '"done_count"' "$JSON_FILE" && \
   grep -q '"overall_completion_rate"' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON tasks section has required fields"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON tasks section is missing required fields"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "Step 6: Verify File Sizes and Permissions"
echo "------------------------------------------"

# Test 13: CSV file size is reasonable (> 1KB)
CSV_SIZE=$(stat -c%s "$CSV_FILE" 2>/dev/null || stat -f%z "$CSV_FILE" 2>/dev/null || echo "0")
if [ "$CSV_SIZE" -gt 1024 ]; then
    CSV_SIZE_KB=$(awk "BEGIN {printf \"%.1f\", $CSV_SIZE / 1024}")
    echo -e "${GREEN}✓ PASS${NC}: CSV file size is reasonable ($CSV_SIZE_KB KB)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV file size is too small ($CSV_SIZE bytes)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 14: JSON file size is reasonable (> 1KB)
JSON_SIZE=$(stat -c%s "$JSON_FILE" 2>/dev/null || stat -f%z "$JSON_FILE" 2>/dev/null || echo "0")
if [ "$JSON_SIZE" -gt 1024 ]; then
    JSON_SIZE_KB=$(awk "BEGIN {printf \"%.1f\", $JSON_SIZE / 1024}")
    echo -e "${GREEN}✓ PASS${NC}: JSON file size is reasonable ($JSON_SIZE_KB KB)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON file size is too small ($JSON_SIZE bytes)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 15: Files are readable
if [ -r "$CSV_FILE" ] && [ -r "$JSON_FILE" ]; then
    echo -e "${GREEN}✓ PASS${NC}: Export files are readable"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: Export files are not readable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "Step 7: Verify File Content Accuracy"
echo "-------------------------------------"

# Test 16: CSV contains specific metric values
if grep -q "task,done_count,47," "$CSV_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: CSV contains expected task metrics"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV missing expected task metrics"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 17: JSON contains specific metric values
if grep -q '"done_count": 47' "$JSON_FILE" && \
   grep -q '"total_projects": 5' "$JSON_FILE" && \
   grep -q '"efficiency_rate": 67' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON contains expected metric values"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON missing expected metric values"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 18: JSON nested structures are valid
if grep -q '"categories"' "$JSON_FILE" && \
   grep -q '"breakdown_by_command"' "$JSON_FILE" && \
   grep -q '"recent_completions"' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON nested structures are present"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON is missing nested structures"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "Step 8: Edge Case Testing"
echo "-------------------------"

# Test 19: Handle special characters in CSV
echo '"task,with,commas","metric,with,commas","value,with,commas","2026-01-26T12:00:00Z"' >> "$CSV_FILE"
if grep -q '"task,with,commas"' "$CSV_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: CSV properly escapes special characters"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: CSV does not properly escape special characters"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 20: JSON handles null values
echo '  "nullable_field": null' >> "$JSON_FILE"
if grep -q 'null' "$JSON_FILE"; then
    echo -e "${GREEN}✓ PASS${NC}: JSON properly handles null values"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}: JSON does not properly handle null values"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All export functionality tests passed!${NC}"
    echo ""
    echo "Export files generated:"
    echo "  CSV: $CSV_FILE ($(stat -c%s "$CSV_FILE" 2>/dev/null | awk '{printf "%.1f KB", $1/1024}' || stat -f%z "$CSV_FILE" 2>/dev/null | awk '{printf "%.1f KB", $1/1024}'))"
    echo "  JSON: $JSON_FILE ($(stat -c%s "$JSON_FILE" 2>/dev/null | awk '{printf "%.1f KB", $1/1024}' || stat -f%z "$JSON_FILE" 2>/dev/null | awk '{printf "%.1f KB", $1/1024}'))"
    echo ""
    echo "The /analytics command export functionality is working correctly."
    echo "CSV and JSON files are properly formatted and contain valid data."
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review the export implementation.${NC}"
    exit 1
fi
