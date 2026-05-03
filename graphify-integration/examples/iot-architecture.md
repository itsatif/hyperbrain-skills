# Example: IoT Platform Architecture Analysis with Graphify

**Use Case:** Extract and visualize IoT data flow from MQTT to InfluxDB

---

## 🎯 Objective

Understand the complete architecture of iot-application service, including MQTT message consumption, Kafka processing, and InfluxDB storage patterns.

---

## 📋 Prerequisites

- iot-application codebase cloned locally
- Graphify installed (`pip install graphifyy`)
- Understanding of IoT stack (MQTT, Kafka, InfluxDB)

---

## 🚀 Step-by-Step Workflow

### Step 1: Navigate to IoT Application

```bash
cd ~/workspace/iot-application
```

### Step 2: Extract IoT Knowledge Graph

```bash
# Extract TypeScript services with focus on IoT patterns
graphify \
  --include "**/*.ts" \
  --exclude "**/*.spec.ts" \
  --exclude "**/node_modules/**" \
  --exclude "**/dist/**" \
  --output-dir ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph
```

**Expected Output:**
```
🔍 Analyzing iot-application codebase...
📊 Found 189 TypeScript files
🔧 Extracting AST nodes...
🔗 Linking cross-file references...
🎯 Detecting communities...
📝 Generating outputs...
✅ HTML: ./knowledge/iot-graph/graph.html
✅ JSON: ./knowledge/iot-graph/graph.json
✅ Report: ./knowledge/iot-graph/GRAPH_REPORT.md
```

### Step 3: Query IoT-Specific Patterns

#### Query 1: MQTT Topic Subscriptions

```bash
cd ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph
graphify query "Find all MQTT topic subscriptions and their handlers"
```

**Expected Result:**
```
Found 23 MQTT topic subscriptions:

1. DeviceTelemetryConsumer
   - Topic: devices/+/telemetry
   - Handler: handleDeviceTelemetry()
   - QoS: 1
   - Parser: JsonTelemetryParser

2. DeviceStatusConsumer
   - Topic: devices/+/status
   - Handler: handleDeviceStatus()
   - QoS: 1
   Parser: StatusParser

3. AlertConsumer
   - Topic: devices/+/alerts
   - Handler: handleAlert()
   - QoS: 2
   Parser: AlertParser
```

#### Query 2: Kafka Consumer Groups

```bash
graphify query "List all Kafka consumer groups and their subscriptions"
```

**Expected Result:**
```
Found 8 Kafka consumer groups:

1. telemetry-processor-group
   - Topics: device-telemetry, processed-telemetry
   - Members: 3 (for parallel processing)
   - Handler: TelemetryProcessorService

2. alert-processor-group
   - Topics: device-alerts, critical-alerts
   - Members: 2
   - Handler: AlertProcessorService

3. aggregate-processor-group
   - Topics: hourly-aggregates, daily-aggregates
   - Members: 1
   - Handler: AggregateProcessorService
```

#### Query 3: InfluxDB Write Patterns

```bash
graphify query "Show all InfluxDB write operations and their measurements"
```

**Expected Result:**
```
Found 34 InfluxDB write operations:

1. TelemetryService.writeRawTelemetry()
   - Measurement: device_telemetry
   - Tags: site_id, device_id, device_type
   - Fields: temperature, humidity, power, energy
   - Precision: ms
   - Bucket: device_component
   - Org: dejoule

2. AlertService.writeAlert()
   - Measurement: device_alerts
   - Tags: site_id, device_id, alert_type, severity
   - Fields: alert_message, triggered_at, resolved_at
   - Precision: ms
   - Bucket: device_component
   - Org: dejoule
```

#### Query 4: End-to-End Data Flow

```bash
graphify path "MqttConsumer.consume" to "InfluxDBService.write"
```

**Expected Result:**
```
Complete data flow from MQTT to InfluxDB:

MqttConsumer.consume('devices/+/telemetry')
  → DeviceTelemetryConsumer.handleDeviceTelemetry()
    → TelemetryParser.parse()
      → TelemetryValidator.validate()
        → TelemetryEnricher.enrich()
          → KafkaProducer.send('device-telemetry')
            → TelemetryProcessorService.process()
              → AggregateCalculator.calculate()
                → InfluxDBService.write('device_telemetry')
```

