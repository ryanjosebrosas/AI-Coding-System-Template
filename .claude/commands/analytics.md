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

**Objective**: Get reference library statistics from database.

**Actions**:

1. **Verify Supabase connection**:
   - Check Supabase credentials are available
   - Test connection with simple query if needed
   - If unavailable, display warning and skip to Step 5 (dashboard with partial data)

2. **Query category statistics**:
   - Execute SQL query (direct Supabase access):
     ```sql
     SELECT
       category,
       COUNT(*) as count,
       MAX(updated_at) as last_updated
     FROM archon_references
     GROUP BY category
     ORDER BY category;
     ```
   - Parse results into category stats map: `reference_stats[category] = {count, last_updated}`

3. **Query total reference count**:
   - Execute SQL query:
     ```sql
     SELECT COUNT(*) as total FROM archon_references;
     ```
   - Extract total count from result

4. **Calculate library health** (optional enhancement):
   - Define standard categories: `python`, `mcp`, `react`, `typescript`, `ai-agents`, `testing`, `patterns`, `supabase`, `api`
   - Count non-empty categories from stats
   - Calculate health: `(non_empty_categories / total_categories) * 100`

5. **Handle query errors**:
   - If SQL query fails with "relation does not exist": Log error that Migration 012 hasn't been run, set reference stats to empty, continue to Step 4
   - If connection error: Log error message, set reference stats to empty, continue to Step 4
   - If query timeout: Retry once with increased timeout, then proceed with empty stats
   - If results are null/empty: Set total count to 0, continue to Step 4

**Expected Result**: Reference library statistics object with structure:
```json
{
  "total_references": 17,
  "categories": {
    "ai-agents": {"count": 3, "last_updated": "2026-01-24T10:30:00Z"},
    "mcp": {"count": 5, "last_updated": "2026-01-24T09:15:00Z"},
    "patterns": {"count": 2, "last_updated": "2026-01-23T14:20:00Z"},
    "python": {"count": 4, "last_updated": "2026-01-22T16:45:00Z"},
    "react": {"count": 0, "last_updated": null},
    "supabase": {"count": 1, "last_updated": "2026-01-21T11:00:00Z"},
    "testing": {"count": 2, "last_updated": "2026-01-20T13:30:00Z"},
    "typescript": {"count": 0, "last_updated": null},
    "api": {"count": 0, "last_updated": null}
  },
  "health_percentage": 67,
  "non_empty_categories": 6
}
```

### Step 4: Query Usage Metrics

**Objective**: Get usage metrics from Supabase (if table populated).

**Actions**:

1. **Verify table exists**:
   - Check if `archon_usage_metrics` table exists (Migration 013)
   - If table doesn't exist, log warning and continue to Step 5 (usage metrics will be empty)

2. **Query recent metrics**:
   - Execute SQL query (direct Supabase access):
     ```sql
     SELECT
       metric_type,
       metric_value,
       recorded_at
     FROM archon_usage_metrics
     WHERE recorded_at >= NOW() - INTERVAL '30 days'
     ORDER BY recorded_at DESC;
     ```

3. **Parse and aggregate metrics**:
   - Group results by `metric_type` into map: `metrics_by_type[metric_type] = [{metric_value, recorded_at}, ...]`
   - For each metric type, calculate:
     - Sum of values (for cumulative metrics like token usage)
     - Count of records (for frequency metrics like command executions)
     - Most recent value and timestamp
   - Handle different metric types:
     - `token_usage`: Sum total tokens, extract per-command breakdown if available
     - `command_execution`: Count executions by command name
     - `time_tracked`: Sum total hours tracked
     - `task_created`: Count tasks created in period
     - `task_completed`: Count tasks completed in period

4. **Calculate time-based aggregations**:
   - **Last 7 days**: Filter metrics where `recorded_at >= NOW() - INTERVAL '7 days'`
   - **Last 30 days**: Use full result set from Step 4.2
   - For each period, calculate aggregates per metric type

5. **Handle query errors**:
   - If SQL query fails with "relation does not exist": Log warning that Migration 013 hasn't been run, set usage metrics to empty, continue to Step 5
   - If connection error: Log error message, set usage metrics to empty, continue to Step 5
   - If query returns empty: Set all metric aggregates to 0, continue to Step 5 (this is expected if not tracking usage yet)
   - If metric_type is unknown: Log warning, include in results anyway for flexibility

