---
name: cache-invalidate
description: Invalidate and clear cached entries by type or key
phase: independent
inputs:
  - type: Cache type to invalidate (rag, web, mcp, all). Defaults to "rag"
  - key: Optional specific cache key to invalidate (exact match)
  - pattern: Optional pattern to match cache keys for batch invalidation
  - older_than: Optional time threshold (e.g., "1h", "30m", "1d") - invalidate entries older than this
  - force: Skip confirmation prompt (default: false)
outputs:
  - Invalidation summary with count of cleared entries and freed space
dependencies:
  - Cache manager script exists (`.auto-claude/scripts/cache_manager.py`)
  - Cache directory structure initialized (`.auto-claude/cache/`)
---

# Cache Invalidate Command

## Purpose

Clear cached entries to free up space, force fresh data fetching, or resolve stale cache issues. This command provides granular control over cache invalidation with options to target specific cache types, keys, or time-based criteria.

**When to use**: Use this command to manually clear cache when:
- Data appears stale or outdated
- Cache is consuming too much disk space
- Testing with fresh data is required
- Troubleshooting cache-related issues
- After updating knowledge sources (for RAG cache)

**What it solves**: This command addresses the need for manual cache control beyond automatic TTL-based expiration, giving users direct control over cache lifecycle.

## Prerequisites

- Cache manager script exists (`.auto-claude/scripts/cache_manager.py`)
- Cache directory structure initialized (`.auto-claude/cache/`)
- Cache data file exists (`.auto-claude/cache/cache_data.json`)

## Execution Steps

### Step 1: Parse Invalidation Parameters

**Objective**: Determine which cache entries to invalidate.

**Actions**:
1. Extract parameters from command context:
   - `type`: Cache type ("rag", "web", "mcp", "all")
   - `key`: Specific cache key (optional)
   - `pattern`: Key pattern for batch invalidation (optional)
   - `older_than`: Time threshold for selective invalidation (optional)
   - `force`: Skip confirmation (default: false)

**Expected Result**: Parsed parameters with default values applied.

### Step 2: Validate Parameters

**Objective**: Ensure parameters are valid and compatible.

**Actions**:
1. Check if `type` is valid: rag, web, mcp, or all
2. If `key` is specified, verify it exists in cache
3. If `pattern` is specified, validate it's a valid glob pattern
4. If `older_than` is specified, parse time duration (e.g., "1h" = 1 hour)
5. Check for parameter conflicts:
   - Cannot specify both `key` and `pattern`
   - Cannot specify both `key` and `older_than`

**Expected Result**: Validated parameters or error message for invalid input.

### Step 3: Query Current Cache State

**Objective**: Get cache statistics before invalidation.

**Actions**:
1. Execute cache manager CLI command:
   ```bash
   python .auto-claude/scripts/cache_manager.py --stats
   ```
2. Parse output for:
   - Total entries count
   - Entries by type
   - Cache size
   - Cache directory path

**Expected Result**: Cache statistics object for pre-invalidation baseline.

### Step 4: Identify Entries to Invalidate

**Objective**: Build list of cache keys to remove.

**Actions**:
1. Load cache data from `.auto-claude/cache/cache_data.json`
2. Filter entries based on parameters:

   **By type**:
   - `type="rag"`: Match keys with prefix "rag_"
   - `type="web"`: Match keys with prefix "web_"
   - `type="mcp"`: Match keys with prefix "mcp_"
   - `type="all"`: Match all cache entries

   **By key**:
   - Exact match: `key == cache_key`

   **By pattern**:
   - Glob match: `fnmatch(cache_key, pattern)`

   **By age**:
   - Compare timestamp: `current_time - entry_time > older_than_threshold`

3. Count matched entries and calculate total size

**Expected Result**: List of cache keys to invalidate with metadata.

### Step 5: Confirm Invalidation (if not forced)

**Objective**: Get user confirmation before destructive operation.

**Actions**:
1. If `force` is false:
   - Display invalidation summary:
     ```
     ## Cache Invalidation Summary

     Type: {type}
     Entries to clear: {count}
     Space to free: {size}
     Criteria: {key/pattern/older_than/type}

     {affected_entries_preview}
     ```
   - Prompt user: "Proceed with cache invalidation? (y/n)"
