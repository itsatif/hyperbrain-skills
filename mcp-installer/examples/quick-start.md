# Example: MCP Installer Quick Start

**Use Case:** One-command installation of all MCP servers from HyperBrain repository

---

## 🎯 Objective

Install all Model Context Protocol (MCP) servers with a single command, eliminating manual configuration.

---

## 📋 Prerequisites

- HyperBrain skills repository cloned
- Node.js 18+ installed
- Claude Code installed
- Bash shell (macOS, Linux, or WSL on Windows)

---

## 🚀 Step-by-Step Workflow

### Step 1: Navigate to HyperBrain Skills

```bash
cd ~/.claude/skills/hyperbrain-skills
```

### Step 2: Run Installer

```bash
# Install all MCP servers
./mcp-installer/bin/install-mcps.sh install
```

**Expected Output:**
```
╔════════════════════════════════════════════════════════════╗
║           MCP Installer - HyperBrain Skills              ║
║     Automated MCP Server Setup for Claude Code           ║
╚════════════════════════════════════════════════════════════╝

ℹ️  Checking prerequisites...
✅ Node.js v18.17.0
✅ npm 9.6.7
✅ Python 3.11.4
✅ Prerequisites check complete

ℹ️  Backing up Claude settings...
✅ Backup created: ~/.claude/mcp-backups/settings.json.backup.20260504_100000

ℹ️  Discovering MCP configurations...
✅ Found always-on MCP config
✅ Found on-demand MCP config
✅ Found 2 MCP configuration(s)

ℹ️  Installing npm-based MCP packages...
ℹ️  Installing @modelcontextprotocol/server-notion...
✅ @modelcontextprotocol/server-notion already installed
ℹ️  Installing @modelcontextprotocol/server-github...
✅ @modelcontextprotocol/server-github installed
ℹ️  Installing @modelcontextprotocol/server-slack...
✅ @modelcontextprotocol/server-slack installed
✅ npm packages installation complete

ℹ️  Installing MCP servers...
ℹ️  Processing mcp-setup/mcp-config.json...
ℹ️  Processing mcp-on-demand/mcp-config.json...
✅ Claude settings updated

ℹ️  Creating environment variable example...
✅ Environment example created: .env.mcp.example

ℹ️  Verifying MCP installation...
✅ MCP servers configured: 7
  ✅ notion (required: true)
  ✅ github (required: true)
  ✅ slack (required: true)
  🔄 morpheus (required: false)
  🔄 data-proxy (required: false)
  🔄 figma-console (required: false)
  🔄 sentinel (required: false)
✅ Verification complete

ℹ️  Next steps:

1. Set environment variables:
   cp .env.mcp.example .env
   nano .env  # Add your API keys

2. Load environment variables:
   source .env

3. Restart Claude Code

4. Test MCP servers:
   /mcp-installer test

5. Use MCPs in conversations:
   - Use Morpheus to query knowledge graphs
   - Use data-proxy to query databases
   - Get Figma designs
   - Check system health with Sentinel

✅ Installation complete!
```

### Step 3: Set Environment Variables

```bash
# Copy example environment file
cp .env.mcp.example .env

# Edit with your API keys
nano .env
```

**Add your credentials:**
```bash
# Required for always-on MCPs
export NOTION_API_KEY="your_notion_token_here"
export GITHUB_TOKEN="your_github_token_here"
export SLACK_TOKEN="your_slack_token_here"
export SLACK_SIGNING_SECRET="your_slack_secret_here"

# Optional for on-demand MCPs
export FIGMA_ACCESS_TOKEN="your_figma_token_here"
export SENTRY_DSN="your_sentry_dsn_here"
export SENTRY_AUTH_TOKEN="your_sentry_auth_token_here"
```

```bash
# Load environment variables
source .env

# Optional: Add to shell profile for persistence
echo 'source ~/.claude/skills/hyperbrain-skills/.env' >> ~/.zshrc
```

### Step 4: Verify Installation

```bash
# Check installation status
./mcp-installer/bin/install-mcps.sh status
```

**Output:**
```
╔════════════════════════════════════════════════════════════╗
║           MCP Installer - HyperBrain Skills              ║
║     Automated MCP Server Setup for Claude Code           ║
╚════════════════════════════════════════════════════════════╝

ℹ️  MCP Installation Status

Total MCP Servers: 7

✅ notion (always-on)
   Notion documentation integration

✅ github (always-on)
   GitHub repository operations

✅ slack (always-on)
   Slack team communication

🔄 morpheus (on-demand)
   Knowledge graph and codebase search

🔄 data-proxy (on-demand)
   Database queries (PostgreSQL, InfluxDB, Redis)

🔄 figma-console (on-demand)
   Figma design integration

🔄 sentinel (on-demand)
   Error tracking and monitoring
```

### Step 5: Restart Claude Code

```bash
# Quit Claude Code completely
# Then restart it
```

### Step 6: Test MCPs in Claude Code

Now you can use MCPs in your conversations:

```bash
# Test Notion MCP
"Use Notion to list all databases in my workspace"

# Test GitHub MCP
"Use GitHub to list all repositories in the hyperbrain-skills organization"

# Test Morpheus MCP (on-demand)
"Use Morpheus to query the backend knowledge graph for jt-api-v2"

# Test Data Proxy MCP (on-demand)
"Use data-proxy to get all devices for site iah-del"

# Test Figma Console MCP (on-demand)
"Use Figma to get the dashboard design file"

# Test Sentinel MCP (on-demand)
"Use Sentinel to check system health"
```

---

## 💡 Advanced Usage

### Install Specific MCP Types

```bash
# Install only always-on MCPs
./mcp-installer/bin/install-mcps.sh install --type always-on

# Install only on-demand MCPs
./mcp-installer/bin/install-mcps.sh install --type on-demand
```

