---
author: "sagar ved"
title: "System Design: Design an Ad Click Counter"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 Question: Design a system to count ad clicks in real-time. Handle billions of clicks per day with sub-second latency and high accuracy.

## 🎯 What the interviewer is testing
- Stream processing concepts (Kafka, Flink, Spark).
- Idempotency and avoiding double counting.
- Aggregation levels (Ingestion vs. Query-time).

---

## 🧠 Deep Explanation

### 1. The Write Path (Ingestion):
Ad Click → Load Balancer → **Click Gateway** (API).
The Gateway should be lightweight. It just validates the request and publishes to **Kafka**.

### 2. Stream Processing (Real-time):
**Apache Flink** or **Spark Streaming** consumes from Kafka.
- **Windowing**: Group clicks by 1-minute or 5-minute windows for specific ad-ids.
- **State management**: Use Flink's managed state to keep counts.
- **Idempotency**: Use a `click_id` and a Bloom Filter or temporary DB entries to ensure one click isn't counted twice due to retries.

### 3. The Read Path (Query):
Store aggregated data in an NoSQL DB like **Cassandra** or **Redis** for fast lookups.

---

## ✅ Ideal Answer
For real-time ad-click counting, we decouple ingestion from processing using a message queue like Kafka. Stream processors then perform windowed aggregations and store results in a high-speed NoSQL database. We must handle exactly-once semantics by using unique transaction IDs and idempotent database updates.

---

## 🏗️ Architecture
```
[Client Click] 
      ↓
[Gateway API] -> [Kafka (Log of Clicks)]
                       ↓
              [Flink (Windowed Counts)]
                       ↓ (Write to DB)
               [Redis / Cassandra]
                       ↓
                [Dashboard / API]
```

---

## ⚠️ Common Mistakes
- Writing directly from the API to a SQL database (will not scale to billions).
- Ignoring network retries (leading to over-counting).
- Not discussing data retention for historical analytics.

---

## 🔄 Follow-up Questions
1. **How to handle "Late Data"?** (Use Watermarks in Flink to allow a small delay for late-arriving events.)
2. **Compare Flink vs Kafka Streams.** (Flink is a full distributed cluster; Kafka Streams is a library within your app.)
3. **What if the aggregator crashes?** (Use Checkpoints to restore state.)
