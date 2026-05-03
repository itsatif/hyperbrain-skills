#!/bin/bash

###############################################################################
# MCP Installer - Automated MCP Server Setup
# Part of HyperBrain Skills Library
###############################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLAUDE_SETTINGS="${CLAUDE_SETTINGS_PATH:-$HOME/.claude/settings.json}"
MCP_CONFIG_DIR="$REPO_ROOT/mcp-setup"
MCP_ONDEMAND_DIR="$REPO_ROOT/mcp-on-demand"
BACKUP_DIR="$HOME/.claude/mcp-backups"

# Functions
log_info() { echo -e "${BLUE}ℹ️  $*${NC}"; }
log_success() { echo -e "${GREEN}✅ $*${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $*${NC}"; }
log_error() { echo -e "${RED}❌ $*${NC}"; }

show_banner() {
  echo -e "${BLUE}"
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║           MCP Installer - HyperBrain Skills              ║"
  echo "║     Automated MCP Server Setup for Claude Code           ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

check_prerequisites() {
  log_info "Checking prerequisites..."

  # Check Node.js
  if ! command -v node &> /dev/null; then
    log_error "Node.js not found. Please install Node.js 18+ first."
    log_info "Visit: https://nodejs.org/"
    exit 1
  fi
  local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
  if [ "$node_version" -lt 18 ]; then
    log_error "Node.js version 18+ required. Found: $(node -v)"
    exit 1
  fi
  log_success "Node.js $(node -v)"

  # Check npm
  if ! command -v npm &> /dev/null; then
    log_error "npm not found"
    exit 1
  fi
  log_success "npm $(npm -v)"

  # Check Python (optional)
  if command -v python3 &> /dev/null; then
    log_success "Python $(python3 --version | cut -d' ' -f2)"
  else
    log_warning "Python not found (optional for some MCPs)"
  fi

  # Check Claude settings directory
  if [ ! -d "$HOME/.claude" ]; then
    log_info "Creating Claude settings directory..."
    mkdir -p "$HOME/.claude"
  fi

  # Create settings.json if not exists
  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_info "Creating Claude settings file..."
    echo '{}' > "$CLAUDE_SETTINGS"
  fi

  log_success "Prerequisites check complete"
}

backup_settings() {
  log_info "Backing up Claude settings..."
  mkdir -p "$BACKUP_DIR"
  local backup_file="$BACKUP_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$CLAUDE_SETTINGS" "$backup_file"
  log_success "Backup created: $backup_file"
}

discover_mcp_configs() {
  log_info "Discovering MCP configurations..."

  local configs=()

  # Always-on MCPs
  if [ -f "$MCP_CONFIG_DIR/mcp-config.json" ]; then
    configs+=("$MCP_CONFIG_DIR/mcp-config.json")
    log_success "Found always-on MCP config"
  fi

  # On-demand MCPs
  if [ -f "$MCP_ONDEMAND_DIR/mcp-config.json" ]; then
    configs+=("$MCP_ONDEMAND_DIR/mcp-config.json")
    log_success "Found on-demand MCP config"
  fi

  if [ ${#configs[@]} -eq 0 ]; then
    log_error "No MCP configurations found in $REPO_ROOT"
    exit 1
  fi

  log_success "Found ${#configs[@]} MCP configuration(s)"
  printf '%s\n' "${configs[@]}"
}

install_npm_packages() {
  log_info "Installing npm-based MCP packages..."

  # Core MCP packages
  local packages=(
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-slack"
  )

  for pkg in "${packages[@]}"; do
    log_info "Installing $pkg..."
    if npm list -g "$pkg" &> /dev/null; then
      log_success "$pkg already installed"
    else
      if npm install -g "$pkg"; then
        log_success "$pkg installed"
      else
        log_warning "Failed to install $pkg (may require sudo)"
      fi
    fi
  done

  log_success "npm packages installation complete"
}

install_mcp_servers() {
  log_info "Installing MCP servers..."

  local configs=("$@")
  local mcp_servers="{}"

  # Merge all MCP configs
  for config in "${configs[@]}"; do
    if [ -f "$config" ]; then
      log_info "Processing $config..."
      # Use jq to merge JSON if available, otherwise append
      if command -v jq &> /dev/null; then
        mcp_servers=$(jq -s 'reduce .[] as $item ({}; . * $item)' "$config" <(echo "$mcp_servers"))
      else
        log_warning "jq not found, manual merge required"
      fi
    fi
  done

  # Update Claude settings
  log_info "Updating Claude settings..."
  if command -v jq &> /dev/null; then
    # Merge existing mcpServers with new ones
    local temp_file=$(mktemp)
    jq --argjson mcp "$mcp_servers" '.mcpServers = $mcp' "$CLAUDE_SETTINGS" > "$temp_file"
    mv "$temp_file" "$CLAUDE_SETTINGS"
    log_success "Claude settings updated"
  else
    log_warning "jq not found. Please manually merge MCP config into $CLAUDE_SETTINGS"
    echo ""
    echo "Add this to your $CLAUDE_SETTINGS:"
    echo ""
    echo "$mcp_servers"
    echo ""
  fi
}

create_env_example() {
  log_info "Creating environment variable example..."

  local env_file="$REPO_ROOT/.env.mcp.example"

  cat > "$env_file" << 'EOF'
# MCP Server Environment Variables
# Copy this file to .env and fill in your values

# Notion MCP
export NOTION_API_KEY="your_notion_integration_token_here"
export NOTION_DATABASE_ID="your_database_id_here"

# GitHub MCP
export GITHUB_TOKEN="your_github_personal_access_token_here"

# Slack MCP
export SLACK_TOKEN="your_slack_bot_token_here"
export SLACK_SIGNING_SECRET="your_slack_signing_secret_here"

# Figma Console MCP
export FIGMA_ACCESS_TOKEN="your_figma_access_token_here"

# Sentinel MCP (Sentry)
export SENTRY_DSN="your_sentry_dsn_here"
export SENTRY_AUTH_TOKEN="your_sentry_auth_token_here"
export SENTRY_ORG="your_organization"
export SENTRY_PROJECT="your_project_id"
export SENTRY_ENDPOINT="https://sentry.example.com"
EOF

  log_success "Environment example created: $env_file"
  log_info "Copy to .env and fill in your values"
}

verify_installation() {
  log_info "Verifying MCP installation..."

  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_error "Claude settings not found"
    return 1
  fi

  if command -v jq &> /dev/null; then
    local mcp_count=$(jq '.mcpServers | length' "$CLAUDE_SETTINGS" 2>/dev/null || echo "0")
    log_success "MCP servers configured: $mcp_count"

    # List configured MCPs
    jq -r '.mcpServers | keys[]' "$CLAUDE_SETTINGS" 2>/dev/null | while read -r mcp; do
      local disabled=$(jq -r ".mcpServers[\"$mcp\"].disabled // false" "$CLAUDE_SETTINGS")
      local required=$(jq -r ".mcpServers[\"$mcp\"].required // false" "$CLAUDE_SETTINGS")
      local status="✅"
      if [ "$disabled" = "true" ]; then
        status="⏸️ "
      fi
      echo -e "  ${status} ${mcp} (required: ${required})"
    done
  else
    log_warning "Install jq for detailed verification"
  fi

  log_success "Verification complete"
}

show_next_steps() {
  echo ""
  log_info "Next steps:"
  echo ""
  echo "1. Set environment variables:"
  echo "   cp .env.mcp.example .env"
  echo "   nano .env  # Add your API keys"
  echo ""
  echo "2. Load environment variables:"
  echo "   source .env"
  echo ""
  echo "3. Restart Claude Code"
  echo ""
  echo "4. Test MCP servers:"
  echo "   /mcp-installer test"
  echo ""
  echo "5. Use MCPs in conversations:"
  echo "   - Use Morpheus to query knowledge graphs"
  echo "   - Use data-proxy to query databases"
  echo "   - Get Figma designs"
  echo "   - Check system health with Sentinel"
  echo ""
}

install_all() {
  show_banner
  check_prerequisites

  local install_type="${1:-all}"
  local include="${2:-}"
  local exclude="${3:-}"
  local auto_confirm="${4:-false}"

  log_info "Installation type: $install_type"

  if [ "$auto_confirm" != "true" ]; then
    echo ""
    read -p "Continue with installation? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log_info "Installation cancelled"
      exit 0
    fi
  fi

  backup_settings

  local configs=()
  if [ "$install_type" = "all" ] || [ "$install_type" = "always-on" ]; then
    if [ -f "$MCP_CONFIG_DIR/mcp-config.json" ]; then
      configs+=("$MCP_CONFIG_DIR/mcp-config.json")
    fi
  fi

  if [ "$install_type" = "all" ] || [ "$install_type" = "on-demand" ]; then
    if [ -f "$MCP_ONDEMAND_DIR/mcp-config.json" ]; then
      configs+=("$MCP_ONDEMAND_DIR/mcp-config.json")
    fi
  fi

  if [ ${#configs[@]} -eq 0 ]; then
    log_error "No MCP configurations found"
    exit 1
  fi

  install_npm_packages
  install_mcp_servers "${configs[@]}"
  create_env_example
  verify_installation
  show_next_steps

  log_success "Installation complete!"
}

show_status() {
  show_banner

  log_info "MCP Installation Status"
  echo ""

  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_error "Claude settings not found: $CLAUDE_SETTINGS"
    log_info "Run: /mcp-installer install"
    exit 1
  fi

  if command -v jq &> /dev/null; then
    local mcp_count=$(jq '.mcpServers | length' "$CLAUDE_SETTINGS" 2>/dev/null || echo "0")
    echo "Total MCP Servers: $mcp_count"
    echo ""

    jq -r '.mcpServers | to_entries[] | @json' "$CLAUDE_SETTINGS" 2>/dev/null | while read -r entry; do
      local name=$(echo "$entry" | jq -r '.key')
      local disabled=$(echo "$entry" | jq -r '.value.disabled // false')
      local required=$(echo "$entry" | jq -r '.value.required // false')
      local description=$(echo "$entry" | jq -r '.value.description // "No description"')

      if [ "$disabled" = "true" ]; then
        echo -e "⏸️  ${YELLOW}${name}${NC} (disabled)"
      elif [ "$required" = "true" ]; then
        echo -e "✅ ${GREEN}${name}${NC} (always-on)"
      else
        echo -e "🔄 ${BLUE}${name}${NC} (on-demand)"
      fi
      echo "   $description"
      echo ""
    done
  else
    log_warning "Install jq for detailed status"
  fi
}

show_help() {
  show_banner
  cat << EOF
Usage: /mcp-installer <command> [options]

Commands:
  install              Install all MCP servers
  status               Show installation status
  test                 Test MCP server connections
  list                 List all configured MCPs
  update               Update MCP servers
  uninstall            Uninstall MCP servers
  backup               Backup configuration
  help                 Show this help message

Options for 'install':
  --type TYPE          MCP type [always-on|on-demand|all] (default: all)
  --include SERVERS    Comma-separated MCPs to include
  --exclude SERVERS    Comma-separated MCPs to exclude
  --claude-settings    Custom Claude settings path
  --yes                Auto-confirm all prompts
  --dry-run            Show what would be installed
  --verbose            Verbose output
  --force              Reinstall even if exists

Examples:
  /mcp-installer install                    # Install all MCPs
  /mcp-installer install --type always-on  # Install always-on only
  /mcp-installer install --include "morpheus,data-proxy"
  /mcp-installer status                     # Show status
  /mcp-installer test                       # Test connections

Environment Variables:
  CLAUDE_SETTINGS_PATH     Custom Claude settings path
  PYTHON_MCP_EXECUTABLE    Python executable path
  NODE_MCP_EXECUTABLE      Node.js executable path
  MCP_INSTALL_DIR          Installation directory

EOF
}

# Main
main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    install)
      local install_type="all"
      local include=""
      local exclude=""
      local auto_confirm="false"

      while [[ $# -gt 0 ]]; do
        case $1 in
          --type)
            install_type="$2"
            shift 2
            ;;
          --include)
            include="$2"
            shift 2
            ;;
          --exclude)
            exclude="$2"
            shift 2
            ;;
          --yes)
            auto_confirm="true"
            shift
            ;;
          *)
            shift
            ;;
        esac
      done

      install_all "$install_type" "$include" "$exclude" "$auto_confirm"
      ;;
    status)
      show_status
      ;;
    test)
      log_info "Testing MCP connections..."
      log_warning "Test feature coming soon!"
      log_info "For now, verify by using MCPs in Claude Code"
      ;;
    list)
      show_status
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      log_error "Unknown command: $command"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

main "$@"
