---
author: "sagar ved"
title: "Spring: Transaction Propagation"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: What are the different Transaction Propagations in Spring? Which one is the default?

## 🎯 What the interviewer is testing
- Dealing with nested transactions.
- Atomicity across multiple service calls.
- Handling of `REQUIRED` vs `REQUIRES_NEW` edge cases.

---

## 🧠 Deep Explanation

### 1. REQUIRED (Default):
If a transaction exists, join it. Else, create one.
- **Impact**: If Service A calls Service B, and B fails, the whole transaction (A + B) rolls back.

### 2. REQUIRES_NEW:
Always start a new transaction. Suspend the existing one.
- **Impact**: If Service B fails, it rolls back. Service A can still catch the exception and **COMMIT** its own work. Perfect for **Logging** or **Audit** trials.

### 3. MANDATORY:
Join existing, or throw an exception if none exists.

### 4. SUPPORTS:
Join existing, or run without a transaction if none exists.

### 5. NOT_SUPPORTED:
Always run without a transaction. Suspend existing one.

### 6. NEVER:
Throw exception if a transaction exists.

### 7. NESTED:
Creates a "Savepoint." If the inner transaction fails, it rolls back to the savepoint, but the outer can still continue. (Requires JDBC support).

---

## ✅ Ideal Answer
Transaction propagation defines how Spring handles the boundaries between overlapping transactional methods. While `REQUIRED` is the safe default for most business units, `REQUIRES_NEW` is critical when specific sub-tasks—like audit logging—must be persisted regardless of whether the main business transaction succeeds or fails. Understanding these modes is essential for preventing partial data corruption in complex, multi-service workflows.

---

## 🔄 Follow-up Questions
1. **Why does `@Transactional` fail if called from the SAME class?** (Self-invocation bypasses the Spring AOP Proxy. The proxy only intercepts "external" calls.)
2. **What exceptions cause a rollback by default?** (Only `RuntimeException` and `Error`. Checked exceptions do NOT trigger rollback unless you specify `rollbackFor = Exception.class`.)
3. **What is "Dirty Read" vs "Phantom Read" in isolation levels?** (Isolation is about data visibility; Propagation is about transaction boundaries.)
