---
name: Analytics
description: "Display usage analytics dashboard showing token usage, time savings, feature usage, and productivity metrics"
phase: independent
dependencies: []
outputs:
  - description: "Analytics dashboard displayed to user"
  - path: "features/usage-analytics-dashboard/exports/analytics-{date}.csv"
    description: "CSV export of analytics data (optional)"
  - path: "features/usage-analytics-dashboard/exports/analytics-{date}.json"
    description: "JSON export of analytics data (optional)"
inputs: []
---

# Analytics Command

## Purpose

Query data sources (Archon MCP, Supabase, local files) and display a comprehensive usage analytics dashboard showing token usage, time savings, feature usage statistics, and productivity metrics.

This command provides transparency into AI-assisted development value and helps identify opportunities for optimization. It addresses the need to understand ROI and track productivity improvements without requiring manual tracking.

**When to use**: Use this command to review your development progress, measure time savings, track feature adoption, or export analytics data for reporting.

**What it solves**: This command addresses the lack of visibility into AI-assisted development value. It automates tracking of productivity metrics that would otherwise require manual effort.

## Prerequisites

- Archon MCP server available (for task/project data)
- Supabase `archon_usage_metrics` table exists (Migration 013)
- Supabase `archon_references` table exists (Migration 012)
- Direct SQL access to Supabase
- Export directory exists: `features/usage-analytics-dashboard/exports/`

## Execution Steps

### Step 1: Query Archon Tasks

**Objective**: Get task completion statistics from Archon MCP.

**Actions**:

1. **Verify Archon MCP availability**:
   - Call `health_check()` to verify server is available
   - If unavailable, display error and fall back to partial dashboard (skip to Step 3)

2. **Query tasks by status**:
   - Execute: `find_tasks(filter_by="status", filter_value="done")`
   - Execute: `find_tasks(filter_by="status", filter_value="review")`
   - Execute: `find_tasks(filter_by="status", filter_value="doing")`
   - Execute: `find_tasks(filter_by="status", filter_value="todo")`
   - Execute: `find_tasks()` (all tasks for total count)

3. **Parse task results**:
   - Extract `task_id`, `title`, `status`, `project_id`, `created_at`, `updated_at` from each task
   - Count tasks by status: `done_count`, `review_count`, `doing_count`, `todo_count`
   - Calculate total: `total_tasks = done_count + review_count + doing_count + todo_count`
   - Group tasks by `project_id` into map: `project_tasks[project_id] = [tasks]`
   - For done tasks, calculate duration: `duration = updated_at - created_at`

4. **Handle query errors**:
   - If `find_tasks()` throws error: Log error message, set task stats to empty, continue to next step
   - If response is malformed: Log parsing error, use partial data if available
   - If timeout occurs: Increase timeout, retry once, then proceed with partial data

**Expected Result**: Task statistics object with structure:
```json
{
  "total_tasks": 55,
  "done_count": 47,
  "review_count": 5,
  "doing_count": 2,
  "todo_count": 1,
  "tasks_by_project": {
    "proj-123": 25,
    "proj-456": 30
  },
  "recent_completions": [
    {
      "task_id": "task-789",
      "title": "Implement feature",
      "project_id": "proj-123",
      "completed_at": "2026-01-26T12:00:00Z",
      "duration_hours": 1.5
    }
  ]
}
```

### Step 2: Query Archon Projects

**Objective**: Get project statistics from Archon MCP.

**Actions**:

1. **Query all projects**:
   - Execute: `find_projects()` (retrieves all projects)
   - If Step 1 failed, verify health with `health_check()` before querying

2. **Parse project results**:
   - Extract `project_id`, `title`, `created_at`, `updated_at` from each project
   - Cross-reference with task data from Step 1:
     - For each project, check `project_tasks[project_id]` map
     - Count tasks in each status: `todo_count`, `doing_count`, `done_count`
   - Determine project status:
     - `active`: Has tasks in todo or doing status
     - `completed`: All tasks are done, no active work
     - `archived`: No recent activity (no tasks updated in 30 days)

3. **Calculate project metrics**:
   - `total_projects`: Count of all projects
   - `active_projects`: Count where project has todo or doing tasks
   - `completed_projects`: Count where all tasks are done
   - `archived_projects`: Count with no recent activity

4. **Handle query errors**:
   - If `find_projects()` throws error: Log error message, set project stats to empty, continue to Step 3
   - If response is missing fields: Use default values, log warning
   - If project has no tasks: Mark as active if created within 7 days, otherwise archived

**Expected Result**: Project statistics object with structure:
```json
{
  "total_projects": 5,
  "active_projects": 3,
  "completed_projects": 1,
  "archived_projects": 1,
  "projects": [
    {
      "project_id": "proj-123",
      "title": "Feature Implementation",
      "task_count": 25,
      "done_count": 20,
      "status": "active",
      "created_at": "2026-01-01T00:00:00Z"
    }
  ]
}
```

