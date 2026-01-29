---
name: review
description: "AI-powered code review with quality analysis"
user-invocable: true
disable-model-invocation: false
---

# Review Skill

AI-powered code review with quality, security, and performance analysis.

## Execution Flow

1. **Identify Changes** - Get files from git diff or specified path
2. **Analyze Code** - Quality, security, performance
3. **Generate Report** - Issues, suggestions, scores
4. **Present Findings** - Categorized by severity

## Review Categories

| Category | Focus |
|----------|-------|
| Quality | Code style, readability, maintainability |
| Security | OWASP top 10, input validation, auth |
| Performance | Efficiency, memory, complexity |
| Architecture | Patterns, SOLID, separation |

## Severity Levels

- **Critical** - Must fix before merge
- **High** - Should fix
- **Medium** - Consider fixing
- **Low** - Nice to have

## Output

- Review report with issues and suggestions
- Quality scores by category
- Summary with action items

## Usage

```
/review                    # Review uncommitted changes
/review path/to/file.ts    # Review specific file
/review --staged           # Review staged changes
```

## Reference

Full implementation details: `.claude/commands/review.md`
