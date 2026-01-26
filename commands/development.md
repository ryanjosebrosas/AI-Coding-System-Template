---
name: Development
description: "Analyze PRD requirements and generate comprehensive Tech Spec with technology stack recommendations"
phase: development
dependencies: [planning]
outputs:
  - path: "TECH-SPEC.md"
    description: "Technical Specification at root with system architecture, technology stack, implementation details, and recommendations"
inputs:
  - path: "PRD.md"
    description: "Product Requirements Document at root"
    required: true
  - path: "MVP.md"
    description: "MVP definition at root"
    required: true
---

# Development Command

## Purpose

Analyze PRD requirements and generate a comprehensive Tech Spec (Technical Specification). This command loads the PRD, uses RAG knowledge base and web MCP servers to research architecture patterns and tech stacks, recommends technology stack (backend, frontend, MCP servers, AI frameworks, models, agent architecture), and generates detailed tech spec with system architecture, technology stack, command structure, file system structure, data models, MCP integration, command implementation, error handling, performance, and security.

**When to use**: Use this command after Planning phase, when you have a PRD and need technical specifications to guide implementation.

**What it solves**: This command addresses the need to translate requirements into technical blueprints with architecture and technology recommendations.

## Prerequisites

- Planning command must have been run (PRD must exist at `features/{feature-name}/prd.md`)
- Archon MCP server should be available (for RAG knowledge base)
- Web MCP servers should be available (for web research)

## Execution Steps

### Step 1: Load PRD

**Objective**: Load the PRD document for analysis.

**Actions**:
1. Load `features/{feature-name}/prd.md`
2. Parse: Overview, User Personas, User Stories, Features, Technical Requirements, Dependencies, Risks
3. Extract: Technical needs, integration needs, data needs

**Expected Result**: PRD loaded and technical requirements extracted.

### Step 2: Research Architecture Patterns (RAG)

**Objective**: Find relevant architecture patterns.

**Actions**:
1. Search RAG: `rag_search_knowledge_base(query="architecture patterns", match_count=5)`
2. Search code examples: `rag_search_code_examples(query="tech stack", match_count=3)`
3. Read full pages: `rag_read_full_page(page_id="{page_id}")`
4. Extract: Architecture patterns, design patterns, best practices

**Expected Result**: Architecture patterns gathered.

### Step 3: Research Technology Stacks (Web)

**Objective**: Research tech stack options.

**Actions**:
1. Search web: `web_search_prime_search(query="tech stack recommendations AI agents")`
2. Read docs: `web_reader_read(url="{url}")` or `zread_read(url="{url}")`
3. Extract: Tech stack recommendations, framework comparisons

**Expected Result**: Tech stack research completed.

### Step 4: Recommend Technology Stack

**Objective**: Analyze requirements and recommend stack.

**Actions**:
1. Analyze backend needs (if any), recommend framework/database/API
2. Analyze frontend needs (if any), recommend framework/UI library
3. Analyze MCP server needs, recommend required/optional MCP servers
4. Analyze AI needs, recommend frameworks/models/architecture
5. Query AI for structured recommendations based on PRD + research

**Expected Result**: Technology stack recommendations generated.

### Step 5: Generate Tech Spec Content

**Objective**: Generate comprehensive tech spec.

**Actions**:
1. Structure sections: System Architecture, Technology Stack, Command Structure, File System Structure, Data Models, MCP Integration, Command Implementation, Error Handling, Performance, Security
2. Generate content for each section based on PRD + research + recommendations
3. Format as markdown with proper structure

**Expected Result**: Complete tech spec generated.

### Step 6: Save Tech Spec and Update Status

**Objective**: Save tech spec and update tracking.

**Actions**:
1. Save to `features/{feature-name}/tech-spec.md`
2. Update STATUS.md: add tech-spec.md artifact, mark Development complete, set current to Task Planning

**Expected Result**: Tech spec saved, status updated.

## Output Format

**File**: `TECH-SPEC.md` (at root)

**Structure**:
```markdown
# Technical Specification: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp}

## System Architecture
{Architecture description with principles and diagram}

## Technology Stack
- **AI Coding System**: {description}
- **Markdown**: {description}
- **YAML Frontmatter**: {description}
- **MCP**: {description}

### MCP Servers
**Required**: {list}
**Optional**: {list}

## Command Structure
{YAML frontmatter and markdown sections documentation}

## File System Structure
{Directory layout and naming conventions}

## Data Models
{STATUS.md, INDEX.md, PRP format documentation}

## MCP Integration
{Archon MCP and Web MCP tools documentation}

## Command Implementation
{Detailed steps for each command}

## Error Handling
{Error types, strategy, recovery}

## Performance
{Optimization and targets}

## Security
{Security measures}
```

## Error Handling

### PRD Not Found
- Error: "PRD not found. Run /planning command first."

### Invalid PRD Format
- Attempt to parse available sections
- Generate tech spec with available information
- Log warnings for missing sections

### Tech Spec Generation Fails
- Retry with shorter context
- Use template with PRD content
- Generate partial tech spec

## MCP Tool Reference

| Tool | Purpose | Query |
|------|---------|-------|
| `rag_search_knowledge_base()` | Architecture patterns | "architecture patterns" |
| `rag_search_code_examples()` | Tech stack examples | "tech stack" |
| `web_search_prime_search()` | Stack recommendations | "tech stack recommendations AI agents" |
| `web_reader_read()` | Read documentation | URL from search |
| `zread_read()` | Advanced reading | URL from search |

## Examples

**Command**: `/development ai-coding-workflow-system`

**Output**:
- Loads PRD
- Researches architecture patterns and tech stacks
- Generates tech spec with system architecture, technology stack, MCP integration
- Saves to `features/ai-coding-workflow-system/tech-spec.md`

## Notes

- Tech spec translates requirements into technical blueprints
- Architecture patterns should align with PRD requirements
- Technology recommendations should be justified based on needs
- MCP integration should be documented clearly
- Error handling and performance considered from start
- Security measures documented

## Validation

After Development command:
- [ ] Tech spec file created
- [ ] All sections present
- [ ] Architecture documented
- [ ] Technology stack recommended with justification
- [ ] MCP integration documented
- [ ] Error handling documented
- [ ] STATUS.md updated with Development completed
