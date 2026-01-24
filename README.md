# AI Coding System Template

A comprehensive markdown-based command system for orchestrating AI-assisted development workflows through MCP (Model Context Protocol) integration. This template provides a complete framework for managing the software development lifecycle from discovery to deployment.

## Overview

This system manages the complete development lifecycle through intelligent markdown artifacts and **powerful MCP (Model Context Protocol) server integration**. It transforms the way AI assistants work with codebases by providing structured context gathering, automated documentation generation, and task-driven development workflows.

**Key Capabilities:**
- **Token-efficient context loading** - Only load relevant codebase artifacts AND references
- **Automated documentation generation** - PRD, Tech Specs, PRPs from AI analysis
- **Task-driven development** - Archon MCP integration for progress tracking
- **Smart Reference Library** - Store and retrieve digested coding insights from RAG/web
- **RAG-powered research** - Search knowledge base and web for best practices
- **Web MCP integration** - Enhanced discovery and planning with web research
- **Comprehensive testing** - AI-suggested fixes and coverage reports
- **Resume capability** - Pick up from any phase after interruptions

## What Makes This System Powerful

### MCP-Powered Architecture

This system leverages multiple MCP servers to create a **unified development intelligence platform**:

| MCP Server | Purpose | Key Capabilities |
|------------|---------|------------------|
| **Archon MCP** | Task & Knowledge Management | Project tracking, task management, RAG knowledge base, document storage |
| **Supabase MCP** | Database Operations | Reference library storage, queries, type generation |
| **Web MCP Servers** | External Research | Web search, content extraction, URL reading |

### The Intelligent Reference Library

At the heart of this system is a **token-efficient knowledge management system**:

```
┌─────────────────────────────────────────────────────────────────────┐
│                     HOW IT WORKS                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. LEARN PHASE                                                    │
│     ┌─────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│     │ /learn  │───▶│ RAG KB   │───▶│ Web MCP  │───▶│ Digest   │   │
│     │ {topic} │    │ Search   │    │ Search   │    │ Insights │   │
│     └─────────┘    └──────────┘    └──────────┘    └──────────┘   │
│                                                      │             │
│                                                      ▼             │
│                                            ┌─────────────────┐    │
│                                            │   Supabase      │    │
│                                            │   Store JSONB   │    │
│                                            └─────────────────┘    │
│                                                                     │
│  2. SELECTIVE LOADING (The Magic!)                                  │
│     ┌────────────────┐    ┌──────────────────────────────┐        │
│     │ PRP specifies  │───▶│ Query: WHERE category IN    │        │
│     │ categories     │    │ (python, mcp)               │        │
│     └────────────────┘    └──────────────────────────────┘        │
│                               │                                     │
│                               ▼                                     │
│                     ┌─────────────────────┐                        │
│                     │ ONLY load relevant  │                        │
│                     │ references into     │                        │
│                     │ AI context!         │                        │
│                     └─────────────────────┘                        │
│                                                                     │
│  3. EXECUTE WITH CONTEXT                                           │
│     AI has ONLY the knowledge it needs → Better code, less tokens   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Why This Matters

**Problem**: Loading entire documentation bases wastes tokens and dilutes context.

**Solution**: Store **digested insights** (not raw dumps) and **selectively load** only what's relevant.

**Benefits**:
- 80-90% reduction in reference token usage
- Higher quality AI responses (focused context)
- Faster response times
- Reusable knowledge across all features

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

| Component | Purpose | Required |
|-----------|---------|----------|
| **Claude Code CLI** | Primary AI assistant interface | ✅ Yes |
| **Archon MCP Server** | Task management and RAG knowledge base | ⭐ Recommended |
| **Supabase** | Database for Smart Reference Library | ⭐ Recommended |
| **Web MCP Servers** | Enhanced web research for discovery/planning | Optional |

### MCP Server Setup

#### 1. Archon MCP Server (Recommended)

Archon MCP provides task management, project tracking, and RAG knowledge base.

**Installation**:
```bash
# Clone Archon MCP
git clone https://github.com/your-repo/archon-mcp
cd archon-mcp

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Start server
npm start
```

**Configure Claude Code**:
```json
// ~/.claude/config.json or .claude/settings.local.json
{
  "mcpServers": {
    "archon": {
      "command": "node",
      "args": ["/path/to/archon-mcp/dist/index.js"],
      "env": {
        "ARCHON_API_URL": "http://localhost:3000",
        "ARCHON_API_KEY": "your-api-key"
      }
    }
  }
}
```

**Verify Connection**:
```bash
# Claude Code will automatically connect
# Ask: "Check Archon MCP health"
# Should return: {"status": "healthy", ...}
```

#### 2. Supabase MCP Server (Reference Library)

Supabase MCP provides database operations for the Smart Reference Library.

**Prerequisites**:
- Create Supabase project at https://supabase.com
- Run migration to create `archon_references` table

**Migration SQL**:
```sql
-- Run in Supabase SQL Editor
CREATE TABLE IF NOT EXISTS archon_references (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  content JSONB NOT NULL,
  source_url TEXT,
  author TEXT DEFAULT 'AI Coding System',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_archon_references_category ON archon_references(category);
CREATE INDEX idx_archon_references_tags ON archon_references USING GIN(tags);
```

**Configure Claude Code**:
```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase",
        "--project-url",
        "https://your-project.supabase.co",
        "--access-token",
        "your-service-role-key"
      ]
    }
  }
}
```

#### 3. Web MCP Servers (Optional)

Enhanced web research for discovery and planning phases.

**Available Servers**:
- `web-search-prime` - Enhanced web search
- `web-reader` - Extract content from URLs
- `zread` - Advanced GitHub repository reading

**Configure Claude Code**:
```json
{
  "mcpServers": {
    "web-search-prime": {
      "command": "npx",
      "args": ["-y", "web-search-prime-mcp-server"]
    },
    "web-reader": {
      "command": "npx",
      "args": ["-y", "web-reader-mcp-server"]
    },
    "zread": {
      "command": "npx",
      "args": ["-y", "zread-mcp-server"]
    }
  }
}
```

**Verify All MCP Servers**:
```bash
# In Claude Code, ask:
"Check all MCP server health"