### Step 4: Analyze Architecture Patterns

#### Query 5: Identify Message Processing Pipelines

```bash
graphify query "Show all message processing pipelines and their transformations"
```

**Expected Result:**
```
Found 7 message processing pipelines:

1. Raw Telemetry Pipeline
   - Input: MQTT (devices/+/telemetry)
   - Step 1: Parse JSON → Telemetry object
   - Step 2: Validate (range checks, required fields)
   - Step 3: Enrich (add site metadata, device info)
   - Step 4: Buffer (batch size: 1000, timeout: 5s)
   - Step 5: Kafka (topic: device-telemetry)
   - Step 6: Process (calculate aggregates)
   - Output: InfluxDB (device_telemetry)

2. Alert Pipeline
   - Input: MQTT (devices/+/alerts)
   - Step 1: Parse JSON → Alert object
   - Step 2: Validate (check required fields)
   - Step 3: Classify (severity: low, medium, high, critical)
   - Step 4: Route (Kafka topic based on severity)
   - Step 5: Process (apply alert rules)
   - Output: InfluxDB (device_alerts) + Notification service
```

#### Query 6: Find Error Handling Patterns

```bash
graphify query "Show error handling patterns in message processing"
```

**Expected Result:**
```
Error handling patterns:

1. Parse Errors
   - Strategy: Dead Letter Queue (DLQ)
   - DLQ Topic: parse-errors
   - Recovery: Manual inspection + replay

2. Validation Errors
   - Strategy: Discard with logging
   - Log Level: WARN
   - Metric: validation_errors_counter

3. Database Errors
   - Strategy: Retry with exponential backoff
   - Max Retries: 3
   - Backoff: 1s, 2s, 4s
   - Fallback: Buffer in memory, alert if buffer > 10000

4. Network Errors
   - Strategy: Circuit breaker
   - Threshold: 5 consecutive failures
   - Timeout: 30s
   - Recovery: Automatic after 60s
```

### Step 5: Explore Interactive HTML

```bash
open ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph/graph.html
```

**Visual Analysis:**
- **Community 1**: MQTT consumers (purple cluster)
- **Community 2**: Kafka processors (blue cluster)
- **Community 3**: InfluxDB writers (green cluster)
- **Community 4**: Validators and parsers (yellow cluster)

### Step 6: Generate Architecture Diagram

```bash
# Create a visual diagram based on graph
graphify explain "IoT data flow architecture from MQTT to InfluxDB" > iot-architecture.txt

# Convert to Mermaid diagram (manual step based on explanation)
cat > iot-architecture.mermaid << 'EOF'
graph TD
    A[MQTT Broker] --> B[DeviceTelemetryConsumer]
    A --> C[DeviceStatusConsumer]
    A --> D[AlertConsumer]
    
    B --> E[TelemetryParser]
    E --> F[TelemetryValidator]
    F --> G[TelemetryEnricher]
    G --> H[Kafka Producer]
    
    H --> I[Kafka: device-telemetry]
    I --> J[TelemetryProcessorService]
    J --> K[AggregateCalculator]
    K --> L[InfluxDB Service]
    L --> M[InfluxDB: device_telemetry]
    
    style A fill:#f96,stroke:#333
    style M fill:#9f9,stroke:#333
    style I fill:#99f,stroke:#333
EOF
```

---

## 📊 Expected Results

### Knowledge Graph Metrics

```
📈 Graph Statistics:
- Nodes: 1,234 (functions, classes, modules)
- Edges: 2,847 (calls, imports, references)
- Communities: 8 (layer clusters)
- Modularity: 0.72 (well-clustered)
- Largest Community: 287 nodes (Telemetry Processing)

📊 Code Metrics:
- Lines of Code: 67,892
- Languages: TypeScript (100%)
- Average Complexity: 5.1 (low-medium)
- Average Coupling: 4.2 (low-medium)
- Average Cohesion: 0.78 (high)

✅ Quality Metrics:
- Test Coverage: 82% (good)
- Documentation: 54% (needs improvement)
- Code Duplication: 3.1% (good)
- Dead Code: 0.8% (excellent)
```

