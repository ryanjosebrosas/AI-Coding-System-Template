# AI Coding System Template

A comprehensive markdown-based command system for orchestrating AI-assisted development workflows through MCP (Model Context Protocol) integration. This template provides a complete framework for managing the software development lifecycle from discovery to deployment.

## Overview

This system manages the complete development lifecycle through intelligent markdown artifacts and MCP server integration. It transforms the way AI assistants work with codebases by providing structured context gathering, automated documentation generation, and task-driven development workflows.

**Key Capabilities:**
- **Token-efficient context loading** - Only load relevant codebase artifacts
- **Automated documentation generation** - PRD, Tech Specs, PRPs from AI analysis
- **Task-driven development** - Archon MCP integration for progress tracking
- **Smart Reference Library** - Store and retrieve digested coding insights
- **Comprehensive testing** - AI-suggested fixes and coverage reports
- **Resume capability** - Pick up from any phase after interruptions

## Features

### Core Workflow Commands
- **`/prime`** - Export complete codebase context for AI analysis
- **`/discovery`** - Explore ideas, inspiration, and opportunities with RAG/web research
- **`/planning {feature}`** - Generate PRD from discovery insights
- **`/development {feature}`** - Generate technical specifications with stack recommendations
- **`/task-planning {feature}`** - Create implementation plans with PRP and Archon tasks
- **`/execution {feature}`** - Execute tasks sequentially with progress tracking
- **`/review {feature}`** - AI-powered code review with quality, security, and performance analysis
- **`/test {feature}`** - Run tests with AI-suggested fixes
- **`/workflow {feature}`** - Execute complete pipeline with resume support

### Smart Reference Library
- **`/learn {topic}`** - Search RAG/web, digest insights, store for reuse
- **`/learn-health`** - Check library coverage and get suggestions

### Utility Commands
- **`/check`** - Comprehensive codebase health check, cleanup, and documentation updates
- **`/update-index`** - Update directory INDEX.md files
- **`/update-status`** - Update feature STATUS.md tracking

## Quick Start

### Prerequisites

- **Claude Code CLI** - Primary AI assistant interface
- **Archon MCP Server** - Task management and knowledge base (recommended)
- **Supabase** - Database for reference library (optional but recommended)
- **Web MCP Servers** - Enhanced web research (optional)

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/ryanjosebrosas/AI-Coding-System-Template.git
   cd AI-Coding-System-Template
   ```

2. **Configure MCP Servers** (if using):
   - Add Archon MCP server to Claude Code configuration
   - Add web MCP servers for enhanced research
   - Configure Supabase connection for reference library

3. **Run initial setup:**
   ```bash
   # Export codebase context
   /prime

   # Explore opportunities
   /discovery
   ```

### Basic Usage

```bash
# 1. Start a new feature
/planning my-feature

# 2. Generate technical spec
/development my-feature

# 3. Create implementation plan
/task-planning my-feature

# 4. Execute implementation
/execution my-feature

# 5. Review code
/review my-feature

# 6. Run tests
/test my-feature
```

### Unified Workflow

Execute all phases automatically:

```bash
# Full pipeline
/workflow my-feature

# Resume from specific phase
/workflow my-feature --from-development
```

### Building Your Reference Library

```bash
# Learn a new topic
/learn python async patterns

# Check library health
/learn-health
```

## Directory Structure

```
project-root/
├── .claude/
│   ├── commands/          # Workflow command definitions
│   │   ├── prime.md
│   │   ├── discovery.md
│   │   ├── planning.md
│   │   ├── development.md
│   │   ├── task-planning.md
│   │   ├── execution.md
│   │   ├── review.md
│   │   ├── test.md
│   │   ├── workflow.md
│   │   ├── learn.md         # Reference library commands
│   │   ├── learn-health.md
│   │   └── ...
│   └── templates/         # STATUS.md template
├── context/               # Codebase exports from /prime
├── discovery/             # Ideas and opportunities from /discovery
├── features/              # Feature-specific artifacts
│   ├── {feature-name}/
│   │   ├── prd.md        # Product Requirements
│   │   ├── tech-spec.md  # Technical Specification
│   │   ├── prp.md        # Plan Reference Protocol
│   │   ├── task-plan.md  # Task breakdown
│   │   ├── execution/    # Task files (deleted as completed)
│   │   └── STATUS.md     # Progress tracking
│   └── INDEX.md          # Features index
├── templates/
│   └── prp/               # PRP templates for different feature types
│       ├── prp-base.md
│       ├── prp-ai-agent.md
│       ├── prp-mcp-integration.md
│       ├── prp-api-endpoint.md
│       └── prp-frontend-component.md
├── reviews/               # Code review reports
├── testing/               # Test results
├── execution/             # System implementation tasks
├── PRD.md                 # Root Product Requirements Document
├── TECH-SPEC.md           # Root Technical Specification
├── MVP.md                 # Minimum Viable Product definition
├── CLAUDE.md              # Developer guidelines
├── INDEX.md               # System navigation index
└── README.md              # This file
```

## Architecture

### Workflow Phases

```
┌─────────┐    ┌──────────┐    ┌─────────┐    ┌──────────────┐    ┌──────────┐    ┌─────────┐    ┌────────┐    ┌─────────┐
│  Prime  │───▶│ Discovery│───▶│ Planning│───▶│Development  │───▶│Task Plan │───▶│Execution│───▶│ Review │───▶│  Test  │
└─────────┘    └──────────┘    └─────────┘    └──────────────┘    └──────────┘    └─────────┘    └────────┘    └─────────┘
     │              │               │                │                │              │         │              │
     ▼              ▼               ▼                ▼                ▼              ▼         ▼              ▼
  Context       Discovery        PRD           TECH-SPEC        PRP         Tasks        Code    Review    Test Results
