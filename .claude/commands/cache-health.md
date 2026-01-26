---
name: Cache Health
description: "Check cache system health, directory structure, file integrity, and performance status"
phase: independent
dependencies: []
outputs:
  - description: "Health report with cache system status, issues found, and recommendations"
inputs: []
---

# Cache Health Command

## Purpose

Comprehensive health check for cache system - verifies directory structure, file integrity, configuration validity, and performance metrics.

**When to use**: Diagnose cache issues, verify after setup, troubleshoot poor performance, confirm correct operation.

## Prerequisites

- Cache manager script exists (`.auto-claude/scripts/cache_manager.py`)
- Cache directory initialized (`.auto-claude/cache/`)

## Execution Steps

### Step 1: Health Check Scan

**1.1 Directory Structure**:
- `.auto-claude/cache/` - Should exist
- `.auto-claude/cache/config.json` - Valid JSON with `default_ttl`, `max_cache_size`, `cache_enabled`
- `.auto-claude/cache/cache_data.json` - Valid JSON (may be empty)
- `.auto-claude/cache/metrics.json` - Valid JSON with `total_requests`, `cache_hits`, `cache_misses`, `last_updated`

**1.2 Cache Manager**:
- Script exists and executable
- Has required functions: `get_cache`, `set_cache`, `invalidate_cache`
- CLI interface with `--health` flag

**1.3 Configuration Validation**:
- `default_ttl > 0` (typically 3600)
- `max_cache_size > 0` (typically 104857600 for 100MB)
- `cache_enabled` is true/false

**1.4 Cache Data Integrity**:
- Valid JSON structure
- Each entry has: key, value, timestamp, optional TTL
- No corrupted or malformed entries

**1.5 Metrics Integrity**:
- Counts are non-negative
- `hits + misses >= total_requests`
- Hit rate: 0-1 range

**1.6 Performance Checks**:
- Hit rate: <40% = poor, >70% = good
- Cache size vs max: >90% = near capacity
- Cache age: >24h = stale

### Step 2: Generate Health Report

```markdown
# Cache System Health Report

**Date**: {timestamp}
**Cache Directory**: {cache_path}

## Summary
- **Health Score**: {percentage}% ({status})
- **Checks Passed**: {passed_count}/{total_count}
- **Issues Found**: {issue_count}

## Health Status
### Directory Structure: {status}
### Cache Manager: {status}
### Configuration: {status}
### Cache Data: {status}
### Metrics: {status}
### Performance: {status}

## Issues Found
{issues_list}

## Recommendations
{recommendations_list}
```

**Status levels**: ✓ Healthy | ⚠ Warning | ❌ Error | ⚡ Performance

### Step 3: Suggest Actions

**Healthy**: Continue normal operation, monitor weekly.

**Warning**: Address minor issues, monitor with `/cache-stats`.

**Error**: Address immediately, may need re-setup.

**Performance**: Review config, adjust TTL, check usage patterns.

## Output Example

```
# Cache System Health Report

**Date**: 2026-01-26T15:45:30

## Summary
- **Health Score**: 85% (Healthy)
- **Checks Passed**: 17/20
- **Issues Found**: 3

## Health Status
### Directory Structure: ✓ Healthy
### Cache Manager: ✓ Healthy
### Configuration: ✓ Healthy
- TTL: 3600s (✓ Optimal)
- Max size: 100.0 MB (✓ Reasonable)
- Enabled: true

### Cache Data: ⚠ Warning
- Entry count: 23
- Expired entries: 5 (⚠ Should be cleaned)
- Cache size: 2.8 MB / 100.0 MB (2.8%)

### Metrics: ✓ Healthy
- Total requests: 145
- Cache hits: 105 | misses: 40
- Hit rate: 72.4% (✓ Good)

## Issues Found
### ⚠ Expired Entries Not Cleaned
5 expired entries in cache. Run `/cache-invalidate older_than="0s"`

## Recommendations
1. Run `/cache-invalidate type="all" older_than="0s"`
2. Add automatic cleanup to cache_manager.py
3. Monitor with `/cache-stats`
```

## Error Handling

| Error | Cause | Recovery |
|-------|-------|----------|
| Cache Manager Not Found | Script doesn't exist | Complete phase-1 setup |
| Cache Directory Missing | .auto-claude/cache/ missing | Create directory structure |
| Config File Corrupted | Invalid JSON | Recreate with defaults |
| Cache Data Corrupted | Invalid JSON in cache_data.json | Recreate empty file |
| Metrics Corrupted | Invalid JSON or inconsistent data | Reset to defaults |
| Permission Denied | No read/write access | Check file permissions |

## Health Score Calculation

**Score breakdown** (0-100 total):
- Directory structure: 25 points
- Cache manager: 25 points
- Configuration: 20 points
- Cache data: 15 points
- Metrics: 10 points
- Performance: 5 points

**Status mapping**:
- 90-100: ✓ Healthy
- 70-89: ⚠ Warning
- 50-69: ❌ Error (functional but issues)
- 0-49: ❌ Critical (non-functional)

## Integration

- **`/cache-stats`**: View detailed metrics after health check
- **`/cache-invalidate`**: Clear corrupted entries
- **`/check`**: Comprehensive codebase health including cache

## Validation

- [ ] All health checks executed
- [ ] Issues documented
- [ ] Minor issues auto-fixed
- [ ] Report generated
- [ ] Recommendations provided

## Notes

- Non-destructive (read-only checks)
- Completes in <1 second
- Provides actionable recommendations
- Catches issues before critical failures
