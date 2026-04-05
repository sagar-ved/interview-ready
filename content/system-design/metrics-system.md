---
title: "System Design: Design a Distributed Metrics System"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 Question: Design a system to collect, store, and alert on metrics from millions of servers (like Prometheus/Datadog). Focus on Time Series storage.

## 🎯 What the interviewer is testing
- Understanding of Time Series Databases (TSDB).
- Handling high-throughput write workloads.
- Data aggregation and downsampling.
- Push vs Pull models.

---

## 🧠 Deep Explanation

### 1. The Core Schema:
A metric consists of: `(MetricName, Labels/Tags, Timestamp, Value)`.
Tags like `region:us-west` allow for efficient filtering.

### 2. Push vs Pull:
- **Pull (Prometheus)**: Central server probes endpoints. Good for service discovery and knowing if a server is dead.
- **Push (Datadog/Graphite)**: Agent on the server sends data to a central collector. Better for short-lived (serverless) jobs and crossing firewalls.

### 3. Data Storage (LSM Trees):
Use Time Series Databases (InfluxDB, Prometheus TSDB, TimescaleDB).
- **Chunking**: Group data into 2-hour blocks for efficient disk writes.
- **Compaction**: Periodically merge blocks to improve read speed.
- **Downsampling**: As data gets older, replace 1-second resolution with 1-hour resolution to save space (Retention Policy).

---

## ✅ Ideal Answer
Metric systems require incredibly high write throughput and sub-second query latency for alerting. We use a TSDB optimized for append-only sequential writes. To handle scale, we sharding metrics by name/labels and use an aggregation layer to compute common statistics (avg, p99) before storage.

---

## 🏗️ Architecture
```
[Servers] -> [Metric Collector (Agent)] -> [Kafka / Message Queue] 
                                                  ↓
                                          [Aggregation Service]
                                                  ↓
                                           [TSDB / Cassandra]
                                                  ↓           ↓
                                          [Alert Manager]   [Grafana]
```

---

## ⚠️ Common Mistakes
- Using a standard Relational DB (SQL) for storing billions of data points without chunking.
- Ignoring the "High Cardinality" problem (Too many unique tag combinations).
- Not discussing data retention or downsampling.

---

## 🔄 Follow-up Questions
1. **Explain "High Cardinality".** (When you have thousands of unique tags like `user_id` on a metric, the index size explodes.)
2. **Difference between a Gauge and a Counter?** (Counter only goes up; Gauge can go up or down.)
3. **How to handle out-of-order samples?** (Most TSDBs keep a small "head" buffer in memory to sort late-arriving samples.)
