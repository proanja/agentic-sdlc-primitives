---
name: skill-authoring
description: Use when writing, editing, reviewing or naming a SKILL.md or an agent skill, choosing a skill's name or description, deciding what belongs in references/ rather than the body, or asking why a skill never loads. Carries the authoring rules — the noun-or-verb naming split, descriptions that state what and when, the 500-line body limit and gotchas. Not for READMEs, docstrings or other code documentation.
---

# Authoring skills

## Start from real expertise

The most common way to produce a useless skill is to ask a model to write one from
general knowledge. What comes back is "handle errors appropriately" and "follow
best practices" — advice the agent already had.

Ground it in something real instead:

- **Extract from a task you just did.** Note the corrections you made, the
  conventions you had to supply, the sequence that worked. Those corrections are
  the skill.
- **Synthesize from project artifacts.** Runbooks, incident write-ups, code review
  comments, and the diffs of past fixes. Project-specific material beats a generic
  article on the same topic every time.

If the agent already does the task well without the skill, do not write the skill.

## A skill, or another primitive

A skill fits when the knowledge applies across files or projects, takes more than
a few rules, and has a trigger the model can detect. Otherwise:

| Need | Primitive |
| --- | --- |
| Rules scoped to one file pattern, under 50 lines | Instruction with `applyTo` |
| A persona with its own tool list and workflow | Agent |
| A reaction to an event — save, commit, session end | Hook |

In this repository a skill lives at `skills/<name>/SKILL.md`, with
`references/`, `scripts/` and `assets/` beside it as it needs them.

## The frontmatter contract

```yaml
---
name: <64 chars max, lowercase letters, numbers and hyphens only>
description: <non-empty, 1024 chars max>
---
```

`name` may not contain `anthropic` or `claude`, and must match its directory. No
angle brackets in either field — they are read as XML.

## Name: a noun for knowledge, a verb for a workflow

The name has two readers: a person typing it after `/`, and the model seeing it
beside the description. Neither is helped by a long name.

- **Knowledge or convention skill** — the model loads it when the topic comes
  up and it has no side effects: a short **noun** for the thing it knows.
  `terraform`, `pipelines`, `azure-infrastructure`, `accessibility`.
- **Workflow skill** — a procedure with a start and an end, usually invoked on
  purpose: an **imperative verb**, plus an object only when the verb alone is
  ambiguous. `handoff`, `estimate`, `write-adr`, `review-pipeline`. Set
  `disable-model-invocation: true` when it has side effects or the user should
  decide when it runs (Claude Code honours the field; other CLIs ignore it).

Public collections use three forms — gerund (`writing-plans`, Anthropic's
recommendation), imperative (`deploy-to-vercel`), noun (`react-best-practices`).
This library uses the two above and never the gerund: nobody types
`/writing-plans`.

| Avoid | Because | Instead |
|---|---|---|
| `documentation-and-adrs` | `and` means two triggers | `adr`, `project-docs` |
| `session-handoff` | the qualifier adds nothing | `handoff` |
| `terraform-style-guide` | every skill is a guide | `terraform` |
| `processing-pdfs` | gerund; nobody types it | `pdf` |
| `azure-helper` | says nothing | name the task |

A company prefix only where the content is inherently ours — `prodyna-brand`,
`prodyna-writing`. Domain skills stay generic; a collision with a public skill
of the same name is resolved by the description and the collection, not by
the name.

## The description decides everything

Only names and descriptions are preloaded; the body loads after the skill is
already chosen. A skill with a vague description is dead regardless of content.

Write it in the third person — it is injected into the system prompt, and "I can
help you…" reads as the assistant speaking. State both halves:

```yaml
description: Extracts text and tables from PDF files, fills forms, merges documents.
  Use when working with PDF files or when the user mentions PDFs, forms, or
  document extraction.
```

What it does, then when to use it, naming the words someone would actually type.
`Helps with documents` triggers on nothing.

Add what it is *not* for when a neighbouring skill could catch the same prompt —
`Not for Bicep; see azure-infrastructure` — because two descriptions sharing
their keywords leave the model guessing between them.

Tune it against real prompts: write about twenty a colleague would type, a third
of them near-misses that must *not* trigger, run each three times and adjust.
Five rounds is usually enough, and the description alone often moves trigger
accuracy more than any change to the body.

## Scope it like a function

A skill should cover one coherent unit of work. Too narrow and several must load
for one task, competing and conflicting. Too broad and it never activates
precisely — querying a database and formatting results is one skill; adding
database administration is two.

Split by **trigger**, not by topic. If two bodies of guidance fire on the same
prompts, they belong together with one in `references/`. The reverse holds too:
one body that answers two different prompt families is two skills, whatever the
topic — an `and` in the name is the usual sign.

## Spend context deliberately

Once the skill activates, the whole body competes with conversation history.
Apply one test to every paragraph:

> Would the agent get this wrong without this instruction?

If no, cut it. Do not explain what a PDF is, how HTTP works, or what a migration
does. Exhaustive skills perform worse than concise ones — the agent pursues
instructions that do not apply to the task at hand.

Keep the body under 500 lines and roughly 5,000 tokens.

## Progressive disclosure

Move detail into `references/`, and say **when** to load each file:

