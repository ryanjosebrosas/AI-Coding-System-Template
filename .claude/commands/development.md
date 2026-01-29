---
name: Development
description: "Analyze PRD requirements and generate comprehensive Tech Spec with technology stack recommendations"
phase: development
dependencies:
  - planning
outputs:
  - path: "TECH-SPEC.md"
    description: "Technical Specification at root with system architecture, technology stack, implementation details, and recommendations"
  - path: "TECH-SPEC-validation-report.md"
    description: "Quality validation report with scores, issues, and improvement suggestions"
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

Analyze PRD requirements and generate a comprehensive Tech Spec through **interactive conversation**. This command engages you in a probing session - challenging your tech stack choices, questioning architecture decisions, and suggesting alternatives - before generating the Tech Spec. The goal is to ensure technical decisions are deliberate, not default.

**When to use**: Use this command after Planning phase, when you have a PRD and need technical specifications to guide implementation.

**What it solves**: This command addresses the need to translate requirements into technical blueprints with architecture and technology recommendations. The interactive probing ensures technical decisions are justified and appropriate for your constraints.

**Interactive Approach**: Instead of just researching and recommending, this command:
1. Asks about your tech stack preferences and constraints
2. Challenges your choices ("Why this stack?")
3. Suggests alternatives via web search when appropriate
4. Validates decisions before generating the Tech Spec

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

### Step 1.5: Interactive Probing (Technical Decisions)

**Objective**: Challenge and validate technical decisions through conversation. Ask one question at a time, follow up based on answers, challenge assumptions.

**Probing Flow**:
```
INIT → Load PRD context
PROBE → Ask about tech choice
CHALLENGE → "Why that choice?"
SUGGEST → Offer alternatives (web search)
VALIDATE → User defends or accepts
REPEAT → Until all decisions validated
CONFIRM → Summarize tech decisions
GENERATE → Create Tech Spec
```

**Probing Questions** (ask one at a time, challenge each answer):

1. **Tech Stack Preferences** (start here):
   - "What tech stack are you considering? (frontend, backend, database)"
   - Challenge: "Why [technology X]? What problem does it solve that alternatives don't?"
   - If no preference: "Let me research options based on your requirements and suggest some..."

2. **Architecture Pattern** (after stack):
   - "What architecture pattern fits this feature? (monolith, microservices, serverless, etc.)"
   - Challenge if mismatch: "You mentioned [constraint] but chose [architecture]. How does that work together?"
   - Suggest: "Based on [PRD requirements], have you considered [alternative]?"

3. **Constraints** (after architecture):
   - "What constraints should I know about? (team skills, budget, timeline, existing infrastructure)"
   - Follow-up: "How does your tech choice [X] fit with [constraint Y]?"
   - Challenge: "Your timeline is [Z], but [technology] has a steep learning curve. Is that factored in?"

4. **Keep It Simple Check**:
   - "Is there a simpler approach that would work? What's the minimum viable tech stack?"
   - Challenge over-engineering: "Do you really need [complex solution] or would [simple solution] work?"

5. **Inspo Repo for Structure** (optional):
   - "Do you have an inspo repo we should reference for architecture or file structure?"
   - **If yes**: Run inspo repo analyzer (see `.claude/utils/inspo-repo-analyzer.md`)
     ```bash
     gh repo view owner/repo --json name,description,languages
     gh api repos/owner/repo/contents
     gh api repos/owner/repo/contents/package.json --jq '.content' | base64 -d
     ```
   - Present analysis and ask: "What aspects do you want to adopt?"
     - **File structure** → Use as template in Tech Spec file structure section
     - **Tech stack** → Validate against user's choices, suggest if matches requirements
     - **Architecture patterns** → Incorporate in System Architecture section
   - **If no**: Proceed without, or ask about similar products/tools
   - Store selected aspects for Tech Spec generation

**Challenge Logic**:
- **User picks popular/default stack**: "Why [X] over [Y]? Is this based on familiarity or requirements?"
- **User picks complex solution**: "This seems complex for the requirements. Would [simpler alternative] work?"
- **User says 'I don't know'**: "Let me research based on your PRD requirements and suggest options..."
- **User defends choice well**: Acknowledge and move on: "Good reasoning. Let's proceed with [choice]."

**Web Search for Alternatives**:
When user picks a stack, optionally search for alternatives:
```
"You chose [stack]. Let me check if there are better fits for [specific requirement]..."
Search: "[requirement] tech stack comparison 2026"
Present: "Here are some alternatives: [A], [B], [C]. Still want to proceed with [original]?"
```

**Confirmation Before Generation**:
After all technical decisions are validated:
```
"Let me confirm the technical decisions:

- **Frontend**: [choice] - Reason: [user's reasoning]
- **Backend**: [choice] - Reason: [user's reasoning]
- **Database**: [choice] - Reason: [user's reasoning]
- **Architecture**: [pattern] - Reason: [user's reasoning]
- **Constraints**: [list]
- **Inspo**: [repo or none]

These decisions will drive the Tech Spec. Any changes before I generate?"
```

If user confirms → proceed to research and generation
If user changes → update and re-confirm

**Expected Result**: Technical decisions validated through conversation, user owns the choices.

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
2. Update STATUS.md: add tech-spec.md artifact
3. Do NOT mark Development complete yet (validation required first)

**Expected Result**: Tech spec saved, status updated with artifact added.

### Step 7: Validate Generated Tech Spec