# Should return status for each configured server
```

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/ryanjosebrosas/AI-Coding-System-Template.git
   cd AI-Coding-System-Template
   ```

2. **Configure MCP Servers** (see above)

3. **Run initial setup:**
   ```bash
   # Export codebase context
   /prime

   # Explore opportunities
   /discovery
   ```

4. **Build your reference library:**
   ```bash
   # Learn essential topics
   /learn python async patterns
   /learn react hooks
   /learn mcp server development

   # Check library health
   /learn-health
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
├── TECH SPEC.md           # Root Technical Specification
├── MVP.md                 # Minimum Viable Product definition
├── CLAUDE.md              # Developer guidelines
├── INDEX.md               # System navigation index
└── README.md              # This file
```

## Architecture

### Complete System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        AI CODING SYSTEM - COMPLETE ARCHITECTURE                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        MCP SERVER LAYER                                  │   │
│  ├──────────────────┬──────────────────┬──────────────────┬────────────────┤   │
│  │   Archon MCP     │   Supabase MCP   │   Web MCP        │   Future MCPs  │   │
│  │                  │                  │   Servers        │                │   │
│  │ • Task Mgmt      │ • Reference Lib  │ • Web Search     │ • Custom tools │   │
│  │ • Projects       │ • Queries        │ • Content Read   │                │   │
│  │ • RAG Knowledge  │ • Type Gen       │ • GitHub Read    │                │   │
│  │ • Documents      │                  │                  │                │   │
│  └──────────────────┴──────────────────┴──────────────────┴────────────────┘   │
│                                    │                                             │
│                                    ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        COMMAND LAYER                                     │   │
│  ├─────────────────────────────────────────────────────────────────────────┤   │
│  │  Workflow: /prime, /discovery, /planning, /development, /task-planning │   │
│  │            /execution, /review, /test, /workflow                        │   │
│  │  Library:  /learn, /learn-health                                         │   │
│  │  Utility:  /check, /update-index, /update-status                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                             │
│                                    ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        ARTIFACT LAYER                                     │   │
│  ├─────────────────────────────────────────────────────────────────────────┤   │
│  │  Context/    Discovery/  Features/     Templates/   Reviews/   Testing/  │   │
│  │  exports     ideas       PRDs, Specs,  PRPs         reports    results   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                             │
│                                    ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        DATA LAYER                                        │   │
│  ├─────────────────────────────────────────────────────────────────────────┤   │
│  │  Supabase:                                                              │   │
│  │  • archon_projects      - Feature tracking                               │   │
│  │  • archon_tasks         - Task management                                │   │
│  │  • archon_references    - Smart Reference Library (JSONB)                │   │
│  │  • archon_documents     - Doc storage                                    │   │
│  │  • archon_versions      - Version history                                │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Workflow Phases with MCP Integration

```
┌─────────┐    ┌──────────┐    ┌─────────┐    ┌──────────────┐    ┌──────────┐
│  Prime  │───▶│ Discovery│───▶│ Planning│───▶│Development  │───▶│Task Plan │
└─────────┘    └──────────┘    └─────────┘    └──────────────┘    └──────────┘
     │              │               │                │                │
     ▼              ▼               ▼                ▼                ▼
  Context       Discovery        PRD           TECH SPEC       PRP + Refs
 (Export)     (RAG+Web)      (Archon)       (Archon)       (Selective Load)
                                                                               │
                                                                               ▼
                                                                        ┌──────────┐
                                                                        │Execution │
                                                                        └──────────┘
                                                                               │
                                                                               ▼
                                                                        ┌──────────────────┐
                                                                        │ Tasks (Archon)   │
                                                                        │ • Status updates │
                                                                        │ • Progress track │
                                                                        │ • Context load   │
                                                                        └──────────────────┘
                                                                               │
                                                                               ▼
                                                                        ┌──────────────────┐
                                                                        │ Review + Test    │
                                                                        │ AI analysis      │
                                                                        └──────────────────┘
```

