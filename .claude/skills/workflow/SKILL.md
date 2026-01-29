---
name: workflow
description: "Run complete development lifecycle"
user-invocable: true
disable-model-invocation: false
---

# Workflow Skill

Unified command for complete development lifecycle.

## Pipeline Stages

```
Prime → Discovery → Planning → Development → Task Planning → Execution → Review → Test
```

## Execution Options

### Full Pipeline
Run all stages in sequence:
```
/workflow full
```

### From Stage
Start from specific stage:
```
/workflow from:planning
/workflow from:development
/workflow from:execution
```

### Single Stage
Run one stage only:
```
/workflow planning
/workflow execution
```

## Stage Dependencies

| Stage | Requires |
|-------|----------|
| Discovery | Prime export |
| Planning | Discovery document |
| Development | PRD |
| Task Planning | PRD + Tech Spec |
| Execution | Task Plan + PRP |
| Review | Completed execution |
| Test | Code changes |

## Interactive Mode

Each interactive stage (discovery, planning, development) will:
1. Engage in conversational probing
2. Gather context through questions
3. Generate artifact after confirmation

## Output

- All artifacts from each stage
- STATUS.md tracking at each phase
- Final summary of workflow completion

## Reference

Full implementation details: `.claude/commands/workflow.md`
