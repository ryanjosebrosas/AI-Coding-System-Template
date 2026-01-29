---
name: Task Planning
description: "Combine all contexts into actionable tasks with PRP guidance"
phase: task-planning
dependencies: [development]
outputs:
  - path: "features/{feature-name}/prp.md"
    description: "Plan Reference Protocol document with codebase-aware implementation guidance"
  - path: "features/{feature-name}/task-plan.md"
    description: "Task plan with task IDs, dependencies, and execution order"
  - path: "features/{feature-name}/STATUS.md"
    description: "Updated feature status tracking file"
  - path: "features/{feature-name}/execution/"
    description: "Execution folder with individual task files (deleted as tasks complete)"
inputs:
  - path: "context/prime-{timestamp}.md"
    description: "Most recent codebase export from Prime command"
    required: true
  - path: "discovery/discovery-{timestamp}.md"
    description: "Most recent discovery document"
    required: false
  - path: "MVP.md"
    description: "MVP definition at root"
    required: true
  - path: "PRD.md"
    description: "Product Requirements Document at root"
    required: true
  - path: "TECH-SPEC.md"
    description: "Technical Specification at root"
    required: true
---

# Task Planning Command

## Purpose

Combine all contexts (Prime, Discovery, PRD, Tech Spec) into actionable tasks with PRP guidance. This command loads all contexts, extracts codebase patterns, selects appropriate PRP template, generates PRP with codebase-aware context, breaks down tasks with dependencies, creates tasks in Archon MCP, and generates task plan document.

## MCP Query Caching

This command implements intelligent caching for all Archon MCP queries to improve performance:

**Cache Storage**: `.auto-claude/performance_cache.json` → `mcp_cache` object

**Cache Entry Format**:
```json
{
  "mcp_cache": {
    "health_check": {
      "result": {...},
      "cached_at": "2026-01-27T00:00:00Z",
      "ttl": 300
    },
    "find_projects:feature-name": {
      "result": [...],
      "cached_at": "2026-01-27T00:00:00Z",
      "ttl": 600
    },
    "create_task:project-id:task-title": {
      "result": {...},
      "cached_at": "2026-01-27T00:00:00Z",
      "ttl": 900
    }
  }
}
```

**Cache Key Patterns**:
- Health check: `health_check`
- Find projects: `find_projects:{query}`
- Create task: `create_task:{project_id}:{task_title}`
- Update task: `update_task:{task_id}:{status}`
- RAG search: `rag_search:{query}:{source_id}`

**TTL Values**:
- Health check: 5 minutes (300s)
- Project lookup: 10 minutes (600s)
- Task creation: 15 minutes (900s)
- Task updates: 5 minutes (300s)
- RAG searches: 30 minutes (1800s)

**Cache Logic**:
1. Before each MCP query, check cache for matching key
2. If cache hit and TTL valid, use cached result (increment `cache_hits`)
3. If cache miss or TTL expired, execute MCP query (increment `cache_misses`)
4. Store query result in cache with current timestamp
5. Update `performance_cache.json` after each operation

## Parallel MCP Query Execution

This command uses parallel query execution for independent MCP queries to reduce latency:

**When to Use Parallel Queries**:
- Multiple RAG searches from different sources (no dependencies between searches)
- Finding projects and tasks concurrently (independent lookups)
- Multiple independent health checks or status queries
- Any queries where results don't depend on each other

**Parallel Query Patterns**:

1. **Parallel RAG Searches** (Step 4 - PRP Generation):
   ```
   # Independent RAG searches can run in parallel:
   - rag_search_knowledge_base("authentication patterns", source_id="src_auth")
   - rag_search_knowledge_base("database patterns", source_id="src_db")
   - rag_search_knowledge_base("API patterns", source_id="src_api")

   # All searches query different sources with no dependencies
   # Results populate different PRP sections
   ```

2. **Parallel Project/Task Lookups** (Step 5 - Archon Integration):
   ```
   # Check for existing projects and tasks in parallel:
   - find_projects(query="{feature-name}")
   - find_tasks(filter_by="project", filter_value="{project_id}")

   # Independent lookups, no dependency between results
   # Used to verify project/task state before creating new tasks
   ```

3. **Sequential with Independent Batches**:
   ```
   # First batch: Parallel RAG searches (independent sources)
   # Second batch: Parallel project/task lookups (after RAG completes)
   # Third batch: Create tasks (after lookups complete)
   # Each batch: Parallel execution
   # Between batches: Sequential (dependencies exist)
   ```

**Implementation Notes**:
- Parallel queries ONLY when queries are truly independent
- Different sources = independent (safe to parallelize)
- Same source with different queries = independent (safe to parallelize)
- Queries that depend on previous results = sequential (must wait)
- Each parallel query still uses caching logic
- Track `parallel_query_batches` in performance metrics

