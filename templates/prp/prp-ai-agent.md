# PRP: {feature-name} - AI Agent

**Template**: prp-ai-agent.md | **Extends**: prp-base.md

## Goal

{Base template Goal section}

## All Needed Context

{Base template All Needed Context section}

### AI Agent Specific Context
- Agent framework documentation (Claude API, LangChain, etc.)
- Model capabilities and limitations
- Tool integration patterns
- Prompt engineering best practices
- Agent architecture patterns from codebase

## Implementation Blueprint

{Base template Implementation Blueprint section}

### Agent Architecture
- Agent type: {Claude agent, LangChain agent, custom agent}
- Framework: {Claude API, LangChain, custom framework}
- Model: {Claude Sonnet, GPT-4, etc.}
- Prompt engineering: {System prompts, user prompts, tool descriptions}

### Agent Tools
- Available tools: {List of tools agent can use}
- Tool integration: {How tools are integrated}
- Tool calling patterns: {How agent calls tools}
- Tool error handling: {How to handle tool failures}

### Agent Memory
- Memory type: {Conversation history, vector store, etc.}
- Context window: {Token limits, context management}
- Memory persistence: {How memory is stored and retrieved}

### Agent Workflow
- Execution flow: {Step-by-step agent execution}
- Decision making: {How agent makes decisions}
- Error handling: {How agent handles errors}
- State management: {How agent maintains state}

## Validation Loop

{Base template Validation Loop section}

### Agent Testing
- Prompt testing: {How to test prompts}
- Tool testing: {How to test tool integration}
- End-to-end testing: {How to test complete agent workflow}
- Performance testing: {How to test agent performance}

### Output Validation
- Response quality: {How to validate agent responses}
- Tool call validation: {How to validate tool calls}
- Error handling validation: {How to validate error handling}

## Anti-Patterns

{Base template Anti-Patterns section}

### AI Agent Specific Anti-Patterns
- Overly complex prompts: Keep prompts focused and clear
- Ignoring context limits: Manage context window carefully
- Not handling tool errors: Always handle tool failures gracefully
- Hardcoding responses: Use dynamic generation
- Not testing prompts: Test prompts thoroughly before deployment
- No memory management: Always implement memory persistence
- Ignoring token limits: Respect model token limitations
