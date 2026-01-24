# AI Coding System Template

> **Build better software with AI** - A complete framework for AI-assisted development with intelligent task management, token-efficient context loading, and a smart reference library.

## Summary

This system helps you build software features using AI assistants in a structured, efficient way. Instead of chaotic prompts and lost context, you get:

- **15+ Commands** - From discovery (`/discovery`) to deployment (`/workflow`)
- **PIV Loop Methodology** - Purpose → Implementation → Validation (bit-by-bit execution)
- **Archon MCP Integration** - Task tracking with `todo` → `doing` → `review` → `done`
- **Smart Reference Library** - Store what you learn (`/learn`), load only what you need
- **90% Token Savings** - Selective context loading vs dumping everything

**In a nutshell**: You run `/workflow {feature-name}` and the system guides you through ideation, requirements, technical design, implementation, review, and testing - with AI executing tasks one at a time, tracking progress, and learning from each project.

**Perfect for**: Developers using Claude Code who want a systematic approach to AI-assisted development.

---

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

## The PIV Loop: AI Coding Methodology

At the core of this system is the **PIV Loop** - a structured approach to AI-assisted development that ensures clarity, actionable steps, and systematic progress tracking.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         THE PIV LOOP - AI CODING METHODOLOGY                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  PHASE 1: PURPOSE (Idea → Distinction)                                   │   │
│  │  ─────────────────────────────────────────────────────────────────────  │   │
│  │  1. GET IDEA                                                             │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Discovery   │───▶│ Brainstorm  │───▶│ Identify    │              │   │
│  │     │ Phase       │    │ Opportunities│    │  Concepts   │              │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "What should      "What problems     "What could                   │   │
│  │      we build?"        can we solve?"     we create?"                  │   │
│  │                                                                          │   │
│  │  2. CLEAR DISTINCTION                                                     │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Define      │───▶│ Clarify     │───▶│ Bound       │              │   │
│  │     │ Scope       │    │ Boundaries  │    │ Context     │              │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "What exactly      "What's IN        "What's the                   │   │
│  │      is this?"         scope?"            context?"                   │   │
│  │                                                                          │   │
│  │  Output: Clear, well-defined concept with scope and boundaries           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                           │
│                                    ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  PHASE 2: IMPLEMENTATION (Details → Actionable Steps)                    │   │
│  │  ─────────────────────────────────────────────────────────────────────  │   │
│  │  3. ADD DETAILS                                                          │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Technical   │───▶│ Requirements│───▶│ Constraints │              │   │
│  │     │ Research    │    │ Analysis    │    │ Definition │              │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "How do we        "What must        "What limits                  │   │
│  │      build it?"       it do?"            us?"                        │   │
│  │                                                                          │   │
│  │  4. TURN INTO ACTIONABLE STEPS                                           │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Break       │───▶│ Prioritize │───▶│ Create      │              │   │
│  │     │ Down        │    │ Order      │    │ Dependencies│              │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "What are the      "What order       "What blocks                  │   │
│  │      small steps?"      should we do?"    what?"                       │   │
│  │                                                                          │   │
│  │  Output: Archon tasks with clear priorities and dependencies             │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                           │
│                                    ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  PHASE 3: VALIDATION (Execute → Verify → Iterate)                       │   │
│  │  ─────────────────────────────────────────────────────────────────────  │   │
│  │  5. AI AUTOMATICALLY FOLLOWS TASKS 1 BY 1 (Archon PM)                    │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Get Task    │───▶│ Mark Doing  │───▶│ Execute     │              │   │
│  │     │ (todo)      │    │ (doing)     │    │ Implementation│           │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "What's next?      "I'm working       "Build this                   │   │
│  │      to do?"          on this"           feature"                     │   │
│  │                                                                          │   │
│  │  6. VALIDATE AND ITERATE                                                   │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │   │
│  │     │ Mark Review │───▶│ Test        │───▶│ Mark Done   │              │   │
│  │     │ (review)    │    │ Results     │    │ (done)      │              │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘              │   │
│  │           │                  │                  │                       │   │
│  │           ▼                  ▼                  ▼                       │   │
│  │     "Is this right?    "Does it work?    "Complete!"                   │   │
│  │      Ready to test?"   Pass or fail?"                                 │   │
│  │                                                                          │   │
│  │  7. GET NEXT TASK AND REPEAT                                               │   │
│  │     └──────────────────────────────────────────────────────────────┐    │   │
│  │                                                                      │    │   │
│  │     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │    │   │
│  │     │ Find Tasks  │───▶│ Pick Next   │───▶│ Continue    │         │    │   │
│  │     │ (status:    │    │ todo Task   │    │ Loop        │         │    │   │
│  │     │  todo)      │    │             │    │             │         │    │   │
│  │     └─────────────┘    └─────────────┘    └─────────────┘         │    │   │
│  │                                                                      │    │   │
│  │     If all tasks done → VALIDATION COMPLETE                          │    │   │
│  │     If issues found → CREATE IMPROVEMENT TASKS → RESTART LOOP        │    │   │
│  │                                                                          │   │
│  │  Output: Completed feature with tested, working code                   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### How PIV Works with Archon MCP