```markdown
Read `references/api-errors.md` when the API returns a non-200 status.
```

Not `see references/ for details` — the agent cannot tell whether that is worth a
read. Keep references one level deep from `SKILL.md`; a reference that links on to
a third file gets read partially or not at all. Give any reference over 100 lines a
table of contents, because partial reads still show it.

References cost nothing until read. A skill's description costs context on every
single turn. When in doubt, make it a reference rather than a second skill.

## Gotchas earn their place

The highest-value section in most skills is the one listing facts that defy
reasonable assumptions:

```markdown
## Gotchas

- The `users` table uses soft deletes. Queries need `WHERE deleted_at IS NULL`
  or deactivated accounts come back.
- The `/health` endpoint returns 200 whenever the web server is up, even with the
  database down. Use `/ready`.
```

Keep these in `SKILL.md`, not a reference — the agent must read them *before*
hitting the situation, and it will not recognise the trigger in advance. Every time
you correct an agent, that correction belongs here.

The section only grows. Prune an entry when the trap is verifiably gone, not
when it looks dated — the agent that would fall into it cannot tell you it did.

## Calibrate control to fragility

Give freedom where several approaches work, and explain *why* rather than
prescribing — an agent that understands the purpose decides better in context.
Be prescriptive where the operation is fragile or the sequence matters: "Run
exactly this command. Do not add flags."

Most skills need both. Calibrate per section.

**Give a default, not a menu.** "Use pdfplumber; for scanned PDFs use pdf2image
with pytesseract" beats listing four libraries as equals.

**Teach an approach, not an answer.** "Read the schema, join on the `_id`
convention, apply the user's filters" generalises; the specific query for one
report does not.

For output templates, checklists, validation loops and bundled scripts, read
`references/patterns.md` when a skill needs structured output or a multi-step
workflow.

## Procedure over prose

A workflow written as steps lifts a model's results roughly twice as much as
the same knowledge written as best-practice prose, and the gap is widest on
smaller models. So:

- A **workflow skill** carries a checklist the agent copies into its reply and
  a validator it runs at the end — a script, a linter, a build.
- A **convention skill** names the tool that enforces the convention —
  `tofu fmt`, `tflint`, `actionlint` — and says when to run it. A rule with no
  enforcing command is advice the agent will weigh against everything else.

What must be identical across runs and users goes into a script, not a
sentence.

## Runs on every OS

A skill is installed on whatever machine its user has. Bundled scripts and the
commands in the body work on Windows, macOS and Linux — or the skill says which
platform it assumes.

**One implementation, not per-OS twins.** Python 3 with the standard library is
the portable default for a bundled script; a `.sh` beside a `.ps1` doubles the
maintenance and the two drift apart. Inside the script, use `pathlib` rather than
string paths, `tempfile` rather than a hard-coded `/tmp`, and do the work in
Python instead of shelling out to `grep`, `sed`, `find` or `cp` — those are
missing or behave differently on Windows, and `sed -i` alone differs between
macOS and Linux.

**In the body, describe the operation where the command is not the point.**
"Search the repo for the old name" lets the agent reach for its own tools;
`grep -r` fails on a machine that has no grep. Where the sequence is fragile,
give the literal command as always — and keep it portable, or name the platform
it needs.

The usual traps: `python3` is `python` on Windows, `~` and `$HOME` are
`%USERPROFILE%`, `./venv/bin/` is `venv\Scripts\`, `chmod +x` means nothing
there, and `$(…)`, `&&` and single quotes are not PowerShell syntax.

A skill that genuinely wraps a platform-bound tool belongs to that platform: say
so in the description, so it is not chosen on a machine that cannot run it.

## Iterate against real runs

The first draft needs refinement. Run it on real tasks and read the **execution
traces**, not just the final answers. Wasted steps have specific causes:

| Symptom | Usual cause |
|---|---|
| Agent tries several approaches first | Instructions too vague |
| Agent follows irrelevant guidance | Instructions that do not apply to this task |
| Agent hesitates between options | A menu with no default |

One execute-then-revise pass measurably helps; complex skills want several.

## A skill that is never chosen

Weak models rarely choose skills on their own, and rewording the description
does not fix that. Do not write a skill for a weak model and expect it to be
found. Either the work runs on a model that chooses skills, or the skill is
invoked by name — from the user, from a role's agent instructions, or with
`disable-model-invocation: true`, which makes that explicit. Descriptions still
earn their keep on the models that do choose.

## Before you ship

- [ ] Name is a noun for a knowledge skill, an imperative verb for a workflow
      skill — no `and`, no gerund — and matches the directory
- [ ] It covers one subject, not one audience
- [ ] Description says what it does, when to use it and what it is not for, in
      the third person
- [ ] A workflow skill has a checklist and a validator; a convention skill names
      the tool that enforces it
- [ ] Body under 500 lines, every paragraph passes the "would the agent get this
      wrong" test
- [ ] References are one level deep and each has a stated load condition
- [ ] Gotchas are in `SKILL.md`
- [ ] Scripts and commands run on Windows, macOS and Linux, or the skill names
      the platform it assumes

The `primitive-review` skill checks the PROSE constraints; run it before
opening a pull request.
