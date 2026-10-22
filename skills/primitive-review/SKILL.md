---
name: "primitive-review"
description: "Review AI primitives (agents, skills, hooks, instructions) for PROSE framework compliance, structural correctness, and quality. Activate after writing any primitive to validate it before merging into the agentic-sdlc-primitives repository."
---

# Primitive Review

Use this skill to review any AI primitive for quality, PROSE compliance, and structural correctness before it is finalized.

## Read First

- The primitive under review
- [PROSE compliance checklist](./references/prose-checklist.md)
- Existing primitives of the same type in the repository for consistency

## Review Workflow

### 1. Structural Review

Verify the primitive has the correct structure for its type:

| Type | Required Structure |
|------|-------------------|
| Agent | YAML frontmatter (`name`, `description`, `tools`) + markdown body with Constraints and Workflow sections |
| Skill | `SKILL.md` with YAML frontmatter (`name`, `description`) in a correctly named directory |
| Instruction | YAML frontmatter (`name`, `description`, `applyTo`) + markdown body under 50 lines of rules |
| Hook | Hook directory with JSON registration file (`version: 1`) + colocated bash script |

### 2. PROSE Compliance Review

Check each PROSE constraint against the [compliance checklist](./references/prose-checklist.md):

- **P — Progressive Disclosure**: Context loads lazily? Links instead of inline content? Skills use three-level loading?
- **R — Reduced Scope**: One concern per primitive? Body sized appropriately for type?
- **O — Orchestrated Composition**: Composes with other primitives? No mega-prompts? No duplication?
- **S — Safety Boundaries**: Tool whitelists (agents)? Constraints section? Approval gates at critical points?
- **E — Explicit Hierarchy**: Inherits global rules? Adds domain-specific refinement without duplicating?

> **Priority rule:** If S1, S2, or S3 fail — flag as blocker immediately regardless of other scores. Safety gaps have the highest blast radius.

### 3. Quality Review

| Check | What to Verify |
|-------|---------------|
| Description quality | Specific, bounded, includes trigger keywords — this is the activation API |
| Constraint completeness | DO NOT / ALWAYS / ONLY boundaries are explicit (agents) |
| Workflow clarity | Numbered steps with clear inputs, outputs, and validation gates |
| Domain knowledge | Named patterns, decision tables — not generic advice |
| Actionable checklist | "Done When" items are testable and specific |
| Consistency | Follows patterns established by existing primitives in this repo |
| No duplication | Content doesn't duplicate what already exists in another primitive |

### 4. Naming and Placement Review

| Type | Expected Path | Naming Convention |
|------|--------------|-------------------|
| Specialist Agent | `agents/specialist/{name}.agent.md` | kebab-case |
| Orchestration Agent | `agents/orchestration/{workflow}/{role}.agent.md` | kebab-case |
| Skill | `skills/{skill-name}/SKILL.md` | kebab-case directory |
| Instruction | `instructions/{domain}/{name}.instructions.md` | kebab-case |
| Hook | `hooks/{name}/{name}.json` + `hooks/{name}/{script-name}.sh` | kebab-case directory |

### 5. APM Compatibility Review

Verify the primitive can be referenced correctly via APM:

```
github.com/proanja/agentic-sdlc-primitives/{path-to-primitive}
```

Check:
- File names are filesystem-safe (no spaces, special characters)
- Directory structure matches APM's discovery rules
- `SKILL.md` is at the root of the skill directory (not nested deeper)
- Agent files end in `.agent.md`
- Instruction files end in `.instructions.md`

## Classify Findings

| Severity | Meaning | Action |
|----------|---------|--------|
| **Blocker** | Primitive won't work correctly or violates safety | Must fix before merging |
| **Major** | Works but likely to cause confusion or rework | Should fix |
| **Minor** | Improvement opportunity | Nice to fix |

## Present Findings

Format each finding as:

```markdown
### Finding {N} [{Severity}] — {Short title}

**Check**: {Which review step caught this}
**Issue**: {1–2 sentences describing the problem and why it matters}
**Suggestion**: {How to fix it}
```

Present findings in batches of 3–5, highest severity first.

## Final Verdict

After all checks, produce a summary:

```markdown
## Review Summary — {Primitive Name}

- **Type**: {Agent / Skill / Instruction / Hook}
- **Findings**: {total} ({blockers} blocker, {majors} major, {minors} minor)
- **PROSE Compliance**: {Pass / Fail (list failing constraints)}
- **Structural Correctness**: {Pass / Fail}
- **Ready to merge**: {Yes / No — with reason if No}
```

## Done When

- [ ] Structural review complete for the primitive type
- [ ] All 5 PROSE constraints checked against the checklist
- [ ] Quality checks passed (description, constraints, workflow, knowledge, duplication)
- [ ] Naming and placement verified against repo conventions
- [ ] APM compatibility confirmed
- [ ] Findings classified by severity
- [ ] Final verdict rendered with clear pass/fail
