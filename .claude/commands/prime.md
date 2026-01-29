---
name: Prime
description: "Export entire codebase for context gathering with structured markdown output. Supports incremental indexing to only process changed files."
phase: prime
dependencies: []
outputs:
  - path: "context/prime-{timestamp}.md"
    description: "Structured markdown export of codebase"
  - path: "context/INDEX.md"
    description: "Index of all prime exports"
  - path: "context/.prime-state.json"
    description: "State tracking for incremental exports"
inputs: []
---

# Prime Command

## Purpose

Export the entire codebase for context gathering. This command traverses the project directory, respects ignore patterns, and generates a structured markdown export with tree structure and file contents. This provides comprehensive context for AI assistants to understand the codebase structure, patterns, and conventions.

**Parallel File Reading**: Files are processed in parallel batches (20-50 files per batch) using background task notation for concurrent reads, reducing wall-clock time by 3-5x compared to sequential processing.

**Incremental Indexing**: On subsequent runs, the command detects changed files using git diff and only processes new, modified, or deleted files, significantly reducing execution time for large codebases.

**Relevance Scoring**: Each file is assigned a relevance score (0-100) based on recency, file type, modification frequency, and path importance. This enables selective context loading in subsequent phases, prioritizing high-relevance files for faster performance.

## Execution Steps

### Step 0: Detect Export Mode (Full vs Incremental)
- Check if `context/.prime-state.json` exists from previous export
- If no state file exists: **Full Export Mode** - process all files
- If state file exists: **Incremental Export Mode** - detect changes
  - Read last export commit hash from state file
  - Run `git diff --name-only {last_commit_hash} HEAD` to get changed files
  - Run `git diff --name-only --diff-filter=D {last_commit_hash} HEAD` to get deleted files
  - If no changes detected, exit with message "No changes since last export"
  - Changed files include: added (A), modified (M), renamed (R)
- Log export mode and number of files to process

### Step 1: Traverse Codebase and Detect Changes
- **Full Export Mode**: Use Git to get list of tracked files: `git ls-files`
- **Incremental Export Mode**: Use the changed files list from git diff
- Respect `.gitignore` and `.cursorignore` patterns
- Skip binary files (detect by extension: .png, .jpg, .gif, .pdf, .zip, etc.)
- Skip files larger than 10MB (log skipped files)
- Skip node_modules, .git, .venv, and other common ignore patterns
- Track deleted files separately for removal from previous export
- **File Hash Tracking**: For each file, compute SHA-256 hash for content-based change detection
  - Store file hashes in `performance_cache.json` under `file_hashes` section
  - Use hash to detect if file content changed even when git metadata unchanged
  - Compare current hash with cached hash to verify actual changes
- **Cache Invalidation on File Modifications**:
  - **For Incremental Mode**:
    - Get list of changed files from git diff (from Step 0)
    - Get list of deleted files from git diff (from Step 0)
    - For each changed file:
      - Compute current SHA-256 hash of file content
      - Compare with cached hash in `performance_cache.json` file_hashes section
      - If hashes differ OR file not in cache: Mark for cache invalidation
      - If hashes match AND file in cache: Cache entry remains valid
    - For each deleted file:
      - Remove from `file_cache` section in `performance_cache.json`
      - Remove from `file_hashes` section in `performance_cache.json`
      - Remove from `file_hashes` section in `.prime-state.json`
    - Log cache invalidation actions: "Invalidating cache for {count} modified files", "Removing {count} deleted files from cache"
  - **For Full Export Mode**:
    - Compute hashes for all files
    - Compare with cached hashes in `performance_cache.json`
    - Identify files with hash changes (content modified since last export)
    - Identify new files (not in cache)
    - Mark these for cache update (existing cache entries for unchanged files remain)
  - **Cache Invalidation Summary**:
    - Track counts: files_to_invalidate, files_to_keep, files_deleted
    - Log summary: "Cache Analysis: {invalidate} invalid, {keep} valid, {deleted} removed"

