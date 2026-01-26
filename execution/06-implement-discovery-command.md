---
archon_task_id: f87c2b05-fecb-4292-9e89-bf6603ef1774
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 117
assignee: User
created_at: 2026-01-23T16:32:57.794576+00:00
updated_at: 2026-01-23T16:52:00.028798+00:00
---

# 06: Implement Discovery Command

**Status:** Done

## Description
Create .claude/commands/discovery.md - load prime, query AI via RAG, explore web, generate discovery doc.

## Implementation Steps

### Command Structure
- [ ] Create discovery.md with YAML frontmatter
- [ ] Define idea parameter (optional)
- [ ] Document discovery flow

### Prime Loading
- [ ] Find latest context/prime-*.md
- [ ] Load codebase context
- [ ] Parse structure and patterns

### RAG Knowledge Search
- [ ] Query rag_search_knowledge_base for:
  - AI agent patterns
  - MCP integration examples
  - Similar implementations
- [ ] Query rag_search_code_examples for:
  - Relevant code patterns
  - Architecture examples
- [ ] Use short, focused queries (2-5 keywords)

### Web Research (if needed)
- [ ] Use web_search_prime_search for:
  - Latest AI/agent trends
  - Best practices
  - Inspiration sources
- [ ] Use web_reader_read/zread_read for:
  - In-depth documentation
  - Architecture patterns
  - Case studies

### Discovery Document Generation
- [ ] Create discovery/{timestamp}-{topic}.md
- [ ] Include sections:
  - Concept Overview
  - Key Insights
  - Recommendations
  - Potential Challenges
  - Next Steps

### Documentation Standards
- [ ] Keep discovery focused and concise
- [ ] Use direct language
- [ ] Focus on actionable insights

## References
- .claude/commands/template.md - Command template
- context/prime-*.md - Codebase context
- CLAUDE.md - RAG Workflow section
