---
name: Learn Compress
description: "Compress reference content to reduce token usage"
phase: independent
dependencies: []
outputs:
  - description: "Reference content compressed with token savings reported"
inputs: []
---

# Learn Compress Command

## Purpose

Analyze `archon_references` table for redundant content (verbose explanations, duplicate code examples, fluff phrases), compress to remove redundancies while preserving technical accuracy, and update `is_compressed` flag.

**When to use**: After learning multiple references, when token usage is high, or periodically for optimization.

**Solves**: Verbose, redundant reference content that wastes tokens during context loading. Unlike `/learn-dedupe` (merges entire references), `/learn-compress` optimizes individual content by removing internal redundancy.

## Prerequisites

- Supabase `archon_references` table exists (Migration 012 + 013)
- Direct SQL access to Supabase
- At least 1 reference with `is_compressed = false` and `token_count >= 500`

## Execution Steps

### Step 1: Query Compressible References

```sql
SELECT id, topic, category, content, token_count, is_compressed
FROM archon_references
WHERE is_compressed = FALSE
  AND token_count >= 500
  AND duplicate_of IS NULL
ORDER BY token_count DESC;
```

### Step 2: Analyze Compression Potential

For each candidate:
- **Count fluff phrases**: "It's important to note", "Keep in mind", etc.
- **Detect redundant sections**: Use n-gram overlap (4-word sequences)
- **Count code examples**: Extract and check for duplicates
- **Calculate estimated savings**:
  - Fluff removal: 5 tokens per phrase
  - Redundancy removal: 100 tokens per section pair
  - Example consolidation: 50 tokens per duplicate
- Filter: Keep only `estimated_savings_percent >= 20`

**N-Gram Overlap Algorithm**:
```python
def detect_redundant_sections(content: str) -> list:
    sections = content.split('##')
    redundancies = []
    for i, section1 in enumerate(sections):
        for section2 in sections[i+1:]:
            words1 = section1.lower().split()
            words2 = section2.lower().split()
            ngrams1 = set(' '.join(words1[j:j+4]) for j in range(len(words1) - 3))
            ngrams2 = set(' '.join(words2[j:j+4]) for j in range(len(words2) - 3))
            if ngrams1 and ngrams2:
                similarity = len(ngrams1 & ngrams2) / len(ngrams1 | ngrams2)
                if similarity >= 0.75:
                    redundancies.append((i, len(sections) - len(section2), similarity))
    return redundancies
```

### Step 3: Present Candidates & Confirm

```
## Found {count} References with Compression Potential

### 1. "{topic}" ({token_count} tokens)
- **Estimated savings**: {savings} tokens ({percent}%)
- **Compression opportunities**:
  - {fluff_count} fluff phrases
  - {redundancy_count} redundant sections
  - {example_count} code examples → {consolidated_count}

---
**Total estimated savings**: {total_savings} tokens

Which references to compress? (comma-separated numbers, "all", or "none")
```

### Step 4: Compress Content

**Phase 1**: Remove fluff phrases
- Search for FLUFF_PHRASES, remove from content (preserve code blocks)

**Phase 2**: Remove redundant sections
- Use n-gram overlap detection, keep first occurrence

**Phase 3**: Consolidate code examples
- Group similar examples, keep most comprehensive per group

**Phase 4**: Update database
```sql
UPDATE archon_references
SET
  content = $1,
  token_count = $2,
  is_compressed = TRUE,
  compressed_content = $3,  -- JSONB metadata
  updated_at = NOW()
WHERE id = $4;
```

**compressed_content metadata**:
```json
{
  "compressed": true,
  "original_token_count": 1250,
  "compressed_token_count": 850,
  "token_savings": 400,
  "savings_percent": 32.0,
  "compression_date": "2026-01-26T12:00:00Z",
  "fluff_removed": 15,
  "redundancies_removed": 2,
  "examples_consolidated": 3
}
```

**Fluff Phrase List**:
```python
FLUFF_PHRASES = [
    "It's important to note", "Keep in mind", "As you can see",
    "It's worth mentioning", "Note that", "Remember", "Make sure to",
    "Don't forget", "In order to", "Due to the fact that",
    "At this point in time",
]
```

### Step 5: Validate Compression

```python
def validate_compression(original: str, compressed: str) -> dict:
    issues = []
    original_code = extract_code_blocks(original)
    compressed_code = extract_code_blocks(compressed)
    if len(compressed_code) < len(original_code):
        issues.append(f"Missing code blocks: {len(original_code) - len(compressed_code)}")
    for term in extract_technical_terms(original):
        if term not in compressed:
            issues.append(f"Missing technical term: {term}")
    return {'valid': len(issues) == 0, 'issues': issues}
```

If validation fails, restore original from backup.

### Step 6: Display Results

```
## Compression Complete

**Compressed {count} reference(s)**:

✓ 1. "{topic}" (ID: {id})
   - Original: {original_tokens} tokens
   - Compressed: {compressed_tokens} tokens
   - Saved: {saved} tokens ({percent}%)

**Total Token Savings**: {total_saved} tokens ({average_percent}% average)

---
Run `/learn-health` to see updated library statistics.
```

## Error Handling

| Error | Cause | Recovery |
|-------|-------|----------|
| Table Not Found | Migration 012/013 not run | Run migration SQL |
| No Candidates | All compressed or too small | Display message |
| Compression Fails | Processing or DB error | Restore from backup |
| Validation Fails | Critical info missing | Restore original, skip |
| User Cancels | User enters "none" | No changes made |

## Output Example

```
## Found 3 References with Compression Potential

### 1. "Python async/await patterns" (1,250 tokens)
- **Estimated savings**: 400 tokens (32%)
- 15 fluff phrases, 2 redundant sections, 5→2 code examples

### 2. "React hooks useState guide" (980 tokens)
- **Estimated savings**: 280 tokens (29%)
- 12 fluff phrases, 1 redundant section, 3→2 code examples

---
**Total estimated savings**: 680 tokens (31% average)

Which references to compress? 1,2

## Compression Complete

**Compressed 2 reference(s)**:

✓ 1. "Python async/await patterns"
   - Saved: 400 tokens (32%)

✓ 2. "React hooks useState guide"
   - Saved: 280 tokens (29%)

**Total Token Savings**: 680 tokens
```

## Notes

- **Threshold**: Only >=500 tokens with >=20% estimated savings
- **Code preservation**: Never truncates code blocks, only consolidates duplicates
- **Reversible**: Metadata stores original stats for potential rollback
- **Typical savings**: 30-50% reduction per reference
- **Performance**: O(n²) due to section comparison, runs on-demand

## Best Practices

**When to compress**:
- After bulk learning sessions (5+ new references)
- When library exceeds 10,000 tokens
- Periodically (monthly) for maintenance

**When to skip**:
- Reference is all code blocks
- Highly technical content (minimal fluff)
- Recently updated (within 7 days)

## Integration

- **`/learn`**: New references added uncompressed, run compress after sessions
- **`/learn-dedupe`**: Run compress after deduplication
- **`/learn-health`**: Run after compress to see updated stats

## Validation

- [ ] SQL queries executed
- [ ] Compression analyzed
- [ ] User confirmed
- [ ] Content compressed
- [ ] Validation passed
- [ ] Database updated
- [ ] Results displayed
