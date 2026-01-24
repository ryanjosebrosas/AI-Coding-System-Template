# PRP: {feature-name} - Frontend Component

**Template**: prp-frontend-component.md | **Extends**: prp-base.md

## Goal

{Base template Goal section}

## All Needed Context

{Base template All Needed Context section}

### Frontend Specific Context
- Frontend framework documentation (React, Vue, Svelte, etc.)
- Component patterns from codebase
- Styling patterns from codebase
- State management patterns from codebase
- Testing patterns from codebase

## Implementation Blueprint

{Base template Implementation Blueprint section}

### Component Architecture
- Component type: {Functional component, class component, etc.}
- Props: {Component props and types}
- State: {Component state, state management}
- Lifecycle: {Component lifecycle hooks}
- Hooks: {Custom hooks, composition patterns}
- Refs: {When and how to use refs}

### Component Styling
- Styling approach: {CSS modules, styled-components, Tailwind, etc.}
- Responsive design: {Breakpoints, mobile-first, etc.}
- Theming: {Theme support, dark mode, etc.}
- CSS architecture: {Global styles, component styles, utility classes}
- Animation: {Component animations and transitions}

### Component Integration
- API integration: {How component fetches data}
- State management: {How component manages state}
- Routing: {How component integrates with routing}
- Event handling: {Event propagation and handling}
- Context integration: {How component consumes context}

### Component Performance
- Optimization: {Memoization, lazy loading, etc.}
- Code splitting: {How component is code split}
- Bundle size: {How to minimize bundle size}
- Rendering optimization: {How to optimize rendering performance}
- Image optimization: {How to optimize images}

### Accessibility
- ARIA attributes: {Required ARIA attributes}
- Keyboard navigation: {Keyboard interaction support}
- Screen reader support: {How to support screen readers}
- Focus management: {How to manage focus}
- Color contrast: {How to ensure accessible colors}

## Validation Loop

{Base template Validation Loop section}

### Component Testing
- Unit testing: {Test component rendering, props, state}
- Integration testing: {Test component integration}
- Visual testing: {Test component appearance}
- Accessibility testing: {Test component accessibility}
- Performance testing: {Test component performance}

### User Testing
- User scenarios: {Key user flows to test}
- Edge cases: {Edge cases to test}
- Error states: {How to test error handling}
- Loading states: {How to test loading states}

## Anti-Patterns

{Base template Anti-Patterns section}

### Frontend Specific Anti-Patterns
- Not handling loading states: Always show loading states
- Not handling errors: Always handle and display errors
- Ignoring accessibility: Always implement accessibility features
- Not optimizing performance: Always optimize component performance
- Not testing components: Always test components thoroughly
- Prop drilling: Use composition instead of prop drilling
- Giant components: Break down large components into smaller ones
- State duplication: Avoid duplicating state across components
- Inline styles: Use appropriate styling approach
- Ignoring responsive design: Always implement responsive layouts
