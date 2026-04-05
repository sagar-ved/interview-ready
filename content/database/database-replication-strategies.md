---
title: "Database: Database Replication Strategies"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: Compare Master-Slave, Master-Master, and Quorum-based replication. How do they handle consistency and availability?

## 🎯 What the interviewer is testing
- High Availability (HA) architectures.
- Tradeoffs in Write vs Read scaling.
- Understanding of "Eventual Consistency."

---

## 🧠 Deep Explanation

### 1. Master-Slave (Single-Leader):
- **Writes**: Only to the Master.
- **Reads**: To many Slaves.
- **Pros**: Simple, easy to manage consistency.
- **Cons**: Master is a write bottleneck and SPOF.

### 2. Multi-Master (Leaderless/Multi-Leader):
- **Writes**: Can happen on any node.
- **Pros**: High write availability; low latency (users write to the nearest DB).
- **Cons**: Conflict resolution is a nightmare (Vector Clocks/LWW).

### 3. Quorum-Based (Dynamo style):
- **Mechanism**: Every write/read must be acknowledged by a minimum number of nodes ($W$ and $R$).
- **The Rule**: If $W + R > N$ (Total nodes), you are guaranteed to read the latest value.
- **Flexibility**: Can tune for **Fast Writes** ($W=1$, but risky) or **Strong Reads** (High $R$).

---

## ✅ Ideal Answer
Replication choice depends on your specific traffic patterns. For read-heavy applications, a Master-Slave setup with multiple read replicas is the standard industry choice. For geographically distributed systems where low-latency writes are critical, Multi-Master or Quorum-based systems are used to ensure availability across network partitions, provided the application can handle eventual consistency and conflict resolution.

---

## 🏢 Summary Table:
| Strategy | Primary Risk | Scalability |
|---|---|---|
| Master-Slave | Master Failure | High Read |
| Multi-Master | Conflict / Integrity | High Write |
| Quorum | Latency Jitter | Tunable |

---

## 🔄 Follow-up Questions
1. **What is "Synchronous" vs "Asynchronous" replication?** (Sync: Wait for slave before returning; Async: Commit on master immediately, slave catches up later.)
2. **Replication Lag?** (The delay between data being written to master and appearing on a slave.)
3. **What is a "Witness" node?** (A tiny node that doesn't hold data but participates in voting/quorum to break ties.)
