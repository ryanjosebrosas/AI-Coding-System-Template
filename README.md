# AI Coding Workflow System

> A markdown-based command system that makes AI your **collaborative partner** in software development. Instead of just generating documents, it asks the right questions, challenges your assumptions, and helps you think through requirements before creating PRDs, Tech Specs, and implementation plans.

## What This Is

This is a workflow template for AI-assisted development that:

1. **Engages you in conversation** - Commands like `/planning` and `/development` ask probing questions before generating artifacts
2. **Challenges your decisions** - "Why this tech stack?" "Is there a simpler approach?"
3. **References inspiration** - Analyze GitHub repos and adopt their patterns
4. **Tracks everything** - Integrates with Archon MCP for task management
5. **Retrieves smart context** - Language-aware RAG filtering for accurate, token-efficient assistance

**The result**: Less rework, fewer assumptions, documents that reflect YOUR vision.

## Interactive Workflow (New!)

Traditional AI: "Here's your PRD" → Doesn't match your vision → Rewrite

This system:
```
/planning
  ├─ "Who will use this feature?"
  ├─ "What are the key features?"
  ├─ "Why [feature X]? What problem does it solve?"
  ├─ "Do you have an inspo repo?"
  └─ "Does this capture your vision?" → Generate PRD
```

**Probing questions** ensure the AI understands before generating.
**Follow-up questions** dig deeper when answers are vague.
**Inspo repos** let you reference GitHub projects you like.

---

## Why This Template?

Traditional AI coding assistants dump entire codebases into prompts, wasting tokens and diluting relevance. This template solves that with:

| Problem | Solution |
|---------|----------|
| Irrelevant search results | **Language-aware filtering** boosts matching language sources |
| Token waste on unchanged files | **Diff-based prime** only details what changed |
| Mixed language confusion | **Auto-detection** prioritizes your project's language |
| Stale context | **Smart caching** tracks file changes efficiently |

**Result**: 90%+ retrieval accuracy, 50%+ token savings on subsequent primes.

## Quick Start (5 minutes)