### Install Specific MCPs

```bash
# Install only Morpheus and Data Proxy
./mcp-installer/bin/install-mcps.sh install --include "morpheus,data-proxy"
```

### Auto-Confirm Installation

```bash
# Skip confirmation prompts
./mcp-installer/bin/install-mcps.sh install --yes
```

### Custom Claude Settings Path

```bash
# Install to custom location
./mcp-installer/bin/install-mcps.sh install --claude-settings ~/custom/settings.json
```

---

## 🔍 Troubleshooting

### Issue: "Node.js not found"

```bash
# Install Node.js using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc  # or source ~/.zshrc
nvm install 18
nvm use 18

# Verify installation
node --version
npm --version
```

### Issue: "Permission denied"

```bash
# Make script executable
chmod +x ./mcp-installer/bin/install-mcps.sh

# Or run with bash
bash ./mcp-installer/bin/install-mcps.sh install
```

### Issue: "jq not found"

```bash
# macOS
brew install jq

# Linux (Ubuntu/Debian)
sudo apt-get install jq

# Verify
jq --version
```

### Issue: "MCP connection failed"

```bash
# Check environment variables
env | grep -E "(NOTION|GITHUB|SLACK|FIGMA|SENTRY)"

# Verify API tokens are correct
# Ensure tokens have required permissions

# Test specific MCP
./mcp-installer/bin/install-mcps.sh test
```

---

## 📊 After Installation

### Claude Settings Structure

Your `~/.claude/settings.json` will contain:

```json
{
  "mcpServers": {
    "notion": {
      "url": "https://notion-mcp.example.com/sse",
      "type": "http",
      "disabled": false,
      "required": true,
      "autoApprove": [
        "mcp__notion__*"
      ]
    },
    "github": {
      "url": "https://github-mcp.example.com/sse",
      "type": "http",
      "disabled": false,
      "required": true,
      "autoApprove": [
        "mcp__github__*"
      ]
    },
    "slack": {
      "url": "https://slack-mcp.example.com/sse",
      "type": "http",
      "disabled": false,
      "required": true,
      "autoApprove": [
        "mcp__slack__*"
      ]
    },
    "morpheus": {
      "url": "https://cody.smartjoules.org/sse",
      "type": "http",
      "disabled": false,
      "required": false,
      "autoApprove": [
        "mcp__morpheus__*"
      ]
    },
    "data-proxy": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "http://10.40.21.254:8100/sse",
        "--allow-http"
      ],
      "disabled": false,
      "required": false,
      "autoApprove": [
        "execute_postgresql_query",
        "execute_influxdb_query",
        "execute_redis_command"
      ]
    },
    "figma-console": {
      "command": "npx",
      "args": [
        "figma-console-mcp"
      ],
      "disabled": false,
      "required": false,
      "env": {
        "FIGMAPATH_ACCESS_TOKEN": "${FIGMAPATH_ACCESS_TOKEN}"
      }
    },
    "sentinel": {
      "command": "node",
      "args": [
        "/Users/atif-salafi/Desktop/workspace/mcp-servers/sentry-server.js"
      ],
      "disabled": false,
      "required": false,
      "env": {
        "SENTRY_DSN": "${SENTRY_DSN}",
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}"
      }
    }
  }
}
```

---

## 🎯 Usage Examples

### Example 1: Query Knowledge Graph with Morpheus

```bash
# In Claude Code conversation:
"Use Morpheus to query the backend knowledge graph.
Show me all REST endpoints in jt-api-v2 service."

# Morpheus activates and provides:
# - List of all endpoints
# - File locations
# - Call graphs
# - Dependencies
```

### Example 2: Query Database with Data Proxy

```bash
# In Claude Code conversation:
"Use data-proxy to execute this PostgreSQL query:
SELECT * FROM devices WHERE site_id = 'iah-del' LIMIT 10"

# Data Proxy activates and provides:
# - Query results
# - Execution time
# - Row count
```

### Example 3: Get Figma Design

```bash
# In Claude Code conversation:
"Use Figma to get the dashboard page design.
Show me the primary button component specifications."

# Figma Console activates and provides:
# - Design file link
# - Component specs
# - CSS/styling details
```

---

## 🔄 Updating MCPs

```bash
# Update all MCP servers
./mcp-installer/bin/install-mcps.sh update

# Force reinstall
./mcp-installer/bin/install-mcps.sh update --force
```

---

## 🗑️ Uninstalling MCPs

```bash
# Uninstall all MCP servers
./mcp-installer/bin/install-mcps.sh uninstall

# Uninstall but keep configuration
./mcp-installer/bin/install-mcps.sh uninstall --keep-config
```

---

## 📚 Best Practices

### 1. Environment Variable Management

```bash
# Use .env file for sensitive data
# Never commit .env to version control

echo ".env" >> .gitignore
```

### 2. Regular Backups

```bash
# Backup before updates
./mcp-installer/bin/install-mcps.sh backup
```

### 3. Testing After Installation

```bash
# Always test after installation
./mcp-installer/bin/install-mcps.sh test
```

### 4. Monitor MCP Usage

```bash
# Check which MCPs are being used
# Review Claude Code logs
# Adjust autoApprove lists as needed
```

---

## ✅ Summary

After running the MCP installer:

✅ **7 MCP servers installed** (3 always-on, 4 on-demand)  
✅ **Configuration updated** in `~/.claude/settings.json`  
✅ **Environment template** created in `.env.mcp.example`  
✅ **Backup created** in `~/.claude/mcp-backups/`  
✅ **Ready to use** after restarting Claude Code  

---

**MCP Installer: One command to install all MCP servers!** 🚀
