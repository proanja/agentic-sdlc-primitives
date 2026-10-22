---
name: "hook-writing"
description: "Write hooks for the agentic-sdlc-primitives repository. Activate when creating event-driven automation that triggers on developer events like tool invocations, git commits, or session lifecycle events (preToolUse, postToolUse, agentStop)."
---

# Hook Writing

Use this skill when creating or updating hook configurations and their associated scripts.

## Read First

- Existing hooks in `hooks/*/` and `hooks/README.md`
- Project `README.md` for overall conventions

## When to Use Hooks (Not Another Primitive)

Hooks are the right choice when:

- Automation should trigger **on a specific developer event**
- The action is **deterministic** (check, block, log — not creative work)
- No human judgment is needed — the hook applies automatically

If rules for file types → use an Instruction.
If domain knowledge for a task → use a Skill.
If a persona that users invoke → use an Agent.

## Hook Event Types

| Event | When It Fires | Use Case |
|-------|--------------|----------|
| `preToolUse` | Before a tool executes | Block unsafe commands, validate inputs |
| `postToolUse` | After a tool executes | Validate output, log actions, trigger follow-up |
| `agentStop` | When the agent session ends | Summary review, cleanup, final checks |

## Directory Structure

```
hooks/
├── {hook-name}/
│   ├── {hook-name}.json     — Hook registration (event binding)
│   └── {script-name}.sh     — Execution logic
├── logs/                    — Runtime output (auto-created, gitignored)
└── README.md                — Documentation
```

## Template — Hook Registration (JSON)

```json
{
  "version": 1,
  "hooks": [
    {
      "event": "{preToolUse|postToolUse|agentStop}",
      "script": "hooks/{hook-name}/{script-name}.sh",
      "cwd": ".",
      "description": "{Brief description of what this hook does}"
    }
  ]
}
```

## Template — Hook Script (Bash)

```bash
#!/usr/bin/env bash
set -euo pipefail

# Read tool invocation context from stdin
INPUT=$(cat)

# Extract relevant fields
TOOL_NAME=$(echo "$INPUT" | python3 -c \
  "import sys, json; print(json.load(sys.stdin).get('toolName', ''))" \
  2>/dev/null || echo "")

# --- Hook logic ---

# For preToolUse: exit 0 to allow, non-zero to block
# For postToolUse/agentStop: exit 0 (advisory only)
exit 0
```

## Writing Guidelines

### Hook Registration

- Use `version: 1` for the hooks schema
- One directory per logical hook
- Place the registration JSON and its scripts in the same hook directory
- Set `cwd: "."` to run from repository root
- Include a `description` for documentation

### Hook Scripts

- Use `#!/usr/bin/env bash` shebang
- Set `set -euo pipefail` for safety
- Read input from `stdin` (JSON format)
- Parse JSON with `python3` or `jq`
- Use explicit pattern matching — prefer narrow, exact checks over broad regex
- Exit `0` to allow/pass, non-zero to block (for `preToolUse` hooks)
- Log decisions to `hooks/logs/` for debugging

### Safety Rules

- **preToolUse hooks must be fast** — they block tool execution
- **Prefer exact pattern matching over broad regex** — reduces false positives
- **Log all blocking decisions** — user must understand why an action was blocked
- **Never modify source code from hooks** — hooks observe and gate, they don't create
- **Handle missing tools gracefully** — don't crash if `python3` or `jq` is unavailable

### Anti-Patterns

| Anti-Pattern | Why It's Bad | Instead |
|--------------|-------------|---------|
| Broad regex matching | False positives block legitimate work | Match exact command patterns |
| Silent blocking | User doesn't know why action was blocked | Log reason and display message |
| Complex business logic | Hooks should be simple, fast checks | Move complex logic to a skill or agent |
| Modifying files from hooks | Side effects during tool execution are dangerous | Log findings, suggest changes |

## PROSE Compliance

| Constraint | How It Applies to Hooks |
|------------|------------------------|
| **P** Progressive Disclosure | Hooks load only when their event fires |
| **R** Reduced Scope | Each hook does one check — combine in separate scripts, not mega-hooks |
| **O** Orchestrated Composition | Hooks compose with agents (hooks gate, agents create) |
| **S** Safety Boundaries | Hooks ARE safety boundaries — they enforce guardrails |
| **E** Explicit Hierarchy | Hooks apply at repo level, scoped by event type |

## Done When

- [ ] Hook JSON uses `version: 1` schema
- [ ] Event type matches the intended trigger point
- [ ] Script has `#!/usr/bin/env bash` shebang and `set -euo pipefail`
- [ ] Script reads input from stdin
- [ ] Logic uses narrow, explicit pattern matching
- [ ] Blocking hooks log their reason
- [ ] Script handles missing dependencies gracefully
- [ ] Hook directory created at `hooks/{hook-name}/`
- [ ] Hook JSON registered at `hooks/{hook-name}/{hook-name}.json`
- [ ] Script placed in `hooks/{hook-name}/`
- [ ] `hooks/README.md` updated with hook documentation