### 1. Prerequisites
- [Claude Code CLI](https://claude.ai/code) (or compatible AI CLI)
- Archon MCP server access

### 2. Clone & Configure
```bash
git clone <repo-url>
cd ai-coding-template
```

### 3. Configure MCP Servers
Edit `.mcp.json` with your server URLs:
```json
{
  "mcpServers": {
    "archon": {
      "type": "http",
      "url": "https://your-archon-server/mcp"
    }
  }
}
```

### 4. Verify Connection
```bash
# In Claude Code, check Archon health
health_check()
```

### 5. Start Building
```bash
/discovery
```

## Commands (Skills)

All commands are available as Claude Code skills. Invoke with `/{command}`.

### Interactive Commands (Conversational Probing)

| Command | Description | Probing |
|---------|-------------|---------|
| `/discovery` | Explore ideas and opportunities | Vision, challenges, ideas, success |
| `/planning {feature}` | Generate PRD | Personas, features, success criteria, inspo |
| `/development {feature}` | Generate Tech Spec | Tech stack (+ "Why?"), architecture, constraints |

These commands **ask questions before generating**, ensuring artifacts match your vision.

### Execution Commands

| Command | Description |
|---------|-------------|
| `/prime` | Export codebase context (language-aware) |
| `/task-planning {feature}` | Create PRP + Archon tasks |
| `/execution {feature}` | Execute tasks step-by-step |
| `/review {feature}` | AI-powered code review |
| `/test {feature}` | Run tests with suggested fixes |
| `/workflow {feature}` | Full pipeline (all commands) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `/learn {topic}` | Save coding insights to library |
| `/learn-health` | Check reference library health |
| `/check` | Health check & cleanup |

### Inspo Repo Feature

During probing, you can provide a GitHub repo URL:
```
"Do you have an inspo repo?" → https://github.com/owner/repo

Analyzing...
- Languages: TypeScript, JavaScript
- Structure: /src, /components, /lib
- Tech Stack: React, Supabase, Tailwind

"What aspects do you want to adopt?"
1. File structure
2. Tech stack
3. Architecture patterns
```

## Workflow

```
/discovery → /planning → /development → /task-planning → /execution → /review → /test
```

Or run all at once:
```bash
/workflow {feature-name}
```

## Project Structure

```
AGENT.md                    # Universal instructions (any CLI)
CLAUDE.md                   # Claude Code config + Smart Context docs
INDEX.md                    # Navigation
.mcp.json                   # MCP server configuration
.smart-context-config.json  # Boost weights + language mapping
.prime-cache.json           # File hash cache (auto-generated, git-ignored)
.claude/
├── commands/               # Original command files
├── skills/                 # Skill-format commands (new)
│   ├── planning/           # Interactive PRD generation
│   ├── development/        # Interactive Tech Spec generation
│   └── {command}/          # Other skill directories
└── utils/                  # Shared utilities (e.g., inspo repo analyzer)
docs/                       # Additional documentation
features/                   # Feature directories with STATUS.md
```

## Smart Context Retrieval

The template uses intelligent context filtering to get the RIGHT information, not ALL information.

### How It Works

```
┌─────────────────┐
│ Language        │ → Detects Python/TypeScript/Go/Rust from file markers
│ Detector        │   (requirements.txt, package.json, go.mod, Cargo.toml)
└────────┬────────┘
         │
┌────────▼────────┐
│ Boost Weight    │ → Adjusts RAG result rankings:
│ Applier         │   • Matching language: 1.5x boost
└────────┬────────┘   • General docs: 1.0x (unchanged)
         │            • Non-matching: 0.7x (reduced, not excluded)
┌────────▼────────┐
│ Prime Cache     │ → Tracks file hashes for diff-based output:
│ Manager         │   • Changed files: full content
└─────────────────┘   • Unchanged files: summary only (saves 50%+ tokens)
```

### Language Detection

The system auto-detects your project language:

| Marker File | Detected Language |
|-------------|-------------------|
| `requirements.txt`, `pyproject.toml` | Python |
| `package.json` + `tsconfig.json` | TypeScript |
| `package.json` (alone) | JavaScript |
| `go.mod` | Go |
| `Cargo.toml` | Rust |

**Fallback**: If no markers found, counts file extensions (40% threshold).

### Boost Weights

When you search the RAG knowledge base, results are re-ranked:

```
Python project searching for "authentication":
  ├─ PydanticAI docs (Python)  → score × 1.5 = ranks higher
  ├─ MCP docs (general)        → score × 1.0 = normal
  └─ TypeScript examples       → score × 0.7 = ranks lower (still included)
```

**Soft filtering**: Non-matching languages are de-prioritized, not excluded. Cross-language patterns still surface when highly relevant.

### Diff-Based Prime

First `/prime` creates a full export. Subsequent runs use `.prime-cache.json`:

```
/prime (first run)     → Full codebase export, creates cache
/prime (after changes) → Changed files: full detail
                         Unchanged files: summary table only
                         Token savings: ~50%+

/prime --full          → Bypass cache, full export
/prime --reset         → Clear cache, fresh start
/prime --debug         → Show language detection details
```

### Configuration

Edit `.smart-context-config.json`:

```json
{
  "enabled": true,
  "boost_weights": {
    "matching": 1.5,
    "general": 1.0,
    "non_matching": 0.7
  },
  "language_sources": {
    "python": ["c0e629a894699314"],
    "typescript": ["f3246532dd189ef4"],
    "general": ["0475da390fe5f210", "b6fcee627ca78458"]
  },
  "debug": false
}
```

### Contextual Embedding (Optional)

For even better accuracy (35-67% improvement), enable contextual embedding in Archon. See [docs/contextual-embedding-guide.md](./docs/contextual-embedding-guide.md).

---

## Key Concepts

### Task-Driven Development
1. Get task from Archon → `find_tasks(status="todo")`
2. Mark as doing → `manage_task(status="doing")`
3. Implement
4. Mark for review → `manage_task(status="review")`
5. Next task

### PIV Loop
- **P**urpose: `/discovery` → `/planning` → `/development`
- **I**mplementation: `/task-planning` → `/execution`
- **V**alidation: `/review` → `/test`

## Adding MCP Servers

Edit `.mcp.json`:
```json
{
  "mcpServers": {
    "your-server": {
      "type": "http",
      "url": "http://localhost:8000/mcp"
    }
  }
}
```

## Documentation

- [AGENT.md](./AGENT.md) - Universal agent instructions
- [CLAUDE.md](./CLAUDE.md) - Claude Code configuration + Smart Context docs
- [INDEX.md](./INDEX.md) - Command reference
- [Contextual Embedding Guide](./docs/contextual-embedding-guide.md) - Enable 35-67% accuracy boost

## License

MIT
