---
name: update-index
description: Update INDEX.md file with new file entry or regenerate from directory contents
phase: utility
inputs:
  - directory: Directory path containing INDEX.md (e.g., "context", "discovery", "features")
  - filename: Name of file to add (optional if regenerating)
  - description: Description of file (optional, auto-extracted if not provided)
  - timestamp: ISO 8601 timestamp (optional, defaults to current time)
  - is_directory: True if adding a subdirectory (for features/)
  - regenerate: If true, regenerate entire INDEX.md from directory contents
outputs:
  - Updated INDEX.md file with new entry
dependencies:
  - Directory must exist
  - INDEX.md may or may not exist (will create if missing)
---

# Update INDEX Command

## Purpose

Update or create INDEX.md files with file entries for navigation and tracking across the AI Coding Workflow System.

**When to use**: After creating any new file in the workflow system (Prime exports, Discovery documents, PRDs, PRPs, execution logs, reviews, test results).

## Workflow Integration

This command is auto-called as the final step in other workflow commands to ensure INDEX.md stays synchronized.

**Auto-Trigger Pattern**:
1. Create primary output file
2. Extract metadata (timestamp, description)
3. Call update-index with parameters
4. Continue with next workflow step

**Expected Calls by Command**:
| Command | When Called | Parameters |
|---------|-------------|------------|
| `/prime` | After saving context export | directory="context", filename="prime-{ts}.md" |
| `/discovery` | After saving discovery doc | directory="discovery", filename="discovery-{ts}.md" |
| `/planning` | After creating feature directory | directory="features", filename="{feature}", is_directory=true |
| `/execution` | After creating execution log | directory="execution", regenerate=true |
| `/review` | After saving review report | directory="reviews", filename="review-{ts}.md" |
| `/test` | After saving test results | directory="testing", filename="test-results-{ts}.md" |

## Execution Steps

### Step 1: Determine Parameters

Extract: `directory`, `filename`, `description`, `timestamp`, `is_directory`, `regenerate`

### Step 2: Read Existing INDEX.md

If `regenerate` is false:
1. Check if `{directory}/INDEX.md` exists
2. If exists, read and parse entries
3. Check if filename already in index

### Step 3: Generate File Entry

```markdown
### {filename}
- **Created**: {timestamp}
- **Description**: {description}
- **Link**: [{filename}](./{filename})
```

For feature directories:
```markdown
### {feature-name}
- **Status**: {current_phase}
- **Description**: {description}
- **Link**: [{feature-name}/](./{feature-name}/)
- **Artifacts**: {list}
```

### Step 4: Auto-Detection Scan (regenerate=true)

**Scan patterns by directory**:

| Directory | Pattern | Example | Timestamp Source | Sort |
|-----------|---------|---------|------------------|------|
| `context/` | `prime-*.md` | `prime-2026-01-23T14:30:00Z.md` | Filename | Newest |
| `discovery/` | `discovery-*.md` | `discovery-*.md` | Filename | Newest |
| `features/` | Subdirectories | `{feature}/` | STATUS.md or mtime | Newest |
| `reviews/` | `review-*.md` | `review-*.md` | Filename | Newest |
| `testing/` | `test-results-*.md` | `test-results-*.md` | Filename | Newest |
| `execution/` | `{number}-*.md` | `01-*.md` | Filename prefix | Ascending |
| `templates/` | All files | Various | Alphabetical | A-Z |

**Comparison logic**:
- New files (in dir, not in INDEX) → Add
- Missing files (in INDEX, not in dir) → Flag
- Updated files (timestamps differ) → Update
- Unchanged (timestamps match) → Skip

### Step 5: Update INDEX.md

If `regenerate` is false: Insert new entry chronologically (newest first)

If `regenerate` is true:
1. Use scan results
2. Extract metadata from each file
3. Generate complete INDEX.md
4. Include detection report

### Step 6: Handle Edge Cases

- INDEX.md missing → Create with template
- File already indexed → Update or skip if unchanged
- Empty directory → Create with "No files yet"
- Corrupted INDEX.md → Backup and regenerate

## Output Format

### context/INDEX.md Template

```markdown
# Context Index

## Overview
Codebase context exports from Prime command. Each export is a complete snapshot.

## Files

### prime-2026-01-24T17-34-57Z.md
- **Created**: 2026-01-24T17:34:57Z
- **Description**: Complete codebase export
- **File Count**: 74 files
- **Link**: [View Export](./prime-2026-01-24T17-34-57Z.md)

## Navigation
- [Back to Root](../)
```

### discovery/INDEX.md Template