### Smart Reference Library Deep Dive

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    REFERENCE LIBRARY - COMPLETE WORKFLOW                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  PHASE 1: LEARN (Building the Library)                                         │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │                                                                          │  │
│  │  User: /learn python async patterns                                      │  │
│  │     │                                                                   │  │
│  │     ├─▶ Archon RAG: Search knowledge base                               │  │
│  │     │   • Query: "python async" (2-5 keywords!)                         │  │
│  │     │   • Returns: Relevant documentation pages                         │  │
│  │     │                                                                   │  │
│  │     ├─▶ Web MCP: Search external sources                                │  │
│  │     │   • web_search_prime_search()                                     │  │
│  │     │   • web_reader_read() for content extraction                      │  │
│  │     │                                                                   │  │
│  │     ├─▶ Digest: AI processes into structured format                     │  │
│  │     │   {                                                               │  │
│  │     │     "summary": "1-2 sentence overview",                           │  │
│  │     │     "insights": [                                                 │  │
│  │     │       "Actionable insight 1",                                     │  │
│  │     │       "Actionable insight 2"                                      │  │
│  │     │     ],                                                            │  │
│  │     │     "code_examples": [...]                                       │  │
│  │     │   }                                                               │  │
│  │     │                                                                   │  │
│  │     └─▶ Store: Supabase INSERT into archon_references                   │  │
│  │         • category: 'python'                                           │  │
│  │         • tags: ['python', 'async', 'patterns']                        │  │
│  │         • content: JSONB digest                                        │  │
│  │         • source_url: original source                                  │  │
│  │                                                                          │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│  PHASE 2: HEALTH CHECK (Monitoring)                                           │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │  User: /learn-health                                                      │  │
│  │     │                                                                     │  │
│  │     └─▶ Query: SELECT category, COUNT(*), ARRAY_AGG(tags)                │  │
│  │              FROM archon_references                                      │  │
│  │              GROUP BY category                                           │  │
│  │                                                                          │  │
│  │         Output:                                                           │  │
│  │         📊 Reference Library Health                                       │  │
│  │         ✓ python: 3 references (async, patterns, testing)               │  │
│  │         ✓ mcp: 2 references (servers, tools)                             │  │
│  │         ⚠ react: 1 reference (hooks) - SUGGEST: Learn components        │  │
│  │         ✗ typescript: 0 references - NEED ATTENTION                      │  │
│  │                                                                          │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│  PHASE 3: SELECTIVE LOADING (The Magic!)                                      │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │                                                                          │  │
│  │  PRP contains:                                                            │  │
│  │  ─────────────────────────────────────────────────────────────────────  │  │
│  │  ### Reference Library                                                   │  │
│  │  **Required Categories**: python, mcp                                    │  │
│  │  **Optional Tags**: async, testing                                       │  │
│  │                                                                          │  │
│  │  ─────────────────────────────────────────────────────────────────────  │  │
│  │                                                                          │  │
│  │  System executes:                                                         │  │
│  │  SELECT * FROM archon_references                                         │  │
│  │  WHERE category = 'python' OR category = 'mcp'                           │  │
│  │    OR ('async' = ANY(tags) OR 'testing' = ANY(tags))                    │  │
│  │                                                                          │  │
│  │  Result: ONLY 5 references loaded (vs 50+ total!)                        │  │
│  │  → 90% token savings!                                                    │  │
│  │  → Focused, relevant context!                                            │  │
│  │                                                                          │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Documentation

- **[PRD.md](./PRD.md)** - Complete product requirements
- **[TECH SPEC.md](./TECH%20SPEC.md)** - Technical specifications and architecture
- **[CLAUDE.md](./CLAUDE.md)** - Development guidelines and best practices
- **[MVP.md](./MVP.md)** - Minimum Viable Product definition
- **[INDEX.md](./INDEX.md)** - System navigation

## Examples

### Example 1: Building a Python MCP Server (Full Workflow)

This example demonstrates the complete workflow with MCP integration.

