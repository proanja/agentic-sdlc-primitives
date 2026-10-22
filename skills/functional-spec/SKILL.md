---
name: functional-spec
description: Clarify incomplete requirements before writing a specification. Use when turning a user story into confirmed business rules, questions, scope, and testable acceptance criteria.
---

# Requirements clarification

A spec is the contract between "what we want" and "what we will test". Keep it short enough to read in ten minutes.

## Procedure

1. Read the story. Separate stated facts from missing decisions.
2. Identify questions about inputs, outputs, failure cases, units, and exact boundaries.
3. Ask the human a short batch of questions and wait. Record unanswered questions explicitly.
4. Write only confirmed behaviour as requirements. Recommendations are not confirmed rules.
5. Add concrete acceptance criteria and check them for ambiguity.

## Rules

- Write in plain language. No class names, frameworks, or file paths.
- Give every requirement an ID: `FR-<spec>.<n>` (e.g. `FR-01.3`). Business rules get `BR-<spec>.<n>`.
- A requirement says **what** the system does, observable from outside: inputs, outputs, states, messages.
- Every requirement is covered by at least one acceptance criterion `AC-<spec>.<n>` written as **Given / When / Then** with concrete values.
- Units, time zones, and limits are explicit: "10 minutes", "°C", "UTC", "max 64 characters".
- For every limit, state what happens **at** the limit (e.g. "more than 10 minutes → offline, so exactly 10 minutes → online").
- Anything not confirmed by the story or the user goes to **Assumptions** or **Open questions** — never silently into a requirement.

## Template

Use [the spec template](./references/spec-template.md). Delete sections that are genuinely empty rather than writing "N/A".

## Self-check before saving

- [ ] Could a tester write tests from section "Acceptance criteria" alone?
- [ ] Is every FR referenced by at least one AC?
- [ ] Are out-of-scope items listed, so nobody builds them "just in case"?
- [ ] Are there vague words left (*fast, recent, appropriate, etc.*)? Replace them with numbers.