**Expected Result**: Usage metrics object with structure:
```json
{
  "token_usage": {
    "total_7_days": 150000,
    "total_30_days": 650000,
    "by_command": {
      "/planning": 200000,
      "/development": 250000,
      "/execution": 200000
    },
    "last_recorded": "2026-01-26T12:00:00Z"
  },
  "command_executions": {
    "total_7_days": 15,
    "total_30_days": 68,
    "by_command": {
      "/analytics": 3,
      "/learn": 8,
      "/learn-health": 12,
      "/planning": 5,
      "/development": 4,
      "/execution": 6
    },
    "last_recorded": "2026-01-26T11:30:00Z"
  },
  "time_tracked": {
    "total_hours_7_days": 25,
    "total_hours_30_days": 98,
    "last_recorded": "2026-01-26T12:00:00Z"
  },
  "tasks_created": {
    "count_7_days": 8,
    "count_30_days": 32
  },
  "tasks_completed": {
    "count_7_days": 12,
    "count_30_days": 47
  }
}
```

**Note on Empty Results**: If usage metrics table is empty (not tracking yet), all values will be 0. This is expected and the dashboard should handle it gracefully.

### Step 5: Calculate Metrics

**Objective**: Calculate token usage, time savings, and completion rate metrics from collected data.

**Actions**:

1. **Calculate token usage metrics**:
   - From usage metrics (Step 4), extract token_usage data:
     - `total_tokens_7_days`: Sum of token_usage values in last 7 days
     - `total_tokens_30_days`: Sum of token_usage values in last 30 days
     - `average_tokens_per_command`: `total_tokens_30_days / command_executions.total_30_days` (if commands > 0)
     - `token_breakdown`: Extract by_command breakdown if available
   - If usage metrics table is empty:
     - Set all token metrics to 0 with note "Token tracking not enabled yet"
   - Calculate percentage change:
     - Compare 7-day total to previous 7-day period (days 8-14)
     - Calculate: `((current_period - previous_period) / previous_period) * 100`
     - Handle division by zero: if previous period is 0, change is "N/A"

2. **Calculate time savings**:
   - For each completed task from Step 1:
     - Extract `duration_hours` from task data (calculated as `updated_at - created_at`)
     - Estimate manual effort:
       - Check if task has `duration_estimate` field
       - If not, use default: 2 hours (adjustable constant)
       - Alternative: Use median duration of completed tasks × 1.5 (manual work is slower)
     - Calculate per-task savings: `manual_effort_estimate - actual_duration_hours`
     - Handle edge cases:
       - If duration is negative (data error): Set savings to 0
       - If savings is negative (task took longer than estimate): Set to 0 (no penalty)
       - If duration is missing: Skip task in calculation
   - Aggregate time savings:
     - `total_hours_saved`: Sum of all per-task savings
     - `average_savings_per_task`: `total_hours_saved / done_count` (if done_count > 0)
     - `hours_saved_7_days`: Sum for tasks where `updated_at >= NOW() - INTERVAL '7 days'`
     - `hours_saved_30_days`: Sum for tasks where `updated_at >= NOW() - INTERVAL '30 days'`
   - Calculate efficiency rate:
     - `efficiency_rate = (total_manual_effort_estimate - total_actual_time) / total_manual_effort_estimate * 100`
     - This represents what percentage of time was saved

3. **Calculate completion rates**:
   - From task statistics (Step 1):
     - `overall_completion_rate = (done_count / total_tasks) * 100` (if total_tasks > 0)
     - `in_progress_rate = (doing_count / total_tasks) * 100`
     - `pending_rate = (todo_count / total_tasks) * 100`
     - `review_rate = (review_count / total_tasks) * 100`
   - Calculate project completion rates:
     - For each project from Step 2:
       - `project_completion_rate = (project.done_count / project.task_count) * 100`
     - Average project completion: `sum(project_completion_rates) / total_projects`
   - Calculate velocity metrics:
     - `tasks_completed_7_days`: Count done tasks where `updated_at >= NOW() - INTERVAL '7 days'`
     - `tasks_completed_30_days`: Count done tasks where `updated_at >= NOW() - INTERVAL '30 days'`
     - `completion_velocity_7_days`: `tasks_completed_7_days / 7` (tasks per day)
     - `completion_velocity_30_days`: `tasks_completed_30_days / 30` (tasks per day)