```bash
# ═══════════════════════════════════════════════════════════════
# PHASE 1: DISCOVERY - Explore with RAG and Web research
# ═══════════════════════════════════════════════════════════════

/discovery

# System actions:
# 1. Web MCP: Searches for "MCP server patterns", "AI agent best practices"
# 2. Archon RAG: Searches knowledge base for relevant documentation
# 3. Digests findings into discovery/ideas.md
# 4. Identifies "MCP Server for Python async operations" as opportunity

# ═══════════════════════════════════════════════════════════════
# PHASE 2: PLANNING - Generate PRD
# ═══════════════════════════════════════════════════════════════

/planning python-mcp-server

# System actions:
# 1. Reads discovery/ideas.md
# 2. Generates PRD with user stories, acceptance criteria
# 3. Stores PRD in features/python-mcp-server/prd.md
# 4. Creates Archon project for tracking

# Output: features/python-mcp-server/prd.md
# - Goal: Build MCP server for Python async operations
# - User stories, acceptance criteria, success metrics

# ═══════════════════════════════════════════════════════════════
# PHASE 3: DEVELOPMENT - Generate Technical Spec
# ═══════════════════════════════════════════════════════════════

/development python-mcp-server

# System actions:
# 1. Reads PRD from features/python-mcp-server/prd.md
# 2. Searches RAG for: "MCP server architecture", "Python async patterns"
# 3. Generates TECH SPEC with:
#    - Architecture diagram
#    - Technology stack recommendations
#    - API design
#    - Database schema
# 4. Stores in features/python-mcp-server/tech-spec.md

# Output: features/python-mcp-server/tech-spec.md
# - Stack: Python 3.11+, asyncio, custom MCP server framework
# - Architecture: Tool registry, request handler, response formatter

# ═══════════════════════════════════════════════════════════════
# PHASE 4: LEARN - Build Reference Library
# ═══════════════════════════════════════════════════════════════

# First, ensure we have relevant knowledge in our library:

/learn python async patterns
# → Archon RAG searches knowledge base
# → Web MCP searches for "python async await"
# → Digests into insights, stores to Supabase

/learn mcp server development
# → Searches for MCP server patterns
# → Stores best practices for tool definition

/learn-health
# → Verify coverage: python (2), mcp (1)
# → Suggests: Learn testing patterns

# ═══════════════════════════════════════════════════════════════
# PHASE 5: TASK PLANNING - Create PRP and Tasks
# ═══════════════════════════════════════════════════════════════

/task-planning python-mcp-server

# System actions:
# 1. Reads PRD and TECH SPEC
# 2. Searches codebase for similar patterns (Glob, Grep)
# 3. Loads relevant references from library:
#    - WHERE category IN ('python', 'mcp')
#    - OR 'async' = ANY(tags)
# 4. Generates PRP with implementation blueprint
# 5. Creates Archon tasks:
#    - Task 1: Set up project structure
#    - Task 2: Implement tool registry
#    - Task 3: Implement request handler
#    - Task 4: Add async support
#    - Task 5: Write tests
# 6. Stores PRP in features/python-mcp-server/prp.md

# Output: features/python-mcp-server/prp.md
# ### Reference Library
# **Required Categories**: python, mcp
# **Optional Tags**: async, testing
#
# ### Implementation Blueprint
# 1. Set up project structure (poetry, src/, tests/)
# 2. Implement tool registry (dictionary pattern from references)
# 3. Implement request handler (async def from references)
# ...

# ═══════════════════════════════════════════════════════════════
# PHASE 6: EXECUTION - Implement with Context
# ═══════════════════════════════════════════════════════════════

/execution python-mcp-server

# System actions:
# 1. Loads PRP (includes selective reference loading!)
# 2. Gets current task: find_tasks(filter_by="status", filter_value="todo")
# 3. Marks as doing: manage_task("update", task_id="t-1", status="doing")
# 4. Executes implementation:
#    - Creates project structure
#    - Implements tool registry (using patterns from references)
#    - Implements request handler (using async patterns from references)
# 5. Marks as review: manage_task("update", task_id="t-1", status="review")
# 6. Moves to next task...
#
# Context during execution:
# - PRP with implementation blueprint
# - Python async patterns (from reference library)
# - MCP server best practices (from reference library)
# - Codebase patterns (from search)
# Total: ~15,000 tokens (vs 150,000+ traditional!)

# ═══════════════════════════════════════════════════════════════
# PHASE 7: REVIEW - Quality Analysis
# ═══════════════════════════════════════════════════════════════

/review python-mcp-server

# System actions:
# 1. Scans feature code
# 2. Analyzes: code quality, security, performance
# 3. Generates review report in reviews/python-mcp-server.md
# 4. Marks all tasks as done: manage_task("update", task_id="...", status="done")

# ═══════════════════════════════════════════════════════════════
# PHASE 8: TEST - Validate Implementation
# ═══════════════════════════════════════════════════════════════

/test python-mcp-server

# System actions:
# 1. Runs test suite
# 2. Analyzes failures
# 3. AI suggests fixes
# 4. Generates coverage report

# ═══════════════════════════════════════════════════════════════
# RESULT: Complete feature delivered with MCP-powered intelligence!
# ═══════════════════════════════════════════════════════════════
```

### Example 2: Building a Reference Library (Deep Dive)

