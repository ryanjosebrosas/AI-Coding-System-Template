---
name: Test
description: "Automated testing with error detection and AI-suggested fixes"
phase: test
dependencies: [execution]
outputs:
  - path: "features/{feature-name}/test-results.md"
    description: "Test results report for feature"
  - path: "testing/test-results-{timestamp}.md"
    description: "Timestamped test results in testing directory"
  - path: "testing/INDEX.md"
    description: "Updated index of all test results"
  - path: "features/{feature-name}/STATUS.md"
    description: "Updated feature status tracking file"
inputs:
  - path: "features/{feature-name}/prd.md"
    description: "Product Requirements Document for acceptance criteria verification"
    required: true
  - path: "features/{feature-name}/prp.md"
    description: "Plan Reference Protocol for test patterns and validation commands"
    required: true
  - path: "features/{feature-name}/execution.md"
    description: "Execution log with completed tasks"
    required: true
---

# Test Command

## Purpose

Automate testing with error detection and AI-suggested fixes. This command runs test suites (unit, integration, E2E), detects errors, uses AI to suggest fixes, generates coverage reports, verifies acceptance criteria, and stores test results.

## Execution Steps

### Step 1: Load Test Configuration

Load test configuration from PRP and codebase patterns:

1. **Load PRP**:
   - Read `features/{feature-name}/prp.md`
   - Extract Validation Loop section
   - Extract: Test patterns, test framework, coverage requirements

2. **Load PRD**:
   - Read `features/{feature-name}/prd.md`
   - Extract acceptance criteria
   - Extract success metrics

3. **Identify test framework**:
   - From PRP or codebase patterns
   - Common frameworks: Jest, Vitest, Mocha, pytest, etc.
   - Identify test commands

**Expected Result**: Test configuration loaded and ready.

### Step 2: Run Test Suites

Execute test suites and capture output:

1. **Run unit tests**:
   - Execute unit test command (e.g., `npm run test:unit` or `pytest tests/`)
   - Capture stdout and stderr
   - Capture exit code
   - Record duration

2. **Run integration tests** (if configured):
   - Execute integration test command (e.g., `npm run test:integration`)
   - Capture stdout and stderr
   - Capture exit code
   - Record duration

3. **Run E2E tests** (if configured):
   - Execute E2E test command (e.g., `npm run test:e2e` or `playwright tests/`)
   - Capture stdout and stderr
   - Capture exit code
   - Record duration

4. **Run coverage analysis** (if configured):
   - Execute coverage command (e.g., `npm run test:coverage` or `pytest --cov`)
   - Capture coverage report
   - Extract coverage percentages

5. **Handle test execution errors**:
   - If test command fails to execute:
     - Log error: "Test command failed to execute: {error}"
     - Continue with available test results
     - Mark as partial test run

**Expected Result**: Test suites executed, output captured.

### Step 2.5: Run Validation Gates

Execute validation gates after test suites to verify code quality:

1. **Load validation configuration**:
   - Load PRP (already loaded in Step 1)
   - Extract: Validation gates, quality thresholds, security rules
   - Identify codebase patterns (language, build tools, linting config)

2. **Execute syntax checking**:
   - Run syntax check:
     - JavaScript/TypeScript: `npm run build` or `tsc --noEmit`
     - Python: `python -m py_compile` or `mypy`
     - Rust: `cargo check`
     - Go: `go build`
   - Capture syntax errors with file locations and line numbers
   - Categorize: Fatal (syntax errors) or Warning (type errors)

3. **Execute linting**:
   - Run linter:
     - JavaScript/TypeScript: `npm run lint` or `eslint .`
     - Python: `pylint` or `ruff check`
     - Rust: `cargo clippy`
     - Go: `golangci-lint run`
   - Capture linting violations (rule, file, line, severity)
   - Categorize: Fatal (critical errors) or Warning (style issues)

4. **Execute security scanning**:
   - Run security scan:
     - JavaScript/TypeScript: `npm audit`, `snyk test`, or `semgrep`
     - Python: `bandit`, `safety check`
     - Rust: `cargo-audit`
     - General: `semgrep --config auto`
   - Scan for vulnerabilities (memory safety, injection, unsafe patterns)
   - Categorize: Fatal (critical/high severity) or Warning (medium/low severity)

5. **Execute formatting validation**:
   - Run format checker:
     - JavaScript/TypeScript: `prettier --check .`
     - Python: `black --check .` or `ruff check`
     - Rust: `cargo fmt --check`
     - Go: `gofmt -l .`
   - Capture formatting issues
   - Categorize: Warning (non-blocking)

6. **Handle validation gate errors**:
   - If validation gate fails to execute:
     - Log error: "Validation gate {gate_name} failed: {error}"
     - Continue with remaining gates
     - Mark as partial validation run

**Expected Result**: Validation gates executed, results categorized by severity.

### Step 3: Detect Errors

Parse test output to identify failures and errors:

1. **Parse test output**:
   - Parse test framework output format
   - Extract: Test results, failures, errors, skips
   - Organize by test suite