4. **Calculate productivity metrics**:
   - Average task duration:
     - Sum all done task durations (calculated in Step 1)
     - `average_duration_hours = total_duration / done_count` (if done_count > 0)
   - Task throughput:
     - `tasks_per_week = tasks_completed_7_days`
     - `tasks_per_month = tasks_completed_30_days`
   - Project activity:
     - `active_projects`: From Step 2, count of projects with status "active"
     - `project_completion_rate = (completed_projects / total_projects) * 100`
   - Time efficiency:
     - From time savings calculation, use `efficiency_rate`
     - Interpret as: "X% of potential manual time saved through AI assistance"

5. **Handle calculation errors**:
   - If task duration data is missing: Use default 0, log warning, continue with other metrics
   - If division by zero occurs: Set result to 0 or "N/A", log error
   - If timestamps are invalid: Skip affected task, log warning
   - If savings calculation produces negative values: Clamp to 0, log warning
   - If any required field is null: Use sensible default, continue calculation

**Expected Result**: Comprehensive metrics object with structure:
```json
{
  "token_usage": {
    "total_7_days": 150000,
    "total_30_days": 650000,
    "average_per_command": 9559,
    "breakdown": {
      "/planning": 200000,
      "/development": 250000,
      "/execution": 200000
    },
    "percentage_change": 12.5,
    "tracking_enabled": true
  },
  "time_savings": {
    "total_hours_saved": 94.5,
    "average_savings_per_task": 2.01,
    "hours_saved_7_days": 18.5,
    "hours_saved_30_days": 72.0,
    "efficiency_rate": 67,
    "calculation_method": "default_2hr_estimate",
    "tasks_analyzed": 47
  },
  "completion_rates": {
    "overall_completion_rate": 85.5,
    "in_progress_rate": 3.6,
    "pending_rate": 1.8,
    "review_rate": 9.1,
    "average_project_completion": 75.0,
    "project_breakdown": [
      {
        "project_id": "proj-123",
        "project_title": "Feature Implementation",
        "completion_rate": 80.0,
        "done_tasks": 20,
        "total_tasks": 25
      }
    ]
  },
  "velocity": {
    "tasks_completed_7_days": 12,
    "tasks_completed_30_days": 47,
    "daily_completion_rate_7_days": 1.71,
    "daily_completion_rate_30_days": 1.57
  },
  "productivity": {
    "average_task_duration_hours": 0.95,
    "tasks_per_week": 12,
    "tasks_per_month": 47,
    "active_projects": 3,
    "project_completion_rate": 20.0,
    "time_efficiency_percent": 67
  }
}
```

**Edge Cases to Handle**:
- No completed tasks yet: Set all rate-based metrics to 0, display "No data" message
- Empty usage metrics table: Set token metrics to 0 with note "Tracking not enabled"
- Task durations not available: Use estimate only, flag as "Estimated"
- Division by zero in rate calculations: Set to 0, log warning
- Negative savings (tasks took longer than expected): Clamp to 0, don't penalize

### Step 6: Display Dashboard

**Objective**: Present formatted analytics dashboard to user.

**Actions**:

1. **Calculate trend indicators**:
   - For each metric in Overview, calculate trend:
     - Compare current 7-day value to previous 7-day period (days 8-14)
     - Calculate percentage change: `((current - previous) / previous) * 100`
     - Map to arrow indicator:
       - `> 10%`: "↑↑" (strong increase)
       - `> 0%`: "↑" (moderate increase)
       - `= 0%`: "→" (no change)
       - `< 0%`: "↓" (decrease)
     - Format trend string: "{arrow} {abs(percentage)}%"
   - Handle edge cases:
     - If previous period is 0: Use "→" (no baseline)
     - If no data available: Use "-" (not applicable)