```bash
# ═══════════════════════════════════════════════════════════════
# SCENARIO: You're building a React app and need to learn hooks
# ═══════════════════════════════════════════════════════════════

# Step 1: Learn from a URL
/learn https://react.dev/reference/react

# System actions:
# 1. Web MCP: Reads and extracts content from URL
# 2. Archon RAG: Searches for "React hooks" in knowledge base
# 3. Digests into insights:
#    {
#      "summary": "React hooks for state and side effects",
#      "insights": [
#        "useState for local state",
#        "useEffect for side effects",
#        "useContext for context consumption"
#      ],
#      "code_examples": [...]
#    }
# 4. Stores to Supabase:
#    INSERT INTO archon_references (title, category, tags, content, ...)
#    VALUES ('React Hooks Reference', 'react', ARRAY['react', 'hooks'], ...)
#
# Result: Reference ID: abc-123, Category: react

# Step 2: Learn more specific topics
/learn react useState patterns
/learn react useEffect cleanup
/learn react context api

# Step 3: Check library health
/learn-health

# Output:
# 📊 Reference Library Health
# ═══════════════════════════════════════════════════════════════
# Category        References    Tags
# ──────────────────────────────────────────────────────────────
# ✓ python        3             async, type-hints, testing
# ✓ react         4             hooks, useState, useEffect, context
# ✓ mcp           1             server, tools
# ⚠ typescript    0             - NEED ATTENTION
# ⚠ testing       1             - SUGGEST: Learn jest, vitest
# ⚠ api           0             - SUGGEST: Learn REST patterns
#
# Total References: 8
# Categories Covered: 3/9 (33%)
# ═══════════════════════════════════════════════════════════════

# Step 4: Address gaps
/learn typescript utility types
/learn rest api design patterns

# Step 5: Use references during development
/task-planning react-dashboard
# PRP includes:
# ### Reference Library
# **Required Categories**: react, typescript
#
# System loads ONLY react + typescript references (6 items)
# → Token savings: 75% (vs loading all 12 references!)
```

### Example 3: Discovery with Web MCP Research

```bash
# ═══════════════════════════════════════════════════════════════
# SCENARIO: Exploring AI agent architecture patterns
# ═══════════════════════════════════════════════════════════════
/discovery

# System actions (with Web MCP):
#
# 1. Web Search (web-search-prime):
#    query: "AI agent architecture patterns 2026"
#    → Returns 5 relevant URLs
#
# 2. Content Extraction (web-reader):
#    URL 1: https://blog.anthropic.com/ai-agents
#    → Extracts: "Agentic workflows", "Tool use patterns"
#
#    URL 2: https://arxiv.org/abs/2401.12345
#    → Extracts: "Multi-agent systems", "Coordination strategies"
#
# 3. GitHub Repository Search (zread):
#    repo: langchain-ai/langchain
#    query: "agent patterns"
#    → Finds: AgentExecutor, ToolRegistry patterns
#
# 4. Archon RAG Search:
#    query: "agent patterns"
#    → Returns: Relevant documentation from knowledge base
#
# 5. Digest and Organize:
#    discovery/ideas.md:
#    ## AI Agent Architecture Opportunities
#    ### Pattern 1: Tool-Calling Agents
#    - Single agent with dynamic tool selection
#    - Use case: Question answering with calculations
#    - Reference: Anthropic blog post
#
#    ### Pattern 2: Multi-Agent Systems
#    - Specialized agents with coordinator
#    - Use case: Complex workflows requiring expertise
#    - Reference: arXiv paper
#
#    ### Pattern 3: Supervised Autonomy
#    - Human-in-the-loop for critical decisions
#    - Use case: High-stakes decision making
#    - Reference: LangChain implementation
#
# ═══════════════════════════════════════════════════════════════
# RESULT: Comprehensive opportunity analysis with web research!
# ═══════════════════════════════════════════════════════════════
```

### Example 4: Resume Capability

```bash
# Start full workflow
/workflow user-authentication

# System starts executing:
# → Discovery complete ✓
# → Planning complete ✓
# → Development complete ✓
# → Task Planning complete ✓
# → Execution: Task 1 in progress...

# ⚠️ POWER LOSS! Session interrupted.

# Resume from where we left off:
/workflow user-authentication --from-execution

# System checks:
# → Discovery phase: Complete (prd.md exists)
# → Planning phase: Complete (tech-spec.md exists)
# → Development phase: Complete (tech-spec.md exists)
# → Task Planning phase: Complete (prp.md exists)
# → Execution phase: Incomplete (Task 1 in doing status)
#
# System action:
# → Skips to Execution phase
# → Continues from Task 1
# → Completes remaining tasks

# No duplicate work! Smart resume!
```

### Example 5: MCP Tools in Action