The PIV Loop is **powered by Archon MCP** for seamless task management:

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    PIV LOOP + ARCHON MCP INTEGRATION                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  PURPOSE PHASE                                                                  │
│  ─────────────                                                                  │
│  /discovery → Generate ideas                                                   │
│  /planning {feature} → Create PRD                                              │
│  /development {feature} → Create TECH SPEC                                     │
│  manage_project("create", title="Feature Name") → Create project               │
│                                                                                 │
│  IMPLEMENTATION PHASE                                                           │
│  ────────────────────                                                           │
│  /task-planning {feature} → Create PRP with blueprint                          │
│  manage_task("create", ...) for each step → Create tasks in Archon             │
│  Set task_order for priority (0-100, higher = more priority)                   │
│  Set addBlockedBy for dependencies                                             │
│                                                                                 │
│  VALIDATION PHASE (AI Automated Execution)                                      │
│  ────────────────────────────────────────                                      │
│                                                                                 │
│  LOOP (Repeat for each task):                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                          │   │
│  │  1. FIND NEXT TASK                                                      │   │
│  │     find_tasks(filter_by="status", filter_value="todo")                  │   │
│  │     → Returns: [{id: "t-1", title: "Setup project", ...}]               │   │
│  │                                                                          │   │
│  │  2. CHECK DEPENDENCIES                                                   │   │
│  │     find_tasks(task_id="t-1") → Check blockedBy field                   │   │
│  │     If blocked → Skip to next unblocked task                            │   │
│  │                                                                          │   │
│  │  3. MARK AS IN PROGRESS                                                  │   │
│  │     manage_task("update", task_id="t-1", status="doing")                │   │
│  │     → Archon tracks: Only ONE task in "doing" at a time                 │   │
│  │                                                                          │   │
│  │  4. LOAD CONTEXT                                                        │   │
│  │     - Load PRP (contains blueprint)                                     │   │
│  │     - Load relevant references (SELECTIVE loading!)                      │   │
│  │     - Load codebase patterns                                           │   │
│  │     → AI has ONLY what it needs for THIS task                          │   │
│  │                                                                          │   │
│  │  5. EXECUTE IMPLEMENTATION                                              │   │
│  │     - Follow PRP blueprint for this task                                │   │
│  │     - Write/create code following patterns                              │   │
│  │     - Apply insights from reference library                             │   │
│  │                                                                          │   │
│  │  6. MARK FOR REVIEW                                                     │   │
│  │     manage_task("update", task_id="t-1", status="review")               │   │
│  │     → Task awaits validation                                           │   │
│  │                                                                          │   │
│  │  7. VALIDATE                                                            │   │
│  │     - Run tests if applicable                                           │   │
│  │     - Verify implementation matches requirements                        │   │
│  │     - Check for edge cases                                             │   │
│  │                                                                          │   │
│  │  8. MARK AS COMPLETE                                                    │   │
│  │     If validation passes:                                               │   │
│  │       manage_task("update", task_id="t-1", status="done")               │   │
│  │     → Task complete, unblocks dependent tasks                           │   │
│  │                                                                          │   │
│  │  9. GET NEXT TASK                                                       │   │
│  │     find_tasks(filter_by="status", filter_value="todo")                 │   │
│  │     → Continue loop until all tasks complete                            │   │
│  │                                                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ALL TASKS COMPLETE → VALIDATION PHASE COMPLETE                                 │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### PIV Loop Principles

