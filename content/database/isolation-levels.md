---
author: "sagar ved"
title: "Database Isolation Levels and Anomalies"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Your payment service is running at READ COMMITTED isolation. A user initiates two simultaneous refund requests. Both read the same balance, both check eligibility, and both proceed — resulting in a double refund. What isolation level prevents this, and what are the trade-offs?

## 🎯 What the interviewer is testing
- Four ACID isolation levels and their anomalies
- Pessimistic vs Optimistic locking
- Real-world implications in financial systems
- SELECT FOR UPDATE and its performance cost

---

## 🧠 Deep Explanation

### 1. The Four Isolation Levels

| Level | Dirty Read | Non-Repeatable Read | Phantom Read | Performance |
|---|---|---|---|---|
| READ UNCOMMITTED | ✅ Possible | ✅ Possible | ✅ Possible | Fastest |
| READ COMMITTED | ❌ Prevented | ✅ Possible | ✅ Possible | Fast |
| REPEATABLE READ | ❌ Prevented | ❌ Prevented | ✅ Possible (MySQL: ❌) | Moderate |
| SERIALIZABLE | ❌ Prevented | ❌ Prevented | ❌ Prevented | Slowest |

### 2. The Anomalies Explained

- **Dirty Read**: Read uncommitted changes that might be rolled back.
- **Non-Repeatable Read**: Re-reading the same row returns different values (someone updated it).
- **Phantom Read**: Re-running the same query returns different **rows** (someone inserted matching rows).
- **Lost Update**: Two transactions read the same value, both compute a new value, and one overwrites the other's write.

### 3. The Double Refund Problem

```
T1 reads balance = $100, checks $100 >= $50 → proceed refund
T2 reads balance = $100, checks $100 >= $50 → proceed refund
T1 writes balance = $50
T2 writes balance = $50  ← OVERWRITES T1! Double refund!
```

This is the **Lost Update** problem. READ COMMITTED doesn't prevent it.

### 4. Solutions

**Option 1: SERIALIZABLE isolation**
- Full locking; transactions serialize perfectly. Massive throughput drop under load.

**Option 2: SELECT FOR UPDATE (Row-level lock)**
```sql
BEGIN;
SELECT balance FROM accounts WHERE id = ? FOR UPDATE; -- Locks the row
-- Check logic
UPDATE accounts SET balance = balance - 50 WHERE id = ?;
COMMIT;
```

**Option 3: Optimistic Locking (version field)**
```sql
UPDATE accounts SET balance = ?, version = version + 1
WHERE id = ? AND version = ?;  -- Fails if someone else modified since we read
```
If 0 rows affected → retry. Best for low-contention systems.

**Option 4: Database Atomic Operations**
```sql
UPDATE accounts SET balance = balance - 50
WHERE id = ? AND balance >= 50;
```
Single atomic operation — no multi-step race condition.

---

## ✅ Ideal Answer

- **Root cause**: READ COMMITTED allows Lost Updates in multi-step read-then-write patterns.
- **Quick fix**: Use atomic `UPDATE WHERE balance >= amount` — single statement, no race.
- **Better fix**: `SELECT FOR UPDATE` for multi-step business logic (validate → deduct → log).
- **For distributed systems**: Optimistic locking with version fields + retry logic.
- **For financial systems**: Always: audit log, idempotency keys, and test with concurrent load tests.

---

## 💻 SQL Code

```sql
-- ❌ VULNERABLE TO LOST UPDATE (READ COMMITTED)
BEGIN;
SELECT balance FROM accounts WHERE id = 42;  -- Both transactions read $100
-- Application-level check and compute
UPDATE accounts SET balance = 50 WHERE id = 42; -- Both write $50
COMMIT;

-- ✅ Option 1: SELECT FOR UPDATE (Pessimistic Lock)
BEGIN;
SELECT balance FROM accounts WHERE id = 42 FOR UPDATE;  -- Exclusive lock
UPDATE accounts SET balance = balance - 50 WHERE id = 42 AND balance >= 50;
COMMIT;

-- ✅ Option 2: Optimistic Locking  
-- Schema: ADD COLUMN version INT DEFAULT 0
BEGIN;
SELECT balance, version FROM accounts WHERE id = 42;
-- Application: new_balance = balance - 50; if new_balance < 0: reject
UPDATE accounts 
SET balance = ?, version = version + 1
WHERE id = 42 AND version = ?;  -- Will fail if version changed
-- If 0 rows affected: retry
COMMIT;

-- ✅ Option 3: Atomic single statement (simplest for simple deductions)
UPDATE accounts 
SET balance = balance - 50
WHERE id = 42 AND balance >= 50;
-- Check affected rows: 0 means insufficient balance (safe: no negative balance)
```

---

## ⚠️ Common Mistakes
- Using SERIALIZABLE globally — kills throughput for a system doing millions of reads
- Forgetting that MySQL REPEATABLE READ DOES prevent phantom reads via gap locks (unlike standard SQL)
- Not implementing idempotency — retries on timeout cause duplicate processing
- Not understanding that `FOR UPDATE` in MySQL creates a shared IX lock on the table in addition to an X lock on the row

---

## 🔄 Follow-up Questions
1. **What is a "write skew" and which level prevents it?** (Two transactions read overlapping data and make updates that violate a constraint; only SERIALIZABLE or explicit `SELECT FOR UPDATE` prevents it.)
2. **What is MVCC (Multi-Version Concurrency Control)?** (Each row has multiple versions with timestamps; readers don't block writers; each transaction sees a consistent snapshot from its start time.)
3. **How does PostgreSQL differ from MySQL regarding REPEATABLE READ?** (PostgreSQL uses MVCC-based snapshot isolation; MySQL uses gap locks to prevent phantom reads.)