```bash
# Direct MCP tool usage during development

# Task: Find async patterns for Python MCP server

# Option 1: Ask AI (recommended)
"How do I implement async tool execution in my MCP server?"

# AI uses Archon RAG:
# 1. rag_search_knowledge_base(query="python async")
# 2. Finds relevant documentation
# 3. rag_search_code_examples(query="asyncio gather")
# 4. Loads code examples
# 5. Provides answer with examples

# Option 2: Direct query (advanced)
# AI executes:
find_tasks(filter_by="status", filter_value="todo")
# → Returns: Task 2: Implement async tool execution

manage_task("update", task_id="t-2", status="doing")
# → Marks as in progress

rag_search_knowledge_base(query="python async patterns")
# → Returns: 3 relevant pages with async patterns

rag_search_code_examples(query="asyncio tool execution")
# → Returns: 2 code examples

# AI implements based on research
manage_task("update", task_id="t-2", status="review")
# → Marks for review
```

## MCP Server Capabilities

### Archon MCP - Task & Knowledge Management

Archon MCP is the **central intelligence hub** for this system, providing:

| Tool | Purpose | Usage Example |
|------|---------|---------------|
| `manage_project()` | Create/update/delete projects | `manage_project("create", title="Auth Feature")` |
| `find_projects()` | List/search projects | `find_projects(query="auth")` |
| `manage_task()` | Create/update/delete tasks | `manage_task("create", project_id="p-1", title="Setup")` |
| `find_tasks()` | Query tasks by status/project | `find_tasks(filter_by="status", filter_value="todo")` |
| `rag_search_knowledge_base()` | Search documentation RAG | `rag_search_knowledge_base(query="async python")` |
| `rag_search_code_examples()` | Find code examples | `rag_search_code_examples(query="React hooks")` |
| `rag_get_available_sources()` | List knowledge sources | Get available documentation sources |
| `rag_read_full_page()` | Read full page content | Read complete documentation page |
| `manage_document()` | Store project documents | `manage_document("create", project_id="p-1", ...)` |
| `health_check()` | Verify server status | Check if MCP is available |

**Task Status Flow**: `todo` → `doing` → `review` → `done`

**Key Features**:
- **RAG Knowledge Base**: Pre-loaded with technical documentation (PydanticAI, Supabase, etc.)
- **Project Hierarchy**: Organize features, track progress across multiple workstreams
- **Task Dependencies**: Block/unblock tasks for complex workflows
- **Version History**: Track changes to docs, features, PRDs

### Supabase MCP - Database Operations

Supabase MCP provides the **persistence layer** for the Smart Reference Library:

| Tool | Purpose | Usage Example |
|------|---------|---------------|
| `execute_sql()` | Run raw SQL queries | `SELECT * FROM archon_references` |
| `apply_migration()` | Apply schema migrations | Create new tables |
| `list_tables()` | Show database tables | View available tables |
| `generate_typescript_types()` | Generate TS types | Auto-generate type definitions |
| `get_project_url()` | Get Supabase API URL | Configure API connections |

**Key Tables**:
- `archon_projects` - Feature tracking
- `archon_tasks` - Task management with dependencies
- `archon_references` - Smart Reference Library (JSONB content)
- `archon_documents` - Document storage
- `archon_versions` - Version history

### Web MCP Servers - External Research

Web MCP servers enable **intelligent web research** during Discovery and Planning:

| Tool | Purpose | Usage Example |
|------|---------|---------------|
| `web_search_prime_search()` | Enhanced web search | Find AI agent patterns |
| `web_reader_read()` | Extract page content | Read documentation URLs |
| `get_repo_structure()` | Explore GitHub repos | Browse repository structure |
| `read_file()` | Read GitHub files | Get specific file content |
| `search_doc()` | Search repo docs | Find issues/docs in repos |

**Benefits over built-in web search**:
- **Token optimization** - Extract only relevant content
- **Structured output** - Markdown-ready formatting
- **GitHub integration** - Direct repository access
- **Caching** - Avoid re-fetching same content

## Reference Library System

### Standard Categories

| Category | Description | Example Topics |
|----------|-------------|----------------|
| `python` | Python patterns, libraries | async, FastAPI, Django, type hints |
| `mcp` | MCP server development | tools, server setup, best practices |
| `react` | React, Next.js, hooks | useState, useEffect, components |
| `typescript` | TypeScript/JavaScript | generics, utility types, patterns |
| `ai-agents` | AI agent patterns | prompting, RAG, tool use |
| `testing` | Testing frameworks | pytest, jest, vitest |
| `patterns` | General design patterns | DRY, KISS, SOLID |
| `supabase` | Supabase/database | RLS, queries, auth |
| `api` | API design | REST, GraphQL, OpenAPI |

### Tag System

Tags provide **fine-grained filtering** beyond categories:

```sql
-- Reference with category + tags
{
  "category": "python",
  "tags": ["python", "async", "await", "asyncio", "concurrency"]
}

-- Query with flexible tag matching
SELECT * FROM archon_references
WHERE category = 'python'
  OR 'async' = ANY(tags)  -- Match specific tag
  OR 'concurrency' = ANY(tags)
```

### Real-World Usage Examples

