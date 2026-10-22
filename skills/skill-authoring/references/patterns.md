# Instruction patterns

## Contents

- Output templates — when the format matters
- Checklists — for multi-step workflows with dependencies
- Validation loops — make the agent check its own work
- Plan-validate-execute — for batch and destructive operations
- Bundled scripts — when the agent keeps reinventing the same logic

Use the ones that fit. A skill needing none of them is not deficient.

## Output templates

Agents pattern-match against concrete structures far better than against prose
descriptions of a format. Give the shape, not a description of the shape.

Short templates belong inline. Long ones, or ones needed only in some branches,
go in `assets/` so they load on demand.

State how strictly to follow it. "Use this exact structure" and "here is a
sensible default, adapt it to the analysis" produce very different behaviour, and
the difference is not inferable from the template itself.

## Checklists

Worth it when steps have dependencies or validation gates, because the agent can
track progress and skip nothing:

```markdown
Progress:
- [ ] Step 1: Analyze the form (run `scripts/analyze_form.py`)
- [ ] Step 2: Create the field mapping (edit `fields.json`)
- [ ] Step 3: Validate the mapping (run `scripts/validate_fields.py`)
- [ ] Step 4: Fill the form (run `scripts/fill_form.py`)
```

Not worth it for three independent steps.

## Validation loops

Do the work, run a validator, fix, repeat until it passes. This lifts output
quality more than any amount of extra prose.

```markdown
1. Make your edits
2. Run `python scripts/validate.py output/`
3. If it fails: read the error, fix, run it again
4. Only proceed once validation passes
```

The validator does not have to be a script. A reference document works — instruct
the agent to check its work against it before finalising.

## Plan-validate-execute

For batch or destructive work, have the agent write an intermediate plan in a
structured format, validate that plan against a source of truth, and only then
execute. Errors surface before anything is changed, and the plan can be revised
without touching the original.

```markdown
1. Extract the fields: `analyze_form.py input.pdf` → `form_fields.json`
2. Write `field_values.json`, mapping each field to its value
3. Validate: `validate_fields.py form_fields.json field_values.json`
4. If it fails, revise `field_values.json` and validate again
5. Fill: `fill_form.py input.pdf field_values.json output.pdf`
```

Step 3 is the whole point. Make its errors specific enough to self-correct from:

```text
Field 'signature_date' not found — available: customer_name, order_total,
signature_date_signed
```

## Bundled scripts

Compare execution traces across runs. If the agent reinvents the same logic every
time — parsing one format, building the same chart, checking the same invariant —
write it once, test it, and bundle it under `scripts/`.

A bundled script is more reliable than generated code, costs no context (only its
output is read), and produces the same result every run.

Say which mode you mean, because the difference is not obvious from the filename:

- **Execute:** "Run `analyze_form.py` to extract the fields"
- **Read:** "See `analyze_form.py` for the extraction algorithm"

Execution is right for most utility scripts.

Handle errors inside the script rather than deferring to the agent. A script that
creates a missing file, or falls back to a documented default, beats one that
throws and leaves the agent guessing. Justify constants in a comment — if you do
not know why the timeout is 30 seconds, neither will the agent.
