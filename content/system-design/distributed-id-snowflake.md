---
author: "sagar ved"
title: "System Design: Distributed ID Generator (Snowflake)"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: Design a unique ID generator for a distributed system. Why don't we use UUID or Auto-Increment?

## 🎯 What the interviewer is testing
- Scalability without a central coordinator.
- Sorting IDs by time.
- Handling clock drift.

---

## 🧠 Deep Explanation

### 1. Why not UUID?
- **Size**: 128 bits (too large). 
- **Indexing**: Not monotonically increasing. B-Trees perform terribly with random keys (page-splitting).

### 2. Why not Auto-Increment (DB)?
- **Performance**: Centralized. If the ID database is slow, the whole system is slow. 

### 3. The Snowflake Solution (64 bits):
- **1 bit**: Unused (sign bit).
- **41 bits**: **Timestamp** (milliseconds). Gives ~69 years of IDs from a custom epoch.
- **10 bits**: **Machine ID** / Datacenter ID. Up to 1024 unique servers.
- **12 bits**: **Sequence Number**. Up to 4096 IDs per millisecond per server.

### 4. Characteristics:
- Sortable by time.
- Zero network communication during ID generation.
- Highly available (each node generates its own ID).

---

## ✅ Ideal Answer
For a global scale system, we need IDs that are both unique and chronologically sortable. The Snowflake approach achieves this by embedding a high-precision timestamp and a machine-specific identifier within a 64-bit integer. This enables every server in our cluster to generate valid, indexed IDs at high velocity without the bottleneck of a central lock or database transaction.

---

## 🏢 Bit Composition:
`[0 | 41-bit Timestamp | 5-bit DC | 5-bit Mach | 12-bit Seq]`

---

## 🔄 Follow-up Questions
1. **Clock Drift?** (If the system clock rolls back, the generator should throw an error or wait until the clock catches up to prevent duplicate IDs.)
2. **What if we have 2000 machines?** (Need more bits for machine ID, reducing the sequence or timestamp bits.)
3. **Alternative?** (Ticket Server like Flickr or Segmented Range from DB.)
