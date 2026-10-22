# agentic-sdlc-primitives

A small collection of AI primitives — agents, skills, instructions, and hooks —
for the agentic SDLC, distributed with the
[Agent Package Manager (APM)](https://github.com/microsoft/apm).

## Structure

```text
agents/
  specialist/      Domain-expert agents ({name}.agent.md)
  orchestration/   Multi-step workflow agents ({workflow}/{role}.agent.md)
skills/            Reusable domain knowledge ({skill-name}/SKILL.md)
instructions/      Scoped rules by file pattern ({domain}/{name}.instructions.md)
hooks/             Event-driven automation ({hook-name}/)
apm.yml            Package manifest
```

## Primitives

⭐ The AI Primitive Writer agent and the skills it uses (Also available in the SICK repo)

### Agents

| Agent | Description |
|-------|-------------|
| ⭐ [AI Primitive Writer](agents/specialist/ai-primitive-writer.agent.md) | Picks the right primitive type for a use case and writes it following the PROSE framework |
| [Planner](agents/orchestration/spec-driven-dev/planner.agent.md) | Turns stories into a specification, architecture, and implementation tasks; install with `functional-spec` |
| [Builder](agents/orchestration/spec-driven-dev/builder.agent.md) | Implements one task with tests and a handoff note |
| [Reviewer](agents/orchestration/spec-driven-dev/reviewer.agent.md) | Reviews documents or code without editing files |
| [Orchestrator](agents/orchestration/spec-driven-dev/orchestrator.agent.md) | Delegates to Builder and two parallel Reviewers, with at most two fix rounds; install with both workers |

### Skills

| Skill | Description |
|-------|-------------|
| ⭐ [agent-writing](skills/agent-writing/SKILL.md) | Templates and guidelines for `.agent.md` files |
| ⭐ [skill-authoring](skills/skill-authoring/SKILL.md) | Naming, descriptions, body limits, and references for skills |
| ⭐ [instruction-writing](skills/instruction-writing/SKILL.md) | Templates and guidelines for `.instructions.md` files |
| ⭐ [hook-writing](skills/hook-writing/SKILL.md) | Templates and guidelines for hooks |
| ⭐ [primitive-review](skills/primitive-review/SKILL.md) | PROSE compliance review for any primitive |
| [functional-spec](skills/functional-spec/SKILL.md) | Writes testable requirements and acceptance criteria from stories |

### Instructions and hooks

| Primitive | Description |
|-----------|-------------|
| [Testing rules](instructions/testing/tests.instructions.md) | Scoped rules for test files, including exact boundaries and controllable time |
| [Protect stories](hooks/protect-stories/) | Bash hook that blocks recognized edits to `stories/` and `.github/hooks/`, and asks for terminal approval |

Install the hook as a package with `apm install github.com/proanja/agentic-sdlc-primitives/hooks/protect-stories`.
It requires Bash and `jq`. It stops the agent from editing these files by accident, but it can't prevent every change, for example one made through the terminal.

## Using primitives in your project

Reference individual primitives from your project's `apm.yml`:

```yaml
dependencies:
  apm:
    - github.com/proanja/agentic-sdlc-primitives/skills/primitive-review
    - github.com/proanja/agentic-sdlc-primitives/agents/specialist/ai-primitive-writer.agent.md
```