### Key Architecture Insights

1. **Clear Layer Separation**: MQTT → Kafka → InfluxDB pipeline is well-separated
2. **High Test Coverage**: Telemetry processing has 91% coverage
3. **Error Recovery**: Good error handling with DLQ and retry mechanisms
4. **Scalability**: Kafka consumer groups support horizontal scaling
5. **Documentation Gap**: Business logic lacks documentation

### Performance Characteristics

```
⚡ Performance Analysis:

Throughput:
- MQTT Messages: ~10,000/second
- Kafka Processing: ~8,000/second
- InfluxDB Writes: ~12,000/second (batched)

Latency:
- MQTT to Kafka: ~50ms (p95)
- Kafka to InfluxDB: ~200ms (p95)
- End-to-end: ~250ms (p95)

Bottlenecks:
1. TelemetryEnricher (database lookups)
2. AggregateCalculator (CPU-intensive)
```

---

## 🎓 Integration with HyperBrain Skills

### 1. IoT Knowledge Base Enhancement

```
User prompt: "Based on the extracted IoT knowledge graph at ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph, identify the top 3 patterns for implementing new MQTT consumers. Include error handling, validation, and integration with Kafka."
```

### 2. Troubleshooting with Knowledge Graph

```
User prompt: "Use the knowledge graph to trace why device telemetry from site 'iah-del' is not appearing in InfluxDB. Check the complete data flow from MQTT to InfluxDB."
```

### 3. Performance Optimization

```
User prompt: "Analyze the IoT knowledge graph to identify optimization opportunities. Focus on the TelemetryEnricher and AggregateCalculator which are bottlenecks. Suggest refactoring approaches."
```

### 4. TDD for Critical IoT Paths

```
User prompt: "Use /tdd to write comprehensive tests for the telemetry processing pipeline. Focus on the critical path from MQTT to InfluxDB, including error scenarios."
```

---

## 🔄 Continuous Updates

### Git Hook Integration

```bash
cd ~/workspace/iot-application
graphify hook install

# Knowledge graph updates on every commit
git add .
git commit -m "Add new alert consumer"
# Graph automatically updated!
```

### Scheduled Updates

```bash
# Update knowledge graph weekly
crontab -e
# Add: 0 0 * * 0 cd ~/workspace/iot-application && graphify --output-dir ~/.claude/skills/hyperbrain-skills/iot-knowledge-base/knowledge/iot-graph
```

---

## 🔍 Troubleshooting

### Issue: "Missing Kafka consumer group details"

**Solution:**
```bash
# Enable semantic extraction for decorator annotations
export GRAPHIIFY_SEMANTIC_EXTRACTION=true
export ANTHROPIC_API_KEY="your-api-key-here"
graphify --output-dir ./knowledge
```

### Issue: "InfluxDB queries not captured"

**Solution:**
```bash
# Include SQL/Flux files
graphify \
  --include "**/*.ts" \
  --include "**/*.flux" \
  --output-dir ./knowledge
```

---

## 📚 Related HyperBrain Skills

- **iot-knowledge-base**: Manual IoT patterns and best practices
- **kafka-patterns**: Kafka consumer/producer patterns
- **mqtt-patterns**: MQTT topic design and consumer patterns
- **influxdb-patterns**: InfluxDB schema and query patterns
- **tdd-workflow**: Test critical IoT data paths

---

## 🎯 Key Takeaways

✅ **Complete Visibility**: End-to-end data flow from MQTT to InfluxDB  
✅ **Architecture Understanding**: Clear separation of concerns across layers  
✅ **Performance Insights**: Identify bottlenecks and optimization opportunities  
✅ **Error Handling**: Comprehensive error recovery patterns documented  
✅ **Test Coverage**: Identify untested critical paths  

**This example demonstrates how Graphify reveals the complete IoT architecture in minutes!** 🚀