**Example 1: Learning Python Async Patterns**
```bash
# Step 1: Learn from gist
/learn https://gist.github.com/.../python-async-guide

# Result: Reference stored
# - category: python
# - tags: ['python', 'async', 'asyncio', 'await', 'concurrency']
# - content: {summary, insights, code_examples}

# Step 2: Use during development
/task-planning python-mcp-server
# PRP includes:
# "Required Categories: python, mcp"
# "Optional Tags: async, testing"

# Result: ONLY python + mcp references loaded!
# Including the async patterns we just learned!
```

**Example 2: Building Knowledge Over Time**
```bash
# Learn incrementally
/learn python type hints          # → python (1)
/learn python async patterns      # → python (2)
/learn mcp server development     # → mcp (1)
/learn react hooks                # → react (1)

# Check health
/learn-health
# Output:
# 📊 Reference Library Health
# ✓ python: 2 references
# ✓ mcp: 1 reference
# ✓ react: 1 reference
# ⚠ typescript: 0 references - SUGGEST: Learn TypeScript basics
# ⚠ testing: 0 references - SUGGEST: Learn pytest patterns

# Address gaps
/learn typescript utility types
/learn pytest fixtures
```

**Example 3: Selective Loading in Action**
```bash
# Scenario: Building an MCP server in Python

# PRP specifies:
### Reference Library
**Required Categories**: python, mcp
**Optional Tags**: async, testing

# System executes:
SELECT * FROM archon_references
WHERE category IN ('python', 'mcp')
  OR 'async' = ANY(tags)
  OR 'testing' = ANY(tags);

# Results (5 references loaded):
1. Python async patterns (learned from gist)
2. Python type hints (learned from docs)
3. MCP server development (learned from web)
4. Async context managers (python + async tag)
5. Pytest fixture patterns (python + testing tag)

# NOT loaded:
- React hooks (wrong category)
- TypeScript generics (wrong category)
- Supabase RLS policies (wrong category)

# Token savings:
# Total library: 20 references
# Loaded for task: 5 references
# Savings: 75% fewer tokens!
```

## Archon MCP Integration

This system deeply integrates with Archon MCP for:

### Task Management
- **Create tasks** with `manage_task("create", ...)` during `/task-planning`
- **Update status** as work progresses: `todo` → `doing` → `review` → `done`
- **Track dependencies** with `addBlockedBy` and `addBlocks`
- **Query tasks** by status, project, or assignee

### Knowledge Base
- **Search documentation** with `rag_search_knowledge_base()`
- **Find code examples** with `rag_search_code_examples()`
- **List sources** to see available documentation
- **Read full pages** for complete context

### Project Organization
- **Create projects** for each feature
- **Link tasks** to projects
- **Store documents** (PRDs, specs) per project
- **Track versions** of documentation

### Required Archon Tools

The following Archon MCP tools are **required** for full functionality:

**Task Management**:
- `manage_task(action, project_id, title, ...)` - Create/update/delete tasks
- `find_tasks(task_id, query, filter_by, ...)` - Query tasks

**Project Management**:
- `manage_project(action, title, description, ...)` - Create/update projects
- `find_projects(project_id, query, ...)` - Query projects

**Knowledge Base (RAG)**:
- `rag_search_knowledge_base(query, source_id, ...)` - Search docs
- `rag_search_code_examples(query, source_id, ...)` - Find examples
- `rag_get_available_sources()` - List documentation sources
- `rag_read_full_page(page_id, url)` - Read complete pages

**Documents**:
- `manage_document(action, project_id, title, ...)` - Store docs
- `find_documents(project_id, document_id, query, ...)` - Query docs

**Health**:
- `health_check()` - Verify server availability

## Token Efficiency Strategy

This system is **architected for token efficiency** at every level:

### 1. Selective Context Loading

**Problem**: Loading entire codebases and documentation bases wastes tokens.

**Solution**: Load ONLY what's needed for the current task.

```
┌─────────────────────────────────────────────────────────────┐
│  TRADITIONAL APPROACH (Token-Heavy)                         │
├─────────────────────────────────────────────────────────────┤
│  Load ALL references → 50,000+ tokens                       │
│  Load ALL codebase → 100,000+ tokens                        │
│  Load ALL docs → 75,000+ tokens                             │
│  ─────────────────────────────────────────                  │
│  Total: 225,000+ tokens per task!                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  THIS SYSTEM (Token-Efficient)                              │
├─────────────────────────────────────────────────────────────┤
│  Load ONLY relevant references → 5,000 tokens               │
│  Load ONLY current feature files → 10,000 tokens            │
│  Load ONLY required docs → 3,000 tokens                     │
│  ─────────────────────────────────────────                  │
│  Total: 18,000 tokens per task (92% savings!)               │
└─────────────────────────────────────────────────────────────┘
```

### 2. Digestion vs. Raw Storage

**Store insights, not articles**:

