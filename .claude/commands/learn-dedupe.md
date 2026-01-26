---
name: Learn Dedupe
description: "Find and merge duplicate references in the library"
phase: independent
dependencies: []
outputs:
  - description: "Duplicate references identified and merged"
inputs: []
---

# Learn Dedupe Command

## Purpose

Find duplicate or highly similar references in the `archon_references` table using similarity search, present potential duplicates to the user for review, and merge confirmed duplicates to maintain a clean, efficient reference library.

This command helps maintain reference library quality by identifying redundant entries and consolidating them, reducing token usage during selective context loading.

**When to use**: Use this command when you suspect duplicate references exist, after bulk learning sessions, or periodically to maintain library hygiene.

**What it solves**: This command addresses the problem of duplicate or near-duplicate references that waste tokens during context loading and create confusion about which reference to use.

## Prerequisites

- Supabase `archon_references` table exists (Migration 012)
- Direct SQL access to Supabase
- At least 2 references in the library

## Execution Steps

### Step 1: Query All References

**Objective**: Load all references for similarity analysis.

**Actions**:
1. Execute SQL query (direct Supabase access):
   ```sql
   SELECT
     id,
     topic,
     category,
     summary,
     tags,
     content,
     created_at,
     updated_at
   FROM archon_references
   ORDER BY category, updated_at DESC;
   ```
2. Parse results into references array

**Expected Result**: Complete list of all references with metadata.

### Step 2: Group by Category

**Objective**: Only compare references within the same category.

**Actions**:
1. Group references by `category` field
2. Create separate arrays for each category

**Expected Result**: Dictionary mapping categories to arrays of references.

### Step 3: Similarity Search

**Objective**: Find potential duplicates using text similarity algorithms.

**Actions**:
1. For each category with 2+ references:
   - Compare each reference pair (nested loop)
   - Calculate similarity score using:
     - **Topic similarity**: Compare topic strings (40% weight)
       - Use Levenshtein distance ratio or word overlap
       - Normalize: 0 = no match, 1 = exact match
     - **Summary similarity**: Compare summary strings (40% weight)
       - Use word overlap or simple cosine similarity on word counts
       - Normalize: 0 = no match, 1 = exact match
     - **Tag overlap**: Compare tag arrays (20% weight)
       - Count matching tags / total unique tags
       - Normalize: 0 = no overlap, 1 = all tags match
   - Combined similarity = (topic × 0.4) + (summary × 0.4) + (tags × 0.2)
2. Flag pairs with similarity score ≥ 0.7 (70%) as potential duplicates
3. Sort potential duplicates by similarity score (highest first)

**Similarity Algorithm** (simple implementation):
```python
def calculate_similarity(ref1, ref2):
    # Topic similarity (word overlap)
    topic1_words = set(ref1['topic'].lower().split())
    topic2_words = set(ref2['topic'].lower().split())
    topic_sim = len(topic1_words & topic2_words) / max(len(topic1_words | topic2_words), 1)

    # Summary similarity (word overlap)
    summary1_words = set(ref1['summary'].lower().split())
    summary2_words = set(ref2['summary'].lower().split())
    summary_sim = len(summary1_words & summary2_words) / max(len(summary1_words | summary2_words), 1)

    # Tag overlap
    tags1 = set(ref1.get('tags', []))
    tags2 = set(ref2.get('tags', []))
    tag_sim = len(tags1 & tags2) / max(len(tags1 | tags2), 1)

    # Combined score
    return (topic_sim * 0.4) + (summary_sim * 0.4) + (tag_sim * 0.2)
```

**Expected Result**: List of potential duplicate pairs with similarity scores.

### Step 4: Present Potential Duplicates

**Objective**: Display potential duplicates to user for review.

**Actions**:
1. Format output as markdown:
   ```
   ## Found {count} Potential Duplicate Pairs

   ### Pair 1 (Similarity: {score}%)
   **Reference A** (ID: {id_a}, Updated: {date_a})
   - **Topic**: {topic_a}
   - **Category**: {category_a}
   - **Summary**: {summary_a}
   - **Tags**: {tags_a}

   **Reference B** (ID: {id_b}, Updated: {date_b})
   - **Topic**: {topic_b}
   - **Category**: {category_b}
   - **Summary**: {summary_b}
   - **Tags**: {tags_b}

   ---

   ### Pair 2 (Similarity: {score}%)
   ...

   ## Merge Strategy
   When merging duplicates:
   - Keep the most recently updated reference
   - Combine tags from both references
   - Keep the content from the most recent reference
   - Delete the older reference
   ```
