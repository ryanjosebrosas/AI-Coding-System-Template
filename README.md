# AI Coding System Template

> **Build better software with AI** - Complete framework for AI-assisted development with intelligent task management, token-efficient context loading, and smart reference library.

Comprehensive markdown-based command system for orchestrating AI-assisted development workflows through MCP (Model Context Protocol) integration.

## Overview

Manages complete development lifecycle through intelligent markdown artifacts and **MCP server integration**.

**Key Capabilities:**
- **Token-efficient context loading** - Only load relevant codebase artifacts AND references
- **Automated documentation** - PRD, Tech Specs, PRPs from AI analysis
- **Task-driven development** - Archon MCP integration for progress tracking
- **Smart Reference Library** - Store and retrieve digested coding insights
- **RAG-powered research** - Search knowledge base and web for best practices
- **Comprehensive testing** - AI-suggested fixes and coverage reports

## Summary

15+ Commands from discovery (`/discovery`) to deployment (`/workflow`), PIV Loop methodology (Purpose → Implementation → Validation), Archon MCP integration for task tracking, Smart Reference Library with 90% token savings.

**Perfect for**: Developers using Claude Code who want systematic AI-assisted development.

## The PIV Loop Methodology

Structured approach to AI-assisted development:

**1. PURPOSE** (Idea → Distinction)
- Get idea through `/discovery`
- Clear distinction with `/planning` (PRD) and `/development` (Tech Spec)

**2. IMPLEMENTATION** (Details → Actionable Steps)
- Add details through technical research
- Create Archon tasks with `/task-planning` (PRP)

**3. VALIDATION** (Execute → Verify → Iterate)
- AI follows tasks one-by-one via `/execution`
- Mark: todo → doing → review → done
- Validate each step before moving on

### Archon Integration

```
find_tasks(status="todo") → manage_task(status="doing")
→ Execute → manage_task(status="review") → Validate
→ manage_task(status="done") → Next task
```

**Principles**:
- Bit by bit (30min - 4 hours per task)
- One at a time (only one "doing" status)
- Dependencies first (`addBlockedBy` field)
- Validate before moving (status="review")

## Features

### Core Workflow Commands

| Command | Description | Output |
|---------|-------------|--------|
| `/prime` | Export codebase context | `context/prime-*.md` |
| `/discovery` | Explore ideas/oppportunities | `discovery/ideas.md` |
| `/planning {feature}` | Generate PRD | `features/{feature}/prd.md` |
| `/development {feature}` | Generate Tech Spec | `features/{feature}/tech-spec.md` |
| `/task-planning {feature}` | Create implementation plan | `features/{feature}/prp.md` + Archon tasks |
| `/execution {feature}` | Execute tasks sequentially | Completed code |
| `/review {feature}` | AI-powered code review | `reviews/{feature}.md` |
| `/test {feature}` | Run tests with AI fixes | `testing/{feature}-results.md` |
| `/workflow {feature}` | Execute complete pipeline | Full feature implementation |

### Smart Reference Library

| Command | Description |
|---------|-------------|
| `/learn {topic}` | Search RAG/web, digest insights, store to Supabase |
| `/learn-health` | Check library coverage, token savings, gaps |

**How `/learn` works:**
```
Topic → RAG search + Web search → Digest (3-5 insights + code)
→ Store to Supabase (category, tags, relevance_score)
```

**Selective loading:** PRPs specify categories → Only load relevant references → 90% token savings

### Utility Commands

| Command | Description |
|---------|-------------|
| `/check` | Codebase health check & cleanup |
| `/update-index` | Auto-sync INDEX.md files |
| `/update-status` | Update STATUS.md tracking |

## Command Reference

### `/prime` - Context Export
Export entire codebase for AI analysis. Contains directory structure, key file contents. Excludes node_modules, .git, build artifacts. Use when starting new project.

### `/discovery` - Opportunity Exploration
Explore ideas using RAG (Archon KB) and web research (web-search-prime, zread, web-reader). Output: `discovery/ideas.md`. Use when looking for new features.

### `/planning {feature}` - PRD Generation
Create Product Requirements Document. Contains goal, user stories, functional/non-functional requirements, dependencies. Output: `features/{feature}/prd.md`.

### `/development {feature}` - Technical Specification
Generate technical architecture and stack. Contains architecture diagrams, tech stack, API design, database schema. Output: `features/{feature}/tech-spec.md`.

