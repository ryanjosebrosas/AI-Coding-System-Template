# Inspo Repo Analyzer Utility

Analyze GitHub repositories as inspiration for your project. This utility uses the `gh` CLI to fetch repo info, structure, and dependencies.

## Usage

When a user provides a GitHub repo URL (e.g., `github.com/owner/repo` or `https://github.com/owner/repo`), use this utility to analyze it.

## Analysis Steps

### Step 1: Parse URL and Validate

Extract owner and repo from URL:
```
Input: "https://github.com/owner/repo" or "github.com/owner/repo" or "owner/repo"
Output: owner="owner", repo="repo"
```

### Step 2: Fetch Basic Repo Info

```bash
gh repo view owner/repo --json name,description,languages,defaultBranchRef
```

Extract:
- Repository name and description
- Primary languages
- Default branch

### Step 3: Fetch File Structure

```bash
gh api repos/owner/repo/contents
```

Extract top-level directories and files:
- `/src`, `/lib`, `/components` → Application structure
- `/tests`, `/__tests__` → Testing approach
- `/docs` → Documentation approach
- Config files → Tool choices (tsconfig.json, eslint, etc.)

### Step 4: Detect Tech Stack

**For JavaScript/TypeScript projects**:
```bash
gh api repos/owner/repo/contents/package.json --jq '.content' | base64 -d
```

Parse `package.json` for:
- `dependencies` → Runtime dependencies
- `devDependencies` → Dev tools
- `scripts` → Build/test commands

**For Python projects**:
```bash
gh api repos/owner/repo/contents/requirements.txt --jq '.content' | base64 -d
# or
gh api repos/owner/repo/contents/pyproject.toml --jq '.content' | base64 -d
```

### Step 5: Fetch README (Optional)

```bash
gh api repos/owner/repo/readme --jq '.content' | base64 -d
```

Extract:
- Project description
- Installation instructions
- Architecture overview (if documented)

## Output Format

Present analysis to user in this format:

```
## Inspo Repo Analysis: {owner}/{repo}

**Description**: {repo description}

### Languages
{Primary language} ({percentage}%), {Secondary} ({percentage}%)

### File Structure
```
/
├── src/           # Application source
├── components/    # UI components
├── lib/           # Utilities
├── tests/         # Test files
├── package.json   # Dependencies
└── README.md      # Documentation
```

### Tech Stack
- **Framework**: {e.g., React, Next.js, FastAPI}
- **Database**: {e.g., Supabase, PostgreSQL}
- **Styling**: {e.g., Tailwind, CSS Modules}
- **Testing**: {e.g., Jest, pytest}

### Key Dependencies
- {dependency1} - {brief description}
- {dependency2} - {brief description}

### Patterns Worth Noting
- {Pattern 1, e.g., "Uses component-based architecture"}
- {Pattern 2, e.g., "API routes in /api directory"}
```

## Aspects to Adopt

After presenting analysis, ask user:
```
"Which aspects would you like to adopt from this repo?"

1. File structure
2. Tech stack
3. Architecture patterns
4. Testing approach
5. All of the above
6. None (just for reference)
```

Store selected aspects for PRD/Tech Spec generation.

## Error Handling

### Repo Not Found
```
"Couldn't find repo '{owner}/{repo}'. Check the URL is correct."
```

### Private Repo
```
"This appears to be a private repo. Make sure you're authenticated with gh:
  gh auth login
Or describe what you liked about it instead."
```

### No Package.json / requirements.txt
```
"Couldn't find dependency file. Detected languages: {languages}.
Would you like to describe the tech stack manually?"
```

### Rate Limited
```
"GitHub API rate limited. Try again in a few minutes, or describe the repo manually."
```

## Integration

This utility is called from `/planning` and `/development` commands when user provides an inspo repo URL. The extracted information is used to:

1. **In /planning**: Inform feature priorities and structure
2. **In /development**: Suggest tech stack and architecture patterns
