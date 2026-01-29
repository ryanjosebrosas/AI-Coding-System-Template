---
name: Discovery
description: "Interview users to explore ideas, inspiration, and needs for AI agents and AI/ATR applications"
phase: discovery
dependencies: [prime]
outputs:
  - path: "discovery/discovery-{timestamp}.md"
    description: "Discovery document with user vision, interview insights, ideas, inspiration sources, needs analysis, and opportunities"
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

Engage users in conversation to explore ideas, inspiration, and needs for AI agents and AI/ATR applications. This command interviews users about their vision, challenges, and improvement ideas, then combines those insights with research (loading prime context, querying AI via MCP using RAG knowledge base and web MCP servers) to generate a personalized discovery document.

## Execution Steps

### Step 1: Interview User

Conduct user interview to gather vision, challenges, ideas, and success criteria:

1. **Welcome user and explain process**:
   - Greeting: "Welcome to the Discovery phase! I'll help you explore ideas and opportunities for AI agents and AI/ATR applications."
   - Explain: "This interview will help me understand your vision, challenges, and ideas. I'll ask a few questions, then combine your insights with research to generate a personalized discovery document."
   - Set expectations: "The interview takes about 5-10 minutes. Your responses will guide the research and discovery process."

2. **Interview questions** (ask conversationally, with natural transitions):
   - **Vision** (start here): "What is your vision for this project? What problems are you trying to solve with AI agents or AI/ATR applications?"
     - After user responds, acknowledge: "Thank you. That helps me understand your vision."
   - **Challenges** (transition): "Now, let's talk about your current situation. What challenges are you facing in your development workflow or project? Are there any pain points or bottlenecks?"
     - After user responds, acknowledge: "I see. Those are important challenges to address."
   - **Ideas** (transition): "Building on that, do you have any specific ideas for AI agents or features you'd like to explore? What capabilities would be most valuable to you?"
     - After user responds, acknowledge: "Great ideas. Let me capture those."
   - **Success** (transition): "Finally, what does success look like for this project? How will you know when the AI agent or application is working well?"
     - After user responds, acknowledge: "Perfect. I now have a clear picture of your vision."

3. **Collect responses** (maintain conversational flow):
   - Allow user to provide detailed responses for each question
   - Use active listening: "I understand," "That makes sense," "Good point"
   - Ask follow-up questions naturally if responses are unclear: "Could you tell me more about that?" "Can you give me an example?"
   - Encourage specific examples: "That's interesting. Can you share a specific use case?"
   - Capture key phrases and terminology from user's responses (note their exact words)
   - Keep tone friendly and engaging, not interrogative

4. **Store responses in memory**:
   - Create structured interview summary:
     - User Vision: {Summary of vision statement}
     - Key Challenges: {List of challenges mentioned}
     - Ideas & Requests: {List of specific ideas and features}
     - Success Criteria: {Definition of success}
     - Key Terminology: {Important terms and phrases from user}
   - Store in memory for use in subsequent research steps
   - Use user's language and terminology in later AI queries

**Expected Result**: User responses collected and stored in memory, ready to guide research.

### Step 2: Load Prime Context

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

### Step 3: Query AI for Ideas

Use RAG knowledge base to find relevant patterns and examples, guided by user interview insights:

1. **Get available knowledge sources**:
   - Call `rag_get_available_sources()`
   - Parse response: List of sources with id, title, url
   - Store source IDs for filtering

2. **Search knowledge base for patterns** (guided by user responses):
   - Call `rag_search_knowledge_base(query="ai agent patterns", match_count=5, return_mode="pages")`
     - Keep query SHORT (2-5 keywords) per CLAUDE.md rules
     - Use `return_mode="pages"` for better context
     - Incorporate user's key terminology from interview
   - Parse results: Pages with content and metadata
   - Extract relevant patterns and best practices

