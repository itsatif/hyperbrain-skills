# Graphify Integration - Quick Reference

**Part of HyperBrain Skills Library**

**Version:** 1.0.0  
**Last Updated:** 2026-05-04

---

## 🎯 What is Graphify?

Graphify transforms codebases into **queryable knowledge graphs** with **71.5x token efficiency** using AST-based extraction and semantic analysis.

### Key Benefits

✅ **Complete Context** - Entire codebase in single query (vs. reading 100s of files)  
✅ **Semantic Understanding** - Relationships and dependencies, not just text  
✅ **Multi-Modal** - Code, docs, PDFs, images, video/audio transcriptions  
✅ **Interactive** - HTML visualization, JSON export, Markdown reports  
✅ **MCP Ready** - Expose as queryable server for live analysis

---

## 🚀 Quick Start

### Installation

```bash
# Recommended: Using uv (fastest)
pip install uv
uv pip install graphifyy

# Alternative: Using pipx
pipx install graphifyy

# Alternative: Using pip
pip install graphifyy

# Verify installation
graphify --version
```

### Basic Usage

```bash
# Analyze current directory
graphify

# Analyze specific directory
graphify /path/to/codebase

# Custom output location
graphify --output-dir ./knowledge-graphs/my-service

# Include/exclude patterns
graphify --include "**/*.ts" --exclude "**/*.spec.ts"
```

---

## 💡 HyperBrain Integration Examples

### 1. Backend Knowledge Base (jt-api-v2)

```bash
cd ~/workspace/jt-api-v2
graphify \
  --include "**/*.ts" \
  --exclude "**/*.spec.ts" \
  --output-dir ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted
```

**Result:** All 50+ endpoints, service dependencies, middleware stack, database relationships

### 2. IoT Knowledge Base

```bash
cd ~/workspace/iot-application
graphify \
  --include "**/*.ts" \
  --output-dir ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph
```

**Result:** MQTT topic subscriptions, Kafka consumer groups, InfluxDB schema, telemetry flow

### 3. Angular Components

```bash
cd ~/workspace/jouletrack-angular
graphify \
  --include "**/*.component.ts" \
  --include "**/*.service.ts" \
  --output-dir ~/.claude/skills/hyperbrain-skills/jouletrack-angular/knowledge/components
```

**Result:** Component hierarchy, service dependencies, RxJS chains, routing structure

---

## 🔍 Query Examples

### Code Navigation

```bash
# Find all REST endpoints
graphify query "List all @Controller or @RestController endpoints"

# Find database operations
graphify query "Show all database queries and their tables"

# Find async operations
graphify query "List all async functions and their awaited operations"
```

### Architecture Analysis

```bash
# Identify service boundaries
graphify query "What are the distinct service modules?"

# Find shared utilities
graphify query "Which utilities are used across multiple services?"

# Trace data flow
graphify path "DeviceController.create" to "InfluxDBService.write"
```

### Impact Analysis

```bash
# What depends on this function?
graphify query "What depends on UserService.authenticate?"

# Find circular dependencies
graphify query "Find circular dependencies in services"

# Identify unused code
graphify query "Find unused or unreachable functions"
```

---

## 📊 Output Formats

### 1. Interactive HTML (graph.html)

```bash
graphify --output-dir ./knowledge
open ./knowledge/graph.html
```

- Visual exploration with search/filter
- Drill-down into function/class details
- Call graph visualization
- Community detection highlights

### 2. JSON Export (graph.json)

```bash
# Use with MCP server
graphify --mcp --port 8080

# Query programmatically
cat ./knowledge/graph.json | jq '.nodes[] | select(.type == "function")'
```

- Machine-readable structure
- MCP server integration ready
- Custom query capability

### 3. Markdown Report (GRAPH_REPORT.md)

```bash
cat ./knowledge/GRAPH_REPORT.md
```

- Human-readable summary
- Architecture overview
- Key metrics and recommendations

---

## 🎓 Common Workflows

### Onboarding New Team Members

```bash
# Create comprehensive knowledge base
cd ~/workspace/jouletrack-angular
graphify --output-dir ./knowledge/onboarding

# Generate documentation
cat ./knowledge/onboarding/GRAPH_REPORT.md > docs/ARCHITECTURE.md

# Explore interactively
open ./knowledge/onboarding/graph.html

# Query specific workflows
graphify query "How does device registration work?"
graphify query "Show authentication flow"
```

### Architecture Review

```bash
# Extract knowledge graph
cd ~/workspace/jt-api-v2
graphify --output-dir ./knowledge

# Query architectural patterns
graphify query "What are the main service layers?"
graphify query "How are services organized by domain?"

# Identify coupling
graphify query "Which services have high dependencies?"

# Generate report
graphify explain "Service architecture and recommendations"
```

### Continuous Documentation

```bash
# Install git hook (auto-updates on commit)
graphify hook install

# Now every commit updates knowledge graph automatically
git add .
git commit -m "Add new feature"
# Knowledge graph stays in sync with code!
```

---

## 📈 Token Efficiency

### Problem: Large Codebases Exceed Context

- **jt-api-v2**: ~150,000 tokens (raw files)
- **iot-application**: ~120,000 tokens
- **jouletrack-angular**: ~200,000 tokens
- **Total**: 470,000 tokens (exceeds 200K context!)

### Solution: Knowledge Graph Compression

