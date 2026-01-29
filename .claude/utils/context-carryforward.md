# Context Carry-Forward Utility

Store and retrieve user decisions across workflow phases to avoid re-asking questions.

## Storage Location

Context is stored in `features/{feature-name}/STATUS.md` under a dedicated section.

## Context Schema

```yaml
## Probing Context

### From Discovery
- **Vision**: {user's stated vision}
- **Key Challenges**: {list of challenges}
- **Ideas**: {specific ideas mentioned}
- **Success Criteria**: {definition of success}

### From Planning
- **Personas**:
  - {persona 1}: {description}
  - {persona 2}: {description}
- **Key Features**: {prioritized list}
- **Constraints**: {timeline, team, budget}
- **Inspo Repo**: {URL or "none"}
- **Adopted Aspects**: {file structure, tech stack, etc.}

### From Development
- **Tech Stack**:
  - Frontend: {choice} - Reason: {why}
  - Backend: {choice} - Reason: {why}
  - Database: {choice} - Reason: {why}
- **Architecture**: {pattern} - Reason: {why}
- **Inspo Aspects Applied**: {list}
```

## Loading Context

At the start of each interactive command, load previous context:

```markdown
### Step 0: Load Previous Context

1. Read `features/{feature-name}/STATUS.md`
2. Parse "Probing Context" section
3. Extract:
   - From Discovery: vision, challenges, ideas, success
   - From Planning: personas, features, constraints, inspo
   - From Development: tech stack, architecture

4. Reference in probing:
   - "Earlier you mentioned [X], does that still apply?"
   - "In planning, you chose [Y personas]. Want to refine that?"
   - "You selected [Z tech stack]. Any changes based on [new info]?"
```

## Saving Context

After probing completes, save decisions to STATUS.md:

```markdown
### Step N: Save Probing Context

1. Compile all decisions from this phase
2. Format as YAML under "## Probing Context"
3. Append/update in STATUS.md
4. Include timestamp
```

## Reference Examples

### Discovery → Planning

When `/planning` loads after `/discovery`:
```
Previous context loaded from Discovery:
- Vision: "Make AI a collaborative partner"
- Challenges: "Only discovery is interactive"
- Success: "Less rework, challenge thinking"

"Your discovery mentioned wanting 'AI as a collaborative partner'.
What specific features would achieve that for your personas?"
```

### Planning → Development

When `/development` loads after `/planning`:
```
Previous context loaded from Planning:
- Personas: Solo Builder, Starting Developer
- Features: Interactive probing, Inspo repo
- Constraints: Timeline 2 weeks, solo developer

"You're targeting Starting Developers with a 2-week timeline.
What tech stack fits that constraint?"
```

## No Re-Asking Rule

If context exists for a question, don't ask again. Instead:
1. Present the previous decision
2. Ask for confirmation: "Still accurate, or want to update?"
3. If update → ask the question
4. If confirmed → move on

## Implementation Notes

- STATUS.md already exists for every feature (created in Planning)
- Probing Context section is optional - only added if probing occurs
- Context persists across sessions (stored in file, not memory)
- Each command appends to context, preserving earlier decisions
- YAML format for easy parsing and readability
