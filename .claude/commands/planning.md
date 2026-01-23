---
name: Planning
description: "Transform discovery insights into comprehensive PRD (Product Requirements Document)"
phase: planning
dependencies: [discovery]
outputs:
  - path: "features/{feature-name}/prd.md"
    description: "Product Requirements Document with features, user stories, acceptance criteria, and technical requirements"
  - path: "features/{feature-name}/STATUS.md"
    description: "Feature status tracking file initialized with Planning phase"
  - path: "features/INDEX.md"
    description: "Updated index of all features"
inputs:
  - path: "discovery/discovery-{timestamp}.md"
    description: "Most recent discovery document with ideas, opportunities, and needs analysis"
    required: true
---

# Planning Command

## Purpose

Transform discovery insights into a comprehensive PRD (Product Requirements Document). This command loads the discovery document, extracts the feature name, creates the feature directory structure, researches PRD templates using RAG knowledge base and web MCP servers, generates PRD with features, user stories, acceptance criteria, and technical requirements, and updates indexes and STATUS.md.

**When to use**: Use this command after Discovery phase, when you have identified opportunities and want to create formal requirements for a feature.

**What it solves**: This command addresses the need to transform exploratory findings into actionable, structured requirements that guide implementation.

## Prerequisites

- Discovery command must have been run (at least one `discovery/discovery-*.md` file must exist)
- Archon MCP server should be available (for RAG knowledge base)
- Web MCP servers should be available (for web research)
- `features/` directory must exist (created in Task 01)

## Execution Steps

### Step 1: Load Discovery Document

**Objective**: Load the most recent discovery document for PRD generation.

**Actions**:
1. Find most recent discovery document in `discovery/` matching `discovery-*.md`
2. Load and parse: Ideas, Inspiration Sources, Needs Analysis, Opportunities, Prioritization
3. Extract key information: Opportunities, Ideas, Needs, Inspiration sources

**Expected Result**: Discovery document loaded and parsed.

### Step 2: Extract Feature Name

**Objective**: Extract and validate feature name.

**Actions**:
1. Extract feature name from discovery or generate from primary opportunity
2. Convert to kebab-case (lowercase, hyphens for spaces)
3. Validate no conflicts (check if `features/{feature-name}/` exists)

**Expected Result**: Valid feature name in kebab-case format.

### Step 3: Create Feature Directory Structure

**Objective**: Create feature directory and initialize STATUS.md.

**Actions**:
1. Create `features/{feature-name}/` directory
2. Initialize STATUS.md using STATUS.md generator (Task 03)
3. Set initial phase: "Planning", mark Prime/Discovery completed

**Expected Result**: Feature directory created, STATUS.md initialized.

### Step 4: Research PRD Templates (RAG + Web)

**Objective**: Find PRD templates and best practices.

**Actions**:
1. Search RAG: `rag_search_knowledge_base(query="PRD template", match_count=5, return_mode="pages")`
2. Search web: `web_search_prime_search(query="PRD template best practices")`
3. Read relevant pages: `rag_read_full_page()` and `web_reader_read()`
4. Extract: PRD structure, sections, format guidelines

**Expected Result**: PRD templates and best practices gathered.

### Step 5: Generate PRD Content

**Objective**: Generate comprehensive PRD using AI analysis.

**Actions**:
1. Combine: Discovery + PRD templates + Best practices
2. Prompt AI: "Generate PRD with Overview, User Personas, User Stories with acceptance criteria, Features with priorities, Technical Requirements, Dependencies, Risks & Assumptions"
3. Format PRD as markdown with proper structure

**Expected Result**: Complete PRD content generated.

### Step 6: Save PRD and Update Status

**Objective**: Save PRD and update tracking files.

**Actions**:
1. Save PRD to `features/{feature-name}/prd.md`
2. Update `features/INDEX.md` with feature entry
3. Update STATUS.md: add prd.md artifact, mark Planning complete, set current to Development

**Expected Result**: PRD saved, indexes updated, status tracking updated.

## Output Format

**File**: `features/{feature-name}/prd.md`

**Structure**:
```markdown
# PRD: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp}

## Overview
{Feature overview}

**Goals**: {list}
**Success Metrics**: {metrics}

## User Personas
**Engineer**: {description}
**Marketer**: {description}
**PM**: {description}

## User Stories
### US-1: {Title}
**As** {persona}, **I want** {goal} **so that** {benefit}.
**Acceptance**: {criteria}

## Features
### Feature 1: {Name}
{Description}. **Priority**: High/Medium/Low

## Technical Requirements
**Data Models**: {description}
**Integrations**: {description}
**Performance**: {description}
**Security**: {description}

## Dependencies
**Required**: {list}
**Optional**: {list}

## Risks & Assumptions
**Risks**: {list}
**Assumptions**: {list}
```

## Error Handling

### No Discovery Document
- Error: "No discovery document found. Run /discovery command first."

### Feature Name Conflict
- Error: "Feature '{name}' already exists. Choose different name."

### PRD Generation Fails
- Retry with shorter context
- Use template structure with discovery content
- Generate partial PRD

## MCP Tool Reference

| Tool | Purpose | Query |
|------|---------|-------|
| `rag_search_knowledge_base()` | Find PRD templates | "PRD template" |
| `web_search_prime_search()` | Find best practices | "PRD template best practices" |
| `rag_read_full_page()` | Get full content | Use page_id from search |
| `web_reader_read()` | Read web content | Use URL from search |

## Examples

**Command**: `/planning ai-coding-workflow-system`

**Output**:
- Loads discovery document
- Creates `features/ai-coding-workflow-system/`
- Generates PRD with 11 user stories, 11 features, technical requirements
- Updates INDEX.md and STATUS.md

## Notes

- Feature name must be kebab-case
- PRD follows standard format: Overview, Personas, User Stories, Features, Technical Requirements, Dependencies, Risks
- User stories format: "As {persona}, I want {goal} so that {benefit}"
- Each user story has acceptance criteria
- Features prioritized: High/Medium/Low
- PRD serves as foundation for Development and Task Planning phases

## Validation

After Planning command:
- [ ] Feature directory created
- [ ] PRD file created with all sections
- [ ] User stories have acceptance criteria
- [ ] Features have priorities
- [ ] INDEX.md updated
- [ ] STATUS.md updated with Planning completed
