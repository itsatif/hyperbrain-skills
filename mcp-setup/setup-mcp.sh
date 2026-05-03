#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up MCP servers for AI-SDLC...${NC}"
echo ""

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Create .env file if it doesn't exist
if [ ! -f ~/.claude/.env ]; then
  echo -e "${GREEN}📝 Creating .env file...${NC}"
  cat > ~/.claude/.env << 'EOF'
# Notion Integration
# Get your token from: https://www.notion.so/my-integrations
NOTION_API_KEY=
NOTION_DATABASE_ID=

# Figma Integration
# Get your token from: https://www.figma.com/settings
FIGMA_ACCESS_TOKEN=
FIGMA_FILE_KEY=

# GitHub Integration
# Get your token from: https://github.com/settings/tokens
GITHUB_TOKEN=
GITHUB_REPOSITORY=

# Slack Integration
# Get your token from: https://api.slack.com/apps
SLACK_BOT_TOKEN=
SLACK_CHANNEL_ID=

# Database Connections
POSTGRES_CONNECTION_STRING=
MONGODB_CONNECTION_STRING=
REDIS_URL=

# Custom MCP Servers
MORPHEUS_ENDPOINT=
DATA_PROXY_ENDPOINT=
EOF
  chmod 600 ~/.claude/.env
  echo -e "${GREEN}✅ Created ~/.claude/.env${NC}"
else
  echo -e "${YELLOW}⚠️  .env file already exists at ~/.claude/.env${NC}"
fi

echo ""
echo -e "${BLUE}🔑 Enter your API tokens (leave blank to skip):${NC}"
echo ""

# Prompt for tokens
read -p "Notion API Key: " notion_key
read -p "Notion Database ID: " notion_db
read -p "Figma Access Token: " figma_token
read -p "Figma File Key: " figma_key
read -p "GitHub Token: " github_token
read -p "GitHub Repository (owner/repo): " github_repo
read -p "Slack Bot Token: " slack_token
read -p "Slack Channel ID: " slack_channel

# Update .env file
if [ -n "$notion_key" ]; then
  sed -i.bak "s/^NOTION_API_KEY=.*/NOTION_API_KEY=$notion_key/" ~/.claude/.env
  echo -e "${GREEN}✅ Notion API Key updated${NC}"
fi

if [ -n "$notion_db" ]; then
  sed -i.bak "s/^NOTION_DATABASE_ID=.*/NOTION_DATABASE_ID=$notion_db/" ~/.claude/.env
  echo -e "${GREEN}✅ Notion Database ID updated${NC}"
fi

if [ -n "$figma_token" ]; then
  sed -i.bak "s/^FIGMA_ACCESS_TOKEN=.*/FIGMA_ACCESS_TOKEN=$figma_token/" ~/.claude/.env
  echo -e "${GREEN}✅ Figma Access Token updated${NC}"
fi

if [ -n "$figma_key" ]; then
  sed -i.bak "s/^FIGMA_FILE_KEY=.*/FIGMA_FILE_KEY=$figma_key/" ~/.claude/.env
  echo -e "${GREEN}✅ Figma File Key updated${NC}"
fi

if [ -n "$github_token" ]; then
  sed -i.bak "s/^GITHUB_TOKEN=.*/GITHUB_TOKEN=$github_token/" ~/.claude/.env
  echo -e "${GREEN}✅ GitHub Token updated${NC}"
fi

if [ -n "$github_repo" ]; then
  sed -i.bak "s/^GITHUB_REPOSITORY=.*/GITHUB_REPOSITORY=$github_repo/" ~/.claude/.env
  echo -e "${GREEN}✅ GitHub Repository updated${NC}"
fi

if [ -n "$slack_token" ]; then
  sed -i.bak "s/^SLACK_BOT_TOKEN=.*/SLACK_BOT_TOKEN=$slack_token/" ~/.claude/.env
  echo -e "${GREEN}✅ Slack Bot Token updated${NC}"
fi