2. Include similarity percentage for each pair
3. Show full details for easy comparison

**Expected Result**: Formatted duplicate report displayed to user.

### Step 5: User Confirmation

**Objective**: Get user approval before merging.

**Actions**:
1. Ask user which pairs to merge:
   ```
   Which pairs would you like to merge?

   Options:
   - Enter comma-separated pair numbers (e.g., "1,3,5")
   - Enter "all" to merge all suggested pairs
   - Enter "none" to skip all
   - Enter specific pairs individually (e.g., "1" to merge pair 1 only)
   ```
2. Parse user input
3. Confirm selection:
   ```
   You selected to merge {count} pair(s):
   {list_of_pairs}

   Proceed with merge? (yes/no)
   ```

**Expected Result**: User confirms which pairs to merge.

### Step 6: Merge Duplicates

**Objective**: Merge confirmed duplicates according to strategy.

**Actions**:
1. For each confirmed pair:
   - Identify which reference is newer (compare `updated_at`)
   - **Keep**: The newer reference
   - **Update tags**: Combine unique tags from both references:
     ```sql
     UPDATE archon_references
     SET tags = ARRAY(
       SELECT DISTINCT unnest(array_cat(
         (SELECT tags FROM archon_references WHERE id = {newer_id}),
         (SELECT tags FROM archon_references WHERE id = {older_id})
       ))
     )
     WHERE id = {newer_id};
     ```
   - **Delete**: The older reference:
     ```sql
     DELETE FROM archon_references
     WHERE id = {older_id};
     ```
2. Log each merge operation

**Expected Result**: Duplicates merged, library cleaned up.

### Step 7: Display Results

**Objective**: Show merge results to user.

**Actions**:
1. Format output as markdown:
   ```
   ## Merge Complete

   **Merged {count} pair(s)**:

   ✓ Pair 1: Kept "{topic}" (ID: {kept_id}), deleted ID {deleted_id}
   ✓ Pair 2: Kept "{topic}" (ID: {kept_id}), deleted ID {deleted_id}
   ...

   **References removed**: {deleted_count}
   **References remaining**: {remaining_count}

   ---
   Run `/learn-health` to see updated library statistics.
   ```

**Expected Result**: Confirmation of completed merges displayed to user.

## Output Format

The command displays potential duplicates and merges confirmed pairs:

```
## Found 2 Potential Duplicate Pairs

### Pair 1 (Similarity: 85%)
**Reference A** (ID: ref-abc123, Updated: 2026-01-24 10:30)
- **Topic**: Python async/await patterns
- **Category**: python
- **Summary**: How to use async and await keywords in Python for concurrent operations
- **Tags**: ['python', 'async', 'concurrency']

**Reference B** (ID: ref-def456, Updated: 2026-01-22 15:45)
- **Topic**: Async patterns in Python
- **Category**: python
- **Summary**: Using async/await for concurrent programming in Python
- **Tags**: ['python', 'async']

---

### Pair 2 (Similarity: 72%)
**Reference A** (ID: ref-ghi789, Updated: 2026-01-23 09:15)
- **Topic**: React hooks useState
- **Category**: react
- **Summary**: Managing state with useState hook in React components
- **Tags**: ['react', 'hooks', 'state']

**Reference B** (ID: ref-jkl012, Updated: 2026-01-20 14:20)
- **Topic**: useState hook basics
- **Category**: react
- **Summary**: Introduction to React's useState hook for state management
- **Tags**: ['react', 'hooks']

---

## Merge Strategy
When merging duplicates:
- Keep the most recently updated reference
- Combine tags from both references
- Keep the content from the most recent reference
- Delete the older reference

Which pairs would you like to merge?

Options:
- Enter comma-separated pair numbers (e.g., "1,2")
- Enter "all" to merge all suggested pairs
- Enter "none" to skip all
```

After user confirmation:

```
You selected to merge 2 pair(s):
1. "Python async/await patterns" ↔ "Async patterns in Python"
2. "React hooks useState" ↔ "useState hook basics"

Proceed with merge? (yes/no)
```

After merge:

```
## Merge Complete

**Merged 2 pair(s)**:

✓ Pair 1: Kept "Python async/await patterns" (ID: ref-abc123), deleted ID ref-def456
✓ Pair 2: Kept "React hooks useState" (ID: ref-ghi789), deleted ID ref-jkl012

**References removed**: 2
**References remaining**: 15

---
Run `/learn-health` to see updated library statistics.
```

## Error Handling

### Table Not Found