```markdown
# Discovery Index

## Overview
Discovery phase outputs exploring ideas and opportunities.

## Files

### discovery-2026-01-23T15:00:00Z.md
- **Created**: 2026-01-23T15:00:00Z
- **Description**: Discovery document
- **Link**: [View](./discovery-2026-01-23T15:00:00Z.md)

## Navigation
- [Back to Root](../)
```

### features/INDEX.md Template

```markdown
# Features Index

## Overview
Feature-specific artifacts organized by feature name.

## Features

### smart-reference-library
- **Status**: Execution Completed
- **Description**: Token-efficient reference library
- **Phase**: Ready for Review & Test
- **Artifacts**: [PRP](./smart-reference-library/prp.md), [Task Plan](./smart-reference-library/task-plan.md)
- **Archon Project ID**: `acf45b67-...`

## Navigation
- [Back to Root](../)
```

### reviews/INDEX.md Template

```markdown
# Reviews Index

## Overview
Code review reports analyzing quality, security, performance.

## Files

### review-2026-01-23T20:00:00Z.md
- **Created**: 2026-01-23T20:00:00Z
- **Description**: Code review for {feature}
- **Link**: [View](./review-2026-01-23T20:00:00Z.md)
```

### testing/INDEX.md Template

```markdown
# Testing Index

## Overview
Test execution results with outcomes and coverage analysis.

## Files

### test-results-2026-01-23T21:00:00Z.md
- **Created**: 2026-01-23T21:00:00Z
- **Description**: Test results for {feature}
- **Link**: [View](./test-results-2026-01-23T21:00:00Z.md)
```

### execution/INDEX.md Template

```markdown
# Execution Directory

Task execution documents linked to Archon MCP tasks.

## Tasks

| # | Task | Status | Description |
|---|------|--------|-------------|
| 01 | [Create Directory Structure](01-create-directory-structure.md) | Done | Create project structure |
| 28 | [Deployment Handoff](28-system-deployment-handoff.md) | Done | Final deployment |

## Links
- [../INDEX.md](../INDEX.md) - Root index
```

## Error Handling

| Error | Recovery |
|-------|----------|
| INDEX.md missing | Create with template |
| Directory missing | Create directory first |
| File already indexed | Update if modified, skip if unchanged |
| INDEX.md corrupted | Backup and regenerate |

## Usage Examples

**Add Prime export**:
```
/update-index directory="context" filename="prime-2026-01-23T14:30:00Z.md"
```

**Add feature directory**:
```
/update-index directory="features" filename="ai-coding-workflow-system" is_directory=true
```

**Regenerate entire INDEX.md**:
```
/update-index directory="context" regenerate=true
```

## Validation

- [ ] File created/updated successfully
- [ ] Entry in correct location
- [ ] Markdown formatting correct
- [ ] Navigation links valid
- [ ] Timestamp in ISO 8601 format

## Reference Tables

**Metadata Fields by Directory**:

| Directory | Required | Optional | Data Source |
|-----------|----------|----------|-------------|
| `context/` | Created, Description, Link | File Count, Total Lines | Filename, content |
| `discovery/` | Created, Description, Link | Feature Name | Filename, frontmatter |
| `features/` | Status, Description, Phase | Artifacts, Project ID | STATUS.md |
| `reviews/` | Created, Description, Link | Feature Name | Filename, frontmatter |
| `testing/` | Created, Description, Link | Feature Name | Filename, frontmatter |
| `execution/` | #, Task, Status | Task ID | Filename, metadata |
| `templates/` | Category, Link | Description | Filesystem |

**Timestamp Extraction Patterns**:

| Pattern | Regex | Example | Extracted |
|---------|-------|---------|-----------|
| `prime-{ts}.md` | `prime-(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)\.md` | `prime-2026-01-23T14:30:00Z.md` | `2026-01-23T14:30:00Z` |
| `{number}-{name}.md` | `^(\d{2})-(.+)\.md$` | `01-create.md` | `01` |

**Default Descriptions**:

| File Type | Default Description |
|-----------|---------------------|
| `prime-*.md` | "Complete codebase export from Prime command" |
| `discovery-*.md` | "Discovery document with ideas, inspiration, needs" |
| `review-*.md` | "Code review for feature {feature-name}" |
| `test-results-*.md` | "Test results for feature {feature-name}" |
| Templates | Descriptive title based on filename |

## Notes

- Use ISO 8601 timestamps: YYYY-MM-DDTHH:mm:ssZ
- Sort newest first (except templates/ which is alphabetical)
- Use relative paths for links
- Extract description from frontmatter when possible
- Auto-detection ensures synchronization
- Missing files are flagged for manual review
