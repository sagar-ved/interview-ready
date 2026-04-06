---
author: "sagar ved"
title: "System Design: Design a Key-Value Store (Consistent Hashing)"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: Design a distributed Key-Value store. How do you handle scalability, replication, and high availability? Focus on Consistent Hashing.

## 🎯 What the interviewer is testing
- Understanding of distributed data partitioning.
- Techniques to minimize re-sharding impact.
- Replication strategies (Master-Slave vs Peer-to-Peer).

---

## 🧠 Deep Explanation

### 1. Consistent Hashing:
Traditional hashing `node = hash(key) % N` fails when `N` (number of servers) changes — almost all keys move to different nodes.
**Consistent Hashing** places keys and nodes on a circular **Hash Ring**. A key belongs to the first node encountered clockwise.
- **Adding/Removing Nodes**: Only keys between two nodes move.
- **Virtual Nodes**: Multiple ring positions per physical node to ensure uniform load distribution.

### 2. High Availability (Replication):
Store copies of data on the next $N$ nodes on the ring.

### 3. Data Consistency (CAP Theorem):
- Often use **Quorum-based** consistency.
- `R + W > N` ensures a read always sees the latest write.

---

## ✅ Ideal Answer
To scale a key-value store, we partition data using consistent hashing with virtual nodes. This minimizes data movement during scaling. For availability, we replicate keys on successors in the hash ring and use tunable consistency (Quorum) to manage the trade-off between latency and strong consistency.

---

## 🏗️ Architecture
```
[Client]
    ↓ (Lookup in Cluster Metadata / Gossip Protocol)
[Node A (Primary for Key X)]
    ↓ Replicate
[Node B, Node C (Successors on ring)]
```

---

## ⚠️ Common Mistakes
- Not mentioning virtual nodes (causing non-uniform load).
- Using basic Modulo hashing for distributed systems.
- Ignoring Gossip Protocol for cluster membership.

---

## 🔄 Follow-up Questions
1. **How to handle write conflicts?** (Vector Clocks or Last-Write-Wins.)
2. **What is a "Sloppy Quorum"?** (Used in Dynamo for high availability during partitions.)
3. **Difference between Master-Slave and Master-Master?** (Latency vs conflict complexity.)
