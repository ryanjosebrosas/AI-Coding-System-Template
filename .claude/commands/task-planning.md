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

## Execution Steps

### Step 1: Load All Contexts

Load Prime, Discovery, PRD, and Tech Spec for comprehensive context:

1. **Load Prime export**:
   - Find most recent `context/prime-*.md`
   - Read and parse Prime export
   - Extract: Project tree, file contents, index statistics
   - Store in memory

2. **Load Discovery document** (if available):
   - Find most recent `discovery/discovery-*.md`
   - Read and parse Discovery document
   - Extract: Ideas, Inspiration Sources, Needs Analysis, Opportunities
   - Store in memory

3. **Load PRD**:
   - Read `features/{feature-name}/prd.md`
   - Parse PRD structure
   - Extract: Overview, User Stories, Features, Technical Requirements, Acceptance Criteria
   - Store in memory

4. **Load Tech Spec**:
   - Read `features/{feature-name}/tech-spec.md`
   - Parse Tech Spec structure
   - Extract: System Architecture, Technology Stack, Command Structure, File System Structure, Data Models, MCP Integration
   - Store in memory

5. **Combine contexts**:
   - Merge all contexts into single context object
   - Organize by source (Prime, Discovery, PRD, Tech Spec)
   - Prepare for pattern extraction and PRP generation

**Expected Result**: All contexts loaded and combined.

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

1. **Populate base sections**:
   - Goal: Fill from PRD Overview and success criteria
   - Deliverable: Fill from PRD features and requirements
   - Success Criteria: Fill from PRD acceptance criteria
   - Documentation URLs: Add relevant links from Discovery and web research
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

Break down implementation tasks and create in Archon MCP:

1. **Verify Archon MCP availability**:
   - Call `health_check()` to verify server is available
   - If unavailable, stop and inform user (per ARCHON-FIRST RULE)

2. **Create or find project**:
   - Call `find_projects(query="{feature-name}")` to check if project exists
   - If not found, create project: `manage_project("create", title="{feature-name}", description="...")`
   - Store project_id

3. **Break down implementation tasks**:
   - Extract implementation tasks from PRP Implementation Blueprint
   - Add dependencies between tasks
   - Estimate effort for each task (30 min - 4 hours)
   - Assign task_order (higher = higher priority, 0-100)

4. **Create tasks in Archon**:
   - For each task in implementation plan:
     - Create task: `manage_task("create", project_id="{project_id}", title="{task-title}", description="{task-description}", task_order={priority})`
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
