# PRP: {feature-name} - API Endpoint

**Template**: prp-api-endpoint.md | **Extends**: prp-base.md

## Goal

{Base template Goal section}

## All Needed Context

{Base template All Needed Context section}

### API Specific Context
- API framework documentation (Express, FastAPI, etc.)
- API design patterns from codebase
- Authentication patterns from codebase
- Validation patterns from codebase
- Error handling patterns from codebase

## Implementation Blueprint

{Base template Implementation Blueprint section}

### API Design
- Endpoint: {HTTP method and path}
- Request format: {Request body, query parameters, headers}
- Response format: {Response body, status codes, headers}
- Error format: {Error response format}
- Versioning: {API versioning strategy}

### API Authentication
- Authentication method: {JWT, API key, OAuth, etc.}
- Authorization: {Role-based, permission-based, etc.}
- Security: {HTTPS, CORS, rate limiting, etc.}
- Token validation: {How to validate tokens}
- Token refresh: {How to handle token refresh}

### API Validation
- Request validation: {Input validation, schema validation}
- Response validation: {Output validation, schema validation}
- Error handling: {Error response format, error codes}
- Sanitization: {Input sanitization, XSS prevention}
- Content validation: {Content-Type validation}

### API Documentation
- Documentation format: {OpenAPI, Swagger, Markdown}
- Endpoint documentation: {Request/response examples}
- Error documentation: {Error codes and messages}
- Versioning documentation: {How API versioning is documented}
- Example requests: {Example requests for testing}

### Rate Limiting & Throttling
- Rate limiting strategy: {How rate limiting is implemented}
- Rate limit values: {Rate limit configuration}
- Throttling behavior: {What happens when rate limit exceeded}
- Rate limit headers: {Headers for rate limit information}

### API Monitoring & Logging
- Request logging: {What is logged for each request}
- Error logging: {How errors are logged}
- Performance metrics: {Metrics collected for monitoring}
- Alerting: {Alert conditions and notification}

## Validation Loop

{Base template Validation Loop section}

### API Testing
- Unit testing: {Test controllers, services, models}
- Integration testing: {Test API endpoints end-to-end}
- Performance testing: {Test API performance, load testing}
- Security testing: {Test authentication, authorization, input validation}
- Error testing: {Test error handling and error responses}

### API Contract Testing
- Schema validation: {Test against defined schemas}
- Example validation: {Test with example requests}
- Error scenario testing: {Test all error scenarios}
- Edge case testing: {Test edge cases and boundary conditions}

## Anti-Patterns

{Base template Anti-Patterns section}

### API Specific Anti-Patterns
- Not validating input: Always validate all input
- Exposing sensitive data: Never expose sensitive data in responses
- Not handling errors: Always return proper error responses
- Ignoring security: Always implement authentication and authorization
- Not documenting APIs: Always document API endpoints
- Hardcoding responses: Use dynamic generation based on input
- Ignoring rate limits: Respect rate limiting and implement properly
- Not monitoring performance: Always monitor API performance
- Inconsistent error responses: Use consistent error format across all endpoints
