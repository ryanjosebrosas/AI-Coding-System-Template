---
name: planning
description: "Generate PRD through interactive conversational probing"
user-invocable: true
disable-model-invocation: false
---

# Planning Skill

Transform discovery insights into a PRD through **interactive conversation**. Asks probing questions one at a time, follows up based on answers, and challenges assumptions before generating.

## Prerequisites

- Discovery document exists (`discovery/discovery-*.md`)
- MVP.md exists at root

## Execution Flow

```
1. Load Context (discovery, MVP)
2. Interactive Probing (5 areas)
3. Confirm Understanding
4. Generate PRD
5. Validate Quality
```

## Step 1: Load Context

1. Find most recent `discovery/discovery-*.md`
2. Load and parse opportunities, ideas, needs
3. Load `MVP.md` for scope reference
4. **Load previous probing context** (see `.claude/utils/context-carryforward.md`)
   - Check if `features/{feature}/STATUS.md` exists with "Probing Context"
   - If discovery context exists, reference it: "Your discovery mentioned [X]..."
   - Don't re-ask questions already answered

## Step 2: Interactive Probing

Ask questions **one at a time**. Follow up based on answers. See `probing-questions.md` for full question bank.

### 2.1 Personas
- "Who will use this feature? Describe 2-3 user types."
- Follow-up: "What's their technical level? What problems do they face?"

### 2.2 Features
- "What are the 3-5 key features this needs?"
- Challenge: "Why [feature X]? What problem does it solve?"

### 2.3 Success Criteria
- "What does success look like? How will you measure it?"
- Follow-up: "Can you give a specific, measurable outcome?"

### 2.4 Constraints
- "Any constraints? Timeline, team size, tech limitations?"
- Follow-up: "What's off the table?"

### 2.5 Inspo Repo (Optional)
- "Do you have an inspo repo? (GitHub URL)"
- If yes: Run analyzer (`.claude/utils/inspo-repo-analyzer.md`)
- Ask which aspects to adopt: file structure, tech stack, architecture

### Follow-Up Logic

| Answer Type | Response |
|------------|----------|
| Vague ("good", "works") | "Be more specific. What does 'good' mean for [persona]?" |
| Generic ("all users") | "Who uses this most? Give one specific user type." |
| New area revealed | Probe deeper with 1-2 follow-ups |
| Sufficient detail | Acknowledge, move to next question |
| "I don't know" | Suggest 2-3 options based on context |
| User wants to skip | Warn of consequences, accept if confirmed |
| Conflicting info | Point out conflict, ask for priority |

For detailed edge case handling, see `.claude/utils/probing-edge-cases.md`.

## Step 3: Confirm Understanding

```
"Let me confirm what I've gathered:

- **Personas**: [list]
- **Key Features**: [prioritized list]
- **Success Criteria**: [specific, measurable]
- **Constraints**: [timeline, team, tech]
- **Inspo**: [repo or none]

Does this capture your vision? Any adjustments?"
```

If confirmed → generate PRD
If adjusted → update and re-confirm

## Step 4: Generate PRD

1. Extract feature name (kebab-case)
2. Create `features/{feature-name}/` directory
3. Initialize STATUS.md
4. **Save probing context** to STATUS.md under "## Probing Context"
5. Research PRD templates via RAG
6. Generate PRD with all gathered context
7. Save to `features/{feature-name}/prd.md`

### PRD Structure

```markdown
# PRD: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp}

## Overview
{From probing: vision and goals}

## User Personas
{From probing: personas with descriptions}

## User Stories
{Generated from personas and features}
"As [persona], I want [goal] so that [benefit]"
+ Acceptance criteria

## Features
{From probing: prioritized features}
Priority: High/Medium/Low

## Technical Requirements
{Derived from features and constraints}

## Dependencies
{From constraints and inspo analysis}

## Risks & Assumptions
{From constraints discussion}
```

## Step 5: Validate PRD

Run validation checks:
- All sections present
- User stories have acceptance criteria
- Features have priorities
- Line count < 600

If validation passes → update STATUS.md, proceed to Development
If validation fails → show issues, offer to fix

## Error Handling

| Error | Response |
|-------|----------|
| No discovery doc | "Run /discovery first" |
| Feature exists | "Choose different name" |
| Vague answers persist | Accept with note in PRD |
| Inspo repo fails | "Describe it manually or skip" |

## Output

- `features/{feature-name}/prd.md` - Product Requirements Document
- `features/{feature-name}/STATUS.md` - Phase tracking
- Updated `features/INDEX.md`
