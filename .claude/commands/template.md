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

## Caching

This command may interact with MCP tools and benefit from response caching.

### MCP Tool Caching

When calling Archon MCP tools (e.g., `find_tasks`, `rag_search_knowledge_base`, `manage_task`), use the `cache_mcp_call` function to cache responses and reduce redundant operations.

**Usage Pattern**:
```python
from auto_claude.scripts.cache_manager import cache_mcp_call

# Wrap MCP tool calls with caching
result = cache_mcp_call(
    tool_name='find_tasks',
    params={'filter_by': 'status', 'filter_value': 'todo'},
    func=find_tasks,  # The actual MCP tool function
    filter_by='status',
    filter_value='todo'
)
```

**Benefits**:
- Reduces redundant MCP server calls
- Improves response times for repeated queries
- Automatic cache expiration (default 30 minutes for MCP tools)
- Transparent cache hits/misses tracking

**When to Cache**:
- ✅ Cache `find_tasks` calls when querying task lists
- ✅ Cache `rag_search_knowledge_base` for common search queries
- ✅ Cache `find_projects` for project lookups
- ❌ Don't cache `manage_task` with `create`/`update`/`delete` operations (write operations)
- ❌ Don't cache if real-time data is critical

**Cache Key Generation**: Cache keys are automatically generated from tool name and parameters. Identical calls will hit the cache.

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

### Example 2: MCP Tool with Caching

**Scenario**: Query tasks from Archon MCP with caching enabled

**Implementation**:
```python
from auto_claude.scripts.cache_manager import cache_mcp_call

# First call - cache miss, fetches from MCP
tasks = cache_mcp_call(
    tool_name='find_tasks',
    params={'filter_by': 'status', 'filter_value': 'todo'},
    func=find_tasks,
    filter_by='status',
    filter_value='todo'
)

# Second call with same params - cache hit, returns cached result
tasks_again = cache_mcp_call(
    tool_name='find_tasks',
    params={'filter_by': 'status', 'filter_value': 'todo'},
    func=find_tasks,
    filter_by='status',
    filter_value='todo'
)
```

**Benefits**:
- Second call returns immediately from cache
- Reduced load on MCP server
- Improved response time

## Notes

- [Note 1]
- [Note 2]
- [Gotcha 1]
- [Best practice 1]

### Caching Best Practices

- **Use caching for read operations**: Cache MCP tools that query data (find_tasks, rag_search, find_projects)
- **Avoid caching write operations**: Don't cache manage_task with create/update/delete, or manage_document with write operations
- **Cache TTL**: MCP responses are cached for 30 minutes by default (configurable in .auto-claude/cache/config.json)
- **Cache key parameters**: Ensure all relevant parameters are included in the `params` dict for proper cache key generation
- **Monitor cache hit rate**: Use `/cache-stats` to monitor cache effectiveness and adjust TTL if needed

### Caching Gotchas

- **Stale data**: Cached data may become outdated. Use cache invalidation or shorter TTL for frequently changing data
- **Parameter sensitivity**: Cache keys are parameter-sensitive. `{'query': 'auth'}` and `{'query': 'auth ', 'extra': None}` generate different keys
- **Write operations**: Never cache operations that modify state (create, update, delete). This will cause stale data and inconsistent state
- **Cache warming**: First call is always a cache miss. Consider pre-warming cache for critical operations

## Validation

After executing this command:
- [ ] Output file(s) created successfully
- [ ] Output format matches specification
- [ ] All required sections present
- [ ] INDEX.md updated (if applicable)
- [ ] STATUS.md updated (if applicable)
- [ ] Archon MCP tasks updated (if applicable)
