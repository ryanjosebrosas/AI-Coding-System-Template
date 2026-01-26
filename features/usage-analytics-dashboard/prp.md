# PRP: Usage Analytics Dashboard

**Version**: 1.0 | **Last Updated**: 2026-01-26 | **Related**: MVP.md, PRD.md, TECH-SPEC.md

## Goal

### Feature Goal
Build a usage analytics dashboard with `/analytics` command that queries Archon MCP, Supabase, and local data sources to display token usage, time savings, feature usage, and productivity metrics, helping users understand value and identify optimization opportunities.

### Deliverable
- SQL migration: `013_add_usage_metrics.sql` (created)
- Command: `.claude/commands/analytics.md` (created)
- Documentation: `features/usage-analytics-dashboard/prp.md` (this file)
- Documentation: `features/usage-analytics-dashboard/STATUS.md`
- Updated: `CLAUDE.md` with /analytics command documentation
- Updated: `INDEX.md` with /analytics command in command list

### Success Criteria
- `/analytics` displays comprehensive dashboard with task, project, token, time, and productivity metrics
- Time savings calculated from task duration vs manual effort estimates
- Reference library statistics aggregated from Supabase
- Data export generates CSV/JSON files in `features/usage-analytics-dashboard/exports/`
- Dashboard handles missing data gracefully (partial display with warnings)

## All Needed Context

### Documentation URLs
- Supabase SQL reference: https://supabase.com/docs/guides/database
- Archon MCP API: See `mcps/user-archon/tools/*.json`
- Markdown table formatting: https://www.markdownguide.org/extended-syntax/#tables

### Codebase Patterns
- Commands use YAML frontmatter + markdown body with Purpose, Prerequisites, Execution Steps, Output Format, Error Handling, Examples, Notes, Validation sections
- Commands define inputs, outputs, dependencies, phase
- Existing commands: `.claude/commands/*.md`
- Similar pattern: `.claude/commands/learn-health.md` (queries Supabase for stats, displays formatted report)

### File References
- Command template: `.claude/commands/template.md`
- Similar command: `.claude/commands/learn-health.md`
- Task execution pattern: `.claude/commands/execution.md`
- Migration pattern: `Archon MCP/migration/012_add_smart_reference_library.sql`
- Analytics command: `.claude/commands/analytics.md` (created)

### Naming Conventions
- Commands: lowercase with hyphens (e.g., `analytics.md`)
- Supabase tables: `archon_` prefix (e.g., `archon_usage_metrics`)
- Indexes: `idx_archon_usage_metrics_{column}`
- Export files: `analytics-{YYYY-MM-DD}.{csv|json}`

### Architecture Patterns
- Passive tracking: Query existing data sources rather than active instrumentation
- Direct SQL via Supabase (not Archon MCP documents)
- Archon MCP queries: `find_tasks()`, `find_projects()`, `health_check()`
- Markdown output with tables, metrics, visual indicators
- Export to CSV/JSON for external analysis

## Implementation Blueprint

### Data Models

**archon_usage_metrics table** (already defined in migration):
```sql
- id: UUID PRIMARY KEY
- metric_type: TEXT NOT NULL (token_usage, command_execution, time_tracked, task_created, task_completed)
- metric_name: TEXT (command name, task ID, etc.)
- metric_value: NUMERIC NOT NULL
- recorded_at: TIMESTAMPTZ NOT NULL DEFAULT NOW()
- created_at: TIMESTAMPTZ DEFAULT NOW()
```

**Indexes for performance**:
```sql
- idx_archon_usage_metrics_type: metric_type
- idx_archon_usage_metrics_recorded_at: recorded_at
- idx_archon_usage_metrics_type_recorded_at: (metric_type, recorded_at)
```

**Note**: Usage metrics table is optional for MVP - dashboard displays "tracking not enabled" if empty. Future enhancement: Add per-command token tracking to populate table.

### Implementation Tasks

