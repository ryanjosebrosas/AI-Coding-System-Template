---
name: Prime
description: "Export entire codebase for context gathering with structured markdown output"
phase: prime
dependencies: []
outputs:
  - path: "context/prime-{timestamp}.md"
    description: "Structured markdown export of codebase"
  - path: "context/INDEX.md"
    description: "Index of all prime exports"
inputs: []
---

# Prime Command

## Purpose

Export the entire codebase for context gathering. This command traverses the project directory, respects ignore patterns, and generates a structured markdown export with tree structure and file contents. This provides comprehensive context for AI assistants to understand the codebase structure, patterns, and conventions.

## Execution Steps

### Step 1: Traverse Codebase
- Use Git to get list of tracked files: `git ls-files`
- Respect `.gitignore` and `.cursorignore` patterns
- Skip binary files (detect by extension: .png, .jpg, .gif, .pdf, .zip, etc.)
- Skip files larger than 10MB (log skipped files)
- Skip node_modules, .git, .venv, and other common ignore patterns

### Step 2: Generate Tree Structure
- Use `tree` command or custom traversal to generate directory structure
- Format as markdown code block with proper indentation
- Include file counts per directory

### Step 3: Export File Contents
- Read each file sequentially
- Wrap file contents in markdown code blocks with language tags (detect from extension)
- Include file path as heading (e.g., `### src/api/users.ts`)
- For very large files (>1000 lines), include first 500 and last 500 lines with note

### Step 4: Create Index
- Count files by language/type
- Calculate total lines of code
- List dependencies (from package.json, requirements.txt, etc. if detectable)
- Create summary statistics

### Step 5: Save Output
- Generate timestamp in ISO 8601 format: `YYYY-MM-DDTHH:mm:ssZ`
- Save to `context/prime-{timestamp}.md`
- Update `context/INDEX.md` with new entry:
  - Link to new prime export
  - Timestamp
  - File count and line count summary

## Output Format

```markdown
# Codebase Export: {timestamp}

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

## Error Handling

- **File Read Errors**: Skip files that cannot be read, log error but continue processing
- **Large Files**: Skip files > 10MB, log warning
- **Binary Files**: Skip binary files, log info
- **Partial Export**: If some files fail, generate partial export with error summary at end
- **Git Errors**: If git is unavailable, fall back to directory traversal

## Notes

- This command should complete in < 5 minutes for codebases with ~10K files
- Large codebases may take longer; consider excluding test files or vendor directories
- The prime export is used as input for Discovery, Task Planning, and other phases