### Step 2: Calculate File Relevance Scores
- **Purpose**: Prioritize files for selective context loading based on multiple factors
- **Scoring Algorithm**: Compute relevance score (0-100) for each file using weighted factors:
  - **Recency Score (0-30 points)**: More recently modified files score higher
    - Files modified in last 24 hours: 30 points
    - Files modified in last 7 days: 20 points
    - Files modified in last 30 days: 10 points
    - Files modified >30 days ago: 0 points
  - **File Type Score (0-25 points)**: Source code files score higher than config/docs
    - Core source files (.ts, .js, .py, .go, .rs, .java): 25 points
    - Web files (.tsx, .jsx, .vue, .svelte): 23 points
    - Style files (.css, .scss, .less): 20 points
    - Config files (.json, .yaml, .toml, .xml): 15 points
    - Documentation (.md, .txt, .rst): 10 points
    - Test files (.test.ts, .spec.py, *_test.go): 18 points
    - Build/deploy files (Dockerfile, Makefile, .gitignore): 12 points
  - **Modification Frequency Score (0-25 points)**: Frequently changed files score higher
    - Calculate from git history: `git log --since="90 days ago" --pretty=format: --name-only {file} | wc -l`
    - >10 changes in 90 days: 25 points
    - 5-10 changes in 90 days: 20 points
    - 2-4 changes in 90 days: 15 points
    - 1 change in 90 days: 10 points
    - 0 changes in 90 days: 5 points (newly added files get 5 points)
  - **Path Importance Score (0-20 points)**: Files in important directories score higher
    - src/, lib/, core/, app/: 20 points
    - components/, services/, utils/, helpers/: 18 points
    - api/, routes/, controllers/, handlers/: 19 points
    - tests/, __tests__/, test/, spec/: 15 points
    - docs/, documentation/: 12 points
    - examples/, samples/, demo/: 10 points
    - config/, .config/, settings/: 14 points
    - scripts/, tools/, bin/: 13 points
    - vendor/, node_modules/, .venv/: 0 points (should be ignored anyway)
    - Root directory files: 16 points
- **Relevance Score Calculation**: `recency_score + file_type_score + frequency_score + path_score`
- **Score Storage**: Store relevance scores in `performance_cache.json`:
  ```json
  {
    "relevance_scores": {
      "src/index.ts": {
        "score": 85,
        "recency_score": 30,
        "file_type_score": 25,
        "frequency_score": 20,
        "path_score": 20,
        "last_calculated": "2026-01-27T10:30:00Z"
      }
    }
  }
  ```
- **Score Caching**: Relevance scores cached for 24 hours (configurable via `RELEVANCE_CACHE_TTL_HOURS`)
- **Incremental Updates**: In incremental mode, only re-score changed/new files
- **Logging**: Log score distribution: "Relevance Scores: {high} high (>70), {medium} medium (40-70), {low} low (<40)"

### Step 3: Generate Tree Structure
- **Full Export Mode**: Use `tree` command or custom traversal to generate directory structure
- **Incremental Export Mode**: Generate tree only for changed directories
- Format as markdown code block with proper indentation
- Include file counts per directory
- Mark deleted files with strikethrough or removal note

### Step 4: Export File Contents
- **Full Export Mode**: Process files in parallel batches for optimal performance
  - Divide files into batches of 20-50 files (configurable via `BATCH_SIZE` environment variable)
  - Use background task notation for concurrent reads: Read files in parallel batches
  - Track batch progress: "Processing batch {current}/{total} ({file_count} files)"
  - Parallel processing reduces wall-clock time by 3-5x compared to sequential reads
- **Incremental Export Mode**: Read only changed/new files in parallel batches
  - Smaller batch size for incremental mode (10-20 files) due to fewer total files
  - Still leverage parallel processing for maximum speed on changed files
