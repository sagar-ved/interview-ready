---
author: "sagar ved"
title: "System Design: Design Vector Clocks (Conflict Resolution)"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: How do distributed systems resolve write conflicts? Explain Vector Clocks vs. LWW (Last-Write-Wins).

## 🎯 What the interviewer is testing
- Conflict detection in "Always Available" systems.
- Understanding of causal consistency.
- Handling data reconciliation in Dynamo-style databases.

---

## 🧠 Deep Explanation

### 1. The Problem:
In a leaderless distributed system (like Cassandra or Dynamo), User A updates the price to \$10 on Server 1. Simultaneously, User B updates it to \$12 on Server 2. Which one "wins"?

### 2. Last-Write-Wins (LWW):
The system uses physical timestamps. Whoever has the newest clock wins.
- **Problem**: Clock Skew! If Server 2's clock is 5ms ahead, its update wins even if it happened first.

### 3. Vector Clocks:
A list of `(NodeID, VersionNumber)` tuples.
- Each node increments its own counter when it processes a write.
- **Causality**:
  - If All versions in Clock A $\ge$ Clock B, A "descends" from B (no conflict, A is newer).
  - If some are $\ge$ and some are $\le$, the writes are **Concurrent (Conflict)**.
- **Resolution**: The system keeps BOTH versions and asks the app/user to merge them later (e.g., merging two items in a shopping cart).

---

## ✅ Ideal Answer
In distributed architectures, physical time is unreliable for determining order. Vector clocks provide a logical timestamp that tracks causal history, allowing the system to identify exactly when two updates occurred without awareness of each other. This shifts the complexity of conflict resolution to the application layer, ensuring no unintentional data loss occurs during network partitions.

---

## 🏗️ Visual State:
- `Clock A: [Node1: 1, Node2: 2]` 
- `Clock B: [Node1: 2, Node2: 2]` -> B wins.
- `Clock C: [Node1: 1, Node3: 1]` -> Conflict with A!

---

## 🔄 Follow-up Questions
1. **How to prevent Vector Clocks from growing too large?** (Version Pruning — discarding oldest nodes/versions if the list gets too long.)
2. **What is a "Phanom" in Vector Clocks?** (Unresolvable state due to server loss; rare.)
3. **Example of a system using Vector Clocks?** (Riak, early Amazon Dynamo.)
