---
name: discovery
description: "Explore ideas through interactive user interview"
user-invocable: true
disable-model-invocation: false
---

# Discovery Skill

Engage users in conversation to explore ideas, inspiration, and needs for AI agents and applications.

## Execution Flow

1. **Interview User** - Vision, challenges, ideas, success criteria
2. **Load Prime Context** - Most recent codebase export
3. **Query RAG** - AI agent patterns, code examples
4. **Web Research** - Inspiration sources, best practices
5. **Needs Analysis** - Gaps and opportunities
6. **Generate Discovery** - Compile findings into document

## Interview Questions

### Vision
"What is your vision for this project? What problems are you trying to solve?"

### Challenges
"What challenges are you facing? Any pain points or bottlenecks?"

### Ideas
"Do you have specific ideas for AI agents or features you'd like to explore?"

### Success
"What does success look like? How will you know it's working?"

## Follow-Up Logic

- **Vague answer**: Ask for specifics and examples
- **Unclear**: Request more details
- **New area**: Probe deeper with 1-2 follow-ups
- **Sufficient**: Acknowledge and move on

## Output

- `discovery/discovery-{timestamp}.md` - Discovery document
- `MVP.md` - MVP definition at root
- Updated `discovery/INDEX.md`

## Reference

Full implementation details: `.claude/commands/discovery.md`
