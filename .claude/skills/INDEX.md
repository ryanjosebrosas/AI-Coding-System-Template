# Skills Index

Skills are Claude Code's mechanism for custom slash commands. Invoke with `/{skill-name}`.

## Available Skills

| Skill | Description | Status |
|-------|-------------|--------|
| planning | Generate PRD through interactive probing | ✓ Created |
| development | Generate Tech Spec with tech stack validation | ✓ Created |
| discovery | Explore ideas through user interview | ✓ Created |
| prime | Export codebase context | ✓ Created |
| task-planning | Create PRP and tasks | ✓ Created |
| execution | Execute tasks step-by-step | ✓ Created |
| review | AI-powered code review | ✓ Created |
| test | Run tests with AI-suggested fixes | ✓ Created |
| workflow | Full development pipeline | ✓ Created |
| learn | Store coding insights | ✓ Created |
| learn-health | Check reference library | ✓ Created |
| check | Codebase health check | ✓ Created |

## Skill Structure

```
.claude/skills/{skill-name}/
├── SKILL.md              # Main skill (<500 lines)
├── probing-questions.md  # Questions for interactive skills
└── templates/            # Supporting files
```

## Interactive Skills

These skills engage in conversational probing before generating artifacts:

- **planning** - Asks about personas, features, success criteria before PRD
- **development** - Challenges tech stack decisions before Tech Spec
- **discovery** - Interviews about vision, challenges, ideas

## Creating New Skills

See `TEMPLATE.md` for the skill template and guidelines.

## Migration Status

All commands migrated from `.claude/commands/` to `.claude/skills/`:
- [x] planning
- [x] development
- [x] discovery
- [x] prime
- [x] task-planning
- [x] execution
- [x] review
- [x] test
- [x] workflow
- [x] learn
- [x] learn-health
- [x] check