2. **Generate insights**:
   - **What's Working** (identify strengths):
     - If completion rate > 80%: "Strong task completion rate"
     - If efficiency rate > 60%: "Excellent time efficiency"
     - If velocity > 1.5 tasks/day: "High delivery velocity"
     - If active projects < 5: "Focused project portfolio"
     - If library health > 70%: "Well-rounded knowledge base"
   - **Opportunities** (identify gaps):
     - If todo_count > doing_count * 2: "Consider breaking down large tasks"
     - If review_count > 5: "Review backlog building - consider code review practices"
     - If any category empty: "Learn {category} patterns with `/learn {category}`"
     - If efficiency rate < 50%: "Review task estimates, consider breaking down work"
     - If velocity < 1 task/day: "Consider reducing work-in-progress (WIP)"
   - **Improvement Tips** (actionable recommendations):
     - If doing_count > 3: "Limit WIP to 2-3 tasks for better focus"
     - If average_task_duration_hours > 2: "Break large tasks into smaller subtasks"
     - If project_completion_rate < 70%: "Close out completed projects to maintain momentum"
     - If no time savings: "Track task estimates to measure efficiency gains"

3. **Format Overview section**:
   - Create header: `## Overview`
   - Create table with columns: `| Metric | Value | Change |`
   - Add rows for each key metric:
     - Tasks Completed: `{done_count}` | `{trend_indicator}`
     - Time Saved: `{total_hours_saved}h` | `{trend_indicator}`
     - Completion Rate: `{overall_completion_rate}%` | `{trend_indicator}`
     - Active Projects: `{active_projects}` | `{trend_indicator}`
   - Add timestamp: `Generated: {current_timestamp}`

4. **Format Task Completion section**:
   - Create header: `## Task Completion`
   - Create subsection: `### Status Breakdown`
   - Create table with columns: `| Status | Count | Percentage |`
   - Add rows for each status: Done, Review, Doing, Todo
   - Calculate percentage: `(count / total_tasks) * 100`
   - Add visual bar: `[████████░░░] 80%` (use █ for filled, ░ for empty, 10 bars total)
   - Create subsection: `### Recent Completions`
   - Create table with columns: `| Task | Project | Completed | Duration |`
   - Add up to 5 most recent completed tasks from `recent_completions` array
   - Format duration as "{hours}h {minutes}m" or "{hours}h"

5. **Format Time Savings section**:
   - Create header: `## Time Savings`
   - Create subsection: `### Overall Savings`
   - Display metrics as bullet list:
     - `**Total Time Saved**: {total_hours_saved} hours`
     - `**Average per Task**: {average_savings_per_task} hours`
     - `**This Week**: {hours_saved_7_days} hours`
     - `**This Month**: {hours_saved_30_days} hours`
   - Create subsection: `### Efficiency`
   - Display: `**Efficiency Rate**: {efficiency_rate}% of potential manual time saved`
   - Add context: "AI assistance accelerated development by {efficiency_rate}%"

6. **Format Feature Usage section**:
   - Create header: `## Feature Usage`
   - Create subsection: `### Reference Library`
   - Create table with columns: `| Category | References | Last Updated |`
   - Add rows for each category from `reference_stats`
   - Format last_updated as YYYY-MM-DD or "-" if null
   - Add total: `**Total References**: {total_references}`
   - If library health calculated, add: `**Library Health**: {health_percentage}%`
   - Create subsection: `### Commands Used`
   - If command_executions data available:
     - Create table with columns: `| Command | Executions | Last Used |`
     - Add rows for top 5 most used commands
     - Format last_used as relative time ("2 hours ago", "Yesterday", "2026-01-24")

7. **Format Productivity Metrics section**:
   - Create header: `## Productivity Metrics`
   - Create table with columns: `| Metric | Value | Benchmark |`
   - Add rows:
     - Completion Rate: `{overall_completion_rate}%` | `80% target`
     - Avg Task Duration: `{average_task_duration_hours}h` | `2h target`
     - Tasks This Week: `{tasks_completed_7_days}` | `5 target`
     - Tasks Per Day: `{completion_velocity_7_days}` | `1.5 target`
     - Active Projects: `{active_projects}` | `-`
   - Add indicators: ✗ if below benchmark, ✓ if at/above benchmark

