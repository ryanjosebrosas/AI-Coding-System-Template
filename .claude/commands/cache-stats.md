---
name: Cache Stats
description: "Display cache metrics and performance statistics"
phase: independent
dependencies: []
outputs:
  - description: "Cache statistics report displayed to user"
inputs: []
---

# Cache Stats Command

## Purpose

Query the cache manager for metrics including hit rate, cache entries, size, and breakdown by prefix (mcp, rag, artifact). Display formatted statistics to help users understand cache performance and usage patterns.

This command provides a quick overview of cache performance without needing to manually inspect cache files or configuration.

**When to use**: Use this command to check cache hit rates, monitor cache growth, identify which cache types are most used, or verify cache is working correctly.

**What it solves**: This command addresses the need to monitor cache effectiveness and understand usage patterns across MCP, RAG, and artifact caches.

## Prerequisites

- Cache manager script exists (`.auto-claude/scripts/cache_manager.py`)
- Cache directory structure initialized (`.auto-claude/cache/`)

## Execution Steps

### Step 1: Query Cache Metrics

**Objective**: Get current cache metrics from cache manager.

**Actions**:
1. Execute cache manager CLI command:
   ```bash
   python .auto-claude/scripts/cache_manager.py --metrics
   ```
2. Parse output for key metrics:
   - Total requests
   - Cache hits
   - Cache misses
   - Hit rate percentage
   - Cache entries count
   - Cache size in bytes
   - Last updated timestamp

**Expected Result**: Metrics object with all current cache statistics.

### Step 2: Query Cache Statistics

**Objective**: Get detailed breakdown of cache entries by prefix.

**Actions**:
1. Execute cache manager CLI command:
   ```bash
   python .auto-claude/scripts/cache_manager.py --stats
   ```
2. Parse output for:
   - Cache directory path
   - Total entries
   - Entries by prefix (mcp, rag, artifact, other)
   - Cache configuration (TTL settings)

**Expected Result**: Statistics object with entry breakdown and configuration.

### Step 3: Calculate Performance Insights

**Objective**: Generate insights from metrics data.

**Actions**:
1. Analyze hit rate:
   - 80-100%: "Excellent"
   - 60-79%: "Good"
   - 40-59%: "Fair"
   - 20-39%: "Poor"
   - 0-19%: "Critical"
2. Identify most-used cache type by entry count
3. Calculate cache efficiency score:
   - `efficiency = hit_rate * (1 - (size / max_size))`
4. Format cache size in human-readable units (KB, MB)

**Expected Result**: Performance status label and insights.

### Step 4: Display Report

**Objective**: Present formatted cache statistics report to user.

**Actions**:
1. Format output as markdown:
   ```
   ## Cache Performance: {hit_rate}% ({status})

   | Metric | Value |
   |--------|-------|
   | Total Requests | {total_requests} |
   | Cache Hits | {hits} |
   | Cache Misses | {misses} |
   | Cache Entries | {entries} |
   | Cache Size | {size_formatted} |
   | Last Updated | {timestamp} |

   ### Entries by Cache Type
   | Type | Count |
   |------|-------|
   | MCP Cache | {mcp_count} |
   | RAG Cache | {rag_count} |
   | Artifact Cache | {artifact_count} |
   | Other | {other_count} |

   ### Configuration
   - Default TTL: {default_ttl}s
   - MCP TTL: {mcp_ttl}s
   - RAG TTL: {rag_ttl}s
   - Max Size: {max_size_formatted}

   ---
   Use `/cache-invalidate` to clear cache entries.
   Use `/cache-health` to check cache system health.
   ```

**Expected Result**: Cache statistics report displayed to user.

## Output Format

The command displays a formatted statistics report:

```
## Cache Performance: 72.5% (Good)

| Metric | Value |
|--------|-------|
| Total Requests | 145 |
| Cache Hits | 105 |
| Cache Misses | 40 |
| Cache Entries | 23 |
| Cache Size | 1.2 MB |
| Last Updated | 2026-01-26T12:30:45 |

### Entries by Cache Type
| Type | Count |
|------|-------|
| MCP Cache | 12 |
| RAG Cache | 8 |
| Artifact Cache | 3 |
| Other | 0 |

### Configuration
- Default TTL: 3600s (1 hour)
- MCP TTL: 1800s (30 minutes)
- RAG TTL: 7200s (2 hours)
- Max Size: 100.0 MB

---
Use `/cache-invalidate` to clear cache entries.
Use `/cache-health` to check cache system health.
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

### No Cache Data

- **Cause**: Cache is empty (first run or recently cleared)
- **Detection**: Total requests = 0 and entries = 0
- **Recovery**: Display "Cache is empty" message, suggest using commands that generate cache entries

### Metrics File Corrupted

- **Cause**: `metrics.json` has invalid JSON
- **Detection**: Cache manager returns default metrics
- **Recovery**: Display warning about metrics reset, show current default values

## Examples

### Example 1: Healthy Cache

**Command**: `/cache-stats`

**Output**:
```
## Cache Performance: 85.3% (Excellent)

| Metric | Value |
|--------|-------|
| Total Requests | 312 |
| Cache Hits | 266 |
| Cache Misses | 46 |
| Cache Entries | 45 |
| Cache Size | 2.8 MB |
| Last Updated | 2026-01-26T14:22:10 |

