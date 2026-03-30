---
name: sprint-loop
description: Adversarial sprint cycle — Generator vs Evaluator compete until acceptance criteria are met
---

<Purpose>
Automated adversarial development loop. A Generator builds, an Evaluator tears it apart. They compete sprint-by-sprint until the Evaluator can't find flaws. The tension between "ship it" and "break it" produces better code than either side alone.
</Purpose>

<Use_When>
- User wants end-to-end automated build+verify cycles
- Task has multiple deliverables that can be split into sprints
- User wants competitive pressure between builder and reviewer
- "자동으로 만들고 검증하고 반복해줘", "sprint loop", "경쟁시켜"
</Use_When>

<Do_Not_Use_When>
- Single trivial fix (overkill)
- User wants manual control at every step (use `/planner` instead)
- Pure research or exploration task (no build target)
</Do_Not_Use_When>

<Roles>

### Contractor (기획)
**Agent:** `analyst` (Opus, read-only) → `planner` (Opus)
- **analyst**: 요구사항 분해, 갭 분석, 누락된 질문/엣지케이스 식별
- **planner**: analyst 결과를 받아 스프린트별 구현 계획 작성 (3-6 step, acceptance criteria 포함)
- analyst가 "뭘 만들지" 정하고, planner가 "어떻게 만들지" 계획
- 계획은 critic 리뷰를 거쳐 확정 → sprint contract로 저장

### Generator (만들기)
**Agent:** `deep-executor` (Opus)
- Implements the sprint contract
- Must match existing codebase patterns
- Knows the Evaluator will be adversarial — builds defensively

### Evaluator (검증)
**Agent:** `verifier` (Sonnet) + `critic` (Opus)
- **verifier**: Runs tests, builds, diagnostics — hard evidence only
- **critic**: Reviews plan completeness, edge cases, architectural fit
- Goal: find flaws. Evaluator "wins" by finding real issues. Generator "wins" by passing clean.

### Referee (판정)
**Role:** Main orchestrator (you)
- Enforces sprint contracts
- Breaks ties when Generator and Evaluator disagree
- Escalates to user only for scope/priority decisions

</Roles>

<Sprint_Contract_Format>
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
</Sprint_Contract_Format>

<Execution_Flow>

### Phase 0: Decomposition & Planning
1. Spawn `analyst` agent with the user's request → 요구사항 분해, 갭 분석, 스프린트 단위 분할
2. Spawn `planner` agent with analyst output → 스프린트별 구현 계획 작성 (파일, 단계, acceptance criteria)
3. Spawn `critic` agent → 각 스프린트 계획 리뷰 (REJECT 시 planner 재수정, 최대 3회)
4. Save confirmed contracts to `.claude/sprints/sprint-{N}.md`
5. Present sprint overview to user for approval

### Phase 1-N: Sprint Cycle (repeat per sprint)

```
┌─────────────────────────────────────────────────┐
│  SPRINT N                                        │
│                                                   │
│  ┌──────────┐  ┌─────────┐  ┌──────────┐  ┌──────────┐  │
│  │ analyst  │─▶│ planner │─▶│Generator │─▶│Evaluator │  │
│  │(갭 분석) │  │(계획)   │  │(deep-exe)│  │(verifier │  │
│  └──────────┘  └─────────┘  │          │◀─│ +critic) │  │
│                    ▲         │ fix loop │  └──────────┘  │
│                    │critic   │ (max 3)  │       │        │
│                    │review   └──────────┘   PASS/FAIL    │
│                  │  fix loop │         │          │
│                  │  (max 3)  │     PASS/FAIL      │
│                  └───────────┘         │          │
│                                        ▼          │
│                              ┌─────────────────┐  │
│                              │ Sprint Verdict  │  │
│                              │ PASS → next     │  │
│                              │ FAIL → escalate │  │
│                              └─────────────────┘  │
└─────────────────────────────────────────────────┘
```

#### Step 1: Contract Lock
- Load sprint contract from `.claude/sprints/sprint-{N}.md`
- Both Generator and Evaluator are bound to this contract
- No scope changes mid-sprint