2. **Identify test failures**:
   - Extract failed test names
   - Extract error messages
   - Extract stack traces
   - Extract assertion failures

3. **Identify runtime errors**:
   - Extract runtime error messages
   - Extract stack traces
   - Extract timeout errors
   - Extract setup/teardown errors

4. **Organize errors**:
   - Group by test file
   - Group by error type
   - Prioritize by severity

**Expected Result**: Errors detected and categorized.

### Step 4: AI-Suggested Fixes

Use AI/MCP to analyze errors and generate fix suggestions:

1. **Prepare error context**:
   - Combine: Error messages + Stack traces + Test code + Implementation code
   - Include PRP anti-patterns and validation commands
   - Extract relevant code snippets

2. **Query AI for fix suggestions**:
   - For each error:
     - Prompt AI: "Analyze this test failure and suggest a fix. Error: {error_message}. Stack trace: {stack_trace}. Test code: {test_code}. Implementation code: {implementation_code}. Provide specific fix with code examples."
     - Request structured response:
       - Root cause analysis
       - Fix recommendation
       - Code example showing fix
       - Prevention suggestions

3. **Use RAG knowledge base** (optional):
   - Search for similar errors: `rag_search_knowledge_base(query="test failure {error_type}", match_count=3)`
   - Search for fix patterns: `rag_search_code_examples(query="test fix {error_type}", match_count=3)`
   - Use results to enhance fix suggestions

4. **Extract fix suggestions**:
   - Parse AI response for:
     - Root cause
     - Fix recommendation
     - Code example
     - Prevention tips

**Expected Result**: Fix suggestions generated for each error.

### Step 5: Generate Test Results Report

Compile findings into comprehensive test report:

1. **Create document structure**:
   ```markdown
   # Test Results: {feature-name}

   ## Test Summary
   {Overall test results}

   ## Test Suites
   {Results from each test suite}

   ## Validation Gates
   {Results from validation gates}

   ## Errors Detected
   {List of errors with details}

   ## Fix Suggestions
   {AI-suggested fixes for each error}

   ## Coverage Report
   {Coverage analysis if available}

   ## Acceptance Criteria Verification
   {Verification of PRD acceptance criteria}

   ## Recommendation
   {Overall recommendation for next steps}
   ```

2. **Populate content**:
   - Fill in: Test summary from Step 2
   - Fill in: Validation gate results from Step 2.5
   - Fill in: Errors detected from Step 3 (includes test and validation errors)
   - Fill in: Fix suggestions from Step 4
   - Fill in: Coverage report from Step 2
   - Fill in: Acceptance criteria verification
   - Fill in: Overall recommendation

3. **Generate timestamp**:
   - Use ISO 8601 format: YYYY-MM-DDTHH:mm:ssZ
   - Include in filename and document

4. **Save documents**:
   - Save feature test results: `features/{feature-name}/test-results.md`
   - Save timestamped test results: `testing/test-results-{timestamp}.md`
   - Update `testing/INDEX.md` with new entry

5. **Update STATUS.md**:
   - Mark Test phase with status
   - Add test results summary
   - Update artifacts list
   - Add timestamp

**Expected Result**: Test report generated, STATUS.md updated.

## Output Format