### Step 3: Query Supabase References

**Objective**: Get reference library statistics.

**Actions**:
1. Execute SQL query:
   ```sql
   SELECT
     category,
     COUNT(*) as count,
     MAX(updated_at) as last_updated
   FROM archon_references
   GROUP BY category
   ORDER BY category;
   ```
2. Execute total count query:
   ```sql
   SELECT COUNT(*) as total FROM archon_references;
   ```

**Expected Result**: Reference library statistics.

### Step 4: Query Usage Metrics

**Objective**: Get usage metrics from Supabase (if table populated).

**Actions**:
1. Execute SQL query:
   ```sql
   SELECT
     metric_type,
     metric_value,
     recorded_at
   FROM archon_usage_metrics
   WHERE recorded_at >= NOW() - INTERVAL '30 days'
   ORDER BY recorded_at DESC;
   ```
2. Aggregate metrics by type:
   - Token usage (if available)
   - Command executions
   - Time tracked

**Expected Result**: Usage metrics aggregated by type.

### Step 5: Calculate Time Savings

**Objective**: Estimate time saved from AI assistance.

**Actions**:
1. For each completed task:
   - Get task duration: `updated_at - created_at`
   - Estimate manual effort: `task.duration_estimate` or use default (2 hours)
   - Calculate savings: `manual_effort - actual_duration`
2. Aggregate time savings:
   - Total hours saved
   - Average savings per task
   - Hours saved this week
   - Hours saved this month

**Expected Result**: Time savings metrics.

### Step 6: Calculate Productivity Metrics

**Objective**: Compute productivity indicators.

**Actions**:
1. Calculate completion rate:
   - `completion_rate = (done_tasks / total_tasks) * 100`
2. Calculate average task duration:
   - Average of `updated_at - created_at` for done tasks
3. Calculate tasks per week:
   - Count done tasks created in last 7 days
4. Calculate active projects:
   - Count projects with tasks in todo/doing status

**Expected Result**: Productivity metrics object.

### Step 7: Display Dashboard

**Objective**: Present formatted analytics dashboard to user.

**Actions**:
1. Format output as markdown with sections:
   - Overview (key metrics)
   - Task Completion
   - Time Savings
   - Feature Usage
   - Productivity Metrics
   - Recent Activity
2. Use markdown tables for data presentation
3. Add visual indicators (progress bars, trend arrows)
4. Include insights and recommendations

**Expected Result**: Comprehensive analytics dashboard displayed.

### Step 8: Export Data (Optional)

**Objective**: Generate CSV and JSON exports for further analysis.

**Actions**:
1. If export requested, create export directory:
   ```bash
   mkdir -p features/usage-analytics-dashboard/exports/
   ```
2. Generate CSV file:
   - Filename: `analytics-{YYYY-MM-DD}.csv`
   - Format: Comma-separated values with headers
   - Content: All metrics and raw data
3. Generate JSON file:
   - Filename: `analytics-{YYYY-MM-DD}.json`
   - Format: JSON object with all metrics
   - Content: Structured data for programmatic access
4. Display export confirmation with file paths

**Expected Result**: Export files created and paths displayed.

## Output Format

The command displays a comprehensive analytics dashboard:

```markdown
# Usage Analytics Dashboard

Generated: {timestamp}

## Overview

| Metric | Value | Change |
|--------|-------|--------|
| Tasks Completed | {count} | {trend} |
| Time Saved | {hours}h | {trend} |
| Completion Rate | {rate}% | {trend} |
| Active Projects | {count} | {trend} |

## Task Completion

### Status Breakdown

| Status | Count | Percentage |
|--------|-------|------------|
| Done | {count} | {percent}% |
| Review | {count} | {percent}% |
| Doing | {count} | {percent}% |
| Todo | {count} | {percent}% |

### Recent Completions

| Task | Project | Completed | Duration |
|------|---------|-----------|----------|
| {task} | {project} | {date} | {duration} |
| ...

## Time Savings

### Overall Savings

- **Total Time Saved**: {hours} hours
- **Average per Task**: {hours} hours
- **This Week**: {hours} hours
- **This Month**: {hours} hours

### Savings Trend

{weekly breakdown or chart}

## Feature Usage

### Reference Library

| Category | References | Last Updated |
|----------|------------|--------------|
| {category} | {count} | {date} |
| ...

**Total References**: {total}

### Commands Used

| Command | Executions | Last Used |
|---------|------------|-----------|
| {command} | {count} | {date} |
| ...

## Productivity Metrics

| Metric | Value | Benchmark |
|--------|-------|-----------|
| Completion Rate | {rate}% | 80% target |
| Avg Task Duration | {hours}h | 2h target |
| Tasks This Week | {count} | 5 target |
| Active Projects | {count} | - |

## Insights & Recommendations

### 🎯 What's Working
- {insight_1}
- {insight_2}

### 💡 Opportunities
- {opportunity_1}
- {opportunity_2}

### 📈 Improvement Tips
- {tip_1}
- {tip_2}

---

**Export Data**: Use `--export` flag to generate CSV/JSON files
**Last Updated**: {timestamp}
```

