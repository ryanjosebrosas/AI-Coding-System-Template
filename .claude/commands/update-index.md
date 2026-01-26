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

Update or create INDEX.md files with file entries to provide navigation and tracking across the AI Coding Workflow System.

## When to Use

Use this command after creating any new file in the workflow system:
- After Prime command creates `context/prime-{timestamp}.md`
- After Discovery command creates `discovery/discovery-{timestamp}.md`
- After Planning command creates `features/{feature-name}/` directory
- After Review command creates `reviews/review-{timestamp}.md`
- After Test command creates `testing/test-results-{timestamp}.md`

## Execution Steps

### Step 1: Determine Parameters

Extract parameters from command context:
- `directory`: The directory being updated
- `filename`: The file or subdirectory being added
- `description`: Optional description (extract from file if not provided)
- `timestamp`: Optional timestamp (extract from filename or use current time)
- `is_directory`: True if adding a feature subdirectory
- `regenerate`: True if regenerating entire INDEX.md

### Step 2: Read Existing INDEX.md

If `regenerate` is false:
1. Check if `{directory}/INDEX.md` exists
2. If exists, read current content
3. Parse existing file entries
4. Check if filename already exists in index

### Step 3: Generate File Entry

Create new file entry in format:

```markdown
### {filename}
- **Created**: {timestamp}
- **Description**: {description}
- **Link**: [{filename}](./{filename})
```

For feature directories (features/):
```markdown
### {feature-name}
- **Created**: {timestamp}
- **Description**: {description}
- **Link**: [{feature-name}/](./{feature-name}/)
- **Status**: {current_phase}
- **Artifacts**: {list_of_artifacts}
```

### Step 4: Update INDEX.md

If `regenerate` is false:
1. Read existing INDEX.md
2. Insert new entry in chronological order (newest first)
3. Preserve overview and navigation sections
4. Write back to file

If `regenerate` is true:
1. Scan directory for all files/subdirectories
2. Extract metadata from each (timestamp from filename or filesystem)
3. Generate complete INDEX.md with all entries
4. Sort by timestamp (newest first, or alphabetical for templates/)

### Step 5: Handle Edge Cases

- **INDEX.md doesn't exist**: Create with template structure
- **File already in index**: Update entry or skip if unchanged
- **Directory is empty**: Create INDEX.md with "No files yet" message
- **Corrupted INDEX.md**: Backup and regenerate

## Output Format

### context/INDEX.md Template

```markdown
# Context Index

## Overview
This directory contains codebase context exports from the Prime command. Each export is a complete snapshot of the codebase at a specific point in time.

## Files

### prime-2026-01-23T14:30:00Z.md
- **Created**: 2026-01-23T14:30:00Z
- **Description**: Codebase export from Prime command
- **Link**: [prime-2026-01-23T14:30:00Z.md](./prime-2026-01-23T14:30:00Z.md)

## Navigation
- [Back to Root](../)
- [Features](../features/)
- [Discovery](../discovery/)
```

### discovery/INDEX.md Template

```markdown
# Discovery Index

## Overview
This directory contains discovery phase outputs. Discovery documents explore ideas, inspiration, and needs for AI agents and AI/ATR applications.

## Files

### discovery-2026-01-23T15:00:00Z.md
- **Created**: 2026-01-23T15:00:00Z
- **Description**: Discovery document with ideas, inspiration, needs, opportunities
- **Link**: [discovery-2026-01-23T15:00:00Z.md](./discovery-2026-01-23T15:00:00Z.md)

## Navigation
- [Back to Root](../)
- [Context](../context/)
- [Features](../features/)
```

### features/INDEX.md Template

```markdown
# Features Index

## Overview
This directory contains all feature-specific artifacts organized by feature name. Each feature has its own subdirectory with PRD, tech spec, PRP, task plans, execution logs, reviews, and test results.

## Features

### ai-coding-workflow-system
- **Created**: 2026-01-23T16:00:00Z
- **Description**: AI Coding Workflow System feature
- **Link**: [ai-coding-workflow-system/](./ai-coding-workflow-system/)
- **Status**: Planning phase
- **Artifacts**: prd.md, tech-spec.md

## Navigation
- [Back to Root](../)
- [Context](../context/)
- [Discovery](../discovery/)
```

### reviews/INDEX.md Template

```markdown
# Reviews Index

## Overview
This directory contains code review reports generated by the Review command. Reviews analyze code quality, security, performance, and compliance with PRD and tech spec.

## Files

### review-2026-01-23T20:00:00Z.md
- **Created**: 2026-01-23T20:00:00Z
- **Description**: Code review for feature ai-coding-workflow-system
- **Link**: [review-2026-01-23T20:00:00Z.md](./review-2026-01-23T20:00:00Z.md)

## Navigation
- [Back to Root](../)
- [Features](../features/)
- [Testing](../testing/)
```

### testing/INDEX.md Template

```markdown
# Testing Index

## Overview
This directory contains test execution results generated by the Test command. Test results include test outcomes, coverage analysis, and AI-suggested fixes.

## Files

### test-results-2026-01-23T21:00:00Z.md
- **Created**: 2026-01-23T21:00:00Z
- **Description**: Test results for feature ai-coding-workflow-system
- **Link**: [test-results-2026-01-23T21:00:00Z.md](./test-results-2026-01-23T21:00:00Z.md)

## Navigation
- [Back to Root](../)
- [Features](../features/)
- [Reviews](../reviews/)
```

## Error Handling

### If INDEX.md doesn't exist
- Create new INDEX.md with appropriate template
- Include overview and navigation sections
- Add first file entry

### If directory doesn't exist
- Create directory first
- Then create INDEX.md
- Report permission errors if unable to create

### If file already in index
- Compare timestamps
- Update entry if file was modified
- Skip if unchanged

### If INDEX.md is corrupted
- Detect corruption (invalid markdown structure)
- Backup existing file to INDEX.md.backup
- Regenerate from directory contents
- Log the recovery action

## Usage Examples

### Adding a Prime export

```
/update-index directory="context" filename="prime-2026-01-23T14:30:00Z.md" description="Codebase export from Prime command" timestamp="2026-01-23T14:30:00Z"
```

### Adding a feature directory

```
/update-index directory="features" filename="ai-coding-workflow-system" description="AI Coding Workflow System feature" is_directory=true status="Planning phase" artifacts="prd.md, tech-spec.md"
```

### Regenerating entire INDEX.md

```
/update-index directory="context" regenerate=true
```

## Validation

After updating INDEX.md:
- [ ] File was created or updated successfully
- [ ] New entry appears in correct location (chronological order)
- [ ] Markdown formatting is correct
- [ ] Navigation links are valid
- [ ] Description is accurate
- [ ] Timestamp is in ISO 8601 format

## Notes

- Use ISO 8601 format for timestamps: YYYY-MM-DDTHH:mm:ssZ
- Sort entries newest first (except templates/ which is alphabetical)
- Use relative paths for navigation links
- Extract description from file frontmatter when possible
- Call this command after any file creation operation