#### Step 2: Generator Builds
- Spawn `deep-executor` with sprint contract as context
- Generator implements all deliverables
- Generator runs own smoke tests (but these don't count as verification)

#### Step 3: Evaluator Attacks
- Spawn `verifier` agent: run tests, build, diagnostics, acceptance criteria check
- Spawn `critic` agent (parallel): review implementation quality, edge cases, contract compliance
- Evaluator produces a **Verdict**:

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

#### Step 4: Fix Loop (if FAIL)
- Generator receives Evaluator's flaw report
- Generator fixes ONLY the reported flaws (no scope creep)
- Evaluator re-evaluates ONLY the fixes + regression
- Max 3 fix rounds per sprint. After 3 fails → escalate to user.

#### Step 5: Sprint Close
- On PASS: update sprint status, save result to `.claude/sprints/sprint-{N}-result.md`
- Log scoreboard (running tally of Generator vs Evaluator wins)
- Move to next sprint

</Execution_Flow>

<Scoreboard>
Track competition across sprints in `.claude/sprints/scoreboard.md`:

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
- Both scores push quality up: Generator builds more defensively, Evaluator looks harder
</Scoreboard>

<Competition_Rules>
1. **No collusion**: Evaluator must not go easy. If Evaluator approves sloppy work, the next sprint's contract gets stricter acceptance criteria.
2. **No sabotage**: Evaluator can only flag real issues with evidence. "I don't like the style" is not a flaw. Every flaw must cite file:line and explain the failure.
3. **Generator learns**: Each sprint, Generator sees what Evaluator caught last time. Repeated flaws of the same type are penalized (counted as 2x in scoreboard).
4. **Evaluator escalates**: If Generator makes the same mistake 3+ times across sprints, Evaluator can request an `architect` review for systemic issues.
5. **Contract is law**: Neither side can change scope mid-sprint. If scope is wrong, finish the sprint and fix the contract for next sprint.
</Competition_Rules>

<Escalation>
- **3 fix rounds exhausted**: Stop sprint, present flaws to user, ask for guidance
- **Generator-Evaluator disagreement**: Spawn `architect` agent as tiebreaker (read-only)
- **Scope ambiguity**: Ask user via `AskUserQuestion` before continuing
- **All sprints complete**: Present final scoreboard and summary
</Escalation>

<Tool_Usage>
- Spawn `analyst` agent for Phase 0 requirements decomposition and gap analysis
- Spawn `planner` agent for sprint implementation planning (receives analyst output)
- Spawn `critic` agent for sprint plan review before contract lock
- Spawn `deep-executor` agent for Generator role (one sprint at a time)
- Spawn `verifier` agent + `critic` agent in parallel for Evaluator role
- Spawn `architect` agent as tiebreaker when needed
- Spawn `test-engineer` agent when verifier flags missing test coverage
- Use Write to save sprint contracts and results to `.claude/sprints/`
- Use `AskUserQuestion` for sprint overview approval and escalations
</Tool_Usage>

<Output>
After all sprints complete:

```markdown
## Sprint Loop Complete

### Final Scoreboard
[scoreboard table]

### Deliverables
1. Sprint 1: [feature] — PASSED (round 1)
2. Sprint 2: [feature] — PASSED (round 2, 3 flaws fixed)
3. Sprint 3: [feature] — PASSED (round 1)

### Files Changed
- [file list with summary]

### Quality Summary
- Total flaws caught and fixed: N
- First-pass success rate: N%
- Test coverage: [evidence]
- Build status: PASSING
```
</Output>

<Examples>
<Good>
User: "sprint-loop으로 OAuth 로그인 만들어줘"
→ Analyst decomposes into 3 sprints, Planner writes implementation plan per sprint, Critic approves
→ Sprints: (1) OAuth provider setup, (2) Login/callback flow, (3) Session management
→ Sprint 1: Generator builds, Evaluator finds missing error handling on token refresh → Generator fixes → PASS round 2
→ Sprint 2: Generator builds defensively (learned from Sprint 1) → PASS round 1
→ Sprint 3: Evaluator catches session expiry edge case → fix → PASS round 2
→ Final: 3/3 passed, 2 flaws caught, Generator first-pass rate 33%
</Good>

<Bad>
Generator and Evaluator agree on everything round 1 with no flaws found across 5 sprints.
→ This means Evaluator is not trying hard enough. Contract criteria were too loose.
</Bad>
</Examples>

<Usage>
- `/sprint-loop [task description]`
- `/sprint-loop [task] --sprints 3` (limit sprint count)
- `/sprint-loop [task] --strict` (Evaluator uses HIGH bar, score threshold 95+)
</Usage>
