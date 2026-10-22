---
name: "instruction-writing"
description: "Write high-quality instruction files (.instructions.md) for the agentic-sdlc-primitives repository. Activate when creating scoped, file-pattern-based rules that customize agent behavior for specific file types or directories."
---

# Instruction Writing

Use this skill when creating or updating instruction files (`.instructions.md`).

## Read First

- Existing instructions in `instructions/` for style reference
- Project `README.md` for overall conventions

## When to Use Instructions (Not Another Primitive)

Instructions are the right choice when:

- Rules apply to a **specific set of files** identified by glob pattern
- Content is **short** (<50 lines of rules)
- Rules are **project-specific** conventions, not reusable domain knowledge
- No persona or tool boundaries are needed

If cross-project reusable knowledge → use a Skill.
If requires a role with tool boundaries → use an Agent.
If event-driven → use a Hook.

## Key Distinction: Instructions vs. Skills

| Instructions | Skills |
|-------------|--------|
| Project-specific rules | Reusable domain knowledge |
| Scoped by `applyTo` file pattern | Activated by description match |
| Short (<50 lines) | Can be extensive with references |
| No workflow — just rules | Has workflow and decision framework |
| "Use `snake_case` for variables" | "How to design a REST API" |

> Agents carry the domain knowledge; instructions provide the project-specific values.

## Template — Instruction File

```markdown
---
name: {Instruction Name}
description: "{One-line description of what these rules cover}"
applyTo: "{glob-pattern}"
---

# {Instruction Title}

> **Customisation template.** {Brief note about what agent knowledge this supplements and what to fill in.}

---

## 1. {Rule Category}

- {Rule 1}
- {Rule 2}
- {Rule 3}

---

## 2. {Rule Category}

| {Column1} | {Column2} | {Column3} |
|-----------|-----------|-----------|
| {value}   | {value}   | {value}   |

---

## 3. {Rule Category}

- **{Setting}**: `{placeholder-value}`
```

## YAML Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Human-readable name |
| `description` | Yes | Brief description of what rules are covered |
| `applyTo` | Yes | Glob pattern(s) determining when rules load |

### applyTo Pattern Examples

| Pattern | Matches |
|---------|---------|
| `"**/*.yaml"` | All YAML files in all directories |
| `"openapi/**/*.yaml, openapi/**/*.yml"` | YAML files under openapi/ |
| `"src/api/**"` | All files under src/api/ |
| `"**/*.tsx"` | All TSX files |
| `"Dockerfile, docker-compose*.yml"` | Docker-related files |

**Rule:** If you can't express the scope as one `applyTo` pattern, the instruction is too broad — split it.

## Writing Guidelines

### Length Limit

Hard limit: **50 lines of rules** (excluding frontmatter and section headings). Every line competes for attention with the source code the agent is working on. If you need more, the knowledge belongs in a Skill.

### One Concern Per File

Each instruction file addresses a single concern. If you can't name the file after a single topic, split it.

Good: `openapi.instructions.md` — rules for OpenAPI files
Bad: `api-and-testing.instructions.md` — two concerns mixed

### Customisation Template Pattern

Instructions serve as customisation templates. Use `{placeholder}` syntax for values that vary between projects:

```markdown
- **Application name**: `{app-name}`
- **Base path**: `/api/v1`
- **Default page size**: `{default-page-size}`
```

Include a note at the top explaining the template is meant to be copied and customised.

### Rule Format

- Use imperative mood ("Use", "Apply", "Follow", "Prefer")
- Be specific — mention exact names, values, and patterns
- Use tables for structured rules
- Separate rule categories with `---` horizontal rules and numbered sections
- No generic advice — every rule should be actionable

## File Placement

Instructions follow the pattern: `instructions/{domain}/{name}.instructions.md`

| Domain | When |
|--------|------|
| `openapi` | Rules for OpenAPI specifications |
| `java` | Rules for Java/Spring projects |
| `react` | Rules for React/TypeScript projects |
| `terraform` | Rules for IaC projects |
| `{custom}` | Any other domain — name after the technology or concern |

## PROSE Compliance

| Constraint | How It Applies to Instructions |
|------------|-------------------------------|
| **P** Progressive Disclosure | Loaded only when `applyTo` pattern matches active files |
| **R** Reduced Scope | <50 lines. One concern. One `applyTo` pattern |
| **O** Orchestrated Composition | Supplements agent knowledge, doesn't duplicate it |
| **S** Safety Boundaries | Scoped by file pattern — rules only apply where relevant |
| **E** Explicit Hierarchy | Domain-specific rules that specialize global conventions |

## Done When

- [ ] Has `name`, `description`, and `applyTo` in frontmatter
- [ ] `applyTo` pattern precisely scopes the rules
- [ ] Body is under 50 lines of rules
- [ ] One concern per file
- [ ] Uses `{placeholder}` syntax for project-specific values
- [ ] Rules are actionable and specific (not generic advice)
- [ ] File placed at `instructions/{domain}/{name}.instructions.md`