- **jt-api-v2**: ~2,100 tokens (71.5x reduction)
- **iot-application**: ~1,700 tokens (70.6x reduction)
- **jouletrack-angular**: ~2,800 tokens (71.4x reduction)
- **Total**: 6,600 tokens (fits with room to spare!)

### Benefits

✅ **Complete Context** - Entire codebase in single query  
✅ **Fast Analysis** - No need to read multiple files  
✅ **Accurate Responses** - Grounded in extracted structure

---

## 🔧 Configuration

### CLI Options

```bash
graphify [OPTIONS] [PATH]

Options:
  --output-dir PATH       Output directory [default: ./graph-output]
  --include PATTERN       Glob pattern for files to include
  --exclude PATTERN       Glob pattern for files to exclude
  --watch                 Watch mode - auto-update on changes
  --verbose               Verbose output
  --mcp                   Start MCP server for querying
  --mcp-port PORT         MCP server port [default: 8080]
  --help                  Show help message
  --version               Show version
```

### Environment Variables

```bash
# Claude API key for semantic extraction
export ANTHROPIC_API_KEY="your-api-key-here"

# Parallel processing workers
export GRAPHIIFY_WORKERS=4

# Max file size (MB)
export GRAPHIIFY_MAX_FILE_SIZE=10

# Enable/disable semantic extraction
export GRAPHIIFY_SEMANTIC_EXTRACTION=true
```

---

## 🎯 Supported File Types

### Code (25+ Languages)

- **Web**: .ts .js .jsx .tsx .mjs .vue .svelte
- **Backend**: .py .go .java .c .cpp .rb .cs .kt .scala .php
- **Systems**: .rs .swift .lua .zig .ps1
- **Data**: .sql
- **Mobile**: .ex .exs (Elixir)
- **Scientific**: .j .jl .m .mm (Julia, Objective-C)

### Documentation

- Markdown: .md .mdx
- Web: .html .htm
- Text: .txt .rst
- Config: .yaml .yml

### Research

- Papers: .pdf
- Images: .png .jpg .jpeg .webp .gif

### Media

- Video: .mp4 .mov .mkv .webm .avi .m4v
- Audio: .mp3 .wav .m4a .ogg (auto-transcribed with faster-whisper)

---

## 🔍 Troubleshooting

### "tree-sitter not found"

```bash
# macOS
brew install tree-sitter

# Linux
sudo apt-get install tree-sitter libyaml-dev

# Windows (WSL)
sudo apt-get install tree-sitter
```

### "ffmpeg not found" (for video processing)

```bash
# macOS
brew install ffmpeg

# Linux
sudo apt-get install ffmpeg
```

### "Out of memory during extraction"

```bash
# Reduce file size or workers
export GRAPHIIFY_MAX_FILE_SIZE=5
export GRAPHIIFY_WORKERS=2
```

### "Claude API rate limit"

```bash
# Disable semantic extraction for code-only
export GRAPHIIFY_SEMANTIC_EXTRACTION=false
```

---

## 🚀 Best Practices

### 1. Start Small

```bash
# Test on single directory first
graphify src/services --output-dir ./test-graph

# Verify quality
cat ./test-graph/GRAPH_REPORT.md

# Then scale to full codebase
graphify --output-dir ./knowledge
```

### 2. Use Exclude Patterns

```bash
# Exclude generated code and tests
graphify \
  --exclude "**/*.spec.ts" \
  --exclude "**/node_modules/**" \
  --exclude "**/dist/**" \
  --exclude "**/*.generated.ts"
```

### 3. Combine with HyperBrain Skills

```bash
# Step 1: Extract graph
graphify --output-dir ./knowledge

# Step 2: Use with expert-personas
# "Act as Google L7 Backend Engineer and review architecture in ./knowledge/GRAPH_REPORT.md"

# Step 3: Use with tdd-workflow
# "Based on dependency graph in ./knowledge/graph.json, write tests for critical paths"
```

### 4. Regular Updates

```bash
# Schedule weekly updates
crontab -e
# Add: 0 0 * * 0 cd ~/workspace/jt-api-v2 && graphify --output-dir ./knowledge
```

---

## 📚 Quick Reference Commands

```bash
# Basic usage
graphify                                          # Current directory
graphify /path/to/codebase                        # Specific path
graphify --output-dir ./knowledge                  # Custom output

# Filtering
graphify --include "**/*.ts"                       # TypeScript only
graphify --exclude "**/*.spec.ts"                  # Exclude tests
graphify --include "**/*.ts" --exclude "**/*.spec.ts"  # Combined

# Continuous mode
graphify --watch                                   # Auto-update
graphify update --graph-dir ./knowledge            # Update existing

# Querying
graphify query "REST endpoints"                    # Query knowledge
graphify path "A" to "B"                           # Find path
graphify explain "architecture"                    # Explain pattern

# Output formats
graphify --mcp --port 8080                         # MCP server

# Git integration
graphify hook install                              # Pre-commit hook
graphify hook uninstall                            # Remove hooks
```

---

## 📞 Resources

### Official

- **GitHub**: https://github.com/safishamsi/graphify
- **PyPI**: https://pypi.org/project/graphifyy/ (note: double 'y')
- **Documentation**: https://github.com/safishamsi/graphify#readme

### HyperBrain

- **HyperBrain GitHub**: https://github.com/itsatif/hyperbrain-skills
- **Full Documentation**: See SKILL.md for comprehensive guide
- **Examples**: ~/.claude/skills/hyperbrain-skills/graphify-integration/examples/

---

**Graphify Integration: Transform your codebase into queryable knowledge!** 🚀
