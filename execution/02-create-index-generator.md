# Task 02: Create INDEX.md Generator

**Priority**: High  
**Dependencies**: Task 01 (Create Directory Structure)  
**Estimate**: 30 minutes  
**Phase**: Foundation

## Overview

Implement an INDEX.md generation utility that automatically creates and updates INDEX.md files in each directory. This utility ensures consistent navigation across all directories and automatically tracks files as they are created.

## Context

From TECH-SPEC.md Data Models section:
- INDEX.md format: `# {Directory} Index\n## Files\n### {filename} - Created: {timestamp} - [{link}](./{filename})`
- INDEX.md files provide navigation across directories
- Auto-update on file creation is required

From PRD.md Feature 10:
- INDEX.md navigation is a High Priority feature
- Required for progress tracking and artifact organization

From MVP.md:
- Transparency: Clear progress tracking and artifact organization
- INDEX.md files enable easy navigation

## Detailed Requirements

### INDEX.md Format Specification

**Structure** (from TECH-SPEC.md):
```markdown
# {Directory Name} Index

## Overview
{Description of directory contents}

## Files

### {filename}
- **Created**: {timestamp}
- **Description**: {description}
- **Link**: [{filename}](./{filename})

## Navigation
- [Back to Root](../../)
- [Features](../features/)
```

### Generator Functionality

1. **Create INDEX.md**
   - Generate INDEX.md with template structure
   - Include directory-specific overview
   - Include navigation links
   - Support empty state (no files yet)

2. **Update INDEX.md**
   - Append new file entries when files are created
   - Maintain chronological order (newest first or oldest first)
   - Update file count
   - Preserve existing entries

