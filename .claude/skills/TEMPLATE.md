# Skill Template

Use this template to create new skills. Skills are Claude Code's way of adding custom slash commands that can be invoked with `/{skill-name}`.

## Frontmatter

```yaml
---
name: {command-name}
description: "{Brief description of what this skill does}"
user-invocable: true
disable-model-invocation: false
---
```

**Required fields**:
- `name`: Skill name (lowercase, hyphens for spaces)
- `description`: Brief description shown in `/help`

**Optional fields**:
- `user-invocable`: `true` (default) - Can be invoked with `/{name}`
- `disable-model-invocation`: `false` (default) - Claude can suggest this skill

## Skill File Structure

```
.claude/skills/{skill-name}/
├── SKILL.md              # Main skill file (<500 lines)
├── probing-questions.md  # Question bank for interactive skills (optional)
└── templates/            # Supporting template files (optional)
    └── output.md         # Template for generated output
```

## Example Skill: planning

```markdown
---
name: planning
description: "Transform discovery insights into PRD through interactive conversation"
user-invocable: true
---

# Planning Skill

## Purpose
Generate a PRD (Product Requirements Document) by engaging the user in a conversational probing session.

## Execution Steps

### Step 1: Load Context
Load discovery document and MVP definition.

### Step 2: Interactive Probing
Ask probing questions one at a time:
1. Personas
2. Features
3. Success criteria
4. Constraints
5. Inspo repos

### Step 3: Generate PRD
After confirming understanding, generate the PRD.
```

## Guidelines

1. **Keep skills under 500 lines** - Split into supporting files if needed
2. **Interactive skills**: Include probing questions that:
   - Ask one question at a time
   - Follow up based on answers
   - Challenge vague or default responses
3. **Reference utilities**: Link to `.claude/utils/` for shared functionality
4. **Backward compatibility**: Skills should work alongside existing commands
