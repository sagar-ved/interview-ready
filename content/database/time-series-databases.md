---
title: "Database: NoSQL: Time-Series Databases (InfluxDB)"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: What is a Time-Series Database (TSDB)? Explain the role of "Tags" and "Fields" and why they are optimized for metrics.

## 🎯 What the interviewer is testing
- Handling high-throughput, timestamped data.
- Knowledge of InfluxDB or Prometheus storage logic.
- Data retention and downsampling.

---

## 🧠 Deep Explanation

### 1. The Data Point:
`Measurement + Timestamp + Tags + Fields`.
- **Tags (Metadata)**: Indexed. e.g. `host="server1"`, `region="us-east"`. Use these for filtering.
- **Fields (Values)**: Not indexed. e.g. `cpu_load=44.5`, `temp=30`.

### 2. High-Throughput Aggregation:
TSDBs are optimized for constant, high-speed writes.
- Unlike relational DBs, they often use **columnar storage** or **LSM Trees** tuned for sequential time windows.
- They have built-in **Retention Policies** (e.g. "Delete data older than 30 days automatically").

### 3. Continuous Queries / Downsampling:
Automatically shrinking old data: 
- 1-second resolution (for today).
- 1-minute averages (for last week).
- 1-hour averages (for last year).

---

## ✅ Ideal Answer
TSDBs are specialized for recording the state of a system over time. By separating metadata (Tags) from sensor readings (Fields), they allow for incredibly fast searching and aggregation across millions of metrics. Their native support for data lifecycle management makes them the standard choice for monitoring systems and IoT applications.

---

## 🏗️ Example Query:
- **Relational**: `SELECT avg(val) FROM logs WHERE time > Now - 1hr AND tag = 'X'` (Slow)
- **TSDB**: `SELECT MEAN(value) FROM metric WHERE tag = 'X' AND time > now() - 1h` (Optimized)

---

## 🔄 Follow-up Questions
1. **Explain "High Cardinality" in TSDB.** (When you have too many unique tags [like UserID], the index size explodes, killing performance.)
2. **Prometheus vs InfluxDB?** (Prometheus is Pull-based and focused on monitoring; InfluxDB is Push-based and more general-purpose TS.)
3. **What is an "LSM Tree" in the context of TSDB?** (Sequential logs that are eventually merged.)
