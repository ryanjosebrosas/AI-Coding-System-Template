---
name: task-planning
description: "Create PRP and tasks from PRD and Tech Spec"
user-invocable: true
disable-model-invocation: false
---

# Task Planning Skill

Combine all contexts (Prime, Discovery, PRD, Tech Spec) into actionable tasks with PRP guidance.

## Execution Flow

1. **Load Contexts** - PRD, Tech Spec, Discovery, Prime
2. **Extract Patterns** - Codebase conventions and structure
3. **Select PRP Template** - Based on feature type
4. **Generate PRP** - Implementation blueprint
5. **Create Archon Project** - Track in Archon MCP
6. **Create Tasks** - Break down into 30min-4hr tasks
7. **Generate Task Files** - Local execution folder

## PRP Templates

| Feature Type | Template |
|-------------|----------|
| AI Agent | `templates/prp/prp-ai-agent.md` |
| MCP Integration | `templates/prp/prp-mcp-integration.md` |
| API Endpoint | `templates/prp/prp-api-endpoint.md` |
| Frontend | `templates/prp/prp-frontend-component.md` |
| Generic | `templates/prp/prp-base.md` |

## Task Status Flow

`todo` → `doing` → `review` → `done`

## Output

- `features/{feature}/prp.md` - Plan Reference Protocol
- `features/{feature}/task-plan.md` - Task breakdown
- `features/{feature}/execution/` - Individual task files
- Tasks created in Archon MCP

## Reference

Full implementation details: `.claude/commands/task-planning.md`