3. **File Entry Format**
   - Filename as heading (###)
   - Created timestamp (ISO 8601 format)
   - Description (extracted from file or provided)
   - Link to file (relative path)

4. **Navigation Links**
   - Back to root link
   - Links to related directories
   - Context-aware navigation

## Implementation Approach

### Option 1: Markdown File Utility (Recommended)

Create a utility function/script that:
- Reads directory contents
- Generates/updates INDEX.md
- Can be called from commands
- Handles file metadata extraction

### Option 2: Command Integration

Integrate INDEX.md updates directly into each command:
- Each command updates INDEX.md after creating files
- Consistent update pattern across all commands
- No separate utility needed

**Decision**: Use Option 1 for consistency and reusability.

## Implementation Steps

### Step 1: Design Generator Interface

Define function signature:
```python
def update_index_md(directory_path, file_name, file_description=None, created_timestamp=None):
    """
    Update INDEX.md in specified directory with new file entry.
    
    Args:
        directory_path: Path to directory containing INDEX.md
        file_name: Name of file to add to index
        file_description: Optional description of file
        created_timestamp: Optional timestamp (defaults to current time)
    """
```

### Step 2: Implement INDEX.md Reading

- Read existing INDEX.md if it exists
- Parse markdown structure
- Extract existing file entries
- Preserve overview and navigation sections

### Step 3: Implement File Entry Addition

- Create new file entry with proper format
- Insert entry in appropriate location (chronological order)
- Update file count if present
- Maintain markdown formatting

### Step 4: Implement INDEX.md Writing

- Write updated INDEX.md back to file
- Preserve formatting and structure
- Handle edge cases (empty directory, first file, etc.)

### Step 5: Implement Navigation Links

- Generate context-aware navigation links
- Include back to root link
- Include links to related directories
- Update navigation based on directory type

## Directory-Specific INDEX.md Templates

### context/INDEX.md
```markdown
# Context Index

## Overview
This directory contains codebase context exports from the Prime command. Each export is a complete snapshot of the codebase at a specific point in time, including file tree structure and file contents.

## Files

### prime-2026-01-23T14:30:00Z.md
- **Created**: 2026-01-23T14:30:00Z
- **Description**: Codebase export from Prime command
- **Link**: [prime-2026-01-23T14:30:00Z.md](./prime-2026-01-23T14:30:00Z.md)

## Navigation
- [Back to Root](../)
- [Discovery](../discovery/)
- [Features](../features/)
```

### discovery/INDEX.md
```markdown
# Discovery Index

## Overview
This directory contains discovery phase outputs. Discovery documents explore ideas, inspiration, and needs for AI agents and AI/ATR applications, identifying opportunities and prioritizing features.

## Files

### discovery-2026-01-23T15:00:00Z.md
- **Created**: 2026-01-23T15:00:00Z
- **Description**: Discovery document with ideas, inspiration sources, needs analysis, and opportunities
- **Link**: [discovery-2026-01-23T15:00:00Z.md](./discovery-2026-01-23T15:00:00Z.md)

## Navigation
- [Back to Root](../)
- [Context](../context/)
- [Features](../features/)
```

### features/INDEX.md
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

### templates/INDEX.md
```markdown
# Templates Index

## Overview
This directory contains template files for the AI Coding Workflow System, including PRP (Plan Reference Protocol) templates for codebase-aware implementation guidance.

## Templates

### PRP Templates
- [PRP Base Template](./prp/prp-base.md) - Base template with all standard sections
- [PRP AI Agent Template](./prp/prp-ai-agent.md) - Template for AI agent implementations
- [PRP MCP Integration Template](./prp/prp-mcp-integration.md) - Template for MCP server integrations
- [PRP API Endpoint Template](./prp/prp-api-endpoint.md) - Template for API endpoint implementations
- [PRP Frontend Component Template](./prp/prp-frontend-component.md) - Template for frontend component implementations

## Navigation
- [Back to Root](../)
- [Features](../features/)
```

### reviews/INDEX.md
```markdown
# Reviews Index

## Overview
This directory contains code review reports generated by the Review command. Reviews analyze code quality, security, performance, and compliance with PRD and tech spec.

## Files

### review-2026-01-23T20:00:00Z.md
- **Created**: 2026-01-23T20:00:00Z
- **Description**: Code review for feature ai-coding-workflow-system
- **Link**: [review-2026-01-23T20:00:00Z.md](./review-2026-01-23T20:00:00Z.md)
- **Feature**: ai-coding-workflow-system
- **Severity**: Medium

## Navigation
- [Back to Root](../)
- [Features](../features/)
- [Testing](../testing/)
```

### testing/INDEX.md
```markdown
# Testing Index

## Overview
This directory contains test execution results generated by the Test command. Test results include test outcomes, coverage analysis, and AI-suggested fixes.

## Files

### test-results-2026-01-23T21:00:00Z.md
- **Created**: 2026-01-23T21:00:00Z
- **Description**: Test results for feature ai-coding-workflow-system
- **Link**: [test-results-2026-01-23T21:00:00Z.md](./test-results-2026-01-23T21:00:00Z.md)
- **Feature**: ai-coding-workflow-system
- **Status**: Passed

## Navigation
- [Back to Root](../)
- [Features](../features/)
- [Reviews](../reviews/)
```

## Generator Implementation Details

### File Detection

**Supported file patterns:**
- `prime-{timestamp}.md` in context/
- `discovery-{timestamp}.md` in discovery/
- `review-{timestamp}.md` in reviews/
- `test-results-{timestamp}.md` in testing/
- Feature directories in features/
- Template files in templates/

### Timestamp Extraction

**From filename:**
- Extract ISO 8601 timestamp from filename patterns
- Parse: `YYYY-MM-DDTHH:mm:ssZ`
- Use as created timestamp

**From file metadata:**
- Fallback to file system modification time
- Convert to ISO 8601 format
- Use if timestamp not in filename

### Description Extraction

**Methods:**
1. Extract from file frontmatter (if markdown with YAML frontmatter)
2. Extract from first heading or first paragraph
3. Use default description based on file type
4. Allow manual description override

### Entry Ordering

**Options:**
- Chronological (newest first) - Recommended for most directories
- Chronological (oldest first) - Alternative
- Alphabetical - For templates directory

**Decision**: Use newest first for context/, discovery/, reviews/, testing/. Use alphabetical for templates/.

## Error Handling

**If INDEX.md doesn't exist:**
- Create new INDEX.md with template
- Include overview and navigation
- Add first file entry

**If INDEX.md is corrupted:**
- Detect corruption (invalid markdown, missing sections)
- Backup existing file
- Regenerate INDEX.md from directory contents
- Merge with backup if possible

**If file already exists in index:**
- Check if entry exists
- Update entry if file modified
- Skip if no changes
- Log duplicate detection

**If directory doesn't exist:**
- Create directory first
- Then create INDEX.md
- Handle permission errors

## Integration Points

### Command Integration

Each command that creates files should call the generator:

**Prime Command:**
```python
update_index_md(
    directory_path="context",
    file_name="prime-2026-01-23T14:30:00Z.md",
    file_description="Codebase export from Prime command",
    created_timestamp="2026-01-23T14:30:00Z"
)
```

**Discovery Command:**
```python
update_index_md(
    directory_path="discovery",
    file_name="discovery-2026-01-23T15:00:00Z.md",
    file_description="Discovery document with ideas and opportunities"
)
```

**Planning Command:**
```python
update_index_md(
    directory_path="features",
    file_name="ai-coding-workflow-system",
    file_description="AI Coding Workflow System feature",
    is_directory=True
)
```

### Feature Directory Updates

For feature directories, update both:
1. `features/INDEX.md` - Add feature entry
2. `features/{feature-name}/INDEX.md` - If feature has sub-index (optional)

## Testing Requirements

### Unit Tests

1. **Create INDEX.md**
   - Test creation in empty directory
   - Verify template structure
   - Verify navigation links

2. **Add File Entry**
   - Test adding first file
   - Test adding subsequent files
   - Verify chronological ordering
   - Verify markdown formatting

3. **Update Existing Entry**
   - Test updating file description
   - Test updating timestamp
   - Verify no duplicates

4. **Error Handling**
   - Test missing directory
   - Test corrupted INDEX.md
   - Test permission errors
   - Test invalid file names

### Integration Tests

1. **Command Integration**
   - Test Prime command updates context/INDEX.md
   - Test Discovery command updates discovery/INDEX.md
   - Test Planning command updates features/INDEX.md

2. **Multiple Updates**
   - Test multiple files added sequentially
   - Test concurrent updates (if applicable)
   - Test large number of files

## Performance Considerations

**Optimization:**
- Cache INDEX.md content in memory during command execution
- Batch updates if multiple files created
- Incremental updates (append vs. full rewrite)
- Limit file count in index (pagination if needed)

**Targets:**
- INDEX.md update: <100ms
- Support 1000+ file entries
- Handle concurrent access safely

## Validation Checklist

- [ ] Generator function implemented
- [ ] INDEX.md creation works for all directories
- [ ] File entry addition works correctly
- [ ] Chronological ordering works
- [ ] Navigation links generated correctly
- [ ] Error handling implemented
- [ ] Integration with commands works
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Performance targets met

## Next Steps

After completing this task:
- Proceed to Task 03: Create STATUS.md Format
- INDEX.md generator will be used by all commands
- Commands will call generator after creating files

## References

- **TECH-SPEC.md**: Data Models - INDEX.md Format (lines 100-105)
- **PRD.md**: Feature 10 - Directory Structure & Navigation (lines 107-108)
- **MVP.md**: Architecture Approach - Progress Tracking (line 49)

## Notes

- Generator should be language-agnostic (can be implemented in any language)
- Consider creating as a reusable utility/script
- May need to handle different file types (markdown, directories, etc.)
- Timestamp format must be ISO 8601: YYYY-MM-DDTHH:mm:ssZ
- Navigation links should be relative paths
- Consider adding file size or line count to entries (optional)
