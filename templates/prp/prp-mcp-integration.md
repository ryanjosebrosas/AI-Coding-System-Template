# PRP: {feature-name} - MCP Integration

**Template**: prp-mcp-integration.md | **Extends**: prp-base.md

## Goal

{Base template Goal section}

## All Needed Context

{Base template All Needed Context section}

### MCP Specific Context
- MCP server documentation
- MCP protocol specification
- Tool definitions and schemas
- Resource definitions and schemas
- MCP integration patterns from codebase

## Implementation Blueprint

{Base template Implementation Blueprint section}

### MCP Server Configuration
- Server type: {HTTP, stdio, SSE}
- Authentication: {API keys, tokens, etc.}
- Connection: {How to connect to MCP server}
- Configuration file: {Where MCP server is configured}

### MCP Tools
- Available tools: {List of tools from MCP server}
- Tool definitions: {Tool schemas and parameters}
- Tool usage patterns: {How to call tools}
- Tool error handling: {How to handle tool errors}
- Tool result validation: {How to validate tool responses}

### MCP Resources
- Available resources: {List of resources from MCP server}
- Resource access: {How to access resources}
- Resource caching: {How to cache resources}
- Resource error handling: {How to handle resource errors}

### MCP Prompts
- Prompt templates: {Available prompt templates}
- Prompt management: {How to manage prompts}
- Prompt usage: {How to use prompts}
- Prompt variables: {How to pass variables to prompts}

### MCP Integration Patterns
- Client initialization: {How to initialize MCP client}
- Connection lifecycle: {How to manage connection lifecycle}
- Error handling: {How to handle MCP errors}
- Retry logic: {How to handle retries and backoff}

## Validation Loop

{Base template Validation Loop section}

### MCP Testing
- Server connection testing: {How to test MCP server connection}
- Tool testing: {How to test MCP tools}
- Resource testing: {How to test MCP resources}
- Integration testing: {How to test MCP integration}
- Performance testing: {How to test MCP performance}

### Error Handling Validation
- Connection errors: {How to validate connection error handling}
- Tool errors: {How to validate tool error handling}
- Resource errors: {How to validate resource error handling}
- Rate limit handling: {How to validate rate limit handling}

## Anti-Patterns

{Base template Anti-Patterns section}

### MCP Specific Anti-Patterns
- Not handling server unavailability: Always implement fallbacks
- Not validating tool responses: Validate all tool responses
- Ignoring rate limits: Respect MCP server rate limits
- Not caching resources: Cache resources when appropriate
- Hardcoding tool calls: Use dynamic tool discovery
- Ignoring connection lifecycle: Properly manage connection state
- Not handling errors: Always implement comprehensive error handling
- Not testing integration: Test MCP integration thoroughly
