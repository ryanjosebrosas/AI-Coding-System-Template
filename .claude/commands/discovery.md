---
name: Discovery
description: "Explore ideas, inspiration, and needs for AI agents and AI/ATR applications"
phase: discovery
dependencies: [prime]
outputs:
  - path: "discovery/discovery-{timestamp}.md"
    description: "Discovery document with ideas, inspiration sources, needs analysis, and opportunities"
  - path: "discovery/INDEX.md"
    description: "Updated index of all discovery documents"
  - path: "MVP.md"
    description: "MVP definition at root based on discovery findings"
inputs:
  - path: "context/prime-{timestamp}.md"
    description: "Most recent codebase export from Prime command"
    required: true
---

# Discovery Command

## Purpose

Explore ideas, inspiration, and needs for AI agents and AI/ATR applications. This command loads the prime context, queries AI via MCP (using RAG knowledge base and web MCP servers), performs needs analysis, and generates a discovery document.

## Execution Steps

### Step 1: Load Prime Context

Find most recent codebase export for analysis:

1. **Find most recent prime export**:
   - List files in `context/` directory matching pattern `prime-*.md`
   - Sort by filename (which includes timestamp)
   - Select most recent (last in sorted list)
   - If no prime exports exist, error: "No prime export found. Run /prime command first."

2. **Load prime export file**:
   - Read file contents
   - Parse markdown structure
   - Extract: Project tree, file contents, index statistics
   - Store in memory for AI queries

3. **Extract key information**:
   - Project structure and organization
   - Technology stack (from dependencies in index)
   - File patterns and conventions
   - Codebase scale (file count, line count)

**Expected Result**: Prime context loaded and ready for analysis.

### Step 2: Query AI for Ideas

Use RAG knowledge base to find relevant patterns and examples:

1. **Get available knowledge sources**:
   - Call `rag_get_available_sources()`
   - Parse response: List of sources with id, title, url
   - Store source IDs for filtering

2. **Search knowledge base for patterns**:
   - Call `rag_search_knowledge_base(query="ai agent patterns", match_count=5, return_mode="pages")`
     - Keep query SHORT (2-5 keywords) per CLAUDE.md rules
     - Use `return_mode="pages"` for better context
   - Parse results: Pages with content and metadata
   - Extract relevant patterns and best practices

3. **Search for code examples**:
   - Call `rag_search_code_examples(query="ai agent", match_count=3)`
     - Keep query SHORT and FOCUSED
   - Parse results: Code examples with content and summaries
   - Extract implementation patterns

4. **Query AI with combined context**:
   - Combine: Prime context + RAG search results
   - Prompt AI: "Based on this codebase context and knowledge base patterns, identify opportunities for AI agents and AI/ATR applications. Consider: [specific aspects]"
   - Extract structured ideas from AI response

**Expected Result**: List of ideas for AI agents and features based on codebase and knowledge base.

### Step 3: Explore Inspiration Sources

Use web MCP servers to find external inspiration and best practices:

1. **Search for inspiration sources**:
   - Call `web_search_prime_search(query="AI agent patterns best practices", max_results=5)`
     - Search for: AI agent architectures, implementation patterns, best practices
   - Parse results: URLs and snippets
   - Select most relevant URLs

2. **Read relevant pages**:
   - For each relevant URL:
     - Call `web_reader_read(url="{url}")` or `zread_read(url="{url}")`
     - Parse extracted content
     - Extract key insights and patterns
   - Store inspiration sources with URLs and summaries

3. **Read full pages from knowledge base**:
   - For relevant pages from RAG search:
     - Call `rag_read_full_page(page_id="{page_id}")` or `rag_read_full_page(url="{url}")`
     - Get complete page content
     - Extract detailed patterns and examples

4. **Combine inspiration sources**:
   - Merge: Web search results + Knowledge base pages
   - Organize by: Source type (documentation, examples, best practices)
   - Extract: URLs, key insights, relevant patterns

**Expected Result**: List of inspiration sources with URLs, summaries, and key insights.

### Step 4: Needs Analysis

Analyze codebase needs and identify gaps and opportunities:

1. **Prepare combined context**:
   - Prime context (codebase structure and contents)
   - RAG knowledge base results (patterns and examples)
   - Web research results (inspiration sources)
   - Knowledge base code examples

2. **Query AI for needs analysis**:
   - Prompt: "Analyze this codebase and identify needs and opportunities for AI agents and AI/ATR applications. Consider: current patterns, gaps, improvement opportunities"
   - Extract structured needs analysis

3. **Prioritize opportunities**:
   - Sort by: Impact, feasibility, alignment with goals
   - Categorize: High, Medium, Low priority
   - Identify: Quick wins vs. strategic initiatives

**Expected Result**: Prioritized list of opportunities with analysis.