### `/task-planning {feature}` - Implementation Planning
Create actionable tasks with PRP. Contains implementation blueprint, codebase patterns, reference categories, Archon tasks with priorities/dependencies. Output: `features/{feature}/prp.md`.

### `/execution {feature}` - Task Execution
Execute tasks one-by-one with tracking:
1. Get next task (status: todo)
2. Mark as doing
3. Load selective context
4. Implement following PRP
5. Mark as review
6. Validate and test
7. Mark as done
8. Repeat

### `/review {feature}` - Code Review
AI-powered quality analysis. Analyzes code quality, security, performance, best practices, testing coverage. Output: `reviews/{feature}.md`.

### `/test {feature}` - Test Execution
Run tests with AI-suggested fixes. Runs test suite, detects failures, AI analyzes root causes, suggests fixes, re-runs to verify. Output: `testing/{feature}-results.md`.

### `/workflow {feature}` - Complete Pipeline
Execute all phases automatically. Phases: Discovery → Planning → Development → Task Planning → Execution → Review → Test. Supports resume with `--from-{phase}` flag.

### `/learn {topic}` - Learn & Store
Build reference library. Search RAG/web → Digest insights (3-5 bullets + code) → Present for approval → Store to Supabase. Result: Token-efficient, reusable knowledge.

### `/learn-health` - Library Diagnostics
Check reference library coverage. Shows category statistics, identifies gaps, displays token savings.

## MCP Integration

This system leverages multiple MCP servers:

| MCP Server | Purpose | Capabilities |
|------------|---------|--------------|
| **Archon MCP** | Task & Knowledge Management | Project tracking, task management, RAG KB, document storage |
| **Supabase MCP** | Database Operations | Reference library storage, queries, type generation |
| **Web MCP** | External Research | Web search, content extraction, URL reading |

## Reference Library Architecture

**The Magic - Selective Loading:**

```
1. LEARN: /learn {topic} → RAG + Web → Digest → Store to Supabase JSONB
2. SPECIFY: PRP defines required categories (e.g., python, mcp)
3. LOAD: SELECT * FROM archon_references WHERE category IN ('python', 'mcp')
4. EXECUTE: AI has ONLY relevant knowledge → Better code, less tokens
```

**Benefits**: 80-90% token reduction, higher quality responses, faster times, reusable knowledge.

## Getting Started

### Prerequisites
- Claude Code CLI
- Archon MCP server configured
- Supabase project for reference library

### Quick Start

```bash
# 1. Explore ideas
/discovery

# 2. Plan feature
/planning {feature-name}
/development {feature-name}

# 3. Create tasks
/task-planning {feature-name}

# 4. Execute
/execution {feature-name}

# 5. Review & test
/review {feature-name}
/test {feature-name}

# Or run all at once:
/workflow {feature-name}
```

### Learn & Store Knowledge

```bash
# Learn a topic
/learn python async patterns

# Check library health
/learn-health
```

## Directory Structure

```
ai-coding-template/
├── .claude/                 # Claude Code adapter
│   ├── commands/            # Workflow commands
│   ├── templates/           # Document templates
│   ├── validators/          # Quality validators
│   └── adapter-config.json  # Adapter configuration
├── commands/                # Universal command definitions
├── config/                  # Agent configurations
├── context/                 # Codebase exports
├── discovery/               # Ideas and opportunities
├── features/                # Feature artifacts (PRD, Tech Spec, PRP)
├── reviews/                 # Code reviews
├── scripts/                 # Utility scripts
├── templates/               # PRP templates
└── AGENT.md                 # Universal core agent instructions
```

## Quality System

Pre-commit hooks validate markdown files:
- Line count limits (500-600 lines)
- YAGNI/KISS compliance
- Required sections

Run manually:
```bash
./scripts/validate-quality.sh
```

## Contributing

Use the PIV Loop to improve this system:

```bash
# 1. Identify improvement
/discovery

# 2. Plan improvement
/planning {improvement}
/development {improvement}

# 3. Create tasks
/task-planning {improvement}

# 4. Execute
/execution {improvement}

# 5. Validate
/review {improvement}
/test {improvement}
```

**Self-improving system**: Every feature can be enhanced using the same PIV methodology.

## License

MIT License - feel free to use and modify for your projects.
