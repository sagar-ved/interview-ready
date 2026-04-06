---
author: "sagar ved"
title: "System Design: Design a Distributed Lock"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: How do you implement a Distributed Lock? Compare Redis (Redlock) vs. Zookeeper-based locks.

## 🎯 What the interviewer is testing
- Understanding of synchronization across multiple machines.
- Safety vs Liveness trade-offs in distributed systems.
- Handling of "Clock Skew" and "GC Pauses".

---

## 🧠 Deep Explanation

### 1. Redis (Redlock):
- **Mechanism**: Use `SET lock_key unique_id NX PX 30000`.
- **NX**: Set if not exists.
- **PX**: Expiry in 30s (prevents deadlocks if client crashes).
- **Redlock**: To handle single-point-of-failure, pick $N/2 + 1$ Redis nodes and acquire the lock in each.
- **Problem**: Susceptible to timing issues if a GC pause or network delay occurs after the lock is acquired but before it expires.

### 2. Zookeeper:
- **Mechanism**: Create a **Ephemeral Sequential** node.
- **Logic**: The client with the lowest sequence number holds the lock. Others "watch" the node before theirs.
- **Benefit**: If the client crashes, the session ends and the ephemeral node is **automatically deleted**.
- **Cons**: High overhead; write-heavy for the ZK cluster.

### 3. Fencing Tokens:
To prevent late writes from a client whose lock expired, include a monotonically increasing "Fencing Token" in each request. The resource (database) only accepts writes with a newer token.

---

## ✅ Ideal Answer
For high-performance, best-effort locking, Redis is excellent. For mission-critical consistency where safety is paramount, Zookeeper's ephemeral nodes provide a more reliable guarantee. In all cases, including a "fencing token" is recommended to handle the "wait-then-execute" race condition caused by client-side pauses.

---

## 🏗️ Fencing Token Logic:
```
Client 1: Acquires Lock (Token 33) -> GC Pause
Lock expires...
Client 2: Acquires Lock (Token 34) -> Writes to DB
Client 1: Wakes up -> Tries to write with Token 33 -> DB rejects (34 > 33)
```

---

## 🔄 Follow-up Questions
1. **Can you use SQL for distributed locks?** (Yes, `SELECT FOR UPDATE` or a dedicated lock table, but doesn't scale well.)
2. **What is a "Deadly Embrace" in locks?** (Basically a deadlock.)
3. **Explain "Lease" vs "Lock".** (A lease is a lock that has a built-in time limit for safety.)
