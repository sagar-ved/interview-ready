---
title: "System Design: Design a Distributed Lock"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: How do you implement a lock across multiple servers? Compare Redis (Redlock) and Zookeeper.

## 🎯 What the interviewer is testing
- Distributed consensus.
- Handling server crashes during lock ownership.
- Identifying SPOFs in lock managers.

---

## 🧠 Deep Explanation

### 1. Redis (Redlock):
- **Mechanism**: Set a key with a TTL (expiration) using the `NX` (Not-Exists) flag.
- **Acquire**: Node A tries to set `lock_key=random_val` on 5 nodes. It wins if it gets 3+ nodes.
- **Fail Case**: If Node A crashes, the lock will eventually time out (TTL).
- **Cons**: Sensitive to time drift between servers. 

### 2. Zookeeper (Ephemeral Nodes):
- **Mechanism**: Use "Sequential Ephemeral Nodes." 
- **Acquire**: Create a node `/lock/guid-n-`. If yours has the lowest sequence number, you have the lock.
- **Fail Case**: If the owner crashes, the ZK session ends and the ephemeral node is **instantly deleted**.
- **Pros**: Highly consistent and reliable. 

---

## ✅ Ideal Answer
Distributed locks solve the "thundering herd" problem across different machines. Redis-based locking is common for high-performance and lightweight tasks where absolute consistency is secondary to speed. Zookeeper is the standard for high-reliability scenarios because its ephemeral nodes provide a native heartbeat—if the owner dies, the lock is guaranteed to be released without waiting for a lease to expire.

---

## 🏗️ Visual State:
- **Redis**: `LOCK -> SET key val NX PX 10000`
- **Zookeeper**: `WATCH /lock/p_001` (Waiting for previous owner to disappear).

---

## 🔄 Follow-up Questions
1. **What is a "Lease"?** (A time-limited lock ownership.)
2. **What if the GC pause is longer than the TTL?** (Node thinks it has the lock, but TTL expired and another node got it. This is why strict locking requires 'fencing tokens'.)
3. **What is a Fencing Token?** (A monotonically increasing ID from the lock server. Database rejects any write with a token lower than the last processed one.)
