#!/bin/bash

########################
# check-my-code Demo
# Using demo-magic
########################

# Include demo-magic
. ./demo-magic.sh

# Configure demo-magic
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=15

# Clear the screen
clear

# Title
echo ""
echo "======================================"
echo "   check-my-code (cmc) CLI Demo"
echo "======================================"
echo ""
wait

# Show version
p "# First, let's check the version of cmc"
pe "npx cmc --version"
wait

# Show help
p "# Let's see all available commands"
pe "npx cmc --help"
wait

# Show the cmc.toml configuration
echo ""
p "# cmc uses a central cmc.toml for all linting configuration"
pe "cat cmc.toml"
wait

# Explain remote inheritance
echo ""
p "# Notice the [extends] section - we can inherit from remote repos!"
p "# "
p "# Community repo (public):  github:chrismlittle123/check-my-code-community/..."
p "# Private repo (company):   github:chrismlittle123/check-my-code-private/..."
p "# "
p "# cmc pulls these configs using your SSH keys - no tokens needed"
wait

# Show sample files with violations
echo ""
p "# Let's look at our TypeScript file with violations"
pe "cat src/example.ts"
wait

echo ""
p "# And our Python file with violations"
pe "cat src/utils.py"
wait

# Generate command - create linter configs
echo ""
p "# The 'generate' command creates linter configs from cmc.toml"
p "# It merges local rules with inherited remote rules"
pe "npx cmc generate --help"
wait

echo ""
p "# Generate ESLint config (merges community + private + local rules)"
pe "npx cmc generate eslint --force"
wait

echo ""
p "# Generate Ruff config"
pe "npx cmc generate ruff --force"
wait

# Check command - find violations
echo ""
p "# Now let's run 'cmc check' to find all violations"
pe "npx cmc check src/"
wait

echo ""
p "# cmc found 11 violations across both languages!"
p "# - 6 ESLint violations in TypeScript (no-var, prefer-const, eqeqeq)"
p "# - 5 Ruff violations in Python (unused imports, line length, unused variable)"
wait

# JSON output for CI
echo ""
p "# For CI pipelines, use --json for machine-readable output"
pe "npx cmc check src/ --json"
wait

# Verify command
echo ""
p "# The 'verify' command ensures configs match cmc.toml"
p "# Use this in CI to catch config drift"
pe "npx cmc verify"
wait

# Context command
echo ""
p "# The 'context' command exports coding standards to AI tools"
pe "npx cmc context --help"
wait

echo ""
p "# AI prompts can also be pulled from community/private repos!"
p "# This ensures your AI assistants follow the same standards"
wait

echo ""
p "# Preview context for Claude Code"
pe "npx cmc context --target claude --stdout"
wait

# Wrap up
echo ""
echo "======================================"
echo "   Demo Complete!"
echo "======================================"
echo ""
p "# Summary:"
echo "  - cmc check    : Run ESLint + Ruff with unified output"
echo "  - cmc generate : Create linter configs from cmc.toml"
echo "  - cmc verify   : Ensure configs match cmc.toml"
echo "  - cmc context  : Export standards to AI tools"
echo ""
p "# Remote inheritance:"
echo "  - Community: github:chrismlittle123/check-my-code-community/..."
echo "  - Private:   github:chrismlittle123/check-my-code-private/..."
echo ""
p "# Install with: npm install check-my-code"
echo ""
echo "Documentation: https://github.com/chrismlittle123/check-my-code"
echo ""