- **Intelligent Caching**:
  - Before reading each file, check `performance_cache.json` `file_cache` section:
    - Compute SHA-256 hash of file path + current timestamp for cache key
    - Look for cached content matching file path and hash
    - Check TTL (Time To Live): Default 24 hours, configurable via `CACHE_TTL_HOURS` environment variable
    - If cache hit and TTL valid: Use cached content, increment `cache_hits` counter
    - If cache miss or TTL expired: Read file from disk, increment `cache_misses` counter
  - After reading file from disk:
    - Store content in `performance_cache.json` under `file_cache` section:
      ```json
      {
        "file_cache": {
          "src/index.ts": {
            "content": "export function main() {...}",
            "hash": "a1b2c3d4e5f6...",
            "cached_at": "2026-01-27T10:30:00Z",
            "ttl_hours": 24
          }
        }
      }
      ```
    - Include content hash for cache validation
    - Store cache timestamp for TTL calculation
  - **Cache Invalidation Execution**:
    - Process invalidation list from Step 1 (files marked for cache invalidation)
    - For each file marked for invalidation:
      - Remove existing cache entry from `performance_cache.json` file_cache section
      - Update file hash in `performance_cache.json` file_hashes section
      - Read file content from disk (cache miss - forced re-read)
      - Store new content in cache with updated hash and timestamp
    - For files NOT marked for invalidation (hash unchanged):
      - Use cached content directly (cache hit without hash re-check)
      - Verify TTL is still valid (current time <= cached_at + ttl_hours)
    - **TTL-based Invalidation**:
      - Check cache entry TTL for all files (including those with unchanged hashes)
      - If TTL expired (current time > cached_at + ttl_hours):
        - Treat as cache miss and re-read file from disk
        - Update cache with new content, hash, and timestamp
      - TTL priority: TTL expiration takes precedence over hash match
        (Even if hash matches, expired cache must be refreshed)
    - **Deleted File Cleanup**:
      - For each deleted file (from git diff --diff-filter=D):
        - Remove from `performance_cache.json` file_cache section
        - Remove from `performance_cache.json` file_hashes section
        - Log removal: "Removed deleted file from cache: {file_path}"
    - **Expired Entry Cleanup** (optional, run at end of Step 3):
      - Scan all cache entries for TTL expiration
      - Remove entries where: current_timestamp > cached_at + (ttl_hours * 3600)
      - Log cleanup: "Removed {count} expired cache entries"
      - Update cache size metrics after cleanup
- Wrap file contents in markdown code blocks with language tags (detect from extension)
- Include file path as heading (e.g., `### src/api/users.ts`)
- For very large files (>1000 lines), include first 500 and last 500 lines with note
- For deleted files, add note: "~~{file-path}~~ (deleted)"
- **Performance Tracking**:
  - Log cache hit rate at end of export: `Cache Hit Rate: {hits}/{total} ({percentage}%)`
  - Track time saved by caching: estimate as `(cache_hits * avg_file_read_time_ms)`
  - Track parallel processing metrics:
    - `total_batches`: Number of batches processed
    - `avg_batch_size`: Average files per batch
    - `parallel_speedup_factor`: Estimated speedup from parallel processing (typically 3-5x)
    - `sequential_estimate_ms`: Estimated time if processed sequentially
    - `actual_duration_ms`: Actual time taken with parallel processing
  - Update `performance_metrics` section in `performance_cache.json` with parallel processing statistics

### Step 5: Create Index
- Count files by language/type
- Calculate total lines of code
- List dependencies (from package.json, requirements.txt, etc. if detectable)
- Create summary statistics
- **Incremental Mode**: Include change summary (added, modified, deleted counts)

### Step 6: Save Output
- Generate timestamp in ISO 8601 format: `YYYY-MM-DDTHH:mm:ssZ`
- Get current git commit hash: `git rev-parse HEAD`
- Save to `context/prime-{timestamp}.md`
- **Incremental Mode**: Include reference to previous export and change summary
- Update `context/INDEX.md` with new entry:
  - Link to new prime export
  - Timestamp
  - File count and line count summary
  - Export mode (full/incremental)
  - Cache hit rate percentage
- Save state to `context/.prime-state.json`:
  - `last_export_commit`: current git commit hash
  - `last_export_timestamp`: ISO timestamp
  - `last_export_file`: filename of this export
  - `total_files`: file count
  - `export_mode`: "full" or "incremental"
  - `file_hashes`: map of file paths to SHA-256 hashes for change detection
- Update `performance_cache.json`:
  - Store all file hashes in `file_hashes` section
  - Update `index_metadata` with current export timestamp and file counts
  - Track performance metrics (duration, cache hits/misses, cache_hit_rate)
  - Clean up expired cache entries (optional: remove entries where TTL expired)
  - Persist current file contents to `file_cache` for future runs
- **Cache Management**:
  - TTL Configuration:
    - Default TTL: 24 hours
    - Environment variable: `CACHE_TTL_HOURS` (optional, overrides default)
    - Per-entry TTL: Stored with each cache entry for flexibility
  - Cache Size Management:
    - Monitor total cache size (target: < 100MB for file cache)
    - If cache exceeds limit, remove least recently used (LRU) entries
    - Log cache cleanup actions
  - Cache Validation:
    - Before using cached content, verify hash matches current file hash
    - If hash mismatch, treat as cache miss and re-read file
    - Update cache with new content and hash
  - **Cache Invalidation Metrics**:
    - Track invalidation counts by reason:
      - `invalidated_hash_change`: Files with modified content (hash differs)
      - `invalidated_ttl_expired`: Files with expired TTL
      - `invalidated_deleted`: Files deleted from codebase
      - `cache_entries_valid`: Files with unchanged hashes and valid TTL
      - `cache_entries_total`: Total cache entries after cleanup
      - `cache_size_bytes`: Total cache size after invalidation updates
    - Log invalidation summary: "Cache Invalidation: {hash_change} hash changes, {ttl_expired} TTL expired, {deleted} deleted"
    - Update performance_metrics section with invalidation statistics

