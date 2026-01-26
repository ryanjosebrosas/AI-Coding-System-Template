#!/usr/bin/env bash

# install-quality-hooks.sh - Git Hook Installation Script for Code Quality Gates
#
# Purpose: Installs quality gate hooks to git hooks directory
# - Installs pre-commit hook to validate markdown files before commit
# - Makes hooks executable and ready to use
#
# Usage: ./scripts/install-quality-hooks.sh [--uninstall]
#   --uninstall: Remove installed hooks (optional)
#
# Exit codes:
#   0 - Installation/uninstallation successful
#   1 - Installation/uninstallation failed
#   2 - Usage error

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")"
HOOK_TEMPLATE="$REPO_ROOT/.claude/templates/hooks/pre-commit"
HOOK_NAME="pre-commit"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==========================================
# Utility Functions
# ==========================================

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_section() {
    echo -e "\n${BLUE}▶ $1${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# ==========================================
# Installation Functions
# ==========================================

get_hooks_dir() {
    # Get git hooks directory (handles worktrees correctly)
    local hooks_dir
    hooks_dir="$(git rev-parse --git-path hooks 2>/dev/null || echo '.git/hooks')"

    # Convert to absolute path
    if [[ "$hooks_dir" != /* ]]; then
        hooks_dir="$REPO_ROOT/$hooks_dir"
    fi

    echo "$hooks_dir"
}

check_prerequisites() {
    local errors=0

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        ((errors++))
    fi

    # Check if hook template exists
    if [[ ! -f "$HOOK_TEMPLATE" ]]; then
        print_error "Hook template not found: $HOOK_TEMPLATE"
        ((errors++))
    fi

    # Check if validate-quality.sh exists
    if [[ ! -f "$REPO_ROOT/scripts/validate-quality.sh" ]]; then
        print_warning "Validation script not found: scripts/validate-quality.sh"
        print_warning "Hooks will be installed but may not function correctly"
    fi

    return $errors
}

install_hook() {
    local hooks_dir="$1"
    local hook_path="$hooks_dir/$HOOK_NAME"

    print_section "Installing Quality Gate Hook"

    # Create hooks directory if it doesn't exist
    if [[ ! -d "$hooks_dir" ]]; then
        mkdir -p "$hooks_dir"
        print_success "Created hooks directory: $hooks_dir"
    fi

    # Check if hook already exists
    if [[ -f "$hook_path" ]]; then
        print_warning "Hook already exists: $hook_path"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_warning "Installation cancelled"
            return 1
        fi
        rm -f "$hook_path"
    fi

    # Copy hook template
    if cp "$HOOK_TEMPLATE" "$hook_path"; then
        print_success "Copied hook template to: $hook_path"
    else
        print_error "Failed to copy hook template"
        return 1
    fi

    # Make hook executable
    if chmod +x "$hook_path"; then
        print_success "Made hook executable"
    else
        print_error "Failed to make hook executable"
        return 1
    fi

    # Verify hook is installed and executable
    if [[ -x "$hook_path" ]]; then
        print_success "Hook installed successfully"
        return 0
    else
        print_error "Hook installation verification failed"
        return 1
    fi
}

uninstall_hook() {
    local hooks_dir="$1"
    local hook_path="$hooks_dir/$HOOK_NAME"

    print_section "Uninstalling Quality Gate Hook"

    if [[ ! -f "$hook_path" ]]; then
        print_warning "Hook not found: $hook_path"
        print_warning "Nothing to uninstall"
        return 0
    fi

    # Remove hook
    if rm -f "$hook_path"; then
        print_success "Removed hook: $hook_path"
        return 0
    else
        print_error "Failed to remove hook"
        return 1
    fi
}

display_post_install_info() {
    echo ""
    print_header "Installation Complete"
    echo ""
    echo "Quality gate hook is now active and will run automatically before commits."
    echo ""
    echo "What it does:"
    echo "  • Validates all staged markdown files (.md)"
    echo "  • Checks line count limits (500-600 lines max)"
    echo "  • Verifies required sections are present"
    echo "  • Blocks commits that fail quality checks"
    echo ""
    echo "To bypass quality gates for a single commit:"
    echo -e "  ${YELLOW}git commit --no-verify${NC}"
    echo ""
    echo "To run quality validation manually:"
    echo -e "  ${YELLOW}./scripts/validate-quality.sh [file|directory]${NC}"
    echo ""
    echo "To uninstall hooks:"
    echo -e "  ${YELLOW}./scripts/install-quality-hooks.sh --uninstall${NC}"
    echo ""
}

# ==========================================
# Main Entry Point
# ==========================================

main() {
    local uninstall=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --uninstall)
                uninstall=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [--uninstall]"
                echo ""
                echo "Options:"
                echo "  --uninstall    Remove installed quality gate hooks"
                echo "  -h, --help     Show this help message"
                echo ""
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Usage: $0 [--uninstall]"
                exit 2
                ;;
        esac
    done

    print_header "Code Quality Gates - Hook Installation"

    # Check prerequisites
    print_section "Checking Prerequisites"
    if ! check_prerequisites; then
        print_error "Prerequisites check failed"
        exit 1
    fi
    print_success "Prerequisites OK"

    # Get hooks directory
    local hooks_dir
    hooks_dir="$(get_hooks_dir)"
    print_success "Git hooks directory: $hooks_dir"

    # Install or uninstall
    if [[ "$uninstall" == true ]]; then
        if uninstall_hook "$hooks_dir"; then
            print_success "Uninstallation complete"
            exit 0
        else
            print_error "Uninstallation failed"
            exit 1
        fi
    else
        if install_hook "$hooks_dir"; then
            display_post_install_info
            exit 0
        else
            print_error "Installation failed"
            exit 1
        fi
    fi
}

# Run main function
main "$@"
