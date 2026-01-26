---
name: Command Name
description: "Brief description of what this command does"
phase: prime|discovery|planning|development|task-planning|execution|review|test
dependencies: []
outputs:
  - path: "relative/path/to/output.md"
    description: "Description of output"
inputs:
  - path: "relative/path/to/input.md"
    description: "Description of input"
    required: true|false
---

# Command Name

## Purpose

[Detailed description of command purpose]

This command [what it does]. It is used during the [phase] phase to [specific purpose].

**When to use**: Use this command when [conditions].

**What it solves**: This command addresses [problem/need].

## Prerequisites

- [Prerequisite 1]
- [Prerequisite 2]

## Execution Steps

### Step 1: [Step Name]

[Detailed instructions for step 1]

**Actions**:
1. Action 1
2. Action 2
3. Action 3

**Expected Result**: [What should happen]

### Step 2: [Step Name]

[Detailed instructions for step 2]

**Actions**:
1. Action 1
2. Action 2

**Expected Result**: [What should happen]

### Step 3: [Step Name]

[Detailed instructions for step 3]

**Actions**:
1. Action 1
2. Action 2

**Expected Result**: [What should happen]

## Output Format

The command generates the following output:

**File**: `{output-path}`

**Structure**:
```markdown
# {Output Title}

## Section 1
{Content}

## Section 2
{Content}
```

**Required Sections**:
- Section 1 (required)
- Section 2 (required)
- Section 3 (optional)

**Format Requirements**:
- Markdown format
- ISO 8601 timestamps (YYYY-MM-DDTHH:mm:ssZ)
- UTF-8 encoding

## Error Handling

### Error Types

1. **Error Type 1**: [Description]
   - **Cause**: [What causes it]
   - **Detection**: [How to detect]
   - **Recovery**: [How to recover]

2. **Error Type 2**: [Description]
   - **Cause**: [What causes it]
   - **Detection**: [How to detect]
   - **Recovery**: [How to recover]

### Error Recovery

**On Error**:
1. Log error to execution.md
2. Update task status in Archon MCP
3. Provide clear error message to user
4. Suggest recovery steps
5. Allow resume from checkpoint

**Checkpoint/Resume**:
- Save state to STATUS.md
- Allow resume with `--from-{phase}` option
- Preserve partial work

## Examples

### Example 1: [Scenario]

**Input**: [Input description]

**Output**: [Output description]

**Steps**:
1. [Step]
2. [Step]
3. [Step]

## Notes

- [Note 1]
- [Note 2]
- [Gotcha 1]
- [Best practice 1]

## Validation

After executing this command:
- [ ] Output file(s) created successfully
- [ ] Output format matches specification
- [ ] All required sections present
- [ ] INDEX.md updated (if applicable)
- [ ] STATUS.md updated (if applicable)
- [ ] Archon MCP tasks updated (if applicable)
