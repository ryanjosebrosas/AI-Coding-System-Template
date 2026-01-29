# Development Probing Questions

Question bank for interactive Tech Spec generation. Challenge each tech decision.

## 1. Tech Stack

### Primary Question
"What tech stack are you considering? (frontend, backend, database)"

### Challenge Questions
| User Says | Challenge With |
|-----------|----------------|
| React | "Why React over Vue/Svelte? Is it familiarity or specific requirements?" |
| Node.js | "Why Node? Would Python or Go be better for [use case]?" |
| PostgreSQL | "Why Postgres? Is relational the right model for your data?" |
| MongoDB | "Why NoSQL? Do you have unstructured data or is it premature optimization?" |
| "The usual" | "What's 'usual' for you? Let's make sure it fits THIS project." |
| Latest framework | "Is [new framework] production-ready? What's your team's experience with it?" |

### If No Preference
"Let me suggest based on your PRD:
- For [requirement X]: Consider [tech A] because [reason]
- For [requirement Y]: Consider [tech B] because [reason]
Does either direction appeal to you?"

## 2. Architecture

### Primary Question
"What architecture pattern fits this feature? (monolith, microservices, serverless, etc.)"

### Challenge Questions
| User Says | Challenge With |
|-----------|----------------|
| Microservices | "For a team of [size], is microservices overhead worth it? Would a modular monolith work?" |
| Monolith | "Will this need to scale independently? Are there natural service boundaries?" |
| Serverless | "Cold starts acceptable for your use case? What about local development?" |
| "Whatever's best" | "Best depends on constraints. What's your deployment environment?" |

### Constraint Conflicts
| If user said... | But chose... | Challenge |
|-----------------|--------------|-----------|
| "Small team" | Microservices | "Microservices add operational overhead. Can your team handle multiple deployments?" |
| "Fast timeline" | New tech | "Learning curve might slow you down. Familiar tech is faster to ship." |
| "Low budget" | Cloud-native | "Cloud services add up. Have you estimated monthly costs?" |

## 3. Constraints

### Primary Question
"What constraints should I know about? (team skills, budget, timeline, existing infrastructure)"

### Depth Questions
| Area | Questions |
|------|-----------|
| Team | "What's the team's strongest language? Any technologies they want to avoid?" |
| Budget | "What's the budget for infrastructure/services? Any corporate restrictions?" |
| Timeline | "When does this need to ship? What's the minimum viable version?" |
| Infrastructure | "Where will this run? Cloud? On-prem? Existing Kubernetes?" |
| Integration | "What existing systems must this work with? APIs? Databases?" |

### Challenge Based on Constraints
- If tight timeline + complex stack: "Your timeline is [X] but [tech] has a learning curve. How does that work?"
- If small team + distributed system: "Will 2 people be able to debug distributed issues effectively?"
- If low budget + premium services: "Have you estimated the monthly cost of [service]?"

## 4. Keep It Simple

### Primary Question
"Is there a simpler approach that would work? What's the minimum viable tech stack?"

### Simplicity Challenges
| Over-engineering Signal | Challenge |
|------------------------|-----------|
| Multiple databases | "Do you need both SQL and NoSQL, or could one handle both use cases?" |
| Message queues early | "Do you have proven scale needs, or is this premature optimization?" |
| Kubernetes for small app | "Would a simple PaaS like Vercel/Railway work instead?" |
| Caching layers | "Have you measured performance without caching first?" |
| Microservices for MVP | "Could you start monolithic and split later if needed?" |

### The YAGNI Check
"Before we proceed: Is there anything in this stack that you might not need for v1?
Let's identify what's essential vs what can be added later."

## 5. Inspo Repo

### Primary Question
"Do you have an inspo repo we should reference for architecture or file structure?"

### If Yes
1. Run inspo analyzer
2. Present: "Here's what I found in [repo]:"
   - Architecture: [pattern]
   - File structure: [layout]
   - Tech stack: [technologies]
   - Testing: [approach]

3. Ask: "What aspects do you want to adopt?"
   - [ ] File structure → Use in Tech Spec layout
   - [ ] Tech stack → Compare with your choices
   - [ ] Architecture patterns → Incorporate in design
   - [ ] Testing approach → Include in quality strategy
   - [ ] All of the above
   - [ ] None (just for reference)

### If Different from User's Choices
"The inspo repo uses [X] but you chose [Y]. Want to:
1. Stick with your choice
2. Switch to match inspo
3. Take the best of both"

### If No Inspo Repo
"That's fine. Is there a product or tool that does something similar we should look at?"

## Edge Case Handling

### User Defends Well
"Good reasoning. That makes sense for your requirements. Let's proceed with [choice]."

### User Can't Defend
"Let me help. Based on your PRD, here's why [X] might be a good fit: [reasoning].
Does that match your thinking, or is there something specific I'm missing?"

### User Gets Defensive
"I'm not questioning your expertise - just making sure we've thought through the decision.
If you're confident in [choice], let's document the reasoning and move on."

### Conflicting Requirements
"I notice a potential conflict:
- You need [fast delivery]
- But chose [complex tech with learning curve]

Which is the higher priority? We may need to compromise on one."