```

### Smart Reference Library

```
┌─────────────┐      ┌──────────┐      ┌─────────────┐
│ /learn cmd  │─────▶│ RAG/Web  │─────▶│   Supabase  │
└─────────────┘      └──────────┘      └─────────────┘
                                                │
                                                ▼
┌─────────────────────────────────────────────────────┐
│         archon_references table                        │
│  - category: python, mcp, react, typescript, etc.    │
│  - tags: Additional filtering tags                     │
│  - content: {summary, insights, code_examples}        │
└─────────────────────────────────────────────────────┘
                                                │
                                                ▼
┌─────────────────────────────────────────────────────┐
│          PRP specifies required categories            │
│    "Load python + mcp references for this task"       │
│    → Only those references load into AI context       │
└─────────────────────────────────────────────────────┘
```

## Documentation

- **[PRD.md](./PRD.md)** - Complete product requirements
- **[TECH-SPEC.md](./TECH-SPEC.md)** - Technical specifications and architecture
- **[CLAUDE.md](./CLAUDE.md)** - Development guidelines and best practices
- **[MVP.md](./MVP.md)** - Minimum Viable Product definition
- **[INDEX.md](./INDEX.md)** - System navigation

## Examples

### Example 1: Building a Python MCP Server

```bash
# 1. Start with discovery
/discovery
# → Finds MCP server patterns as opportunity

# 2. Generate requirements
/planning python-mcp-server
# → Creates PRD with user stories and acceptance criteria

# 3. Generate technical spec
/development python-mcp-server
# → Creates TECH-SPEC with architecture and stack

# 4. Create implementation plan
/task-planning python-mcp-server
# → Creates PRP with codebase patterns and Archon tasks

# 5. Execute implementation
/execution python-mcp-server
# → Executes tasks sequentially, tracks progress

# 6. Review code
/review python-mcp-server
# → AI review for quality, security, performance

# 7. Run tests
/test python-mcp-server
# → Automated tests with AI-suggested fixes
```

### Example 2: Building a Reference Library

```bash
# Learn Python async patterns
/learn python async patterns

# Learn React hooks
/learn react hooks

# Learn MCP server development
/learn mcp server patterns

# Check library health
/learn-health
# → Shows: python (2), react (1), mcp (1)
# → Suggests: Learn TypeScript, Learn testing patterns
```

### Example 3: Full Workflow with Resume

```bash
# Start full workflow
/workflow rest-api

# If interrupted during Development, resume:
/workflow rest-api --from-development
# → Skips completed phases, continues from Development
```

## Archon MCP Integration

This system integrates with Archon MCP for:

- **Task Management** - Create, update, track tasks across projects
- **Knowledge Base** - RAG search for documentation and code examples
- **Project Organization** - Manage multiple features with hierarchical structure

**Required Archon Tools:**
- `manage_project()` - Create and manage projects
- `manage_task()` - Create and track implementation tasks
- `rag_search_knowledge_base()` - Search documentation
- `rag_search_code_examples()` - Find code examples
- `find_projects()`, `find_tasks()` - Query projects and tasks

## Token Efficiency

This system is designed for token efficiency:

1. **Prime exports** - Snapshots of codebase, only used when needed
2. **Selective loading** - PRPs specify only required references
3. **Digestion** - Store concise insights, not full articles
4. **Caching** - Archon caches knowledge base for fast retrieval

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

MIT License - See LICENSE file for details

## Acknowledgments

Built with:
- [Claude Code CLI](https://claude.ai/claude-code)
- [Archon MCP](https://github.com/your-repo/archon) - Task management and knowledge base
- [Supabase](https://supabase.com) - Database for reference library

---

**GitHub Repository**: https://github.com/ryanjosebrosas/AI-Coding-System-Template

**Template Version**: 1.0
**Last Updated**: 2026-01-24
