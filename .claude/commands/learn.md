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

Search Archon RAG and web for a coding topic, digest findings into concise actionable insights, and store approved insights to the `archon_references` table in Supabase.

This command builds a token-efficient reference library by storing digested knowledge (not raw dumps) organized by category for selective context loading during future tasks.

**When to use**: Use this command when you want to save useful coding patterns, best practices, or technical insights for future reference.

**What it solves**: This command addresses the problem of loading irrelevant context. By storing digested insights and enabling selective loading by category, only relevant references load during future tasks.

## Prerequisites

- Archon MCP server available (for RAG search)
- Supabase `archon_references` table exists (Migration 012)
- Archon RAG knowledge base configured

## Execution Steps

### Step 1: Parse Topic and Infer Category

**Objective**: Extract keywords and determine the reference category.

**Actions**:
1. Parse the `topic` input parameter
2. Extract key technology keywords (python, react, mcp, typescript, etc.)
3. Infer category from keywords using mapping:
   - "python", "asyncio", "fastapi", "django" → `python`
   - "react", "next", "hooks", "components" → `react`
   - "mcp", "model context" → `mcp`
   - "typescript", "ts" → `typescript`
   - "agent", "ai", "llm", "prompt" → `ai-agents`
   - "test", "jest", "pytest", "vitest" → `testing`
   - "supabase", "postgres", "sql" → `supabase`
   - "api", "rest", "graphql" → `api`
   - If no match → `patterns` (general design patterns)
4. Generate additional tags from topic keywords

**Expected Result**: Category determined and tags extracted.

### Step 2: Search Archon RAG Knowledge Base

**Objective**: Find relevant insights in the knowledge base.

**Actions**:
1. Call `rag_search_knowledge_base()`
   - **Query**: 2-5 keywords from topic (keep SHORT!)
   - **match_count**: 5
   - **return_mode**: "pages"
2. Parse results for relevant pages
3. Extract full content using `rag_read_full_page()` for promising results

**Expected Result**: List of relevant knowledge base pages with content.

### Step 3: Search Web (Optional Fallback)

**Objective**: Find external resources if RAG results insufficient.

**Actions**:
1. If RAG returns < 3 results or low relevance:
   - Call WebSearch or `web_search_prime_search()`
   - Use same 2-5 keyword query
2. Parse search results for relevant URLs
3. Use `web_reader_read()` to extract content from promising URLs

**Expected Result**: Additional insights from web resources (if needed).

### Step 4: Digest Findings into Insights

**Objective**: Process raw content into concise, actionable insights.

**Actions**:
1. Combine all sources (RAG + web)
2. Prompt LLM to digest into structured format:
   ```json
   {
     "summary": "1-2 sentence overview",
     "insights": [
       "Actionable insight 1",
       "Actionable insight 2",
       "Actionable insight 3"
     ],
     "code_examples": [
       {
         "title": "Example name",
         "language": "python|javascript|typescript|sql",
         "code": "concise code snippet"
       }
     ],
     "sources": ["url1", "url2"],
     "learned_at": "ISO-8601-timestamp"
   }
   ```
3. Keep insights concise (3-5 bullet points max)
4. Include only relevant code examples (2-3 max)

**Expected Result**: Structured digest ready for review.

### Step 5: Present for Approval

**Objective**: Get user confirmation before storing.

**Actions**:
1. Present digest in readable format:
   ```
   ## Found insights for: {topic}

   **Category**: {category}
   **Tags**: {tags}

   ### Summary
   {summary}

   ### Key Insights
   - {insight 1}
   - {insight 2}
   - {insight 3}

   ### Code Examples
   {code examples}

   ### Sources
   - {source 1}
   - {source 2}

   ---
   Save to reference library? (y/n)
   ```
2. Wait for user confirmation

**Expected Result**: User approves or rejects the digest.

### Step 6: Store to Supabase

**Objective**: Insert approved insight into `archon_references` table.

**Actions**:
1. Generate INSERT query (direct SQL via Supabase):
   ```sql
   INSERT INTO archon_references (title, category, tags, content, source_url)
   VALUES (
     '{title}',
     '{category}',
     ARRAY[{tags}],
     '{content_jsonb}'::jsonb,
     '{primary_source_url}'
   );
   ```