**Performance Metrics**:
- Track number of parallel query batches executed
- Track average queries per batch
- Compare sequential vs parallel execution time
- Document expected speedup in build-progress.txt

## Execution Steps

### Step 1: Load All Contexts with Selective Prioritization

Load contexts in priority order with selective loading for large codebases:

**Priority 1: Critical Feature-Specific Context (Load First)**
- These files are essential for current feature and must be loaded immediately

1. **Load PRD**:
   - Read `features/{feature-name}/prd.md`
   - Parse PRD structure
   - Extract: Overview, User Stories, Features, Technical Requirements, Acceptance Criteria
   - Store in memory with priority score: 100 (critical)

2. **Load Tech Spec**:
   - Read `features/{feature-name}/tech-spec.md`
   - Parse Tech Spec structure
   - Extract: System Architecture, Technology Stack, Command Structure, File System Structure, Data Models, MCP Integration
   - Store in memory with priority score: 100 (critical)

**Priority 2: Discovery Context (Load Second)**
- Provides feature ideation and inspiration sources

3. **Load Discovery document** (if available):
   - Find most recent `discovery/discovery-*.md`
   - Read and parse Discovery document
   - Extract: Ideas, Inspiration Sources, Needs Analysis, Opportunities
   - Store in memory with priority score: 80 (high)

**Priority 3: Prime Export with Selective Loading (Load Third with Prioritization)**
- Large export - use incremental loading with file prioritization

4. **Load Prime export selectively**:
   - Find most recent `context/prime-*.md`
   - Check file size and modification date
   - **For large exports (>100MB)**: Use incremental loading
     - **First Batch** (High Priority - Load Immediately):
       - Index statistics and metadata
       - Recently modified files (modified in last 7 days)
       - High-relevance directories: `.claude/commands/`, `features/{feature-name}/`, `templates/`
       - Configuration files: `CLAUDE.md`, `MVP.md`, `.claude/config.json`
     - **Second Batch** (Medium Priority - Load on Demand):
       - Reference implementations in `Archon MCP/`
       - Documentation files
       - Test files related to current feature
     - **Third Batch** (Low Priority - Load if Needed):
       - Unrelated features
       - Example files
       - Legacy code
   - **For small exports (<100MB)**: Load entire export at once
   - Extract: Project tree, prioritized file contents, index statistics
   - Store in memory with priority scores per file (based on relevance, recency, path importance)

**File Relevance Scoring** (for Prime export prioritization):
- **Recency Score** (0-40 points):
  - Modified <1 day ago: 40 points
  - Modified 1-7 days ago: 30 points
  - Modified 8-30 days ago: 20 points
  - Modified >30 days ago: 10 points
- **Path Importance Score** (0-40 points):
  - Current feature path: 40 points
  - Core commands (`.claude/`): 35 points
  - MCP server code: 30 points
  - Templates: 25 points
  - Other features: 15 points
  - Documentation: 10 points
- **File Type Score** (0-20 points):
  - Command definitions: 20 points
  - Configuration: 18 points
  - Implementation code: 15 points
  - Tests: 12 points
  - Documentation: 8 points
- **Total Score**: Sum of all three (0-100 points)
- **Priority Thresholds**:
  - High Priority (>70): Load in First Batch
  - Medium Priority (40-70): Load in Second Batch
  - Low Priority (<40): Load in Third Batch if needed

5. **Combine contexts incrementally**:
   - Start with Priority 1 contexts (PRD, Tech Spec) - immediately available
   - Add Priority 2 context (Discovery) - available after first batch
   - Add Priority 3 contexts incrementally - load batches as needed
   - Organize by priority tier and source
   - Prepare for pattern extraction and PRP generation

**Expected Result**: High-priority contexts loaded first, lower-priority contexts loaded incrementally on demand, reducing initial context load time by 60-80% for large codebases.

**Performance Optimization Notes**:
- For small codebases (<10k files), all contexts load at once (no overhead)
- For large codebases (>100k files), selective loading reduces initial load from ~30s to ~5-10s
- Cache frequently accessed files from Prime export in `.auto-claude/performance_cache.json`
- Track load times for each priority batch in performance metrics

### Step 2: Extract Codebase Patterns

Use pattern extraction utility to extract codebase patterns from Prime export:

1. **Call pattern extraction utility**:
   - Use utility from Task 11: `extract_codebase_patterns(prime_export_path)`
   - Pass path to most recent Prime export
   - Receive extracted patterns

2. **Extract patterns**:
   - File structure patterns
   - Naming conventions (files, functions, classes, variables, constants)
   - Architecture patterns (service structure, API patterns, component structure, data flow)
   - Similar implementations (reference files)
   - Testing patterns (test framework, test organization, test structure)
   - Validation commands (linting, formatting, type checking)