### Step 5: Generate Discovery Document

Compile all findings into discovery document:

1. **Create document structure**:
   ```markdown
   # Discovery: {timestamp}

   ## Codebase Overview
   {Summary of codebase structure, technology stack, patterns}

   ## Ideas for AI Agents
   {List of ideas from AI queries, prioritized}

   ## Inspiration Sources
   {List of external sources with URLs and summaries}

   ## Needs Analysis
   {Analysis of codebase needs and gaps}

   ## Opportunities
   {Prioritized list of opportunities with impact and feasibility}

   ## Next Steps
   {Recommended next steps for development}
   ```

2. **Populate content**:
   - Fill in: Codebase overview from Step 1
   - Fill in: Ideas from Step 2
   - Fill in: Inspiration sources from Step 3
   - Fill in: Needs analysis from Step 4
   - Fill in: Opportunities prioritized list

3. **Generate timestamp**:
   - Use ISO 8601 format: YYYY-MM-DDTHH:mm:ssZ
   - Include in filename and document

4. **Save document**:
   - Save to `discovery/discovery-{timestamp}.md`
   - Update `discovery/INDEX.md` with new entry:
     - Link to discovery document
     - Timestamp
     - Summary of ideas and opportunities

**Expected Result**: Discovery document created with all findings.

### Step 6: Generate MVP.md

**Objective**: Extract MVP definition from discovery document and save to project root.

**Actions**:

1. **Extract MVP recommendations**:
   - Read the discovery document created in Step 5
   - Locate the "### Recommended MVP Focus" section in the discovery content
   - Extract the MVP title, goals, key features, and priorities

2. **Create MVP.md structure**:
   ```markdown
   # MVP: {MVP Title}

   ## Goals
   {List of MVP goals from discovery recommendations}

   ## Key Features
   {Prioritized list of MVP features}

   ## Success Criteria
   {Definition of MVP success}

   ## Architecture Recommendations
   {Technical architecture suggestions from discovery}

   ## Next Steps
   {Recommended path forward after MVP}
   ```

3. **Save to root directory**:
   - Save as `MVP.md` in project root (not in discovery/ folder)
   - Ensure file is readable by `/planning` command as input
   - Include timestamp reference to source discovery document

**Expected Result**: MVP.md created at project root with extracted MVP definition.

### Step 7: Update Discovery Index

**Objective**: Maintain an up-to-date index of all discovery documents.

**Actions**:

1. **Read existing index**:
   - Open `discovery/INDEX.md`
   - If file doesn't exist, create it with standard header

2. **Add new entry**:
   - Append entry for new discovery document:
     - Link: `[Discovery: {timestamp}](discovery-{timestamp}.md)`
     - Timestamp: {ISO 8601 timestamp}
     - Summary: Brief summary of key findings and opportunities

3. **Format index**:
   - Keep most recent discoveries at top
   - Maintain consistent markdown format
   - Include all relevant metadata

**Expected Result**: Discovery index updated with new entry.

## Output Format

```markdown
# Discovery: {timestamp}

## Codebase Overview

### Project Structure
{Brief description of project structure and organization}

### Technology Stack
{List of technologies detected from prime export}

### Patterns and Conventions
{Key patterns and naming conventions observed}

## Ideas for AI Agents

### High Priority
{List of high-priority ideas}

### Medium Priority
{List of medium-priority ideas}

### Low Priority
{List of low-priority ideas}

## Inspiration Sources

### Documentation
{Links to documentation sources with summaries}

### Examples
{Links to example implementations with summaries}

### Best Practices
{Links to best practice resources with summaries}

## Needs Analysis

### Current Gaps
{Analysis of missing features or capabilities}

### Improvement Opportunities
{Areas for improvement in existing codebase}

### Emerging Opportunities
{New opportunities based on trends and patterns}

## Opportunities

| Opportunity | Impact | Feasibility | Priority | Effort Estimate |
|------------|---------|-------------|----------|------------------|
| {Name} | {High/Med/Low} | {High/Med/Low} | {High/Med/Low} | {Time} |

## Next Steps
{Recommended next steps for development}

## Timestamp
{ISO 8601 timestamp}
```

## Error Handling

- **No Prime Export Found**: Check `context/` directory, list available exports, suggest running `/prime`
- **MCP Server Unavailable**: Use Claude's built-in web search, inform user of limitations
- **Knowledge Base Empty**: Proceed with web search only, document limitation
- **Web Search Fails**: Log error, continue with available context
- **Document Generation Fails**: Log error, suggest manual creation

## Notes

- Discovery documents help explore ideas before committing to specific features
- Use RAG knowledge base first for patterns, web search for external sources
- Combine multiple sources for comprehensive analysis
- Prioritize opportunities by impact and feasibility
- Discovery document feeds into Planning command