8. **Format Insights & Recommendations section**:
   - Create header: `## Insights & Recommendations`
   - Create subsection: `### 🎯 What's Working`
   - Add 2-3 bullet points from "What's Working" insights
   - Create subsection: `### 💡 Opportunities`
   - Add 2-3 bullet points from "Opportunities" insights
   - Create subsection: `### 📈 Improvement Tips`
   - Add 2-3 bullet points from "Improvement Tips"

9. **Add footer**:
   - Add separator: `---`
   - Add export hint: `**Export Data**: Use \`/analytics --export\` to generate CSV/JSON files`
   - Add timestamp: `**Last Updated**: {current_timestamp}`

10. **Handle edge cases**:
    - If all metrics are 0 (no data yet):
      - Display "## No Data Yet" section
      - Provide setup instructions
      - Skip detailed sections
    - If specific data source unavailable:
      - Display note: `**Note**: {source} data unavailable - {reason}`
      - Continue with available data
    - If trend cannot be calculated (no previous period):
      - Use "→" indicator and "N/A" in Change column
    - If metric is negative (shouldn't happen):
      - Clamp to 0, log warning
    - If percentage exceeds 100%:
      - Clamp to 100% for display, log warning

**Expected Result**: Comprehensive analytics dashboard displayed with formatted markdown tables, visual indicators, and actionable insights.

**Formatting Example**:
```markdown
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
| Done | 47 | 85% [█████████░░] |
| Review | 5 | 9% [██░░░░░░░░░] |
| Doing | 2 | 4% [░░░░░░░░░░] |
| Todo | 1 | 2% [░░░░░░░░░░] |

### Recent Completions

| Task | Project | Completed | Duration |
|------|---------|-----------|----------|
| Implement analytics | proj-123 | 2 hours ago | 1.5h |
| Fix auth bug | proj-456 | Yesterday | 0.75h |
| Add tests | proj-123 | 2 days ago | 1h |

## Time Savings

### Overall Savings

- **Total Time Saved**: 94.5 hours
- **Average per Task**: 2.01 hours
- **This Week**: 18.5 hours
- **This Month**: 72.0 hours

### Efficiency

**Efficiency Rate**: 67% of potential manual time saved

## Feature Usage

### Reference Library

| Category | References | Last Updated |
|----------|------------|--------------|
| ai-agents | 3 | 2026-01-24 |
| mcp | 5 | 2026-01-24 |
| patterns | 2 | 2026-01-23 |
| python | 4 | 2026-01-22 |
| react | 0 | - |
| supabase | 1 | 2026-01-21 |
| testing | 2 | 2026-01-20 |
| typescript | 0 | - |

**Total References**: 17
**Library Health**: 67%

### Commands Used

| Command | Executions | Last Used |
|---------|------------|-----------|
| /analytics | 3 | 2 hours ago |
| /learn | 8 | Yesterday |
| /learn-health | 12 | 3 days ago |

## Productivity Metrics

| Metric | Value | Benchmark |
|--------|-------|-----------|
| Completion Rate | 85% ✓ | 80% target |
| Avg Task Duration | 0.95h ✓ | 2h target |
| Tasks This Week | 12 ✓ | 5 target |
| Active Projects | 3 | - |

## Insights & Recommendations

### 🎯 What's Working
- Strong task completion rate at 85%
- Excellent time efficiency with 67% savings
- High delivery velocity at 1.7 tasks/day

### 💡 Opportunities
- Learn react patterns with `/learn react`
- Learn typescript patterns with `/learn typescript`

### 📈 Improvement Tips
- Review backlog building - consider dedicated review time
- Close out completed projects to maintain momentum

---

**Export Data**: Use `/analytics --export` to generate CSV/JSON files
**Last Updated**: 2026-01-26T12:00:00Z
```

### Step 7: Export Data (Optional)

**Objective**: Generate CSV and JSON exports of analytics data for further analysis or reporting.

**Actions**:

1. **Check export flag**:
   - Determine if export was requested (via `--export` flag or user prompt)
   - If not requested, skip this step and proceed to command completion
   - If requested, continue to export directory creation

2. **Create export directory**:
   - Define export path: `features/usage-analytics-dashboard/exports/`
   - Execute directory creation:
     ```bash
     mkdir -p features/usage-analytics-dashboard/exports/
     ```
   - Handle errors:
     - If directory already exists: Continue (no error)
     - If permission denied: Log error, display message to user, skip export
     - If disk space insufficient: Log error, display message to user, skip export
     - If path is invalid: Log error, display message to user, skip export

3. **Generate CSV export**:
   - Define filename: `analytics-{YYYY-MM-DD}.csv` (using current date)
   - Construct CSV content with headers and data rows:
     - **Header row**: `metric_type,metric_name,metric_value,timestamp`
     - **Task metrics rows**:
       - `task,total_tasks,{total_tasks},{current_timestamp}`
       - `task,done_count,{done_count},{current_timestamp}`
       - `task,review_count,{review_count},{current_timestamp}`
       - `task,doing_count,{doing_count},{current_timestamp}`
       - `task,todo_count,{todo_count},{current_timestamp}`
     - **Project metrics rows**:
       - `project,total_projects,{total_projects},{current_timestamp}`
       - `project,active_projects,{active_projects},{current_timestamp}`
       - `project,completed_projects,{completed_projects},{current_timestamp}`
     - **Time savings rows**:
       - `savings,total_hours_saved,{total_hours_saved},{current_timestamp}`
       - `savings,average_savings_per_task,{average_savings_per_task},{current_timestamp}`
       - `savings,hours_saved_7_days,{hours_saved_7_days},{current_timestamp}`
       - `savings,hours_saved_30_days,{hours_saved_30_days},{current_timestamp}`
       - `savings,efficiency_rate,{efficiency_rate},{current_timestamp}`
     - **Token usage rows** (if tracking enabled):
       - `tokens,total_7_days,{total_tokens_7_days},{current_timestamp}`
       - `tokens,total_30_days,{total_tokens_30_days},{current_timestamp}`
       - `tokens,average_per_command,{average_tokens_per_command},{current_timestamp}`
     - **Velocity rows**:
       - `velocity,tasks_completed_7_days,{tasks_completed_7_days},{current_timestamp}`
       - `velocity,tasks_completed_30_days,{tasks_completed_30_days},{current_timestamp}`
       - `velocity,daily_rate_7_days,{completion_velocity_7_days},{current_timestamp}`
     - **Reference library rows**:
       - `references,total_references,{total_references},{current_timestamp}`
       - `references,health_percentage,{health_percentage},{current_timestamp}`
       - For each category: `references,category_{category},{count},{current_timestamp}`
   - Write CSV file:
     - Use proper CSV formatting (comma-separated, newline-delimited)
     - Ensure headers match row structure
     - Handle special characters (escape commas in values)
   - Handle errors:
     - If write fails: Log error, display message, continue to JSON export
     - If file exists: Overwrite with new data
     - If data contains invalid characters: Sanitize or escape, log warning

4. **Generate JSON export**:
   - Define filename: `analytics-{YYYY-MM-DD}.json` (using current date)
   - Construct JSON object with complete analytics data:
     ```json
     {
       "export_timestamp": "{ISO_8601_timestamp}",
       "export_date": "{YYYY-MM-DD}",
       "metrics": {
         "tasks": {
           "total_tasks": {total_tasks},
           "done_count": {done_count},
           "review_count": {review_count},
           "doing_count": {doing_count},
           "todo_count": {todo_count},
           "overall_completion_rate": {overall_completion_rate}
         },
         "projects": {
           "total_projects": {total_projects},
           "active_projects": {active_projects},
           "completed_projects": {completed_projects},
           "archived_projects": {archived_projects}
         },
         "time_savings": {
           "total_hours_saved": {total_hours_saved},
           "average_savings_per_task": {average_savings_per_task},
           "hours_saved_7_days": {hours_saved_7_days},
           "hours_saved_30_days": {hours_saved_30_days},
           "efficiency_rate": {efficiency_rate},
           "tasks_analyzed": {tasks_analyzed}
         },
         "velocity": {
           "tasks_completed_7_days": {tasks_completed_7_days},
           "tasks_completed_30_days": {tasks_completed_30_days},
           "daily_completion_rate_7_days": {completion_velocity_7_days},
           "daily_completion_rate_30_days": {completion_velocity_30_days}
         },
         "productivity": {
           "average_task_duration_hours": {average_task_duration_hours},
           "tasks_per_week": {tasks_completed_7_days},
           "tasks_per_month": {tasks_completed_30_days},
           "active_projects": {active_projects},
           "project_completion_rate": {project_completion_rate},
           "time_efficiency_percent": {efficiency_rate}
         },
         "token_usage": {
           "total_7_days": {total_tokens_7_days},
           "total_30_days": {total_tokens_30_days},
           "average_per_command": {average_tokens_per_command},
           "breakdown_by_command": {
             "/planning": {tokens_planning},
             "/development": {tokens_development},
             "/execution": {tokens_execution}
           },
           "tracking_enabled": {tracking_enabled}
         },
         "references": {
           "total_references": {total_references},
           "health_percentage": {health_percentage},
           "non_empty_categories": {non_empty_categories},
           "categories": {
             "ai-agents": {"count": {count}, "last_updated": "{timestamp}"},
             "mcp": {"count": {count}, "last_updated": "{timestamp}"},
             "patterns": {"count": {count}, "last_updated": "{timestamp}"},
             "python": {"count": {count}, "last_updated": "{timestamp}"},
             "react": {"count": {count}, "last_updated": "{timestamp}"},
             "supabase": {"count": {count}, "last_updated": "{timestamp}"},
             "testing": {"count": {count}, "last_updated": "{timestamp}"},
             "typescript": {"count": {count}, "last_updated": "{timestamp}"},
             "api": {"count": {count}, "last_updated": "{timestamp}"}
           }
         },
         "recent_completions": [
           {
             "task_id": "{task_id}",
             "title": "{task_title}",
             "project_id": "{project_id}",
             "completed_at": "{timestamp}",
             "duration_hours": {duration}
           }
         ]
       }
     }
     ```
   - Write JSON file with proper formatting:
     - Use pretty-print (2-space indentation)
     - Ensure valid JSON syntax
     - Include all null/empty values (use null, not empty strings)
   - Handle errors:
     - If write fails: Log error, display message, continue to confirmation
     - If file exists: Overwrite with new data
     - If JSON serialization fails: Log error with field name, use partial data if possible

5. **Verify export files**:
   - Check that both files were created successfully:
     - Verify CSV file exists and is non-empty
     - Verify JSON file exists and is valid JSON (if feasible)
   - Calculate file sizes for reporting:
     - Get CSV file size in bytes
     - Get JSON file size in bytes
     - Convert to human-readable format (KB, MB if needed)
   - If either file creation failed:
     - Log which file failed
     - Display partial success message
     - Include error reason

6. **Display export confirmation**:
   - Create formatted message:
     ```markdown
     ## Export Complete

     **Files Created**:
     - CSV: `{csv_file_path}` ({file_size})
     - JSON: `{json_file_path}` ({file_size})

     **Export Date**: {YYYY-MM-DD}
     **Total Metrics**: {count_of_metrics_exported}

     Use these files for further analysis or reporting.
     ```
   - Include file paths in message for easy access
   - Add timestamp of export
   - If only one format succeeded, note the partial success
   - If both failed, display error message with troubleshooting steps

**Expected Result**: Export files created successfully and confirmation message displayed to user.

**CSV File Example**:
```csv
metric_type,metric_name,metric_value,timestamp
task,total_tasks,55,2026-01-26T12:00:00Z
task,done_count,47,2026-01-26T12:00:00Z
task,review_count,5,2026-01-26T12:00:00Z
task,doing_count,2,2026-01-26T12:00:00Z
task,todo_count,1,2026-01-26T12:00:00Z
savings,total_hours_saved,94.5,2026-01-26T12:00:00Z
savings,efficiency_rate,67,2026-01-26T12:00:00Z
velocity,tasks_completed_7_days,12,2026-01-26T12:00:00Z
references,total_references,17,2026-01-26T12:00:00Z
references,health_percentage,67,2026-01-26T12:00:00Z
```

**JSON File Structure** (complete example shown in Actions above)

**Confirmation Message Example**:
```markdown
## Export Complete

**Files Created**:
- CSV: `features/usage-analytics-dashboard/exports/analytics-2026-01-26.csv` (2.4 KB)
- JSON: `features/usage-analytics-dashboard/exports/analytics-2026-01-26.json` (4.8 KB)

**Export Date**: 2026-01-26
**Total Metrics**: 25

Use these files for further analysis or reporting.
```

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
