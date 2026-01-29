---
name: learn-health
description: "Check reference library health and statistics"
user-invocable: true
disable-model-invocation: false
---

# Learn Health Skill

Check reference library health and display statistics.

## Checks Performed

1. **Library Exists** - Verify `.claude/reference/` directory
2. **Index Valid** - Check INDEX.md is current
3. **Topics Count** - Number of saved topics
4. **Sources Count** - Number of source references
5. **Staleness** - Topics not updated in 30+ days
6. **Orphans** - Files not in index

## Health Report

```
Reference Library Health
========================

Status: Healthy ✓

Topics: 24
Sources: 47
Last Updated: 2026-01-29

Stale Topics (>30 days):
- react-hooks.md (45 days)
- postgresql-indexing.md (32 days)

Orphaned Files: None

Recommendations:
- Consider refreshing stale topics
```

## Output

- Health status (Healthy/Warning/Error)
- Statistics summary
- Recommendations for maintenance

## Usage

```
/learn-health
```

## Reference

Full implementation details: `.claude/commands/learn-health.md`
