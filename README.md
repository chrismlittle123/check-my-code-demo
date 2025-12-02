# check-my-code (cmc)

**One config. One command. Consistent code quality.**

A CLI tool that uses `cmc.toml` as the single source of truth for linting rules across TypeScript/JavaScript (ESLint) and Python (Ruff) projects.

## The Problem: Configuration Sprawl

Every repository ends up with its own linter configs:

```
project-a/
├── .eslintrc.json
├── ruff.toml
└── ...

project-b/
├── eslint.config.js      # Different format
├── pyproject.toml        # Ruff rules buried here
└── ...

project-c/
├── .eslintrc.yaml        # Yet another format
├── ruff.toml             # Slightly different rules
└── ...
```

Over time, configs drift. Teams lose consistency. New projects copy-paste outdated rules.

## The Solution: cmc.toml

Define your standards once:

```toml
[project]
name = "my-project"

[rulesets.eslint.rules]
"no-var" = "error"
"prefer-const" = "error"
"eqeqeq" = ["error", "always"]

[rulesets.ruff]
line-length = 100

[rulesets.ruff.lint]
select = ["E", "F"]
```

Then let cmc handle the rest:

```bash
cmc generate eslint    # Creates eslint.config.js
cmc generate ruff      # Creates ruff.toml
cmc check              # Runs both linters
cmc verify             # Ensures configs haven't drifted
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
src/utils.py:9 [ruff/E501] Line too long (133 > 100)
src/example.ts:4 [eslint/no-var] Unexpected var, use let or const instead.
src/example.ts:8 [eslint/prefer-const] 'greeting' is never reassigned. Use 'const' instead.
src/example.ts:11 [eslint/eqeqeq] Expected '===' and instead saw '=='.

✗ 6 violations found
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

## Example: Inherit from Remote Repositories

Don't reinvent the wheel. Pull in rulesets and prompts from shared repos:

```toml
[project]
name = "my-project"

[extends]
# Community standards (public)
eslint = "github:chrismlittle123/check-my-code-community/rulesets/typescript/eslint-default@1.0.0"
ruff = "github:chrismlittle123/check-my-code-community/rulesets/python/ruff-default@latest"

# Company standards (private repo - uses your SSH keys)
eslint = "github:chrismlittle123/check-my-code-private/rulesets/acme-corp@v2.0.0"

[ai-context]
# Pull prompts from community
prompts = [
  "github:chrismlittle123/check-my-code-community/prompts/typescript/strict@latest",
  "github:chrismlittle123/check-my-code-community/prompts/python/prod@1.0.0"
]
```

**Community repo** — Open source templates anyone can use:
- `typescript/strict@latest` — Strict TypeScript standards
- `python/prod@1.0.0` — Production Python best practices
- Browse: https://github.com/chrismlittle123/check-my-code-community

**Private repo** — Your organization's internal standards:
- Company-specific rules and prompts
- Accessed via SSH keys (no tokens needed)
- Keep proprietary standards secure

**Additive-only inheritance** — You can only make rules *stricter*, never weaker. If the base config says `"no-var" = "error"`, you can't downgrade it to `"warn"`.

## Example: AI Integration

Export your coding standards to AI assistants so they follow your rules:

```bash
# Claude Code
cmc context --target claude    # Appends to CLAUDE.md

# Cursor
cmc context --target cursor    # Appends to .cursorrules

# GitHub Copilot
cmc context --target copilot   # Appends to .github/copilot-instructions.md
```

## Design Principles

- **cmc.toml is authoritative** — It's the source of truth, not the generated configs
- **Graceful degradation** — Works with whatever linters you have installed
- **Delegates to native linters** — cmc doesn't reinvent linting, it orchestrates
- **AI-agnostic** — Export to any coding assistant

## Roadmap

**v1 (Current)** — Unified linting with ESLint and Ruff

**v2 (Coming Soon)** — Expanding beyond linting:
- **Formatting** — Prettier, Black, integrated into `cmc check`
- **Type Safety** — TypeScript strict mode, mypy/pyright for Python
- **Custom Hooks** — Define your own rules in `cmc.toml`:

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
```

The goal: one tool to enforce *all* your codebase standards.

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