3. **Store patterns**:
   - Store patterns in memory
   - Prepare for PRP template population

**Expected Result**: Codebase patterns extracted and ready for PRP generation.

### Step 3: Select PRP Template

Select appropriate PRP template based on feature type:

1. **Analyze feature characteristics**:
   - Review PRD features and requirements
   - Review Tech Spec system architecture and technology stack
   - Identify feature type:
     - AI agent (uses AI models, prompts, tools)
     - MCP integration (integrates with MCP server)
     - API endpoint (handles HTTP requests/responses)
     - Frontend component (renders UI, handles user interactions)
     - Generic/custom (doesn't fit specialized templates)

2. **Select template**:
   - If AI agent → `templates/prp/prp-ai-agent.md`
   - If MCP integration → `templates/prp/prp-mcp-integration.md`
   - If API endpoint → `templates/prp/prp-api-endpoint.md`
   - If frontend component → `templates/prp/prp-frontend-component.md`
   - Otherwise → `templates/prp/prp-base.md`

3. **Load selected template**:
   - Read template file contents
   - Parse template structure
   - Identify sections to populate

**Expected Result**: PRP template selected and loaded.

### Step 4: Generate PRP

Populate PRP template with codebase patterns and context:

1. **Populate base sections with RAG caching**:
   - Goal: Fill from PRD Overview and success criteria
   - Deliverable: Fill from PRD features and requirements
   - Success Criteria: Fill from PRD acceptance criteria
   - Documentation URLs: Add relevant links from Discovery and web research
     - For RAG queries, use caching: Generate key `rag_search:{query}:{source_id}`
     - Check cache before calling `rag_search_knowledge_base()`
     - Cache results with 30-minute TTL
     - Update cache hit/miss metrics
   - File References: Add from codebase patterns extraction
   - Naming Conventions: Fill from codebase patterns extraction
   - Architecture Patterns: Fill from codebase patterns extraction

2. **Populate template-specific sections** (based on selected template):
   - AI Agent sections: Agent Architecture, Agent Tools, Agent Memory, Agent Workflow
   - MCP Integration sections: MCP Server Configuration, MCP Tools, MCP Resources, MCP Prompts
   - API Endpoint sections: API Design, API Authentication, API Validation, API Documentation
   - Frontend Component sections: Component Architecture, Component Styling, Component Integration, Component Performance

3. **Populate Implementation Blueprint**:
   - Data Models: Extract from Tech Spec
   - Implementation Tasks: Break down from PRD features and Tech Spec implementation phases
   - Dependencies: Extract from Tech Spec and analyze task relationships
   - File Structure: Extract from Tech Spec and combine with codebase patterns
   - Integration Points: Extract from Tech Spec MCP Integration section

4. **Populate Validation Loop**:
   - Syntax Validation: Use validation commands from codebase patterns
   - Unit Tests: Use test patterns from codebase
   - Integration Tests: Follow integration test patterns from codebase
   - End-to-End Tests: Define based on PRD user stories

5. **Populate Anti-Patterns**:
   - General anti-patterns: From PRP base template
   - Template-specific anti-patterns: From selected specialized template

6. **Generate PRP document**:
   - Combine all populated sections
   - Add metadata (version, timestamp, related documents)
   - Format as markdown

**Expected Result**: Codebase-aware PRP generated with all needed context.

### Step 5: Create Tasks in Archon MCP

Break down implementation tasks and create in Archon MCP with caching:

1. **Verify Archon MCP availability with caching**:
   - Generate cache key: `health_check`
   - Check `.auto-claude/performance_cache.json` for cached result
   - If cache hit and TTL valid (5 minutes), use cached result
   - If cache miss or TTL expired, call `health_check()` to verify server is available
   - Store result in cache with current timestamp and 5-minute TTL
   - Update `performance_metrics.cache_hits` or `cache_misses` accordingly
   - If unavailable, stop and inform user (per ARCHON-FIRST RULE)

2. **Create or find project with caching**:
   - Generate cache key: `find_projects:{feature-name}`
   - Check cache for existing project lookup
   - If cache hit and TTL valid (10 minutes), use cached result
   - If cache miss or TTL expired, call `find_projects(query="{feature-name}")` to check if project exists
   - Store result in cache with current timestamp and 10-minute TTL
   - Update cache hit/miss metrics
   - If not found, create project: `manage_project("create", title="{feature-name}", description="...")`
   - Invalidate project lookup cache after creation
   - Store project_id

3. **Break down implementation tasks**:
   - Extract implementation tasks from PRP Implementation Blueprint
   - Add dependencies between tasks
   - Estimate effort for each task (30 min - 4 hours)
   - Assign task_order (higher = higher priority, 0-100)

4. **Create tasks in Archon with caching**:
   - For each task in implementation plan:
     - Generate cache key: `create_task:{project_id}:{task-title}`
     - Check cache for existing task creation
     - If cache hit and TTL valid (15 minutes), skip creation (task already exists)
     - If cache miss or TTL expired, create task: `manage_task("create", project_id="{project_id}", title="{task-title}", description="{task-description}", task_order={priority})`
     - Store result in cache with current timestamp and 15-minute TTL
     - Update cache hit/miss metrics
     - Store returned task_id

5. **Generate task plan document**:
   - Create markdown table with tasks:
     - Task ID
     - Task title
     - Dependencies
     - Estimated effort
     - Status

**Expected Result**: Tasks created in Archon MCP and task plan document generated.

### Step 6: Create Execution Folder with Task Files

Create local execution folder with individual task files for visibility and tracking:

1. **Create execution folder**:
   - Create `features/{feature-name}/execution/` directory

2. **Create INDEX.md**:
   - List all tasks with links to individual files
   - Include project ID and workflow instructions

3. **Create individual task files**:
   - For each task, create `{order}-{task-slug}.md`
   - Include: Task ID, Priority, Status, Dependencies
   - Include: Description, Steps, Deliverables
   - Include: "On Completion" section with:
     - Command to mark done in Archon
     - Instruction to delete the file
     - Next task reference

4. **Task file naming convention**:
   - Format: `{order:02d}-{task-slug}.md`
   - Example: `01-run-sql-migration.md`, `02-create-learn-command.md`

**Expected Result**: Execution folder created with task files for local tracking.

**Workflow**: 
- Tasks exist in both Archon (source of truth) AND execution folder (local visibility)
- When task completes: Mark done in Archon → Delete the file
- When all task files deleted: Feature is complete

### Step 7: Save Documents and Update Status

Save PRP and task plan, update feature STATUS:

1. **Save PRP document**:
   - Save to `features/{feature-name}/prp.md`
   - Verify file created successfully

2. **Save task plan document**:
   - Save to `features/{feature-name}/task-plan.md`
   - Verify file created successfully

3. **Update STATUS.md**:
   - Read existing `features/{feature-name}/STATUS.md` or create new
   - Add Task Planning phase:
     - Mark as "Task Planning - Completed"
     - List tasks created with IDs
     - Link to PRP and task plan documents
   - Update artifacts list
   - Add timestamp

**Expected Result**: Documents saved, STATUS.md updated.

## Output Format

### PRP Document

```markdown
# PRP: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp} | **Related**: PRD.md, TECH-SPEC.md

## Goal
{Goal section populated from context}

## All Needed Context
{Context section populated with codebase patterns}

## Implementation Blueprint
{Implementation Blueprint section populated from Tech Spec and PRD}

## Validation Loop
{Validation Loop section populated from codebase patterns}

## Anti-Patterns
{Anti-patterns section populated from template}
```

### Task Plan Document

```markdown
# Task Plan: {feature-name}

**Generated**: {timestamp}
**PRP Version**: 1.0
**Total Tasks**: {count}
**Archon Project ID**: {project-id}

## Task List

| Task ID | Task Title | Dependencies | Priority | Estimate | Status |
|----------|------------|--------------|----------|-----------|--------|
| {id} | {title} | {deps} | {priority} | {estimate} | {status} |

## Execution Order

1. Task {id}: {title}
2. Task {id}: {title}
3. Task {id}: {title}
... (repeat for all tasks in dependency order)

## Next Steps
- Execute Task 1 (no dependencies)
- Proceed through tasks in dependency order
- Track progress in Archon MCP
```

## Error Handling

- **Prime Export Not Found**: Check `context/` directory, list available exports, suggest running `/prime`
- **PRD Not Found**: Check `features/{feature-name}/` directory, error and stop
- **Tech Spec Not Found**: Check `features/{feature-name}/` directory, error and stop
- **Pattern Extraction Fails**: Log warning, continue with limited codebase awareness
- **PRP Template Not Found**: Check `templates/prp/` directory, error and stop
- **Archon MCP Unavailable**: Stop execution, inform user, wait for availability (per ARCHON-FIRST RULE)
- **Task Creation Fails**: Log error, continue with task plan only

## Notes

- CRITICAL: Always use Archon MCP for task management (ARCHON-FIRST RULE)
- Never use TodoWrite fallback
- PRP provides codebase-aware implementation guidance
- Tasks are created with dependencies for proper execution order
- Task IDs from Archon MCP are used during Execution command
- STATUS.md tracks phase progress
- Task plan document provides offline reference
- Each task should represent 30 minutes to 4 hours of work
- Higher task_order = higher priority
- Only ONE task in 'doing' status at a time
