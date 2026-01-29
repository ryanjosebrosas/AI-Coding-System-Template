---
name: test
description: "Run tests with AI-suggested fixes"
user-invocable: true
disable-model-invocation: false
---

# Test Skill

Automated testing with error detection and AI-suggested fixes.

## Execution Flow

1. **Detect Framework** - Jest, pytest, etc.
2. **Run Tests** - Execute test suite
3. **Analyze Failures** - Parse error messages
4. **Suggest Fixes** - AI-powered suggestions
5. **Report Results** - Summary with actions

## Supported Frameworks

| Language | Framework |
|----------|-----------|
| JavaScript/TypeScript | Jest, Vitest, Mocha |
| Python | pytest, unittest |
| Go | go test |
| Rust | cargo test |

## Error Analysis

For each failing test:
1. Parse error message and stack trace
2. Identify likely cause
3. Suggest fix with code snippet
4. Offer to apply fix

## Output

- Test results summary
- Failure analysis with suggestions
- Coverage report (if available)

## Usage

```
/test                  # Run all tests
/test path/to/test.ts  # Run specific test
/test --coverage       # Include coverage
```

## Reference

Full implementation details: `.claude/commands/test.md`
