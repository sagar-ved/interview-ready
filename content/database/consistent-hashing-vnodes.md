---
title: "Database: Consistent Hashing (Detailed)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: How does Consistent Hashing work? Explain "Virtual Nodes" and why they are necessary.

## 🎯 What the interviewer is testing
- Scaling distributed storage (Sharding).
- Minimizing data migration when nodes join/leave.
- Solving "Hotspot" issues via better distribution.

---

## 🧠 Deep Explanation

### 1. Traditional Hashing: `hash(key) % N`
- **Problem**: If you have 10 nodes and you add node #11, **every single key** will remap (`% 10` vs `% 11` are different for almost every number). You'd have to move 90% of your data.

### 2. Consistent Hashing (The Ring):
- Key and Nodes are hashed to a range (e.g. 0 to $2^{32}-1$).
- Imagine a circle. A key identifies its "destination" as the nearest node traveling **clockwise**.
- **Result**: If a node joins, it only "steals" keys from its immediate neighbor. Only $1/N$ of data moves.

### 3. Virtual Nodes (VNodes):
- **Problem**: Just putting nodes on the circle can lead to "Skew." Some nodes might cover 40% of the circle, others only 5%.
- **Solution**: Mapping one physical server to **hundreds of tiny points** (Virtual Nodes) on the ring.
- **Benefit**: If a server crashes, its load is split across **all** other servers (each taking a few VNodes), rather than dumping everything onto one single neighbor.

---

## ✅ Ideal Answer
Consistent hashing is the standard for managing sharded data in highly dynamic environments like Cassandra or Memcached. By using a hash ring and virtual nodes, we minimize the disruption of adding or removing capacity. Virtual nodes are particularly critical because they ensure a mathematically uniform distribution of data, protecting the system from hot-spots and ensuring that failures don't lead to cascading overloads on specific neighbors.

---

## 🏗️ Logic Table:
- **Traditional**: `hash % N`. Cost of node change = $O(\text{Data})$.
- **Consistent**: Hash Ring. Cost of node change = $O(\text{Data} / N)$.

---

## 🔄 Follow-up Questions
1. **Where is this used?** (DynamoDB, Cassandra, Akamai CDN.)
2. **Does it prevent hot-spots for popular keys?** (Not entirely—if one KEY is hit a billion times, the node holding it will still suffer. You need Application-layer caching for that.)
3. **What is a "Hash Slot" in Redis?** (A variation of consistent hashing where the ring is pre-divided into a fixed number [16,384] of logical slots.)