## Output Format

**Full Export:**
```markdown
# Codebase Export: {timestamp}

## Export Mode
- Type: Full
- Commit: {git_commit_hash}

## Project Tree
```
{tree structure}
```

## Files

### {file-path}
```{language}
{file contents}
```

## Index
- Total Files: {count}
- Total Lines: {count}
- Languages: {list}
- Dependencies: {list if detectable}
```

**Incremental Export:**
```markdown
# Codebase Export: {timestamp}

## Export Mode
- Type: Incremental
- Previous Export: {previous_export_filename}
- Previous Commit: {previous_commit_hash}
- Current Commit: {current_commit_hash}

## Changes Summary
- Added: {count}
- Modified: {count}
- Deleted: {count}
- Total Changed: {count}

## Changed Files

### {file-path} (added)
```{language}
{file contents}
```

### {file-path} (modified)
```{language}
{file contents}
```

~~### {file-path} (deleted)~~

## Index
- Total Files: {count}
- Total Lines: {count}
- Languages: {list}
```

## Error Handling

- **File Read Errors**: Skip files that cannot be read, log error but continue processing
- **Large Files**: Skip files > 10MB, log warning
- **Binary Files**: Skip binary files, log info
- **Partial Export**: If some files fail, generate partial export with error summary at end
- **Git Errors**: If git is unavailable, fall back to directory traversal in full export mode
- **State File Corruption**: If `.prime-state.json` is invalid, log warning and fall back to full export
- **Incremental Detection Failure**: If git diff fails, log warning and perform full export instead
- **No Changes**: If incremental mode detects no changes, exit with message and exit code 0
- **Cache Corruption**: If `performance_cache.json` is invalid or corrupted, log warning and rebuild cache from scratch
- **Cache Invalidation Errors**: If cache invalidation fails for a specific file, log error and continue (mark file as cache miss)
- **Hash Mismatch Detected**: If cached file hash doesn't match current file hash, invalidate cache entry and re-read file
- **Cache Size Limit Exceeded**: If cache size exceeds 100MB after invalidation cleanup, perform LRU eviction to free space

## State File Format (`.prime-state.json`)

```json
{
  "last_export_commit": "abc123def456...",
  "last_export_timestamp": "2025-01-27T10:30:00Z",
  "last_export_file": "prime-2025-01-27T10:30:00Z.md",
  "total_files": 1250,
  "export_mode": "full",
  "file_hashes": {
    "src/index.ts": "a1b2c3d4e5f6...",
    "README.md": "f6e5d4c3b2a1...",
    "package.json": "1234567890ab..."
  },
  "relevance_summary": {
    "high_relevance": 350,
    "medium_relevance": 600,
    "low_relevance": 300,
    "average_score": 55.5
  },
  "previous_exports": [
    {
      "commit": "def456abc123...",
      "timestamp": "2025-01-26T15:20:00Z",
      "file": "prime-2025-01-26T15:20:00Z.md"
    }
  ]
}
```

## Performance Cache Format (`performance_cache.json`)

The performance cache stores file contents to avoid redundant disk reads on subsequent exports, plus relevance scores for selective context loading.