| Principle | Description | Archon Integration |
|-----------|-------------|-------------------|
| **Bit by Bit** | Break work into smallest executable units | Each task = 30min - 4 hours |
| **Clear Distinction** | Every task has clear boundaries and scope | Task description specifies exact scope |
| **Actionable Steps** | Tasks are concrete, not abstract | PRP provides implementation blueprint |
| **One at a Time** | Only one task in progress at any time | `status="doing"` enforced by system |
| **Dependencies First** | Blocked tasks wait for prerequisites | `addBlockedBy` field tracks dependencies |
| **Validate Before Moving** | Review each task before marking done | `status="review"` ensures validation |

### Real-World PIV Example

**Building a Python MCP Server for Async Operations**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  PURPOSE PHASE: Idea → Distinction                                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  1. GET IDEA: "Build an MCP server that exposes Python async operations"        │
│     Source: /discovery → Found gap in async tooling                            │
│                                                                                 │
│  2. CLEAR DISTINCTION:                                                         │
│     IN SCOPE:                                                                   │
│     - MCP server for Python asyncio operations                                  │
│     - Tool execution with async/await support                                  │
│     - Basic error handling                                                     │
│                                                                                 │
│     OUT OF SCOPE:                                                               │
│     - Advanced features (streaming, batching)                                  │
│     - Multi-language support                                                   │
│     - Production deployment                                                    │
│                                                                                 │
│  3. GENERATE ARTIFACTS:                                                         │
│     /planning python-mcp-server → PRD.md                                       │
│     /development python-mcp-server → TECH SPEC.md                              │
│     manage_project("create", title="Python MCP Server")                        │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  IMPLEMENTATION PHASE: Details → Actionable Steps                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  4. ADD DETAILS:                                                                │
│     - Stack: Python 3.11+, asyncio, MCP SDK                                    │
│     - Architecture: Tool registry, request handler, response formatter         │
│     - Requirements: Tool name, parameters, async execution                     │
│                                                                                 │
│  5. CREATE ACTIONABLE STEPS (Archon Tasks):                                    │
│     manage_task("create", title="Set up project structure", task_order=10)     │
│     manage_task("create", title="Implement tool registry", task_order=9)        │
│     manage_task("create", title="Implement request handler", task_order=8,     │
│                  addBlockedBy=["t-2"])  # Depends on tool registry            │
│     manage_task("create", title="Add async execution support", task_order=7,   │
│                  addBlockedBy=["t-3"])  # Depends on handler                 │
│     manage_task("create", title="Write unit tests", task_order=6,              │
│                  addBlockedBy=["t-4"])  # Depends on execution                │
│     manage_task("create", title="Add error handling", task_order=5,            │
│                  addBlockedBy=["t-4"])  # Depends on execution                │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  VALIDATION PHASE: AI Automatically Follows Tasks 1 by 1                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  TASK 1: "Set up project structure"                                            │
│  ─────────────────────────────────────────                                  │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 1 (no dependencies)                                           │
│  manage_task("update", task_id="t-1", status="doing")                          │
│  → AI executes: Creates pyproject.toml, src/, tests/                           │
│  manage_task("update", task_id="t-1", status="review")                         │
│  → Validation: Directory structure exists                                      │
│  manage_task("update", task_id="t-1", status="done")                           │
│  → Task complete!                                                              │
│                                                                                 │
│  TASK 2: "Implement tool registry"                                             │
│  ────────────────────────────────────────                                     │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 2 (no dependencies)                                           │
│  manage_task("update", task_id="t-2", status="doing")                          │
│  → AI executes: Creates ToolRegistry class with register(), get() methods      │
│  manage_task("update", task_id="t-2", status="review")                         │
│  → Validation: Can register and retrieve tools                                 │
│  manage_task("update", task_id="t-2", status="done")                           │
│  → Task complete! Unblocks Task 3                                              │
│                                                                                 │
│  TASK 3: "Implement request handler"                                           │
│  ────────────────────────────────────────                                     │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 3 (was blocked by Task 2, now unblocked!)                     │
│  manage_task("update", task_id="t-3", status="doing")                          │
│  → AI executes: Creates RequestHandler with async def handle()                 │
│  manage_task("update", task_id="t-3", status="review")                         │
│  → Validation: Handler processes requests correctly                            │
│  manage_task("update", task_id="t-3", status="done")                           │
│  → Task complete! Unblocks Task 4 and 5                                        │
│                                                                                 │
│  TASK 4: "Add async execution support"                                         │
│  ────────────────────────────────────────                                     │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 4 (was blocked by Task 3, now unblocked!)                     │
│  manage_task("update", task_id="t-4", status="doing")                          │
│  → AI executes: Implements asyncio.gather() for concurrent tool execution       │
│  manage_task("update", task_id="t-4", status="review")                         │
│  → Validation: Tools execute concurrently                                     │
│  manage_task("update", task_id="t-4", status="done")                           │
│  → Task complete! Unblocks Task 5                                               │
│                                                                                 │
│  TASK 5: "Write unit tests"                                                    │
│  ─────────────────────────────────                                        │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 5 (now unblocked)                                             │
│  manage_task("update", task_id="t-5", status="doing")                          │
│  → AI executes: Creates pytest tests for all components                        │
│  manage_task("update", task_id="t-5", status="review")                         │
│  → Validation: All tests pass                                                 │
│  manage_task("update", task_id="t-5", status="done")                           │
│  → Task complete!                                                              │
│                                                                                 │
│  TASK 6: "Add error handling"                                                  │
│  ──────────────────────────────────                                          │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: Task 6 (now unblocked)                                             │
│  manage_task("update", task_id="t-6", status="doing")                          │
│  → AI executes: Adds try/except blocks, error responses                        │
│  manage_task("update", task_id="t-6", status="review")                         │
│  → Validation: Errors handled gracefully                                      │
│  manage_task("update", task_id="t-6", status="done")                           │
│  → Task complete!                                                              │
│                                                                                 │
│  find_tasks(filter_by="status", filter_value="todo")                           │
│  → Returns: [] (No more tasks!)                                                │
│                                                                                 │
│  ✓ VALIDATION PHASE COMPLETE - ALL TASKS DONE                                  │
│  ✓ Feature fully implemented, tested, and working                              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Why PIV Works