### Entries by Cache Type
| Type | Count |
|------|-------|
| MCP Cache | 28 |
| RAG Cache | 15 |
| Artifact Cache | 2 |
| Other | 0 |

### Configuration
- Default TTL: 3600s (1 hour)
- MCP TTL: 1800s (30 minutes)
- RAG TTL: 7200s (2 hours)
- Max Size: 100.0 MB

---
Use `/cache-invalidate` to clear cache entries.
Use `/cache-health` to check cache system health.
```

### Example 2: Empty Cache

**Command**: `/cache-stats`

**Output**:
```
## Cache Performance: 0% (No Data)

| Metric | Value |
|--------|-------|
| Total Requests | 0 |
| Cache Hits | 0 |
| Cache Misses | 0 |
| Cache Entries | 0 |
| Cache Size | 0 bytes |
| Last Updated | - |

### Cache is Empty
No cache entries yet. Use commands that generate cached data:
- MCP tool calls (find_tasks, rag_search_knowledge_base)
- RAG searches (knowledge base queries)
- Artifact generation

---
Cache will populate automatically as you use the system.
```

### Example 3: Poor Cache Performance

**Command**: `/cache-stats`

**Output**:
```
## Cache Performance: 25.0% (Poor)

| Metric | Value |
|--------|-------|
| Total Requests | 120 |
| Cache Hits | 30 |
| Cache Misses | 90 |
| Cache Entries | 8 |
| Cache Size | 512 KB |
| Last Updated | 2026-01-26T10:15:30 |

### Entries by Cache Type
| Type | Count |
|------|-------|
| MCP Cache | 3 |
| RAG Cache | 5 |
| Artifact Cache | 0 |
| Other | 0 |

### Performance Insights
⚠️ Low hit rate detected. This could indicate:
- Cache entries expiring too quickly (consider increasing TTL)
- Highly unique queries (little cache reuse)
- Recent cache invalidation

### Configuration
- Default TTL: 3600s (1 hour)
- MCP TTL: 1800s (30 minutes)
- RAG TTL: 7200s (2 hours)
- Max Size: 100.0 MB

---
Use `/cache-invalidate` to clear cache entries.
Use `/cache-health` to check cache system health.
```

## Notes

- **Quick check**: This command is the fastest way to see cache performance
- **No side effects**: Read-only operation, doesn't modify cache
- **Human-readable**: Sizes and times formatted for easy reading
- **Actionable insights**: Performance status helps identify cache issues

## Cache Types

The stats report tracks these cache prefixes:

| Prefix | Description | Typical Use |
|--------|-------------|-------------|
| `mcp` | MCP tool responses | find_tasks, rag_search, find_projects |
| `rag` | RAG search results | knowledge base queries, code searches |
| `artifact` | Generated artifacts | PRDs, tech specs, task plans |
| `other` | Uncached data | Miscellaneous cached values |

## Metrics Explained

### Hit Rate

Percentage of cache requests that returned cached data:

- **80-100%**: Excellent - cache working very well
- **60-79%**: Good - cache providing solid benefits
- **40-59%**: Fair - cache helping but could improve
- **20-39%**: Poor - cache may need tuning
- **0-19%**: Critical - cache not effective (check TTL)

### Cache Size

Total disk space used by cache data:

- Stored in `.auto-claude/cache/cache_data.json`
- Size affects read/write performance
- Monitored against `max_cache_size` limit

### Last Updated

Timestamp of most recent cache activity:

- Shows cache is actively being used
- Helps identify stale cache (old timestamp)

## Validation

After executing this command:
- [ ] Cache manager CLI commands executed successfully
- [ ] Metrics parsed correctly
- [ ] Hit rate calculated accurately
- [ ] Entries by prefix counted correctly
- [ ] Report formatted and displayed
- [ ] Error cases handled gracefully

## Integration with Other Commands

- **`/cache-invalidate`**: Clear cache entries when needed
- **`/cache-health`**: Check cache system health and configuration
- **`/learn`**: Generates RAG cache entries when searching knowledge base
- **`/planning`**: Generates web cache entries when researching
- **`/execution`**: Generates MCP cache entries when managing tasks

## Performance Considerations

- **Read-only**: This command doesn't modify cache, very fast
- **No network calls**: All data read from local cache files
- **Lightweight**: Minimal CPU and memory usage
- **Frequent use**: Safe to run frequently to monitor cache

## Troubleshooting

### Hit Rate is Low

**Possible causes**:
1. TTL too short - entries expiring before reuse
2. High query variety - little repetition in queries
3. Recent cache clear - metrics reset recently

**Solutions**:
- Increase TTL in cache config
- Check query patterns for opportunities to reuse
- Monitor over time to establish baseline

### Cache Size is Large

**Possible causes**:
1. Many cached entries
2. Large response sizes
3. Expired entries not cleaned up

**Solutions**:
- Run `/cache-invalidate` to clear old entries
- Reduce TTL for less critical cache types
- Check individual cache type usage

### Stale Timestamp

**Possible causes**:
1. Cache not being used
2. System inactive
3. Cache manager not being called

**Solutions**:
- Run commands that use caching (MCP calls, RAG searches)
- Verify cache manager integration is working
- Check for errors in command execution
