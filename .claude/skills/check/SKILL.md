---
name: check
description: "Codebase health check and cleanup"
user-invocable: true
disable-model-invocation: false
---

# Check Skill

Comprehensive codebase health check, cleanup, and documentation updates.

## Checks Performed

### Required Files
- `.gitignore` - Git ignore patterns
- `LICENSE` - License file
- `README.md` - Project documentation
- `CLAUDE.md` - Developer guidelines
- `INDEX.md` - Navigation index

### Artifacts to Clean
- `nul` - Windows artifact
- `.DS_Store` - macOS artifact
- `*.tmp`, `*.temp` - Temporary files
- Old `context/prime-*.md` - Keep latest 2-3

### Documentation Sync
- `INDEX.md` matches actual commands
- `features/INDEX.md` matches feature statuses
- STATUS.md files are current

## Auto-Fixes

1. Create missing `.gitignore` with standard patterns
2. Create missing `LICENSE` (MIT default)
3. Delete artifact files
4. Update outdated INDEX.md entries
5. Sync documentation with actual state

## Health Score

- Required Files: X/Y present
- Documentation: X/Y up-to-date
- Artifacts: X found and cleaned
- Overall: percentage%

## Output

- Health report with issues and fixes
- Prompt to commit changes (if any)
- Summary of actions taken

## Usage

```
/check
```

## Reference

Full implementation details: `.claude/commands/check.md`
