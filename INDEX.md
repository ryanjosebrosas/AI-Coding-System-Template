# AI Coding Workflow System - INDEX

## Overview

This is a markdown-based command system for orchestrating AI-assisted development workflows through MCP integration. It manages the complete lifecycle from codebase context to implementation, review, and testing.

## Directory Navigation

- **[context/](./context/)** - Prime exports (codebase context)
- **[discovery/](./discovery/)** - Discovery documents (ideas and opportunities)
- **[features/](./features/)** - Feature artifacts (PRD, tech spec, PRP, task plans)
- **[templates/](./templates/)** - Template files (PRP templates)
- **[reviews/](./reviews/)** - Code review reports
- **[testing/](./testing/)** - Test results
- **[execution/](./execution/)** - Task breakdown files
- **[.claude/commands/](./.claude/commands/)** - Workflow commands

## Core Commands

| Command | Description | Phase |
|---------|-------------|-------|
| `/prime` | Export codebase for context gathering | Prime |
| `/discovery` | Explore ideas and opportunities | Discovery |
| `/planning {feature}` | Generate PRD from discovery | Planning |
| `/development {feature}` | Generate tech spec from PRD | Development |
| `/task-planning {feature}` | Generate PRP and create tasks | Task Planning |
| `/execution {feature}` | Execute tasks sequentially | Execution |
| `/review {feature}` | Run code review | Review |
| `/test {feature}` | Run tests with AI-suggested fixes | Test |
| `/workflow {feature}` | Execute full workflow with resume support | All phases |
| `/learn {topic}` | Search, digest, and store coding insights | Independent |
| `/learn-health` | Check reference library health and statistics | Independent |
| `/update-index` | Update directory INDEX.md files | Utility |
| `/update-status` | Update feature STATUS.md tracking | Utility |

## Core Documents (Root Level)

- **[MVP.md](./MVP.md)** - Minimum Viable Product definition
- **[PRD.md](./PRD.md)** - Product Requirements Document
- **[TECH-SPEC.md](./TECH-SPEC.md)** - Technical Specification
- **[CLAUDE.md](./CLAUDE.md)** - Developer guidelines

## Quick Start

1. Run `/prime` to export codebase context
2. Run `/discovery` to explore opportunities
3. Run `/planning {feature-name}` to create PRD
4. Run `/development {feature-name}` to create tech spec
5. Run `/task-planning {feature-name}` to create implementation plan
6. Run `/execution {feature-name}` to implement tasks
7. Run `/review {feature-name}` to review code
8. Run `/test {feature-name}` to run tests

Or run `/workflow {feature-name}` to execute all phases automatically.

## Status

**Version**: 1.0
**Last Updated**: 2026-01-24
**Status**: Stable (Smart Reference Library Completed)

## Completed Features

- **Smart Reference Library** - Token-efficient reference storage with /learn and /learn-health commands (Execution Complete, Awaiting Review/Test)
