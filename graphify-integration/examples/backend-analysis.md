# Example: Backend Knowledge Base Analysis with Graphify

**Use Case:** Automatically extract and document jt-api-v2 architecture

---

## 🎯 Objective

Transform the jt-api-v2 codebase into a queryable knowledge graph that integrates with the existing backend-knowledge-base skill.

---

## 📋 Prerequisites

- jt-api-v2 codebase cloned locally
- Graphify installed (`pip install graphifyy`)
- HyperBrain skills library installed

---

## 🚀 Step-by-Step Workflow

### Step 1: Navigate to jt-api-v2

```bash
cd ~/workspace/jt-api-v2
```

### Step 2: Extract Knowledge Graph

```bash
# Extract TypeScript services only
graphify \
  --include "**/*.ts" \
  --exclude "**/*.spec.ts" \
  --exclude "**/node_modules/**" \
  --exclude "**/dist/**" \
  --output-dir ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted
```

**Expected Output:**
```
🔍 Analyzing codebase...
📊 Found 247 TypeScript files
🔧 Extracting AST nodes...
🔗 Linking cross-file references...
🎯 Detecting communities...
📝 Generating outputs...
✅ HTML: ./knowledge/auto-extracted/graph.html
✅ JSON: ./knowledge/auto-extracted/graph.json
✅ Report: ./knowledge/auto-extracted/GRAPH_REPORT.md
```

### Step 3: Review Generated Report

```bash
cat ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted/GRAPH_REPORT.md
```

**Report Contents:**
- Architecture overview
- Service layer breakdown
- API endpoint inventory
- Database schema relationships
- Dependency analysis
- Recommendations

### Step 4: Query the Knowledge Graph

#### Query 1: Find All REST Endpoints

```bash
cd ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted
graphify query "List all @Controller or @RestController endpoints with their routes"
```

**Expected Result:**
```
Found 47 REST endpoints:

1. DeviceController
   - GET /api/devices - listDevices()
   - POST /api/devices - createDevice()
   - GET /api/devices/:id - getDevice()
   - PUT /api/devices/:id - updateDevice()
   - DELETE /api/devices/:id - deleteDevice()

2. SiteController
   - GET /api/sites - listSites()
   ...

3. AlertController
   - GET /api/alerts - listAlerts()
   ...
```

#### Query 2: Trace Service Dependencies

```bash
graphify path "DeviceController.getDevice" to "DatabaseService.execute"
```

**Expected Result:**
```
Call path from DeviceController.getDevice to DatabaseService.execute:

DeviceController.getDevice()
  → DeviceService.findById()
    → DeviceRepository.findOne()
      → DatabaseService.execute()
```

#### Query 3: Identify High-Impact Services

```bash
graphify query "Which services are depended upon by most other services?"
```

**Expected Result:**
```
Top 5 most depended-upon services:

1. DatabaseService (23 dependents)
2. CacheService (18 dependents)
3. LoggerService (15 dependents)
4. AuthService (12 dependents)
5. ValidationService (9 dependents)
```

### Step 5: Explore Interactive HTML

```bash
open ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted/graph.html
```

**Interactive Features:**
- Search for specific functions/classes
- Filter by service layer
- Click nodes to see details
- Visualize call graphs
- Highlight community clusters

### Step 6: Integrate with HyperBrain

Now use the extracted knowledge with other HyperBrain skills:

#### Example 1: Architecture Review with Expert Persona

```
User prompt: "Act as Google L7 Backend Engineer and review the jt-api-v2 architecture. Focus on service layer organization, dependency management, and potential scalability bottlenecks. Use the knowledge graph at ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted/GRAPH_REPORT.md"
```

#### Example 2: TDD Workflow with Critical Paths

```
User prompt: "Based on the dependency graph in ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted/graph.json, identify the top 5 most critical execution paths that need comprehensive test coverage. Use /tdd to create tests for these paths."
```

#### Example 3: Refactoring Planning

```
User prompt: "Use /superpowers-brainstorm to plan a refactoring of jt-api-v2 to extract device monitoring into a separate microservice. Use the knowledge graph to understand current dependencies and plan the separation boundary."
```

---

## 📊 Expected Results

### Knowledge Graph Metrics

```
📈 Graph Statistics:
- Nodes: 1,847 (functions, classes, modules)
- Edges: 3,421 (calls, imports, references)
- Communities: 12 (service clusters)
- Modularity: 0.67 (well-clustered)
- Largest Community: 342 nodes (Device Management)

📊 Code Metrics:
- Lines of Code: 89,234
- Languages: TypeScript (98%), SQL (2%)
- Average Complexity: 4.2 (low)
- Average Coupling: 3.1 (low)
- Average Cohesion: 0.82 (high)

✅ Quality Metrics:
- Test Coverage: 76% (needs improvement)
- Documentation: 68% (needs improvement)
- Code Duplication: 2.3% (excellent)
- Dead Code: 1.1% (excellent)
```

### Key Insights Discovered

1. **Service Boundaries**: Clear separation between Device, Site, Alert, and User domains
2. **Shared Utilities**: Common services (Database, Cache, Logger) have high reuse
3. **Coupling**: Low coupling between services (good!)
4. **Test Coverage**: DeviceService has 92% coverage, but AlertService only 54%
5. **Documentation**: Controllers well-documented, repositories lack docs

---

## 🎓 Next Steps

### 1. Continuous Updates

```bash
# Install git hook for auto-updates
cd ~/workspace/jt-api-v2
graphify hook install

# Now knowledge graph updates on every commit
```

### 2. MCP Server for Live Querying

```bash
# Start MCP server
graphify --mcp --mcp-port 8080

# Now query from any application via HTTP
curl http://localhost:8080/query?q="REST%20endpoints"
```

### 3. Documentation Integration

```bash
# Add to backend-knowledge-base
cat ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/knowledge/auto-extracted/GRAPH_REPORT.md >> ~/.claude/skills/hyperbrain-skills/backend-knowledge-base/KB_AUTOMATED_ANALYSIS.md

# Commit to repository
cd ~/.claude/skills/hyperbrain-skills
git add backend-knowledge-base/KB_AUTOMATED_ANALYSIS.md
git commit -m "docs: add automated jt-api-v2 knowledge graph analysis"
```

---

## 🔍 Troubleshooting

### Issue: "Too many files to process"

**Solution:**
```bash
# Process in chunks by directory
graphify src/services --output-dir ./knowledge/services
graphify src/controllers --output-dir ./knowledge/controllers
graphify src/repositories --output-dir ./knowledge/repositories
```

### Issue: "Memory error during extraction"

**Solution:**
```bash
# Reduce file size limit and workers
export GRAPHIIFY_MAX_FILE_SIZE=5
export GRAPHIIFY_WORKERS=2
graphify --output-dir ./knowledge
```

### Issue: "Missing API documentation"

**Solution:**
```bash
# Enable semantic extraction for JSDoc comments
export GRAPHIIFY_SEMANTIC_EXTRACTION=true
export ANTHROPIC_API_KEY="your-api-key-here"
graphify --output-dir ./knowledge
```

---

## 📚 Related HyperBrain Skills

- **backend-knowledge-base**: Manual documentation of jt-api-v2 patterns
- **tdd-workflow**: Write tests based on critical path analysis
- **expert-personas**: Get expert review of extracted architecture
- **superpowers-brainstorm**: Plan refactoring using graph insights

---

**This example demonstrates how Graphify transforms manual documentation into automated, queryable knowledge!** 🚀
