---
name: sprint-loop
description: "Adversarial sprint cycle with Generator vs Evaluator competition. Use when: (1) user wants automated build+verify cycles — 'sprint loop', '경쟁시켜', '자동으로 만들고 검증해줘', (2) task has multiple deliverables that can be split into sprints, (3) user wants competitive pressure between builder and reviewer. Do NOT use for single trivial fixes, manual-control workflows (use /planner), or pure research tasks."
---

Automated adversarial development loop. Generator builds, Evaluator tears it apart. They compete sprint-by-sprint until the Evaluator can't find flaws.

## Roles

| Role | Agent | Responsibility |
|------|-------|---------------|
| Contractor | `analyst` → `planner` → `critic` | analyst 분해 → planner 계획 → critic 리뷰 |
| Generator | `deep-executor` | Implements sprint contract, builds defensively |
| Evaluator | `verifier` + `critic` | Runs tests/builds (verifier), reviews quality (critic) |
| Referee | Orchestrator (you) | Enforces contracts, breaks ties, escalates |

## Execution Flow

### Phase 0: Decomposition & Planning

1. Spawn `analyst` → requirements decomposition, gap analysis, sprint splitting
2. Spawn `planner` with analyst output → implementation plan per sprint (files, steps, acceptance criteria)
3. Spawn `critic` → review each sprint plan (REJECT → planner revises, max 3 rounds)
4. Save confirmed contracts to `.claude/sprints/sprint-{N}.md`
5. Present sprint overview to user for approval via `AskUserQuestion`

### Phase 1-N: Sprint Cycle

```
analyst → planner → critic(approve)
                        ↓
               ┌─── Generator (deep-executor) ───┐
               │    implements contract           │
               └──────────┬──────────────────────┘
                          ↓
               ┌─── Evaluator (verifier+critic) ──┐
               │    attacks implementation         │
               │    PASS → next sprint             │
               │    FAIL → Generator fixes (max 3) │
               └──────────────────────────────────┘
```

**Step 1: Contract Lock** — Load `.claude/sprints/sprint-{N}.md`. No scope changes mid-sprint.

**Step 2: Generator Builds** — Spawn `deep-executor` with sprint contract. Own smoke tests don't count as verification.

**Step 3: Evaluator Attacks** — Spawn `verifier` + `critic` in parallel. Produce verdict with evidence.

**Step 4: Fix Loop** — On FAIL, Generator fixes ONLY reported flaws. Evaluator re-evaluates. Max 3 rounds → escalate to user.

**Step 5: Sprint Close** — On PASS, save result to `.claude/sprints/sprint-{N}-result.md`, update scoreboard, move to next sprint.

- For contract format, verdict format, scoreboard, and competition rules: see [contracts-and-rules.md](references/contracts-and-rules.md)

## Escalation

- **3 fix rounds exhausted**: Stop, present flaws to user
- **Generator-Evaluator disagreement**: Spawn `architect` as tiebreaker
- **Scope ambiguity**: Ask user via `AskUserQuestion`

## Tool Usage

- Spawn `analyst` for Phase 0 decomposition
- Spawn `planner` for sprint planning (receives analyst output)
- Spawn `critic` for plan review before contract lock + evaluation during sprints
- Spawn `deep-executor` for Generator (one sprint at a time)
- Spawn `verifier` + `critic` in parallel for Evaluator
- Spawn `architect` as tiebreaker when needed
- Spawn `test-engineer` when verifier flags missing coverage
- Use Write for `.claude/sprints/` files
- Use `AskUserQuestion` for approvals and escalations

## Output

After all sprints complete, report: final scoreboard, deliverables per sprint, files changed, total flaws caught, first-pass success rate, test coverage evidence, build status.

## Usage

- `/sprint-loop [task description]`
- `/sprint-loop [task] --sprints 3` (limit sprint count)
- `/sprint-loop [task] --strict` (score threshold 95+)