3. **Search for code examples** (guided by user's ideas):
   - Call `rag_search_code_examples(query="ai agent", match_count=3)`
     - Keep query SHORT and FOCUSED
     - Reference specific challenges mentioned by user
   - Parse results: Code examples with content and summaries
   - Extract implementation patterns

4. **Query AI with combined context**:
   - Combine: User responses + Prime context + RAG search results
   - Prompt AI: "Based on this codebase context, knowledge base patterns, and user's vision/challenges/ideas, identify personalized opportunities for AI agents and AI/ATR applications. Consider: [specific aspects from user interview]"
   - Extract structured ideas from AI response
   - Reference specific challenges and ideas mentioned by user

**Expected Result**: Personalized list of ideas for AI agents and features based on user's vision, challenges, codebase context, and knowledge base patterns.

### Step 4: Explore Inspiration Sources

Use web MCP servers to find external inspiration and best practices, guided by user interview insights:

1. **Search for inspiration sources** (guided by user's challenges and ideas):
   - Call `web_search_prime_search(query="AI agent patterns best practices", max_results=5)`
     - Search for: AI agent architectures, implementation patterns, best practices
     - Incorporate user's specific challenges and terminology
     - Reference specific ideas mentioned by user
   - Parse results: URLs and snippets
   - Select most relevant URLs based on user's stated needs

2. **Read relevant pages**:
   - For each relevant URL:
     - Call `web_reader_read(url="{url}")` or `zread_read(url="{url}")`
     - Parse extracted content
     - Extract key insights and patterns
   - Store inspiration sources with URLs and summaries

3. **Read full pages from knowledge base** (guided by user's interests):
   - For relevant pages from RAG search:
     - Call `rag_read_full_page(page_id="{page_id}")` or `rag_read_full_page(url="{url}")`
     - Get complete page content
     - Extract detailed patterns and examples relevant to user's vision

4. **Combine inspiration sources**:
   - Merge: Web search results + Knowledge base pages
   - Organize by: Source type (documentation, examples, best practices)
   - Extract: URLs, key insights, relevant patterns
   - Reference specific challenges and ideas mentioned by user

**Expected Result**: Personalized list of inspiration sources with URLs, summaries, and key insights aligned with user's vision and challenges.

### Step 5: Needs Analysis

Analyze codebase needs and identify gaps and opportunities, guided by user interview insights:

1. **Prepare combined context**:
   - User interview responses (vision, challenges, ideas, success criteria)
   - Prime context (codebase structure and contents)
   - RAG knowledge base results (patterns and examples)
   - Web research results (inspiration sources)
   - Knowledge base code examples

2. **Query AI for needs analysis** (guided by user's challenges and vision):
   - Prompt: "Analyze this codebase and identify needs and opportunities for AI agents and AI/ATR applications. Consider: current patterns, gaps, improvement opportunities. Reference specific challenges mentioned by user: [user's stated challenges]. Align with user's vision: [user's vision summary]."
   - Extract structured needs analysis
   - Reference specific challenges and ideas mentioned by user

3. **Prioritize opportunities**:
   - Sort by: Impact, feasibility, alignment with user's goals
   - Categorize: High, Medium, Low priority
   - Identify: Quick wins vs. strategic initiatives
   - Ensure priorities address user's stated challenges

**Expected Result**: Prioritized list of opportunities with analysis, aligned with user's vision and addressing their specific challenges.

### Step 6: Generate Discovery Document

Compile all findings into discovery document:

1. **Create document structure**:
   ```markdown
   # Discovery: {timestamp}

   ## User Vision & Insights
   {User's vision, challenges, ideas, and success criteria from interview}

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
   - Fill in: User interview insights from Step 1 (User Vision & Insights section)
   - Fill in: Codebase overview from Step 2
   - Fill in: Ideas from Step 3
   - Fill in: Inspiration sources from Step 4
   - Fill in: Needs analysis from Step 5
   - Fill in: Opportunities prioritized list
   - Ensure research findings reference user insights
   - Tie opportunities back to user's expressed needs

3. **Generate timestamp**:
   - Use ISO 8601 format: YYYY-MM-DDTHH:mm:ssZ
   - Include in filename and document

4. **Save document**:
   - Save to `discovery/discovery-{timestamp}.md`
   - Update `discovery/INDEX.md` with new entry (see Step 8):
     - Link to discovery document
     - Timestamp
     - Summary of ideas and opportunities

**Expected Result**: Discovery document created with all findings.

### Step 7: Generate MVP.md

**Objective**: Extract MVP definition from discovery document and save to project root.

**Actions**:

1. **Extract MVP recommendations**:
   - Read the discovery document created in Step 6
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

### Step 8: Update Discovery Index

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

## User Vision & Insights

### Vision Statement
{Summary of user's vision for the project}

### Key Challenges
{List of challenges and pain points mentioned by user}

### Ideas & Requests
{List of specific ideas and features user wants to explore}

### Success Criteria
{Definition of success from user's perspective}

### Key Terminology
{Important terms and phrases from user's responses}

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

### Interview-Specific Scenarios

- **User Skips Interview Questions**: Document 'No user insights provided' in discovery document, proceed with research-only findings. Note: Discovery will lack personalized vision and challenges context.
- **User Provides Unclear/Vague Responses**: Ask follow-up questions to clarify: "Could you provide more specific details about [aspect]?" "Can you give me an example of [scenario]?" If responses remain unclear after 2-3 follow-ups, document limitation and proceed with available information.
- **Interview Responses Conflict with Research Findings**: Present both perspectives in discovery document:
  - "User Vision: {user's perspective}"
  - "Research Findings: {patterns and best practices from knowledge base}"
  - "Analysis: {reconciliation or note of divergence}"
  - Validate conflicts with user: "Your approach differs from common patterns. Would you like to explore why, or proceed with your preferred approach?"

### Existing Error Scenarios

- **No Prime Export Found**: Check `context/` directory, list available exports, suggest running `/prime` first
- **MCP Server Unavailable**: Use Claude's built-in web search, inform user of limitations (may consume more tokens, less targeted results)
- **Knowledge Base Empty**: Proceed with web search only, document limitation in discovery document
- **Web Search Fails**: Log error, continue with available context (prime export + user interview insights)
- **Document Generation Fails**: Log error, suggest manual creation or retry attempt

## Notes

- Discovery now starts with an interview conversation to understand user vision, challenges, ideas, and success criteria
- User insights guide research direction - RAG queries and web searches incorporate user's terminology and specific challenges
- Discovery documents are personalized to user's vision, with all research findings tied back to user's expressed needs
- Interview can be skipped if user prefers automatic research (document limitation when proceeding without user insights)
- Use RAG knowledge base first for patterns, web search for external sources
- Combine multiple sources (user interview + prime context + RAG + web) for comprehensive analysis
- Prioritize opportunities by impact and feasibility
- Discovery document feeds into Planning command and generates MVP.md at project root