2. If user confirms or `force` is true, proceed
3. If user declines, abort operation

**Expected Result**: User confirmation or operation aborted.

### Step 6: Execute Invalidation

**Objective**: Remove identified cache entries.

**Actions**:
1. Execute cache manager CLI command:
   ```bash
   python .auto-claude/scripts/cache_manager.py --invalidate --type {type} --key {key} --pattern {pattern} --older-than {older_than}
   ```
2. Parse output for:
   - Number of entries removed
   - Space freed
   - Any errors encountered

**Expected Result**: Cache entries removed and metrics updated.

### Step 7: Update Cache Metrics

**Objective**: Update metrics to reflect invalidation.

**Actions**:
1. Execute cache manager CLI command:
   ```bash
   python .auto-claude/scripts/cache_manager.py --refresh-metrics
   ```
2. Verify metrics file updated correctly
3. Calculate invalidation impact

**Expected Result**: Updated metrics file reflecting post-invalidation state.

### Step 8: Display Invalidation Report

**Objective**: Present formatted invalidation summary to user.

**Actions**:
1. Format output as markdown:
   ```
   ## Cache Invalidation Complete ✓

   | Metric | Before | After | Change |
   |--------|--------|-------|--------|
   | Total Entries | {before_count} | {after_count} | -{removed_count} |
   | Cache Size | {before_size} | {after_size} | -{freed_space} |
   | {type} Entries | {before_type_count} | {after_type_count} | -{removed_type_count} |

   ### Invalidated Entries
   - Total removed: {removed_count}
   - Space freed: {freed_space}
   - Type: {type}
   - Criteria: {criteria_description}

   ### Next Steps
   - Cache will rebuild automatically as you use the system
   - Use `/cache-stats` to monitor cache performance
   - Use `/cache-health` to verify cache system status
   ```

**Expected Result**: Invalidation report displayed to user.

## Output Format

The command displays a formatted invalidation report:

```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 12 | -33 |
| Cache Size | 2.8 MB | 0.7 MB | -2.1 MB |
| RAG Entries | 15 | 0 | -15 |

### Invalidated Entries
- Total removed: 33
- Space freed: 2.1 MB
- Type: rag
- Criteria: Clear all RAG cache entries

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

## Error Handling

### Cache Manager Not Found

- **Cause**: `.auto-claude/scripts/cache_manager.py` doesn't exist
- **Detection**: Command fails with "No such file or directory"
- **Recovery**: Inform user to run cache infrastructure setup, suggest checking phase-1 subtasks

### Cache Directory Missing

- **Cause**: `.auto-claude/cache/` directory doesn't exist
- **Detection**: Cache manager initialization fails
- **Recovery**: Inform user to create cache directory structure

### Cache Data File Missing

- **Cause**: `.auto-claude/cache/cache_data.json` doesn't exist
- **Detection**: File read operation fails
- **Recovery**: Create empty cache data file, inform user cache is already empty

### Invalid Cache Type

- **Cause**: User specified invalid `type` parameter
- **Detection**: Type not in ["rag", "web", "mcp", "all"]
- **Recovery**: Display error message with valid types, suggest correct command

### Key Not Found

- **Cause**: Specified `key` doesn't exist in cache
- **Detection**: Key lookup returns None
- **Recovery**: Display message that key doesn't exist, show available keys with `/cache-stats`

### Pattern Matches Nothing

- **Cause**: Specified `pattern` doesn't match any cache keys
- **Detection**: Filtered entry list is empty
- **Recovery**: Display message that pattern matched nothing, suggest checking pattern syntax

### Invalid Time Format

- **Cause**: `older_than` parameter has invalid format
- **Detection**: Time duration parsing fails
- **Recovery**: Display error with valid format examples (e.g., "1h", "30m", "1d")

### Parameter Conflict

- **Cause**: Mutually exclusive parameters specified together
- **Detection**: Parameter validation detects conflict
- **Recovery**: Display error explaining conflict, suggest using one parameter at a time

## Examples

### Example 1: Clear All RAG Cache

**Command**: `/cache-invalidate type="rag"`

**Output**:
```
## Cache Invalidation Summary

