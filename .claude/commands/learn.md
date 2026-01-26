---
name: Learn
description: "Search, digest, and save coding insights to reference library"
phase: independent
dependencies: []
outputs:
  - description: "Digested insight stored in archon_references table"
inputs:
  - name: topic
    description: "Topic to learn (e.g., 'python async', 'react hooks', 'mcp server patterns')"
    required: true
---

# Learn Command

## Purpose

Search Archon RAG and web for a coding topic, digest findings into concise actionable insights, and store approved insights to `archon_references` in Supabase.

**When to use**: Save useful coding patterns, best practices, or technical insights for future reference.

**Solves**: Loading irrelevant context. Stores digested insights organized by category for selective context loading.

## Prerequisites

- Archon MCP server available (RAG search)
- Supabase `archon_references` table exists (Migration 012)
- Archon RAG knowledge base configured

## Execution Steps

### Step 1: Parse Topic and Infer Category

Extract keywords and determine category:
- "python", "asyncio", "fastapi" → `python`
- "react", "next", "hooks" → `react`
- "mcp", "model context" → `mcp`
- "typescript", "ts" → `typescript`
- "agent", "ai", "llm" → `ai-agents`
- "test", "jest", "pytest" → `testing`
- "supabase", "postgres", "sql" → `supabase`
- "api", "rest", "graphql" → `api`
- Default → `patterns`

### Step 2: Search Archon RAG

```bash
rag_search_knowledge_base(query="2-5 keywords", match_count=5, return_mode="pages")
```

Parse results and extract full content with `rag_read_full_page()`.

### Step 3: Search Web (Fallback)

If RAG returns < 3 results or low relevance:
```bash
web_search_prime_search(query="2-5 keywords")
web_reader_read(url="...")  # Extract content
```

### Step 4: Analyze Content & Suggest Tags

Analyze gathered content to suggest improved tags and validate category:

1. Extract additional keywords from actual content
2. Suggest enhanced tags:
   - Technology-specific terms
   - Framework/library names
   - Pattern names (factory, observer, repository)
   - Use-case tags (error-handling, testing, optimization)
3. Validate category against content themes
4. Present suggestions:

```
## Content Analysis Complete

**Initial Category**: {category}
**Suggested Category**: {validated_category} {if different, explain why}

**Suggested Additional Tags**:
- {tag1} (found in content)
- {tag2} (key concept)

Accept suggestions? (y/n/edit)
```

### Step 5: Digest Findings

Prompt LLM to digest into structured JSON:

```json
{
  "summary": "1-2 sentence overview",
  "insights": ["Actionable insight 1", "insight 2", "insight 3"],
  "code_examples": [
    {
      "title": "Example name",
      "language": "python|javascript|typescript",
      "code": "concise code snippet"
    }
  ],
  "sources": ["url1", "url2"],
  "learned_at": "ISO-8601-timestamp"
}
```

Keep insights concise (3-5 bullets max), include 2-3 code examples max.

### Step 6: Present for Approval

```
## Found insights for: {topic}

**Category**: {category}
**Tags**: {tags}

### Summary
{summary}

### Key Insights
- {insight 1}
- {insight 2}

### Code Examples
{code}

### Sources
- {source}

---
Save to reference library? (y/n)
```

### Step 7: Check for Duplicates

**Generate similarity_hash**:
```python
def normalize_content(content: str) -> str:
    content = content.lower()
    content = re.sub(r'\s+', ' ', content.strip())
    content = re.sub(r'\*\*(.*?)\*\*', r'\1', content)
    content = re.sub(r'\*(.*?)\*', r'\1', content)
    content = re.sub(r'`(.*?)`', r'\1', content)
    return content

similarity_hash = hashlib.sha256(normalized_content.encode()).hexdigest()
```

**Query for existing**:
```sql
SELECT id, title, category, tags, content, created_at
FROM archon_references
WHERE similarity_hash = '{hash}'
ORDER BY updated_at DESC LIMIT 5;
```

**If duplicates found**, present options:
```
## ⚠️ Potential Duplicate Detected

Found {count} existing reference(s):

**Existing**: {title} (ID: {id})
**Current digest**: {summary}

Choose action:
1) Skip - Don't add
2) Update - Replace existing
3) Add anyway - Create new
```

### Step 8: Store to Supabase

**Calculate relevance_score** (0-100):
- usage_score = 10 (baseline)
- recency_score = 100 (new)
- quality_score = 60 (default)
- completeness_score = based on content length (50-100)
- Final: (usage × 0.40) + (recency × 0.30) + (quality × 0.20) + (completeness × 0.10)

**Estimate token_count**:
```python
token_count = ceil(len(content_jsonb) / 4)
```

**INSERT query**:
```sql
INSERT INTO archon_references (
  title, category, tags, content, source_url,
  relevance_score, usage_count, token_count, last_used_at, similarity_hash
)
VALUES (
  '{title}', '{category}', ARRAY[{tags}], '{content}'::jsonb,
  '{source_url}', {score}, 1, {tokens}, NOW(), '{hash}'
);
```

## Error Handling

| Error | Cause | Recovery |
|-------|-------|----------|
| RAG Search Fails | Archon MCP unavailable | Fall back to web search |
| Web Search Fails | No internet/MCP unavailable | Proceed with RAG only |
| Supabase Insert Fails | Table missing/permissions | Run migration, retry |
| No Results Found | Topic obscure | Suggest different keywords |

## Output Example

```
## Content Analysis Complete

**Initial Category**: python
**Suggested Category**: python (validated)

**Suggested Additional Tags**:
- asyncio (core library)
- concurrency (key concept)
- aiohttp (library)

Accept suggestions? (y/n/edit): y

---

## Found insights for: python async patterns

**Category**: python
**Tags**: python, async, asyncio, concurrency, aiohttp

### Summary
Python async/await patterns for concurrent I/O operations.

### Key Insights
- Use asyncio.gather() to run multiple coroutines concurrently
- Always use async/await consistently
- Use asyncio.create_task() for fire-and-forget operations

### Code Examples
```python
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        return await asyncio.gather(*tasks)
```

### Sources
- https://docs.python.org/3/library/asyncio.html

---
Save to reference library? (y/n): y

✅ Saved to reference library! (ID: abc-123)
```

## Notes

- **Keep queries SHORT**: 2-5 keywords max for RAG
- **Content analysis improves accuracy**: Tags/category validated against actual content
- **Duplicate detection**: similarity_hash prevents identical content
- **Quality over quantity**: Store valuable, actionable insights only
- **Token efficiency**: Store digested insights, not full articles
- **User approval required**: Always present before storing

## Integration

- **`/learn-health`**: Shows stats including references created by `/learn`
- **`/learn-dedupe`**: Run to find and merge duplicate references
- **`/learn-compress`**: Run to optimize reference content
- **PRP templates**: Specify required categories for selective loading

## Validation

- [ ] Topic parsed and category inferred
- [ ] RAG search executed
- [ ] Content analysis completed
- [ ] Tags suggested based on actual content
- [ ] Category validated
- [ ] User approved suggestions
- [ ] Findings digested to JSONB
- [ ] User confirmed storage
- [ ] Duplicates checked and handled
- [ ] Relevance score calculated
- [ ] Insert successful
