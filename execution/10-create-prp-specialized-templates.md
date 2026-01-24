---
archon_task_id: e7f6c606-a26e-42ff-8204-348fc23f7fd5
project_id: 49e7f3a1-d9c5-439f-aa5f-2cdf4fec5b61
status: done
task_order: 109
assignee: User
created_at: 2026-01-23T16:33:09.931401+00:00
updated_at: 2026-01-23T16:55:39.283781+00:00
---

# 10: Create PRP Specialized Templates

**Status:** Done

## Description
Create specialized PRP templates: ai-agent, mcp-integration, api-endpoint, frontend-component.

## Implementation Steps

### ai-agent.md Template
- [ ] Extend prp-base.md
- [ ] Add agent-specific sections:
  - Agent capabilities definition
  - Tool usage patterns
  - State management
  - Error handling for agents
- [ ] Include common agent gotchas
- [ ] Add validation for agent behavior

### mcp-integration.md Template
- [ ] Extend prp-base.md
- [ ] Add MCP-specific sections:
  - MCP server connection
  - Tool integration patterns
  - Error handling for MCP calls
  - Fallback strategies
- [ ] Include MCP best practices
- [ ] Add health check validation

### api-endpoint.md Template
- [ ] Extend prp-base.md
- [ ] Add API-specific sections:
  - Endpoint definition
  - Request/response schemas
  - Authentication/authorization
  - Error response format
- [ ] Include API security checklist
- [ ] Add integration test requirements

### frontend-component.md Template
- [ ] Extend prp-base.md
- [ ] Add frontend-specific sections:
  - Component props/state
  - UI/UX requirements
  - Accessibility considerations
  - Responsive design
- [ ] Include frontend best practices
- [ ] Add visual regression testing

### Template Documentation
- [ ] Document when to use each template
- [ ] Add template selection guide
- [ ] Include examples

## References
- templates/prp/prp-base.md - Base PRP template
- PRD.md - Project requirements for context
