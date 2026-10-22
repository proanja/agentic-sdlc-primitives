---
name: "agent-writing"
description: "Write high-quality agent definitions (.agent.md) for the agentic-sdlc-primitives repository. Activate when creating a new specialist or orchestration agent with PROSE-compliant tool boundaries, domain expertise, and structured workflows."
---

# Agent Writing

Use this skill when creating or updating agent definitions (`.agent.md` files).

## Read First

- Existing agents in `agents/specialist/` and `agents/orchestration/` for style reference
- Project `README.md` for overall conventions

## Agent Types

### Specialist Agents

Domain experts for a specific technology stack. Single file at `agents/specialist/{name}.agent.md`.

Examples: `openapi-designer.agent.md`, `ai-primitive-writer.agent.md`

### Orchestration Agents

Multi-step workflows with multiple cooperating agents. Directory at `agents/orchestration/{workflow-name}/` containing one `.agent.md` per role.

Example: `agents/orchestration/spec-driven-dev/` with `spec-writer.agent.md`, `spec-reviewer.agent.md`, `spec-planner.agent.md`, `spec-executor.agent.md`

## Template — Specialist Agent

```markdown
---
name: "{Agent Name}"
description: "{Concise description of domain expertise, stack, and key capabilities}"
tools: [{tool-list}]
model: {model-name} (copilot)
---

# {Agent Name}

{One paragraph: who you are, what you do, what you do NOT do.}

## Core Principles

{3–5 numbered principles that guide all decisions.}

## Constraints

{Explicit boundaries:}
- DO NOT {action outside scope}
- DO NOT {unsafe action}
- ALWAYS {required behavior}
- ONLY {scope limitation}

## Workflow

{Numbered steps from input to output.}

### 1. {Phase Name}

{What to do, what to read, what to ask.}

### 2. {Phase Name}

{Execution steps with clear inputs and outputs.}

## {Domain-Specific Sections}

{Tables, rules, conventions, named patterns specific to the domain.}

## Non-Negotiables

{Hard rules that must never be violated.}

## Skills Reference

- `{skill-name}` — {brief description}
```

## YAML Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Human-readable display name |
| `description` | Yes | Activation contract — what triggers this agent |
| `tools` | Yes | Explicit tool whitelist — never use wildcards |
| `model` | No | Preferred model for this agent |
| `argument-hint` | No | Example argument for invocation |

### Tool Selection Guide

| Tool | When to Include |
|------|----------------|
| `read` | Agent needs to read files |
| `edit` | Agent creates or modifies files |
| `search` | Agent searches the codebase |
| `execute` | Agent runs commands (build, lint, test) |
| `todo` | Agent tracks multi-step work |
| `agent` | Agent delegates to sub-agents |

Only include tools the agent genuinely needs. Fewer tools = smaller blast radius = safer agent.

## Writing Guidelines

### Description — The API

The `description` frontmatter is how the harness decides when to activate this agent. Write it to be:

- **Specific** — mention the domain, technology stack, and key capabilities
- **Bounded** — state what the agent does, implying what it does NOT do
- **Trigger-aware** — include keywords that match common user queries

Bad: `"Helps with code"`
Good: `"API contract specialist: OpenAPI 3.1 YAML, RESTful design, contract-first delivery, schema design, RFC 9457 error conventions"`

### Constraints Section

Every agent MUST have explicit constraints implementing PROSE Safety Boundaries (S):

- What the agent will NOT do (scope boundaries)
- What files/domains it will NOT touch
- What approval it needs before acting
- What primitive types it ONLY produces

### Workflow Section

Structure as numbered phases. Each phase should:

- State what happens and why
- List inputs needed
- Define the output or deliverable
- Include `🚨 STOP` validation gates at critical decision points

### Domain Knowledge

Encode expertise as:

- **Named patterns** — reference specific patterns by name, not generic advice
- **Decision tables** — structured rules with clear conditions and actions
- **Anti-patterns** — each represents a mistake that happened at least once
- **Concrete examples** — showing good and bad approaches

### Length and Structure

- Aim for 80–200 lines of body content
- Use tables for structured rules
- Use code blocks for templates and examples
- One heading level per concern
- Short paragraphs and tight bullet lists

## PROSE Compliance

| Constraint | How It Applies to Agents |
|------------|-------------------------|
| **P** Progressive Disclosure | Reference skills by name instead of inlining their content |
| **R** Reduced Scope | One domain per agent — if doing two things, split into two agents |
| **O** Orchestrated Composition | Agent references skills; doesn't duplicate their content |
| **S** Safety Boundaries | Explicit `tools` list, constraints section, `🚨 STOP` approval gates |
| **E** Explicit Hierarchy | Agent inherits project-level rules; adds domain-specific ones |

## Done When

- [ ] Frontmatter has `name`, `description`, and `tools`
- [ ] Description is specific enough to activate on the right tasks
- [ ] Tool list is minimal — only tools the agent genuinely needs
- [ ] Constraints section explicitly bounds scope with DO NOT / ALWAYS / ONLY
- [ ] Workflow section has numbered phases with validation gates
- [ ] Domain knowledge uses named patterns, not generic advice
- [ ] No inlined content that belongs in a skill — reference it instead
- [ ] File placed at correct path in repo