```markdown
# Test Results: {feature-name}

**Tested By**: Test Command
**Test Date**: {timestamp}
**Feature**: {feature-name}
**Duration**: {duration}

## Test Summary

### Overall Results
- **Total Tests Run**: {count}
- **Passed**: {count}
- **Failed**: {count}
- **Skipped**: {count}
- **Pass Rate**: {percentage}
- **Duration**: {duration}

### Test Suites

#### Unit Tests
- **Total**: {count}
- **Passed**: {count}
- **Failed**: {count}
- **Duration**: {duration}
- **Command**: {test_command}

#### Integration Tests
- **Total**: {count}
- **Passed**: {count}
- **Failed**: {count}
- **Duration**: {duration}
- **Command**: {test_command}

#### E2E Tests (if applicable)
- **Total**: {count}
- **Passed**: {count}
- **Failed**: {count}
- **Duration**: {duration}
- **Command**: {test_command}

## Validation Gates

### Syntax Checking
- **Status**: {Pass/Fail}
- **Tool**: {syntax_checker}
- **Duration**: {duration}
- **Issues Found**: {count}
  - Fatal: {count}
  - Warning: {count}

**Issues**:
| File | Line | Error | Severity |
|------|------|-------|----------|
| {file} | {line} | {error} | {severity} |

### Linting
- **Status**: {Pass/Fail}
- **Tool**: {linter}
- **Duration**: {duration}
- **Issues Found**: {count}
  - Fatal: {count}
  - Warning: {count}

**Issues**:
| File | Line | Rule | Severity | Description |
|------|------|------|----------|-------------|
| {file} | {line} | {rule} | {severity} | {description} |

### Security Scanning
- **Status**: {Pass/Fail}
- **Tool**: {security_scanner}
- **Duration**: {duration}
- **Vulnerabilities Found**: {count}
  - Critical/High: {count}
  - Medium/Low: {count}

**Vulnerabilities**:
| File | Line | Vulnerability | Severity | Fix Recommendation |
|------|------|----------------|----------|-------------------|
| {file} | {line} | {vulnerability} | {severity} | {fix} |

### Formatting Validation
- **Status**: {Pass/Fail}
- **Tool**: {format_checker}
- **Duration**: {duration}
- **Files with Issues**: {count}

**Formatting Issues**:
| File | Issue | Fix Command |
|------|-------|-------------|
| {file} | {description} | {fix_command} |

### Validation Summary
- **Total Gates**: {count}
- **Passed**: {count}
- **Failed**: {count}
- **Fatal Issues**: {count}
- **Warning Issues**: {count}

## Errors Detected

| Test | Type | Error Message | Stack Trace | Severity |
|-------|------|--------------|-------------|----------|
| {test} | {type} | {error} | {trace} | {severity} |

### Error Summary
- **Total Errors**: {count}
  - Critical: {count}
  - High: {count}
  - Medium: {count}
  - Low: {count}

## Fix Suggestions

| Error | Root Cause | Fix Recommendation | Code Example |
|-------|------------|-------------------|--------------|
| {error} | {cause} | {fix} | {example} |

### Additional Recommendations
{Additional suggestions from AI analysis}

## Coverage Report

### Overall Coverage
- **Lines Covered**: {count}
- **Total Lines**: {count}
- **Coverage**: {percentage}

### Coverage by File
| File | Lines Covered | Total Lines | Coverage |
|------|--------------|-------------|----------|
| {file} | {count} | {count} | {percentage} |

## Acceptance Criteria Verification

| Criteria | Status | Notes |
|----------|--------|-------|
| {criteria} | {Pass/Fail} | {notes} |

### Overall Verification
- **All Criteria Met**: {Yes/No}
- **Gaps Identified**: {count}
- **Blocking Issues**: {count}

## Approval Status

**Status**: {Approved / Approved with Changes / Blocked}

**Validation Impact**: {Approval status based on validation gate results and test results}

**Conditions for Approval**:
- All tests pass (unit, integration, E2E if applicable)
- All fatal validation issues resolved (syntax, critical linting, critical/high security vulnerabilities)
- Warning-level issues documented and acknowledged
- Acceptance criteria met
- Coverage requirements satisfied (if applicable)

**Blocking Issues**:
- **Fatal Validation Failures**: {Any fatal issues from validation gates that block approval}
  - Syntax errors: {count}
  - Critical linting violations: {count}
  - Critical/High security vulnerabilities: {count}
- **Test Failures**: {Unresolved test failures that block approval}
  - Failed unit tests: {count}
  - Failed integration tests: {count}
  - Failed E2E tests: {count}

**Approval Determination**:
- **Approved**: All tests pass, no fatal validation issues, acceptance criteria met
- **Approved with Changes**: Minor warnings only, tests pass, acceptance criteria met
- **Blocked**: Fatal validation failures exist, test failures exist, or acceptance criteria not met

**Next Steps**:
{Recommended actions based on test and validation results}

- If approved: Proceed to review or deployment phase
- If approved with changes: Document warnings, proceed to review phase
- If blocked: Fix fatal issues and test failures, re-run /test command before proceeding

**Note**: Fatal validation failures (syntax errors, critical linting violations, critical/high security vulnerabilities) **must** be resolved before approval. These issues block progression to review and deployment phases.
```

## Error Handling

- **PRP Not Found**: Check `features/{feature-name}/` directory, error and stop
- **PRD Not Found**: Check `features/{feature-name}/` directory, error and stop
- **Test Framework Not Found**: Use default test commands (npm run test, pytest)
- **Test Command Fails**: Log error, mark as partial test run, continue with available results
- **Coverage Analysis Fails**: Log error, continue without coverage report
- **Validation Gate Fails**: Log error, mark as partial validation run, continue with remaining gates
- **Syntax Check Fails**: Categorize as fatal, continue with remaining validation gates
- **Linting Fails**: Categorize as fatal or warning based on severity, continue with remaining gates
- **Security Scan Fails**: Log error, continue with other validation gates
- **AI Analysis Fails**: Log error, generate test report without fix suggestions
- **Acceptance Criteria Verification Fails**: Log which criterion failed, continue with other checks

## Notes

- Test command automates test execution and error detection
- Validation gates (syntax, linting, security, formatting) run after test suites to verify code quality
- Validation results are incorporated into the test report alongside test results
- AI-suggested fixes provide actionable guidance for fixing errors
- Coverage reports help identify untested code
- Acceptance criteria verification ensures PRD requirements are met
- Test results are stored both with feature and globally
- Test results feed into review and deployment phases
- If all tests pass and validation gates pass, proceed to review or deployment
- If tests fail or validation gates fail, fix errors and re-run tests before proceeding
- Validation gate failures are categorized as fatal (blocking) or warning (non-blocking)
