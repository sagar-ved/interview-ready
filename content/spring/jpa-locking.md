---
author: "sagar ved"
title: "JPA: Optimistic vs. Pessimistic Locking"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: Compare Optimistic and Pessimistic locking in Spring Data JPA. When would you choose one over the other?

## 🎯 What the interviewer is testing
- Concurrency control in shared data.
- Deadlock risks vs performance bottlenecks.
- Knowledge of the `@Version` annotation.

---

## 🧠 Deep Explanation

### 1. Optimistic Locking:
- **Concept**: Assume NO conflict will occur. 
- **Mechanism**: Every row has a `@Version` (integer/timestamp). 
- **Logic**: When updating, the DB checks `UPDATE ... WHERE version = 1`. If someone else changed it, the version is now 2, the update fails, and Spring throws `OptimisticLockingFailureException`.
- **Pro**: High Scalability (No DB locks).
- **Con**: Retries are needed if conflicts are frequent.

### 2. Pessimistic Locking:
- **Concept**: Assume conflict WILL occur. 
- **Mechanism**: Use `SELECT ... FOR UPDATE`. The DB places a physical lock on the row.
- **Pro**: Guaranteed consistency (No retries needed).
- **Con**: Poor scalability (Other transactions must wait). Risk of **Deadlocks**.

---

## ✅ Ideal Answer
Optimistic locking is the go-to strategy for high-throughput internet applications where actual data conflicts are rare. It preserves database performance by allowing concurrent reads and only validating the version at the final commit phase. Conversely, Pessimistic locking is reserved for critical, conflict-heavy sections like stock inventory or financial balance updates, where the cost of a physical database lock is an acceptable trade-off for the absolute guarantee of serialized access.

---

## 🏢 Use-case Matrix:
| Case | Best Choice | Why? |
|---|---|---|
| Social Media Posts | Optimistic | Low chance of concurrent edits on same post. |
| Bank Account Transfer | Pessimistic | High risk of double-counting. |
| Product Catalog | Optimistic | Updates are infrequent. |

---

## 🔄 Follow-up Questions
1. **How to handle an Optimistic failure?** (Catch the exception and either inform the user "Another user changed this" or perform an automated retry.)
2. **What if the DB doesn't support `FOR UPDATE`?** (The JPA implementation falls back to emulating the lock or fails.)
3. **Does @Version work for native queries?** (No, unless the native query explicitly updates the version column and checks the count.)