**Traditional Development**:
```
Idea → Long period of confusion → Rushed implementation → Bug fixes
```

**PIV Loop with Archon**:
```
Purpose → Clear scope → Detailed breakdown → Actionable steps
→ AI executes one by one → Validate each step → Complete feature
```

**Key Benefits**:
1. **Clarity**: Every task has clear purpose and scope
2. **Focus**: AI works on ONE task at a time with focused context
3. **Traceability**: Archon tracks every task status and dependency
4. **Quality**: Each task validated before moving forward
5. **Recoverable**: Can interrupt and resume at any task
6. **Token Efficient**: Only load context for current task

### PIV Loop Applies to This System Too

**This AI Coding System itself is built and improved using the PIV Loop methodology.**

The system is designed to **self-improve** - you can use the exact same PIV workflow to enhance this system:

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│          USING PIV LOOP TO IMPROVE THIS AI CODING SYSTEM                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  EXAMPLE 1: Adding a New Command to the System                                  │
│  ───────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  PURPOSE PHASE                                                                  │
│  ─────────────                                                                  │
│  Idea: "Add /deploy command for automated deployment"                           │
│  → /discovery → Identify deployment automation as opportunity                   │
│  → /planning deploy-command → Create PRD for deploy command                     │
│  → /development deploy-command → Design command architecture                    │
│  → manage_project("create", title="Deploy Command Feature")                     │
│                                                                                 │
│  IMPLEMENTATION PHASE                                                           │
│  ────────────────────                                                           │
│  Details:                                                                        │
│  - Command should integrate with existing workflow                              │
│  - Support multiple deployment targets (Docker, cloud, etc.)                    │
│  - Include rollback capability                                                  │
│                                                                                 │
│  Actionable Steps (Archon Tasks):                                               │
│  → Task 1: Create .claude/commands/deploy.md command file                      │
│  → Task 2: Implement deployment logic                                           │
│  → Task 3: Add rollback mechanism                                               │
│  → Task 4: Write tests for deploy command                                      │
│  → Task 5: Update README with /deploy documentation                            │
│                                                                                 │
│  VALIDATION PHASE                                                               │
│  ────────────────                                                               │
│  AI executes each task one by one:                                              │
│  → Creates command file following existing patterns                             │
│  → Implements deployment using system's reference library                       │
│  → Validates each step before moving to next                                    │
│  → Tests and validates the complete feature                                     │
│                                                                                 │
│  Result: New command seamlessly integrated into the system!                     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│          EXAMPLE 2: IMPROVING THE REFERENCE LIBRARY                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  PURPOSE PHASE                                                                  │
│  ─────────────                                                                  │
│  Idea: "The system lacks TypeScript patterns references"                        │
│  → /learn-health → Reveals gap: typescript (0 references)                      │
│  → /planning typescript-library → Create PRD for TS reference expansion        │
│                                                                                 │
│  IMPLEMENTATION PHASE                                                           │
│  ────────────────────                                                           │
│  Actionable Steps:                                                              │
│  → Task 1: Learn TypeScript utility types (/learn ts utility types)            │
│  → Task 2: Learn TypeScript generics (/learn ts generics)                      │
│  → Task 3: Learn TypeScript patterns (/learn ts patterns)                      │
│  → Task 4: Update PRP templates to include typescript category                 │
│  → Task 5: Validate reference loading works correctly                          │
│                                                                                 │
│  VALIDATION PHASE                                                               │
│  ────────────────                                                               │
│  AI executes:                                                                   │
│  → Searches RAG and web for TypeScript best practices                          │
│  → Digests findings and stores to Supabase                                     │
│  → Updates templates to load TS references when needed                         │
│  → Validates that references load selectively                                  │
│                                                                                 │
│  Result: System now supports TypeScript development workflows!                  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│          EXAMPLE 3: ENHANCING MCP INTEGRATION                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  PURPOSE PHASE                                                                  │
│  ─────────────                                                                  │
│  Idea: "Add GitHub MCP integration for repository operations"                    │
│  → /discovery → Found opportunity to improve code analysis                      │
│  → /planning github-mcp → Create PRD for GitHub integration                    │
│                                                                                 │
│  IMPLEMENTATION PHASE                                                           │
│  ────────────────────                                                           │
│  Actionable Steps:                                                              │
│  → Task 1: Configure GitHub MCP server in .claude/config.json                  │
│  → Task 2: Update README with GitHub MCP documentation                        │
│  → Task 3: Add GitHub tools to workflow commands                               │
│  → Task 4: Create example using GitHub MCP for repo analysis                   │
│  → Task 5: Test integration with real repository                               │
│                                                                                 │
│  VALIDATION PHASE                                                               │
│  ────────────────                                                               │
│  AI executes:                                                                   │
│  → Adds MCP server configuration                                                │
│  → Updates documentation to include new capabilities                            │
│  → Enhances discovery and review commands to use GitHub tools                  │
│  → Validates integration works correctly                                       │
│                                                                                 │
│  Result: System now has GitHub repository analysis capabilities!                │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### The System Eats Its Own Dog Food