Type: rag
Entries to clear: 15
Space to free: 1.2 MB
Criteria: Clear all RAG cache entries

Affected entries (showing first 5):
- rag_search:authentication_jwt:1234567890
- rag_search:vector_search_pgvector:1234567891
- rag_search:React_hooks:1234567892
- rag_search:MCP_patterns:1234567893
- rag_search:async_patterns:1234567894

Proceed with cache invalidation? (y/n)
```

**User confirms**: `y`

**Final Output**:
```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 30 | -15 |
| Cache Size | 2.8 MB | 1.6 MB | -1.2 MB |
| RAG Entries | 15 | 0 | -15 |

### Invalidated Entries
- Total removed: 15
- Space freed: 1.2 MB
- Type: rag
- Criteria: Clear all RAG cache entries

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

### Example 2: Invalidate Specific Cache Key

**Command**: `/cache-invalidate type="rag" key="rag_search:authentication_jwt:1234567890"`

**Output**:
```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 44 | -1 |
| Cache Size | 2.8 MB | 2.7 MB | -102.4 KB |
| RAG Entries | 15 | 14 | -1 |

### Invalidated Entries
- Total removed: 1
- Space freed: 102.4 KB
- Type: rag
- Criteria: Key match (rag_search:authentication_jwt:1234567890)

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

### Example 3: Batch Invalidation by Pattern

**Command**: `/cache-invalidate type="rag" pattern="rag_search:*authentication*"`

**Output**:
```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 42 | -3 |
| Cache Size | 2.8 MB | 2.5 MB | -307.2 KB |
| RAG Entries | 15 | 12 | -3 |

### Invalidated Entries
- Total removed: 3
- Space freed: 307.2 KB
- Type: rag
- Criteria: Pattern match (rag_search:*authentication*)

Matched entries:
- rag_search:authentication_jwt:1234567890
- rag_search:authorization_patterns:1234567895
- rag_search:oauth_flow:1234567896

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

### Example 4: Time-Based Invalidation

**Command**: `/cache-invalidate type="all" older_than="1h"`

**Output**:
```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 18 | -27 |
| Cache Size | 2.8 MB | 1.1 MB | -1.7 MB |
| All Types | 45 | 18 | -27 |

### Invalidated Entries
- Total removed: 27
- Space freed: 1.7 MB
- Type: all
- Criteria: Older than 1 hour

Entries removed by type:
- RAG: 12 entries (820 KB)
- Web: 10 entries (650 KB)
- MCP: 5 entries (230 KB)

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

### Example 5: Force Invalidation (No Confirmation)

**Command**: `/cache-invalidate type="web" force=true`

**Output**:
```
## Cache Invalidation Complete ✓

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Entries | 45 | 35 | -10 |
| Cache Size | 2.8 MB | 2.1 MB | -700 KB |
| Web Entries | 10 | 0 | -10 |

### Invalidated Entries
- Total removed: 10
- Space freed: 700 KB
- Type: web
- Criteria: Clear all web cache entries (forced, no confirmation)

