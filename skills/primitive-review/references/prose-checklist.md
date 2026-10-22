# PROSE Compliance Checklist

Canonical checklist for validating AI primitives against the five PROSE architectural constraints. Derived from the Agentic SDLC Handbook (Chapter 12) and the PROSE AI-Native Development guide.

## Progressive Disclosure (P)

- [ ] **P1**: Instruction files >100 lines use links (not inline content) for subsidiary topics
- [ ] **P2**: Cross-reference links include a description of target contents
- [ ] **P3**: Skills use the three-level loading pattern (metadata → body → resources)
- [ ] **P4**: Large reference content is in `references/` directories, not inlined in SKILL.md

## Reduced Scope (R)

- [ ] **R1**: The primitive's purpose is statable in one sentence with a single deliverable
- [ ] **R2**: Multi-step workflows start each phase with fresh context
- [ ] **R3**: Instruction files are under 50 lines of rules
- [ ] **R4**: Skill bodies are under 5,000 words

## Orchestrated Composition (O)

- [ ] **O1**: Each primitive addresses exactly one concern
- [ ] **O2**: Workflow prompts reference shared primitives by link, not pasted content
- [ ] **O3**: No duplication of content that exists in another primitive
- [ ] **O4**: Primitives compose — agents reference skills, skills reference examples

## Safety Boundaries (S)

> **Priority rule:** If S1, S2, or S3 fail — fix immediately regardless of total score. Safety gaps have the highest blast radius and are the fastest to close.

- [ ] **S1**: Every agent has an explicit `tools` list (no wildcards)
- [ ] **S2**: Approval gates (`🚨 STOP`) exist before every destructive or irreversible action
- [ ] **S3**: Every agent has explicit scope boundaries (what files/domains it can touch)
- [ ] **S4**: Hook scripts use narrow, explicit pattern matching (not broad regex)

## Explicit Hierarchy (E)

- [ ] **E1**: Primitive adds domain-specific rules without duplicating global rules
- [ ] **E2**: Module-specific rules are addable without editing any file above that scope
- [ ] **E3**: Instructions use `applyTo` patterns to scope precisely
- [ ] **E4**: Agent constraints clearly bound what's in scope vs. out of scope

## Quick Scoring

| Score | Interpretation |
|-------|---------------|
| All pass | Ready to merge |
| Any S1/S2/S3 fail | Blocker — fix before anything else |
| 1–2 other fails | Major findings — should fix |
| Only minor P/E fails | Minor findings — nice to fix |
