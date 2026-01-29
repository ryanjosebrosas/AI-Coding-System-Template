---
name: Planning
description: "Transform discovery insights into comprehensive PRD (Product Requirements Document)"
phase: planning
dependencies:
  - discovery
outputs:
  - path: "PRD.md"
    description: "Product Requirements Document at root with features, user stories, acceptance criteria, and technical requirements"
  - description: "Quality validation report with pass/fail status, scores, and improvement suggestions"
inputs:
  - path: "discovery/discovery-{timestamp}.md"
    description: "Most recent discovery document with ideas, opportunities, and needs analysis"
    required: true
  - path: "MVP.md"
    description: "MVP definition at root"
    required: true
---

# Planning Command

## Purpose

Transform discovery insights into a comprehensive PRD (Product Requirements Document) through **interactive conversation**. This command engages you in a conversational probing session - asking questions one at a time, following up based on your answers, and challenging assumptions - before generating the PRD. The goal is to make AI your collaborative partner in requirements definition, not just a document generator.

**When to use**: Use this command after Discovery phase, when you have identified opportunities and want to create formal requirements for a feature.

**What it solves**: This command addresses the need to transform exploratory findings into actionable, structured requirements that guide implementation. The interactive probing ensures the PRD reflects your actual vision, not AI assumptions.

**Interactive Approach**: Instead of immediately generating a PRD, this command:
1. Asks probing questions about personas, features, success criteria
2. Follows up based on your answers (challenges vague responses)
3. Summarizes understanding and confirms before generating
4. Results in a PRD that captures your true intent

## Prerequisites

- Discovery command must have been run (at least one `discovery/discovery-*.md` file must exist)
- Archon MCP server should be available (for RAG knowledge base)
- Web MCP servers should be available (for web research)
- `features/` directory must exist (created in Task 01)
- Validation framework must be set up (validation rules and report template exist)

## Execution Steps

### Step 1: Load Discovery Document

**Objective**: Load the most recent discovery document for PRD generation.

**Actions**:
1. Find most recent discovery document in `discovery/` matching `discovery-*.md`
2. Load and parse: Ideas, Inspiration Sources, Needs Analysis, Opportunities, Prioritization
3. Extract key information: Opportunities, Ideas, Needs, Inspiration sources

**Expected Result**: Discovery document loaded and parsed.

### Step 1.5: Interactive Probing (Conversational Flow)

**Objective**: Engage user in conversation to gather context before PRD generation. Ask one question at a time, follow up based on answers, challenge assumptions.

**Probing Flow**:
```
INIT → Load context (discovery, MVP)
PROBE → Ask one question
LISTEN → Receive response
ANALYZE → Follow-up or next topic?
REPEAT → Until sufficient context
CONFIRM → Summarize understanding
GENERATE → Create PRD
```

**Probing Questions** (ask one at a time, follow up based on answers):

1. **Personas** (start here):
   - "Who will use this feature? Describe 2-3 user types."
   - Follow-up if vague: "What's their technical level? What problems do they face daily?"
   - Follow-up if generic: "Can you give a specific example of a user and their workflow?"

2. **Features** (after personas):
   - "What are the 3-5 key features this needs?"
   - Follow-up: "Which of these is the absolute must-have vs nice-to-have?"
   - Challenge: "Why [feature X]? What problem does it solve for [persona Y]?"

3. **Success Criteria** (after features):
   - "What does success look like? How will you know this feature is working?"
   - Follow-up if vague: "Can you give me a specific, measurable outcome?"
   - Follow-up: "How will [persona] know the feature is helping them?"

4. **Constraints** (after success):
   - "Are there any constraints? Timeline, team size, tech limitations?"
   - Follow-up: "What's off the table? What should we avoid?"

5. **Inspo Repo** (optional, ask at end):
   - "Do you have an inspiration repo we should reference? (GitHub URL)"
   - **If yes**: Run inspo repo analyzer (see `.claude/utils/inspo-repo-analyzer.md`)
     ```bash
     gh repo view owner/repo --json name,description,languages
     gh api repos/owner/repo/contents
     ```
   - Present analysis and ask: "What aspects do you want to adopt?"
     - File structure → Inform feature organization
     - Tech stack → Reference in Technical Requirements
     - Architecture patterns → Include in PRD scope
   - **If no**: "That's fine. Is there any existing product or tool that does something similar?"
   - Store selected aspects for PRD generation

**Follow-Up Logic**:
- **Vague answer** ("it should be good", "whatever works"): "Could you be more specific? For example, what does 'good' mean for [persona]?"
- **Generic answer** ("all users"): "Let's narrow it down. Who uses this most? Give me one specific user type."
- **New area revealed**: Probe deeper with 1-2 follow-up questions
- **Sufficient detail**: Acknowledge and move to next question

