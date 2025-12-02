# check-my-code (cmc)

**One config. One command. Consistent code quality.**

A CLI tool that uses `cmc.toml` as the single source of truth for coding standards across your organization — linting, formatting, type safety, custom hooks, and AI coding agent prompts — all versioned in a central repository with tier-based enforcement.

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

## Remote Repositories: Community & Private

Pull rulesets and prompts from shared repositories instead of copy-pasting configs:

```toml
[extends]
# Community repo (public) - versioned rulesets for common stacks
eslint = "github:chrismlittle123/check-my-code-community/rulesets/typescript/5.5/eslint@1.0.0"
ruff = "github:chrismlittle123/check-my-code-community/rulesets/python/3.12/ruff@1.0.0"

# Private repo (your org) - uses SSH keys, no tokens needed
eslint = "github:your-org/your-standards/rulesets/frontend@2.0.0"
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

This is the core problem cmc solves: **different projects need different levels of rigor**.

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

**One repo, versioned tiers, organization-wide consistency.**

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

## Design Principles

- **Central, versioned repository** — All standards in one place, with semantic versioning
- **Tier-based enforcement** — Different projects, different rules, same infrastructure
- **cmc.toml is authoritative** — It's the source of truth, not the generated configs
- **Graceful degradation** — Works with whatever linters you have installed
- **Delegates to native tools** — cmc doesn't reinvent linting/formatting, it orchestrates
- **AI-agnostic** — Export to any coding assistant

## Roadmap

**v1 (Current)** — Unified linting with ESLint and Ruff

**v2 (Coming Soon)** — The full vision:

| Category | What's Included |
|----------|-----------------|
| **Linting** | ESLint, Ruff (current) |
| **Formatting** | Prettier, Black |
| **Type Safety** | TypeScript strict mode, mypy/pyright |
| **Language Versions** | Node.js, Python version enforcement |
| **Custom Hooks** | Your own rules (see below) |
| **AI Prompts** | Coding standards for Claude, Cursor, Copilot |

**Custom Hooks** — Define your own rules in `cmc.toml`:

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

**The goal:** One central repository. Versioned tiers. Everything enforced — linting, formatting, types, conventions, AI behavior — across your entire organization.

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