**Objective**: Ensure the generated Tech Spec meets quality standards before marking Development complete.

**Actions**:
1. Call the `/validate` command with the generated Tech Spec:
   - Artifact path: `features/{feature-name}/tech-spec.md`
   - Artifact type: TECH-SPEC
2. Wait for validation results
3. Handle validation outcome:
   - **If PASS**:
     - Display success message with quality score
     - Update STATUS.md: mark Development complete, set current to Task Planning
     - Proceed to Task Planning phase
   - **If FAIL**:
     - Display validation failure with critical issues
     - Show immediate action items from validation report
     - Ask user to choose:
       1. Fix issues and re-validate
       2. Override and proceed (requires acknowledgment)
     - If user chooses to fix → await corrections, then re-run validation
     - If user chooses override → require explicit acknowledgment phrase
   - **If CONDITIONAL**:
     - Display validation conditional with high priority issues
     - Show recommended improvements
     - Ask user to choose:
       1. Fix issues and re-validate (recommended)
       2. Override and proceed
     - If user chooses to fix → await corrections, then re-run validation
     - If user chooses override → proceed with warning
4. Document validation outcome in STATUS.md:
   - Add validation status: PASS/FAIL/CONDITIONAL/OVERRIDE
   - Add quality score
   - Add validation report path: `features/{feature-name}/tech-spec-validation-report.md`

**Expected Result**: Tech spec validated, quality ensured, STATUS.md updated with validation outcome, Development marked complete (or override acknowledged).

**Error Handling**:
- If validation command fails → log error, mark validation as FAILED, prompt user to run `/validate` manually
- If validation framework incomplete → warn user, mark Development complete with note to validate later

## Output Format

**File**: `TECH-SPEC.md` (at root)

**Structure**:
```markdown
# Technical Specification: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp}

## System Architecture
{Architecture description with principles and diagram}

## Technology Stack
- **Claude Code**: {description}
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

### Validation Fails
- Display validation failure with critical issues
- Show immediate action items from validation report
- Prompt user to fix issues or override with acknowledgment
- If user fixes issues → re-run validation
- If user overrides → require explicit acknowledgment: "I acknowledge the quality issues and accept responsibility"

### Validation Conditional
- Display validation conditional with high priority issues
- Show recommended improvements
- Prompt user to fix issues (recommended) or override
- Document override decision in STATUS.md if user proceeds

### Validation Framework Unavailable
- Warning: "Validation framework unavailable. Proceeding without validation."
- Mark Development complete with note: "Validation pending - run /validate manually"
- Advise user to run `/validate features/{feature-name}/tech-spec.md` when framework is available

## MCP Tool Reference

| Tool | Purpose | Query |
|------|---------|-------|
| `rag_search_knowledge_base()` | Architecture patterns | "architecture patterns" |
| `rag_search_code_examples()` | Tech stack examples | "tech stack" |
| `web_search_prime_search()` | Stack recommendations | "tech stack recommendations AI agents" |
| `web_reader_read()` | Read documentation | URL from search |
| `zread_read()` | Advanced reading | URL from search |
| `/validate` command | Validate tech spec quality | `features/{feature-name}/tech-spec.md` |

## Examples

**Command**: `/development ai-coding-workflow-system`

**Output**:
- Loads PRD
- Researches architecture patterns and tech stacks
- Generates tech spec with system architecture, technology stack, MCP integration
- Saves to `features/ai-coding-workflow-system/tech-spec.md`
- Validates tech spec quality
- If validation passes:
  - Displays: "✅ Validation passed! Quality Score: 85/100"
  - Marks Development complete in STATUS.md
- If validation fails:
  - Displays: "❌ Validation failed. Critical issues must be addressed."
  - Shows immediate action items
  - Prompts for fix or override

## Notes

- Tech spec translates requirements into technical blueprints
- Architecture patterns should align with PRD requirements
- Technology recommendations should be justified based on needs
- MCP integration should be documented clearly
- Error handling and performance considered from start
- Security measures documented
- **Validation is automatic**: After generating Tech Spec, the `/validate` command runs automatically to ensure quality
- **Validation enforces YAGNI/KISS**: Tech specs must be concise (500-600 lines max) and avoid verbose content
- **Override mechanism**: If validation fails, users can override with explicit acknowledgment (not recommended)
- **Quality tracking**: Validation status and scores are recorded in STATUS.md for traceability
- **Fix and re-validate**: If validation fails, fix critical issues and re-run `/validate` before proceeding

## Validation

After Development command:
- [ ] Tech spec file created at `features/{feature-name}/tech-spec.md`
- [ ] All required sections present (System Architecture, Technology Stack, Command Structure, File System Structure, Data Models, MCP Integration, Command Implementation, Error Handling)
- [ ] Architecture documented with principles and diagrams
- [ ] Technology stack recommended with justification
- [ ] MCP integration documented (required and optional servers)
- [ ] Error handling documented
- [ ] Tech spec validated using `/validate` command
- [ ] Validation report generated at `features/{feature-name}/tech-spec-validation-report.md`
- [ ] Quality score meets threshold (≥ 70/100)
- [ ] STATUS.md updated with:
  - [ ] tech-spec.md artifact added
  - [ ] Development phase marked complete
  - [ ] Current phase set to Task Planning
  - [ ] Validation status (PASS/FAIL/CONDITIONAL/OVERRIDE)
  - [ ] Quality score recorded
  - [ ] Validation report path recorded