## Error Handling

### Archon MCP Unavailable

- **Cause**: Archon MCP server not running or connection error
- **Detection**: `find_tasks()` or `find_projects()` calls fail
- **Recovery**: Display partial dashboard with available data, inform user of Archon unavailability

### Supabase Connection Error

- **Cause**: Supabase credentials invalid or network error
- **Detection**: SQL queries throw connection error
- **Recovery**: Display error message, suggest checking Supabase credentials, fall back to Archon-only metrics

### Table Not Found

- **Cause**: Migration 013 or 012 hasn't been run
- **Detection**: SQL query fails with "relation does not exist"
- **Recovery**: Inform user to run migration SQL, provide migration instructions, display partial dashboard

### Export Directory Error

- **Cause**: File system permissions or disk space
- **Detection**: File write operation fails
- **Recovery**: Display error with specific permission issue, suggest manual directory creation

### Empty Data Set

- **Cause**: No tasks, projects, or metrics recorded yet
- **Detection**: All queries return empty or zero counts
- **Recovery**: Display "No analytics data available" message, suggest using system to generate data

## Examples

### Example 1: First-Time Usage

**Command**: `/analytics`

**Output**:
```
# Usage Analytics Dashboard

Generated: 2026-01-26T12:00:00Z

## Overview

| Metric | Value | Change |
|--------|-------|--------|
| Tasks Completed | 0 | - |
| Time Saved | 0h | - |
| Completion Rate | 0% | - |
| Active Projects | 0 | - |

## No Data Yet

Start using the AI coding system to generate analytics data:
- Create projects with `/project create`
- Complete tasks with `/task create`
- Use workflow commands like `/planning`, `/development`

---
Run `/analytics` again after accumulating activity.
```

### Example 2: Active Development

**Command**: `/analytics`

**Output**:
```
# Usage Analytics Dashboard

Generated: 2026-01-26T12:00:00Z

## Overview

| Metric | Value | Change |
|--------|-------|--------|
| Tasks Completed | 47 | ↑ 12% |
| Time Saved | 94h | ↑ 8% |
| Completion Rate | 85% | ↑ 5% |
| Active Projects | 3 | → |

## Task Completion

### Status Breakdown

| Status | Count | Percentage |
|--------|-------|------------|
| Done | 47 | 85% |
| Review | 5 | 9% |
| Doing | 2 | 4% |
| Todo | 1 | 2% |

... (full dashboard)
```

### Example 3: Export Data

**Command**: `/analytics --export`

**Output**:
```
# Usage Analytics Dashboard

... (dashboard display)

## Export Complete

Files created:
- features/usage-analytics-dashboard/exports/analytics-2026-01-26.csv
- features/usage-analytics-dashboard/exports/analytics-2026-01-26.json

Use these files for further analysis or reporting.
```

## Notes

- **Passive tracking**: No need to manually track - system queries existing data sources
- **Token tracking**: Not in MVP - future enhancement will add per-command token tracking
- **Time estimates**: Currently uses default 2-hour manual effort estimate, can be refined
- **Privacy**: All data stays local - no external analytics or telemetry
- **Performance**: Queries are optimized to complete in < 2 seconds
- **Export format**: CSV for spreadsheets, JSON for programmatic access
- **Trend calculation**: Compares current period to previous period (week/month)

## Validation

After executing this command:
- [ ] All data sources queried successfully
- [ ] Metrics calculated accurately
- [ ] Dashboard formatted correctly
- [ ] Export files generated (if requested)
- [ ] No errors in console output
- [ ] Display is readable and actionable

## Integration with Other Commands

- **`/learn`**: Adds references that appear in Feature Usage section
- **`/project create`**: Creates projects tracked in analytics
- **`/task create`**: Creates tasks tracked in completion metrics
- **Workflow commands** (`/planning`, `/development`, `/execution`): Generate task data for analytics
- **`/learn-health`**: Similar pattern for reference library analytics

## Future Enhancements

- Token tracking per command (requires command instrumentation)
- Cost calculation based on token usage
- Project-by-project breakdown
- Custom time range filtering (week, month, quarter, custom)
- Trend charts and visualizations
- Comparison to team benchmarks
- Email reports or scheduled snapshots
- Integration with time tracking tools (Toggl, Harvest)