```sql
-- BAD: Store full article (10,000+ tokens)
content: "Full article text with all the fluff..."

-- GOOD: Store digested insights (500 tokens)
content: {
  "summary": "Python async/await patterns for concurrent I/O",
  "insights": [
    "Use asyncio.gather() to run multiple coroutines concurrently",
    "Always use async/await consistently - don't mix sync and async",
    "Use asyncio.create_task() for fire-and-forget operations"
  ],
  "code_examples": [
    {
      "title": "Concurrent HTTP requests",
      "language": "python",
      "code": "async def fetch_all(urls):\n    ..."
    }
  ]
}
```

**Result**: 95% token reduction, same actionable knowledge!

### 3. Lazy Loading Strategy

```
Task starts → Check PRP for required categories
              ↓
              Query Supabase: WHERE category IN (required)
              ↓
              Load ONLY matching references (5-10 items)
              ↓
              Execute task with focused context
```

### 4. Caching Strategy

- **Archon RAG**: Cached knowledge base for fast doc searches
- **Web MCP**: Optional caching for frequently accessed URLs
- **Supabase**: Indexed queries on category/tags for fast lookups

### Token Savings Calculation

```
Scenario: Building an MCP server in Python

Traditional Approach:
├─ All references (20 items × 2,000 tokens)    = 40,000 tokens
├─ All codebase files                         = 80,000 tokens
├─ All documentation                          = 30,000 tokens
└─ Total                                      = 150,000 tokens

This System:
├─ Relevant refs only (5 items × 500 tokens)  = 2,500 tokens
├─ Current feature files                      = 10,000 tokens
├─ Required docs only                         = 3,000 tokens
└─ Total                                      = 15,500 tokens

SAVINGS: 134,500 tokens (90% reduction!)
```

### Best Practices for Token Efficiency

1. **Be specific with PRP categories**: Only request what you need
2. **Use tags for fine filtering**: `['async', 'testing']` vs loading all Python
3. **Keep insights concise**: 3-5 bullet points, not 20
4. **Code examples**: Only include directly relevant snippets
5. **Avoid redundant info**: Don't repeat the same pattern across references

## Contributing

Contributions are welcome! This is an open-source template for AI-assisted development.

Areas for contribution:
- Additional PRP templates for different feature types
- New workflow commands
- Enhanced MCP integrations
- Documentation improvements
- Bug fixes and optimizations

## License

MIT License - See LICENSE file for details

## Acknowledgments

Built with:
- **[Claude Code CLI](https://claude.ai/claude-code)** - Primary AI assistant interface
- **[Archon MCP](https://github.com/your-repo/archon)** - Task management, knowledge base, RAG
- **[Supabase](https://supabase.com)** - Database for Smart Reference Library
- **Web MCP Servers** - Enhanced web research (web-search-prime, web-reader, zread)

Inspired by:
- PEP 20 (The Zen of Python)
- The Hitchhiker's Guide to Python
- Khan Academy Development Docs
- The Pragmatic Programmer

## System Status

| Component | Status | Notes |
|-----------|--------|-------|
| Core Commands | ✅ Stable | /prime, /discovery, /planning, /development, etc. |
| Archon Integration | ✅ Active | Task management, RAG knowledge base |
| Reference Library | ✅ Active | Supabase-backed, selective loading |
| Web MCP Integration | ✅ Active | Enhanced research capabilities |
| Documentation | ✅ Complete | Comprehensive README and CLAUDE.md |

## FAQ

**Q: Do I need all MCP servers to use this system?**

A: No! The system works with Claude Code alone. MCP servers provide **enhanced capabilities**:
- **Archon MCP**: Task tracking, RAG knowledge base (recommended)
- **Supabase MCP**: Smart Reference Library (recommended)
- **Web MCP**: Better web research (optional)

**Q: How much does this cost in tokens?**

A: The system is designed for token efficiency:
- Traditional approach: 150,000+ tokens per task
- This system: ~15,000 tokens per task (90% savings)
- Selective reference loading is the key

**Q: Can I use this without Supabase?**

A: Yes! The Smart Reference Library is optional. Without it:
- `/learn` command won't store references
- PRPs won't load external references
- System still works with codebase context only

**Q: How do I add new PRP templates?**

A: Create new template files in `templates/prp/`:
```bash
# Example: templates/prp/prp-api-endpoint.md
---
### Reference Library
**Required Categories**: api, {language}

### Implementation Blueprint
1. Define API endpoint
2. Implement request validation
3. Implement business logic
4. Add error handling
5. Write tests
---
```

**Q: Can I customize the workflow phases?**

A: Yes! Edit workflow command files in `.claude/commands/`:
- `workflow.md` - Full pipeline
- Individual phase commands - `/planning`, `/development`, etc.

**Q: How do I migrate my existing project?**

A: Three steps:
1. Clone this repo into your project root
2. Run `/prime` to export your codebase
3. Run `/discovery` to explore opportunities

---

**GitHub Repository**: https://github.com/ryanjosebrosas/AI-Coding-System-Template

**Template Version**: 1.1
**Last Updated**: 2026-01-25
**MCP Integration**: Archon + Supabase + Web MCP servers