**This AI Coding System is built using itself.**

| System Component | Built With | How PIV Applies |
|-----------------|------------|-----------------|
| **Workflow Commands** | /workflow command | PIV loop to create new commands |
| **Reference Library** | /learn command | PIV loop to expand knowledge |
| **Documentation** | /planning, /development | PIV loop to improve docs |
| **MCP Integrations** | Archon + research | PIV loop to add new MCP servers |
| **This README** | System itself | PIV loop to document improvements |

**Key Insight**: Every feature of this system can be improved using the PIV Loop methodology. The system is **self-sustaining** and **self-improving**.

### Improving This System: Quick Start

Want to contribute to this system? Use the PIV Loop:

```bash
# 1. PURPOSE: Identify improvement opportunity
/discovery
# → Find gap: "Need X feature", "Y documentation incomplete"

# 2. PLAN: Create requirements
/planning {improvement-name}
/development {improvement-name}

# 3. BREAK DOWN: Create actionable steps
/task-planning {improvement-name}
# → Generates tasks with clear priorities

# 4. EXECUTE: Let AI follow tasks
/execution {improvement-name}
# → AI executes tasks one by one

# 5. VALIDATE: Review and test
/review {improvement-name}
/test {improvement-name}
```

**Example: Adding /deploy Command**
```bash
# Use the system to improve the system!
/discovery
→ "Add automated deployment capabilities"

/planning deploy-command
→ Creates PRD for deploy feature

/development deploy-command
→ Designs deployment architecture

/task-planning deploy-command
→ Creates 5 tasks:
  1. Create command file
  2. Implement deployment logic
  3. Add rollback
  4. Write tests
  5. Update docs

/execution deploy-command
→ AI executes tasks 1-5 one by one

/review deploy-command
→ Code quality check

/test deploy-command
→ Validate deployment works

# Result: System now has /deploy command!
```

**This is the power of PIV Loop - the system improves itself systematically.**

## Features

### Core Workflow Commands

