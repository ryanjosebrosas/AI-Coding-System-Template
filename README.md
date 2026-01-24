# AI Coding Workflow System

A markdown-based command system for orchestrating AI-assisted development workflows through MCP integration.

## Overview

This system manages the complete development lifecycle from codebase context gathering through implementation, review, and testing. It uses markdown files for all artifacts and integrates with MCP (Model Context Protocol) servers for task management, knowledge base queries, and web research.

## Features

- **Prime Export**: Comprehensive codebase context gathering
- **Discovery**: AI-powered exploration of ideas and opportunities
- **Planning**: Automated PRD generation from discovery
- **Development**: Tech spec generation with stack recommendations
- **Task Planning**: PRP (Plan Reference Protocol) generation with task breakdown
- **Execution**: Sequential task execution with progress tracking
- **Review**: AI-powered code review with compliance verification
- **Testing**: Automated testing with AI-suggested fixes
- **Unified Workflow**: Single command for complete lifecycle

## Quick Start

### Prerequisites

- Claude Code CLI
- Archon MCP server (recommended)
- Web MCP servers (recommended)

### Basic Usage

```bash
# Export codebase context
/prime

# Explore opportunities
/discovery

# Create feature requirements
/planning my-feature

# Generate technical specification
/development my-feature

# Create implementation plan
/task-planning my-feature

# Execute implementation
/execution my-feature

# Review code
/review my-feature

# Run tests
/test my-feature
```

### Unified Workflow

Execute all phases with a single command:

```bash
/workflow my-feature
```

### Resume from Phase

Resume from any phase if errors occur:

```bash
/workflow my-feature --from-development
```

## Directory Structure

```
project-root/
├── .claude/
│   ├── commands/          # Workflow commands
│   └── templates/         # STATUS.md template
├── context/               # Prime exports
├── discovery/             # Discovery documents
├── features/              # Feature artifacts
│   └── {feature-name}/
│       ├── prd.md
│       ├── tech-spec.md
│       ├── prp.md
│       ├── task-plan.md
│       └── STATUS.md
├── templates/
│   └── prp/               # PRP templates
├── reviews/               # Review reports
├── testing/               # Test results
├── execution/             # Task breakdown files
├── PRD.md                 # Product Requirements Document
├── TECH-SPEC.md           # Technical Specification
├── CLAUDE.md              # Developer guidelines
└── README.md              # This file
```

## Documentation

- **[PRD.md](./PRD.md)** - Complete product requirements
- **[TECH-SPEC.md](./TECH-SPEC.md)** - Technical specifications
- **[CLAUDE.md](./CLAUDE.md)** - Development guidelines
- **[INDEX.md](./INDEX.md)** - System navigation

## License

MIT License - See LICENSE file for details
