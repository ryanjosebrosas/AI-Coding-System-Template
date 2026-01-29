# Planning Probing Questions

Question bank for interactive PRD generation. Ask one question at a time, follow up based on answers.

## 1. Personas

### Primary Question
"Who will use this feature? Describe 2-3 user types."

### Follow-ups
| If answer is... | Ask... |
|-----------------|--------|
| Vague ("users", "people") | "Let's narrow it down. Who uses this most? Technical or non-technical?" |
| Single persona | "Are there other user types? Maybe admins, or different experience levels?" |
| Too many personas | "Which 2-3 are the primary users? We can note others as secondary." |
| Technical-only | "What about less technical users? Will they interact with this?" |

### Depth Questions (if needed)
- "What's their technical level?"
- "What problems do they face daily?"
- "What tools do they currently use?"
- "What frustrates them about current solutions?"

## 2. Features

### Primary Question
"What are the 3-5 key features this needs?"

### Follow-ups
| If answer is... | Ask... |
|-----------------|--------|
| Vague ("it should work well") | "What specific capabilities? Give me concrete examples." |
| Too many features | "Which 3-5 are must-haves for the first version?" |
| Single feature | "What else? Think about [persona]'s workflow." |
| Technical jargon | "Can you describe that in terms of what the user does?" |

### Challenge Questions
- "Why [feature X]? What problem does it solve for [persona]?"
- "Is [feature X] a must-have or nice-to-have?"
- "What happens if we don't include [feature X]?"
- "Could [simpler approach] work instead?"

## 3. Success Criteria

### Primary Question
"What does success look like? How will you know this feature is working?"

### Follow-ups
| If answer is... | Ask... |
|-----------------|--------|
| Vague ("users are happy") | "Can you give a specific, measurable outcome?" |
| No metrics | "What would you measure? Usage? Speed? Satisfaction?" |
| Too ambitious | "What's the minimum success criteria for v1?" |
| Only technical | "How will [persona] know it's helping them?" |

### Depth Questions
- "If this works perfectly, what changes for [persona]?"
- "What's the difference between 'working' and 'great'?"
- "How will you know if it's NOT working?"

## 4. Constraints

### Primary Question
"Are there any constraints? Timeline, team size, tech limitations?"

### Follow-ups
| If answer is... | Ask... |
|-----------------|--------|
| "No constraints" | "Really? What about timeline? Budget? Team availability?" |
| Tight timeline | "What's the priority if we can't fit everything?" |
| Limited team | "Should we design for maintainability by a small team?" |
| Tech limitations | "What's off the table? What should we avoid?" |

### Depth Questions
- "What existing systems must we integrate with?"
- "Are there any dependencies we're waiting on?"
- "What's the budget for external services/tools?"
- "Who needs to approve this?"

## 5. Inspo Repo

### Primary Question
"Do you have an inspiration repo we should reference? (GitHub URL)"

### If Yes
1. Run inspo analyzer
2. Present findings
3. Ask: "What aspects do you want to adopt?"
   - [ ] File structure
   - [ ] Tech stack
   - [ ] Architecture patterns
   - [ ] All of the above
   - [ ] None (just for reference)

### If No
"That's fine. Is there any existing product or tool that does something similar?"
- If yes → note for reference
- If no → proceed without inspo

## Edge Case Handling

### User Says "I Don't Know"
"No problem! Let me suggest some options based on what we've discussed:
- Option A: [suggestion based on context]
- Option B: [alternative]
- Option C: [simpler approach]
Which sounds closest to what you need?"

### User Wants to Skip
"Skipping this is a missed opportunity - the PRD will be less tailored to your needs. Are you sure? (yes/no)"
- If yes → proceed with defaults, note in PRD
- If no → continue probing

### Conflicting Answers
"I notice a potential conflict: you said [X] but also [Y]. Which is the higher priority?"

### User Gets Frustrated
"I understand this is detailed. The goal is a PRD that captures YOUR vision, not my assumptions. Want to:
1. Continue (we're almost done)
2. Skip remaining questions
3. Take a break and continue later"