| Command | Description | What It Does |
|---------|-------------|--------------|
| **`/prime`** | Export codebase for context gathering | - Scans entire codebase structure<br>- Generates structured markdown output<br>- Creates snapshot in `context/prime-*.md`<br>- Token-efficient context for AI analysis |
| **`/discovery`** | Explore ideas and opportunities | - Searches Archon RAG knowledge base<br>- Uses Web MCP for external research<br>- Explores AI agent patterns and opportunities<br>- Digests findings into `discovery/ideas.md` |
| **`/planning {feature}`** | Generate PRD from insights | - Reads discovery insights<br>- Creates Product Requirements Document<br>- Defines user stories and acceptance criteria<br>- Stores in `features/{feature}/prd.md` |
| **`/development {feature}`** | Generate technical specifications | - Analyzes PRD requirements<br>- Researches technology stack options<br>- Creates architecture diagrams<br>- Stores in `features/{feature}/tech-spec.md` |
| **`/task-planning {feature}`** | Create implementation plans | - Combines PRD + TECH SPEC + codebase patterns<br>- Generates PRP (Plan Reference Protocol)<br>- Creates Archon tasks with dependencies<br>- Loads relevant references selectively |
| **`/execution {feature}`** | Execute tasks sequentially | - Follows PRP blueprint step-by-step<br>- Marks tasks: todo → doing → review → done<br>- Uses Archon for progress tracking<br>- Executes implementation with focused context |
| **`/review {feature}`** | AI-powered code review | - Analyzes code quality, security, performance<br>- Identifies potential issues and anti-patterns<br>- Generates review report in `reviews/`<br>- Provides actionable recommendations |
| **`/test {feature}`** | Run tests with AI fixes | - Executes test suite<br>- Detects errors and failures<br>- AI suggests fixes for failing tests<br>- Generates coverage reports |
| **`/workflow {feature}`** | Execute complete pipeline | - Runs all phases automatically<br>- Supports resume from any phase<br>- Tracks progress across entire workflow<br>- Seamless integration of all commands |

### Smart Reference Library

| Command | Description | What It Does |
|---------|-------------|--------------|
| **`/learn {topic}`** | Search, digest, and save insights | - Searches Archon RAG knowledge base<br>- Uses Web MCP for external sources<br>- Digests findings into structured insights<br>- Stores to Supabase `archon_references` table |
| **`/learn-health`** | Check library health | - Queries reference library statistics<br>- Shows category coverage (python, react, etc.)<br>- Identifies gaps and suggests improvements<br>- Displays token savings metrics |

**How /learn works:**
```
Input topic → RAG search + Web search → Digest insights → Store to Supabase
Example: /learn python async patterns
→ Searches: Archon KB + web for "python async"
→ Digests: 3-5 key insights + code examples
→ Stores: category='python', tags=['python', 'async']
→ Reusable: Loads selectively during tasks
```

### Utility Commands

| Command | Description | What It Does |
|---------|-------------|--------------|
| **`/check`** | Codebase health check & cleanup | - Validates required files exist<br>- Removes OS artifacts (nul, .DS_Store)<br>- Cleans up old context exports (keeps latest 2-3)<br>- Removes completed project artifacts<br>- Updates documentation consistency<br>- Generates health report with score |
| **`/update-index`** | Update INDEX.md files | - Scans directories for files<br>- Updates or regenerates INDEX.md<br>- Lists all files in organized format<br>- Keeps navigation current |
| **`/update-status`** | Update STATUS.md tracking | - Updates phase progress in STATUS.md<br>- Lists artifacts created per phase<br>- Documents next steps and blockers<br>- Syncs with actual completion state |

### Command Reference (Full Details)

#### `/prime` - Context Export
**Purpose**: Export entire codebase for AI analysis
**Output**: `context/prime-{timestamp}.md`
**Use when**: Starting new project, need codebase context
**Contains**:
- Directory structure with file descriptions
- Key file contents (commands, templates, docs)
- Excludes: node_modules, .git, build artifacts
**Size**: 10,000-50,000 tokens (large but comprehensive)

#### `/discovery` - Opportunity Exploration
**Purpose**: Explore ideas using RAG and web research
**Output**: `discovery/ideas.md`
**Use when**: Looking for new features, opportunities, inspiration
**Research sources**:
- Archon RAG knowledge base
- Web search (web-search-prime)
- GitHub repositories (zread)
- Documentation (web-reader)