### Next Steps
- Cache will rebuild automatically as you use the system
- Use `/cache-stats` to monitor cache performance
- Use `/cache-health` to verify cache system status
```

## Notes

- **Destructive operation**: Cannot be undone - cache entries are permanently deleted
- **Automatic rebuild**: Cache will repopulate as you use the system
- **Confirmation by default**: Forces you to confirm before clearing (use `force=true` to skip)
- **Selective clearing**: Use parameters to target specific entries instead of clearing everything
- **Time-based clearing**: Useful for removing stale data while keeping recent entries
- **Metric updates**: Cache metrics automatically update after invalidation

## Cache Types

The following cache types can be invalidated:

| Type | Prefix | Description | Typical Use |
|------|--------|-------------|-------------|
| `rag` | `rag_` | RAG search results | Knowledge base queries, code searches |
| `web` | `web_` | Web search/content | External research, documentation lookup |
| `mcp` | `mcp_` | MCP tool responses | Task management, project queries |
| `all` | (any) | All cache types | Complete cache reset |

## Invalidation Strategies

### Clear All of One Type

Best for: Complete refresh of a specific cache type

```bash
/cache-invalidate type="rag"
```

### Clear Specific Entry

Best for: Removing one stale or problematic entry

```bash
/cache-invalidate type="rag" key="rag_search:authentication_jwt:1234567890"
```

### Clear by Pattern

Best for: Batch removing related entries (e.g., all authentication-related searches)

```bash
/cache-invalidate type="rag" pattern="rag_search:*authentication*"
```

### Clear by Age

Best for: Removing old entries while keeping recent data

```bash
/cache-invalidate type="all" older_than="1h"
```

Supported time formats:
- `30m` = 30 minutes
- `1h` = 1 hour
- `2d` = 2 days
- `1w` = 1 week

## Validation

After executing this command:
- [ ] Parameters validated successfully
- [ ] Cache entries identified correctly
- [ ] User confirmation obtained (if not forced)
- [ ] Cache manager invalidation command executed
- [ ] Entries removed from cache data file
- [ ] Metrics updated to reflect changes
- [ ] Invalidation report displayed accurately
- [ ] Error cases handled gracefully

## Integration with Other Commands

- **`/cache-stats`**: Check cache metrics before and after invalidation
- **`/cache-health`**: Verify cache system status after clearing
- **`/learn`**: RAG cache rebuilds when you run this command again
- **`/planning`**: Web cache rebuilds when you research topics again
- **`/execution`**: MCP cache rebuilds when you manage tasks

## Performance Considerations

- **Fast operation**: Invalidating cache is very fast (file write operation)
- **Cache rebuild cost**: First requests after invalidation will be slower (cache misses)
- **Disk space**: Frequent invalidation reduces disk usage but increases API/server calls
- **Network usage**: Clearing web or RAG cache may trigger new network requests

## Troubleshooting

### Cache Still Shows Old Data

**Possible causes**:
1. Cache not actually cleared (command failed)
2. Different cache type than expected
3. Data source hasn't changed

**Solutions**:
- Verify invalidation succeeded with `/cache-stats`
- Check you're invalidating the correct cache type
- Confirm underlying data source was actually updated

### No Entries Were Removed

**Possible causes**:
1. Pattern/key doesn't match anything
2. Cache type has no entries
3. All entries newer than `older_than` threshold

**Solutions**:
- Run `/cache-stats` to see what's actually cached
- Check your pattern syntax
- Adjust `older_than` threshold
- Try broader invalidation (e.g., `type="all"`)

### Invalidation Command Failed

**Possible causes**:
1. Cache manager script missing
2. Cache directory doesn't exist
3. File permissions issue
4. Cache data file corrupted

**Solutions**:
- Verify cache infrastructure is set up (check phase-1 subtasks)
- Check file permissions on `.auto-claude/cache/`
- Try deleting cache data file manually (will recreate on next run)
- Run `/cache-health` to diagnose issues

## When to Use Each Invalidation Type

### Use `type="rag"` When:
- Knowledge base sources are updated
- RAG server indexes are refreshed
- You're getting stale search results
- Testing with fresh knowledge base data

### Use `type="web"` When:
- Web pages you referenced have changed
- Documentation has been updated
- You need fresh research data
- Troubleshooting web cache issues

### Use `type="mcp"` When:
- Archon MCP server data was updated externally
- Task/project data changed outside workflow
- Testing MCP integration
- Troubleshooting MCP cache issues

### Use `type="all"` When:
- Complete cache reset needed
- Troubleshooting system-wide cache issues
- Before running comprehensive tests
- Freeing maximum disk space

## Safety Tips

- **Always check first**: Run `/cache-stats` before invalidating to see what will be cleared
- **Use selective invalidation**: Prefer `key` or `pattern` over clearing entire cache type
- **Time-based clearing**: Use `older_than` to preserve recent entries
- **Test with force=false**: Default confirmation prevents accidental clears
- **Monitor rebuild**: Run `/cache-stats` after to see cache repopulate
