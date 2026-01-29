# PRP: Interactive Workflow Enhancement

**Version**: 1.0 | **Last Updated**: 2026-01-29
**Related**: PRD.md, TECH-SPEC.md, MVP.md

## Goal

Transform AI Coding Workflow commands from "run and generate" to "converse and generate" - making AI a collaborative partner that asks the right questions, challenges assumptions, and helps users think through requirements before generating artifacts.

## Deliverables

1. **Interactive `/planning` command** - Conversational probing before PRD generation
2. **Interactive `/development` command** - Tech stack challenges before Tech Spec generation
3. **Inspo repo feature** - Analyze GitHub repos via `gh` CLI
4. **Skill migration** - Convert all commands to Claude Code skill format
5. **Updated README** - Clear explanation of the system (max 1000 lines)

## Success Criteria

- Users complete PRD/Tech Spec with minimal revisiting of earlier phases
- Starting developers feel guided, not overwhelmed
- System asks specific, answerable questions
- Inspo repos successfully analyzed and aspects applied
- All commands available as skills

---

## All Needed Context

### Documentation URLs
- Claude Code Skills: https://code.claude.com/docs/en/skills.md
- GitHub CLI: https://cli.github.com/manual/

### File References
- Current commands: `.claude/commands/*.md`
- Target skills: `.claude/skills/{command}/SKILL.md`
- PRD: `PRD.md`
- Tech Spec: `TECH-SPEC.md`

### Codebase Patterns

**Command Structure**:
```markdown
---
name: {Command Name}
description: "{Description}"
phase: {phase}
dependencies: [{deps}]
outputs: [{outputs}]
inputs: [{inputs}]
---

# {Command} Command

## Purpose
...

## Execution Steps
...
```

**Skill Structure** (target):
```markdown
---
name: {command}
description: "{Description}"
user-invocable: true
disable-model-invocation: false
---

# {Skill instructions}
```

### Architecture Patterns

**Conversational Probing Flow**:
```
1. INIT: Load context (discovery, MVP, previous phases)
2. PROBE: Ask question based on phase
3. LISTEN: Receive user response
4. ANALYZE: Follow-up or move to next topic
5. REPEAT: Until sufficient context
6. CONFIRM: Summarize, verify understanding
7. GENERATE: Create artifact
```

**Inspo Repo Analysis**:
```bash
gh repo view owner/repo --json name,description,languages
gh api repos/owner/repo/contents
gh api repos/owner/repo/contents/package.json
```

---

## Implementation Blueprint

### Phase 1: Core Interactivity (Priority: High)

**Task 1.1: Update /planning with conversational probing**
- Add probing section before PRD generation
- Questions: personas, features, priorities, success criteria, inspo repos
- Follow-up based on answers
- Proceed to generation when sufficient

**Task 1.2: Update /development with conversational probing**
- Add probing section before Tech Spec generation
- Questions: tech stack preferences, architecture, constraints
- Challenge assumptions ("Why this stack?")
- Suggest alternatives via web search

### Phase 2: Inspo Repo Feature (Priority: High)

**Task 2.1: Create inspo repo analyzer utility**
- Use `gh` CLI to fetch repo info
- Extract: file structure, package.json, README
- Parse dependencies and detect tech stack
- Return structured analysis

**Task 2.2: Integrate inspo into probing flow**
- Ask "Do you have an inspo repo?" during probing
- Run analysis if URL provided
- Present findings to user
- Let user select aspects to adopt
- Apply to generation

### Phase 3: Skill Migration (Priority: High)

**Task 3.1: Create skill structure**
- Create `.claude/skills/` directory
- Define skill template with frontmatter

**Task 3.2: Migrate /planning to skill**
- Create `.claude/skills/planning/SKILL.md`
- Add `probing-questions.md` for question bank
- Keep under 500 lines

**Task 3.3: Migrate /development to skill**
- Create `.claude/skills/development/SKILL.md`
- Add `probing-questions.md` for question bank
- Keep under 500 lines

**Task 3.4: Migrate remaining commands to skills**
- discovery, prime, task-planning, execution
- review, test, workflow
- learn, learn-health, check

### Phase 4: Documentation & Polish (Priority: Medium)

**Task 4.1: Update README.md**
- Add summary/explanation at top after title
- Document the interactive workflow system
- Include quick start guide
- Keep under 1000 lines

**Task 4.2: Context carry-forward**
- Store user preferences across phases
- Load previous decisions in subsequent commands

---

## Validation Loop

### After Each Task
1. Test the modified command manually
2. Verify probing questions are specific and answerable
3. Verify artifact generation works after probing
4. Check file stays under line limits

### After Phase Completion
1. Run full workflow with new features
2. Verify backward compatibility (existing commands still work)
3. Test with "Starting Developer" persona mindset

### Final Validation
- [ ] `/planning` asks probing questions before PRD
- [ ] `/development` challenges tech stack decisions
- [ ] Inspo repo can be analyzed and applied
- [ ] All commands available as skills
- [ ] README updated with clear explanation
- [ ] No regressions in existing functionality

---

## Anti-Patterns

### Probing Anti-Patterns
- **Vague questions**: "What do you want?" → Ask specific questions
- **Too many questions at once**: Interview-style → One question at a time
- **Not following up**: Generic next question → Follow-up based on answer
- **Assuming expertise**: Technical jargon → Explain and suggest options

### Implementation Anti-Patterns
- **Over-engineering**: Complex GitHub API → Simple `gh` CLI
- **Monolithic skills**: Everything in SKILL.md → Separate files for questions
- **Breaking backward compat**: Remove old commands → Keep both working

---

## Task Dependencies

```
Task 1.1 (planning probing)
    │
    └──► Task 3.2 (planning skill) ──► Task 3.4 (other skills)

Task 1.2 (development probing)
    │
    └──► Task 3.3 (development skill) ──► Task 3.4 (other skills)

Task 2.1 (inspo analyzer)
    │
    └──► Task 2.2 (integrate inspo)

Task 3.1 (skill structure) ──► Tasks 3.2, 3.3, 3.4

Task 4.1 (README) - Independent
Task 4.2 (context carry-forward) - After Phase 1
```

---

**Archon Project ID**: 986a93b2-983d-4399-be63-db0992d3169d
