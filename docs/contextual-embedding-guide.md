# Contextual Embedding Setup Guide

This guide explains how to enable contextual retrieval in Archon for improved RAG accuracy.

## What is Contextual Embedding?

Contextual embedding is an Anthropic technique that prepends explanatory context to each chunk before embedding. This helps the embedding model understand what the chunk is about in relation to the full document.

**Traditional Embedding**:
```
Chunk: "The function returns a list of users."
```

**Contextual Embedding**:
```
Chunk: "This is from the API documentation for the /users endpoint.
The function returns a list of users."
```

## Performance Improvement

| Metric | Without Contextual | With Contextual | Improvement |
|--------|-------------------|-----------------|-------------|
| Retrieval Accuracy | ~60% | 81-95% | +35-67% |
| Failed Retrievals | 5.7% | 1.9% | -67% |
| Chunk Relevance | Moderate | High | Significant |

Source: [Anthropic Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval)

## Cost Implications

Contextual embedding requires an additional Claude API call per chunk to generate context:

| Operation | Cost |
|-----------|------|
| Embedding generation | Standard embedding cost |
| Context generation | ~$1.02 per million tokens |
| Total overhead | ~15-25% increase |

**When is it worth it?**
- High-value knowledge bases (documentation, code examples)
- Frequently queried sources
- Technical content where precision matters

## Enabling in Archon

### Step 1: Update Archon Configuration

In your Archon MCP server configuration:

```json
{
  "rag": {
    "contextual_embedding": {
      "enabled": true,
      "model": "claude-3-haiku-20240307",
      "max_context_length": 150,
      "parallel_workers": 5
    }
  }
}
```

**Parameters**:
- `enabled`: Toggle contextual embedding on/off
- `model`: Claude model for context generation (Haiku recommended for cost)
- `max_context_length`: Max tokens for generated context
- `parallel_workers`: Concurrent context generations (default: 3, recommended: 5)

### Step 2: Re-index Existing Sources

After enabling, existing sources need re-indexing:

```bash
# Via Archon CLI (if available)
archon reindex --source-id src_abc123

# Or via MCP tool
# Re-crawl the source to trigger re-embedding
```

**Re-indexing Notes**:
- Re-indexing processes all chunks with new contextual embeddings
- Takes ~2-3x longer than initial indexing
- Existing embeddings are replaced (not duplicated)
- Schedule during low-usage periods

### Step 3: Verify Activation

Check that contextual embedding is active:

```python
# Via health_check response
{
  "rag": {
    "contextual_embedding": "enabled",
    "sources_reindexed": 4,
    "sources_pending": 2
  }
}
```

## Best Practices

1. **Start with high-value sources**: Enable for documentation first, then expand
2. **Use Haiku for context generation**: Much cheaper than Sonnet/Opus
3. **Set parallel_workers based on rate limits**: 5 is balanced for most setups
4. **Monitor costs**: Track context generation API usage
5. **Combine with BM25**: Hybrid search (contextual + BM25) provides best results

## Troubleshooting

### Contexts Not Being Generated
- Check `enabled: true` in configuration
- Verify Claude API key has sufficient credits
- Check model availability in your region

### Re-indexing Slow
- Reduce `parallel_workers` if hitting rate limits
- Process sources in batches during off-hours
- Consider Haiku if using more expensive models

### No Improvement in Results
- Verify sources were actually re-indexed
- Check that queries use the reindexed source_id
- Enable debug mode to see embedding details

## Related Configuration

See also:
- [Smart Context Retrieval](../CLAUDE.md#smart-context-retrieval) - Language-aware filtering
- [Prime Command](../.claude/commands/prime.md) - Diff-based caching