**Confirmation Before Generation**:
After all questions, summarize:
```
"Let me confirm what I've gathered:

- **Personas**: [list personas with descriptions]
- **Key Features**: [prioritized list]
- **Success Criteria**: [specific, measurable criteria]
- **Constraints**: [timeline, team, tech]
- **Inspo**: [repo or similar products]

Does this capture your vision? Any adjustments before I generate the PRD?"
```

If user says yes → proceed to PRD generation
If user adjusts → update understanding, re-confirm

**Expected Result**: Sufficient context gathered through conversation, user confirms understanding.

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

### Step 7: Validate PRD Quality

**Objective**: Validate the generated PRD against quality standards for completeness, clarity, accuracy, and consistency.

**Actions**:
1. Determine artifact type as PRD (from filename: `prd.md`)
2. Perform completeness check:
   - Verify all required PRD sections are present (Overview, User Personas, User Stories, Features, Technical Requirements, Dependencies, Risks & Assumptions)
   - Verify required subsections (Goals, Success Metrics in Overview)
   - Validate each user story has acceptance criteria
   - Validate each feature has priority level (High/Medium/Low)
   - Flag missing sections with severity (Critical/High)
5. Perform clarity check:
   - Count total non-blank lines in PRD
   - Validate against line limits (< 500 recommended, ≤ 600 maximum)
   - Detect verbose sections (> 20% of total lines)
   - Generate condensation suggestions for verbose sections
6. Perform accuracy check:
   - Validate technical details (user stories have acceptance criteria, features have priorities)
   - Check technical requirements are specific and testable
   - Flag accuracy issues with severity levels
7. Perform consistency check:
   - Check for internal contradictions
   - Validate terminology consistency
   - Validate requirement consistency
   - Flag inconsistencies with severity
8. Perform maintainability check:
   - Assess document organization and structure
   - Check for version information
   - Assess modularity and update-friendliness
   - Flag maintainability issues
9. Calculate quality scores:
   - Completeness score (30% weight)
   - Accuracy score (25% weight)
   - Consistency score (20% weight)
   - Clarity score (10% weight)
   - Maintainability score (15% weight)
   - Total quality score (weighted sum)
8. Generate validation report:
    - Populate with validation results
    - Include issues by severity (Critical, High, Medium, Low)
    - Generate improvement suggestions (Immediate, Short-Term, Long-Term)
    - Save report to `features/{feature-name}/prd-validation-report.md`
11. Display validation summary:
    - Show overall pass/fail status (PASS ≥ 70, no critical issues)
    - Show category scores and individual pass/fail
    - Show issue counts by severity
    - Show report location
12. Handle validation results:
    - **If PASS**: Display success message, proceed with workflow
    - **If FAIL or CONDITIONAL**: Display issues, prompt user for action:
      - Option 1: Fix issues and re-validate
      - Option 2: Override and proceed (requires acknowledgment)
      - Option 3: View detailed report first

**Expected Result**: PRD validated against quality standards, validation report generated, user informed of validation status and next steps.

## Output Format

**File**: `PRD.md` (at root)

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

### Validation Fails
- Display validation issues and recommendations
- Offer options: fix and re-validate, override (with acknowledgment), or view report
- If override, require explicit acknowledgment of quality issues
- Document override decision in validation report

### Validation Issues
- If validation fails, show issues and recommendations

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
- Validates PRD quality (completeness, clarity, accuracy, consistency, maintainability)
- Generates validation report: `features/ai-coding-workflow-system/prd-validation-report.md`
- Updates INDEX.md and STATUS.md
- Displays validation status: PASS/FAIL/CONDITIONAL with scores and issues

## Notes

- Feature name must be kebab-case
- PRD follows standard format: Overview, Personas, User Stories, Features, Technical Requirements, Dependencies, Risks
- User stories format: "As {persona}, I want {goal} so that {benefit}"
- Each user story has acceptance criteria
- Features prioritized: High/Medium/Low
- PRD serves as foundation for Development and Task Planning phases
- Validation is automatic after PRD generation, ensuring quality standards are met
- Validation checks: completeness, clarity, accuracy, consistency, maintainability
- Quality scores: Completeness (30%), Accuracy (25%), Consistency (20%), Clarity (10%), Maintainability (15%)
- Pass threshold: 70/100 overall score, no critical issues, all required sections present
- Override available with explicit acknowledgment (not recommended)

## Validation

After Planning command:
- [ ] Feature directory created
- [ ] PRD file created with all sections
- [ ] User stories have acceptance criteria
- [ ] Features have priorities
- [ ] INDEX.md updated
- [ ] STATUS.md updated with Planning completed
- [ ] PRD validated against quality standards
- [ ] Validation report generated at `features/{feature-name}/prd-validation-report.md`
- [ ] Quality scores calculated (Completeness, Accuracy, Consistency, Clarity, Maintainability)
- [ ] Pass/fail status determined (≥ 70 score, no critical issues)
- [ ] Issues flagged by severity (Critical, High, Medium, Low)
- [ ] Improvement suggestions generated (Immediate, Short-Term, Long-Term)
- [ ] User informed of validation status and next steps
