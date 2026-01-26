# Supabase Migration Guide

## Running Migrations

### Option 1: Supabase Dashboard (Recommended for Development)

1. Open [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `oherglzxqtppevlepbbb`
3. Navigate to **SQL Editor** in the left sidebar
4. Click **New Query**
5. Copy the contents of the migration file (e.g., `013_add_usage_metrics.sql`)
6. Paste into the SQL Editor
7. Click **Run** to execute
8. Verify the table was created:
   ```sql
   SELECT table_name
   FROM information_schema.tables
   WHERE table_name = 'archon_usage_metrics';
   ```

### Option 2: Using psql Command Line

If you have psql installed and your database connection string:

```bash
# Set your credentials
export SUPABASE_URL="postgresql://postgres:[YOUR-PASSWORD]@db.oherglzxqtppevlepbbb.supabase.co:5432/postgres"

# Run the migration
psql "$SUPABASE_URL" -f "Archon MCP/migration/013_add_usage_metrics.sql"
```

### Option 3: Using the Migration Runner Script

```bash
cd "Archon MCP/migration"
./run_migration.sh 013_add_usage_metrics.sql
```

Note: The script will provide instructions if direct execution is not available.

## Migration 013: Usage Metrics Table

### Description
Creates `archon_usage_metrics` table for tracking command executions, task completions, and feature usage.

### Table Schema
- `id`: UUID primary key
- `metric_type`: TEXT (command_execution, task_completed, reference_used, feature_usage)
- `feature_name`: TEXT - Feature being tracked
- `command_name`: TEXT - Optional command name
- `task_id`: TEXT - Optional Archon MCP task ID
- `project_id`: TEXT - Optional Archon MCP project ID
- `duration_seconds`: INTEGER - Optional duration
- `tokens_used`: INTEGER - Optional token count (future)
- `metadata`: JSONB - Additional flexible data
- `created_at`: TIMESTAMPTZ - Timestamp

### Indexes
- `metric_type` - For filtering by type
- `feature_name` - For feature-based queries
- `created_at DESC` - For time-series queries
- `command_name` - For command-based queries
- `task_id` - For task-based queries

### Security
- RLS (Row Level Security) enabled
- Permissive policy for development (adjust for production)

## Verification

After running the migration, verify success:

```sql
-- Check table exists
SELECT table_name
FROM information_schema.tables
WHERE table_name = 'archon_usage_metrics';

-- Check schema
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'archon_usage_metrics'
ORDER BY ordinal_position;

-- Check indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'archon_usage_metrics';
```

## Rollback (If Needed)

```sql
DROP TABLE IF EXISTS archon_usage_metrics CASCADE;
```

## Troubleshooting

### Permission Denied
- Ensure you have admin access to the Supabase project
- Check your API key or database password

### Table Already Exists
- Check if migration was already run
- Use `CREATE TABLE IF NOT EXISTS` to make it idempotent

### Connection Issues
- Verify Supabase project reference: `oherglzxqtppevlepbbb`
- Check network connectivity to Supabase
- Confirm credentials are correct
