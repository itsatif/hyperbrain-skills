# MCP Installer - Quick Reference

**Part of HyperBrain Skills Library**

**Version:** 1.0.0
**Last Updated:** 2026-05-04

---

## 🎯 What is MCP Installer?

One-command installation of all Model Context Protocol (MCP) servers from the HyperBrain repository.

### Key Benefits

✅ **One-Command Setup** - Install all MCPs with single command  
✅ **Automatic Detection** - Discovers all MCP configurations  
✅ **Dependency Resolution** - Installs required packages  
✅ **Validation** - Verifies each MCP after installation  
✅ **Rollback Support** - Easy uninstallation if needed  

---

## 🚀 Quick Start

### Install All MCPs

```bash
# Navigate to HyperBrain skills
cd ~/.claude/skills/hyperbrain-skills

# Install all MCP servers
/mcp-installer install

# With auto-confirmation
/mcp-installer install --yes
```

### Verify Installation

```bash
# Check status
/mcp-installer status

# Test connections
/mcp-installer test

# List installed MCPs
/mcp-installer list
```

---

## 📚 Available MCP Servers

### Always-On (3 servers)

| MCP | Purpose | Type |
|-----|---------|------|
| **Notion** | Documentation | HTTP |
| **GitHub** | Repository operations | HTTP |
| **Slack** | Team communication | HTTP |

### On-Demand (4 servers)

| MCP | Purpose | Trigger |
|-----|---------|---------|
| **Morpheus** | Knowledge graph | "Use Morpheus" |
| **Data Proxy** | Database queries | "Use data-proxy" |
| **Figma Console** | Design integration | "Use Figma" |
| **Sentinel** | Error tracking | "Use Sentinel" |

---

## 💡 Common Workflows

### Install Specific MCPs

```bash
# Install only always-on
/mcp-installer install --type always-on

# Install only on-demand
/mcp-installer install --type on-demand

# Install specific MCPs
/mcp-installer install --include "morpheus,data-proxy"
```

### Check Installation

```bash
# Show status
/mcp-installer status

# Test all MCPs
/mcp-installer test

# Test specific MCP
/mcp-installer test morpheus
```

### Update & Uninstall

```bash
# Update all MCPs
/mcp-installer update

# Uninstall all
/mcp-installer uninstall

# Uninstall specific
/mcp-installer uninstall --include "sentinel"
```

---

## 🔧 Configuration

### CLI Options

```bash
/mcp-installer install [OPTIONS]

Options:
  --type TYPE              [always-on|on-demand|all]
  --include SERVERS        Comma-separated MCPs to include
  --exclude SERVERS        Comma-separated MCPs to exclude
  --claude-settings PATH   Custom settings path
  --yes                    Auto-confirm prompts
  --dry-run                Show without installing
  --verbose                Verbose output
  --force                  Reinstall if exists
```

### Environment Variables

```bash
# Claude settings
export CLAUDE_SETTINGS_PATH="$HOME/.claude/settings.json"

# Python/Node paths
export PYTHON_MCP_EXECUTABLE="python3"
export NODE_MCP_EXECUTABLE="node"

# Install directory
export MCP_INSTALL_DIR="$HOME/.claude/mcp-servers"
```

---

## 🔍 Troubleshooting

### "Claude settings not found"

```bash
# Create default settings
mkdir -p ~/.claude
echo '{}' > ~/.claude/settings.json

# Or specify custom path
/mcp-installer install --claude-settings ~/custom/settings.json
```

### "Node.js not found"

```bash
# Install Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
```

### "Python not found"

```bash
# macOS
brew install python@3.11

# Linux
sudo apt-get install python3.11 python3-pip
```

### "MCP connection failed"

```bash
# Check environment variables
env | grep -E "(NOTION|GITHUB|SLACK|FIGMA|SENTRY)"

# Test specific MCP
/mcp-installer test morpheus --verbose
```

---

## 📊 Installation Status

```bash
/mcp-installer status

# Output:
# 📊 MCP Installation Status
#
# ✅ Notion MCP (always-on)
#    Status: Installed and running
#
# ✅ GitHub MCP (always-on)
#    Status: Installed and running
#
# ✅ Morpheus MCP (on-demand)
#    Status: Installed, ready to activate
#
# ⚠️  Data Proxy MCP (on-demand)
#    Status: Requires VPN
#
# ❌ Figma Console MCP (on-demand)
#    Status: Missing FIGMAPATH_ACCESS_TOKEN
```

---

## 🎯 Quick Reference Commands

```bash
# Installation
/mcp-installer install                              # Install all
/mcp-installer install --type always-on            # Always-on only
/mcp-installer install --include "morpheus"        # Specific MCPs
/mcp-installer install --yes                       # Auto-confirm

# Status & Testing
/mcp-installer status                               # Show status
/mcp-installer list                                 # List MCPs
/mcp-installer test                                 # Test all
/mcp-installer test morpheus                        # Test specific

# Updates
/mcp-installer update                               # Update all
/mcp-installer update --force                       # Force reinstall

# Uninstallation
/mcp-installer uninstall                            # Uninstall all
/mcp-installer uninstall --keep-config              # Keep config

# Utilities
/mcp-installer stats                                # Show statistics
/mcp-installer metrics                              # Connection metrics
/mcp-installer backup                               # Backup config
```

---

## 📚 Environment Setup

After installation, set environment variables:

```bash
# Copy example env
cp .env.example .env

# Add your API keys
nano .env

# Required variables:
# NOTION_API_KEY
# GITHUB_TOKEN
# SLACK_TOKEN
# FIGMAPATH_ACCESS_TOKEN (optional)
# SENTRY_DSN (optional)
```

---

## 🔗 Integration

Works seamlessly with:
- **mcp-on-demand** - On-demand MCP configuration
- **mcp-setup** - Always-on MCP setup
- **graphify-integration** - Knowledge graph queries
- **self-learning** - Track MCP interactions

---

**MCP Installer: One command to install all MCP servers!** 🚀
