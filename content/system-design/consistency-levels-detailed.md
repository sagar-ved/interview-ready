---
title: "System Design: Consistency Levels (Strong vs. Eventual)"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: Compare Strong Consistency and Eventual Consistency. When would you sacrifice "consistency" for "availability"?

## 🎯 What the interviewer is testing
- CAP Theorem application.
- Real-world database behavior.
- Business impact of stale data.

---

## 🧠 Deep Explanation

### 1. Strong Consistency:
- **Expectation**: As soon as a write returns "Success," any subsequent read **anywhere** in the world must return that new value.
- **Mechanism**: Usually requires synchronous replication or a leader-based lock.
- **Cost**: High latency and potentially lower availability (if the master is down, you can't write).

### 2. Eventual Consistency:
- **Expectation**: If no new updates happen, all nodes will **eventually** converge to the same value. In the short term, some users might see "stale" data.
- **Mechanism**: Asynchronous replication.
- **Benefit**: Extreme availability and low latency. You can write to ANY node.

### 3. The Compromise (Causal Consistency):
Ensures that if Person A comments on a post, Person B sees the post BEFORE seeing the comment. Order of "cause and effect" is preserved.

---

## ✅ Ideal Answer
The choice between strong and eventual consistency is fundamentally a business decision. While strong consistency is required for financial ledgering and sensitive inventory, eventual consistency is the preferred choice for social media feeds and analytical dashboards where a few seconds of lag is imperceptible to the user but allows the underlying system to remain resilient against global network partitions.

---

## 🏗️ Use Case Table:
| Case | Consistency Mode | Reason |
|---|---|---|
| Bank Transfer | Strong | Prevents double-spending. |
| Facebook Like Count | Eventual | High availability; exact count isn't critical. |
| DNS Records | Eventual | Global scale requires caching. |
| User Profile Edit | Causal | User must see their own changes immediately. |

---

## 🔄 Follow-up Questions
1. **Explain the "P" in CAP.** (Partition Tolerance: When the network is broken, you MUST choose between C [Consistency] or A [Availability].)
2. **What is "Read-your-own-writes"?** (A level of consistency where a specific user is guaranteed to see their own updates, even if the rest of the world sees old data.)
3. **Which databases are known for Eventual Consistency?** (Cassandra, Riak, DynamoDB.)
4. **Which are Strong?** (MySQL/Postgres [in standard setup], Spanner, CockroachDB.)
