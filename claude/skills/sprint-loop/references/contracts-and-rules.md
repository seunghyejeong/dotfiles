# Sprint Contracts & Competition Rules

## Sprint Contract Format

```markdown
## Sprint N: [Feature Name]

**Status:** PENDING | IN_PROGRESS | REVIEW | PASSED | FAILED

### Deliverables
1. [Concrete deliverable with file path]
2. [Concrete deliverable with file path]

### Acceptance Criteria
- [ ] [Testable criterion — pass/fail, not subjective]
- [ ] [Testable criterion]
- [ ] [Testable criterion]

### Out of Scope
- [Explicitly excluded items]

### Generator Constraints
- Max files to modify: [N]
- No new dependencies unless listed here: [list]

### Evaluator Focus
- [Specific areas to attack: edge cases, error handling, regression, etc.]
```

## Evaluation Verdict Format

```markdown
## Sprint N Evaluation

**Verdict:** PASS | FAIL
**Score:** [0-100]

### Evidence
| Criterion | Status | Evidence |
|-----------|--------|----------|
| [criterion] | PASS/FAIL | [proof] |

### Flaws Found (Evaluator Wins)
1. [Flaw] — Severity: HIGH/MEDIUM/LOW — Evidence: [file:line]

### Generator Defense
[Areas where Generator built defensively and Evaluator couldn't break]

### Required Fixes (if FAIL)
1. [Specific fix needed]
```

## Scoreboard Format

Track in `.claude/sprints/scoreboard.md`:

```markdown
## Sprint Scoreboard

| Sprint | Generator | Evaluator | Rounds | Verdict |
|--------|-----------|-----------|--------|---------|
| 1      | 85        | 2 flaws   | 1      | PASS    |
| 2      | 70        | 5 flaws   | 3      | PASS    |
| 3      | 95        | 0 flaws   | 1      | PASS    |

**Generator Win Rate:** 66% (first-pass passes)
**Evaluator Catch Rate:** 7 flaws across 3 sprints
```

- Generator "wins" a sprint by passing on round 1 (zero flaws)
- Evaluator "wins" by finding real flaws that require fixes

## Competition Rules

1. **No collusion**: Evaluator must not go easy. If Evaluator approves sloppy work, the next sprint's contract gets stricter acceptance criteria.
2. **No sabotage**: Evaluator can only flag real issues with evidence. "I don't like the style" is not a flaw. Every flaw must cite file:line and explain the failure.
3. **Generator learns**: Each sprint, Generator sees what Evaluator caught last time. Repeated flaws of the same type are penalized (counted as 2x in scoreboard).
4. **Evaluator escalates**: If Generator makes the same mistake 3+ times across sprints, Evaluator can request an `architect` review for systemic issues.
5. **Contract is law**: Neither side can change scope mid-sprint. If scope is wrong, finish the sprint and fix the contract for next sprint.
