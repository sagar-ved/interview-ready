---
author: "sagar ved"
title: "Database: ACID vs. BASE"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 Question: Compare ACID and BASE properties. Which domains usually favor which, and why?

## 🎯 What the interviewer is testing
- Foundational database theory.
- Understanding the trade-offs of the CAP Theorem.
- Consistency vs Availability choices.

---

## 🧠 Deep Explanation

### 1. ACID (Relational - Oracle, Postgres, MySQL):
- **Atomicity**: All or nothing.
- **Consistency**: DB starts and ends in a valid state.
- **Isolation**: Concurrent transactions don't interfere.
- **Durability**: Committed data is permanent.
- **Domain**: Banking, E-commerce, Inventory (where correctness is non-negotiable).

### 2. BASE (NoSQL - Cassandra, SimpleDB, DynamoDB):
- **Basically Available**: System seems to always work.
- **Soft state**: State may change over time without input (due to eventual consistency).
- **Eventual consistency**: After a period of no updates, all nodes will agree.
- **Domain**: Social Media, Logs, Content Delivery (where availability > being 100% up-to-date for every user).

---

## ✅ Ideal Answer
ACID provides a strong guarantee of data integrity at the cost of scalability and latency under high load or network partitions. BASE embrases eventual consistency to provide global scalability and high availability. Choosing between them depends on whether your application requires "absolute correctness now" or "it will be correct shortly."

---

## 🏗️ CAP Mapping:
- **ACID** usually focuses on **CP** (Consistency/Partition Tolerance).
- **BASE** usually focuses on **AP** (Availability/Partition Tolerance).

---

## 🔄 Follow-up Questions
1. **Can an ACID database scale horizontally?** (Yes, via sharding, but maintaining cross-shard transactions is very slow.)
2. **What is "Strongly Consistent" NoSQL?** (e.g., MongoDB with `majority` read concern; Google Spanner using atomic clocks.)
3. **What is a "Saga Pattern"?** (Used to manage transactions across multiple ACID services.)
