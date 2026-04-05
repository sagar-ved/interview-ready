---
title: "System Design: Metrics & Monitoring (Prometheus)"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: Design a metrics monitoring system like Prometheus. Compare Push vs. Pull models.

## 🎯 What the interviewer is testing
- Understanding of observability at scale.
- Dealing with high-velocity data points (Counter, Gauge, Histogram).
- Scalability of metric collection.

---

## 🧠 Deep Explanation

### 1. The Pull Model (Prometheus):
The monitoring server asks each target: "What are your metrics?"
- **Pros**: 
  - Centralized scaling (server decides when to scrape).
  - No need for targets to know the server's IP. 
  - Down targets are easily detected (if scrape fails, target is down).
- **Cons**: Difficult for short-lived (serverless) jobs. 

### 2. The Push Model (InfluxDB / StatsD):
Targets send their data to the server.
- **Pros**: Good for ephemeral tasks (Lambdas).
- **Cons**: Can overwhelm the server with a "thundering herd." Security is harder (authentication).

### 3. Prometheus Storage:
Uses a **Time-Series DB**. Highly optimized for appending data to blocks that are eventually compressed and moved to long-term storage (S3/GCS).

---

## ✅ Ideal Answer
For long-running infrastructure, a pull-based model is preferred as it gives the monitoring system full control over traffic volume and health detection. At the storage layer, we utilize a time-series database optimized for append-only writes. To prevent data explosions, we apply strict metric naming conventions and implement downsampling for long-term historical analysis.

---

## 🏗️ Architecture
```
[Target Service] <-- [Prometheus (Scraper)] --> [TSDB Storage]
      ↓                                             ↓
[Pushgateway] (For short-lived jobs)            [Grafana (UI)]
```

---

## 🔄 Follow-up Questions
1. **What is "Cardinality Explosion"?** (When you add a unique label like `user_id` to a metric, creating millions of unique time-series, which crashes the DB.)
2. **Gauge vs Counter?** (Counter only goes up [until reset]; Gauge can go up and down.)
3. **What is AlertManager?** (A component that deduplicates, groups, and routes alerts to Slack/Email based on metric thresholds.)
