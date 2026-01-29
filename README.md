# AI Coding Workflow System

Markdown-based command system for AI-assisted development with MCP integration and **Smart Context Retrieval** for accurate, token-efficient AI assistance.

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

## Commands

| Command | Description |
|---------|-------------|
| `/prime` | Export codebase context |
| `/discovery` | Explore ideas and opportunities |
| `/planning {feature}` | Generate PRD |
| `/development {feature}` | Generate Tech Spec |
| `/task-planning {feature}` | Create PRP + Archon tasks |
| `/execution {feature}` | Execute tasks |
| `/review {feature}` | Code review |
| `/test {feature}` | Run tests |
| `/workflow {feature}` | Full pipeline |
| `/learn {topic}` | Store coding insights |
| `/learn-health` | Check reference library |
| `/check` | Health check & cleanup |

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
.claude/commands/           # Workflow command files
docs/                       # Additional documentation
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
