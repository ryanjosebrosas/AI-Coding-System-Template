---
name: Learn Health
description: "Check reference library health and display statistics"
phase: independent
dependencies: []
outputs:
  - description: "Health report displayed to user"
inputs: []
---

# Learn Health Command

## Purpose

Query the `archon_references` table for statistics, calculate library health percentage, identify empty categories, and generate suggestions for what to learn next.

This command provides a quick overview of the reference library's growth and coverage without running a full `/learn` command.

**When to use**: Use this command to check which categories need attention, track library growth, or get suggestions for what to learn next.

**What it solves**: This command addresses the need to quickly assess library health and identify gaps without loading full reference content.

## Prerequisites

- Supabase `archon_references` table exists (Migration 012)
- Direct SQL access to Supabase

## Execution Steps

### Step 1: Query Statistics

**Objective**: Get reference counts per category from database.

**Actions**:
1. Execute SQL query (direct Supabase access):
   ```sql
   SELECT
     category,
     COUNT(*) as count,
     MAX(updated_at) as last_updated
   FROM archon_references
   GROUP BY category
   ORDER BY category;
   ```
2. Parse results into category stats object

**Expected Result**: List of categories with reference counts and last updated timestamps.

### Step 2: Get Total Count

**Objective**: Get total reference count across all categories.

**Actions**:
1. Execute SQL query:
   ```sql
   SELECT COUNT(*) as total FROM archon_references;
   ```

**Expected Result**: Total reference count.

### Step 3: Calculate Health

**Objective**: Determine overall library health percentage.

**Actions**:
1. Define standard categories:
   - `python`
   - `mcp`
   - `react`
   - `typescript`
   - `ai-agents`
   - `testing`
   - `patterns`
   - `supabase`
   - `api`
2. Count non-empty categories from stats
3. Calculate health percentage:
   - `health = (non_empty_categories / total_categories) * 100`
4. Determine health status:
   - 80-100%: "Excellent"
   - 60-79%: "Good"
   - 40-59%: "Fair"
   - 20-39%: "Poor"
   - 0-19%: "Critical"

**Expected Result**: Health percentage and status label.

### Step 4: Identify Empty Categories

**Objective**: Find categories with no references.

**Actions**:
1. Compare standard categories against stats
2. List categories with count = 0 or not present in stats

**Expected Result**: List of empty categories.

### Step 5: Generate Suggestions

**Objective**: Suggest topics to learn based on gaps.

**Actions**:
1. For each empty category, generate suggested learning topics:
   - `python` → "Learn Python async patterns", "Learn FastAPI basics"
   - `mcp` → "Learn MCP server patterns", "Learn MCP tool development"
   - `react` → "Learn React hooks", "Learn Next.js routing"
   - `typescript` → "Learn TypeScript types", "Learn TS generics"
   - `ai-agents` → "Learn AI agent patterns", "Learn prompt engineering"
   - `testing` → "Learn pytest patterns", "Learn testing best practices"
   - `patterns` → "Learn design patterns", "Learn SOLID principles"
   - `supabase` → "Learn Supabase RLS", "Learn Supabase realtime"
   - `api` → "Learn REST design", "Learn GraphQL schemas"
2. Select top 3-5 suggestions based on empty categories

**Expected Result**: List of actionable learning suggestions.

### Step 6: Display Report

**Objective**: Present formatted health report to user.

**Actions**:
1. Format output as markdown:
   ```
   ## Brain Health: {health_percentage}% ({status})

   | Category | References | Last Updated |
   |----------|------------|--------------|
   | {category1} | {count} | {date or '-'} |
   | {category2} | {count} | {date or '-'} |
   | ...

   **Total References**: {total_count}

   ### Empty Categories
   {empty_categories_list}

   ### Suggestions
   - {suggestion_1}
   - {suggestion_2}
   - {suggestion_3}

   ---
   Use `/learn {topic}` to add new references.
   ```

**Expected Result**: Health report displayed to user.

## Output Format

The command displays a formatted health report:

```
## Brain Health: 67% (Good)

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

### Empty Categories
- react
- typescript
- api

### Suggestions
- Learn React hooks patterns
- Learn TypeScript generics
- Learn REST API design best practices

---
Use `/learn {topic}` to add new references.
```

## Error Handling

### Table Not Found

- **Cause**: Migration 012 hasn't been run
- **Detection**: SQL query fails with "relation does not exist"
- **Recovery**: Inform user to run migration SQL, suggest command

### Query Fails

- **Cause**: Supabase connection error or permission denied
- **Detection**: SQL query throws exception
- **Recovery**: Display error message, suggest checking Supabase credentials

### Empty Result Set

- **Cause**: No references in library yet
- **Detection**: Total count = 0
- **Recovery**: Display "Library is empty" message, suggest running `/learn`

## Examples

### Example 1: Healthy Library

**Command**: `/learn-health`

**Output**:
```
## Brain Health: 89% (Excellent)

| Category | References | Last Updated |
|----------|------------|--------------|
| ai-agents | 5 | 2026-01-24 |
| mcp | 8 | 2026-01-24 |
| patterns | 6 | 2026-01-23 |
| python | 7 | 2026-01-24 |
| react | 4 | 2026-01-22 |
| supabase | 3 | 2026-01-21 |
| testing | 4 | 2026-01-20 |
| typescript | 3 | 2026-01-19 |

**Total References**: 40

### Empty Categories
- api

### Suggestions
- Learn REST API design patterns
```

### Example 2: Empty Library

**Command**: `/learn-health`

**Output**:
```
## Brain Health: 0% (Critical)

| Category | References | Last Updated |
|----------|------------|--------------|
| (no data yet) | - | - |

**Total References**: 0

### All Categories Empty
Your reference library is empty! Start learning:

### Suggestions
- Learn Python async patterns
- Learn MCP server development
- Learn React hooks basics

---
Use `/learn {topic}` to add your first reference.
```

## Notes

- **Quick check**: This command is faster than running `/learn` for just checking stats
- **Token efficient**: Only queries stats, doesn't load full reference content
- **Actionable suggestions**: Based on actual gaps in your library
- **Growth tracking**: Watch health percentage improve over time

## Standard Categories

The health check tracks these 9 standard categories:

| Category | Description | Example Topics |
|----------|-------------|----------------|
| `python` | Python patterns, libraries | async, FastAPI, Django |
| `mcp` | MCP server development | tool creation, server patterns |
| `react` | React, Next.js, hooks | hooks, routing, state |
| `typescript` | TypeScript/JavaScript | types, generics, patterns |
| `ai-agents` | AI agent patterns | prompting, agents, tools |
| `testing` | Testing frameworks | pytest, Jest, testing patterns |
| `patterns` | Design patterns | SOLID, GoF patterns |
| `supabase` | Supabase/database | RLS, realtime, storage |
| `api` | API design | REST, GraphQL, OpenAPI |

## Validation

After executing this command:
- [ ] SQL queries executed successfully
- [ ] Stats calculated correctly
- [ ] Health percentage accurate
- [ ] Empty categories identified
- [ ] Suggestions generated
- [ ] Report formatted and displayed

## Integration with Other Commands

- **`/learn`**: Adds references that increase health percentage
- **PRP templates**: Reference `/learn-health` output to understand available categories
- **`CLAUDE.md`**: Documents both commands as part of reference library system
