-- Migration: 013_add_usage_metrics.sql
-- Description: Create table for tracking usage analytics metrics
-- Related: Usage Analytics Dashboard feature

-- Create archon_usage_metrics table
CREATE TABLE IF NOT EXISTS archon_usage_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  metric_type TEXT NOT NULL CHECK (metric_type IN ('command_execution', 'task_completed', 'reference_used', 'feature_usage')),
  feature_name TEXT NOT NULL,
  command_name TEXT,
  task_id TEXT,
  project_id TEXT,
  duration_seconds INTEGER,
  tokens_used INTEGER,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_archon_usage_metrics_metric_type ON archon_usage_metrics(metric_type);
CREATE INDEX IF NOT EXISTS idx_archon_usage_metrics_feature_name ON archon_usage_metrics(feature_name);
CREATE INDEX IF NOT EXISTS idx_archon_usage_metrics_created_at ON archon_usage_metrics(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_archon_usage_metrics_command_name ON archon_usage_metrics(command_name);
CREATE INDEX IF NOT EXISTS idx_archon_usage_metrics_task_id ON archon_usage_metrics(task_id);

-- Add comments for documentation
COMMENT ON TABLE archon_usage_metrics IS 'Stores usage analytics metrics for command executions, task completions, and feature usage tracking';
COMMENT ON COLUMN archon_usage_metrics.metric_type IS 'Type of metric: command_execution, task_completed, reference_used, or feature_usage';
COMMENT ON COLUMN archon_usage_metrics.feature_name IS 'Name of the feature being tracked (e.g., analytics, learn, task-planning)';
COMMENT ON COLUMN archon_usage_metrics.command_name IS 'Optional: Name of command executed (e.g., /analytics, /learn)';
COMMENT ON COLUMN archon_usage_metrics.task_id IS 'Optional: Associated task ID from Archon MCP';
COMMENT ON COLUMN archon_usage_metrics.project_id IS 'Optional: Associated project ID from Archon MCP';
COMMENT ON COLUMN archon_usage_metrics.duration_seconds IS 'Optional: Duration of the operation in seconds';
COMMENT ON COLUMN archon_usage_metrics.tokens_used IS 'Optional: Number of tokens used (future enhancement)';
COMMENT ON COLUMN archon_usage_metrics.metadata IS 'Additional flexible data stored as JSONB (e.g., status, tags, custom fields)';
COMMENT ON COLUMN archon_usage_metrics.created_at IS 'Timestamp when the metric was recorded';

-- Enable Row Level Security
ALTER TABLE archon_usage_metrics ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (adjust for production use)
CREATE POLICY "Allow all access to archon_usage_metrics" ON archon_usage_metrics
  FOR ALL
  USING (true)
  WITH CHECK (true);
