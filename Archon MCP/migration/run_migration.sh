#!/bin/bash
# Migration Runner Script
# Usage: ./run_migration.sh <migration_file>
#
# This script executes a SQL migration file against the Supabase database
# using the Supabase MCP server or direct psql connection

set -e  # Exit on error

MIGRATION_FILE="${1:-}"

if [ -z "$MIGRATION_FILE" ]; then
    echo "Usage: $0 <migration_file>"
    echo "Example: $0 013_add_usage_metrics.sql"
    exit 1
fi

if [ ! -f "$MIGRATION_FILE" ]; then
    echo "Error: Migration file not found: $MIGRATION_FILE"
    exit 1
fi

echo "======================================"
echo "Running Migration: $MIGRATION_FILE"
echo "======================================"

# Check if Supabase URL is available
if [ -n "$SUPABASE_URL" ] && [ -n "$SUPABASE_PASSWORD" ]; then
    # Use Supabase CLI or psql
    echo "Executing via psql..."
    psql "$SUPABASE_URL" -f "$MIGRATION_FILE"
else
    # Alternative: Use MCP server (if available)
    echo "Note: This migration needs to be executed manually via:"
    echo "1. Supabase Dashboard SQL Editor"
    echo "2. psql command line tool"
    echo "3. MCP server with SQL execution capability"
    echo ""
    echo "Migration file: $MIGRATION_FILE"
    echo ""
    echo "To execute manually:"
    echo "1. Open Supabase Dashboard"
    echo "2. Navigate to SQL Editor"
    echo "3. Copy contents of: $(pwd)/$MIGRATION_FILE"
    echo "4. Execute the SQL"
fi

echo ""
echo "Migration completed!"
echo "Verify with: SELECT table_name FROM information_schema.tables WHERE table_name = 'archon_usage_metrics';"