- **Cause**: Migration 012 hasn't been run
- **Detection**: SQL query fails with "relation does not exist"
- **Recovery**: Inform user to run migration SQL, suggest command

### No References Found

- **Cause**: Library is empty or has only 1 reference
- **Detection**: Query returns < 2 references
- **Recovery**: Display "Not enough references to check for duplicates" message, suggest running `/learn`

### No Duplicates Found

- **Cause**: All references are unique
- **Detection**: Similarity search returns 0 pairs with score ≥ 0.7
- **Recovery**: Display "No duplicates found" message, congratulate user on clean library

### User Cancels Merge

- **Cause**: User enters "none" or declines confirmation
- **Detection**: User input = "none" or confirmation = "no"
- **Recovery**: Display "Merge cancelled" message, no changes made

### Merge Fails

- **Cause**: Database constraint violation or connection error
- **Detection**: UPDATE or DELETE query throws exception
- **Recovery**: Display error message, suggest manual review, rollback any partial merges

## Examples

### Example 1: Successful Merge

**Command**: `/learn-dedupe`

**Output**:
```
## Found 1 Potential Duplicate Pair

### Pair 1 (Similarity: 88%)
**Reference A** (ID: ref-xyz789, Updated: 2026-01-24 10:30)
- **Topic**: FastAPI dependency injection
- **Category**: python
- **Summary**: Using Depends() for dependency injection in FastAPI
- **Tags**: ['python', 'fastapi', 'di']

**Reference B** (ID: ref-abc123, Updated: 2026-01-21 15:45)
- **Topic**: FastAPI Depends pattern
- **Category**: python
- **Summary**: Dependency injection with Depends() in FastAPI
- **Tags**: ['python', 'fastapi']

---

Which pairs would you like to merge? 1

You selected to merge 1 pair(s):
1. "FastAPI dependency injection" ↔ "FastAPI Depends pattern"

Proceed with merge? (yes/no) yes

## Merge Complete

**Merged 1 pair(s)**:

✓ Pair 1: Kept "FastAPI dependency injection" (ID: ref-xyz789), deleted ID ref-abc123

**References removed**: 1
**References remaining**: 12

---
Run `/learn-health` to see updated library statistics.
```

### Example 2: No Duplicates

**Command**: `/learn-dedupe`

**Output**:
```
## No Duplicates Found

Your reference library is clean! No similar references detected.

**Total references checked**: 18

Great job maintaining unique, high-quality references!

---
Run `/learn-health` to see library statistics.
```

### Example 3: User Cancels

**Command**: `/learn-dedupe`

**Output**:
```
## Found 3 Potential Duplicate Pairs

[... pairs displayed ...]

Which pairs would you like to merge? none

## Merge Cancelled

No references were merged. Your library remains unchanged.

---
Run `/learn-dedupe` again later if you change your mind.
```

## Notes

- **Similarity threshold**: 70% (0.7) balances false positives vs. missed duplicates
- **Category scope**: Only compares references within the same category
- **Safe merge**: Requires user confirmation, never auto-merges
- **Tag preservation**: Combines unique tags from both references
- **Recency priority**: Keeps the most recently updated reference
- **Token savings**: Merging duplicates reduces token usage during selective context loading

## Similarity Algorithm Details

**Threshold Selection**:
- **70%** (0.7) - Recommended default
  - Balances catching true duplicates while avoiding false positives
  - Topics with 70%+ similarity are likely covering the same concept
- **80%** (0.8) - Conservative
  - Fewer false positives, may miss some duplicates
  - Use if you're cautious about merging
- **60%** (0.6) - Aggressive
  - Catches more duplicates, may include some false positives
  - Use if you want thorough deduplication

**Weight Distribution**:
- **Topic (40%)**: Topic is the most important identifier
- **Summary (40%)**: Summary describes what the reference covers
- **Tags (20%)**: Tags provide category context but are less specific

## Validation

After executing this command:
- [ ] SQL queries executed successfully
- [ ] Similarity scores calculated correctly
- [ ] Potential duplicates identified and presented
- [ ] User confirmation received
- [ ] Merges executed according to strategy
- [ ] Older references deleted
- [ ] Tags combined correctly
- [ ] Results displayed accurately

## Integration with Other Commands

- **`/learn`**: Adding references may create duplicates, run `/learn-dedupe` after learning sessions
- **`/learn-health`**: Run after deduplication to see updated library statistics
- **PRP templates**: Clean library ensures efficient selective context loading
- **`CLAUDE.md`**: Documents command as part of reference library maintenance
