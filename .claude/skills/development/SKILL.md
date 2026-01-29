---
name: development
description: "Generate Tech Spec through interactive tech stack validation"
user-invocable: true
disable-model-invocation: false
---

# Development Skill

Generate a Tech Spec by **challenging tech decisions** through conversation. Questions your stack choices, suggests alternatives, and validates decisions before generating.

## Prerequisites

- PRD exists (`features/{feature-name}/prd.md`)
- MVP.md exists at root

## Execution Flow

```
1. Load PRD
2. Interactive Probing (tech decisions)
3. Confirm Decisions
4. Research Patterns (RAG + Web)
5. Generate Tech Spec
6. Validate Quality
```

## Step 1: Load PRD

1. Load `features/{feature-name}/prd.md`
2. Parse personas, features, requirements
3. Extract technical needs and constraints
4. **Load previous probing context** from `STATUS.md`
   - If planning context exists, reference it: "Your PRD targets [personas]..."
   - Reference constraints: "You mentioned [timeline], [team size]..."
   - Don't re-ask questions already answered

## Step 2: Interactive Probing

Ask about tech decisions **one at a time**. Challenge each answer. See `probing-questions.md`.

### 2.1 Tech Stack
- "What tech stack are you considering? (frontend, backend, database)"
- Challenge: "Why [X]? What problem does it solve that alternatives don't?"

### 2.2 Architecture
- "What architecture pattern? (monolith, microservices, serverless)"
- Challenge: "You mentioned [constraint] but chose [architecture]. How does that fit?"

### 2.3 Constraints
- "What constraints? (team skills, budget, timeline, infrastructure)"
- Challenge: "Your timeline is [Z], but [tech] has a learning curve. Factored in?"

### 2.4 Keep It Simple
- "Is there a simpler approach? What's the minimum viable tech stack?"
- Challenge: "Do you need [complex solution] or would [simple] work?"

### 2.5 Inspo Repo (Optional)
- "Have an inspo repo for architecture or structure?"
- If yes: Run analyzer, ask which aspects to adopt

### Challenge Logic

| User Choice | Challenge |
|-------------|-----------|
| Popular/default stack | "Why [X] over [Y]? Familiarity or requirements?" |
| Complex solution | "Seems complex. Would [simpler] work?" |
| "I don't know" | "Let me research and suggest options..." |
| Well-defended choice | "Good reasoning. Let's proceed." |
| Conflicting constraints | Point out conflict, ask for priority |
| User wants to skip | Warn of consequences, accept if confirmed |
| Bad inspo repo | Explain error, offer manual description |

For detailed edge case handling, see `.claude/utils/probing-edge-cases.md`.

### Web Search for Alternatives
```
"You chose [stack]. Let me check for better fits..."
Search: "[requirement] tech stack comparison 2026"
"Alternatives: [A], [B], [C]. Still want [original]?"
```

## Step 3: Confirm Decisions

```
"Let me confirm technical decisions:

- **Frontend**: [choice] - Reason: [reasoning]
- **Backend**: [choice] - Reason: [reasoning]
- **Database**: [choice] - Reason: [reasoning]
- **Architecture**: [pattern] - Reason: [reasoning]
- **Constraints**: [list]
- **Inspo**: [repo or none]

These drive the Tech Spec. Any changes?"
```

If confirmed → proceed
If changed → update and re-confirm

## Step 4: Research Patterns

1. RAG search: `rag_search_knowledge_base(query="architecture patterns")`
2. Code examples: `rag_search_code_examples(query="tech stack")`
3. Web search: Stack recommendations, comparisons
4. Combine with validated user decisions

## Step 4.5: Save Probing Context

Save tech decisions to `STATUS.md` under "## Probing Context → From Development":
- Tech stack choices with reasoning
- Architecture decisions
- Inspo aspects applied

## Step 5: Generate Tech Spec

### Tech Spec Structure

```markdown
# Technical Specification: {feature-name}

**Version**: 1.0 | **Last Updated**: {timestamp}

## System Architecture
{Pattern chosen, with justification from probing}

## Technology Stack
{User's validated choices}
- Frontend: [choice] - [user's reasoning]
- Backend: [choice] - [user's reasoning]
- Database: [choice] - [user's reasoning]

### MCP Servers
Required: [list]
Optional: [list]

## File System Structure
{From inspo repo or best practices}

## Data Models
{Derived from PRD requirements}

## Implementation Approach
{Based on architecture and constraints}

## Error Handling
{Strategy based on stack choices}

## Performance Considerations
{Based on constraints}

## Security Considerations
{Based on requirements}
```

## Step 6: Validate Tech Spec

Run validation:
- All sections present
- Tech choices documented with reasoning
- Line count < 600

If passes → update STATUS.md, proceed to Task Planning
If fails → show issues, offer to fix

## Error Handling

| Error | Response |
|-------|----------|
| PRD not found | "Run /planning first" |
| No tech preference | Research and suggest options |
| Inspo repo fails | "Describe it manually or skip" |
| Conflicting choices | "I notice a conflict: [X] vs [Y]. Which is priority?" |

## Output

- `features/{feature-name}/tech-spec.md` - Technical Specification
- Updated STATUS.md with Development phase complete
