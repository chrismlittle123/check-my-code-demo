#!/bin/bash

########################
# check-my-code Demo
# Using demo-magic
########################

# Include demo-magic
. ./demo-magic.sh

# Vibrant colors (using bright/bold variants)
BOLD_GREEN="\033[1;32m"
BOLD_CYAN="\033[1;36m"
BOLD_YELLOW="\033[1;33m"
BOLD_MAGENTA="\033[1;35m"
BOLD_BLUE="\033[1;34m"
BOLD_RED="\033[1;31m"
BOLD_WHITE="\033[1;37m"
DIM="\033[2m"

# Configure demo-magic - faster typing and vibrant prompt
DEMO_PROMPT="${BOLD_MAGENTA}❯ ${BOLD_CYAN}\W ${COLOR_RESET}"
DEMO_CMD_COLOR=$BOLD_WHITE
DEMO_COMMENT_COLOR=$BOLD_YELLOW
TYPE_SPEED=40

# Clear the screen
clear

# Title with style
echo ""
echo -e "${BOLD_MAGENTA}╔══════════════════════════════════════════╗${COLOR_RESET}"
echo -e "${BOLD_MAGENTA}║${BOLD_WHITE}     ⚡ check-my-code (cmc) CLI Demo ⚡     ${BOLD_MAGENTA}║${COLOR_RESET}"
echo -e "${BOLD_MAGENTA}╚══════════════════════════════════════════╝${COLOR_RESET}"
echo ""
echo -e "${DIM}One config. One command. Consistent code quality.${COLOR_RESET}"
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
echo -e "${BOLD_BLUE}━━━ Configuration ━━━${COLOR_RESET}"
p "# cmc uses a central cmc.toml for all linting configuration"
pe "cat cmc.toml"
wait

# Explain remote inheritance
echo ""
echo -e "${BOLD_GREEN}━━━ Remote Inheritance ━━━${COLOR_RESET}"
p "# Notice the [extends] section - inherit from remote repos!"
p "# "
p "# 🌐 Community (public):  github:chrismlittle123/check-my-code-community/..."
p "# 🔒 Private (company):   github:chrismlittle123/check-my-code-private/..."
p "# "
p "# cmc pulls configs using your SSH keys - no tokens needed"
wait

# Show sample files with violations
echo ""
echo -e "${BOLD_YELLOW}━━━ Sample Code with Violations ━━━${COLOR_RESET}"
p "# Let's look at our TypeScript file with violations"
pe "cat src/example.ts"
wait

echo ""
p "# And our Python file with violations"
pe "cat src/utils.py"
wait

# Generate command - create linter configs
echo ""
echo -e "${BOLD_CYAN}━━━ Generate Linter Configs ━━━${COLOR_RESET}"
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
echo -e "${BOLD_RED}━━━ Find Violations ━━━${COLOR_RESET}"
p "# Now let's run 'cmc check' to find all violations"
pe "npx cmc check src/"
wait

echo ""
p "# 🔍 cmc found 11 violations across both languages!"
p "# → 6 ESLint violations in TypeScript (no-var, prefer-const, eqeqeq)"
p "# → 5 Ruff violations in Python (unused imports, line length, unused var)"
wait

# JSON output for CI
echo ""
echo -e "${BOLD_BLUE}━━━ CI/CD Integration ━━━${COLOR_RESET}"
p "# For CI pipelines, use --json for machine-readable output"
pe "npx cmc check src/ --json"
wait

# Audit command
echo ""
echo -e "${BOLD_GREEN}━━━ Config Verification ━━━${COLOR_RESET}"
p "# The 'audit' command ensures configs match cmc.toml"
p "# Use this in CI to catch config drift"
pe "npx cmc audit"
wait

# Context command
echo ""
echo -e "${BOLD_MAGENTA}━━━ AI Integration ━━━${COLOR_RESET}"
p "# The 'context' command exports coding standards to AI tools"
pe "npx cmc context --help"
wait

echo ""
p "# 🤖 AI prompts can also be pulled from community/private repos!"
p "# This ensures your AI assistants follow the same standards"
wait

echo ""
p "# Preview context for Claude Code"
pe "npx cmc context --target claude --stdout"
wait

# Wrap up
echo ""
echo -e "${BOLD_MAGENTA}╔══════════════════════════════════════════╗${COLOR_RESET}"
echo -e "${BOLD_MAGENTA}║${BOLD_WHITE}            ✅ Demo Complete!              ${BOLD_MAGENTA}║${COLOR_RESET}"
echo -e "${BOLD_MAGENTA}╚══════════════════════════════════════════╝${COLOR_RESET}"
echo ""
echo -e "${BOLD_CYAN}Commands:${COLOR_RESET}"
echo -e "  ${BOLD_WHITE}cmc check${COLOR_RESET}    → Run ESLint + Ruff with unified output"
echo -e "  ${BOLD_WHITE}cmc generate${COLOR_RESET} → Create linter configs from cmc.toml"
echo -e "  ${BOLD_WHITE}cmc audit${COLOR_RESET}   → Ensure configs match cmc.toml"
echo -e "  ${BOLD_WHITE}cmc context${COLOR_RESET}  → Export standards to AI tools"
echo ""
echo -e "${BOLD_GREEN}Remote Inheritance:${COLOR_RESET}"
echo -e "  🌐 Community: ${DIM}github:chrismlittle123/check-my-code-community/...${COLOR_RESET}"
echo -e "  🔒 Private:   ${DIM}github:chrismlittle123/check-my-code-private/...${COLOR_RESET}"
echo ""
echo -e "${BOLD_YELLOW}Install:${COLOR_RESET} npm install check-my-code"
echo ""
echo -e "${DIM}Documentation: https://github.com/chrismlittle123/check-my-code${COLOR_RESET}"
echo ""
