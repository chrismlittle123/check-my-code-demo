# check-my-code (cmc)

**One config. One command. Consistent code quality.**

A CLI tool that uses `cmc.toml` as the single source of truth for **all** coding standards across your organization:

| Category | Tools | Status |
|----------|-------|--------|
| **Linting** | ESLint, Ruff | v1 ✓ |
| **AI Prompts** | Claude, Cursor, Copilot | v1 ✓ |
| **MCP Server** | For AI coding agents | v1 ✓ |
| **Formatting** | Prettier, Black | v2 |
| **Type Safety** | TypeScript strict, mypy/pyright | v2 |
| **Custom Hooks** | Your own rules | v2 |

All versioned in a central repository with tier-based enforcement.

## The Problem: Configuration Sprawl

Every repository ends up with its own configs — not just linters, but formatters, type checkers, AI prompts, everything:

```
project-a/
├── .eslintrc.json
├── .prettierrc
├── ruff.toml
├── CLAUDE.md
└── ...

project-b/
├── eslint.config.js      # Different format
├── pyproject.toml        # Ruff + Black buried here
├── .cursorrules          # Different AI prompts
└── ...
```

Over time, configs drift. Teams lose consistency. New projects copy-paste outdated rules. AI assistants get different instructions everywhere.

## The Vision: One Central Repository

Define **everything** in one place:

```
your-org-standards/
├── rulesets/           # Linting rules
├── formatters/         # Formatting configs (v2)
├── type-safety/        # Type checker configs (v2)
├── prompts/            # AI coding standards
├── hooks/              # Custom validation rules (v2)
└── tiers/              # Production vs prototype configs
    ├── production/
    ├── internal-tool/
    └── prototype/
```

Each project just points to what it needs:

```toml
[project]
name = "payment-service"

[extends]
eslint = "github:your-org/standards/tiers/production/rulesets/typescript/5.5/eslint@1.0.0"
ruff = "github:your-org/standards/tiers/production/rulesets/python/3.12/ruff@1.0.0"

[prompts]
templates = ["typescript/5.5", "python/3.12"]
```

**One repo, versioned tiers, organization-wide consistency.**

---

# What Works Today (v1)

## The Solution: cmc.toml

Define your linting standards once:

```toml
[project]
name = "my-project"

[extends]
eslint = "github:chrismlittle123/check-my-code-community/rulesets/typescript/5.5/eslint@1.0.0"
ruff = "github:chrismlittle123/check-my-code-community/rulesets/python/3.12/ruff@1.0.0"

[rulesets.eslint.rules]
"no-var" = "error"
"prefer-const" = "error"
"eqeqeq" = ["error", "always"]

[rulesets.ruff]
line-length = 100

[rulesets.ruff.lint]
select = ["E", "F"]

[prompts]
templates = ["typescript/5.5", "python/3.12"]
```

Then let cmc handle the rest:

```bash
cmc generate eslint    # Creates eslint.config.js
cmc generate ruff      # Creates ruff.toml
cmc check              # Runs both linters
cmc verify             # Ensures configs haven't drifted
cmc context            # Exports AI coding standards
```

## Commands

| Command | What it does |
|---------|--------------|
| `cmc check [path]` | Run ESLint + Ruff, unified output |
| `cmc generate <linter>` | Generate linter config from cmc.toml |
| `cmc verify [linter]` | Verify configs match cmc.toml (CI-friendly) |
| `cmc context --target <tool>` | Export standards to AI coding assistants |

## Example: Finding Violations

```bash
$ cmc check src/

src/utils.py:4 [ruff/F401] `os` imported but unused
src/utils.py:5 [ruff/F401] `sys` imported but unused
src/utils.py:6 [ruff/F401] `json` imported but unused
src/utils.py:9 [ruff/E501] Line too long (133 > 100)
src/utils.py:13 [ruff/F841] Local variable `unused_result` is assigned to but never used
src/example.ts:4 [eslint/no-var] Unexpected var, use let or const instead.
src/example.ts:5 [eslint/no-var] Unexpected var, use let or const instead.
src/example.ts:8 [eslint/prefer-const] 'greeting' is never reassigned. Use 'const' instead.
src/example.ts:11 [eslint/eqeqeq] Expected '===' and instead saw '=='.
src/example.ts:16 [eslint/no-var] Unexpected var, use let or const instead.
src/example.ts:17 [eslint/eqeqeq] Expected '!==' and instead saw '!='.

✗ 11 violations found
```

Both languages. One command. Unified format.

## Example: CI Pipeline Verification

```bash
$ cmc verify

✓ eslint.config.js matches cmc.toml
✓ ruff.toml matches cmc.toml
```

If someone manually edits a config and it drifts from `cmc.toml`, verification fails:

```bash
$ cmc verify

✗ eslint.config.js does not match cmc.toml
  Run 'cmc generate eslint' to fix
```

## Remote Repositories: Community & Private

Pull rulesets and prompts from shared repositories instead of copy-pasting configs:

```toml
[extends]
# Community repo (public) - versioned rulesets for common stacks
eslint = "github:chrismlittle123/check-my-code-community/rulesets/typescript/5.5/eslint@1.0.0"
ruff = "github:chrismlittle123/check-my-code-community/rulesets/python/3.12/ruff@1.0.0"

# Private repo (your org) - uses SSH keys, no tokens needed
eslint = "github:your-org/your-standards/rulesets/typescript/5.5/eslint@1.0.0"
```

### Community Repo Structure

The community repo organizes rulesets and prompts by language and version:

```
check-my-code-community/
├── rulesets/
│   ├── typescript/5.5/eslint/
│   │   └── 1.0.0.toml
│   └── python/3.12/ruff/
│       └── 1.0.0.toml
├── prompts/
│   ├── typescript/5.5/
│   │   └── 1.0.0.md
│   └── python/3.12/
│       └── 1.0.0.md
└── rulesets.json / prompts.json   # Manifests
```

Browse: https://github.com/chrismlittle123/check-my-code-community

### Private Repo for Your Organization

Set up the same structure for company-specific standards:
- Accessed via SSH keys (no tokens needed)
- Keep proprietary rules secure
- Version with semantic versioning

**Additive-only inheritance** — Local rules can only make things *stricter*, never weaker. If the base config says `"no-var" = "error"`, you can't downgrade it to `"warn"`.

## Tier-Based Coding Standards

Different projects need different levels of rigor.

A production API needs strict type safety and zero violations. A hackathon prototype? Just needs to run.

Define tiers in your organization's private repo:

```
your-org-standards/
├── tiers/
│   ├── production/           # Maximum strictness
│   │   ├── rulesets/
│   │   │   ├── typescript/5.5/eslint/1.0.0.toml
│   │   │   └── python/3.12/ruff/1.0.0.toml
│   │   └── prompts/
│   │       └── strict/1.0.0.md
│   │
│   ├── internal-tool/        # Moderate strictness
│   │   └── ...
│   │
│   └── prototype/            # Minimal rules
│       └── ...
```

Then reference the appropriate tier:

```toml
[project]
name = "payment-service"

[extends]
eslint = "github:your-org/standards/tiers/production/rulesets/typescript/5.5/eslint@1.0.0"
ruff = "github:your-org/standards/tiers/production/rulesets/python/3.12/ruff@1.0.0"
```

## AI Integration

Export coding standards to AI assistants so they follow your rules:

```bash
# Claude Code
cmc context --target claude    # Appends to CLAUDE.md

# Cursor
cmc context --target cursor    # Appends to .cursorrules

# GitHub Copilot
cmc context --target copilot   # Appends to .github/copilot-instructions.md
```

Configure which prompts to use:

```toml
[prompts]
templates = ["typescript/5.5", "python/3.12"]
```

## MCP Server

cmc includes an MCP (Model Context Protocol) server that allows AI coding agents to interact with the CLI directly. This makes it easier for Claude Code, Codex, Copilot, and other AI assistants to:

- Run linting checks and get structured results
- Generate and verify configs
- Access your coding standards programmatically

```bash
# Start the MCP server
cmc mcp
```

The MCP server exposes cmc's functionality through a standardized protocol, enabling seamless integration with AI-powered development tools.

---

# What's Coming (v2)

## Formatting

Prettier and ruff, unified under cmc:

```toml
[formatters.prettier]
semi = false
singleQuote = true

[formatters.ruff]
line-length = 100
```

```bash
cmc format              # Run all formatters
cmc generate prettier   # Generate .prettierrc
cmc generate ruff      # Generate ruff.toml
```

## Type Safety

TypeScript and Python type checking:

```toml
[type-safety.typescript]
strict = true
noImplicitAny = true

[type-safety.python]
tool = "mypy"
strict = true
```

```bash
cmc typecheck           # Run type checkers
```

## Custom Hooks

Define your own validation rules:

```toml
[hooks.directory-naming]
pattern = "kebab-case"
paths = ["src/**"]
message = "Directory names must be kebab-case"

[hooks.no-console-in-prod]
pattern = "console\\.(log|debug)"
paths = ["src/**/*.ts"]
exclude = ["src/**/*.test.ts"]
severity = "error"

[hooks.require-license-header]
pattern = "^// Copyright"
paths = ["src/**/*.ts"]
message = "All source files must have a license header"
```

---

## Design Principles

- **Central, versioned repository** — All standards in one place, with semantic versioning
- **Tier-based enforcement** — Different projects, different rules, same infrastructure
- **cmc.toml is authoritative** — It's the source of truth, not the generated configs
- **Graceful degradation** — Works with whatever tools you have installed
- **Delegates to native tools** — cmc doesn't reinvent linting/formatting, it orchestrates
- **AI-agnostic** — Export to any coding assistant

## Quick Start

```bash
# Install
npm install check-my-code

# Generate configs from cmc.toml
cmc generate eslint
cmc generate ruff

# Run linters
cmc check

# Verify configs match (for CI)
cmc verify
```

## Running the Demo

```bash
./demo.sh
```

Press ENTER to advance through each step.

---

Documentation: https://github.com/chrismlittle123/check-my-code