```json
{
  "version": "1.0.0",
  "created_at": "2026-01-27T00:00:00Z",
  "updated_at": "2026-01-27T10:30:00Z",
  "metadata": {
    "cache_type": "performance",
    "description": "Performance optimization cache for markdown workflow system"
  },
  "file_cache": {
    "src/index.ts": {
      "content": "export function main() {\n  console.log('Hello');\n}",
      "hash": "a1b2c3d4e5f6...",
      "cached_at": "2026-01-27T10:30:00Z",
      "ttl_hours": 24,
      "size_bytes": 45
    },
    "README.md": {
      "content": "# My Project\n...",
      "hash": "f6e5d4c3b2a1...",
      "cached_at": "2026-01-27T10:30:00Z",
      "ttl_hours": 24,
      "size_bytes": 1234
    }
  },
  "file_hashes": {
    "src/index.ts": "a1b2c3d4e5f6...",
    "README.md": "f6e5d4c3b2a1...",
    "package.json": "1234567890ab..."
  },
  "relevance_scores": {
    "src/index.ts": {
      "score": 85,
      "recency_score": 30,
      "file_type_score": 25,
      "frequency_score": 20,
      "path_score": 20,
      "last_calculated": "2026-01-27T10:30:00Z"
    },
    "README.md": {
      "score": 38,
      "recency_score": 10,
      "file_type_score": 10,
      "frequency_score": 8,
      "path_score": 10,
      "last_calculated": "2026-01-27T10:30:00Z"
    }
  },
  "index_metadata": {
    "last_index": "2026-01-27T10:30:00Z",
    "total_files": 1250,
    "indexed_files": 1250,
    "cache_size_bytes": 5242880,
    "cache_hit_rate": 0.85
  },
  "performance_metrics": {
    "last_prime_duration_ms": 45230,
    "cache_hits": 1062,
    "cache_misses": 188,
    "cache_hit_rate": 0.85,
    "avg_file_read_time_ms": 15,
    "time_saved_by_cache_ms": 15930,
    "parallel_processing": {
      "total_batches": 25,
      "avg_batch_size": 50,
      "parallel_speedup_factor": 4.2,
      "sequential_estimate_ms": 189966,
      "actual_duration_ms": 45230
    }
  }
}
```

**Cache Entry Structure:**
- `content`: Full file content (truncated for display in example)
- `hash`: SHA-256 hash of file content for validation
- `cached_at`: ISO timestamp when content was cached
- `ttl_hours`: Time-to-live in hours (default: 24)
- `size_bytes`: Size of cached content in bytes

**Cache Invalidation:**
- Hash-based: If file hash changes, cache entry is invalidated
- TTL-based: If `current_time > cached_at + ttl_hours`, cache entry expires
- Manual: Delete `performance_cache.json` to clear all cached data

## Notes

- This command should complete in < 5 minutes for codebases with ~10K files (full export)
- **Parallel Processing**: Files are processed in batches of 20-50 concurrently, providing 3-5x speedup over sequential processing
- **Incremental Performance**: Incremental exports typically complete in < 30 seconds for < 100 changed files
- **Cache Performance**: With 80%+ cache hit rate, incremental exports can complete in < 10 seconds
- **Relevance Scoring**: Files are scored 0-100 based on recency, type, modification frequency, and path importance. High-relevance files (>70 points) should be prioritized for context loading in subsequent phases (task-planning, execution)
- **Score Interpretation**:
  - **High Relevance (>70)**: Recently modified core source files in important directories - prioritize for immediate context loading
  - **Medium Relevance (40-70)**: Standard source files, config files, or less recently modified code - load after high-relevance files
  - **Low Relevance (<40)**: Documentation, test files, or rarely modified files - load on-demand or selectively based on task needs
- Large codebases may take longer; consider excluding test files or vendor directories
- The prime export is used as input for Discovery, Task Planning, and other phases
- **Force Full Export**: Delete `context/.prime-state.json` to force a full export
- **Clear Cache**: Delete `performance_cache.json` to clear all cached file contents (forces re-read)
- **Clear Relevance Scores**: Delete `relevance_scores` section from `performance_cache.json` to force re-scoring (uses last_calculated TTL)
- **Cache TTL**: Default 24 hours, configurable via `CACHE_TTL_HOURS` environment variable
- **Relevance Cache TTL**: Default 24 hours, configurable via `RELEVANCE_CACHE_TTL_HOURS` environment variable
- **Cache Size**: File cache targets < 100MB; LRU eviction when limit exceeded
- **Git History**: Requires git history to detect changes and modification frequency; shallow clones may have limited history
- **Branch Switching**: When switching branches, compare commits carefully - may need full export if branches diverged significantly
- **File Hash Tracking**: SHA-256 hashes provide content-based change detection that works even when git metadata is unavailable or unreliable. Hashes are stored in both `.prime-state.json` and `performance_cache.json` for redundancy and cross-tool compatibility
- **Cache Validation**: Before using cached content, always verify hash matches current file to detect stale cache entries
- **Selective Context Loading**: Task planning and execution phases should use relevance scores to prioritize file loading, starting with high-relevance files and loading lower-relevance files on-demand
