# On-Demand MCP Servers - Quick Reference

**Part of HyperBrain Skills Library**

**Purpose:** On-demand activation of specialized MCP servers

**Version:** 1.0.0
**Last Updated:** 2026-05-03

---

## 🎯 Overview

These MCP servers activate **ONLY when explicitly requested**, providing specialized capabilities without automatic overhead.

---

## 🚀 Available MCP Servers

### 1. Morpheus MCP

**Purpose:** Knowledge graph queries and codebase search

**How to Activate:**
```
"Use Morpheus to query the knowledge graph"
"Search codebase for container pattern"
"Get architecture from Morpheus"
```

**Capabilities:**
- Query knowledge graphs (DeJoule, Backend, IoT)
- Search codebase for patterns
- Read files with context
- Get architecture overview
- Retrieve InfluxDB schema

---

### 2. Data Proxy MCP

**Purpose:** Access database services and execute queries

**How to Activate:**
```
"Use data-proxy to query PostgreSQL"
"Execute InfluxDB query through data-proxy"
"Get device telemetry from data-proxy"
```

**Capabilities:**
- Query PostgreSQL (devices, sites, users)
- Query InfluxDB (telemetry, time-series data)
- Execute Redis commands (cache operations)
- Check database health

---

### 3. Figma Console MCP

**Purpose:** Access Figma designs and components

**How to Activate:**
```
"Use Figma to get the dashboard design"
"Get component from Figma"
"Take screenshot of Figma design"
```

**Capabilities:**
- Get Figma file data
- Access design components
- Take screenshots
- Get component for development
- Access design tokens

---

### 4. Sentinel MCP

**Purpose:** Monitor and track system health

**How to Activate:**
```
"Use Sentinel to check system health"
"Get application metrics from Sentinel"
```

**Capabilities:**
- Check system health status
- Monitor application metrics
- Track error rates
- Get performance data

---

## 📋 Quick Reference

| MCP Server | Trigger Keywords | Use For |
|------------|-----------------|---------|
| **Morpheus** | "Use Morpheus", "Query knowledge graph", "Search codebase" | Knowledge graphs, code search |
| **Data Proxy** | "Use data-proxy", "Query database", "Execute SQL" | Database queries |
| **Figma** | "Use Figma", "Get Figma design", "Figma component" | Design access |
| **Sentinel** | "Use Sentinel", "Check health", "System status" | System monitoring |

---

## 💡 Usage Examples

### Example 1: Query Knowledge Graph
```
User: "Use Morpheus to query the backend knowledge graph"

AI: [Activates Morpheus MCP on-demand]
    "Querying backend knowledge graph...
    
    Retrieved from jt-api-v2:
    - Architecture: Layered (Controller → Service → Repository)
    - Services: 7 microservices
    - API Endpoints: 50+ routes"
```

### Example 2: Query Database
```
User: "Use data-proxy to get all devices for site iah-del"

AI: [Activates data-proxy MCP on-demand]
    "Querying PostgreSQL...
    
    Results:
    - chiller-1 (Controller: ctrl-1, Type: Chiller)
    - chiller-2 (Controller: ctrl-1, Type: Chiller)
    - ahu-1 (Controller: ctrl-2, Type: AHU)"
```

### Example 3: Get Figma Design
```
User: "Use Figma to get the dashboard design"

AI: [Activates Figma Console MCP on-demand]
    "Fetching Figma file...
    
    File: Dashboard Design
    - Pages: 5
    - Components: 23
    - Styles: 12 color styles, 8 text styles"
```

---

## ✅ Best Practices

### When to Use
✅ Querying large knowledge bases
✅ Searching codebase for patterns
✅ Accessing real-time database data
✅ Getting latest Figma designs
✅ Checking system health status

### When NOT to Use
❌ Basic coding tasks (use built-in skills)
❌ Simple pattern matching (use knowledge base)
❌ Local file operations (use filesystem tools)
❌ General questions (use built-in knowledge)

---

## 🔒 Security

- **Authentication:** Required for all MCP servers
- **Authorization:** Database-level permissions enforced
- **Logging:** All queries logged
- **Rate Limiting:** Query rate limits enforced
- **Network:** Data Proxy requires VPN/internal network

---

## 📚 Documentation

For complete details, see [SKILL.md](SKILL.md)

---

**On-demand MCP servers provide specialized capabilities when you need them, without automatic overhead!** 🚀