2. Execute via Supabase client (not Archon MCP)
3. Confirm successful insert

**Expected Result**: Reference stored in database.

## Output Format

The command stores a reference record in the `archon_references` table:

**Table**: `archon_references`

**Record Structure**:
```sql
{
  id: UUID (auto-generated),
  title: TEXT (topic + descriptive suffix),
  category: TEXT (python|mcp|react|typescript|ai-agents|testing|patterns|supabase|api),
  tags: TEXT[] (additional keyword tags),
  content: JSONB {
    summary: string,
    insights: string[],
    code_examples: object[],
    sources: string[],
    learned_at: timestamp
  },
  source_url: TEXT (primary source),
  author: TEXT ('AI Coding System'),
  created_at: TIMESTAMPTZ,
  updated_at: TIMESTAMPTZ
}
```

**Example Content**:
```json
{
  "summary": "Python async/await patterns for concurrent I/O operations",
  "insights": [
    "Use asyncio.gather() to run multiple coroutines concurrently",
    "Always use async/await consistently - don't mix sync and async code",
    "Use asyncio.create_task() for fire-and-forget operations"
  ],
  "code_examples": [
    {
      "title": "Concurrent HTTP requests",
      "language": "python",
      "code": "async def fetch_all(urls):\n    async with aiohttp.ClientSession() as session:\n        tasks = [fetch_url(session, url) for url in urls]\n        return await asyncio.gather(*tasks)"
    }
  ],
  "sources": ["https://docs.python.org/3/library/asyncio.html"],
  "learned_at": "2026-01-24T20:00:00Z"
}
```

## Error Handling

### RAG Search Fails

- **Cause**: Archon MCP unavailable or knowledge base empty
- **Detection**: `rag_search_knowledge_base()` returns error
- **Recovery**: Fall back to web search only, inform user of limitation

### Web Search Fails

- **Cause**: No internet or web MCP unavailable
- **Detection**: WebSearch returns error
- **Recovery**: Proceed with RAG results only, warn if insufficient

### Supabase Insert Fails

- **Cause**: Table doesn't exist or permission denied
- **Detection**: SQL insert fails
- **Recovery**: Inform user to run migration SQL, offer retry

### No Results Found

- **Cause**: Topic too obscure or not in knowledge base
- **Detection**: Zero results from RAG + web search
- **Recovery**: Suggest different topic keywords, offer to search again

## Examples

### Example 1: Learn Python Async Patterns

**Command**: `/learn python async patterns`

**Execution**:
1. Parse: topic="python async patterns" → category="python", tags=["python", "async"]
2. RAG search: `rag_search_knowledge_base(query="python async", match_count=5)`
3. Digest findings into insights
4. Present for approval
5. Store on approval

**Output**:
```
## Found insights for: python async patterns

**Category**: python
**Tags**: python, async, patterns

### Summary
Python async/await patterns for concurrent I/O operations.

### Key Insights
- Use asyncio.gather() to run multiple coroutines concurrently
- Always use async/await consistently - don't mix sync and async code
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
✅ Saved to reference library! (ID: abc-123)
```

### Example 2: Learn React Hooks

**Command**: `/learn react hooks`

**Execution**:
1. Parse: topic="react hooks" → category="react", tags=["react", "hooks"]
2. RAG search: `rag_search_knowledge_base(query="react hooks", match_count=5)`
3. Digest and present
4. Store on approval

**Output**: Similar format with React-specific insights and examples.

## Notes

- **Keep queries SHORT**: 2-5 keywords max for RAG searches
- **Quality over quantity**: Store only valuable, actionable insights
- **User approval required**: Always present before storing
- **Token efficiency**: Store digested insights, not full articles
- **Source attribution**: Always track original source URLs

## Validation

After executing this command:
- [ ] Topic parsed and category inferred correctly
- [ ] RAG search executed successfully
- [ ] Findings digested into structured JSONB
- [ ] Digest presented for approval
- [ ] User confirmed approval
- [ ] Insert into `archon_references` successful
- [ ] Record can be queried back

## Integration with Other Commands

- **`/learn-health`**: Shows stats including references created by `/learn`
- **PRP templates**: Can specify required categories (e.g., "Load references with tags: ['python', 'mcp']")
- **CLAUDE.md**: Documents reference library usage