#### `/planning {feature}` - PRD Generation
**Purpose**: Create Product Requirements Document
**Output**: `features/{feature}/prd.md`
**Use when**: You have an idea and need formal requirements
**Contains**:
- Goal and success criteria
- User stories with acceptance criteria
- Functional requirements
- Non-functional requirements
- Dependencies and risks

#### `/development {feature}` - Technical Specification
**Purpose**: Generate technical architecture and stack
**Output**: `features/{feature}/tech-spec.md`
**Use when**: PRD is complete, need technical design
**Contains**:
- Architecture diagrams
- Technology stack recommendations
- API design
- Database schema
- Integration points
- Security considerations

#### `/task-planning {feature}` - Implementation Planning
**Purpose**: Create actionable tasks with PRP
**Output**: `features/{feature}/prp.md` + Archon tasks
**Use when**: TECH SPEC complete, ready to implement
**Contains**:
- Implementation blueprint (ordered steps)
- Codebase patterns to follow
- Reference library categories to load
- Archon tasks with priorities and dependencies
- Validation checklist

#### `/execution {feature}` - Task Execution
**Purpose**: Execute tasks one-by-one with tracking
**Output**: Completed code + updated task status
**Use when**: PRP created, ready to code
**Process**:
1. Get next task (status: todo)
2. Mark as doing
3. Load selective context
4. Implement following PRP
5. Mark as review
6. Validate and test
7. Mark as done
8. Repeat until all tasks complete

#### `/review {feature}` - Code Review
**Purpose**: AI-powered quality analysis
**Output**: `reviews/{feature}.md`
**Use when**: Implementation complete
**Analyzes**:
- Code quality and readability
- Security vulnerabilities
- Performance bottlenecks
- Best practices violations
- Testing coverage
- Documentation completeness

#### `/test {feature}` - Test Execution
**Purpose**: Run tests with AI-suggested fixes
**Output**: `testing/{feature}-results.md`
**Use when**: Review complete, need validation
**Features**:
- Runs test suite
- Detects failures and errors
- AI analyzes root causes
- Suggests specific fixes
- Re-runs to verify fixes

#### `/workflow {feature}` - Complete Pipeline
**Purpose**: Execute all phases automatically
**Output**: Complete feature from idea to tested code
**Use when**: Want hands-off development
**Phases** (all or resume from any):
1. Discovery → 2. Planning → 3. Development → 4. Task Planning → 5. Execution → 6. Review → 7. Test
**Flags**: `--from-{phase}` to resume from specific phase

#### `/learn {topic}` - Learn & Store
**Purpose**: Build reference library with digested insights
**Output**: Stored in Supabase `archon_references`
**Use when**: Want to save knowledge for future use
**Process**:
1. Search Archon RAG (2-5 keywords)
2. Search Web MCP if needed
3. Digest into insights (3-5 bullets, code examples)
4. Present for approval
5. Store to database
**Result**: Token-efficient, reusable knowledge

#### `/learn-health` - Library Diagnostics
**Purpose**: Check reference library coverage
**Output**: Health report with statistics
**Use when**: Want to know library state
**Shows**:
- References per category (python, mcp, react, etc.)
- Tag distribution
- Coverage gaps
- Token savings achieved
- Suggestions for improvement

#### `/check` - Health Check & Cleanup
**Purpose**: Maintain clean, healthy repository
**Output**: Health report + fixes applied
**Use when**: Repository feels cluttered, want cleanup
**Checks**:
- Required files present (.gitignore, LICENSE, etc.)
- No OS artifacts (nul, .DS_Store, Thumbs.db)
- Context exports cleaned (keeps latest 2-3)
- Project artifacts removed if complete
- Documentation synchronized
**Result**: Clean repo, health score 0-100%

#### `/update-index` - Update Navigation
**Purpose**: Keep INDEX.md files current
**Output**: Updated INDEX.md in directories
**Use when**: New files added, navigation outdated
**Updates**: Root INDEX.md, features/, context/, discovery/, etc.

#### `/update-status` - Update Progress Tracking
**Purpose**: Sync STATUS.md with actual progress
**Output**: Updated STATUS.md files
**Use when**: Phases complete, need to update tracking
**Updates**: Phase status, artifacts, next steps

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

## Connect

- **Website**: https://ryanjosebrosas.xyz
- **LinkedIn**: https://linkedin.com/in/ryanjosebrosas
