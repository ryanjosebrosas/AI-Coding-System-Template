# Probing Edge Cases Handling

Handle edge cases during interactive probing sessions.

## Edge Case 1: Vague Answers

**Detection**: User says generic phrases like:
- "it should be good"
- "whatever works"
- "the usual"
- "something nice"

**Response**:
```
"Could you be more specific? For example:
- What does 'good' mean for your users?
- What's one specific thing that would make this successful?"
```

**If still vague after 2 attempts**: Accept and note in artifact:
```
"I'll proceed with best practices since specifics weren't provided.
The [artifact] may need revision once you have clearer requirements."
```

## Edge Case 2: User Wants to Skip

**Detection**: User says:
- "skip"
- "just generate"
- "I don't have time"
- "can we move on"

**Response**:
```
"Skipping is a missed opportunity - the output will be based on assumptions
rather than your actual needs. Are you sure?

1. Yes, skip and use defaults
2. No, let me answer the question"
```

**If user confirms skip**:
- Proceed with sensible defaults
- Note in artifact: "This section used defaults due to skipped probing"
- Warn at the end: "You may want to revisit [X] as it was generated with defaults"

## Edge Case 3: Conflicting Information

**Detection**: User says things that contradict:
- "I want it fast" + "I want it perfect"
- "Small team" + "Microservices architecture"
- "Low budget" + "Premium cloud services"
- "2-week timeline" + "Learning new framework"

**Response**:
```
"I notice a potential conflict:
- You mentioned: [First statement]
- But also: [Second statement]

These might not work well together. Which is the higher priority?"
```

**Resolution options**:
1. User chooses priority → proceed with that
2. User explains compatibility → accept reasoning
3. User can't decide → suggest a middle ground

## Edge Case 4: User Doesn't Know

**Detection**: User says:
- "I don't know"
- "not sure"
- "no idea"
- "what do you suggest?"

**Response**:
```
"No problem! Based on what you've told me, here are some options:

1. [Option A] - Good for [reason]
2. [Option B] - Good for [different reason]
3. [Option C] - The simplest approach

Which sounds closest to what you need?"
```

**If user still uncertain**:
- Use web search: "Let me research options for [context]..."
- Present findings with recommendations
- Offer to choose a sensible default: "I can go with [X] as a starting point. You can always change later."

## Edge Case 5: Invalid Inspo Repo

**Detection**: Repo URL doesn't work:
- 404 error
- Private repository
- Rate limited
- Network error

**Response by error type**:

| Error | Response |
|-------|----------|
| 404 | "Couldn't find that repo. Is the URL correct?" |
| Private | "This appears to be private. Are you authenticated with `gh auth login`?" |
| Rate limit | "GitHub rate limited. Try again in a few minutes, or describe the repo manually." |
| Network | "Network error. Can you describe what you liked about that repo instead?" |

**Fallback**:
```
"Instead of analyzing the repo, could you describe:
- What did you like about its structure?
- What tech stack did it use?
- Any patterns you want to adopt?"
```

## Edge Case 6: User Gets Frustrated

**Detection**: User shows frustration:
- "This is taking too long"
- "Just do something"
- "Why so many questions"
- Short, terse answers

**Response**:
```
"I understand this is detailed. The goal is output that matches YOUR vision,
not my assumptions. Want to:

1. Continue (we're almost done)
2. Answer remaining questions briefly
3. Skip to generation with what we have"
```

**Adapt approach**:
- Combine remaining questions: "Quick questions: [A], [B], [C]?"
- Accept shorter answers without extensive follow-up
- Acknowledge their time is valuable

## Edge Case 7: Changing Previous Answers

**Detection**: User changes a previous answer:
- "Actually, change X to Y"
- "I changed my mind about..."
- "Wait, go back to..."

**Response**:
```
"Got it, updating [topic] from [old] to [new].

Does this change affect anything else we discussed?"
```

**Handle cascading changes**:
- If personas change → check if features still make sense
- If tech stack changes → verify architecture compatibility
- If constraints change → review all decisions against new constraints

## Implementation Notes

These edge cases should be handled in every interactive command:
- `/discovery` - User interview
- `/planning` - PRD probing
- `/development` - Tech stack probing

Reference this document in probing-questions.md for each skill.

## Quick Reference

| Edge Case | Detection | Response |
|-----------|-----------|----------|
| Vague | "good", "works" | Ask for specifics, accept after 2 tries |
| Skip | "skip", "just generate" | Warn of consequences, proceed if confirmed |
| Conflict | Contradicting statements | Point out, ask for priority |
| Don't Know | "not sure", "no idea" | Suggest options, offer to research |
| Bad Repo | 404, private, network | Explain error, offer manual description |
| Frustrated | Short/terse answers | Offer to speed up or skip |
| Changed Mind | "actually", "wait" | Update, check for cascading changes |