| Order | Task | Dependencies | Estimate |
|-------|------|--------------|----------|
| 1 | Create SQL migration | None | 30 min |
| 2 | Run SQL migration in Supabase | Migration created | 15 min |
| 3 | Create /analytics command structure | None | 30 min |
| 4 | Implement data collection (Archon MCP) | Command structure | 1 hour |
| 5 | Implement data collection (Supabase) | Command structure | 45 min |
| 6 | Implement metrics calculation | Data collection | 1 hour |
| 7 | Implement dashboard display | Metrics calculation | 45 min |
| 8 | Implement export functionality | Dashboard display | 30 min |
| 9 | Create PRP document | All above | 30 min |
| 10 | Update CLAUDE.md | Command done | 15 min |
| 11 | Update INDEX.md | Command done | 5 min |
| 12 | Test command execution | All above | 30 min |
| 13 | Test export functionality | All above | 15 min |

### File Structure

```
.claude/commands/
├── analytics.md          # Created

features/usage-analytics-dashboard/
├── prp.md                # This file
├── STATUS.md             # Progress tracking
└── exports/              # Auto-generated
    ├── analytics-2026-01-26.csv
    └── analytics-2026-01-26.json

Archon MCP/migration/
└── 013_add_usage_metrics.sql  # Created
```

### Integration Points

**Archon MCP**:
- `find_tasks(filter_by="status", filter_value="done")` for completion statistics
- `find_tasks()` for all tasks and duration calculations
- `find_projects()` for project metrics
- `health_check()` for availability verification

**Supabase Direct SQL**:
- `SELECT COUNT(*), GROUP BY category` from `archon_references` for library stats
- `SELECT metric_type, metric_value, recorded_at` from `archon_usage_metrics` for usage trends
- Connection error handling with graceful degradation

**Local Files**:
- Export directory: `features/usage-analytics-dashboard/exports/`
- STATUS.md files for feature progress (future enhancement)

## Validation Loop

### Syntax Validation
- YAML frontmatter valid in analytics.md command file
- SQL migration runs without errors
- Markdown formatting correct with proper table syntax

### Unit Tests
- SQL: Insert/query usage metrics manually in Supabase
- Commands: Verify YAML parsing works
- Metrics calculation: Test with sample data

### Integration Tests
- `/analytics`: Full flow from data query to dashboard display
- Export: Verify CSV/JSON files created with correct data
- Error handling: Test with Archon MCP unavailable, Supabase disconnected

### End-to-End Tests
1. Run migration in Supabase (or verify table exists)
2. Execute `/analytics`
3. Verify dashboard displays with all sections
4. Execute `/analytics --export`
5. Verify export files exist and contain data
6. Verify CLAUDE.md and INDEX.md updated

## Anti-Patterns

### General Anti-Patterns
- Active instrumentation (adding tracking code throughout codebase) - use passive queries instead
- Storing raw telemetry data - calculate and store aggregated metrics only
- Breaking when data sources unavailable - display partial dashboard with warnings
- Complex visualizations - use simple markdown tables and text indicators
- Hardcoded file paths - use relative paths from working directory

### Feature-Specific Anti-Patterns
- Calculating time savings without task duration data - use default estimate if missing
- Displaying zero-token metrics as error - show "tracking not enabled" message instead
- Trend calculation without historical data - use "→" indicator and "N/A" for change
- Export files in wrong location - always use `features/usage-analytics-dashboard/exports/`
- SQL injection in queries - use parameterized queries or properly escaped values
- Blocking on empty usage_metrics table - handle gracefully with zero values
- Assuming all tasks have duration - check for null/missing timestamps
- Division by zero in rate calculations - always check denominator > 0
- Negatives in time savings - clamp to 0, don't penalize for long tasks

### Data Collection Anti-Patterns
- Querying Archon MCP for every metric - batch queries and cache results
- Running SQL queries sequentially - combine when possible, handle failures independently
- Assuming all data sources available - check health first, degrade gracefully
- Not handling query timeouts - set reasonable timeouts, retry once, then proceed
- Parsing MCP responses without validation - check for malformed/missing fields

### Display Anti-Patterns
- Showing empty sections when data unavailable - skip section or show "No data" message
- Trend arrows without baseline - use "→" for no previous period data
- Cluttered dashboard with too many metrics - focus on actionable insights
- Missing visual indicators - use bars [████░░░], arrows ↑↓, ✓✗ for clarity
- No timestamp on dashboard - always show when data was generated
