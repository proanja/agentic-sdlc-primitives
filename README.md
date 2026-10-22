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
apm.yml            Root manifest for contributor tooling
```

## Primitives

### Agents

| Agent | Description |
|-------|-------------|
| [AI Primitive Writer](agents/specialist/ai-primitive-writer.agent.md) | Picks the right primitive type for a use case and writes it following the PROSE framework |

### Skills

| Skill | Description |
|-------|-------------|
| [agent-writing](skills/agent-writing/SKILL.md) | Templates and guidelines for `.agent.md` files |
| [skill-authoring](skills/skill-authoring/SKILL.md) | Naming, descriptions, body limits, and references for skills |
| [instruction-writing](skills/instruction-writing/SKILL.md) | Templates and guidelines for `.instructions.md` files |
| [hook-writing](skills/hook-writing/SKILL.md) | Templates and guidelines for hooks |
| [primitive-review](skills/primitive-review/SKILL.md) | PROSE compliance review for any primitive |

## Contributing a primitive

Install the contributor tooling, then ask the **AI Primitive Writer** agent to
help you design and write the new primitive:

```sh
apm install
```

The agent recommends a primitive type, writes it with the matching skill, and
runs `primitive-review` before you open a pull request.

## Using primitives in your project

Reference individual primitives from your project's `apm.yml`:

```yaml
dependencies:
  apm:
    - github.com/proanja/agentic-sdlc-primitives/skills/primitive-review
    - github.com/proanja/agentic-sdlc-primitives/agents/specialist/ai-primitive-writer.agent.md
```