if [ -n "$slack_channel" ]; then
  sed -i.bak "s/^SLACK_CHANNEL_ID=.*/SLACK_CHANNEL_ID=$slack_channel/" ~/.claude/.env
  echo -e "${GREEN}✅ Slack Channel ID updated${NC}"
fi

# Clean up backup file
rm -f ~/.claude/.env.bak

echo ""
echo -e "${BLUE}📦 Installing MCP servers...${NC}"

# Create MCP directory
mkdir -p ~/.claude/mcp
cd ~/.claude/mcp

# Install MCP servers
echo -e "${GREEN}Installing Notion MCP...${NC}"
npm install @modelcontextprotocol/server-notion 2>/dev/null || echo -e "${YELLOW}⚠️  Notion MCP installation failed${NC}"

echo -e "${GREEN}Installing Figma MCP...${NC}"
npm install @modelcontextprotocol/server-figma 2>/dev/null || echo -e "${YELLOW}⚠️  Figma MCP installation failed${NC}"

echo -e "${GREEN}Installing GitHub MCP...${NC}"
npm install @modelcontextprotocol/server-github 2>/dev/null || echo -e "${YELLOW}⚠️  GitHub MCP installation failed${NC}"

echo -e "${GREEN}Installing Slack MCP...${NC}"
npm install @modelcontextprotocol/server-slack 2>/dev/null || echo -e "${YELLOW}⚠️  Slack MCP installation failed${NC}"

echo -e "${GREEN}Installing PostgreSQL MCP...${NC}"
npm install @modelcontextprotocol/server-postgres 2>/dev/null || echo -e "${YELLOW}⚠️  PostgreSQL MCP installation failed${NC}"

echo -e "${GREEN}Installing MongoDB MCP...${NC}"
npm install @modelcontextprotocol/server-mongodb 2>/dev/null || echo -e "${YELLOW}⚠️  MongoDB MCP installation failed${NC}"

echo -e "${GREEN}Installing Redis MCP...${NC}"
npm install @modelcontextprotocol/server-redis 2>/dev/null || echo -e "${YELLOW}⚠️  Redis MCP installation failed${NC}"

echo ""
echo -e "${BLUE}⚙️  Updating Claude settings...${NC}"

# Backup existing settings
if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.backup
  echo -e "${GREEN}✅ Backed up existing settings.json${NC}"
fi

# Create or update settings.json
if [ ! -f ~/.claude/settings.json ]; then
  # Create new settings.json
  cat > ~/.claude/settings.json << 'EOF'
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY:}",
        "NOTION_DATABASE_ID": "${NOTION_DATABASE_ID:}"
      }
    },
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN:}",
        "FIGMA_FILE_KEY": "${FIGMA_FILE_KEY:}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN:}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN:}",
        "SLACK_CHANNEL_ID": "${SLACK_CHANNEL_ID:}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${POSTGRES_CONNECTION_STRING:}"
      }
    },
    "mongodb": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-mongodb"],
      "env": {
        "MONGODB_CONNECTION_STRING": "${MONGODB_CONNECTION_STRING:}"
      }
    },
    "redis": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-redis"],
      "env": {
        "REDIS_URL": "${REDIS_URL:}"
      }
    }
  }
}
EOF
  echo -e "${GREEN}✅ Created ~/.claude/settings.json${NC}"
else
  echo -e "${YELLOW}⚠️  settings.json already exists. Please manually merge MCP configurations.${NC}"
  echo -e "${YELLOW}   Backup saved at ~/.claude/settings.json.backup${NC}"
fi

echo ""
echo -e "${GREEN}✅ MCP setup complete!${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "1. Edit ~/.claude/.env to add more tokens"
echo -e "2. Restart Claude Code to load MCP servers"
echo -e "3. Test connections using the MCP Setup skill"
echo ""
echo -e "${BLUE}🔍 Troubleshooting:${NC}"
echo -e "- Check if MCP servers are installed: cd ~/.claude/mcp && npm list"
echo -e "- Verify environment variables: cat ~/.claude/.env"
echo -e "- Check Claude settings: cat ~/.claude/settings.json | grep -A 10 mcpServers"
echo ""
